/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Table
 */
class LTable extends LComponent {

  /// slds-table - Initializes data table | Required
  static const String C_TABLE = "slds-table";
  /// slds-table--bordered - Adds borders to the table |
  static const String C_TABLE__BORDERED = "slds-table--bordered";
  /// slds-table--striped - Adds stripes to alternating rows |
  static const String C_TABLE__STRIPED = "slds-table--striped";
  /// slds-is-selected - Changes row to selected state |
  static const String C_IS_SELECTED = "slds-is-selected";
  /// slds-is-sortable - Enables user interactions for sorting a column |
  static const String C_IS_SORTABLE = "slds-is-sortable";
  /// slds-cell-wrap - Forces text to wrap in a cell |
  static const String C_CELL_WRAP = "slds-cell-wrap";
  /// slds-cell-shrink - Shrinks cell to width of content |
  static const String C_CELL_SHRINK = "slds-cell-shrink";
  /// slds-no-row-hover - Removes hover state on row |
  static const String C_NO_ROW_HOVER = "slds-no-row-hover";
  /// slds-max-medium-table--stacked - Modifies table layout to accommodate smaller viewports |
  static const String C_MAX_MEDIUM_TABLE__STACKED = "slds-max-medium-table--stacked";
  /// slds-max-medium-table--stacked-horizontal - Modifies table layout to accommodate smaller viewports |
  static const String C_MAX_MEDIUM_TABLE__STACKED_HORIZONTAL = "slds-max-medium-table--stacked-horizontal";
  /// slds-hint-parent - Highlights action overflow ribbons on row hover |
  static const String C_HINT_PARENT = "slds-hint-parent";

  static const String C_ROW_SELECT = "slds-row-select";
  static const String C_ROW_ACTION = "slds-row-action";


  /// Table Element
  final TableElement element = new TableElement()
    ..classes.add(C_TABLE);

  TableSectionElement _thead;
  TableSectionElement _tbody;
  TableSectionElement _tfoot;
  final List<LTableHeaderRow> _theadRows = new List<LTableHeaderRow>();
  final List<LTableRow> _tbodyRows = new List<LTableRow>();
  final List<LTableRow> _tfootRows = new List<LTableRow>();

  final bool rowSelect;

  /// Column Name-Label Map - required for responsive
  final Map<String,String> nameLabelMap = new Map<String,String>();
  /// Name list by column #
  final List<String> nameList = new List<String>();

  /**
   * Table
   */
  LTable(String idPrefix, bool this.rowSelect) {
    element.id = idPrefix == null || idPrefix.isEmpty ? LComponent.createId("table", null) : idPrefix;
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
   * for responsive - use row.addHeaderCell to add name-label info
   */
  LTableRow addHeadRow() {
    if (_thead == null)
      _thead = element.createTHead();
    LTableHeaderRow row = new LTableHeaderRow(_thead.addRow(), _theadRows.length, id,
        LText.C_TEXT_HEADING__LABEL, rowSelect, nameList, nameLabelMap);
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
    LTableRow row = new LTableRow(_thead.addRow(), _tbodyRows.length, id, rowValue,
        LButton.C_HINT_PARENT, rowSelect, nameList, nameLabelMap, LTableRow.TYPE_BODY);
    _tbodyRows.add(row);
    return row;
  }

  /// Add Table Foot Row
  LTableRow addFootRow() {
    if (_tfoot == null)
      _tfoot = element.createTFoot();
    LTableRow row = new LTableRow(_thead.addRow(), _tfootRows.length, id, null,
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



  static String lTableRowSelectAll() => Intl.message("Select All", name: "lTableRowSelectAll", args: []);
  static String lTableRowSelectRow() => Intl.message("Select Row", name: "lTableRowSelectRow", args: []);

  static String lTableColumnSortAsc() => Intl.message("Sort Ascending", name: "lTableColumnSortAsc", args: []);
  static String lTableColumnSortDec() => Intl.message("Sort Decending", name: "lTableColumnSortDec", args: []);

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
   * Add Cell Text
   * with [display] of column [name] with [value]
   */
  LTableCell addCellText(String display, {String name, String value, String align}) {
    SpanElement span = new SpanElement()
      ..classes.add(LText.C_TRUNCATE)
      ..text = display == null ? "" : display;
    return addCell(span, name, value, align);
  }

  /**
   * Add Cell Link
   * of column [name] with [value]
   */
  LTableCell addCellLink(AnchorElement a, {String name, String value, String align}) {
    a.classes.add(LText.C_TRUNCATE);
    return addCell(a, name, value, align);
  }

  /**
   * Add Button - no need to set classes
   */
  LTableCell addCellButton(LButton button) {
    button.classes.addAll([LButton.C_BUTTON__ICON_BORDER_FILLED, LButton.C_BUTTON__ICON_BORDER_SMALL]);
    button.icon.classes.addAll([LButton.C_BUTTON__ICON, LButton.C_BUTTON__ICON__HINT, LButton.C_BUTTON__ICON__SMALL]);

    LTableCell tc = addCell(button.element, null, null, null);
    tc.element.classes.add(LTable.C_ROW_ACTION);
    return tc;
  }

  /**
   * with [display] of column [name] with [value]
   * if you not provide the data column [name], it is derived - if found the label is derived (required for responsive)
   * [align] LText.C_TEXT_CENTER LText.C_TEXT_RIGHT
   */
  LTableCell addCell(Element content, String name, String value, String align) {
    // find column Name
    String theName = name;
    if (theName == null) {
      int index = element.children.length;
      if (nameList.length > index)
        theName = nameList[index];
    }
    // find column label
    String label = null;
    if (theName != null) {
      label = nameLabelMap[theName];
    }

    LTableCell cell = null;
    if (type == TYPE_HEAD) {
      TableCellElement tc = document.createElement("th")
        ..attributes["scope"] = "col";
      element.append(tc);
      cell = new LTableHeaderCell(tc, content, theName, label, value, align);
    } else {
      cell = new LTableCell(element.addCell(), content, theName, label, value, align);
    }
    return cell;
  } // addTableElement

} // LTableRow


/**
 * Table Header Row
 */
class LTableHeaderRow extends LTableRow {

  /**
   * Table Header Row
   */
  LTableHeaderRow(TableRowElement element, int rowNo, String idPrefix,
        String cssClass, bool rowSelect,
        List<String> nameList, Map<String,String> nameLabelMap)
    : super (element, rowNo, idPrefix, null, cssClass, rowSelect, nameList, nameLabelMap, LTableRow.TYPE_HEAD);

  /**
   * Add Cell with Header Text
   * with [label] of column [name] with optional [value]
   * - name/label are used for responsive
   */
  LTableHeaderCell addHeaderCell(String label, String name, {String value, String align}) {
    SpanElement span = new SpanElement()
      ..classes.add(LText.C_TRUNCATE)
      ..text = label == null ? "" : label;

    if (name != null && name.isNotEmpty && label != null && label.isNotEmpty) {
      int index = element.children.length;
      while (nameList.length < index)
        nameList.add(null);
      nameList.add(name);
      nameLabelMap[name] = label;
    }

    TableCellElement tc = document.createElement("th")
      ..attributes["scope"] = "col";
    element.append(tc);
    return new LTableHeaderCell(tc, span, name, label, value, align);
  } // addHeaderCell

} // LTableHeaderRow


/**
 * Table Cell
 */
class LTableCell {

  /// td/th
  final TableCellElement element;

  /**
   * Table Cell
   */
  LTableCell(TableCellElement this.element, Element content, String name, String label, String value, String align) {
    if (align != null && align.isNotEmpty)
      element.classes.add(align);

    if (name != null)
      element.attributes[Html0.DATA_NAME] = name;
    if (label != null)
      element.attributes[Html0.DATA_LABEL] = label;
    if (value != null)
      element.attributes[Html0.DATA_VALUE] = value;
    element.append(content);
  } // LTableCell

} // TableCell



/**
 * Table Header Cell
 */
class LTableHeaderCell extends LTableCell {

  /**
   * Table Header Cell
   */
  LTableHeaderCell(TableCellElement element, Element content, String name, String label, String value, String align)
      : super(element, content, name, label, value, align) {
  //  element.attributes["scope"] = "col";
  }

  /// Sortable
  bool get sortable => element.classes.contains(LTable.C_IS_SORTABLE);
  void set sortable (bool newValue) {
    if (newValue) {
      element.classes.add(LTable.C_IS_SORTABLE);
      if (sortAsc == null)
        sortAsc = true;
    } else {
      element.classes.remove(LTable.C_IS_SORTABLE);
    }
  }

  /// Sort Direction
  bool get sortAsc => _sortAsc != null && _sortAsc;
  void set sortAsc (bool newValue) {
    // ensure th class
    if (!element.classes.contains(LTable.C_IS_SORTABLE))
      element.classes.add(LTable.C_IS_SORTABLE);
    _sortAsc = newValue;
    if (_sortButton == null) {
      _sortButton = new LButton.iconBare("sort-",
        new LIconUtility(LIconUtility.ARROWDOWN, className: LButton.C_BUTTON__ICON, size: LIcon.C_ICON__SMALL),
        LTable.lTableColumnSortDec());
      element.append(_sortButton.element);
    }
    if (_sortAsc) {
      _sortButton.icon.linkName = LIconUtility.ARROWDOWN;
      _sortButton.assistiveText = LTable.lTableColumnSortDec();
    } else {
      _sortButton.icon.linkName = LIconUtility.ARROWUP;
      _sortButton.assistiveText = LTable.lTableColumnSortAsc();
    }
  }
  bool _sortAsc;
  LButton _sortButton;

} // LTableHeaderCell
