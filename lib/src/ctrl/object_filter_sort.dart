/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;


/**
 * Sort and Group By Table
 */
class ObjectFilterSort extends LComponent {

  static final Logger _log = new Logger("ObjectFilterSort");

  /// Sorting Element
  final DivElement element = new DivElement();
  /// Table
  LTable _table = new LTable("fs");

  /// Provided Sort List
  final List<DSort> sortList;
  /// Table Sort List
  final List<DRecord> sortRecordList = new List<DRecord>();
  /// Meta Table
  final DTable objectTable;


  /**
   * Sort and Group By
   */
  ObjectFilterSort(List<DSort> this.sortList, DTable this.objectTable) {
    _table.editMode = LTable.EDIT_ALL;
    _table.addTableAction(AppsAction.createNew(onAppsActionNew));
    _table.addTableAction(AppsAction.createDeleteSelected(onAppsActionDeleteSelected));
    _table.addRowAction(AppsAction.createDelete(onAppsActionDelete));
    element.append(_table.element);

    _table.setUi(uiSort());
    reset();
  } // ObjectFilterSort

  /// Reset
  void reset() {
    _toRecordList();
    _addNewRecord();
    _table.display(sortRecordList);
  }

  /// Application Action New
  void onAppsActionNew(String value, DRecord record, DEntry entry, var actionVar) {
    _addNewRecord();
    _log.config("onAppsActionNew ${value}  #${sortRecordList.length}");
    _table.display(sortRecordList);
  }

  /// Add New Record at End
  void _addNewRecord() {
    DRecord rec = new DRecord()
      ..tableName = _TABLENAME;
    sortRecordList.add(rec);
  }

  /// Application Action Delete
  void onAppsActionDelete(String value, DRecord record, DEntry entry, var actionVar) {
    if (record != null) {
      sortRecordList.remove(record);
      if (sortRecordList.isEmpty)
        _addNewRecord();
      _log.config("onAppsActionDelete ${value}  #${sortRecordList.length}");
      _table.display(sortRecordList);
    }
  }

  /// Application Action Delete Selected Records
  void onAppsActionDeleteSelected(String value, DRecord record, DEntry entry, var actionVar) {
    List<DRecord> records = _table.selectedRecords;
    int count = 0;
    if (records != null && records.isNotEmpty) {
      for (DRecord sel in records) {
        sortRecordList.remove(sel);
        count++;
      }
    }
    if (sortRecordList.isEmpty)
      _addNewRecord();
    _log.config("onAppsActionDeleteSelected ${value} deleted=${count}  #${sortRecordList.length}");
    _table.display(sortRecordList);
  }

  /// Convert to Records
  void _toRecordList() {
    sortRecordList.clear();
    for (DSort sort in sortList) {
      DRecord record = new DRecord()
        ..tableName = _TABLENAME;
      record.entryList.add(new DEntry()
        ..columnName = _COL_NAME
        ..valueOriginal = sort.columnName
      );
      record.entryList.add(new DEntry()
        ..columnName = _COL_ASC
        ..valueOriginal = sort.isAscending.toString()
      );
      record.entryList.add(new DEntry()
        ..columnName = _COL_GROUP
        ..valueOriginal = sort.isGroupBy.toString()
      );
      sortRecordList.add(record);
    }
  } // toDRecords

  /// Convert to DSort
  List<DSort> updateSortList() {
    sortList.clear();
    DataRecord dd = new DataRecord(null);
    for (DRecord record in sortRecordList) {
      dd.setRecord(record, 0);
      String columnName = dd.getValue(name: _COL_NAME);
      if (columnName == null || columnName.isEmpty)
        continue;
      DSort sort = new DSort()
        ..columnName = columnName;
      if (dd.getValueAsBool(name: _COL_ASC))
        sort.isAscending = true;
      if (dd.getValueAsBool(name: _COL_GROUP))
        sort.isGroupBy = true;
      sortList.add(sort);
    }
    return sortList;
  }


  static const String _TABLENAME = "DSort";
  static const String _COL_NAME = "columnName";
  static const String _COL_ASC = "isAscending";
  static const String _COL_GROUP = "isGroupBy";

  /**
   * Saved Query UI
   */
  UI uiSort() {
    UiUtil uiu = new UiUtil(new UI());
    DTable sqTable = new DTable()
      ..name = _TABLENAME
      ..label = "Sort";
    uiu.setTable(sqTable);
    uiu.addPanel(null);

  // Columns
    DColumn col = new DColumn()
      ..name = _COL_NAME
      ..label = "Column Name"
      ..dataType = DataType.PICK
      ..uniqueSeqNo = 1
      ..displaySeqNo = 1
      ..columnSize = 60
      ..isMandatory = true;
    for (DColumn colOption in objectTable.columnList) {
      DOption option = new DOption()
        ..value = colOption.name
        ..label = colOption.label;
      col.pickValueList.add(option);
    }
    col.pickListSize = col.pickValueList.length;
    uiu.addColumn(col);

    // Columns
    col = new DColumn()
      ..name = _COL_ASC
      ..label = "Ascending"
      ..dataType = DataType.BOOLEAN
      ..isMandatory = false;
    uiu.addColumn(col);

    col = new DColumn()
      ..name = _COL_GROUP
      ..label = "Group By"
      ..dataType = DataType.BOOLEAN
      ..isMandatory = false;
    uiu.addColumn(col);


  return uiu.ui;
  } // uiSort


} // ObjectFilterSort
