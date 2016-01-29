/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_graph;

/**
 * Graph Calculation
 */
class GraphCalc
    extends GraphPoint {

  static final Logger _log = new Logger("GraphCalc");

  /// Count Calculation
  static const String COLUMN_COUNT = "counT";


  final String tableName;
  String get columnName => key;
  final String dateColumnName;
  final int numPrecision;

  List<GraphBy> _byList;
  List<GraphMatch> _matchList;

  /**
   * KPI Metric Calculation
   */
  GraphCalc(String this.tableName, String columnName, String label,
      String this.dateColumnName, {int this.numPrecision:2})
      : super(columnName, label);

  /// reset
  void resetCalc(List<GraphMatch> matchList, List<GraphBy> byList, ByPeriod byPeriod) {
    _matchList = matchList;
    _byList = new List<GraphBy>();
    for (GraphBy by in byList) {
      by.byPeriod = byPeriod;
      _byList.add(by.clone());
    }
    this.byPeriod = byPeriod;
    reset(); // total
  } // reset

  /// calculate values from [record]
  void calculateRecord(DRecord record) {
    String dateString = null;
    DateTime date = null;
    if (dateColumnName != null) {
      dateString = DataRecord.getColumnValue(record, dateColumnName);
      if (dateString != null && dateString.isNotEmpty) {
        int time = int.parse(dateString, onError: (String value2) {
          _log.warning("calculateRecord ${label} ${columnName}: date ${dateColumnName} invalid=${value2}");
          return null;
        });
        date = new DateTime.fromMillisecondsSinceEpoch(time, isUtc: true);
      }
    }

    String valueString = null;
    double value = null;
    if (columnName == COLUMN_COUNT) {
      value = 1.0;
    } else {
      valueString = DataRecord.getColumnValue(record, columnName);
      if (valueString != null && valueString.isNotEmpty) {
        value = double.parse(valueString, (String value2) {
          _log.warning("calculateRecord ${label} ${columnName}: value invalid=${value2}");
          return null;
        });
      }
    }
    calculatePoint(record, date, dateString, value, valueString);
  } // calculateRecord


  /**
   * Calculate individual Point
   */
  void calculatePoint(DRecord record, DateTime date, String dateString, num value, String valueString) {
    if (_match(record, date, dateString, value, valueString)) {
      _log.finer("calculatePoint ${label} Match value=${value} ${date}");
      calculate(value, date);
      for (GraphBy by in _byList) {
        by.calculateRecord(record, value, date);
      }
    } else {
      _log.finer("calculatePoint ${label} NoMatch value=${value} ${date}");
    }
  } // calculatePoint

  /**
   * Match Records
   */
  bool _match(DRecord record, DateTime date, String dateString, num value, String valueString) {
    for (GraphMatch match in _matchList) {
      // restrict value
      if (match.columnName == columnName) {
        if (!match.valueMatch(value, valueString)) {
          return false;
        }
      }
      else if (match.columnName == dateColumnName) {
        if (!match.dateMatch(date, dateString)) {
          return false;
        }
      }
      else if (!match.recordMatch(record)) {
        return false;
      }
    }
    return true;
  } // match

  /// Display
  void display(Element host) {
    if (renderStackedChart(host))
      return;
    if (renderPie(host))
      return;

    ParagraphElement p = new ParagraphElement()
      ..classes.add(LMargin.C_BOTTOM__SMALL);
    if (count == 0) {
      p.text = "- ${graphCalcNoData()} -";
    } else {
      p.text = toString();
    }
    host.append(p);
    /*
    if (byDateList != null) {
      sortDateList();
      for (GraphPoint pp in byDateList) {
        p = new ParagraphElement()
          ..text = "> ${pp}";
        host.append(p);
      }
    }

    /// By
    for (GraphBy by in _byList) {
      p = new ParagraphElement()
        ..text = "- ${by}";
      host.append(p);
      if (by.byDateList != null) {
        by.sortDateList();
        for (GraphPoint pp in by.byDateList) {
          p = new ParagraphElement()
            ..text = "- > ${pp}";
          host.append(p);
        }
      }
      //
      by.updateLabels();
      for (GraphPoint point in by.byValueList) {
        p = new ParagraphElement()
          ..text = "-- ${point}";
        host.append(p);
        if (point.byDateList != null) {
          point.sortDateList();
          for (GraphPoint pp in point.byDateList) {
            p = new ParagraphElement()
              ..text = "-- > ${pp}";
            host.append(p);
          }
        }
      }
    } */
  } // display


  /// render stacked chart in [parent]
  bool renderStackedChart(Element parent) {
    bool rendered = false;
    for (GraphBy by in _byList) {
      if (by.byPeriod == null)
        continue;
      if (by.byValueList.isEmpty)
        continue; // no data

      // layout
      DivElement chartHostWrapper = new DivElement()
        ..classes.addAll(["chart-host-wrapper"]);
      parent.append(chartHostWrapper);
      DivElement chartHost = new DivElement()
        ..classes.addAll(["chart-host"]);
      chartHostWrapper.append(chartHost);
      DivElement legendHost = new DivElement()
        ..classes.addAll(["chart-legend-host"]);
      chartHostWrapper.append(legendHost);
      rendered = true;

      // config
      List<int> measures = new List<int>();
      for (int i = 0; i < by.byValueList.length; i++) {
        measures.add(i + 1);
      }
      /*
      ChartSeries series = new ChartSeries(tableName, measures,
          new StackedBarChartRenderer(alwaysAnimate: true));
      Iterable<ChartSeries> seriesList = [series];
      Iterable<int> dimensionList = [0];
      ChartConfig config = new ChartConfig(seriesList, dimensionList)
        ..legend = new ChartLegend(legendHost,
            showValues: true,
            title: by.label);
      int width = chartHost.clientWidth;
      if (config.minimumSize.width > width) { // 400x300
        config.minimumSize = new Rect.size(width, 300*(width~/400));
      }

      // data
      ChartData data = new ChartData(_stackedColumns(by), _stackedRows(by));
      ChartState state = new ChartState();
      // area
      CartesianArea area = new CartesianArea(chartHost, data, config,
          state:state, useTwoDimensionAxes:false, useRowColoring:false);
      area.theme = new QuantumChartTheme2();
      createDefaultCartesianBehaviors().forEach((behavior) {
        area.addChartBehavior(behavior);
      });
      area.draw();
      */
    }
    return rendered;
  } // renderStackedChart

  /* stacked columns (by values)
  List<ChartColumnSpec> _stackedColumns(GraphBy by) {
    List<ChartColumnSpec> list = new List<ChartColumnSpec>();
    List<String> info = new List<String>();
    by.updateLabels();
    ChartColumnSpec column = new ChartColumnSpec(label:GraphCalcDate(),
        type: ChartColumnSpec.TYPE_STRING);
    info.add(GraphCalcDate());
    list.add(column);
    // TODO only used by values
    for (GraphPoint point in by.byValueList) {
      FormatFunction formatter = _format2num;
      column = new ChartColumnSpec(label:point.label,
          type: ChartColumnSpec.TYPE_NUMBER,
          formatter:formatter);
      info.add(point.label);
      list.add(column);
    }
    _log.fine("stackedColumns ${info}");
    return list;
  } // stackedColumns */

  /// stacked column values - list of dates + by values
  List<List<dynamic>> _stackedRows(GraphBy by) {
    List<List<dynamic>> list = new List<List<dynamic>>();
    List<String> dateLabels = by.getDateLabels(); // sync date info
    for (int i = 0; i < dateLabels.length; i++) {
      List<dynamic> row = new List<dynamic>();
      row.add(dateLabels[i]);
      for (GraphPoint point in by.byValueList) {
        row.add(point.byDateList[i].sum);
      }
      _log.finer(row);
      list.add(row);
    }
    _log.fine("stackedRows ${list.length} * ${dateLabels.length}");
    return list;
  } // stackedRows



  /// Render Pie in [parent]
  bool renderPie(Element parent) {
    bool rendered = false;
    bool isDonut = true;
    for (GraphBy by in _byList) {
      if (by.count == 0)
        continue;
      // layout
      DivElement chartHostWrapper = new DivElement()
        ..classes.addAll(["chart-host-wrapper"]);
      parent.append(chartHostWrapper);
      DivElement chartHost = new DivElement()
        ..classes.addAll(["chart-host"]);
      chartHostWrapper.append(chartHost);
      DivElement legendHost = new DivElement()
        ..classes.addAll(["chart-legend-host"]);
      chartHostWrapper.append(legendHost);
      rendered = true;
      //
      by.updateLabels();
      /*
      ChartSeries series = new ChartSeries(tableName, [1],
          new PieChartRenderer(innerRadiusRatio: isDonut ? 0.5 : 0,
              statsMode: PieChartRenderer.STATS_VALUE_PERCENTAGE,
              showLabels: true,
              sortDataByValue: false));
      ChartConfig config = new ChartConfig([series], [0])
        ..legend = new ChartLegend(legendHost,
            title: by.label,
            showValues: true);
      int width = chartHost.clientWidth;
      if (config.minimumSize.width > width) { // 400x300
        config.minimumSize = new Rect.size(width, 300*(width~/400));
      }

      ChartData data = new ChartData(_pieColumns(by), _pieRows(by));
      ChartState state = new ChartState();

      LayoutArea area = new LayoutArea(chartHost, data, config,
          state:state);
      area.theme = new QuantumChartTheme2();
      createDefaultCartesianBehaviors().forEach((behavior) {
        area.addChartBehavior(behavior);
      });
      area.draw();
      */
    }
    return rendered;
  } // renderPie

  /* pie column list
  List<ChartColumnSpec> _pieColumns(GraphBy by) {
    List<ChartColumnSpec> list = new List<ChartColumnSpec>();
    by.updateLabels();
    ChartColumnSpec column = new ChartColumnSpec(label:"-", type: ChartColumnSpec.TYPE_STRING);
    list.add(column);
    for (GraphPoint point in by.byValueList) {
      FormatFunction formatter = _format2num;
      column = new ChartColumnSpec(label:point.label,
          type: ChartColumnSpec.TYPE_NUMBER,
          formatter:formatter);
      list.add(column);
    }
    return list;
  } */

  /// pie column rows
  List<List<dynamic>> _pieRows(GraphBy by) {
    List<List<dynamic>> list = new List<List<dynamic>>();
    for (GraphPoint point in by.byValueList) {
      List<dynamic> row = new List<dynamic>();
      row.add(point.label);
      row.add(point.sum);
      list.add(row);
    }
    return list;
  }


  /* Helper method to create default behaviors for cartesian chart demos.
  Iterable<ChartBehavior> createDefaultCartesianBehaviors() =>
      new List.from([
        new Hovercard(isMultiValue: true),
        new AxisLabelTooltip()
      ]);

  String _format2num(dynamic value) {
    if (value is num)
      return value.toStringAsFixed(numPrecision);
    return value;
  } */

  static String graphCalcDate() => Intl.message("Date", name: "graphCalcDate");
  static String graphCalcNoData() => Intl.message("No Data", name: "graphCalcNoData");

} // GraphCalc
