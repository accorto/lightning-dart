/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/**
 * Time series for Table records
 */
class EngineChartedTimeSeries
    extends EngineChartedContainer {

  static final Logger _log = new Logger("EngineChartedTimeSeries");

  final String title;
  final DTable table;
  final String timeColumnName;
  /// the columns
  final List<DColumn> _columns = new List<DColumn>();
  /// data record
  DataRecord _dataRecord;

  final List<int> _measures = new List<int>();
  final List<ChartColumnSpec> _columnSpecs = new List<ChartColumnSpec>();
  final List<bool> _accumulateList = new List<bool>();
  final List<List<num>> _dataRows = new List<List<num>>();


  /// Chart Engine Charted Engine
  EngineChartedTimeSeries(String this.title,
      DTable this.table, String this.timeColumnName)
      : super() {

    _dataRecord = new DataRecord(table, null);
    DColumn col = DataUtil.getTableColumn(table, timeColumnName);
    if (col == null)
      throw new Exception("Column Not Found: ${timeColumnName}");

    ChartColumnSpec spec = new ChartColumnSpec(label: col.label,
        type: ChartColumnSpec.TYPE_TIMESTAMP);
    _columnSpecs.add(spec);
    _accumulateList.add(false);
  } // EngineChartedTimeSeries

  /// add column to time series
  void addColumn(String columnName, bool accumulate) {
    DColumn col = DataUtil.getTableColumn(table, timeColumnName);
    if (col == null) {
      _log.warning("addColumn ${columnName} NotFound");
    } else {
      _columns.add(col);
      _measures.add(_columnSpecs.length); // 1,2,3,...
      ChartColumnSpec spec = new ChartColumnSpec(label: col.label,
          type: ChartColumnSpec.TYPE_NUMBER);
      _columnSpecs.add(spec);
      _accumulateList.add(accumulate);
    }
  } // addColumn

  /// render records
  void renderTimeSeries(List<DRecord> records,  bool displayHorizontal) {
    _dataRows.clear();
    for (DRecord record in records) {
      _addRecord(record);
    }

    // sort
    _dataRows.sort((List<num> one, List<num> two){
      return one.first.compareTo(two.first);
    });
    // accumulate
    List<num> running = new List<num>.filled(_columnSpecs.length, 0);
    for (List<num> row in _dataRows) {
      for (int i = 1; i < row.length; i++) {
        if (_accumulateList[i]) {
          num no = running[i];
          if (row[i] == null)
            row[i] = no;
          else
            row[i] += no;
        }
      }
      running = row;
    } // accumulate
    _draw(displayHorizontal);
  } // renderTimeSeries

  /// add record to time series
  void _addRecord(DRecord record) {
    _dataRecord.setRecord(record, 0);
    String time = _dataRecord.getValue(timeColumnName);
    TimeSeriesPoint gtp = new TimeSeriesPoint.from(time);
    if (gtp.valid) {
      for (DColumn col in _columns) {
        gtp.addString(_dataRecord.getValue(col.name));
      }
    }
    _dataRows.add(gtp._data);
  } // addRecord


  /// draw time series
  void _draw( bool displayHorizontal) {
    int width = _createLayout(displayHorizontal);
    //
    ChartSeries series = new ChartSeries(table.name, _measures,
        new LineChartRenderer());
    Iterable<ChartSeries> seriesList = [series];
    Iterable<int> dimensionList = [0];
    ChartConfig config = new ChartConfig(seriesList, dimensionList)
          ..legend = new ChartLegend(_legendHost,
          title: title);
    _setChartSize(config, width);
    // data
    _data = new ChartData(_columnSpecs, _dataRows);
    // area
    ChartState state = new ChartState();
    CartesianArea area = new CartesianArea(_chartHost, _data, config,
        state: state);
    area.theme = new EngineChartedTheme();
    _createDefaultCartesianBehaviors().forEach((behavior) {
      area.addChartBehavior(behavior);
    });
    area.draw();
  } // draw

} // GraphTimeSeries

