/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;


/**
 * Compact Card Entry (Tile)
 * - target: same api as row
 */
class LCardCompactEntry extends LTileGeneric {


  /// The record
  DRecord record;

  final AppsActionTriggered recordAction;

  /**
   * Card Entry
   */
  LCardCompactEntry(String label, {Element button, AppsActionTriggered this.recordAction})
      : super(label) {
    if (button != null) {
      _heading.append(button);
    }
  } // LCardCompactEntry

  /**
   * Card Entry
   */
  LCardCompactEntry.from(DRecord record, {Element button, AppsActionTriggered this.recordAction})
      : super(record.drv) {
    this.record = record;

    element.attributes[Html0.DATA_VALUE] = record.recordId;
    titleLink.href = "#${record.urv}";

    if (button != null) {
      _heading.append(button);
    }
  } // LCardCompactEntry

  void addActions(List<AppsAction> actions, {Object actionReference}) {
    if (_dropdown == null) { // init
      titleLink.onClick.listen((MouseEvent evt) {
        evt.preventDefault();
        recordAction("record", record, null, null);
      });
    }
    super.addActions(actions,
      actionReference: actionReference == null ? record : actionReference);
  }

  void display(UI ui) {
    DataRecord data = new DataRecord(null, value: record);
    for (UIGridColumn gc in ui.gridColumnList) {
      String label = gc.column.label;
      String value = data.getValue(name: gc.columnName);
      // TODO render correctly
      addEntry(label, value, addColonsToLabel: true);
    }
  } // display

} // LCardCompactEntry

