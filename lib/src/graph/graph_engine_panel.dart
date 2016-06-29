/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/**
 * Graph Engine Panel ("Metric")
 * - host and interface to Engine
 * - part of graph element
 */
class GraphEnginePanel
    extends LComponent {

  static final Logger _log = new Logger("GraphEnginePanel");

  /// chart engine
  final EngineBase engine = new EngineCharted();
  /// engine element
  Element get element => engine.element;

  /// KPI / Element name/id
  final String tableName;

  /// default date column
  DColumn dateColumn;
  /// default by period
  ByPeriod byPeriod;

  final List<GraphCalc> _calcList = new List<GraphCalc>();
  final List<StatMatch> _matchList = new List<StatMatch>();
  final List<StatBy> _byList = new List<StatBy>();

  /**
   * Graph Engine Panel
   */
  GraphEnginePanel(String id,
      String this.tableName,
      List<String> groupByColumnNames,
      {String title, String subTitle}) {
    element.id = "${id}-panel";
    if (groupByColumnNames != null)
      engine.groupByColumnNames = groupByColumnNames;
    if (title != null)
      engine.title = title;
    if (subTitle != null)
      engine.subTitle = subTitle;
  } // GraphPanel

  /// reset panel
  void reset() {
    _calcList.clear();
    _matchList.clear();
    _byList.clear();
  }

  /// calc sum for numeric value of [columnName]
  void calc(DColumn column) {
    _log.fine("calc ${column.name}");
    _calcList.add(new GraphCalc(tableName, column));
  }

  /// match
  void matchRegex(String columnName, RegExp regex) {
    _log.fine("matchRegex ${columnName} ${regex}");
    _matchList.add(new StatMatch(columnName, StatMatchType.Regex)
      ..regex = regex);
  }
  /// match
  void matchNum(String columnName, StatMatchOpNum op, num value) {
    _log.fine("matchNum ${columnName} ${op} ${value}");
    _matchList.add(new StatMatch(columnName, StatMatchType.Num)
      ..numOp = op
      ..numValue = value);
  }
  /// match
  void matchDate(String columnName, StatMatchOpDate op) {
    _log.fine("matchDate ${columnName} ${op}");
    _matchList.add(new StatMatch(columnName, StatMatchType.Date)
      ..dateOp = op);
  }
  /// match
  void matchNull(String columnName) {
    _log.fine("matchNull ${columnName}");
    _matchList.add(new StatMatch(columnName, StatMatchType.Null));
  }
  /// match
  void matchNotNull(String columnName) {
    _log.fine("matchNull ${columnName}");
    _matchList.add(new StatMatch(columnName, StatMatchType.NotNull));
  }

  /// add Group By
  void byX(String columnName, String label, KeyValueMap keyLabelMap) {
    _log.fine("byX ${columnName} ${keyLabelMap.keys}");
    _byList.add(new StatBy(columnName, label, keyLabelMap));
  } // by
  /// add Group By
  void byColumn(DColumn column) {
    _log.fine("by ${column.name}");
    _byList.add(new StatBy.column(column));
  } // by

  /**
   * Calculate  Value
   * see [TableStatistics.calculate]
   */
  void calculateDate(List<DRecord> recordList,
      DColumn dateColumn,
      ByPeriod byPeriod) {
    this.dateColumn = dateColumn;
    this.byPeriod = byPeriod;
    calculate(recordList);
  }
  /**
   * Calculate  Value
   * see [TableStatistics.calculate]
   */
  void calculate(List<DRecord> recordList) {
    _log.config("calculate '${tableName}' records=${recordList.length} calc=${_calcList.length} by=${_byList.length} match=${_matchList.length}");

    // reset
    for (StatCalc what in _calcList) {
      what.resetCalc(_byList, _matchList, dateColumn, byPeriod);
    }
    for (DRecord record in recordList) {
      if (record.hasIsGroupBy())
        continue;
      String dateString = null;
      DateTime recordDate = null;
      if (dateColumn != null) {
        dateString = DataRecord.getColumnValue(record, dateColumn.name);
        recordDate = StatCalc.recordDate(dateString, dateColumn);
      }
      for (StatCalc what in _calcList) {
        what.calculateRecord2(record, recordDate, dateString);
      }
    }
    //
    for (StatCalc what in _calcList) {
      what.dump();
    }
  } // calculate

  /// display - horizontal/vertical or flow
  void display(bool displayHorizontal) {
    engine.reset();
    for (GraphCalc calc in _calcList) {
      _log.config("display ${calc.key} E${engine.no}");
      if (calc.display(engine, displayHorizontal)) {
        new Timer(new Duration(seconds: 2), () {
          _log.config("display ${calc.key} E${engine.no} (again)");
          engine.reset();
          calc.display(engine, displayHorizontal);
        });
      }
    }
  } // display

} // GraphPanel
