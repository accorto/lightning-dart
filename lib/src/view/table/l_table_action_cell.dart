/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Table Action Cell (head/tbody)
 */
class LTableActionCell
    extends LTableCell {

  static final Logger _log = new Logger("LTableActionCell");

  /// create action button
  static LButton _createButton(String idPrefix){
    return new LButton(new ButtonElement(), "action", null, idPrefix:idPrefix,
        buttonClasses: [LButton.C_BUTTON__ICON_BORDER_FILLED, LButton.C_BUTTON__ICON_X_SMALL],
        icon: new LIconUtility(LIconUtility.DOWN, color: LButton.C_BUTTON__ICON__HINT, size: LButton.C_BUTTON__ICON__SMALL),
        assistiveText: AppsAction.appsActions());
  }

  /// The Button
  LButton button;
  /// The Dropdown
  LDropdown dropdown;
  /// Parent Row
  final LTableRow row;
  /// Actions for row
  final List<AppsAction> _actions = new List<AppsAction>();

  /**
   * Action Table Cell
   */
  LTableActionCell(LTableRow this.row, TableCellElement element,
      LButton btn, bool atEnd)
      : super(element, btn.element, "action", null, null, null, null, false) {
    this.button = btn;
    cellElement.classes.add(LTable.C_CELL_SHRINK);

    dropdown = new LDropdown(button, button.id,
        dropdownClasses: [atEnd ? LDropdown.C_DROPDOWN__RIGHT : LDropdown.C_DROPDOWN__LEFT,
          LDropdown.C_DROPDOWN__ACTIONS]);
    cellElement.append(dropdown.element);
    dropdown.dropdown.editorChange = onActionChange;
  } // LTableActionCell

  /// Add Action
  void addAction(AppsAction action) {
    _actions.add(action);
    LDropdownItem item = action.asDropdown(false, recreate: true);
    dropdown.dropdown.addDropdownItem(item);
  }

  /// Dropdown Row Action Change
  void onActionChange(String name, String actionName, DEntry entry, LDropdownItem item) {
    // see LCardCompact
    AppsAction action = null;
    for (AppsAction aa in _actions) {
      if (aa.value == actionName) {
        action = aa;
        break;
      }
    }
    if (action == null) {
      _log.warning("onActionChange NotFound=${actionName}");
    } else if (action.callback == null) {
      _log.info("onActionChange ${action.value} - no callback");
    } else {
      DataRecord data = action.data;
      if (data == null && row != null)
        data = row.data;
      if (data != null) {
        _log.fine("onActionChange ${action.value} - ${data}");
      } else {
        _log.info("onActionChange ${action.value} - no record");
      }
      var actionVar = action.actionVar;
      if (actionVar == null)
        actionVar = row;
      action.callback(action.value, data, null, actionVar);
    }
  } // onActionChange

} // LTableActionCell
