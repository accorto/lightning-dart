/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;


/**
 * Sort and Group By Table
 */
class ObjectFilterSort extends TableCtrl {

  static final Logger _log = new Logger("ObjectFilterSort");

  /// Provided Sort List
  final List<DSort> sortList;
  /// Meta Table
  final DTable objectTable;


  /**
   * Sort and Group By
   */
  ObjectFilterSort(List<DSort> this.sortList, DTable this.objectTable)
    : super(idPrefix: "ofs", optionRowSelect:false, optionLayout:false, optionEdit:false, alwaysOneEmptyLine:true) {
    element.classes.add(LMargin.C_TOP__SMALL);
  } // ObjectFilterSort

  /// Add Table/Row Actions
  void addActions() {
    super.addActions();
    addRowAction(AppsAction.createUp(onAppsActionTableUp));
    addRowAction(AppsAction.createDown(onAppsActionTableDown));
  }


  /// Reset
  void reset() {
    _toRecordList();
    addNewRecord();
    display();
  }

  /// Add New Record at End
  DRecord addNewRecord() {
    DRecord rec = super.addNewRecord();
    rec.drv = recordList.length.toString();
    return rec;
  }

  /// Sorting
  void onAppsActionSequence() {
    int seqNo = 1;
    for (DRecord record in recordList) {
      record.drv = seqNo.toString();
      seqNo++;
    }
  }

  /// Convert to Records
  void _toRecordList() {
    recordList.clear();
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
      recordList.add(record);
    }
  } // toDRecords

  /// Convert to DSort
  List<DSort> updateSortList() {
    sortList.clear();
    DataRecord dd = new DataRecord(null);
    for (DRecord record in recordList) {
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
  UI get ui {
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
      ..isMandatory = false;
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
  } // getUI

} // ObjectFilterSort
