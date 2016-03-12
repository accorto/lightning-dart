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

    _modal.addFooterButtons(saveLabelOverride: "Import", hideOnSave: false)
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
    _addColumnButton = new LButton.neutral("addColumn", "Add Column")
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
  String _csvInfo = "Select csv file";

  /// create table
  void _createTable() {
    _headerColumnPicks.clear();
    _headerColumnList.clear();
    _table.clear();

    // header row
    _headerRow = _table.addHeadRow(false);
    // header columns
    for (int i = 0; i < _csv.headingColumns.length; i++) {
      String headingCol = _csv.headingColumns[i];
      LTableHeaderCell cell = _headerRow.addHeaderCell(i.toString(), headingCol);
      cell.cellElement.append(new BRElement());
      cell.cellElement.append(_createHeaderColumnPick(headingCol).element);
      cell.cellElement.append(new BRElement());
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
      ..placeholder = "Map to Column"
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
    _headerRow.rowElement.children.last.remove();

    LTableHeaderCell cell = _headerRow.addHeaderCell("a", "-");
    cell.cellElement.append(new BRElement());
    cell.cellElement.append(_createHeaderColumnPick("-").element);
    cell.cellElement.append(new BRElement());

    _headColumnButton();
    _createTableLines(false);
    diagnostics();
  } // onClickAddColumn

  /// header editor change - create editors
  void onHeaderEditorChange(String name, String newValue, DEntry entry, var details) {
    String no = name.replaceAll("col-", "");
    int index = int.parse(no, onError: (String s){
      return null;
    });
    if (index == null) {
      _log.config("onEditorChange ${name} ${newValue} Index NotFound");
      return;
    }
    if (index < 0 || index+1 >= _headerColumnList.length) {
      _log.config("onEditorChange ${name} ${newValue} index=${index} error max=${_headerColumnList.length}");
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
      _log.config("onEditorChange ${name} ${newValue} Column NotFound");
      return;
    }
    for (int i = 0; i < _headerColumnList.length; i++) {
      DColumn col = _headerColumnList[i];
      if (col != null && col.name == column.name) {
        feedbackSet(new LAlert.warning(label: "${column.label}: already in column #${i+1}"));
        return;
      }
    }
    _log.config("onEditorChange ${name} ${newValue}");
    _headerColumnList[index] = column;
    _createTableLines(false);
  } // onEditorChange

  /// Header Editor Focused - close other editor dropdowns
  void onHeaderEditorFocus(Event evt) {
    String id = "";
    if (evt != null) {
      Element target = evt.target;
      id = target.id;
    }
    for (LEditor ed in _headerColumnPicks) {
      // _log.fine("onEditorFocus ${id} - ${ed.id}");
      if (id != ed.id) {
        ed.showDropdown = false;
      }
    }
  } // onEditorFocus

  /// re-create lines
  void _createTableLines(bool reset) {
    _table.clearRecords();

    feedbackClear();
    int start = _firstLineIsHeading ? 1 : 0;
    if (reset) {
      _table.clearBody();
      for (int lineNo = start; lineNo < _csv.cells.length; lineNo++) {
        DataRecord data = new DataRecord(datasource.tableDirect, null)
          ..newRecord(null, rowNo: lineNo);
        _table.addBodyRow(row: new ObjectImportLine(this, _table, _table.createBodyRow(),
            lineNo, data, _csv.cells[lineNo]));
      }
    }
    // for each line
    for (LTableRow line in _table.i_bodyRows) {
      if (line is ObjectImportLine)
        line.createLine(datasource.tableDirect, _headerColumnList);
    } // lines
    diagnostics();
  } // createTableLines


  /// check all lines
  void onHeaderSelectClick(MouseEvent evt) {
    _log.config("onHeaderSelectClick");
    for (LTableRow line in _table.i_bodyRows) {
      if (line is ObjectImportLine)
        line.checkLine();
    }
    //_selectAll.checked = false;
    diagnostics();
  }

  /// diagnostics
  void diagnostics() {
    String mapInfo = "Map columns!";
    int mapCount = 0;
    for (DColumn col in _headerColumnList) {
      if (col != null)
        mapCount++;
    }
    if (mapCount > 0) {
      mapInfo = "${mapCount} columns mapped";
      int mandatoryMissing = 0;
      for (DColumn col in _columnListAll) {
        if (col.isCalculated || col.isReadOnly)
          continue;
        if (col.isMandatory) {
          if (!_headerColumnList.contains(col)) {
            feedbackAdd(new LAlert.error(label: "Mandatory Column '${col.label}' not mapped"));
            mandatoryMissing++;
          }
        }
      }
      if (mandatoryMissing > 0)
        mapInfo += " - ${mandatoryMissing} mandatory columns missing";
    }

    // row
    String rowInfo = "Check values";
    if (_table.i_bodyRows.isNotEmpty) {
      for (LTableRow line in _table.i_bodyRows) {
        int selected = 0;
        if (line is ObjectImportLine) {
          if (line.data.selected)
            selected++; // valid

        }
        rowInfo = "${selected} rows selected for import";
      }
    }

    _todo.children.clear();
    _todo
      ..append(new LIElement()..text = _csvInfo)
      ..append(new LIElement()..text = mapInfo)
      ..append(new LIElement()..text = rowInfo);
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

  void onSaveClick(MouseEvent evt) {
    _log.info("onSaveClick");
    // TODO save import
  }


  static String objectImportTitle() => Intl.message("Import", name: "objectImportTitle");
  static String objectImportFileLabel() => Intl.message("Select a file to import", name: "objectImportFileLabel");

} // ObjectImport
