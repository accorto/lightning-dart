/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Table
 */
class LTable {


  static const String C_TABLE = "slds-table";
  static const String C_TABLE__BORDERED = "slds-table--bordered";
  static const String C_TABLE__STRIPED = "slds-table--striped";

  static const String C_MAX_MEDIUM_TABLE__STACKED = "slds-max-medium-table--stacked";
  static const String C_MAX_MEDIUM_TABLE__STACKED_HORIZONTAL = "slds-max-medium-table--stacked-horizontal";

  static const String C_ROW_SELECT = "slds-row-select";
  static const String C_IS_SELECTED = "slds-is-selected";

  static const String C_IS_SORTABLE = "slds-is-sortable";
  static const String C_ROW_ACTION = "slds-row-action";
  static const String C_CELL_WRAP = "slds-cell-wrap";

  static const String C_NO_ROW_HOVER = "slds-no-row-hover";

  /// Table Element
  final TableElement element = new TableElement()
    ..classes.add(C_TABLE);

  TableSectionElement _thead;
  TableSectionElement _tbody;
  TableSectionElement _tfoot;
  final List<LTableRow> _theadRows = new List<LTableRow>();
  final List<LTableRow> _tbodyRows = new List<LTableRow>();
  final List<LTableRow> _tfootRows = new List<LTableRow>();

  final String idPrefix;
  final bool rowSelect;

  /// Column Name-Label Map - required for responsive
  final Map<String,String> nameLabelMap = new Map<String,String>();
  /// Name list by column #
  final List<String> nameList = new List<String>();

  /**
   * Table
   */
  LTable(String this.idPrefix, bool this.rowSelect) {
  }

  /// scrollable-x wrapper with table
  DivElement responsiveWrapper() {
    DivElement wrapper = new DivElement()
      ..classes.add(LScrollable.C_SCROLLABLE__X);
    wrapper.append(element);
    return wrapper;
  }

  /// Responsive Stacked
  bool get responsiveStacked => element.classes.contains(C_MAX_MEDIUM_TABLE__STACKED);
  void set responsiveStacked (bool newValue) {
    element.classes.remove(C_MAX_MEDIUM_TABLE__STACKED_HORIZONTAL);
    if (newValue)
      element.classes.add(C_MAX_MEDIUM_TABLE__STACKED);
    else
      element.classes.remove(C_MAX_MEDIUM_TABLE__STACKED);
  }
  /// Responsive Stacked Horizontal
  bool get responsiveStackedHorizontal => element.classes.contains(C_MAX_MEDIUM_TABLE__STACKED_HORIZONTAL);
  void set responsiveStackedHorizontal (bool newValue) {
    element.classes.remove(C_MAX_MEDIUM_TABLE__STACKED);
    if (newValue)
      element.classes.add(C_MAX_MEDIUM_TABLE__STACKED_HORIZONTAL);
    else
      element.classes.remove(C_MAX_MEDIUM_TABLE__STACKED_HORIZONTAL);
  }

  /// Table bordered
  bool get bordered => element.classes.contains(C_TABLE__BORDERED);
  /// Table bordered
  void set bordered (bool newValue) {
    element.classes.remove(C_TABLE__STRIPED);
    if (newValue) {
      element.classes.add(C_TABLE__BORDERED);
    } else {
      element.classes.remove(C_TABLE__BORDERED);
    }
  }
  /// Table striped
  bool get striped => element.classes.contains(C_TABLE__STRIPED);
  /// Table striped
  void set striped (bool newValue) {
    element.classes.remove(C_TABLE__BORDERED);
    if (newValue) {
      element.classes.add(C_TABLE__STRIPED);
    } else {
      element.classes.remove(C_TABLE__STRIPED);
    }
  }

  /**
   * Add Table Head Row
   * for responsive - use row.addHeader to add name-label info
   */
  LTableRow addHeadRow() {
    if (_thead == null)
      _thead = element.createTHead();
    LTableRow row = new LTableRow(_thead.addRow(), _theadRows.length, idPrefix, null,
        LText.C_TEXT_HEADING__LABEL, rowSelect, nameList, nameLabelMap, LTableRow.TYPE_HEAD);
    if (rowSelect && _theadRows.isEmpty) {
      row.selectCb.onClick.listen((MouseEvent evt) {
        selectAll(row.selectCb.checked);
      });
    }
    _theadRows.add(row);
    return row;
  }

  /// Add Table Body Row
  LTableRow addBodyRow({String rowValue}) {
    if (_tbody == null)
      _tbody = element.createTBody();
    LTableRow row = new LTableRow(_thead.addRow(), _tbodyRows.length, idPrefix, rowValue,
        LButton.C_HINT_PARENT, rowSelect, nameList, nameLabelMap, LTableRow.TYPE_BODY);
    _tbodyRows.add(row);
    return row;
  }

  /// Add Table Foot Row
  LTableRow addFootRow() {
    if (_tfoot == null)
      _tfoot = element.createTFoot();
    LTableRow row = new LTableRow(_thead.addRow(), _tfootRows.length, idPrefix, null,
        LButton.C_HINT_PARENT, rowSelect, nameList, nameLabelMap, LTableRow.TYPE_FOOT);
    _tbodyRows.add(row);
    return row;
  }

  /// Select/Unselect All Body Rows
  void selectAll(bool select) {
    for (LTableRow row in _tbodyRows) {
      row.selected = select;
    }
  }

} // LTable



/**
 * Table Row.
 */
class LTableRow {

  static const String TYPE_HEAD = "H";
  static const String TYPE_BODY = "B";
  static const String TYPE_FOOT = "F";

  /// Table Row
  final TableRowElement element;
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

  /**
   * [rowNo] absolute row number 0..x (in type)
   */
  LTableRow(TableRowElement this.element, int this.rowNo, String idPrefix, String rowValue,
      String cssClass, bool rowSelect,
      List<String> this.nameList, Map<String,String> this.nameLabelMap, String this.type) {
    element.classes.add(cssClass);
    if (rowValue != null)
      element.attributes[Html0.DATA_VALUE] = rowValue;
    if (idPrefix != null)
      element.id = "${idPrefix}-${type}-${rowNo}";


    if (rowSelect) {
      selectCb = new InputElement(type: "checkbox");
      String selectLabel = type == TYPE_HEAD ? lTableRowSelectAll() : "${lTableRowSelectRow()} ${rowNo + 1}";
      LabelElement label = new LabelElement()
        ..classes.add(LCheckbox.C_CHECKBOX);
      label.append(selectCb);
      label.append(new SpanElement()
        ..classes.add(LCheckbox.C_CHECKBOX__FAUX)
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
        element.append(tc);
        tc.append(label);
      } else {
        TableCellElement tc = element.addCell()
          ..classes.add(LTable.C_ROW_SELECT);
        tc.append(label);
      }
    }
  } // LTableRow


  /// Row Selected
  bool get selected => element.classes.contains(LTable.C_IS_SELECTED);
  /// Row Selected
  void set selected (bool newValue) {
    if (newValue) {
      element.classes.add(LTable.C_IS_SELECTED);
    } else {
      element.classes.remove(LTable.C_IS_SELECTED);
    }
    if (selectCb != null)
      selectCb.checked = newValue;
  } // selected


  /**
   * Add Cell with Header Text
   * with [label] of column [name] with optional [value]
   * - name/label are used for responsive
   */
  TableCellElement addCellHeader(String label, String name, {String value, String align}) {
    SpanElement span = new SpanElement()
      ..classes.add(LText.C_TRUNCATE)
      ..text = label == null ? "" : label;
    if (type == TYPE_HEAD
        && name != null && name.isNotEmpty && label != null && label.isNotEmpty) {
      int index = element.children.length;
      while (nameList.length < index)
        nameList.add(null);
      nameList.add(name);
      nameLabelMap[name] = label;
    }
    return addCell(span, name, value, align);
  } // addCellHeader

  /**
   * Add Cell Text
   * with [display] of column [name] with [value]
   */
  TableCellElement addCellText(String display, {String name, String value, String align}) {
    SpanElement span = new SpanElement()
      ..classes.add(LText.C_TRUNCATE)
      ..text = display == null ? "" : display;
    return addCell(span, name, value, align);
  }

  /**
   * Add Cell Link
   * of column [name] with [value]
   */
  TableCellElement addCellLink(AnchorElement a, {String name, String value, String align}) {
    a.classes.add(LText.C_TRUNCATE);
    return addCell(a, name, value, align);
  }

  /**
   * Add Button - no need to set classes
   */
  TableCellElement addCellButton(LButton button) {
    button.classes.addAll([LButton.C_BUTTON__ICON_BORDER_FILLED, LButton.C_BUTTON__ICON_BORDER_SMALL]);
    button.icon.classes.addAll([LButton.C_BUTTON__ICON, LButton.C_BUTTON__ICON__HINT, LButton.C_BUTTON__ICON__SMALL]);

    TableCellElement tc = addCell(button.element, null, null, null);
    tc.classes.add(LTable.C_ROW_ACTION);
    return tc;
  }

  /**
   * with [display] of column [name] with [value]
   * if you not provide the data column [name], it is derived - if found the label is derived (required for responsive)
   * [align] LText.C_TEXT_CENTER LText.C_TEXT_RIGHT
   */
  TableCellElement addCell(Element content, String name, String value, String align) {
    // find column Name
    String theName = name;
    if (theName == null) {
      int index = element.children.length;
      if (nameList.length > index)
        theName = nameList[index];
    }

    TableCellElement tc = null;
    if (type == TYPE_HEAD) {
      tc = document.createElement("th")
        ..attributes["scope"] = "col";
      element.append(tc);
      tc.append(content);
    } else {
      tc = element.addCell();
      tc.append(content);
    }
    if (align != null && align.isNotEmpty)
      element.classes.add(align);

    String label = null;
    if (theName != null) {
      tc.attributes[Html0.DATA_NAME] = theName;
      label = nameLabelMap[theName];
    }
    if (label != null)
      tc.attributes[Html0.DATA_LABEL] = label;
    if (value != null)
      tc.attributes[Html0.DATA_VALUE] = value;
    return tc;
  } // addTableElement



  static String lTableRowSelectAll() => Intl.message("Select All", name: "lTableRowSelectAll", args: []);
  static String lTableRowSelectRow() => Intl.message("Select Row", name: "lTableRowSelectRow", args: []);

} // LTableRow

class LTableCell {




} // LTableCell
