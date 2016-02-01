/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Table Summary Row (by, footer)
 */
class LTableSumRow
    extends LTableRow {

  /**
   * Table Summary Row
   */
  LTableSumRow(TableRowElement element,
      int rowNo,
      String idPrefix,
      String cssClass,
      bool rowSelect,
      List<String> nameList,
      Map<String,String> nameLabelMap,
      String type,
      List<DataColumn> dataColumns)
      : super (element,
        rowNo,
        idPrefix,
        null, // rowValue
        cssClass,
        rowSelect,
        nameList,
        nameLabelMap,
        type,
        null, // actions
        dataColumns);



  /// set Record statistics
  void setStatistics(TableStatistics statistics, {AppsActionTriggered recordAction}) {
    this.recordAction = recordAction;
    this.statistics = statistics;
    display();
  }
  TableStatistics statistics;


  void display() {
    if (statistics == null)
      return;

    for (String name in nameList) {
      TableCellElement tc = new Element.td();
      rowElement.append(tc);
      if (name == null) {
        continue;
      }
      StatCalc calc = null;
      for (StatCalc c in statistics.calcList) {
        if (c.column.name == name) {
          calc = c;
          break;
        }
      }

      if (calc == null) {
        continue;
      }

      String label = calc.column.label;
      String value = "";

      String align = null;
      DataType dt = calc.column.dataType;
      if (DataTypeUtil.isCenterAligned(dt))
        align = LTable.C_TEXT_CENTER;
      else if (DataTypeUtil.isRightAligned(dt))
        align = LTable.C_TEXT_RIGHT;


      if (name == DataRecord.URV || name == "Id") {
      //  addCellUrv(record, recordAction);
      } else {
        if (DataTypeUtil.isNumber(dt)) {
          value = calc.sum.toStringAsFixed(calc.decimalDigits);
        } else {
          value = calc.count.toString();
        }
        new LTableSumCell(tc, name, label, value, align, calc);
      }
    } // for all column names
  } // display


} // LTableSumRow
