/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Table Cell
 */
class LTableCell {

  /// td/th
  final TableCellElement cellElement;

  /**
   * Table Cell
   */
  LTableCell(TableCellElement this.cellElement, Element content, String name, String label, String value, String align) {
    if (align != null && align.isNotEmpty)
      cellElement.classes.add(align);

    if (name != null)
      cellElement.attributes[Html0.DATA_NAME] = name;
    if (label != null)
      cellElement.attributes[Html0.DATA_LABEL] = label;
    if (value != null)
      cellElement.attributes[Html0.DATA_VALUE] = value;
    cellElement.append(content);
  } // LTableCell

} // TableCell

/**
 * Table Action Cell (head/tbody)
 */
class LTableActionCell extends LTableCell {

  static final Logger _log = new Logger("LTableActionCell");

  /// create action button
  static LButton createButton(String idPrefix){
    return new LButton(new ButtonElement(), "action", null, idPrefix:idPrefix,
      buttonClasses: [LButton.C_BUTTON__ICON_BORDER_FILLED, LButton.C_BUTTON__ICON_BORDER_SMALL],
      icon: new LIconUtility(LIconUtility.DOWN, color: LButton.C_BUTTON__ICON__HINT, size: LButton.C_BUTTON__ICON__SMALL),
      assistiveText: AppsAction.appsActions());
  }

  /// The Button
  LButton button;
  /// The Dropdown
  LDropdown dropdown;
  /// Parent Row
  LTableRow row;
  /// Actions for row
  final List<AppsAction> _actions = new List<AppsAction>();

  /**
   * Action Table Cell
   */
  LTableActionCell(TableCellElement element, LButton button)
      : super(element, button.element, "action", null, null, null) {
    this.button = button;
    cellElement.classes.add(LTable.C_ROW_ACTION);
    dropdown = new LDropdown(button, button.id,
      dropdownClasses: [LDropdown.C_DROPDOWN__RIGHT, LDropdown.C_DROPDOWN__ACTIONS]);
    cellElement.append(dropdown.element);
    dropdown.dropdown.editorChange = onActionChange;
  } // LTableActionCell

  /// Add Action
  void addAction(AppsAction action) {
    _actions.add(action);
    LDropdownItem item = action.asDropdown();
    dropdown.dropdown.addItem(item);
  }

  void onActionChange(String name, String actionName, DEntry entry, LDropdownItem details) {
    AppsAction action = null;
    for (AppsAction aa in _actions) {
      if (aa.value == actionName) {
        action = aa;
        break;
      }
    }
    details.selected = false;
    if (action == null) {
      _log.warning("onActionChange NotFound=${actionName}");
    } else if (action.callback == null) {
      _log.info("onActionChange ${action.value} - no callback");
    } else {
      DRecord record = null;
      if (row != null && row.record != null) {
        record = row.record;
        _log.fine("onActionChange ${action.value} - ${record.urv}");
      } else {
        _log.fine("onActionChange ${action.value}");
      }
      action.callback(action.value, record, null);
    }
  } // onActionChange

} // LTableActionCell



/**
 * Table Header Cell
 */
class LTableHeaderCell extends LTableCell {

  /**
   * Table Header Cell
   */
  LTableHeaderCell(TableCellElement element, Element content, String name, String label, String value, String align,
        TableSortClicked tableSortClicked)
    : super(element, content, name, label, value, align) {
    // set before element.attributes["scope"] = "col";
    if (tableSortClicked != null) {
      sortable = true;
      sortAsc = true;
      element.onClick.listen((Event evt) {
        sortAsc = !sortAsc; // toggle
        tableSortClicked(name, sortAsc);
      });
    }
  }

  /// Sortable
  bool get sortable => cellElement.classes.contains(LTable.C_IS_SORTABLE);
  void set sortable (bool newValue) {
    if (newValue) {
      cellElement.classes.add(LTable.C_IS_SORTABLE);
      if (sortAsc == null)
        sortAsc = true;
    } else {
      cellElement.classes.remove(LTable.C_IS_SORTABLE);
    }
  }

  /// Sort Direction
  bool get sortAsc => _sortAsc != null && _sortAsc;
  void set sortAsc (bool newValue) {
    // ensure th class
    if (!cellElement.classes.contains(LTable.C_IS_SORTABLE))
      cellElement.classes.add(LTable.C_IS_SORTABLE);
    _sortAsc = newValue;
    _addSort();
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

  /// Add Sort button
  void _addSort() {
    if (_sortButton == null) {
      _sortButton = new LButton.iconBare("sort-",
        new LIconUtility(LIconUtility.ARROWDOWN, className: LButton.C_BUTTON__ICON, size: LButton.C_BUTTON__ICON__SMALL),
        LTable.lTableColumnSortDec());
      cellElement.append(_sortButton.element);
    }
  }

} // LTableHeaderCell

