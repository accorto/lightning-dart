/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_model;

/// Execute Sorting
typedef bool SortExecuteRemote();

/**
 * Record Sorting - maintains Record Sort Info
 *
 * - query response - updated
 *
 * - table and home call sort() -> executeSort
 *
 * - query request - info set
 *
 */
class RecordSortList {

  static final Logger _log = new Logger("RecordSorting");

  /// Record Sorts
  final List<RecordSort> _sortList = new List<RecordSort>();
  /// Record Sorts
  List<RecordSort> get list => _sortList;

  /// Execute Sorting
  SortExecuteRemote sortExecuteRemote;

  /// Record Sort List
  RecordSortList();


  bool get isEmpty => _sortList.isEmpty;
  bool get isNotEmpty => _sortList.isNotEmpty;

  /// Set From Sorting
  void setFromRequest(DataRequest request) {
    _sortList.clear();
    for (DSort sort in request.querySortList) {
      _sortList.add(new RecordSort(sort));
    }
  }

  /// Clear List
  void clear() {
    _sortList.clear();
  }

  /// Set Sort
  void set(RecordSort sort) {
    _sortList.clear();
    _sortList.add(sort);
  }

  /// Set as first
  void setFirst(RecordSort sort) {
    _sortList.remove(sort);
    _sortList.insert(0, sort);
  }

  /// Add Sort
  void add(RecordSort sort) {
    _sortList.add(sort);
  }

  /// get Record Sort for [columnName] or null
  RecordSort getSort (String columnName) {
    if (_sortList.isNotEmpty && columnName != null && columnName.isNotEmpty) {
      for (RecordSort sort in _sortList) {
        if (sort.sort.columnName == columnName) {
          return sort;
        }
      }
    }
    return null;
  }

  /// Remove Sort Record
  void remove(RecordSort sort) {
    _sortList.remove(sort);
  }

  /// Execute Sort remotely - true if remote
  bool sortRemote() {
    if (_sortList.isEmpty) {
      return false; // no sorting
    }
    if (sortExecuteRemote != null) {
      return sortExecuteRemote(); // data source
    }
    return false;
  }


  /// Local Sort
  void sortRecordList(List<DRecord> recordList) {
    if (recordList != null && recordList.length > 1) {
      _log.config("sortList ${toString()}");
      recordList.sort(recordSortCompare);
    }
  }

  /// Record Sort
  int recordSortCompare(DRecord one, DRecord two) {
    int cmp = 0;
    for (RecordSort sort in list) {
      String columnName = sort.sort.columnName;
      String oneValue = columnName == DataRecord.URV ? one.drv : DataRecord.getColumnValue(one, columnName);
      if (oneValue == null)
        oneValue = "";
      String twoValue = columnName == DataRecord.URV ? two.drv : DataRecord.getColumnValue(two, columnName);
      if (twoValue == null)
        twoValue = "";
      //
      cmp = oneValue.compareTo(twoValue);
      if (DataTypeUtil.isNumber(sort.dataType)) {
        double oneDouble = double.parse(oneValue, (_){ return double.NAN; });
        double twoDouble = double.parse(twoValue, (_){ return double.NAN; });
        cmp = oneDouble.compareTo(twoDouble);
      }
      if (cmp != 0) {
        if (sort.isDescending)
          cmp *= -1;
        break;
      }
    }
    return cmp;
  } // recordSortCompare


  String toString() {
    return _sortList.toString();
  }

} // RecordSortList





/**
 * Record Sort Info
 */
class RecordSort {

  /// Sort Info
  DSort sort;

  /// Record Sort
  RecordSort(DSort this.sort);

  /// Record Sort
  RecordSort.create(String columnName, bool isAscending) {
    sort = new DSort()
      ..columnName = columnName
      ..isAscending = isAscending;
  }


  /// Column Name
  String get columnName => sort.columnName;

  /// ascending
  bool get isAscending => sort.isAscending;
  /// descending
  bool get isDescending => !sort.isAscending;

  /// Column Label
  String get columnLabel => _columnLabel == null ? sort.columnName : _columnLabel;
  void set columnLabel (String newValue) {
    _columnLabel = newValue;
  }
  String _columnLabel;

  /// set label from table column name
  void setLabelFrom(DTable table) {
    String columnName = sort.columnName;
    if (columnName == DataRecord.URV)
      _columnLabel = "record name";
    else {
      for (DColumn col in table.columnList) {
        if (col.name == columnName) {
          _columnLabel = col.label;
          break;
        }
      }
    }
  } // setLabel

  DataType get dataType => _dataType;
  void set dataType (DataType newValue) {
    _dataType = newValue;
  }
  DataType _dataType;

  /// column name : a|d
  String toString() => "${columnName}:${isAscending ? "a" : "d"}";

} // RecordSort
