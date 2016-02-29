/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Table Row
 */
class LTableRow
    implements FormI {

  static final Logger _log = new Logger("LTableRow");

  static const String TYPE_HEAD = "H";
  static const String TYPE_BODY = "B";
  static const String TYPE_FOOT = "F";

  /// Get Render Editor
  static LEditor _getRenderEditor(DataColumn dataColumn) {
    String key = "${dataColumn.table.name}.${dataColumn.name}";
    LEditor editor = _renderEditorMap[key];
    if (editor == null) {
      editor =  EditorUtil.createFromColumn(dataColumn.name,
          dataColumn, true, idPrefix:"table-${dataColumn.table.name}");
      _renderEditorMap[key] = editor;
    }
    return editor;
  }
  static Map<String, LEditor> _renderEditorMap = new Map<String, LEditor>();

  /// Table Element
  final LTable ltable;
  /// Table Row
  final TableRowElement rowElement;
  /// Row Type
  final String type;
  /// Row Number
  final int rowIndex;
  /// optional row select checkbox
  InputElement selectCb;
  /// Data Container
  DataRecord data;
  /// FormI Callback when save
  RecordSaved recordSaved;
  /// FormI Callback when delete
  RecordDeleted recordDeleted;
  /// Editors
  List<LEditor> editorList;
  /// On Table Row Select Clicked
  TableSelectClicked tableSelectClicked;
  /// row select
  LabelElement _label;

  /**
   * [rowNo] absolute row number 0..x (in type)
   */
  LTableRow(LTable this.ltable, TableRowElement this.rowElement,
      int this.rowIndex,
      String rowValue,
      String cssClass,
      String this.type,
      List<AppsAction> rowActions) {

    rowElement.classes.add(cssClass);
    if (rowValue != null)
      rowElement.attributes[Html0.DATA_VALUE] = rowValue;
    if (ltable.idPrefix != null && ltable.idPrefix.isNotEmpty)
      rowElement.id = "${ltable.idPrefix}-${type}-${rowIndex}";

    DTable table = null;
    if (ltable.dataColumns != null && ltable.dataColumns.isNotEmpty)
      table = ltable.dataColumns.first.table;
    data = new DataRecord(table, onRecordChange);

    // Row Select nor created as LTableCell but maintained by row directly
    if (ltable.rowSelect) {
      selectCb = new InputElement(type: "checkbox");
      String selectLabel = type == TYPE_HEAD ? LTable.lTableRowSelectAll() : "${LTable.lTableRowSelectRow()} ${rowIndex + 1}";
      _label = new LabelElement()
        ..classes.add(LForm.C_CHECKBOX);
      _label.append(selectCb);
      _label.append(new SpanElement()
        ..classes.add(LForm.C_CHECKBOX__FAUX)
      );
      _label.append(new SpanElement()
        ..classes.add(LForm.C_FORM_ELEMENT__LABEL)
        ..classes.add(LText.C_ASSISTIVE_TEXT)
        ..text = selectLabel
      );
      // name/id
      selectCb.name = "sel-${type}-${rowIndex}";
      if (ltable.idPrefix == null) {
        selectCb.id = selectCb.name;
      } else {
        selectCb.id = ltable.idPrefix + "-" + selectCb.name;
      }
      _label.htmlFor = selectCb.id;
      // th/td
      if (type == TYPE_HEAD) {
        TableCellElement tc = new Element.th()
          ..classes.add(LTable.C_ROW_SELECT)
          ..attributes["scope"] = "col";
        rowElement.append(tc);
        tc.append(_label);
      } else {
        TableCellElement tc = rowElement.addCell()
          ..classes.add(LTable.C_ROW_SELECT);
        tc.append(_label);
        selectCb.onClick.listen(onSelectClick);
      }
    }
    if (rowActions != null && rowActions.isNotEmpty) {
      addActions(rowActions);
    }
  } // LTableRow

  /// clicked on selectCb
  void onSelectClick(MouseEvent evt) {
    if (selectCb.checked) {
      rowElement.classes.add(LTable.C_IS_SELECTED);
    } else {
      rowElement.classes.remove(LTable.C_IS_SELECTED);
    }
    data.selected = selectCb.checked;
    if (tableSelectClicked != null)
      tableSelectClicked(data);
  } // onSelectedClick

  /// Row Selected
  bool get selected => rowElement.classes.contains(LTable.C_IS_SELECTED);
  /// Row Selected
  void set selected (bool newValue) {
    if (newValue) {
      rowElement.classes.add(LTable.C_IS_SELECTED);
    } else {
      rowElement.classes.remove(LTable.C_IS_SELECTED);
    }
    data.selected = newValue;
    if (selectCb != null)
      selectCb.checked = newValue;
  } // selected

  /// Row is displayed
  bool get show => !rowElement.classes.contains(LVisibility.C_HIDE);
  /// Show/Hide Row
  void set show (bool newValue) {
    if (newValue)
      rowElement.classes.remove(LVisibility.C_HIDE);
    else
      rowElement.classes.add(LVisibility.C_HIDE);
  }

  /// clicked on something else than selectCb
  void onRowSelectClick(MouseEvent evt) {
    _log.fine("onRowSelectClick ${rowIndex}");
    evt.preventDefault();
    evt.stopPropagation();
    // update display + selectCb
    if (selectCb != null) {
      selected = !selectCb.checked; // toggle
    } else {
      selected = true;
    }
    if (tableSelectClicked != null)
      tableSelectClicked(data);
  }

  /**
   * Add Cell Text
   * with [display] of column [name] with [value]
   */
  LTableCell addCellText(String display,
      {String name,
      String label,
      String value,
      String align,
      DataColumn dataColumn,
      bool addStatistics:true,
      TableCellElement tc}) {
    DivElement div = new DivElement()
      ..classes.add(LText.C_TRUNCATE);
    if (display == null || display.isEmpty) {
      div.appendHtml("&nbsp;");
    } else {
      div.text = display;
    }
    return addCell(div, name, label, value, align, dataColumn, addStatistics: addStatistics, tc:tc);
  }

  /// Add Link
  LTableCell addCellUrv() {
    AnchorElement a = new AnchorElement(href: "#${record.urv}")
      ..text = record.drv;
    if (ltable.recordAction != null) {
      a.onClick.listen((MouseEvent evt) {
        evt.preventDefault();
        ltable.recordAction("record", data, null, null);
      });
    } else if (isEditModeSelectSingleMulti) {
      a.onClick.listen(onRowSelectClick);
    }
    return addCell(a, DataRecord.URV, record.urv, null, null, null)
      ..cellElement.attributes[Html0.ROLE] = Html0.ROLE_ROW;
  }

  /**
   * Add Cell Link
   * of column [name] with [value]
   */
  LTableCell addCellLink(AnchorElement a,
      {String name,
      String label,
      String value,
      String align,
      DataColumn dataColumn}) {
    a.classes.add(LText.C_TRUNCATE);
    return addCell(a, name, label, value, align, dataColumn);
  }

  /**
   * Add Button - no need to set classes
   */
  LTableCell addCellButton(LButton button) {
    button.classes.addAll([LButton.C_BUTTON__ICON_BORDER_FILLED, LButton.C_BUTTON__ICON_X_SMALL]);
    button.icon.classes.addAll([LButton.C_BUTTON__ICON, LButton.C_BUTTON__ICON__HINT, LButton.C_BUTTON__ICON__SMALL]);

    LTableCell tc = addCell(button.element, null, null, null, null, null);
    tc.cellElement.classes.add(LTable.C_ROW_ACTION);
    return tc;
  }

  /// Add Editor
  LTableCell addCellEditor(LEditor editor,
      String display,
      String value,
      String align,
      bool editModeField) {
    if (editorList == null)
      editorList = new List<LEditor>();
    editor.onFocus.listen(onEditorFocus); // close other dropdowns
    editorList.add(editor);

    if (editModeField) {
      if (editor.isValueRenderElement) {
        return addCell(editor.getValueRenderElement(value), editor.name, editor.label, value, align, editor.dataColumn);
      }
      DivElement div = new DivElement()
        ..classes.add(LText.C_TRUNCATE)
        ..text = display == null ? "" : display;
      return addCell(div, editor.name, editor.label, value, align, editor.dataColumn);
    }
    return addCell(editor.element, editor.name, editor.label, null, align, editor.dataColumn);
  } // addCellEditor

  /**
   * with [display] of column [name] with [value]
   * if you not provide the data column [name], it is derived - if found the label is derived (required for responsive)
   * [align] e.g. LTable.C_TEXT_CENTER
   */
  LTableCell addCell(Element content,
      String name,
      String label,
      String value,
      String align,
      DataColumn dataColumn,
      {bool fieldEdit: false,
      bool addStatistics: true,
      TableCellElement tc}) {

    // find column Name
    String theName = name;
    if (theName == null) {
      int index = rowElement.children.length;
      if (ltable.nameList.length > index)
        theName = ltable.nameList[index];
    }
    // find column label
    if (label == null && theName != null) {
      label = ltable.nameLabelMap[theName];
    }

    // create if not exists
    if (tc == null) {
      if (type == TYPE_HEAD) {
        tc = new Element.th()
          ..attributes["scope"] = "col";
      } else {
        tc = new Element.td();
      }
      if (_actionCell == null || !ltable.rowSelect) {
        rowElement.append(tc);
      } else {
        rowElement.insertBefore(tc, _actionCell.cellElement);
      }
    }
    if (fieldEdit) {
      tc.onFocus.listen((Event evt){
        _log.config("fieldFocus ${theName}");
      });
    }
    return new LTableCell(tc, content, theName, label, value, align, dataColumn, addStatistics);
  } // addCell

  /**
   * Add Actions
   */
  void addActions(List<AppsAction> actions) {
    if (_actionCell == null) {
      bool atEnd = ltable.rowSelect;
      if (type == TYPE_HEAD) {
        TableCellElement tc = new Element.th()
          ..attributes["scope"] = "col";
        rowElement.append(tc);
        _actionCell = new LTableActionCell(this, tc,
            LTableActionCell._createButton(rowElement.id), atEnd);
      } else {
        _actionCell = new LTableActionCell(this, rowElement.addCell(),
            LTableActionCell._createButton(rowElement.id), atEnd);
      }
    }
    // add actions
    for (AppsAction action in actions) {
      _actionCell.addAction(action);
    }
  }
  LTableActionCell _actionCell;


  /// Set Record - [recordAction] click on urv
  void setRecord(DRecord record, int rowNo) {
    data.setRecord(record, rowNo);
    display();
    ltable.displayFoot(); //update
  }
  /// get record or null if empty
  DRecord get record {
    if (data.isEmpty) {
      return null;
    }
    return data.record;
  }

  /// (re) display values
  void display() {
    for (String name in ltable.nameList) {
      if (name == null)
        continue;
      if (name == DataRecord.URV || name == "Id") {
        addCellUrv();
      } else {
        DataColumn dataColumn = findColumn(name);
        DEntry entry = data.getEntry(null, name, false);
        String value = DataRecord.getEntryValue(entry);
        String align = getDisplayAlign(dataColumn);

        if (isEditModeRO
            || data.isReadOnly
            || isEditModeSelectSingleMulti
            || (isEditModeSel && !selected)) {
          _displayRo(name, value, align, dataColumn, entry, true);
        } else { // all, sel or field
          LEditor editor = EditorUtil.createFromColumn(name, dataColumn, true,
            idPrefix:rowElement.id, data:data, entry:entry); // no isAlternativeDisplay
          if (editor.isValueRenderElement) { // checkbox
            addCellEditor(editor, value, value, align, isEditModeField);
          }
          else if (editor.isValueDisplay && entry != null && entry.hasValueDisplay()) { // rendered already
            addCellEditor(editor, entry.valueDisplay, value, align, isEditModeField);
          }
          else if (editor.isValueDisplay && value != null && value.isNotEmpty) { // need to render
            LTableCell cell = addCellEditor(editor, "<${value}>", value, align, isEditModeField);
            editor.render(value, false)
            .then((String display){
              cell.contentText = display;
              if (entry != null) { // future render
                entry.valueDisplay = display;
              }
            })
            .catchError((error, stackTrace){
              cell.contentText = "${error}";
              cell.cellElement.attributes["error"] = "${error}";
            });
          }
          else { //
            addCellEditor(editor, value, value, align, isEditModeField);
          }
        }
      }
    } // for all column names
  } // display

  /// display Read Only
  void _displayRo(String name, String value, String align,
      DataColumn dataColumn, DEntry entry,
      bool addStatistics, {TableCellElement tc}) {
    if (dataColumn != null && dataColumn.isValueRenderElement) {
      LEditor editor = _getRenderEditor(dataColumn);
      addCell(editor.getValueRenderElement(value), name, editor.label, value, align,
          dataColumn, addStatistics:addStatistics, tc:tc);
    } else if (entry != null && entry.hasValueDisplay()) {
      addCellText(entry.valueDisplay, name:name, value:value, align:align,
          dataColumn:dataColumn, addStatistics:addStatistics, tc:tc);
    } else if (value == null || value.isEmpty || dataColumn == null || !dataColumn.isValueRender) {
      addCellText(value, name:name, value:value, align:align,
          dataColumn:dataColumn, addStatistics:addStatistics, tc:tc);
    } else {
      LTableCell cell = addCellText("<${value}>", name:name, value:value, align:align,
          dataColumn:dataColumn, addStatistics:addStatistics, tc:tc);
      EditorUtil.render(dataColumn, value)
      .then((String display){
        cell.contentText = display;
        if (entry != null) {
          entry.valueDisplay = display;
        }
      })
      .catchError((error, stackTrace){
        cell.contentText = "${error}";
      });
    }
  } // displayRo

  /// Render Value
  String getDisplayAlign(DataColumn dataColumn) {
    if (dataColumn != null) {
      DataType dt = dataColumn.tableColumn.dataType;
      if (DataTypeUtil.isCenterAligned(dt))
        return LTable.C_TEXT_CENTER;
      if (DataTypeUtil.isRightAligned(dt))
        return LTable.C_TEXT_RIGHT;
    }
    return null;
  }

  /// Edit Mode
  void set editMode (String newValue) {
    _editMode = newValue;
    if (type == TYPE_HEAD) {
      if (_label != null) {
        if (isEditModeSelectSingle) {
          _label.classes.add(LVisibility.C_HIDE);
        } else {
          _label.classes.remove(LVisibility.C_HIDE);
        }
      }
    } else if (type == TYPE_BODY) {
      if (isEditModeSelectSingleMulti) {
        if (_rowClickSubscription == null)
          _rowClickSubscription = rowElement.onClick.listen(onRowSelectClick);
      }
      if (record != null) {
        display(); // update
      }
    }
  }
  String _editMode = LTable.EDIT_RO;
  StreamSubscription<MouseEvent> _rowClickSubscription;

  /// Table Edit Mode - Read Only
  bool get isEditModeRO => _editMode == LTable.EDIT_RO;
  /// Table Edit Mode - Field Click
  bool get isEditModeField => _editMode == LTable.EDIT_FIELD;
  /// Table Edit Mode - Selected Rows
  bool get isEditModeSel => _editMode == LTable.EDIT_SEL;
  /// Table Edit Mode - R/O Select Single or Multiple Rows
  bool get isEditModeSelectSingleMulti => _editMode == LTable.EDIT_SELECT_SINGLE || _editMode == LTable.EDIT_SELECT_MULTI;
  /// Table Edit Mode - R/O Select Single Row
  bool get isEditModeSelectSingle => _editMode == LTable.EDIT_SELECT_SINGLE;
  /// Table Edit Mode - R/O Select Multiple Rows
  bool get isEditModeSelectMulti => _editMode == LTable.EDIT_SELECT_MULTI;


  /// find column by name or null
  DataColumn findColumn(String name) {
    for (DataColumn col in ltable.dataColumns) {
      if (col != null && col.name == name)
        return col;
    }
    return null;
  }

  /// editor changed
  void onRecordChange(DRecord record, DEntry columnChanged, int rowNo) {
    bool changed = data.checkChanged();
    String name = columnChanged == null ? "-" : columnChanged.columnName;
    _log.config("onRecordChange - ${name} - changed=${changed}");
    if (editorList != null) {
      for (EditorI editor in editorList) {
        if (editor.hasDependentOn) {
          for (EditorIDependent edDep in editor.dependentOnList) {
            if (name == edDep.columnName) {
              _log.fine("onRecordChange ${name} dependent: ${editor.name}");
              editor.onDependentOnChanged(columnChanged);
            }
          }
        }
      } // for all editors
    }
    ltable.displayFoot(); // update
  } // onRecordChange

  /// Editor Focused - close other editor dropdowns
  void onEditorFocus(FocusEvent evt) {
    String id = "";
    if (evt != null) {
      Element target = evt.target;
      id = target.id;
    }
    for (LEditor ed in editorList) {
      // _log.fine("onEditorFocus ${id} - ${ed.id}");
      if (id != ed.id) {
        ed.showDropdown = false;
      }
    }
  } // onEditorFocus

  /// string info
  String toString() {
    return "LTableRow@${rowElement.id}[${data.recordId} selected=${data.selected}]";
  }

} // LTableRow
