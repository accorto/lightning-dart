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


  /**
   * Graph Metric Calculation
   */
  GraphCalc(String tableName, DColumn column)
      : super(tableName, column);


  /// Display
  void display(EngineBase engine) {
    if ((dateColumn != null
        || (byList.isNotEmpty && byList.first.byValueList.isNotEmpty))
        && engine.renderStacked(this)) {
      return;
    }

    if (engine.renderPie(this)) {
      return;
    }

    ParagraphElement p = new ParagraphElement()
      ..classes.add(LMargin.C_BOTTOM__SMALL);
    if (count == 0) {
      p.text = "- ${StatCalc.statCalcNoData()} -";
    } else {
      p.text = toString();
    }
    engine.element.append(p);
  } // display

} // GraphCalc
