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
      ..attributes[Html0.DATA_ID] = lineNo.toString();
  } // ObjectImportLine


  /// re-create TR line
  void createLine(DTable table, List<DColumn> columnList) {
    _table = table;
    _columnList = columnList;
    display(true);
  }

  /**
   * display line
   * - create editors
   */
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
    int editorCount = 0;
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
          ..readOnly = false
          ..editorChange = onEditorChange
          ..onFocus.listen(onEditorFocus); // close other dropdowns
        name = col.name;
        if (!checkLineValue(editor, cellText)) {
          valid = false;
        }
        editorCount++;
      }
      // cell
      DivElement content = new DivElement()
        ..classes.add(LText.C_TRUNCATE)
        ..text = cellText;
      if (cellText == null || cellText.isEmpty) {
        content.setInnerHtml("&nbsp;", treeSanitizer: NodeTreeSanitizer.trusted);
      }
      LTableCell cell = addCell(content,
          name, null, null, null, dataColumn, fieldEdit:false, addStatistics: false);
      if (editor != null) {
        cell.cellElement
          ..append(editor.element);
      }
      editorList.add(editor);
      _overrideList.add(null);
    } // cols
    data.selected = valid && editorCount > 0;
    selectCb.checked = valid && editorCount > 0;
    //display_hideColumns();
  } // createLine

  /// focus - close other dropdowns
  void onEditorFocus(Event evt) {
    super.onEditorFocus(evt);
    parent._removeHeaderDropdowns();
  }

  /// check line - select only if valid
  void onSelectClick(MouseEvent evt) {
    String error = checkLine();
    _log.config("onSelectClick ${rowIndex} error=${error}");
    if (selectCb.checked) {
      if (error == null) {
        data.selected = true;
      } else {
        selectCb.checked = false;
        PageSimple.instance.setStatusWarning("${objectImportLineLine()} ${rowIndex}: ${error}");
      }
    } else {
      data.selected = false;
    }
    parent.diagnostics();
  } // onClickSelect

  /// check line - return error message or null
  String checkLine() {
    if (data.isEmpty) {
      return "Record empty"; // unlikely
    }
    String error = null;
    int columnCount = 0;
    for (int i = 0; i < _columnList.length; i++) {
      String cellText = "";
      if (i < cellLine.length) {
        cellText = cellLine[i];
      }
      DColumn col = _columnList[i];
      if (col != null) {
        columnCount++;
        LEditor ed = editorList[i];
        String overwrite = _overrideList[i];
        if (overwrite == null && ed != null) {
          if (!checkLineValue(ed, cellText)) {
            if (error == null)
              error = "${objectImportLineCheck()}: ${col.label}";
            else
              error += ", ${col.label}";
          }
        }
      }
    } // cols
    if (columnCount == 0) {
      return objectImportLineEmpty();
    }
    return error;
  } // checkLine

  /// check line column value
  bool checkLineValue(LEditor ed, String cellText) {
    bool valid = ed.setValueSynonym(cellText); // might be null
    if (valid == null) {
      ed.value = cellText;
      return true;
    }
    if (valid) {
      ed.setCustomValidity("");
    } else {
      ed.setCustomValidity(objectImportLineValueNotFound());
    }
    ed.doValidate();
    return valid;
  }

  /// editor change - mark overwrite
  void onEditorChange(String name, String newValue, DEntry entry, var details) {
    for (int i = 0; i < editorList.length; i++) {
      LEditor ed = editorList[i];
      if (ed != null && name == ed.name) {
        _log.fine("onEditorChange ${name} ${newValue}");
        _overrideList[i] = newValue == null ? "" : newValue;
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

  static String objectImportLineLine() => Intl.message("Line", name: "objectImportLineLine");
  static String objectImportLineCheck() => Intl.message("Check", name: "objectImportLineCheck");
  static String objectImportLineEmpty() => Intl.message("empty", name: "objectImportLineEmpty");
  static String objectImportLineValueNotFound() => Intl.message("value not found or invalid", name: "objectImportLineValueNotFound");

} // ObjectImportLine
