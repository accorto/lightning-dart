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

  static final Logger _log = new Logger("ObjectImport");

  final LModal _modal = new LModal("imp")
    ..large = true;
  LInputFile _fileInput;
  /// the table
  final TableElement _table = new TableElement()
    ..classes.addAll([LTable.C_TABLE, LTable.C_TABLE__BORDERED, LTable.C_TABLE__FIXED_LAYOUT]);
  final DivElement _feedback = new DivElement()
    ..classes.addAll([LMargin.C_TOP__MEDIUM, LScrollable.C_SCROLLABLE__Y])
    ..style.maxHeight = "150px";

  final Datasource datasource;
  List<DColumn> _columnListAll;
  final List<DOption> _optionList = new List<DOption>();
  LButton _addColumnButton;

  /// the pick list per column
  final List<LLookup> _columnPicks = new List<LLookup>();
  /// the selected column from pick list
  final List<DColumn> _columnList = new List<DColumn>();

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
      ..onClick.listen(onClickAddColumn);
    _diagnostics();
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
    _columnPicks.clear();
    _columnList.clear();
    // header row
    _headTr = _table.createTHead().addRow()
      ..classes.add(LText.C_TEXT_HEADING__LABEL);
    // select
    LCheckbox selectAll = new LCheckbox("selectAll")
      ..title = "Select All Toggle";
    Element th = new Element.th()
      ..classes.add(LTable.C_CELL_SHRINK)
      ..append(selectAll.element);
    _headTr.append(th);
    // columns
    for (String headingCol in _csv.headingColumns) {
      th = _createTh(headingCol)
        ..append(new BRElement())
        ..append(_createColPick(headingCol).element)
        ..append(new BRElement());
      _headTr.append(th); // see onClickAddColumn
    }
    _headColumnButton();
    _diagnostics();
    //
    _tbody = _table.createTBody();
    _createTableLines(true);
  }
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
    int colWidth = 180;
    resizeInput.value = colWidth.toString();
    th.style.width = "${colWidth}px";
    resizeInput.onInput.listen((Event evt) {
      th.style.width = "${resizeInput.value}px";
    });
    return th;
  } // createTh

  // create Lookup Editor
  LEditor _createColPick(String headingCol) {
    int colNo = _columnPicks.length;
    LLookup pl = new LLookup("col-${colNo}", idPrefix: id, inGrid: true)
      ..required = false
      ..placeholder = "Map to Column"
      ..dOptionList = _optionList
      ..editorChange = onEditorChange;
    //
    DColumn column = null;
    for (DColumn col in _columnListAll) {
      if (col.name == headingCol || col.label == headingCol
        || (col.hasExternalKey() && col.externalKey == headingCol)) {
        column = col;
        pl.value = col.name;
        break;
      }
    }
    _columnPicks.add(pl);
    _columnList.add(column);
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
  void onClickAddColumn(Event evt) {
    _headTr.children.last.remove();
    Element th = _createTh("-")
      ..append(new BRElement())
      ..append(_createColPick("-").element)
      ..append(new BRElement());
    _headTr.append(th);
    _headColumnButton();
    _createTableLines(false);
    _diagnostics();
  } // onClickAddColumn

  /// editor change
  void onEditorChange(String name, String newValue, DEntry entry, var details) {
    String no = name.replaceAll("col-", "");
    int index = int.parse(no, onError: (String s){
      return null;
    });
    if (index == null) {
      _log.config("onEditorChange ${name} ${newValue} Index NotFound");
      return;
    }
    if (index < 0 || index+1 >= _columnList.length) {
      _log.config("onEditorChange ${name} ${newValue} index=${index} error max=${_columnList.length}");
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
    for (int i = 0; i < _columnList.length; i++) {
      DColumn col = _columnList[i];
      if (col != null && col.name == column.name) {
        feedbackSet(new LAlert.warning(label: "${column.label}: already in column #${i+1}"));
        return;
      }
    }
    _log.config("onEditorChange ${name} ${newValue}");
    _columnList[index] = column;
    _createTableLines(false);
  } // onEditorChange

  /// re-create lines
  void _createTableLines(bool reset) {
    _tbody.children.clear();
    feedbackClear();
    if (reset) {
      _dataList.clear();
      for (int i = 1; i < _csv.cells.length; i++) {
        DataRecord data = new DataRecord(datasource.tableDirect, null)
          ..newRecord(null)
          ..selected = true;
        _dataList.add(data);
      }
    }

    for (int i = 1; i < _csv.cells.length; i++) {
      DataRecord data = _dataList[i-1];
      List<String> cellLine = _csv.cells[i];
      TableRowElement tr = _tbody.addRow()
        ..classes.add(LTable.C_HINT_PARENT)
        ..attributes[Html0.DATA_ID] = i.toString();
      // select
      LCheckbox cb = new LCheckbox("selected", inGrid: true)
        ..value = data.selected.toString();
      cb.input.onClick.listen((Event evt) {
          data.selected = cb.input.checked;
        });
      tr.addCell()
        ..append(cb.element);
      // columns
      for (int i = 0; i < _columnList.length; i++) {
        String cellText = "";
        if (i < cellLine.length)
          cellText = cellLine[i];
        //
        TableCellElement td = tr.addCell()
          ..classes.add(LText.C_TRUNCATE)
          ..append(new SpanElement()
              ..text = cellText)
          ..append(new BRElement());
        DColumn col = _columnList[i];
        if (col != null) {
          DataColumn dataColumn = new DataColumn(datasource.tableDirect, col, null, null);
          LEditor ed = EditorUtil.createFromColumn("", dataColumn, true, data: data);
          td.append(ed.element);
          ed.value = cellText;
          if (ed.value != cellText && ed.doValidate()) {
            ed.setCustomValidity("value does not match");
            ed.doValidate();
          }
        }
      } // cols
      tr.addCell(); // addColumn
    } // lines
    _diagnostics();
  } // createTableLines
  List<DataRecord> _dataList = new List<DataRecord>();

  /// diagnostics
  void _diagnostics() {
    String mapInfo = "Map columns!";
    int mapCount = 0;
    for (DColumn col in _columnList) {
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
          if (!_columnList.contains(col)) {
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
    if (_dataList.isNotEmpty) {
      int selected = 0;
      for (DataRecord data in _dataList) {
        if (data.selected)
          selected++;
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

  }



  static String objectImportTitle() => Intl.message("Import", name: "objectImportTitle");
  static String objectImportFileLabel() => Intl.message("Select a file to import", name: "objectImportFileLabel");

} // ObjectImport
