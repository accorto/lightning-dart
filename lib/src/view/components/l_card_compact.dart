/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Compact Card - container for Tiles
 * - same API as Table
 */
class LCardCompact extends LCard {

  static final Logger _log = new Logger("LCardCompact");

  /// Card Container actions
  LDropdown _action;
  /// Content List
  final UListElement _list = new UListElement();

  /// UI Meta Data
  UI _ui;
  /// Actions
  final List<AppsAction> _rowActions = new List<AppsAction>();


  /**
   * Compact Card
   */
  LCardCompact(String idPrefix)
  : super(idPrefix) {
    element.classes.add(LCard.C_CARD__COMPACT);
    _body.append(_list);
  }

  /// Set Header
  void setUi(UI ui) {
    _ui = ui;
    _createHeader();
  } // setUi

  /// recreate Header
  void _createHeader() {
    LIcon icon = null;
    String label = _ui.table.label;
    setHeader(icon, label, action:_action);
  }

  /**
   * Add Table (Card) Action
   */
  void addTableAction(AppsAction action) {
    if (_action == null) {
        LButton button = new LButton(new ButtonElement(), "action", null, idPrefix:"row",
          buttonClasses: [LButton.C_BUTTON__ICON_BORDER_FILLED],
          icon: new LIconUtility(LIconUtility.DOWN),
          assistiveText: AppsAction.appsActions());
      _action = new LDropdown(button, button.id,
        dropdownClasses: [LDropdown.C_DROPDOWN__RIGHT, LDropdown.C_DROPDOWN__ACTIONS]);
      _createHeader();
    }
    LDropdownItem item = action.asDropdown(true);
    _action.dropdown.addDropdownItem(item);
  } // addTableAction

  /**
   * Add Row (Card Entry) Action
   */
  void addRowAction(AppsAction action) {
    _rowActions.add(action);
  }

  /// Set Records - [recordAction] click on drv/urv
  void display(List<DRecord> records, {AppsActionTriggered recordAction}) {
    clearEntries();
    int i = 0;
    for (DRecord record in records) {
      LCardCompactEntry entry = _createEntry(record, i++, recordAction);
      addEntry(entry);
    }
  } // display


  /**
   * Create Card Entry
   */
  LCardCompactEntry _createEntry(DRecord record, int rowNo, AppsActionTriggered recordAction) {
    // action drop down
    LCardCompactEntry entry = new LCardCompactEntry.from(record, recordAction:recordAction);
    entry.addActions(_rowActions);
    entry.display(_ui);
    return entry;
  } // createEntry


  /// Dropdown Row Action Change
  void onActionChange(String name, String actionName, DEntry entry, LDropdownItem details) {
    // see LTableActionCell
    AppsAction action = null;
    for (AppsAction aa in _rowActions) {
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
      if (details.reference is DRecord)
        record = details.reference as DRecord;
      if (record != null) {
        _log.fine("onActionChange ${action.value} - ${record.urv}");
        action.callback(action.value, record, null, action.actionVar);
      } else {
        _log.info("onActionChange ${action.value} - no record");
      }
    }
  } // onActionChange


  /**
   * Add to the Body
   */
  void addEntry(LCardCompactEntry entry) {
    _list.append(entry.element);
  }

  /// clear body entries
  void clearEntries() {
    _list.children.clear();
  }

} // LCardCompact
