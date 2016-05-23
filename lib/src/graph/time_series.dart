/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/**
 * Time Series
 */
class TimeSeries {

  static final Logger _log = new Logger("TimeSeries");

  /// data record
  DataRecord _dataRecord;

  /// time series column list
  final List<TimeSeriesColumn> _columnList = new List<TimeSeriesColumn>();
  /// data rows
  final List<List<num>> _dataRows = new List<List<num>>();

  /// initialize
  void init(DTable table, String timeColumnName) {
    _dataRecord = new DataRecord(table, null);
    DColumn col = DataUtil.getTableColumn(table, timeColumnName);
    if (col == null)
      throw new Exception("Column Not Found: ${timeColumnName}");

    TimeSeriesColumn tsc = new TimeSeriesColumn(col, false, null, _columnList.length);
    tsc.spec = new ChartColumnSpec(
        label: col.label,
        type: ChartColumnSpec.TYPE_DATE,
        formatter: dateFormatFunction);
    _columnList.add(tsc);
  } // init

  /// format date values
  String dateFormatFunction(value) {
    if (value == null) {
      return "";
    }
    if (value is num) {
      num numValue = value;
      DateTime dt = new DateTime.fromMillisecondsSinceEpoch(numValue, isUtc: true);
      return ClientEnv.dateFormat_ymd.format(dt);
    }
    return value.toString();
  }

  /// add column to time series
  void addColumn(String columnName, bool accumulate,
      TimeSeriesMeasure measure,
      {String labelOverride}) {
    DColumn col = DataUtil.getTableColumn(_dataRecord.table, columnName);
    if (col == null) {
      _log.warning("addColumn ${columnName} NotFound");
    } else {
      _columnList.add(new TimeSeriesColumn(col, accumulate, measure,
          _columnList.length, labelOverride: labelOverride));
    }
  } // addColumn

  /// render records
  void load(List<DRecord> records) {
    // reset
    _dataRows.clear();
    for (TimeSeriesColumn tsc in _columnList) {
      tsc.reset();
    }
    // add
    for (DRecord record in records) {
      _addRecord(record);
    }

    // sort
    _dataRows.sort((List<num> one, List<num> two){
      return one.first.compareTo(two.first);
    });
    // accumulate
    List<num> running = new List<num>.filled(_columnList.length, 0);
    for (List<num> row in _dataRows) {
      for (int i = 1; i < row.length; i++) {
        if (_columnList[i].accumulate(row[i])) {
          num no = running[i];
          if (row[i] == null)
            row[i] = no;
          else
            row[i] += no;
        }
      }
      running = row;
    } // accumulate
  } // renderTimeSeries

  /// add record to time series
  void _addRecord(DRecord record) {
    _dataRecord.setRecord(record, 0);
    TimeSeriesPoint gtp = null;
    for (TimeSeriesColumn tsc in _columnList) {
      String value = tsc.getValue(_dataRecord);
      if (tsc.index == 0) {
        gtp = new TimeSeriesPoint.from(value);
      } else {
        gtp.addString(value);
      }
    }
    _dataRows.add(gtp._data);
  } // addRecord

} // TimeSeries



/**
 * Time Series Measure
 */
class TimeSeriesMeasure {

  /// name
  final String name;
  /// axis config
  final ChartAxisConfig axisConfig = new ChartAxisConfig();
  /// formatter
  FormatFunction formatter = null;

  /// measures
  final List<int> measures = new List<int>();
  final List<num> _domain = new List<num>();

  /// Time Series Measure - amt=true false=h null=none
  TimeSeriesMeasure(String this.name, String label, bool amt) {
    axisConfig.title = label;
    axisConfig.scale = new LinearScale();
    if (amt != null) {
      formatter = amt ? formatterAmt : formatterHours;
    }
  }

  /// reset
  void reset() {
    measures.clear();
    _domain.clear();
  }

  /// Amount formatter (k)
  String formatterAmt(value) {
    if (value != null && value is num) {
      return "${ClientEnv.numberFormat_1.format(value/1000)}k";
    }
    return value;
  }

  /// Hour formatter (h)
  String formatterHours(value) {
    if (value != null && value is num) {
      return "${ClientEnv.numberFormat_int.format(value)}h";
    }
    return value;
  }



  /// update sale min/max
  void updateScale(num min, num max) {
    if (min != null && max != null) {
      if (_domain.isEmpty) {
        _domain.add(min);
        _domain.add(max);
      } else {
        if (_domain[0] > min)
          _domain[0] = min;
        if (_domain[1] < max)
          _domain[1] = max;
      }
      axisConfig.scale.domain = _domain;
    }
  } // updateScale

  @override
  String toString() {
    return "TimeSeriesMeasure@${name}[measures=${measures} domain=${_domain}]";
  }

} // TimeSeriesMeasure



/**
 * Time Series Column
 */
class TimeSeriesColumn {

  final DColumn column;
  final bool _accumulate;
  final TimeSeriesMeasure measure;
  final int index;

  String get name => column.name;

  ChartColumnSpec spec;

  int count = 0;
  int countNull = 0;
  num sum = 0;
  num min;
  num max;

  /// Time Series Column
  TimeSeriesColumn(DColumn this.column,
      bool this._accumulate,
      TimeSeriesMeasure this.measure,
      int this.index,
      {String labelOverride}) {

    String label = labelOverride == null ? column.label : labelOverride;

    spec = new ChartColumnSpec(
        label: label,
        type: ChartColumnSpec.TYPE_NUMBER,
        formatter: measure == null ? null : measure.formatter);
  } // TimeSeriesColumn

  /// get Value from record
  String getValue (DataRecord data) {
    return data.getValue(name);
  }

  /// reset
  void reset() {
    count = 0;
    countNull = 0;
    sum = 0;
    min = null;
    max = null;
    if (measure != null)
      measure.reset();
  }

  /// add up stats and return true if accumulate
  bool accumulate(num value) {
    if (value == null) {
      countNull++;
    } else {
      count++;
      sum += value;
      if (min == null || value < min)
        min = value;
      if (max == null || value > max)
        max = value;
    }
    return _accumulate;
  }


  /// update Measure
  void updateMeasure() {
    if (measure != null) {
      measure.measures.add(index);
      if (_accumulate) {
        measure.updateScale(min, sum);
      } else {
        measure.updateScale(min, max);
      }
    }
  } // updateMeasure

  @override
  String toString() {
    return "TimeSeriesColumn@${name}#${index}[${measure == null ? '-' : measure.name}"
        " null=${countNull} null=${count} min=${min} max=${max} sum=${sum}]";
  }

} // TimeSeriesColumn



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
    return "${new DateTime.fromMillisecondsSinceEpoch(data[0].toInt(), isUtc: true)}: ${new List<num>.from(_data).removeAt(0)}";
  }

} // TimeSeriesPoint
