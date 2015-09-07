/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;


/**
 * Table Controller
 */
abstract class TableCtrl extends LComponent {

  static final Logger _log = new Logger("TableCtrl");


  /// Filter Element
  final DivElement element = new DivElement();
  /// Table
  final LTable _table = new LTable("ot");
  /// Record Sort List
  final List<DRecord> recordList = new List<DRecord>();

  final bool alwaysOneEmptyLine;

  /**
   * Object Table
   */
  TableCtrl({String idPrefix,
      bool rowSelect:true,
      String editMode: LTable.EDIT_ALL,
      bool this.alwaysOneEmptyLine:false}) {
    if (idPrefix != null && idPrefix.isNotEmpty)
      _table.element.id = idPrefix;
    _table.rowSelect = rowSelect;
    _table.editMode = editMode;
    _table.addTableAction(AppsAction.createNew(onAppsActionNew));
    if (rowSelect)
      _table.addTableAction(AppsAction.createDeleteSelected(onAppsActionDeleteSelected));
    _table.addRowAction(AppsAction.createDelete(onAppsActionDelete));
    element.append(_table.element);

    _table.setUi(getUI());
    reset();
  } // ObjectTable

  /// Reset
  void reset() {
    // recordList.clear(); // override
    if (alwaysOneEmptyLine)
      _addNewRecord();
    _table.display(recordList);
  }

  /// Application Action New
  void onAppsActionNew(String value, DRecord record, DEntry entry, var actionVar) {
    _addNewRecord();
    _log.config("onAppsActionNew ${value}  #${recordList.length}");
    _table.display(recordList);
  }

  /// Add New Record at End
  void _addNewRecord();

  /// Application Action Delete
  void onAppsActionDelete(String value, DRecord record, DEntry entry, var actionVar) {
    if (record != null) {
      recordList.remove(record);
      if (alwaysOneEmptyLine && recordList.isEmpty)
        _addNewRecord();
      _log.config("onAppsActionDelete ${value}  #${recordList.length}");
      _table.display(recordList);
    }
  } // onAppsActionDelete

  /// Application Action Delete Selected Records
  void onAppsActionDeleteSelected(String value, DRecord record, DEntry entry, var actionVar) {
    List<DRecord> records = _table.selectedRecords;
    int count = 0;
    if (records != null && records.isNotEmpty) {
      for (DRecord sel in records) {
        recordList.remove(sel);
        count++;
      }
    }
    if (alwaysOneEmptyLine && recordList.isEmpty)
      _addNewRecord();
    _log.config("onAppsActionDeleteSelected ${value} deleted=${count}  #${recordList.length}");
    _table.display(recordList);
  } // onAppsActionDeleteSelected



  /// Get UI
  UI getUI();

} // ObjectTable
