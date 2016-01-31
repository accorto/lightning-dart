/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Graph Calculation
 */
class StatCalc
    extends StatPoint {

  /// get Record Date
  static DateTime recordDate(String dateString, DColumn dateColumn) {
    if (dateString != null && dateString.isNotEmpty) {
      int time = int.parse(dateString, onError: (String value2) {
        _log.warning("recordDate ${dateColumn.name} invalid=${value2}");
        return null;
      });
      if (time != null) {
        return new DateTime.fromMillisecondsSinceEpoch(time,
            isUtc: dateColumn.dataType == DataType.DATE);
      }
    }
    return null;
  } // recordDate

  static final Logger _log = new Logger("StatCalc");

  /// Count Calculation
  static const String COLUMN_COUNT = "counT";

  final String tableName;
  DColumn column;
  DColumn dateColumn;
  int numPrecision = 0;

  final List<StatBy> byList = new List<StatBy>();

  /**
   * Column Calculation
   */
  StatCalc(String this.tableName, DColumn column)
      : super(column.name, column.label) {
    this.column = column;
    numPrecision = column.decimalDigits;
  }

  /// reset
  void resetCalc(List<StatBy> byList, DColumn dateColumn, ByPeriod byPeriod) {
    byList.clear();
    for (StatBy by in byList) {
      by.byPeriod = byPeriod;
      byList.add(by.clone());
    }
    this.dateColumn = dateColumn;
    this.byPeriod = byPeriod;
    reset(); // total
  } // reset

  /// calculate values from [record]
  void calculateRecord(DRecord record) {
    String dateString = null;
    DateTime date = null;
    if (dateColumn != null) {
      dateString = DataRecord.getColumnValue(record, dateColumn.name);
      date = recordDate(dateString, dateColumn);
    }
    calculateRecord2(record, date, dateString);
  } // calculateRecord

  /// calculate values from [record] for date
  void calculateRecord2(DRecord record, DateTime recordDate, String dateString) {
    // value
    String valueString = DataRecord.getColumnValue(record, key);
    // value
    num valueNum = null;
    if (valueString != null && valueString.isNotEmpty) {
      if (DataTypeUtil.isNumber(column.dataType)) {
        valueNum = double.parse(valueString, (String value2) {
          _log.warning("calculatePoint ${tableName}.${key}(${label}): invalid value=${value2}");
          return null;
        });
      } else if (DataTypeUtil.isDate(column.dataType)) {
        valueNum = int.parse(valueString, onError: (String value2) {
          _log.warning("calculatePoint ${tableName}.${key}(${label}): invalid value=${value2}");
          return null;
        });
      } else if (DataType.BOOLEAN == column.dataType) {
        valueNum = valueString == "true" ? 1 : 0;
      }
    }
    calculatePoint(record, valueNum, valueString, recordDate, dateString);
  } // calculateRecord2

  /**
   * Calculate individual Point
   */
  void calculatePoint(DRecord record,
      num valueNum, String valueString,
      DateTime recordDate, String dateString) {
    //
    calculate(valueNum, valueString, recordDate);
    for (StatBy by in byList) {
      by.calculateRecord(record, valueNum, valueString, recordDate);
    }
  } // calculatePoint

  /// Display
  void dump() {
    _log.info("dump ${tableName}${key} ${label}\n${toStringX('')}"); // updates by labels
  } // dump

  /**
   * Dump Info (updated by labels)
   * - byDateList   (GraphPoint - byDateList[GraphPoint])
   * . byList       (GraphCalc - byList[GraphBy])
   * = byValueList  (GraphBy - byValueList[GraphPoint])

      counT(Display):	 count=118 sum=118.0 min=1.0 max=1.0 avg=1.0 nullCount=0
      - 1435449600000(6/28/2015):	 count=17 sum=17.0 min=1.0 max=1.0 avg=1.0 nullCount=0
      - 1420934400000(1/11/2015):	 count=100 sum=100.0 min=1.0 max=1.0 avg=1.0 nullCount=0
      - 1437868800000(7/26/2015):	 count=1 sum=1.0 min=1.0 max=1.0 avg=1.0 nullCount=0
      . Created(Created):	 count=118 sum=118.0 min=1.0 max=1.0 avg=1.0 nullCount=0
      . - 1435449600000(6/28/2015):	 count=17 sum=17.0 min=1.0 max=1.0 avg=1.0 nullCount=0
      . - 1420934400000(1/11/2015):	 count=100 sum=100.0 min=1.0 max=1.0 avg=1.0 nullCount=0
      . - 1437868800000(7/26/2015):	 count=1 sum=1.0 min=1.0 max=1.0 avg=1.0 nullCount=0
      . = 1421107847000(1421107847000):	 count=2 sum=2.0 min=1.0 max=1.0 avg=1.0 nullCount=0
      . = - 1420934400000(1/11/2015):	 count=2 sum=2.0 min=1.0 max=1.0 avg=1.0 nullCount=0
      :: byValueList of byList(GraphBy) not used

      38:47.660  GraphCalc: display AD_Table.counT Display
      counT(Display):	 count=118 sum=118.0 min=1.0 max=1.0 avg=1.0 nullCount=0
      . TableCategory(Category):	 count=118 sum=118.0 min=1.0 max=1.0 avg=1.0 nullCount=0
      . = ASSOCIATION(Association):	 count=3 sum=3.0 min=1.0 max=1.0 avg=1.0 nullCount=0
      . = BASE(Base):	 count=18 sum=18.0 min=1.0 max=1.0 avg=1.0 nullCount=0
      . = DICTIONARY(Dictionary):	 count=66 sum=66.0 min=1.0 max=1.0 avg=1.0 nullCount=0
      . = REFERENCE(Reference):	 count=22 sum=22.0 min=1.0 max=1.0 avg=1.0 nullCount=0
      . = SETTING2(Setting):	 count=1 sum=1.0 min=1.0 max=1.0 avg=1.0 nullCount=0
      . = TRANSACTION(Transaction):	 count=8 sum=8.0 min=1.0 max=1.0 avg=1.0 nullCount=0

   */
  String toStringX(String linePrefix) {
    String s = "${linePrefix}${super.toStringX(linePrefix)}";
    for (StatBy by in byList) {
      s += "\n" + by.toStringX("${linePrefix}. ");
    }
    return s;
  }

  static String statCalcDate() => Intl.message("Date", name: "statCalcDate");
  static String statCalcNoData() => Intl.message("No Data", name: "statCalcNoData");

} // StatCalc
