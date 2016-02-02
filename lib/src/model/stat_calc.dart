/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_model;

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
  static const String COUNT_COLUMN_NAME = "counT";
  /// Count Column
  static final DColumn COUNT_COLUMN = new DColumn()
    ..name = COUNT_COLUMN_NAME
    ..label = statCalcWhatCount()
    ..dataType = DataType.INT;

  final String tableName;

  final List<StatBy> byList = new List<StatBy>();
  List<StatMatch> _matchList;

  /**
   * Column Calculation
   */
  StatCalc(String this.tableName, DColumn column)
      : super(column.name, column.label) {
    this.column = column;
  }

  /// Data Type
  DataType get dataType => column.dataType;

  /// Decimal Digits (see LInputNumber)
  int get decimalDigits {
    if (column.hasDecimalDigits()) {
      return column.decimalDigits; // explicit
    }
    if (dataType == DataType.AMOUNT || dataType == DataType.CURRENCY) {
      return  2;
    }
    if (dataType == DataType.QUANTITY || dataType == DataType.DECIMAL) {
      return 1;
    }
    if (dataType == DataType.NUMBER) { // float
      return 3;
    }
    // DataType.INT, DataType.RATING
    return 0;
  } // decimalDigits


  /// reset
  void resetCalc(List<StatBy> byList, List<StatMatch> matchList,
      DColumn dateColumn, ByPeriod byPeriod) {
    this.byList.clear();
    for (StatBy by in byList) {
      by.byPeriod = byPeriod;
      this.byList.add(by.clone());
    }
    _matchList = matchList;
    //
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
    if (key == COUNT_COLUMN_NAME) {
      calculatePoint(record, null, COUNT_COLUMN_NAME, recordDate, dateString);
    } else {
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
    }
  } // calculateRecord2

  /**
   * Calculate individual Point
   */
  void calculatePoint(DRecord record,
      num valueNum, String valueString,
      DateTime recordDate, String dateString) {

    if (_match(record, valueNum, valueString, recordDate, dateString)) {
      calculate(valueNum, valueString, recordDate);
      for (StatBy by in byList) {
        by.calculateRecord(record, valueNum, valueString, recordDate);
      }
    } else {
      _log.finer("calculatePoint ${key} NoMatch value=${valueNum} ${recordDate}");
    }
  } // calculatePoint

  /**
   * Match Records
   */
  bool _match(DRecord record,
      num valueNum, String valueString, DateTime recordDate, String dateString) {
    for (StatMatch match in _matchList) {
      // restrict value
      if (match.columnName == key) {
        if (!match.valueMatch(valueNum, valueString)) {
          return false;
        }
      }
      else if (match.columnName == dateColumn.name) {
        if (!match.dateMatch(recordDate, dateString)) {
          return false;
        }
      }
      else if (!match.recordMatch(record)) {
        return false;
      }
    }
    return true;
  } // match


  /// Display details (fine)
  void dump() {
    String info = "dump ${tableName}.${key} (${label})";
    if (dateColumn != null)
      info += " ${dateColumn.name} ${byPeriod}";
    info += "\n${toStringX('')}"; // updates by label
    _log.fine(info);
  } // dump

  /**
   * Dump Info (updated by labels)
   * - byDateList   (GraphPoint - byDateList[GraphPoint])
   * . byList       (GraphCalc - byList[GraphBy])
   * = byValueList  (GraphBy - byValueList[GraphPoint])

      StatCalc: dump demo.counT (Count)
      counT(Count):	 count=7 sum=- min=- max=- avg=- nulls=0
      . status(Status):	 count=7 sum=- min=- max=- avg=- nulls=0
      . = (-None-):	 count=1 sum=- min=- max=- avg=- nulls=0
      . = due(Due):	 count=2 sum=- min=- max=- avg=- nulls=0
      . = new(New):	 count=2 sum=- min=- max=- avg=- nulls=0
      . = paid(Paid):	 count=2 sum=- min=- max=- avg=- nulls=0

      StatCalc: dump demo.amount (Amount)
      amount(Amount):	 count=7 sum=176.1 min=2.3 max=52.3 avg=25.2 nulls=0
      . status(Status):	 count=7 sum=176.1 min=2.3 max=52.3 avg=25.2 nulls=0
      . = (-None-):	 count=1 sum=32.3 min=32.3 max=32.3 avg=32.3 nulls=0
      . = due(Due):	 count=2 sum=54.6 min=12.3 max=42.3 avg=27.3 nulls=0
      . = new(New):	 count=2 sum=64.6 min=12.3 max=52.3 avg=32.3 nulls=0
      . = paid(Paid):	 count=2 sum=24.6 min=2.3 max=22.3 avg=12.3 nulls=0

      StatCalc: dump demo.amount (Amount) date ByPeriod.Week
      amount(Amount):	 count=7 sum=176.1 min=2.3 max=52.3 avg=25.2 nulls=0
      - 1419724800000(12/28/2014):	 count=1 sum=12.3 min=12.3 max=12.3 avg=12.3 nulls=0
      - 1420329600000(1/4/2015):	 count=2 sum=24.6 min=2.3 max=22.3 avg=12.3 nulls=0
      - 1422748800000(2/1/2015):	 count=2 sum=54.6 min=12.3 max=42.3 avg=27.3 nulls=0
      - 1423353600000(2/8/2015):	 count=1 sum=52.3 min=52.3 max=52.3 avg=52.3 nulls=0
      - 1433030400000(5/31/2015):	 count=1 sum=32.3 min=32.3 max=32.3 avg=32.3 nulls=0
      . status(Status):	 count=7 sum=176.1 min=2.3 max=52.3 avg=25.2 nulls=0
      . - 1419724800000(12/28/2014):	 count=1 sum=12.3 min=12.3 max=12.3 avg=12.3 nulls=0
      . - 1420329600000(1/4/2015):	 count=2 sum=24.6 min=2.3 max=22.3 avg=12.3 nulls=0
      . - 1422748800000(2/1/2015):	 count=2 sum=54.6 min=12.3 max=42.3 avg=27.3 nulls=0
      . - 1423353600000(2/8/2015):	 count=1 sum=52.3 min=52.3 max=52.3 avg=52.3 nulls=0
      . - 1433030400000(5/31/2015):	 count=1 sum=32.3 min=32.3 max=32.3 avg=32.3 nulls=0
      . = (-None-):	 count=1 sum=32.3 min=32.3 max=32.3 avg=32.3 nulls=0
      . = - 1433030400000(5/31/2015):	 count=1 sum=32.3 min=32.3 max=32.3 avg=32.3 nulls=0
      . = due(Due):	 count=2 sum=54.6 min=12.3 max=42.3 avg=27.3 nulls=0
      . = - 1422748800000(2/1/2015):	 count=2 sum=54.6 min=12.3 max=42.3 avg=27.3 nulls=0
      . = new(New):	 count=2 sum=64.6 min=12.3 max=52.3 avg=32.3 nulls=0
      . = - 1419724800000(12/28/2014):	 count=1 sum=12.3 min=12.3 max=12.3 avg=12.3 nulls=0
      . = - 1423353600000(2/8/2015):	 count=1 sum=52.3 min=52.3 max=52.3 avg=52.3 nulls=0
      . = paid(Paid):	 count=2 sum=24.6 min=2.3 max=22.3 avg=12.3 nulls=0
      . = - 1420329600000(1/4/2015):	 count=2 sum=24.6 min=2.3 max=22.3 avg=12.3 nulls=0

      StatCalc: dump demo.counT (Count) date ByPeriod.Week
      counT(Count):	 count=7 sum=- min=- max=- avg=- nulls=0
      - 1419724800000(12/28/2014):	 count=1 sum=- min=- max=- avg=- nulls=0
      - 1420329600000(1/4/2015):	 count=2 sum=- min=- max=- avg=- nulls=0
      - 1422748800000(2/1/2015):	 count=2 sum=- min=- max=- avg=- nulls=0
      - 1423353600000(2/8/2015):	 count=1 sum=- min=- max=- avg=- nulls=0
      - 1433030400000(5/31/2015):	 count=1 sum=- min=- max=- avg=- nulls=0
      . status(Status):	 count=7 sum=- min=- max=- avg=- nulls=0
      . - 1419724800000(12/28/2014):	 count=1 sum=- min=- max=- avg=- nulls=0
      . - 1420329600000(1/4/2015):	 count=2 sum=- min=- max=- avg=- nulls=0
      . - 1422748800000(2/1/2015):	 count=2 sum=- min=- max=- avg=- nulls=0
      . - 1423353600000(2/8/2015):	 count=1 sum=- min=- max=- avg=- nulls=0
      . - 1433030400000(5/31/2015):	 count=1 sum=- min=- max=- avg=- nulls=0
      . = (-None-):	 count=1 sum=- min=- max=- avg=- nulls=0
      . = - 1433030400000(5/31/2015):	 count=1 sum=- min=- max=- avg=- nulls=0
      . = due(Due):	 count=2 sum=- min=- max=- avg=- nulls=0
      . = - 1422748800000(2/1/2015):	 count=2 sum=- min=- max=- avg=- nulls=0
      . = new(New):	 count=2 sum=- min=- max=- avg=- nulls=0
      . = - 1419724800000(12/28/2014):	 count=1 sum=- min=- max=- avg=- nulls=0
      . = - 1423353600000(2/8/2015):	 count=1 sum=- min=- max=- avg=- nulls=0
      . = paid(Paid):	 count=2 sum=- min=- max=- avg=- nulls=0
      . = - 1420329600000(1/4/2015):	 count=2 sum=- min=- max=- avg=- nulls=0

      StatCalc: dump demo.counT (Count) date ByPeriod.Week
      counT(Count):	 count=7 sum=- min=- max=- avg=- nulls=0
      - 1419724800000(12/28/2014):	 count=1 sum=- min=- max=- avg=- nulls=0
      - 1420329600000(1/4/2015):	 count=2 sum=- min=- max=- avg=- nulls=0
      - 1422748800000(2/1/2015):	 count=2 sum=- min=- max=- avg=- nulls=0
      - 1423353600000(2/8/2015):	 count=1 sum=- min=- max=- avg=- nulls=0
      - 1433030400000(5/31/2015):	 count=1 sum=- min=- max=- avg=- nulls=0

   */
  String toStringX(String linePrefix) {
    String s = "${linePrefix}${super.toStringX(linePrefix)}";
    for (StatBy by in byList) {
      s += "\n" + by.toStringX("${linePrefix}. ");
    }
    return s;
  }

  static String statCalcColumnDate() => Intl.message("Date", name: "statCalcColumnDate");
  static String statCalcNoData() => Intl.message("No Data", name: "statCalcNoData");

  // labels
  static String statCalcWhat() => Intl.message("Display", name: "statCalcWhat");
  static String statCalcBy() => Intl.message("Group", name: "statCalcBy");
  static String statCalcDate() => Intl.message("by", name: "statCalcDate");
  static String statCalcPeriod() => Intl.message("per", name: "statCalcPeriod");
  static String statCalcPeriodTitle() => Intl.message("Group date per Period", name: "statCalcPeriodTitle");

  static String statCalcByTitle() => Intl.message("Select a Column", name: "statCalcByTitle");

  // values
  static String statCalcWhatCount() => Intl.message("Count", name: "statCalcWhatCount");
  static String statCalcByNone() => Intl.message("None", name: "statCalcByNone");
  static String statCalcDateNone() => Intl.message("Total", name: "statCalcDateNone");


} // StatCalc
