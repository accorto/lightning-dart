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
      //_log.finer("calculatePoint ${label} Match value=${value} ${date}");
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
  void display(EngineBase engine) {
    _log.info("display ${tableName}.${columnName} ${label}\n${toStringX('')}"); // updates by labels

    if (engine.renderStacked(this))
      return; // su
    if (engine.renderPie(this))
      return;

    ParagraphElement p = new ParagraphElement()
      ..classes.add(LMargin.C_BOTTOM__SMALL);
    if (count == 0) {
      p.text = "- ${graphCalcNoData()} -";
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

  /**
   * Dump Info (updated by labels)
   * - byDateList   (GraphPoint - byDateList[GraphPoint])
   * . byList       (GraphCalc - byList[GraphBy])
   * = byValueList  (GraphBy - byValueList[GraphPoint])

      counT(Display):	 count=118 sum=118.0 min=1.0 max=1.0 avg=1.0 nullCount=0
      - 1435449600000(6/28/2015):	 count=17 sum=17.0 min=1.0 max=1.0 avg=1.0 nullCount=0
      - 1420934400000(1/11/2015):	 count=100 sum=100.0 min=1.0 max=1.0 avg=1.0 nullCount=0
      - 1437868800000(7/26/2015):	 count=1 sum=1.0 min=1.0 max=1.0 avg=1.0 nullCount=0
      . Created(Created):	 count=118 sum=118.0 min=1.0 max=1.0 avg=1.0 nullCount=0
      . - 1435449600000(6/28/2015):	 count=17 sum=17.0 min=1.0 max=1.0 avg=1.0 nullCount=0
      . - 1420934400000(1/11/2015):	 count=100 sum=100.0 min=1.0 max=1.0 avg=1.0 nullCount=0
      . - 1437868800000(7/26/2015):	 count=1 sum=1.0 min=1.0 max=1.0 avg=1.0 nullCount=0
      . = 1421107847000(1421107847000):	 count=2 sum=2.0 min=1.0 max=1.0 avg=1.0 nullCount=0
      . = - 1420934400000(1/11/2015):	 count=2 sum=2.0 min=1.0 max=1.0 avg=1.0 nullCount=0
      :: byValueList of byList(GraphBy) not used

      38:47.660  GraphCalc: display AD_Table.counT Display
      counT(Display):	 count=118 sum=118.0 min=1.0 max=1.0 avg=1.0 nullCount=0
      . TableCategory(Category):	 count=118 sum=118.0 min=1.0 max=1.0 avg=1.0 nullCount=0
      . = ASSOCIATION(Association):	 count=3 sum=3.0 min=1.0 max=1.0 avg=1.0 nullCount=0
      . = BASE(Base):	 count=18 sum=18.0 min=1.0 max=1.0 avg=1.0 nullCount=0
      . = DICTIONARY(Dictionary):	 count=66 sum=66.0 min=1.0 max=1.0 avg=1.0 nullCount=0
      . = REFERENCE(Reference):	 count=22 sum=22.0 min=1.0 max=1.0 avg=1.0 nullCount=0
      . = SETTING2(Setting):	 count=1 sum=1.0 min=1.0 max=1.0 avg=1.0 nullCount=0
      . = TRANSACTION(Transaction):	 count=8 sum=8.0 min=1.0 max=1.0 avg=1.0 nullCount=0

   */
  String toStringX(String linePrefix) {
    String s = "${linePrefix}${super.toStringX(linePrefix)}";
    for (GraphBy by in _byList) {
      s += "\n" + by.toStringX("${linePrefix}. ");
    }
    return s;
  }

  static String graphCalcDate() => Intl.message("Date", name: "graphCalcDate");
  static String graphCalcNoData() => Intl.message("No Data", name: "graphCalcNoData");

} // GraphCalc
