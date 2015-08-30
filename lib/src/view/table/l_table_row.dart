/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Table Row
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
      List<String> this.nameList, Map<String,String> this.nameLabelMap, String this.type,
      List<AppsAction> rowActions) {
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
    if (rowActions != null && rowActions.isNotEmpty) {
      addActions(rowActions);
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
      cell = new LTableCell(tc, content, theName, label, value, align);
    } else {
      cell = new LTableCell(element.addCell(), content, theName, label, value, align);
    }
    return cell;
  } // addTableElement

  /**
   * Add Actions
   */
  void addActions(List<AppsAction> actions) {
    if (type == TYPE_HEAD) {
      _actionCell = document.createElement("th")
        ..attributes["scope"] = "col";
      element.append(_actionCell);
    } else {
      _actionCell = element.addCell();
    }
    _actionCell.classes.add(LTable.C_ROW_ACTION);
    LButton btn = new LButton.iconBorderFilled("action", new LIconUtility(LIconUtility.DOWN), AppsAction.appsActions());
    LDropdown dropdown = new LDropdown(btn, "xx", dropdownClasses: [LDropdown.C_DROPDOWN__RIGHT, LDropdown.C_DROPDOWN__ACTIONS]);
    _actionCell.append(dropdown.element);
    for (AppsAction action in actions) {
      dropdown.dropdown.addItem(action.asDropdown());
    }
  }
  TableCellElement _actionCell;

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
      this.tableSortClicked, List<AppsAction> tableActions)
    : super (element, rowNo, idPrefix, null, cssClass, rowSelect, nameList, nameLabelMap,
        LTableRow.TYPE_HEAD, tableActions);

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
    return new LTableHeaderCell(tc, span, name, label, value, align, tableSortClicked);
  } // addHeaderCell

} // LTableHeaderRow

