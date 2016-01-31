/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Stat (Group) By
 */
class StatBy
    extends StatPoint {

  static final Logger _log = new Logger("StatBy");

  String get columnName => key;

  /// Values
  List<StatPoint> byValueList = new List<StatPoint>();
  /// Key-Value Map
  Map<String,String> keyLabelMap;
  /// Need Label Update
  bool needLabelUpdate = true;

  /**
   * Stat (Group) By
   */
  StatBy(String columnName, String label, Map<String,String> this.keyLabelMap)
      : super (columnName, label) {
  } // KpiMetricBy

  /// clone
  StatBy clone() {
    return new StatBy(columnName, label, keyLabelMap)
      ..byPeriod = byPeriod;
  }

  /**
   * Calculate
   */
  void calculateRecord(DRecord record, double value, String valueString, DateTime date) {
    calculate(value, valueString, date); // total
    String key = DataRecord.getColumnValue(record, columnName);
    if (key == null) {
      key = "";
    }
    StatPoint point = null;
    for (StatPoint pp in byValueList) {
      if (pp.key == key) {
        point = pp;
        break;
      }
    }
    if (point == null) {
      point = new StatPoint(key, null);
      point.byPeriod = byPeriod;
      byValueList.add(point);
    }
    point.calculate(value, valueString, date);
    needLabelUpdate = true;
  } // calculate

  /**
   * Update Labels + sort if required
   */
  void updateLabels() {
    if (needLabelUpdate) {
      for (StatPoint point in byValueList) {
        if (point.key.isEmpty)
          point.label = "-${statByNone()}-";
        else {
          if (keyLabelMap == null || keyLabelMap.isEmpty)
            point.label = point.key;
          else {
            String label = keyLabelMap[point.key];
            if (label == null || label.isEmpty) {
              point.label = "<${point.key}>";
            } else {
              point.label = label;
            }
          }
        }
      }
      // sort
      byValueList.sort((StatPoint one, StatPoint two) {
        return one.label.compareTo(two.label);
      });
      needLabelUpdate = keyLabelMap == null || keyLabelMap.isEmpty;
    }
  } // updateLabels

  /// consolidate date labels
  List<String> getDateLabels() {
    /// get all date values in points
    Map<String,String> pointDateMap = new Map<String,String>();
    for (StatPoint point in byValueList) {
      if (point.byDateList != null) {
        for (StatPoint datePoint in point.byDateList) {
          pointDateMap[datePoint.key] = datePoint.label;
        }
      }
    }
    // add missing dates in points + sort
    for (StatPoint point in byValueList) {
      pointDateMap.forEach((String key, String label){
        point.checkDate(key, label);
      });
      point.sortDateList();
    }
    /// create list
    List<String> keys = new List<String>.from(pointDateMap.keys);
    keys.sort((String one, String two){
      return one.compareTo(two);
    });
    List<String> labels = new List<String>();
    for (String key in keys) {
      labels.add(pointDateMap[key]);
    }
    return labels;
  } // getDateLabels

  /// Info
  String toString() {
    String s = super.toString();
    if (byValueList != null)
      s += " byValueList=#${byValueList.length}";
    return s;
  }

  /// Dump Info (updates label)
  String toStringX(String linePrefix) {
    String s = super.toStringX(linePrefix);
    updateLabels();
    for (StatPoint point in byValueList) {
      s += "\n" + point.toStringX("${linePrefix}= ");
    }
    return s;
  }

  static String statByNone() => Intl.message("None", name: "statByNone");

} // StatBy
