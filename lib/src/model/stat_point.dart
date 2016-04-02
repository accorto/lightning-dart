/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_model;

/// By Date
enum ByPeriod { Day, Week, Month, Quarter, Year }

/**
 * Graph Metric point (count, sum, ...)
 */
class StatPoint {

  /// key (column name)
  final String key;
  /// Meta Info
  DColumn column;
  /// Meta Info
  DColumn dateColumn;

  /// by Date criteria
  ByPeriod byPeriod;

  /// by date values
  List<StatPoint> byDateList;

  int _count = 0;
  int _nullCount = 0;
  num _sum = null;
  num _min = null;
  num _max = null;

  /**
   * Metric point with [key] (columnName, name) and [label]
   */
  StatPoint(String this.key, String label) {
    _label = label;
  }

  /// label (can update)
  String get label => _label;
  void set label(String newValue) {
    _label = newValue;
  }
  String _label;


  /// reset
  void reset() {
    _count = 0;
    _nullCount = 0;
    _sum = null;
    _min = null;
    _max = null;
    byDateList = null;
  }

  /// update
  void calculate(num valueNum, String valueString, DateTime date) {
    if (valueString == null || valueString.isEmpty) {
      _nullCount++;
    } else {
      _count++;
      if (valueNum != null) {
        if (_sum == null) {
          _sum = valueNum;
        } else {
          _sum += valueNum;
        }
        // min/max
        if (_min == null || valueNum < _min) {
          _min = valueNum;
        }
        if (_max == null || valueNum > _max) {
          _max = valueNum;
        }
      }
    }

    // By Period
    if (byPeriod != null && date != null) {
      if (byDateList == null)
        byDateList = new List<StatPoint>();
      DateTime date2 = getDateKey(date.toUtc(), byPeriod);
      String dateKey = date2.millisecondsSinceEpoch.toString();
      StatPoint point = null;
      for (StatPoint pp in byDateList) {
        if (pp.key == dateKey) {
          point = pp;
          break;
        }
      }
      if (point == null) {
        String dateLabel = format(date2);
        point = new StatPoint(dateKey, dateLabel);
        byDateList.add(point);
      }
      point.calculate(valueNum, valueString, null);
    }
  } // calculate

  bool get hasSum => _sum != null;
  /// value sum
  num get sum => _sum == null ? 0 : _sum;

  /// total count
  int get count => _count;
  /// null count
  int get nullCount => _nullCount;

  num get min => _min == null ? 0 : _min;
  num get max => _max == null ? 0 : _max;
  /// has Min/Max
  bool get hasMinMax => _min != null && _max != null;

  /// average
  num get avg {
    if (_sum == null || _sum == 0) {
      return 0;
    }
    if (_count == 0)
      return _sum;
    return _sum / _count;
  }

  /// percent 0..100 of min/max or 0
  int getPercent(String value) {
    if (_min == null || _max == null || value == null || value.isEmpty) {
      return 0;
    }
    double numValue = double.parse(value, (_){return null;});
    if (numValue == null || numValue <= _min)
      return 0;
    if (numValue >= _max)
      return 100;
    //
    double pct = 100 * ((numValue - _min) / (_max - _min));
    return pct.toInt();
  } // getPercent


  /// start/first date for utc [date] based on period
  static DateTime getDateKey(DateTime date, ByPeriod byPeriod) {
    if (byPeriod == ByPeriod.Day) {
      return new DateTime.utc(date.year, date.month, date.day);
    }
    if (byPeriod == ByPeriod.Week) {
      int offset = date.weekday; // 1=Mo
      if (offset == DateTime.SUNDAY) // 7
        return new DateTime.utc(date.year, date.month, date.day);
      return new DateTime.utc(date.year, date.month, date.day).subtract(
          new Duration(days: offset));
    }
    if (byPeriod == ByPeriod.Month) {
      return new DateTime.utc(date.year, date.month, 1);
    }
    if (byPeriod == ByPeriod.Quarter) {
      int quarterMonth = DateTime.JANUARY;
      if (date.month >= DateTime.OCTOBER)
        quarterMonth = DateTime.OCTOBER;
      else if (date.month >= DateTime.JULY)
        quarterMonth = DateTime.JULY;
      else if (date.month >= DateTime.APRIL)
        quarterMonth = DateTime.APRIL;
      return new DateTime.utc(date.year, quarterMonth, 1);
    }
    if (byPeriod == ByPeriod.Year) {
      return new DateTime.utc(date.year, 1, 1);
    }
    return date;
  }

  /// format date based on period
  String format(DateTime date) {
    if (byPeriod == ByPeriod.Day || byPeriod == ByPeriod.Week) {
      return ClientEnv.formatDate(date);
    }
    if (byPeriod == ByPeriod.Month) {
      return ClientEnv.formatMonth(date);
    }
    if (byPeriod == ByPeriod.Quarter) {
      return ClientEnv.formatQuarter(date);
    }
    if (byPeriod == ByPeriod.Year) {
      return date.year.toString();
    }
    return ClientEnv.formatDate(date);
  }

  /// sort date list based on date
  void sortDateList() {
    if (byDateList != null) {
      byDateList.sort((StatPoint one, StatPoint two) {
        return one.key.compareTo(two.key); // by time
      });
    }
  }

  /// ensure that key/label exists
  void checkDate(key, label) {
    if (byDateList == null)
      byDateList = new List<StatPoint>();
    for (StatPoint pp in byDateList) {
      if (pp.key == key)
        return;
    }
    byDateList.add(new StatPoint(key, label));
  }

  // checkDate

  /// info
  String toString() {
    String info = "${label == null ? key : label}: count=${count} "
        "sum=${_sum == null ? "-" : _sum.toStringAsFixed(1)} "
        "min=${_min == null ? "-" : _min.toStringAsFixed(1)} "
        "max=${_max == null ? "-" : _max.toStringAsFixed(1)} "
        "avg=${_sum == null ? "-" : avg.toStringAsFixed(1)} "
        "nulls=${_nullCount} ";
    if (byPeriod != null) {
      info += " ${byPeriod}=#${byDateList == null ? "-" : byDateList.length}";
    }
    return info;
  }

  /// Dump Info
  String toStringX(String linePrefix) {
    String s = "${linePrefix}${key}($label):\t count=${count} "
        "sum=${_sum == null ? "-" : _sum.toStringAsFixed(1)} "
        "min=${_min == null ? "-" : _min.toStringAsFixed(1)} "
        "max=${_max == null ? "-" : _max.toStringAsFixed(1)} "
        "avg=${_sum == null ? "-" : avg.toStringAsFixed(1)} "
        "nulls=${_nullCount} ";
    if (byDateList != null) {
      for (StatPoint byDate in byDateList) {
        s += "\n" + byDate.toStringX("${linePrefix}- ");
      }
    }
    return s;
  }


  /// find by Period
  static ByPeriod findPeriod(String value) {
    if (ByPeriod.Day.toString() == value)
      return ByPeriod.Day;
    if (ByPeriod.Week.toString() == value)
      return ByPeriod.Week;
    if (ByPeriod.Month.toString() == value)
      return ByPeriod.Month;
    if (ByPeriod.Quarter.toString() == value)
      return ByPeriod.Quarter;
    if (ByPeriod.Year.toString() == value)
      return ByPeriod.Year;
    return null;
  }

  static String statByPeriodDay() => Intl.message("Day", name: "statByPeriodDay");
  static String statByPeriodWeek() => Intl.message("Week", name: "statByPeriodWeek");
  static String statByPeriodMonth() => Intl.message("Month", name: "statByPeriodMonth");
  static String statByPeriodQuarter() => Intl.message("Quarter", name: "statByPeriodQuarter");
  static String statByPeriodYear() => Intl.message("Year", name: "statByPeriodYear");

} // StatPoint
