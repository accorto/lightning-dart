/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/**
 * Object Import Line (table row)
 */
class ObjectImportLine
    extends LTableRow {

  static final Logger _log = new Logger("ObjectImportLine");

  final ObjectImport parent;
  /// data result
  final DataRecord data;
  /// csv source
  final List<String> cellLine;

  /// overwite per column
  final List<String> _overrideList = new List<String>();
  /// table meta data
  DTable _table;
  /// column meta data
  List<DColumn> _columnList;

  /// Import Line
  ObjectImportLine(ObjectImport this.parent, LTable ltable, TableRowElement rowElement,
      int lineNo,
      DataRecord this.data, List<String> this.cellLine)
      : super(ltable, rowElement,
          lineNo, lineNo.toString(), LButton.C_HINT_PARENT, LTableRow.TYPE_BODY, null) {
    // select
    selectCb
      ..onClick.listen(onSelectClick)
      ..attributes[Html0.DATA_ID] = lineNo.toString();
  } // ObjectImportLine


  /// re-create TR line
  void createLine(DTable table, List<DColumn> columnList) {
    _table = table;
    _columnList = columnList;
    display(true);
  }

  /// display line
  void display(bool redisplay){
    if (redisplay) {
      editorList = new List<LEditor>(); // see display
      rowElement.children.clear();
      if (selectCellElement != null)
        rowElement.append(selectCellElement);
      if (actionCellElement != null)
        rowElement.append(actionCellElement);
      _overrideList.clear();
    }
    //
    bool valid = true;
    for (int i = 0; i < _columnList.length; i++) {
      String cellText = "";
      if (i < cellLine.length)
        cellText = cellLine[i];
      //
      DataColumn dataColumn = null;
      LEditor editor = null;
      String name = null;
      DColumn col = _columnList[i];
      if (col != null) {
        dataColumn = new DataColumn(_table, col, null, null);
        editor = EditorUtil.createFromColumn("", dataColumn, true,
            idPrefix:rowElement.id, data: data)
          ..editorChange = onEditorChange
          ..onFocus.listen(onEditorFocus); // close other dropdowns
        name = col.name;
        if (!checkLineValue(editor, cellText)) {
          valid = false;
        }
      }
      // cell
      DivElement content = new DivElement()
        ..classes.add(LText.C_TRUNCATE)
        ..text = cellText;
      LTableCell cell = addCell(content,
          name, null, null, null, dataColumn, fieldEdit:false, addStatistics: false);
      if (editor != null) {
        cell.cellElement
        //  ..append(new BRElement())
          ..append(editor.element);
      }
      editorList.add(editor);
      _overrideList.add(null);
    } // cols
    data.selected = valid;
    selectCb.checked = valid;
  } // createLine

  /// check line - select only if valid
  void onSelectClick(MouseEvent evt) {
    bool valid = checkLine();
    _log.config("onSelectClick ${rowIndex} valid=${valid}");
    if (selectCb.checked) {
      if (valid)
        data.selected = true;
      else
        selectCb.checked = false;
    } else {
      data.selected = false;
    }
    parent.diagnostics();
  } // onClickSelect

  /// check line
  bool checkLine() {
    if (data.isEmpty) {
      return false;
    }
    bool valid = true;
    for (int i = 0; i < _columnList.length; i++) {
      String cellText = "";
      if (i < cellLine.length) {
        cellText = cellLine[i];
      }
      DColumn col = _columnList[i];
      if (col != null) {
        LEditor ed = editorList[i];
        String overwrite = _overrideList[i];
        if (overwrite == null && ed != null) {
          if (!checkLineValue(ed, cellText)) {
            valid = false;
          }
        }
      }
    } // cols
    return valid;
  } // checkLine

  /// check line value
  bool checkLineValue(LEditor ed, String cellText) {
    ed.value = cellText;
    bool valid = ed.setValueSynonym(cellText); // might be null
    if (ed.value != cellText && ed.doValidate()) {
      ed.setCustomValidity("value does not match");
      if (!ed.doValidate())
        valid = false;
    }
    if (valid == null)
      return true;
    return valid;
  }

  /// editor change - mark overwrite
  void onEditorChange(String name, String newValue, DEntry entry, var details) {
    for (int i = 0; i < editorList.length; i++) {
      LEditor ed = editorList[i];
      if (ed != null && name == ed.name) {
        _log.fine("onEditorChange ${name} ${newValue}");
        _overrideList[i] = newValue;
        ed.setCustomValidity("");
        ed.doValidate();
        return;
      }
    }
    _log.warning("onEditorChange ${name} ${newValue} NotFound");
  }

  String toString() {
    return "ObjectImportLine@${rowElement.id}[${data.recordId} selected=${data.selected}]";
  }

} // ObjectImportLine
