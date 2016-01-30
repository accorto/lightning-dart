/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_graph;

/**
 * Graph (Group) By
 */
class GraphBy
    extends GraphPoint {

  static final Logger _log = new Logger("GraphBy");

  String get columnName => key;

  /// Values
  List<GraphPoint> byValueList = new List<GraphPoint>();
  /// Key-Value Map
  Map<String,String> keyLabelMap;
  /// Need Label Update
  bool _needLabelUpdate = true;

  /**
   * Graph (Group) By
   */
  GraphBy(String columnName, String label, Map<String,String> this.keyLabelMap)
      : super (columnName, label) {
    if (keyLabelMap == null) {
      _log.config("${columnName} keyMap for FK");
      FkService.instance.getFkMapFuture(columnName)
      .then((Map<String, String> map) {
        keyLabelMap = map;
        _needLabelUpdate = true;
      });
    }
  } // KpiMetricBy

  /// clone
  GraphBy clone() {
    return new GraphBy(columnName, label, keyLabelMap)
      ..byPeriod = byPeriod;
  }

  /**
   * Calculate
   */
  void calculateRecord(DRecord record, double value, DateTime date) {
    calculate(value, date); // total
    String key = DataRecord.getColumnValue(record, columnName);
    if (key == null) {
      key = "";
    }
    GraphPoint point = null;
    for (GraphPoint pp in byValueList) {
      if (pp.key == key) {
        point = pp;
        break;
      }
    }
    if (point == null) {
      point = new GraphPoint(key, null);
      point.byPeriod = byPeriod;
      byValueList.add(point);
    }
    point.calculate(value, date);
    _needLabelUpdate = true;
  } // calculate

  /**
   * Update Labels + sort if required
   */
  void updateLabels() {
    if (_needLabelUpdate) {
      for (GraphPoint point in byValueList) {
        if (point.key.isEmpty)
          point.label = "-${graphByNone()}-";
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
      byValueList.sort((GraphPoint one, GraphPoint two) {
        return one.label.compareTo(two.label);
      });
      _needLabelUpdate = keyLabelMap == null || keyLabelMap.isEmpty;
    }
  } // updateLabels

  /// consolidate date labels
  List<String> getDateLabels() {
    /// get all date values in points
    Map<String,String> pointDateMap = new Map<String,String>();
    for (GraphPoint point in byValueList) {
      if (point.byDateList != null) {
        for (GraphPoint datePoint in point.byDateList) {
          pointDateMap[datePoint.key] = datePoint.label;
        }
      }
    }
    // add missing dates in points + sort
    for (GraphPoint point in byValueList) {
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
    for (GraphPoint point in byValueList) {
      s += "\n" + point.toStringX("${linePrefix}= ");
    }
    return s;
  }

  static String graphByNone() => Intl.message("None", name: "graphByNone");

} // GraphBy
