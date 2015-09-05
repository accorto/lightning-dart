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
    _action.dropdown.addItem(item);
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
    // label
    AnchorElement label = new AnchorElement(href: "#${record.urv}")
      ..text = record.drv;
    if (recordAction != null) {
      label.onClick.listen((MouseEvent evt) {
        evt.preventDefault();
        recordAction("record", record, null, null);
      });
    }
    // action drop down
    Element actions = null;
    if (_rowActions.isNotEmpty) {
      LButton button = new LButton(new ButtonElement(), "action", null, idPrefix:"row",
        buttonClasses: [LButton.C_BUTTON__ICON_BORDER_FILLED, LButton.C_BUTTON__ICON_BORDER_SMALL, LGrid.C_SHRINK_NONE],
        icon: new LIconUtility(LIconUtility.DOWN, color: LButton.C_BUTTON__ICON__HINT, size: LButton.C_BUTTON__ICON__SMALL),
        assistiveText: AppsAction.appsActions());
      LDropdown dropdown = new LDropdown(button, button.id,
        dropdownClasses: [LDropdown.C_DROPDOWN__RIGHT, LDropdown.C_DROPDOWN__ACTIONS]);
      for (AppsAction action in _rowActions) {
        LDropdownItem item = action.asDropdown(false);
        item.reference = record;
        dropdown.dropdown.addItem(item);
      }
      dropdown.dropdown.editorChange = onActionChange;
      actions = dropdown.element;
    }

    LCardCompactEntry entry = new LCardCompactEntry(label, actions);
    entry.element.attributes[Html0.DATA_VALUE] = record.recordId;
    return _createEntryDetails(entry, record);
  } // createEntry
  /// card detail entries
  LCardCompactEntry _createEntryDetails(LCardCompactEntry entry, DRecord record) {
    DataRecord data = new DataRecord(null, value: record);
    for (UIGridColumn gc in _ui.gridColumnList) {
      String label = gc.column.label;
      String value = data.getValue(name: gc.columnName);
      // TODO render correctly
      entry.addDetail(label, value, addColonsToLabel: true);
    }
    return entry;
  }

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
