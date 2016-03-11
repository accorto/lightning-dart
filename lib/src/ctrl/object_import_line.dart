/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/**
 * Object Import Line (table row)
 */
class ObjectImportLine {

  static final Logger _log = new Logger("ObjectImportLine");

  final ObjectImport parent;
  /// data result
  final DataRecord data;
  /// csv source
  final List<String> cellLine;
  /// line no
  final int lineNo;

  /// editor per column
  final List<LEditor> _editorList = new List<LEditor>();
  /// overwite per column
  final List<String> _overrideList = new List<String>();
  /// column meta data
  List<DColumn> _columnList;
  /// select
  LCheckbox _select;

  /// Import Line
  ObjectImportLine(ObjectImport this.parent,
      DataRecord this.data, List<String> this.cellLine, int this.lineNo) {
    // select
    _select = new LCheckbox("selected", inGrid: true)
      ..title = "Import Line";
    _select.input
      ..onClick.listen(onSelectClick)
      ..attributes[Html0.DATA_ID] = lineNo.toString();
  } // ObjectImportLine

  /// re-create TR line
  void createLine(TableRowElement tr, DTable table, List<DColumn> columnList) {
    _columnList = columnList;
    String idPrefix = "imp-${lineNo}";
    tr
      ..id = idPrefix
      ..classes.add(LTable.C_HINT_PARENT)
      ..attributes[Html0.DATA_ID] = lineNo.toString();
    tr.addCell()
      ..append(_select.element);

    _editorList.clear();
    _overrideList.clear();
    bool valid = true;
    for (int i = 0; i < _columnList.length; i++) {
      String cellText = "";
      if (i < cellLine.length)
        cellText = cellLine[i];
      //
      TableCellElement td = tr.addCell()
        ..id = "${idPrefix}-${i}"
        ..classes.add(LText.C_TRUNCATE)
        ..append(new SpanElement()
          ..text = cellText)
        ..append(new BRElement());
      DColumn col = _columnList[i];
      if (col == null) {
        _editorList.add(null);
      } else {
        DataColumn dataColumn = new DataColumn(table, col, null, null);
        LEditor ed = EditorUtil.createFromColumn("", dataColumn, true,
            idPrefix:idPrefix, data: data)
          ..editorChange = onEditorChange
          ..onFocus.listen(onEditorFocus);
        td.append(ed.element);
        _editorList.add(ed);
        //
        if (!checkLineValue(ed, cellText)) {
          valid = false;
        }
      }
      _overrideList.add(null);
    } // cols
    data.selected = valid;
    _select.checked = valid;
    tr.addCell(); // addColumn
    //
    _select.value = data.selected.toString();
  } // createLine

  /// check line - select only if valid
  void onSelectClick(MouseEvent evt) {
    bool valid = checkLine();
    _log.config("onSelectClick ${lineNo} valid=${valid}");
    if (_select.checked) {
      if (valid)
        data.selected = true;
      else
        _select.checked = false;
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
        LEditor ed = _editorList[i];
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
    for (int i = 0; i < _editorList.length; i++) {
      LEditor ed = _editorList[i];
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
  /// Editor Focused - close other editor dropdowns
  void onEditorFocus(Event evt) {
    String id = "";
    if (evt != null) {
      Element target = evt.target;
      id = target.id;
    }
    for (LEditor ed in _editorList) {
      // _log.fine("onEditorFocus ${id} - ${ed.id}");
      if (ed != null && id != ed.id) {
        ed.showDropdown = false;
      }
    }
  } // onEditorFocus

} // ObjectImportLine
