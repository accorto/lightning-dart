/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_graph;

/**
 * Graph Panel
 */
class GraphPanel
    extends LComponent {

  static final Logger _log = new Logger("GraphPanel");

  /// chart engine
  final EngineBase engine = new EngineCharted();
  /// engine element
  Element get element => engine.element;

  /// KPI / Element name/id
  final String id;
  final String tableName;

  final List<GraphCalc> _calcList = new List<GraphCalc>();
  final List<GraphMatch> _matchList = new List<GraphMatch>();
  final List<GraphBy> _byList = new List<GraphBy>();

  ByPeriod _byPeriod;

  /**
   * Graph Panel
   */
  GraphPanel(String this.id, String this.tableName,
    {String title, String subTitle}) {
    element.id = id;
    if (title != null)
      engine.title = title;
    if (subTitle != null)
      engine.subTitle = subTitle;
  }

  /// reset panel
  void reset() {
    _calcList.clear();
    _matchList.clear();
    _byList.clear();
    _byPeriod = null;
  }

  /// calc sum for numeric value of [columnName]
  void calc(String columnName, String label, String dateColumnName, {int numPrecision:2}) {
    _log.fine("calc ${columnName} (${dateColumnName})");
    _calcList.add(new GraphCalc(tableName, columnName, label,
        dateColumnName, numPrecision:numPrecision));
  }

  /// match
  void matchRegex(String columnName, RegExp regex) {
    _log.fine("matchRegex ${columnName} ${regex}");
    _matchList.add(new GraphMatch(columnName, MatchType.Regex)
      ..regex = regex);
  }
  /// match
  void matchNum(String columnName, MatchOpNum op, num value) {
    _log.fine("matchNum ${columnName} ${op} ${value}");
    _matchList.add(new GraphMatch(columnName, MatchType.Num)
      ..numOp = op
      ..numValue = value);
  }
  /// match
  void matchDate(String columnName, MatchOpDate op) {
    _log.fine("matchDate ${columnName} ${op}");
    _matchList.add(new GraphMatch(columnName, MatchType.Date)
      ..dateOp = op);
  }
  /// match
  void matchNull(String columnName) {
    _log.fine("matchNull ${columnName}");
    _matchList.add(new GraphMatch(columnName, MatchType.Null));
  }
  /// match
  void matchNotNull(String columnName) {
    _log.fine("matchNull ${columnName}");
    _matchList.add(new GraphMatch(columnName, MatchType.NotNull));
  }

  /// add Group By
  void by(String columnName, String label, Map<String, String> keyLabelMap) {
    _log.fine("by ${columnName} ${keyLabelMap.keys}");
    _byList.add(new GraphBy(columnName, label, keyLabelMap));
  } // by

  /// by period
  void byPeriod(ByPeriod byPeriod) {
    _log.fine("byPeriod ${byPeriod}");
    _byPeriod = byPeriod;
  }

  /**
   * Calculate  Value
   */
  void calculate(List<DRecord> records) {
    _log.config("calculate '${tableName}' records=${records.length}") ;
    for (GraphCalc calc in _calcList) {
      calc.resetCalc(_matchList, _byList, _byPeriod);
      for (DRecord record in records) {
        calc.calculateRecord(record);
      }
    }
  } // calculate

  /// display
  void display() {
    engine.reset();
    for (GraphCalc calc in _calcList) {
      calc.display(engine);
    }
  }

} // GraphPanel
