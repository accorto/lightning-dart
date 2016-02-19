/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Table Summary Cell
 */
class LTableSumCell
    extends LTableCell {

  final StatCalc statCalc;

  /**
   * Table Summary Cell
   */
  LTableSumCell(TableCellElement element,
      String name,
      String label,
      String value,
      String align,
      StatCalc this.statCalc)
      :super(element,
        new DivElement(),
        name,
        label,
        value,
        align,
        null,
        false) {

    // content
    LIconUtility icon = new LIconUtility(LIconUtility.INFO,
        size: LIcon.C_ICON__X_SMALL, addlCss: [LMargin.C_RIGHT__X_SMALL]);
    content
      ..classes.addAll(["cell-sum", LText.C_TRUNCATE])
      ..append(icon.element)
      ..appendText(value);

    // pop content
    LPopover pop = new LPopover();
    pop.headText = statCalc.column.label;
    DListUtil info = _info();
    pop.body.append(info.element);
    content.remove();
    pop.showAboveElement(content);
    // add pop
    cellElement.children.clear();
    cellElement.append(pop.element);
  } // LTableSumCell


  /// Popup Info
  DListUtil _info () {
    DListUtil info = new DListUtil();
    info.add(tableSumCellCount(), statCalc.count);
    info.add("- " + tableSumCellNull(), statCalc.nullCount);

    if (DataTypeUtil.isDate(statCalc.dataType)) {
      DateFormat df = ClientEnv.dateFormat_ymd;
      bool isUtc = true;
      if (statCalc.dataType == DataType.DATETIME) {
        df = ClientEnv.dateFormat_ymd_hm;
        isUtc = false;
      } else if (statCalc.dataType == DataType.TIME) {
        df = ClientEnv.dateFormat_hm;
        isUtc = false;
      }
      DateTime dt;
      if (statCalc.hasMinMax) {
        dt = new DateTime.fromMillisecondsSinceEpoch(statCalc.min.toInt(), isUtc:isUtc);
        info.add(tableSumCellMin(), df.format(dt));
        dt = new DateTime.fromMillisecondsSinceEpoch(statCalc.max.toInt(), isUtc:isUtc);
        info.add(tableSumCellMax(), df.format(dt));
      }
      if (statCalc.hasSum && statCalc.avg != 0) {
        dt = new DateTime.fromMillisecondsSinceEpoch(statCalc.avg.toInt(), isUtc:isUtc);
        info.add(tableSumCellAvg(), df.format(dt));
      }
    } else { // duration
      if (statCalc.hasMinMax) {
        info.add(tableSumCellMin(), statCalc.min);
        info.add(tableSumCellMax(), statCalc.max);
      }
      if (statCalc.hasSum) {
        info.add(tableSumCellAvg(), statCalc.avg.toStringAsFixed(statCalc.decimalDigits));
        info.add(tableSumCellSum(), statCalc.sum.toStringAsFixed(statCalc.decimalDigits));
      }
    }

    return info;
  } // info


  static String tableSumCellTotal() => Intl.message("Total Records", name: "tableSumCellTotal");
  static String tableSumCellCount() => Intl.message("Records with values", name: "tableSumCellCount");
  static String tableSumCellNull() => Intl.message("no Value", name: "tableSumCellNull");

  static String tableSumCellMin() => Intl.message("Min", name: "tableSumCellMin");
  static String tableSumCellMax() => Intl.message("Max", name: "tableSumCellMax");
  static String tableSumCellAvg() => Intl.message("Average", name: "tableSumCellAvg");
  static String tableSumCellSum() => Intl.message("Sum", name: "tableSumCellSum");

} // LTableSumCell
