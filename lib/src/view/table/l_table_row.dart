/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Table Row
 */
class LTableRow implements FormI {

  static final Logger _log = new Logger("LTableRow");

  static const String TYPE_HEAD = "H";
  static const String TYPE_BODY = "B";
  static const String TYPE_FOOT = "F";

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

  /**
   * [rowNo] absolute row number 0..x (in type)
   */
  LTableRow(TableRowElement this.rowElement, int this.rowNo, String idPrefix, String rowValue,
      String cssClass, bool rowSelect,
      List<String> this.nameList, Map<String,String> this.nameLabelMap, String this.type,
      List<AppsAction> rowActions, List<DataColumn> this.dataColumns) {
    rowElement.classes.add(cssClass);
    if (rowValue != null)
      rowElement.attributes[Html0.DATA_VALUE] = rowValue;
    if (idPrefix != null)
      rowElement.id = "${idPrefix}-${type}-${rowNo}";

    data = new DataRecord(onRecordChange);

    // Row Select nor created as LTableCell but maintained by row directly
    if (rowSelect) {
      selectCb = new InputElement(type: "checkbox");
      String selectLabel = type == TYPE_HEAD ? LTable.lTableRowSelectAll() : "${LTable.lTableRowSelectRow()} ${rowNo + 1}";
      LabelElement label = new LabelElement()
        ..classes.add(LForm.C_CHECKBOX);
      label.append(selectCb);
      label.append(new SpanElement()
        ..classes.add(LForm.C_CHECKBOX__FAUX)
      );
      label.append(new SpanElement()
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
      label.htmlFor = selectCb.id;
      // th/td
      if (type == TYPE_HEAD) {
        TableCellElement tc = new Element.th()
          ..classes.add(LTable.C_ROW_SELECT)
          ..attributes["scope"] = "col";
        rowElement.append(tc);
        tc.append(label);
      } else {
        TableCellElement tc = rowElement.addCell()
          ..classes.add(LTable.C_ROW_SELECT);
        tc.append(label);
        selectCb.onClick.listen((MouseEvent evt){
          if (selectCb.checked) {
            rowElement.classes.add(LTable.C_IS_SELECTED);
          } else {
            rowElement.classes.remove(LTable.C_IS_SELECTED);
          }
        });
      }
    }
    if (rowActions != null && rowActions.isNotEmpty) {
      addActions(rowActions);
    }
  } // LTableRow


  /// Row Selected
  bool get selected => rowElement.classes.contains(LTable.C_IS_SELECTED);
  /// Row Selected
  void set selected (bool newValue) {
    if (newValue) {
      rowElement.classes.add(LTable.C_IS_SELECTED);
    } else {
      rowElement.classes.remove(LTable.C_IS_SELECTED);
    }
    if (selectCb != null)
      selectCb.checked = newValue;
  } // selected


  /**
   * Add Cell Text
   * with [display] of column [name] with [value]
   */
  LTableCell addCellText(String display,
      {String name, String value, String align, DataColumn dataColumn}) {
    SpanElement span = new SpanElement()
      ..classes.add(LText.C_TRUNCATE)
      ..text = display == null ? "" : display;
    return addCell(span, name, value, align, dataColumn);
  }

  /// Add Link
  LTableCell addCellUrv(DRecord record, AppsActionTriggered recordAction) {
    AnchorElement a = new AnchorElement(href: "#${record.urv}")
      ..text = record.drv;
    if (recordAction != null) {
      a.onClick.listen((MouseEvent evt) {
        evt.preventDefault();
        recordAction("record", record, null, null);
      });
    }
    return addCell(a, DataRecord.URV, record.urv, null, null)
      ..cellElement.attributes[Html0.ROLE] = Html0.ROLE_ROW;
  }

  /**
   * Add Cell Link
   * of column [name] with [value]
   */
  LTableCell addCellLink(AnchorElement a, {String name, String value, String align, DataColumn dataColumn}) {
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
  LTableCell addCellEditor(LEditor editor, String display, String value, String align, bool editModeField) {
    if (editors == null)
      editors = new List<LEditor>();
    editors.add(editor);

    if (editModeField) {
      SpanElement span = new SpanElement()
        ..classes.add(LText.C_TRUNCATE)
        ..text = display == null ? "" : display;
      return addCell(span, editor.name, value, align, editor.dataColumn);
    }
    return addCell(editor.input, null, null, align, editor.dataColumn);
  }

  /**
   * with [display] of column [name] with [value]
   * if you not provide the data column [name], it is derived - if found the label is derived (required for responsive)
   * [align] LText.C_TEXT_CENTER LText.C_TEXT_RIGHT
   */
  LTableCell addCell(Element content, String name, String value,
      String align, DataColumn dataColumn, {bool fieldEdit:false}) {
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

    TableCellElement tc = null;
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
    if (fieldEdit) {
      tc.onFocus.listen((Event evt){
        _log.config("fieldFocus ${theName}");
      });
    }
    return new LTableCell(tc, content, theName, label, value, align, dataColumn);
  } // addTableElement

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
  void setRecord(DRecord record, int rowNo, {AppsActionTriggered recordAction}) {
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
      if (name == DataRecord.URV) {
        addCellUrv(record, recordAction);
      } else {
        DataColumn dataColumn = findColumn(name);
        DEntry entry = data.getEntry(null, name, false);
        String value = DataRecord.getEntryValue(entry);
        String align = _displayAlign(dataColumn);

        if (_editMode == LTable.EDIT_RO
            || (_editMode == LTable.EDIT_SEL && !selected)) {
          if (entry != null && entry.hasValueDisplay()) {
            addCellText(entry.valueDisplay, name:name, value:value, dataColumn:dataColumn);
          } else if (value == null || value.isEmpty || dataColumn == null) {
            addCellText(value, name:name, value:value, dataColumn:dataColumn);
          } else {
            LTableCell cell = addCellText("<${value}>", name:name, value:value, dataColumn:dataColumn);
            EditorUtil.render(dataColumn, value)
            .then((String display){
              cell.cellElement.children.first.text = display;
              if (entry != null) {
                entry.valueDisplay = display;
              }
            });
          }
        } else { // all, sel or field
          LEditor editor = EditorUtil.createfromColumn(name, dataColumn, true,
            idPrefix:rowElement.id, data:data, entry:entry);
          bool editModeField = _editMode == LTable.EDIT_FIELD;
          if (editor.valueRendered && entry != null && entry.hasValueDisplay()) {
            addCellEditor(editor, entry.valueDisplay, value, align, editModeField);
          } else if (editor.valueRendered && value != null && value.isNotEmpty) {
            LTableCell cell = addCellEditor(editor, "<${value}>", value, align, editModeField);
            if (editModeField) {
              editor.render(value, false)
              .then((String display){
                cell.cellElement.children.first.text = display;
              });
            }
          } else {
            addCellEditor(editor, value, value, align, editModeField);
          }
        }
      }
    } // for all column names
  } // display


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
    if (record != null) {
      display();
    }
  }
  String _editMode = LTable.EDIT_RO;


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


/**
 * Table Header Row
 */
class LTableHeaderRow extends LTableRow {

  // callback
  TableSortClicked tableSortClicked;

  /**
   * Table Header Row
   */
  LTableHeaderRow(TableRowElement element, int rowNo, String idPrefix,
      String cssClass, bool rowSelect,
      List<String> nameList, Map<String,String> nameLabelMap,
      this.tableSortClicked, List<AppsAction> tableActions, List<DataColumn> dataColumns)
    : super (element, rowNo, idPrefix, null, cssClass, rowSelect, nameList, nameLabelMap,
        LTableRow.TYPE_HEAD, tableActions, dataColumns);

  /**
   * Add Cell with Header Text
   * with [label] of column [name] with optional [value]
   * - name/label are used for responsive
   */
  LTableHeaderCell addHeaderCell(String name, String label, {String value, String align, DataColumn dataColumn}) {
    SpanElement span = new SpanElement()
      ..classes.add(LText.C_TRUNCATE)
      ..text = label == null ? "" : label;

    if (name != null && name.isNotEmpty && label != null && label.isNotEmpty) {
      int index = rowElement.children.length;
      while (nameList.length < index)
        nameList.add(null);
      nameList.add(name);
      nameLabelMap[name] = label;
    }

    TableCellElement tc = new Element.th()
      ..attributes["scope"] = "col";
    if (_actionCell == null) {
      rowElement.append(tc);
    } else {
      rowElement.insertBefore(tc, _actionCell.cellElement);
    }
    if (dataColumn == null) {
      dataColumn = findColumn(name);
    }
    LTableHeaderCell cell = new LTableHeaderCell(tc, span, name, label, value, align, tableSortClicked, dataColumn);
    _cells.add(cell);
    return cell;
  } // addHeaderCell

  List<LTableHeaderCell> _cells = new List<LTableHeaderCell>();

  /**
   * Add Grid Column
   */
  void addGridColumn(DataColumn dataColumn) {
    addHeaderCell(dataColumn.name, dataColumn.label, dataColumn:dataColumn);
  }

  /// Set Sorting
  void setSorting(RecordSorting recordSorting) {
    for (LTableHeaderCell cell in _cells) {
      if (cell.sortable) {
        RecordSort sort = recordSorting.getSort(cell.name);
        if (sort == null)
          cell.sortAsc = true;
        else
          cell.sortAsc = sort.isAscending;
      }
    }
  }


} // LTableHeaderRow

