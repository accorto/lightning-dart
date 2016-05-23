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
    extends EngineChartedContainer
    with TimeSeries {

  static final Logger _log = new Logger("EngineChartedTimeSeries");


  /// Chart Engine Charted Engine
  EngineChartedTimeSeries(DTable table, String timeColumnName)
      : super() {
    init(table, timeColumnName);
  } // EngineChartedTimeSeries

  /// render record values
  bool renderTimeSeries(List<DRecord> records,  bool displayHorizontal) {
    if (records == null || records.isEmpty) {
      element.children.clear();
      DivElement info = new DivElement()
        ..classes.addAll([LMargin.C_VERTICAL__MEDIUM])
        ..text = "- No Data -";
      element.append(info);
      return true;
    }
    reset();
    load(records);
    return _draw(displayHorizontal);
  }

  /// draw time series
  bool _draw( bool displayHorizontal) {
    int width = _createLayout(displayHorizontal);
    // a series per data type
    List<ChartSeries> seriesList = new List<ChartSeries>();
    List<TimeSeriesMeasure> measureList = new List<TimeSeriesMeasure>();
    for (TimeSeriesColumn tsc in _columnList) {
      if (tsc.measure != null) {
        tsc.updateMeasure();
        if (!measureList.contains(tsc.measure)) {
          measureList.add(tsc.measure);
        }
      }
    }

    // measure = series = axis
    for (TimeSeriesMeasure tsm in measureList) {
      ChartSeries series = new ChartSeries("ts_${tsm.name}",
          tsm.measures,
          new LineChartRenderer(
              alwaysAnimate: true,
              trackOnDimensionAxis: true),
          measureAxisIds: [tsm.name]);
      seriesList.add(series);
    }

    Iterable<int> dimensionList = [0];
    ChartConfig config = new ChartConfig(seriesList, dimensionList)
          ..legend = new ChartLegend(_legendHost,
          //  title: "",
              showValues: true);
    for (TimeSeriesMeasure tsm in measureList) {
      config.registerMeasureAxis(tsm.name, tsm.axisConfig);
    }
    _setChartSize(config, width);
    // data
    List<ChartColumnSpec> columnSpecs = new List<ChartColumnSpec>();
    for (TimeSeriesColumn tsc in _columnList) {
      columnSpecs.add(tsc.spec);
    }
    _data = new ChartData(columnSpecs, _dataRows);
    // area
    ChartState state = new ChartState();
    CartesianArea area = new CartesianArea(_chartHost, _data, config,
        state: state);
    area.theme = new EngineChartedTheme();
    //
    area.addChartBehavior(
        new Hovercard(showDimensionTitle: true,
          isMouseTracking: true,
          isMultiValue: true));
    area.addChartBehavior(
        new AxisLabelTooltip());

    // draw
    try {
      area.draw();
      return true;
    } catch (error) {
      _log.warning("draw", error);
      dumpData();
      return false;
    }
  } // draw

} // EngineChartedTimeSeries
