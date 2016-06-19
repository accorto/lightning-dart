/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/**
 * Graph Calculation + Display
 */
class GraphCalc
    extends StatCalc {

  static final Logger _log = new Logger("GraphCalc");


  /**
   * Graph Metric Calculation
   */
  GraphCalc(String tableName, DColumn column)
      : super(tableName, column);


  /// Display - horizontal/vertical or flow
  /// return true if needs to be re-rendered
  bool display(EngineBase engine, bool displayHorizontal) {
    if ((dateColumn != null
        || (byList.isNotEmpty && byList.first.byValueList.isNotEmpty))
        && engine.renderStacked(this, displayHorizontal)) {
      return engine.needLabelUpdate;
    }

    if (engine.renderPie(this, displayHorizontal)) {
      return engine.needLabelUpdate;
    }

    if (count == 0) {
      ParagraphElement p = new ParagraphElement()
        ..classes.add(LMargin.C_BOTTOM__SMALL)
        ..text = "- ${StatCalc.statCalcNoData()} -";
      engine.element.append(p);
    } else {
      LDList info = new LDList();
      engine.element.append(info.element);
      info.add(LTableSumCell.tableSumCellCount(), count);
      info.add(LTableSumCell.tableSumCellNull(), nullCount);
      if (hasMinMax) {
        info.add(LTableSumCell.tableSumCellMin(), this.min);
        info.add(LTableSumCell.tableSumCellMax(), this.max);
      }
      if (hasSum) {
        info.add(LTableSumCell.tableSumCellAvg(), avg.toStringAsFixed(1));
        info.add(LTableSumCell.tableSumCellSum(), this.sum.toStringAsFixed(1));
      }
    }
    //engine.element.style.minHeight = "inherit"; // 300px
    return false;
  } // display

} // GraphCalc
