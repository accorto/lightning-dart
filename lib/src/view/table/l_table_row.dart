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
  final DTable table;
  /// Data Container
  DataRecord data;
  /// Callback when save
  RecordSaved onRecordSaved;
  /// Editors
  List<LEditor> editors;

  /**
   * [rowNo] absolute row number 0..x (in type)
   */
  LTableRow(TableRowElement this.rowElement, int this.rowNo, String idPrefix, String rowValue,
      String cssClass, bool rowSelect,
      List<String> this.nameList, Map<String,String> this.nameLabelMap, String this.type,
      List<AppsAction> rowActions, DTable this.table) {
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
        TableCellElement tc = document.createElement("th")
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
  LTableCell addCellText(String display, {String name, String value, String align, DColumn column}) {
    SpanElement span = new SpanElement()
      ..classes.add(LText.C_TRUNCATE)
      ..text = display == null ? "" : display;
    return addCell(span, name, value, align, column);
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
    return addCell(a, LTable.URV, record.urv, null, null);
  }

  /**
   * Add Cell Link
   * of column [name] with [value]
   */
  LTableCell addCellLink(AnchorElement a, {String name, String value, String align, DColumn column}) {
    a.classes.add(LText.C_TRUNCATE);
    return addCell(a, name, value, align, column);
  }

  /**
   * Add Button - no need to set classes
   */
  LTableCell addCellButton(LButton button) {
    button.classes.addAll([LButton.C_BUTTON__ICON_BORDER_FILLED, LButton.C_BUTTON__ICON_BORDER_SMALL]);
    button.icon.classes.addAll([LButton.C_BUTTON__ICON, LButton.C_BUTTON__ICON__HINT, LButton.C_BUTTON__ICON__SMALL]);

    LTableCell tc = addCell(button.element, null, null, null, null);
    tc.cellElement.classes.add(LTable.C_ROW_ACTION);
    return tc;
  }

  LTableCell addCellEditor(LEditor editor) {
    if (editors == null)
      editors = new List<LEditor>();
    editors.add(editor);
    return addCell(editor.input, null, null, null, editor.column);
  }

  /**
   * with [display] of column [name] with [value]
   * if you not provide the data column [name], it is derived - if found the label is derived (required for responsive)
   * [align] LText.C_TEXT_CENTER LText.C_TEXT_RIGHT
   */
  LTableCell addCell(Element content, String name, String value, String align, DColumn column) {
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
    return new LTableCell(tc, content, theName, label, value, align, column);
  } // addTableElement

  /**
   * Add Actions
   */
  void addActions(List<AppsAction> actions) {
    if (_actionCell == null) {
      if (type == TYPE_HEAD) {
        TableCellElement tc = document.createElement("th")
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
      if (name == LTable.URV) {
        addCellUrv(record, recordAction);
      } else {
        DColumn column = findColumn(name);
        DEntry entry = data.getEntry(null, name, false);
        if (_editMode == LTable.EDIT_ALL || (_editMode == LTable.EDIT_SEL && selected)) {
          LEditor editor = EditorUtil.createfromColumn(name, column, data, true, rowElement.id);
          addCellEditor(editor);
        } else {
          String value = DataRecord.getEntryValue(entry);
          String display = displayRender(column, entry);
          addCellText(display, name:name, value:value, column:column);
        }
      }
    }
  } // display

  /// Render Value
  String displayRender(DColumn column, DEntry entry) {
    if (entry == null)
      return null;
    if (entry.hasValueDisplay())
      return entry.valueDisplay;
    String value = DataRecord.getEntryValue(entry);
    if (column != null && value != null && value.isNotEmpty) {
      if (DataTypeUtil.isDisplayRendered(column.dataType)) {
        // todo render
      }
    }
    return value;
  }


  void set editMode (String newValue) {
    _editMode = newValue;
    if (record != null) {
      display();
    }
  }
  String _editMode = LTable.EDIT_RO;


  /// find column by name or null
  DColumn findColumn(String name) {
    if (table != null && name != null) {
      for (DColumn col in table.columnList) {
        if (col.name == name)
          return col;
      }
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
      this.tableSortClicked, List<AppsAction> tableActions, DTable table)
    : super (element, rowNo, idPrefix, null, cssClass, rowSelect, nameList, nameLabelMap,
        LTableRow.TYPE_HEAD, tableActions, table);

  /**
   * Add Cell with Header Text
   * with [label] of column [name] with optional [value]
   * - name/label are used for responsive
   */
  LTableHeaderCell addHeaderCell(String name, String label, {String value, String align, DColumn column}) {
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

    TableCellElement tc = document.createElement("th")
      ..attributes["scope"] = "col";
    if (_actionCell == null) {
      rowElement.append(tc);
    } else {
      rowElement.insertBefore(tc, _actionCell.cellElement);
    }
    if (column == null) {
      column = findColumn(name);
    }
    return new LTableHeaderCell(tc, span, name, label, value, align, tableSortClicked, column);
  } // addHeaderCell


  /**
   * Add Grid Column
   */
  void addGridColumn(UIGridColumn gc) {
    addHeaderCell(gc.column.name, gc.column.label, column:gc.column);
  }




} // LTableHeaderRow

