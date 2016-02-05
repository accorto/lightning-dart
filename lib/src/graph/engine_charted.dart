/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_graph;

/**
 * Graph Presentation via Charted
 */
class EngineCharted
    extends EngineBase {

  static final Logger _log = new Logger("EngineCharted");

  final Element element = new Element.article()
    ..classes.add("chart-wrapper");

  /// chart height in px
  int chartHeight = 300;


  DivElement _wrapper = new DivElement()
    ..classes.add("chart-title-wrapper");
  HeadingElement _title = new HeadingElement.h2()
    ..classes.add("chart-title");
  HeadingElement _subTitle = new HeadingElement.h4()
    ..classes.add("chart-subtitle");


  GraphCalc _calc;
  int _numPrecision = 2;

  List<StatPoint> _metaRowList = new List<StatPoint>();
  List<StatPoint> _metaColList = new List<StatPoint>();

  /**
   * Charted Engine Interface
   * chart-wrapper
   * - chart-title-wrapper
   * --  chart-title
   * - chart-host-wrapper
   * --  chart-host
   * ---   chart-canvas (svg)
   * ---   hovercard
   * --  chart-legend-host
   * ---   chart-legend-heading
   * ---   chart-legend-row
   */
  EngineCharted() {
    element.append(_wrapper);
  }

  /// set chart title
  void set title (String newValue) {
    _title.text = newValue;
    if (newValue == null || newValue.isEmpty)
      _title.remove();
    else if (_title.parent == null) {
      _wrapper.append(_title);
    }
  }
  void set subTitle (String newValue) {
    _subTitle.text = newValue;
    if (newValue == null || newValue.isEmpty)
      _subTitle.remove();
    else if (_subTitle.parent == null) {
      _wrapper.append(_subTitle);
    }
  }

  /// reset elements
  void reset() {
    element.children.clear();
    element.append(_wrapper);
    _legendHost = null;
    _chartHost = null;
    _state = null;
    _data = null;
    _metaRowList.clear();
    _metaColList.clear();
  }

  /**
   * Render stacked bar chart - true if rendered
   */
  bool renderStacked(GraphCalc calc) {
    _calc = calc;
    _numPrecision = _calc.decimalDigits;
    bool rendered = false;
    for (StatBy by in _calc.byList) {
      if (by.byPeriod == null)
        continue;
      if (by.byValueList.isEmpty)
        continue; // no data
      rendered = true;
      _createLayout();

      // config
      List<int> measures = new List<int>();
      for (int i = 0; i < by.byValueList.length; i++) {
        measures.add(i + 1);
      }

      ChartSeries series = new ChartSeries(_calc.tableName, measures,
          new StackedBarChartRenderer(alwaysAnimate: true));
      Iterable<ChartSeries> seriesList = [series];
      Iterable<int> dimensionList = [0];
      ChartConfig config = new ChartConfig(seriesList, dimensionList)
        ..legend = new ChartLegend(_legendHost,
            showValues: true,
            title: by.label);
      int width = _chartHost.clientWidth; // scale down
      if (config.minimumSize.width > width) { // 400x300
        int height = 300*(width~/400);
        config.minimumSize = new Rect.size(width, height);
      }
      _log.fine("renderStacked size=${config.minimumSize}"); // x y w h
      int height = config.minimumSize.height;
      if (height > 0)
        _legendHost.style.maxHeight = "${height}px";

      // data
      _data = new ChartData(_stackedColumns(by), _stackedRows(by));

      // area
      _createState();
      CartesianArea area = new CartesianArea(_chartHost, _data, config,
          state:_state, useTwoDimensionAxes:false, useRowColoring:false);
      area.theme = new EngineChartedTheme();
      _createDefaultCartesianBehaviors().forEach((behavior) {
        area.addChartBehavior(behavior);
      });
      area.draw();
    }
    if (!rendered && _calc.byDateList != null && _calc.byDateList.isNotEmpty) {
      return renderBar(_calc);
    }
    return rendered;
  } // renderStackedChart

  /// stacked columns (by values)
  List<ChartColumnSpec> _stackedColumns(StatBy by) {
    List<ChartColumnSpec> list = new List<ChartColumnSpec>();
    by.updateLabels();
    ChartColumnSpec column = new ChartColumnSpec(label:StatCalc.statCalcColumnDate(),
        type: ChartColumnSpec.TYPE_STRING);
    list.add(column);
    _metaColList.add(null);
    for (StatPoint point in by.byValueList) {
      FormatFunction formatter = _format2num;
      column = new ChartColumnSpec(label:point.label,
          type: ChartColumnSpec.TYPE_NUMBER,
          formatter:formatter);
      list.add(column);
      _metaColList.add(point);
    }
    return list;
  } // stackedColumns

  /// stacked column values - list of dates + by values
  List<List<dynamic>> _stackedRows(StatBy by) {
    List<List<dynamic>> list = new List<List<dynamic>>();
    List<String> dateLabels = by.getDateLabels(); // sync date info
    List<StatPoint> datePoints = by.getDatePoints();

    for (int i = 0; i < dateLabels.length; i++) {
      List<dynamic> row = new List<dynamic>();
      row.add(dateLabels[i]);
      _metaRowList.add(datePoints[i]);
      for (StatPoint point in by.byValueList) {
        if (point.byDateList[i].hasSum) {
          row.add(point.byDateList[i].sum);
        } else {
          row.add(point.byDateList[i].count);
        }
      }
      _log.finer(row);
      list.add(row);
    }
    _log.fine("stackedRows rows=${list.length}|${dateLabels.length}|${datePoints.length} cols=${by.byValueList.length}");
    return list;
  } // stackedRows


  /**
   * Render Bar Chart
   */
  bool renderBar(GraphCalc calc) {
    _calc = calc;
    if (_calc.byDateList != null && _calc.byDateList.isNotEmpty) { // .. no by
      _data = new ChartData(_pointColumns(_calc),
          _pointRows(_calc.byDateList));
    } else if (_calc.byList.isNotEmpty) { // by w/o date (like pie)
      StatBy by = _calc.byList.first;
      _data = new ChartData(_byColumns(by.label, by), _byRows(by));
    }
    if (_data == null) {
      return false; // no data
    }
    _createLayout();

    ChartSeries series = new ChartSeries(_calc.tableName, [1],
        new BarChartRenderer(alwaysAnimate: true));
    Iterable<ChartSeries> seriesList = [series];
    Iterable<int> dimensionList = [0];
    ChartConfig config = new ChartConfig(seriesList, dimensionList)
      ..legend = new ChartLegend(_legendHost,
          showValues: true,
          title: _calc.label);
    int width = _chartHost.clientWidth; // scale down
    if (config.minimumSize.width > width) { // 400x300
      int height = 300*(width~/400);
      config.minimumSize = new Rect.size(width, height);
    }
    _log.fine("renderBar size=${config.minimumSize}"); // x y w h
    int height = config.minimumSize.height;
    if (height > 0)
      _legendHost.style.maxHeight = "${height}px";

    // area
    _createState();
    CartesianArea area = new CartesianArea(_chartHost, _data, config,
        state:_state, useTwoDimensionAxes:false, useRowColoring:false);
    area.theme = new EngineChartedTheme();
    _createDefaultCartesianBehaviors().forEach((behavior) {
      area.addChartBehavior(behavior);
    });
    area.draw();
    return true;
  } // renderStackedPlain

  /// bar column list
  List<ChartColumnSpec> _pointColumns(GraphCalc calc) {
    List<ChartColumnSpec> list = new List<ChartColumnSpec>();
    ChartColumnSpec column = new ChartColumnSpec(label:calc.tableName,
        type: ChartColumnSpec.TYPE_STRING);
    list.add(column);
    _metaColList.add(null);

    FormatFunction formatter = _format2num;
    column = new ChartColumnSpec(label:calc.label,
        type: ChartColumnSpec.TYPE_NUMBER,
        formatter:formatter);
    list.add(column);
    _metaColList.add(calc);
    return list;
  }

  /// bar column rows
  List<List<dynamic>> _pointRows(List<StatPoint> pointList) {
    List<List<dynamic>> list = new List<List<dynamic>>();
    for (StatPoint point in pointList) {
      List<dynamic> row = new List<dynamic>();
      row.add(point.label);
      _metaRowList.add(point);
      if (point.hasSum) {
        row.add(point.sum);
      } else {
        row.add(point.count);
      }
      list.add(row);
    }
    return list;
  }

  /**
   * Render Pie in [parent]
   */
  bool renderPie(GraphCalc calc) {
    _calc = calc;
    _numPrecision = _calc.decimalDigits;
    bool rendered = false;
    bool isDonut = true;
    for (StatBy by in _calc.byList) {
      if (by.count == 0)
        continue;
      rendered = true;
      _createLayout();
      //
      by.updateLabels();

      ChartSeries series = new ChartSeries(_calc.tableName, [1],
          new PieChartRenderer(innerRadiusRatio: isDonut ? 0.5 : 0,
              statsMode: PieChartRenderer.STATS_VALUE_PERCENTAGE,
              showLabels: true,
              sortDataByValue: false));
      ChartConfig config = new ChartConfig([series], [0])
        ..legend = new ChartLegend(_legendHost,
            title: by.label,
            showValues: true);
      int width = _chartHost.clientWidth;
      if (config.minimumSize.width > width) { // 400x300
        int height = 300*(width~/400);
        config.minimumSize = new Rect.size(width, height);
      }
      _log.fine("renderPie size=${config.minimumSize}"); // x y w h
      int height = config.minimumSize.height;
      if (height > 0)
        _legendHost.style.maxHeight = "${height}px";

      _data = new ChartData(_byColumns(by.label, by), _byRows(by));

      _createState();
      LayoutArea area = new LayoutArea(_chartHost, _data, config,
          state:_state);
      area.theme = new EngineChartedTheme();
      _createDefaultCartesianBehaviors().forEach((behavior) {
        area.addChartBehavior(behavior);
      });
      area.draw();
    }
    return rendered;
  } // renderPie

  /// pie column list
  List<ChartColumnSpec> _byColumns(String label, StatBy by) {
    List<ChartColumnSpec> list = new List<ChartColumnSpec>();
    by.updateLabels();
    ChartColumnSpec column = new ChartColumnSpec(label:label, type: ChartColumnSpec.TYPE_STRING);
    list.add(column);
    _metaColList.add(by);
    for (StatPoint point in by.byValueList) {
      FormatFunction formatter = _format2num;
      column = new ChartColumnSpec(label:point.label,
          type: ChartColumnSpec.TYPE_NUMBER,
          formatter:formatter);
      list.add(column);
      _metaColList.add(point);
    }
    return list;
  }

  /// pie column rows
  List<List<dynamic>> _byRows(StatBy by) {
    List<List<dynamic>> list = new List<List<dynamic>>();
    for (StatPoint point in by.byValueList) {
      List<dynamic> row = new List<dynamic>();
      row.add(point.label);
      _metaRowList.add(point);
      if (point.hasSum) {
        row.add(point.sum);
      } else {
        row.add(point.count);
      }
      list.add(row);
    }
    return list;
  }


  /// Helper method to create default behaviors for cartesian chart demos.
  Iterable<ChartBehavior> _createDefaultCartesianBehaviors() =>
      new List.from([
        new Hovercard(isMultiValue: true),
        new AxisLabelTooltip()
      ]);

  /// format based on precision
  String _format2num(dynamic value) {
    if (value is num)
      return value.toStringAsFixed(_numPrecision);
    return value;
  }

  /* format based as int
  String _format2int(dynamic value) {
    if (value is num)
      return value.toStringAsFixed(0);
    return value;
  } */

  /// create Charted layout
  void _createLayout() {
    if (_chartHost == null) {
      DivElement chartHostWrapper = new DivElement()
        ..classes.addAll(["chart-host-wrapper"]);
      element.append(chartHostWrapper);
      _chartHost = new DivElement()
        ..classes.addAll(["chart-host"])
        ..dir = "ltr";
      chartHostWrapper.append(_chartHost);
      _legendHost = new DivElement()
        ..classes.addAll(["chart-legend-host"]);
      chartHostWrapper.append(_legendHost);
    }
  }
  DivElement _legendHost;
  DivElement _chartHost;


  ChartState _createState() {
    if (_state == null) {
      _state = new ChartState();
      _state.changes.listen((List<ChangeRecord> changes) {
        for (ChangeRecord change in changes) {
          if (change is ChartHighlightChangeRecord && change.add != null) {
            handleHighlight(change);
          } else if (change is ChartSelectionChangeRecord) {
            if (change.add != null)
              handleSelection(change);
            else if (change.remove != null)
              handleClear();
          }
        }
      });
    }
    dumpData();
    return _state;
  }
  ChartState _state;
  ChartData _data;

  /// dump data
  void dumpData() {
    String info = "";
    int i = 0;
    for (ChartColumnSpec col in _data.columns) {
      info += "\n\tc${i} ${col.label}: ${col.type}";
      i++;
    }
    i = 0;
    for (Iterable row in _data.rows) {
      info += "\n\tr${i} ";
      for (var d in row) {
        info += "\t${d} ";
      }
      i++;
    }
    _log.config("dumpData " + info);
  }


  /// handle Pie Chart click
  void handleSelection(ChartSelectionChangeRecord change) {
    if (syncTable == null)
      return;
    String columnName = null;
    if (_calc.byList.isNotEmpty)
      columnName = _calc.byList.first.key;
    String columnValue = null;
    //
    int id = change.add;
    String info = "handleSelection id=${id} ${columnName}";
    StatPoint rowPoint = null;
    if (id < _metaRowList.length) {
      rowPoint = _metaRowList[id];
      if (rowPoint != null) {
        columnValue = rowPoint.key;
        info += "=${rowPoint.key} count=${rowPoint.count}";

        if (rowPoint.column != null) {
          info += " column=${rowPoint.column.name}";
        }
        if (rowPoint.byPeriod != null) {
          info += " ${rowPoint.byPeriod}";
        }
      }
    }
    if (_calc.dateColumn != null) {
      info += " -- date=${_calc.dateColumn.name} ${_calc.byPeriod}";
    }
    _log.config(info);
    if (columnName != null) {
      int match = syncTable.graphSelect((DRecord record) {
        String recordValue = DataRecord.getColumnValue(record, columnName);
        if (columnValue.isEmpty)
          return recordValue == null || recordValue.isEmpty;
        return recordValue == columnValue;
      });
      if (match != rowPoint.count) {
        info += " <> actual=${match}";
        _log.warning(info);
      }
    }
  } // handleSelection

  /// Clear Table selection
  void handleClear() {
    if (syncTable == null)
      return;
    syncTable.graphSelect(null);
  }

  /// Bar Chart
  void handleHighlight(ChartHighlightChangeRecord change) {
    if (syncTable == null)
      return;
    String columnName = null;
    if (_calc.byList.isNotEmpty)
      columnName = _calc.byList.first.key;
    String columnValue = null;
    String dateColumnName = null;
    String dateColumnValue = null;
    ByPeriod dateByPeriod;

    int col = change.add.first;
    String info = "handleHighlight ${columnName} col=${col}";
    StatPoint colPoint = null;
    if (col < _metaColList.length) {
      colPoint = _metaColList[col];
      if (colPoint != null) {
        columnValue = colPoint.key;
        info += " key=${colPoint.key}";
        if (colPoint.column != null) {
          columnName = colPoint.column.name; // for count
          info += " column=${colPoint.column.name}";
        }
        if (colPoint.dateColumn != null) {
          dateColumnName = colPoint.dateColumn.name; // for count
          info += " date=${colPoint.dateColumn.name}";
        }
        if (colPoint.byPeriod != null) {
          dateByPeriod = colPoint.byPeriod; // for count
          info += " ${colPoint.byPeriod}";
        }
      }
    }
    //
    int row = change.add.last;
    info += " -- row=${row}";
    StatPoint rowPoint = null;
    if (row < _metaRowList.length) {
      rowPoint = _metaRowList[row];
      if (rowPoint != null) {
        dateColumnValue = rowPoint.key;
        info += " key=${rowPoint.key}";
        if (rowPoint.column != null) {
          info += " column=${rowPoint.column.name}";
        }
        if (rowPoint.dateColumn != null) {
          dateColumnName = rowPoint.dateColumn.name;
          info += " date=${rowPoint.dateColumn.name}";
        }
        if (rowPoint.byPeriod != null) {
          dateByPeriod = rowPoint.byPeriod;
          info += " ${rowPoint.byPeriod}";
        }
      }
    }
    if (_calc.dateColumn != null) {
      info += " -- date=${_calc.dateColumn.name} ${_calc.byPeriod}";
    }
    _log.config(info);
    if (columnName != null && dateColumnName != null && dateColumnValue != null) {
      int match = syncTable.graphSelect((DRecord record) {
        // value
        if (columnName != StatCalc.COUNT_COLUMN_NAME) {
          String recordValue = DataRecord.getColumnValue(record, columnName);
          if (columnValue.isEmpty) {
            if (!(recordValue == null || recordValue.isEmpty))
              return false;
          } else {
            if (recordValue != columnValue)
              return false;
          }
        }
        // date
        String dateValue = DataRecord.getColumnValue(record, dateColumnName);
        return isDateMatch(dateValue, dateColumnValue, dateByPeriod);
      });
      info += " match=${match}";
      _log.fine(info);
    }
  } // handleHighlight

  static bool isDateMatch(String dateValue, String dateColumnValue, ByPeriod dateByPeriod) {
    if (dateValue == null || dateValue.isEmpty)
      return false;
    if (dateValue == dateColumnValue)
      return true;
    int time = int.parse(dateValue, onError: (_){return null;});
    if (time == null)
      return false;
    DateTime date0 = new DateTime.fromMicrosecondsSinceEpoch(time, isUtc: true);
    date0 = StatPoint.getDateKey(date0, dateByPeriod);
    return date0.millisecondsSinceEpoch.toString() == dateColumnValue;
  }


} // EngineCharted
