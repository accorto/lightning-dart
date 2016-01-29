/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_graph;

/**
 * Graph Metric point (count, sum, ...)
 */
class GraphPoint {

  /// key / column name
  final String key;

  /// label (cam update)
  String label;

  /// by Date criteria
  ByPeriod byPeriod;

  /// by date values
  List<GraphPoint> byDateList;

  int _count = 0;
  int _nullCount = 0;
  double _sum = 0.0;
  double _min = null;
  double _max = null;

  /**
   * Metric point with [key] (columnName, name) and [label]
   */
  GraphPoint(String this.key, String this.label);

  /// reset
  void reset() {
    _count = 0;
    _nullCount = 0;
    _sum = 0.0;
    _min = null;
    _max = null;
    byDateList = null;
  }

  /// update
  void calculate(num value, DateTime date) {
    if (value == null) {
      _nullCount++;
    } else {
      _count++;
      _sum += value;
      if (_min == null || value < _min)
        _min = value;
      if (_max == null || value > _max)
        _max = value;
    }
    // By Period
    if (byPeriod != null && date != null) {
      if (byDateList == null)
        byDateList = new List<GraphPoint>();
      DateTime date2 = getDateKey(date);
      String dateKey = date2.millisecondsSinceEpoch.toString();
      GraphPoint point = null;
      for (GraphPoint pp in byDateList) {
        if (pp.key == dateKey) {
          point = pp;
          break;
        }
      }
      if (point == null) {
        String dateLabel = format(date2);
        point = new GraphPoint(dateKey, dateLabel);
        byDateList.add(point);
      }
      point.calculate(value, null);
    }
  }

  // calculate

  double get sum => _sum;

  int get count => _count;

  int get nullCount => _nullCount;

  double get min => _min == null ? 0.0 : _min;

  double get max => _max == null ? 0.0 : _max;

  double get avg {
    if (_count == 0)
      return _sum;
    return _sum / _count;
  }

  /// start/first date for [date] based on period
  DateTime getDateKey(DateTime date) {
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
      byDateList.sort((GraphPoint one, GraphPoint two) {
        return one.key.compareTo(two.key); // by time
      });
    }
  }

  /// ensure that key/label exists
  void checkDate(key, label) {
    if (byDateList == null)
      byDateList = new List<GraphPoint>();
    for (GraphPoint pp in byDateList) {
      if (pp.key == key)
        return;
    }
    byDateList.add(new GraphPoint(key, label));
  }

  // checkDate


  /// info
  String toString() {
    String info = "${label == null ? key : label}: count=${count} "
        "sum=${_sum.toStringAsFixed(1)} "
        "min=${_min == null ? "-" : _min.toStringAsFixed(1)} "
        "max=${_max == null ? "-" : _max.toStringAsFixed(1)} "
        "avg=${avg.toStringAsFixed(1)} nullCount=${_nullCount} ";
    if (byPeriod != null) {
      info += " ${byPeriod}=#${byDateList == null ? "-" : byDateList.length}";
    }
    return info;
  }
}
