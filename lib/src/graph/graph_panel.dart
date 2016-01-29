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


  // element
  final Element element = new Element.article()
    ..classes.add("chart-wrapper")
    ..style.minHeight = "400px";

  DivElement _wrapper = new DivElement()
    ..classes.add("chart-title-wrapper");
  HeadingElement _h2 = new HeadingElement.h2()
    ..classes.add("chart-title");

  /// KPI / Element name/id
  final String id;
  final String tableName;

  /// KPI Label
  final String label;

  String description;

  final List<GraphCalc> _calcList = new List<GraphCalc>();
  final List<GraphMatch> _matchList = new List<GraphMatch>();
  final List<GraphBy> _byList = new List<GraphBy>();

  ByPeriod _byPeriod;

  /**
   * Kpi Metric
   */
  GraphPanel(String this.id, String this.tableName, String this.label) {
    element.id = id;
    _wrapper.append(_h2);
    _h2.text = label;
    element.append(_wrapper); // recreated!
  }

  void reset() {
    _byList.clear();
    _matchList.clear();
    _calcList.clear();
    _byPeriod = null;
  }

  /// calc sum for numeric value of [columnName]
  void calc(String columnName, String label, String dateColumnName, {int numPrecision:2}) {
    _calcList.add(new GraphCalc(tableName, columnName, label,
        dateColumnName, numPrecision:numPrecision));
  }

  /// match
  void matchRegex(String columnName, RegExp regex) {
    _matchList.add(new GraphMatch(columnName, MatchType.Regex)
      ..regex = regex);
  }
  /// match
  void matchNum(String columnName, MatchOpNum op, num value) {
    _matchList.add(new GraphMatch(columnName, MatchType.Num)
      ..numOp = op
      ..numValue = value);
  }
  /// match
  void matchDate(String columnName, MatchOpDate op) {
    _matchList.add(new GraphMatch(columnName, MatchType.Date)
      ..dateOp = op);
  }
  /// match
  void matchNull(String columnName) {
    _matchList.add(new GraphMatch(columnName, MatchType.Null));
  }
  /// match
  void matchNotNull(String columnName) {
    _matchList.add(new GraphMatch(columnName, MatchType.NotNull));
  }

  /// add Group By
  void by(String columnName, String label, Map<String, String> keyLabelMap) {
    _byList.add(new GraphBy(columnName, label, keyLabelMap));
  } // by

  /// by period
  void byPeriod(ByPeriod byPeriod) {
    _byPeriod = byPeriod;
  }

  /**
   * Calculate  Value
   */
  void calculate(List<DRecord> records) {
    // reset
    element.children.clear();
    element.append(_wrapper);
    // calculate
    _log.config("calculate '${label}' records=${records.length}") ;
    for (GraphCalc calc in _calcList) {
      calc.resetCalc(_matchList, _byList, _byPeriod);
      for (DRecord record in records) {
        calc.calculateRecord(record);
      }
    }
  } // calculate

  /// display
  void display() {
    for (GraphCalc calc in _calcList) {
      _log.config("display '${label}': ${calc.toString()}") ;
      calc.display(element);
    }
  }

} // GraphPanel
