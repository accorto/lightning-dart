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


  /// Table Row
  final TableRowElement rowElement;
  /// Row Type
  final String type;
  /// Row Number
  final int rowNo;
  /// optional row select checkbox
  InputElement selectCb;
  /// Column Name-Label Map
  final Map<String,String> nameLabelMap;
  /// Name list by column #
  final List<String> nameList;
  /// Record Action
  AppsActionTriggered recordAction;
  /// Meta Data
  final List<DataColumn> dataColumns;
  /// Data Container
  DataRecord data;
  /// Callback when save
  RecordSaved recordSaved;
  /// Callback when delete
  RecordDeleted recordDeleted;
  /// Editors
  List<LEditor> editors;
  /// On Table Row Select Clicked
  TableSelectClicked tableSelectClicked;
  /// row select
  LabelElement _label;

  /**
   * [rowNo] absolute row number 0..x (in type)
   */
  LTableRow(TableRowElement this.rowElement,
      int this.rowNo,
      String idPrefix,
      String rowValue,
      String cssClass,
      bool rowSelect,
      List<String> this.nameList,
      Map<String,String> this.nameLabelMap,
      String this.type,
      List<AppsAction> rowActions,
      List<DataColumn> this.dataColumns) {

    rowElement.classes.add(cssClass);
    if (rowValue != null)
      rowElement.attributes[Html0.DATA_VALUE] = rowValue;
    if (idPrefix != null && idPrefix.isNotEmpty)
      rowElement.id = "${idPrefix}-${type}-${rowNo}";

    DTable table = null;
    if (dataColumns != null && dataColumns.isNotEmpty)
      table = dataColumns.first.table;
    data = new DataRecord(table, onRecordChange);

    // Row Select nor created as LTableCell but maintained by row directly
    if (rowSelect) {
      selectCb = new InputElement(type: "checkbox");
      String selectLabel = type == TYPE_HEAD ? LTable.lTableRowSelectAll() : "${LTable.lTableRowSelectRow()} ${rowNo + 1}";
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
      selectCb.name = "sel-${type}-${rowNo}";
      if (idPrefix == null) {
        selectCb.id = selectCb.name;
      } else {
        selectCb.id = idPrefix + "-" + selectCb.name;
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
    _log.fine("onRowSelectClick ${rowNo}");
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
    return addCell(div, name, value, align, dataColumn, addStatistics: addStatistics, tc:tc);
  }

  /// Add Link
  LTableCell addCellUrv(DRecord record,
      AppsActionTriggered recordAction) {
    AnchorElement a = new AnchorElement(href: "#${record.urv}")
      ..text = record.drv;
    if (recordAction != null) {
      a.onClick.listen((MouseEvent evt) {
        evt.preventDefault();
        recordAction("record", record, null, null);
      });
    } else if (isEditModeSelectSingleMulti) {
      a.onClick.listen(onRowSelectClick);
    }
    return addCell(a, DataRecord.URV, record.urv, null, null)
      ..cellElement.attributes[Html0.ROLE] = Html0.ROLE_ROW;
  }

  /**
   * Add Cell Link
   * of column [name] with [value]
   */
  LTableCell addCellLink(AnchorElement a,
      {String name,
      String value,
      String align,
      DataColumn dataColumn}) {
    a.classes.add(LText.C_TRUNCATE);
    return addCell(a, name, value, align, dataColumn);
  }

  /**
   * Add Button - no need to set classes
   */
  LTableCell addCellButton(LButton button) {
    button.classes.addAll([LButton.C_BUTTON__ICON_BORDER_FILLED, LButton.C_BUTTON__ICON_X_SMALL]);
    button.icon.classes.addAll([LButton.C_BUTTON__ICON, LButton.C_BUTTON__ICON__HINT, LButton.C_BUTTON__ICON__SMALL]);

    LTableCell tc = addCell(button.element, null, null, null, null);
    tc.cellElement.classes.add(LTable.C_ROW_ACTION);
    return tc;
  }

  /// Add Editor
  LTableCell addCellEditor(LEditor editor,
      String display,
      String value,
      String align,
      bool editModeField) {
    if (editors == null)
      editors = new List<LEditor>();
    editors.add(editor);

    if (editModeField) {
      if (editor.isValueRenderElement) {
        return addCell(editor.getValueRenderElement(value), editor.name, value, align, editor.dataColumn);
      }
      DivElement div = new DivElement()
        ..classes.add(LText.C_TRUNCATE)
        ..text = display == null ? "" : display;
      return addCell(div, editor.name, value, align, editor.dataColumn);
    }
    return addCell(editor.input, null, null, align, editor.dataColumn);
  } // addCellEditor

  /**
   * with [display] of column [name] with [value]
   * if you not provide the data column [name], it is derived - if found the label is derived (required for responsive)
   * [align] e.g. LTable.C_TEXT_CENTER
   */
  LTableCell addCell(Element content,
      String name,
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
      if (nameList.length > index)
        theName = nameList[index];
    }
    // find column label
    String label = null;
    if (theName != null) {
      label = nameLabelMap[theName];
    }

    // create if not exists
    if (tc == null) {
      if (type == TYPE_HEAD) {
        tc = new Element.th()
          ..attributes["scope"] = "col";
      } else {
        tc = new Element.td();
      }
      if (_actionCell == null) {
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
      if (type == TYPE_HEAD) {
        TableCellElement tc = new Element.th()
          ..attributes["scope"] = "col";
        rowElement.append(tc);
        _actionCell = new LTableActionCell(tc, LTableActionCell.createButton("hdr"), null);
      } else {
        _actionCell = new LTableActionCell(rowElement.addCell(), LTableActionCell.createButton("row"), null);
      }
      _actionCell.row = this;
    }
    for (AppsAction action in actions) {
      _actionCell.addAction(action);
    }
  }
  LTableActionCell _actionCell;


  /// Set Record - [recordAction] click on urv
  void setRecord(DRecord record,
      int rowNo,
      {AppsActionTriggered recordAction}) {
    data.setRecord(record, rowNo);
    this.recordAction = recordAction;
    display();
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
    for (String name in nameList) {
      if (name == null)
        continue;
      if (name == DataRecord.URV || name == "Id") {
        addCellUrv(record, recordAction);
      } else {
        DataColumn dataColumn = findColumn(name);
        DEntry entry = data.getEntry(null, name, false);
        String value = DataRecord.getEntryValue(entry);
        String align = _displayAlign(dataColumn);

        if (isEditModeRO
            || data.isReadOnly
            || isEditModeSelectSingleMulti
            || (isEditModeSel && !selected)) {
          _displayRo(name, value, align, dataColumn, entry, true);
        } else { // all, sel or field
          LEditor editor = EditorUtil.createFromColumn(name, dataColumn, true,
            idPrefix:rowElement.id, data:data, entry:entry); // no isAlternativeDisplay
          if (editor.isValueRenderElement) {
            addCellEditor(editor, value, value, align, isEditModeField);
          } else if (editor.isValueDisplay && entry != null && entry.hasValueDisplay()) {
            addCellEditor(editor, entry.valueDisplay, value, align, isEditModeField);
          } else if (editor.isValueDisplay && value != null && value.isNotEmpty) {
            LTableCell cell = addCellEditor(editor, "<${value}>", value, align, isEditModeField);
            if (isEditModeField) {
              editor.render(value, false)
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
          } else {
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
      addCell(editor.getValueRenderElement(value), name, value, align,
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
  String _displayAlign(DataColumn dataColumn) {
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
    for (DataColumn col in dataColumns) {
      if (col.name == name)
        return col;
    }
    return null;
  }

  /// editor changed
  void onRecordChange(DRecord record, DEntry columnChanged, int rowNo) {
    bool changed = data.checkChanged();
    String name = columnChanged == null ? "-" : columnChanged.columnName;
    _log.config("onRecordChange - ${name} - changed=${changed}");
    if (editors != null) {
      for (EditorI editor in editors) {
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
  } // onRecordChange

} // LTableRow
