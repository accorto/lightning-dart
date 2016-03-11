/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/**
 * Import
 * TODO line editor dropdown check
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
  final TableElement _table = new TableElement()
    ..classes.addAll([LTable.C_TABLE, LTable.C_TABLE__BORDERED, LTable.C_TABLE__FIXED_LAYOUT]);
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
    DivElement tableDiv = new DivElement()
      ..classes.add(LScrollable.C_SCROLLABLE__X)
      ..style.maxHeight = "600px"
      ..style.overflowY = "auto"
      ..append(_table);
    _modal.append(tableDiv);
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
    _table.children.clear();
    _headerColumnPicks.clear();
    _headerColumnList.clear();
    // header row
    _headTr = _table.createTHead().addRow()
      ..classes.add(LText.C_TEXT_HEADING__LABEL);
    // select
    _selectAll = new LCheckbox("selectAll")
      ..title = "Check Lines for Import"
      ..element.onClick.listen(onHeaderSelectClick);
    Element th = new Element.th()
      ..classes.add(LTable.C_CELL_SHRINK)
      ..append(_selectAll.element);
    _headTr.append(th);
    // columns
    for (String headingCol in _csv.headingColumns) {
      th = _createTh(headingCol)
        ..append(new BRElement())
        ..append(_createHeaderColumnPick(headingCol).element)
        ..append(new BRElement());
      _headTr.append(th); // see onClickAddColumn
    }
    _headColumnButton();
    diagnostics();
    //
    _tbody = _table.createTBody();
    _createTableLines(true);
  } // createTable
  LCheckbox _selectAll;
  TableRowElement _headTr;
  TableSectionElement _tbody;

  /// create header cell
  Element _createTh(String headingCol) {
    InputElement resizeInput = new InputElement(type: EditorI.TYPE_RANGE)
    //..id =
      ..classes.add(LText.C_ASSISTIVE_TEXT)
      ..min = "20"
      ..max = "500";
    SpanElement resizeHandle = new SpanElement()
      ..classes.add(LTable.C_RESIZABLE__HANDLE)
      ..append(new SpanElement()..classes.add(LTable.C_RESIZABLE__DIVIDER));
    DivElement resizeDiv1 = new DivElement()
      ..classes.addAll([LGrid.C_SHRINK_NONE, LTable.C_RESIZABLE])
      ..append(new LabelElement()
        ..classes.add(LText.C_ASSISTIVE_TEXT)
      //..htmlFor =
        ..text = "click and drag to resize")
      ..append(resizeInput)
      ..append(resizeHandle);
    DivElement resizeDiv = new DivElement()
      ..classes.add(LText.C_TRUNCATE)
      ..appendText(headingCol)
      ..append(resizeDiv1);

    Element th = new Element.th()
      ..classes.add(LTable.C_IS_RESIZABLE)
      ..attributes["scope"] = "col"
      ..append(resizeDiv);
    int colWidth = 200;
    resizeInput.value = colWidth.toString();
    th.style.width = "${colWidth}px";
    resizeInput.onInput.listen((Event evt) {
      th.style.width = "${resizeInput.value}px";
    });
    return th;
  } // createTh

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
    Element th = new Element.th()
      ..appendHtml("&nbsp;")
      ..append(_addColumnButton.element);
    _headTr.append(th);
  }

  /// add a new column
  void onAddColumnClick(Event evt) {
    _headTr.children.last.remove();
    Element th = _createTh("-")
      ..append(new BRElement())
      ..append(_createHeaderColumnPick("-").element)
      ..append(new BRElement());
    _headTr.append(th);
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
    _tbody.children.clear();
    feedbackClear();
    int start = _firstLineIsHeading ? 1 : 0;
    if (reset) {
      lineList.clear();
      for (int lineNo = start; lineNo < _csv.cells.length; lineNo++) {
        DataRecord data = new DataRecord(datasource.tableDirect, null)
          ..newRecord(null, rowNo: lineNo);
        lineList.add(new ObjectImportLine(this, data, _csv.cells[lineNo], lineNo));
      }
    }
    // for each line
    for (ObjectImportLine line in lineList) {
      line.createLine(_tbody.addRow(), datasource.tableDirect, _headerColumnList);
    } // lines
    diagnostics();
  } // createTableLines
  final List<ObjectImportLine> lineList = new List<ObjectImportLine>();


  /// check all lines
  void onHeaderSelectClick(MouseEvent evt) {
    _log.config("onHeaderSelectClick");
    for (ObjectImportLine line in lineList) {
      line.checkLine();
    }
    _selectAll.checked = false;
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
    if (lineList.isNotEmpty) {
      int selected = 0;
      for (ObjectImportLine line in lineList) {
        if (line.data.selected)
          selected++; // valid
      }
      rowInfo = "${selected} rows selected";
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
