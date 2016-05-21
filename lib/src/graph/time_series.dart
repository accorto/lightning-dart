/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/**
 * Time Series Point with dimensions
 */
class TimeSeriesPoint {

  /// convert to int or null
  static num convertInt(String inString) {
    if (inString == null || inString.isEmpty)
      return null;
    return int.parse(inString, onError: (String s){
      return null;
    });
  }
  /// convert to double or null
  static num convert(String inString) {
    if (inString == null || inString.isEmpty)
      return null;
    return double.parse(inString, (String s){
      return null;
    });
  }


  /// Time Series Point
  TimeSeriesPoint(int timeMs) {
    _data.add(timeMs);
  }
  /// Time Series Point
  TimeSeriesPoint.from(String timeString) : this(convertInt(timeString));
  /// Time Series Point
  TimeSeriesPoint.date(DateTime time)
      : this(time.toUtc().millisecondsSinceEpoch);

  bool get valid => _data.isNotEmpty && _data[0] != null;

  /// add value
  void add(num value) {
    _data.add(value);
  }

  /// add string value
  bool addString(String value) {
    num vv = convert(value);
    _data.add(vv);
    return vv != null;
  }

  /// get data list
  List<num> get data => _data;
  final List<num> _data = new List<num>();


  String toString() {
    return "${new DateTime.fromMicrosecondsSinceEpoch(data[0].toInt(), isUtc: true)}: ${new List<num>.from(_data).removeAt(0)}";
  }

} // TimeSeriesPoint
