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
    extends StatCalc {

  static final Logger _log = new Logger("GraphCalc");

  List<GraphMatch> _matchList;

  /**
   * KPI Metric Calculation
   */
  GraphCalc(String tableName, DColumn column)
      : super(tableName, column);

  /// reset
  void resetCalcGraph(List<GraphMatch> matchList,
      List<GraphBy> byList,
      DColumn dateColumn,
      ByPeriod byPeriod) {
    resetCalc(byList, dateColumn, byPeriod);
    _matchList = matchList;
  } // reset


  /**
   * Calculate individual Point
   */
  void calculatePoint(DRecord record,
      num value, String valueString, DateTime recordDate, String dateString) {
    if (_match(record, value, valueString, recordDate, dateString)) {
      super.calculatePoint(record, value, valueString, recordDate,dateString);
    } else {
      _log.finer("calculatePoint ${label} NoMatch value=${value} ${recordDate}");
    }
  } // calculatePoint

  /**
   * Match Records
   */
  bool _match(DRecord record,
      num value, String valueString, DateTime date, String dateString) {
    for (GraphMatch match in _matchList) {
      // restrict value
      if (match.columnName == key) {
        if (!match.valueMatch(value, valueString)) {
          return false;
        }
      }
      else if (match.columnName == dateColumn.name) {
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
  void display(EngineBase engine) {
    _log.info("display ${tableName}.${key} ${label}\n${toStringX('')}"); // updates by labels

    if (engine.renderStacked(this))
      return; // su
    if (engine.renderPie(this))
      return;

    ParagraphElement p = new ParagraphElement()
      ..classes.add(LMargin.C_BOTTOM__SMALL);
    if (count == 0) {
      p.text = "- ${StatCalc.statCalcNoData()} -";
    } else {
      p.text = toString();
    }
    engine.element.append(p);
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

} // GraphCalc
