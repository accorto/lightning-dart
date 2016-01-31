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
  static LButton createButton(String idPrefix){
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
  LTableRow row;
  /// Actions for row
  final List<AppsAction> _actions = new List<AppsAction>();

  /**
   * Action Table Cell
   */
  LTableActionCell(TableCellElement element, LButton button, DataColumn dataColumn,
      {String dropdownDirection:LDropdown.C_DROPDOWN__RIGHT})
      : super(element, button.element, "action", null, null, null, dataColumn) {
    this.button = button;
    cellElement.classes.add(LTable.C_ROW_ACTION);
    dropdown = new LDropdown(button, button.id,
        dropdownClasses: [dropdownDirection, LDropdown.C_DROPDOWN__ACTIONS]);
    cellElement.append(dropdown.element);
    dropdown.dropdown.editorChange = onActionChange;
  } // LTableActionCell

  /// Add Action
  void addAction(AppsAction action, {DRecord reference}) {
    _actions.add(action);
    LDropdownItem item = action.asDropdown(false);
    if (row != null)
      item.reference = row.record;
    if (reference != null)
      item.reference = reference;
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
      DRecord record = null;
      if (item.reference is DRecord)
        record = item.reference as DRecord;
      if (record == null && row != null)
        record = row.record;
      if (record != null) {
        _log.fine("onActionChange ${action.value} - ${record.urv}");
      } else {
        _log.info("onActionChange ${action.value} - no record");
      }
      action.callback(action.value, record, null, action.actionVar);
    }
  } // onActionChange

} // LTableActionCell
