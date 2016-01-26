/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_model;

/// Execute Sorting
typedef bool SortExecute();

/// Sort was executed locally or needs to go to server
typedef void SortResult(bool sortedLocally);

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
class RecordSorting {

  static final Logger _log = new Logger("RecordSorting");

  /// Record Sorts
  final List<RecordSort> list = new List<RecordSort>();

  /// Execute Sorting
  SortExecute sortExecute;
  /// Execute Sorting
  SortResult sortResult;

  /// Record Sort List
  RecordSorting();

  bool get isEmpty => list.isEmpty;
  bool get isNotEmpty => list.isNotEmpty;

  /// Set From Sorting
  void setFromRequest(DataRequest request) {
    list.clear();
    for (DSort sort in request.querySortList) {
      list.add(new RecordSort(sort));
    }
  }

  /// Clear List
  void clear() {
    list.clear();
  }

  /// Set Sort
  void set(RecordSort sort) {
    list.clear();
    list.add(sort);
  }

  /// Add Sort
  void add(RecordSort sort) {
    list.add(sort);
  }

  /// get Record Sort for [columnName] or null
  RecordSort getSort (String columnName) {
    if (list.isNotEmpty && columnName != null && columnName.isNotEmpty) {
      for (RecordSort sort in list) {
        if (sort.sort.columnName == columnName) {
          return sort;
        }
      }
    }
    return null;
  }

  /// Remove Sort Record
  void remove(RecordSort sort) {
    list.remove(sort);
  }

  /// Execute Sort
  bool sort() {
    bool sortedLocally = null;
    if (list.isEmpty) {
      _log.info("sort - no entries");
      sortedLocally = true; // no need
    } else {
      if (sortExecute != null) {
        sortedLocally = sortExecute(); // data source
      }
    }
    if (sortResult != null && sortedLocally != null) {
      sortResult(sortedLocally);
    }
    return sortedLocally;
  }


  /// Local Sort
  void sortList(List<DRecord> recordList) {
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
      cmp = oneValue.compareTo(twoValue);
      if (cmp != 0) {
        if (sort.isDescending)
          cmp *= -1;
        break;
      }
    }
    return cmp;
  } // recordSortCompare


  String toString() {
    return list.toString();
  }


} // RecordSorting





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

  /// column name : a|d
  String toString() => "${columnName}:${isAscending ? "a" : "d"}";

} // RecordSort
