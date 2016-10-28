/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/**
 * Graph Presentation via Charted
 *
 * Planned Improvements:
 * - values added Legend: DefaultCartesianAreaImpl._updateLegend
 * - remove 0 value lines in Hover: Hovercard._getMeasuresData -> _createHovercardItem
 */
class EngineCharted
    extends EngineChartedContainer
    with EngineBase {

  static final Logger _log = new Logger("EngineCharted");

  static const String _TYPE_PIE = "pie";
  static const String _TYPE_BAR = "bar";
  static const String _TYPE_STACKED = "stacked";

  /// Sum Unicode SUMMATION 2211 (large) SIGMA 03A3 (smaller)
  static const String SUMMATION ="\u{03A3}";

  GraphCalc _calc;
  int _numPrecision = 2;
  String _graphType;

  List<StatPoint> _metaRowList = new List<StatPoint>();
  List<StatPoint> _metaColList = new List<StatPoint>();
  /// need label update
  bool needLabelUpdate = false;

  /**
   * Charted Engine
   */
  EngineCharted() {
    element.attributes["data-no"] = no.toString();
  }

  /// Graph Element
  Element getElement() {
    return element;
  }

  /// reset elements
  void reset() {
    _log.fine("reset #${no}");
    resetContainer(); // EngineChartedContainer
    _state = null;
    _metaRowList.clear();
    _metaColList.clear();
  }

  /**
   * Render stacked bar chart - true if rendered
   */
  bool renderStacked(GraphCalc calc, bool displayHorizontal) {
    _calc = calc;
    needLabelUpdate = false;
    _numPrecision = _calc.decimalDigits;
    bool rendered = false;
    for (StatBy by in _calc.byList) {
      if (by.byPeriod == null)
        continue;
      if (by.byValueList.isEmpty)
        continue; // no data

      rendered = true;
      _graphType = _TYPE_STACKED;
      int width = _createLayout(displayHorizontal);

      // config
      List<int> measures = new List<int>();
      for (int i = 0; i < by.byValueList.length; i++) {
        measures.add(i + 1);
      }

      ChartSeries series = new ChartSeries(_calc.tableName,
          measures,
          new StackedBarChartRenderer(alwaysAnimate: true));
      Iterable<ChartSeries> seriesList = [series];
      Iterable<int> dimensionList = [0];
      String vv = by.hasSum ? by.sum.toStringAsFixed(1) : by.count.toStringAsFixed(0);
      String tt = "${by.label} - ${calc.label} ${SUMMATION} ${vv}";
      ChartConfig config = new ChartConfig(seriesList, dimensionList)
        ..legend = new ChartLegend(_legendHost,
            showValues: true,
            title: tt);
      _setChartSize(config, width, false);
      //window.console.dir(config);

      // data
      _data = new ChartData(_stackedColumns(by), _stackedRows(by));
      //window.console.dir(_data);

      // area
      _createState();
      CartesianArea area = new CartesianArea(_chartHost, _data, config,
          state:_state,
          useTwoDimensionAxes:false,
          useRowColoring:false);
      area.theme = new EngineChartedTheme();
      _createDefaultCartesianBehaviors().forEach((behavior) {
        area.addChartBehavior(behavior);
      });
      window.console.dir(area);
      area.draw(preRender: true); // TODO charted crashes with 1.17.1
      _log.fine("renderStacked ${calc.key} E${no} needLabel=${needLabelUpdate}");
    }
    if (!rendered && _calc.byDateList != null && _calc.byDateList.isNotEmpty) {
      return renderBar(_calc, displayHorizontal);
    }
    return rendered;
  } // renderStackedChart

  /// stacked columns (by values)
  List<ChartColumnSpec> _stackedColumns(StatBy by) {
    List<ChartColumnSpec> list = new List<ChartColumnSpec>();
    if (by.updateLabels())
      needLabelUpdate = true;
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
    _log.fine("stackedRows E${no} rows=${list.length}|${dateLabels.length}|${datePoints.length} cols=${by.byValueList.length}");
    return list;
  } // stackedRows


  /**
   * Render Bar Chart
   */
  bool renderBar(GraphCalc calc, bool displayHorizontal) {
    _calc = calc;
    needLabelUpdate = false;
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
    //window.console.dir(_data);
    _graphType = _TYPE_BAR;
    int width = _createLayout(displayHorizontal);

    ChartSeries series = new ChartSeries(_calc.tableName, [1],
        new BarChartRenderer(alwaysAnimate: true));
    Iterable<ChartSeries> seriesList = [series];
    Iterable<int> dimensionList = [0];
    ChartConfig config = new ChartConfig(seriesList, dimensionList)
      ..legend = new ChartLegend(_legendHost,
          showValues: true,
          title: _calc.label);
    //window.console.dir(config);
    _setChartSize(config, width, false);

    // area
    _createState();
    CartesianArea area = new CartesianArea(_chartHost, _data, config,
        state:_state,
        useTwoDimensionAxes:false,
        useRowColoring:true); // different color per bar
    area.theme = new EngineChartedTheme();
    _createDefaultCartesianBehaviors().forEach((behavior) {
      area.addChartBehavior(behavior);
    });
    //window.console.dir(area);
    area.draw(); // TODO: charted crashes with 1.17.1
    _log.fine("renderBar ${calc.key} E${no} needLabel=${needLabelUpdate}");
    return true;
  } // renderBar

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
  bool renderPie(GraphCalc calc, bool displayHorizontal) {
    _calc = calc;
    needLabelUpdate = false;
    _numPrecision = _calc.decimalDigits;
    bool rendered = false;
    bool isDonut = true;
    for (StatBy by in _calc.byList) {
      if (by.count == 0)
        continue;

      rendered = true;
      _graphType = _TYPE_PIE;
      int width = _createLayout(displayHorizontal);
      //
      if (by.updateLabels())
        needLabelUpdate = true;

      ChartSeries series = new ChartSeries(_calc.tableName, [1],
          new PieChartRenderer(innerRadiusRatio: isDonut ? 0.5 : 0,
              statsMode: PieChartRenderer.STATS_VALUE_PERCENTAGE,
              showLabels: true,
              sortDataByValue: false));
      String vv = by.hasSum ? by.sum.toStringAsFixed(1) : by.count.toStringAsFixed(0);
      String tt = "${by.label} - ${calc.label} ${SUMMATION} ${vv}";
      ChartConfig config = new ChartConfig([series], [0])
        ..legend = new ChartLegend(_legendHost,
            title: tt,
            showValues: true);
      _setChartSize(config, width, false);

      _data = new ChartData(_byColumns(calc.label, by), _byRows(by));

      _createState();
      LayoutArea area = new LayoutArea(_chartHost, _data, config,
          state:_state);
      area.theme = new EngineChartedTheme();
      _createDefaultCartesianBehaviors().forEach((behavior) {
        area.addChartBehavior(behavior);
      });
      area.draw();
      _log.fine("renderPie ${calc.key} E${no} needLabel=${needLabelUpdate}");
    }
    return rendered;
  } // renderPie

  /// pie column list
  List<ChartColumnSpec> _byColumns(String whatLabel, StatBy by) {
    List<ChartColumnSpec> list = new List<ChartColumnSpec>();
    if (by.updateLabels())
      needLabelUpdate = true;
    ChartColumnSpec column = new ChartColumnSpec(label:by.label, type: ChartColumnSpec.TYPE_STRING);
    list.add(column);
    _metaColList.add(by);

    column = new ChartColumnSpec(label:whatLabel, type: ChartColumnSpec.TYPE_NUMBER);
    list.add(column);
    _metaColList.add(by);

    /* for (StatPoint point in by.byValueList) {
      FormatFunction formatter = _format2num;
      column = new ChartColumnSpec(label:point.label,
          type: ChartColumnSpec.TYPE_NUMBER,
          formatter:formatter);
      list.add(column);
      _metaColList.add(point);
    }*/
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

  /// create State
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
  } // createState
  ChartState _state;


  /// handle Pie Chart click or legend click
  void handleSelection(ChartSelectionChangeRecord change) {
    if (syncTable == null)
      return;
    String columnName = null;
    if (_calc.byList.isNotEmpty)
      columnName = _calc.byList.first.key;
    if (columnName == null)
      return; // count/display on bar
    String columnValue = null;
    //
    int id = change.add;
    String info = "handleSelection E${no} id=${id} ${columnName}";
    StatPoint point = null;
    if (id < _metaRowList.length && _graphType == _TYPE_PIE) {
      point = _metaRowList[id];
      if (point != null) {
        columnValue = point.key;
        info += "=${point.key} (row) count=${point.count}";

        if (point.column != null) {
          info += " column=${point.column.name}";
        }
        if (point.byPeriod != null) {
          info += " ${point.byPeriod}";
        }
      }
    }
    if (point == null && id < _metaColList.length) { // legend
      point = _metaColList[id];
      if (point != null) {
        columnValue = point.key;
        info += "=${point.key} (col) count=${point.count}";

        if (point.column != null) {
          info += " column=${point.column.name}";
        }
        if (point.byPeriod != null) {
          info += " ${point.byPeriod}";
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
        if (columnValue == null || columnValue.isEmpty)
          return recordValue == null || recordValue.isEmpty;
        return recordValue == columnValue;
      });
      if (point != null && match != point.count) {
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

  /// handle Bar/Stacked Chart click
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
    String info = "handleHighlight E${no} ${columnName} col=${col}";
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
      if (dateColumnName == null) {
        dateColumnName = _calc.dateColumn.name;
      }
      if (dateByPeriod == null) {
        dateByPeriod = _calc.byPeriod;
      }
    }
    _log.config(info);
    if (columnName != null && dateColumnName != null && dateColumnValue != null) {
      int match = syncTable.graphSelect((DRecord record) {
        // value
        if (groupByColumnNames.contains(columnName)) {
          String recordValue = DataRecord.getColumnValue(record, columnName);
          if (columnValue.isEmpty) {
            if (!(recordValue == null || recordValue.isEmpty))
              return false;
          } else {
            if (recordValue != columnValue)
              return false;
          }
        }
        // value matches - compare date
        String dateValue = DataRecord.getColumnValue(record, dateColumnName);
        return isDateMatch(dateValue, dateColumnValue, dateByPeriod);
      });
      info += " match=${match}";
      _log.fine(info);
    }
  } // handleHighlight

  /// Match Date [recordValue] to [targetValue] based on [dateByPeriod]
  static bool isDateMatch(String recordValue,
      String targetValue,
      ByPeriod dateByPeriod,
      {bool isUtc:true}) {
    if (recordValue == null || recordValue.isEmpty)
      return false;
    if (recordValue == targetValue)
      return true;
    int time = int.parse(recordValue, onError: (_){return null;});
    if (time == null)
      return false;
    DateTime dateRecord = new DateTime.fromMillisecondsSinceEpoch(time, isUtc: isUtc);
    DateTime dateCmp = StatPoint.getDateKey(dateRecord, dateByPeriod);
    return dateCmp.millisecondsSinceEpoch.toString() == targetValue;
  }


} // EngineCharted
