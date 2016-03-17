/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/**
 * Import
 */
class ObjectImport {

  static const String DOC = "https://support.accorto.com/support/solutions/articles/1000227178-import";

  static final Logger _log = new Logger("ObjectImport");

  /// Modal
  final LModal _modal = new LModal("imp")
    ..large = true
    ..helpHref = DOC;
  /// File Editor
  LInputFile _fileInput;
  /// the table
  final LTable _table = new LTable("imp", rowSelect: true)
    ..bordered = true
    ..setResponsiveScroll(600);
  final DivElement _feedback = new DivElement()
    ..classes.addAll([LMargin.C_TOP__MEDIUM, LScrollable.C_SCROLLABLE__Y])
    ..style.maxHeight = "150px";

  /// data source
  final Datasource datasource;
  /// all columns
  List<DColumn> _columnListAll;
  /// column options
  final List<DOption> _optionList = new List<DOption>();
  /// add column button
  LButton _addColumnButton;

  /// first line is heading
  bool _firstLineIsHeading = true;

  /// the pick list per column
  final List<LLookup> _headerColumnPicks = new List<LLookup>();
  /// the selected column from pick list
  final List<DColumn> _headerColumnList = new List<DColumn>();

  OListElement _todo = new OListElement()
    ..classes.add(LGrid.C_COL__PADDED)
    ..classes.add(LList.C_LIST__ORDERED);
  /// Import Button
  LButton _buttonImport;


  /// Import
  ObjectImport(Datasource this.datasource) {
    _modal.setHeader("${objectImportTitle()}: ${datasource.tableDirect.label}",
        icon: new LIconUtility(LIconUtility.UPLOAD));

    _fileInput = new LInputFile("fn", idPrefix: id)
      ..label = objectImportFileLabel()
      ..accept = ".csv, text/plain"
      ..inputFileResult = onInputFileResult;
    DivElement fileDiv = new DivElement()
      ..classes.addAll([LGrid.C_GRID, LGrid.C_WRAP])
      ..append(_fileInput.element)
      ..append(_todo);
    _modal.append(fileDiv);
    // table
    _modal.append(_table.element);
    _modal.append(_feedback);

    _buttonImport =_modal.addFooterButtons(saveLabelOverride: objectImportButton(), hideOnSave: false)
      ..onClick.listen(onSaveClick);

    // column list
    _columnListAll = datasource.tableDirect.columnList;
    for (DColumn column in _columnListAll) {
      if (column.isCalculated || column.isReadOnly) {
        continue;
      }
      DOption option = new DOption()
          ..value = column.name
          ..label = column.label
          ..iconImage = DataTypeUtil.getIconImage(column.dataType);
      _optionList.add(option);
    }
    _optionList.sort(OptionUtil.compareLabel);
    //
    _addColumnButton = new LButton.neutral("addColumn", objectImportAddColumn())
      ..onClick.listen(onAddColumnClick);
    diagnostics();
  } // ObjectImport

  String get id => _modal.id;

  void show() {
    _modal.showModal();
  }

  /// file loaded
  void onInputFileResult(List<int> result, String name, int size) {
    _csv = new FileCsv.data(result, name);
    double sizeK = size / 1024;
    _csvInfo = "File: ${name} ${sizeK.toStringAsFixed(1)}k, lines=${_csv.lines.length}";
    if (_csv.linesEmpty > 0)
      _csvInfo += "(empty=${_csv.linesEmpty})";
    _csvInfo += ", columns=${_csv.minColCount}";
    if (_csv.minColCount != _csv.maxColCount)
      _csvInfo += "-${_csv.maxColCount}";
    _fileInput.hint = "";
    //_csv.dump();
    //
    _createTable();
  } // onInputFileResult
  FileCsv _csv;
  String _csvInfo = objectImportSelectCsv();

  /// create table
  void _createTable() {
    _headerColumnPicks.clear();
    _headerColumnList.clear();
    _table.clear();

    // header row
    _headerRow = _table.addHeadRow(false); // no sort
    _table.tableHeadSelectClicked = onTableHeadSelectClicked;
    // header columns
    for (int i = 0; i < _csv.headingColumns.length; i++) {
      String headingCol = _csv.headingColumns[i];
      LTableHeaderCell cell = _headerRow.addHeaderCell(i.toString(), headingCol);
      cell.cellElement.append(new BRElement());
      cell.cellElement.append(_createHeaderColumnPick(headingCol).element);
    }
    _headColumnButton();
    diagnostics();
    //
    _createTableLines(true);
  } // createTable
  LTableHeaderRow _headerRow;

  // create Column Lookup Editor
  LEditor _createHeaderColumnPick(String headingCol) {
    int colNo = _headerColumnPicks.length;
    LLookup pl = new LLookup("col-${colNo}", idPrefix: id, inGrid: true)
      ..required = false
      ..placeholder = objectImportMap()
      ..dOptionList = _optionList
      ..editorChange = onHeaderEditorChange
      ..onFocus.listen(onHeaderEditorFocus);
    for (LLookupItem item in pl.lookupItemList) {
      item.a.style // fix header text
          ..textTransform = "initial"
          ..letterSpacing = "initial";
    }

    // set value if name, label, extKey matches
    DColumn column = null;
    for (DColumn col in _columnListAll) {
      if (col.name == headingCol || col.label == headingCol
        || (col.hasExternalKey() && col.externalKey == headingCol)) {
        column = col;
        pl.value = col.name;
        break;
      }
    }
    _headerColumnPicks.add(pl);
    _headerColumnList.add(column);
    return pl;
  } // createColPick

  /// add column button to head row
  void _headColumnButton() {
    LTableHeaderCell cell = _headerRow.addHeaderCell("add", "-");
    cell.cellElement.append(new BRElement());
    cell.cellElement.append(_addColumnButton.element);
  }

  /// add a new column
  void onAddColumnClick(Event evt) {
    _log.fine("onAddColumnClick");
    _headerRow.rowElement.children.last.remove();

    LTableHeaderCell cell = _headerRow.addHeaderCell("a", "-");
    cell.cellElement.append(new BRElement());
    cell.cellElement.append(_createHeaderColumnPick("-").element);

    _headColumnButton(); // re-create
    _createTableLines(true);
    diagnostics();
  } // onClickAddColumn

  /// header editor change - create editors
  void onHeaderEditorChange(String name, String newValue, DEntry entry, var details) {
    String no = name.replaceAll("col-", "");
    int index = int.parse(no, onError: (String s){
      return null;
    });
    if (index == null) {
      _log.config("onHeaderEditorChange ${name} ${newValue} Index NotFound");
      return;
    }
    if (index < 0 || index >= _headerColumnList.length) {
      _log.config("onHeaderEditorChange ${name} ${newValue} index=${index} error max=${_headerColumnList.length}");
      return;
    }
    DColumn column = null;
    for (DColumn col in _columnListAll) {
      if (col.name == newValue) {
        column = col;
        break;
      }
    }
    if (column == null) {
      _log.config("onHeaderEditorChange ${name} ${newValue} Column NotFound");
      return;
    }
    for (int i = 0; i < _headerColumnList.length; i++) {
      DColumn col = _headerColumnList[i];
      if (col != null && col.name == column.name) {
        feedbackSet(new LAlert.warning(label: objectImportColumnAlreadyMapped(column.label, i+1)));
        return;
      }
    }
    _log.config("onHeaderEditorChange ${name} ${newValue}");
    _headerColumnList[index] = column;
    _createTableLines(true);
  } // onEditorChange

  /// Header Editor Focused - close other editor dropdowns
  void onHeaderEditorFocus(Event evt) {
    String id = "";
    if (evt != null) {
      Element target = evt.target;
      id = target.id;
    }
    for (LEditor ed in _headerColumnPicks) {
      if (id != ed.id) {
        ed.showDropdown = false;
      }
    }
  } // onEditorFocus

  /// remove close header dropdowms
  void _removeHeaderDropdowns() {
    for (LEditor ed in _headerColumnPicks) {
        ed.showDropdown = false;
    }
  }

  /// re-create lines
  void _createTableLines(bool reset) {
    feedbackClear();
    int start = _firstLineIsHeading ? 1 : 0;
    if (reset) {
      _table.clearBody();
      for (int lineNo = start; lineNo < _csv.cells.length; lineNo++) {
        DataRecord data = new DataRecord(datasource.tableDirect, null)
          ..newRecord(null, rowNo: lineNo);
        ObjectImportLine line = new ObjectImportLine(this, _table, _table.createBodyRow(),
            lineNo, data, _csv.cells[lineNo]);
        line.createLine(datasource.tableDirect, _headerColumnList); // display
        _table.addBodyRow(row: line);
      }
    } else {
      for (LTableRow line in _table.tbodyRows) {
        if (line is ObjectImportLine) {
          line.createLine(datasource.tableDirect, _headerColumnList); // display
        }
      } // lines
    }
    _table.fixWidth(null);
    diagnostics();
  } // createTableLines


  bool onTableHeadSelectClicked(bool newValue) {
    _log.config("onTableHeadSelectClicked ${newValue}");
    for (LTableRow line in _table.tbodyRows) {
      if (line is ObjectImportLine) {
        String error = line.checkLine();
        if (error != null && error.isNotEmpty)
          line.selected = false;
      }
    }
    PageSimple.instance.setStatusInfo(diagnostics());
    return null; // no change
  }

  /// diagnostics
  String diagnostics() {
    String mapInfo = objectImportMapColumns();

    int mapCount = 0;
    String duplicateInfo = null;
    Set<String> columnNameSet = new Set<String>();
    for (DColumn col in _headerColumnList) {
      if (col != null) {
        mapCount++;
        String columnName = col.name;
        if (columnNameSet.contains(columnName)) {
          if (duplicateInfo == null)
            duplicateInfo = "${objectImportDuplicate()}: ${col.label}";
          else
            duplicateInfo += ", ${col.label}";
        }
        columnNameSet.add(columnName);
      }
    }

    int missingCount = -1;
    if (mapCount > 0) {
      mapInfo = objectImportColumnsMapped(mapCount);
      // mandatory missing
      missingCount = 0;
      for (DColumn col in _columnListAll) {
        if (col.isCalculated || col.isReadOnly)
          continue;
        if (col.isMandatory) {
          if (!_headerColumnList.contains(col)) {
            feedbackAdd(new LAlert.error(label: objectImportColumnNotMapped(col.label)));
            missingCount++;
          }
        }
      }
      if (missingCount > 0)
        mapInfo += " - ${objectImportMandatoryMissing(missingCount)}";
    }

    // row
    String rowInfo = objectImportCheckValues();
    int selectedCount = 0;
    for (LTableRow line in _table.tbodyRows) {
      if (line is ObjectImportLine) {
        if (line.data.selected)
          selectedCount++; // valid
      }
    }
    if (_table.tbodyRows.isNotEmpty)
      rowInfo = objectImportRowsSelected(selectedCount);
    _buttonImport.disabled = selectedCount == 0 || missingCount != 0;

    _todo.children.clear();
    _todo
      ..append(new LIElement()..text = _csvInfo)
      ..append(new LIElement()..text = mapInfo)
      ..append(new LIElement()..text = rowInfo);
    return rowInfo;
  } // diagnostics

  void feedbackClear() {
    _feedback.children.clear();
  }
  void feedbackSet(LAlert alert) {
    _feedback.children.clear();
    _feedback.append(alert.element);
  }
  void feedbackAdd(LAlert alert) {
    _feedback.append(alert.element);
  }

  /**
   * Import
   */
  void onSaveClick(MouseEvent evt) {
    List<DRecord> records = new List<DRecord>();
    for (LTableRow line in _table.tbodyRows) {
      if (line is ObjectImportLine) {
        if (line.data.selected)
          records.add(line.data.record);
      }
    }
    _log.info("onSaveClick ${records.length}");
    if (records.isEmpty)
      return;

    // save import
    _modal.busy = true;
    datasource.saveAll(records)
    .then((DataResponse response){
      _modal.busy = false;
      if (response.response.isSuccess)
        _modal.show = false;
    })
    .catchError((error, stackTrace){
      _modal.busy = false;
    });
  } // onSaveClick


  static String objectImportTitle() => Intl.message("Import", name: "objectImportTitle");
  static String objectImportButton() => Intl.message("Import", name: "objectImportButton");
  static String objectImportFileLabel() => Intl.message("Select a file to import", name: "objectImportFileLabel");
  static String objectImportAddColumn() => Intl.message("Add Column", name: "objectImportAddColumn");
  static String objectImportSelectCsv() => Intl.message("Select cvs file", name: "objectImportSelectCsv");

  static String objectImportMap() => Intl.message("Map to column", name: "objectImportMap");

  static String objectImportColumnAlreadyMapped(String columnName, int columnNumber) => Intl.message("${columnName} already in column ${columnNumber}",
      name: "objectImportColumnAlreadyMapped", args:[columnName, columnNumber]);

  static String objectImportMapColumns() => Intl.message("Map columns!", name: "objectImportMapColumns");
  static String objectImportDuplicate() => Intl.message("Duplicate", name: "objectImportDuplicate");

  static String objectImportColumnsMapped(int mapCount) => Intl.message("${mapCount} columns mapped",
      name: "objectImportColumnsMapped", args:[mapCount]);
  static String objectImportColumnNotMapped(String columnName) => Intl.message("$columnName is mandatory and not mapped",
      name: "objectImportColumnNotMapped", args:[columnName]);
  static String objectImportMandatoryMissing(int missingCount) => Intl.message("$missingCount mandatory columns missing",
      name: "objectImportMandatoryMissing", args:[missingCount]);

  static String objectImportCheckValues() => Intl.message("Check values", name: "objectImportCheckValues");
  static String objectImportRowsSelected(int rowCount) => Intl.message("$rowCount selected for import",
      name: "objectImportRowsSelected", args:[rowCount]);


} // ObjectImport
