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
  void setStatistics(TableStatistics statistics,
      {AppsActionTriggered recordAction,
      String label}) {
    this.statistics = statistics;
    this.recordAction = recordAction;
    //
    if (label == null)
      data.record.clearDrv();
    else
      data.record.drv = label;
    //
    rowElement.children.clear();
    display();
  }
  TableStatistics statistics;


  /// display stat record
  void display() {
    for (String name in nameList) {
      TableCellElement tc = new Element.td();
      rowElement.append(tc);

      if (name == null) { // select column
        LIconUtility icon = new LIconUtility(
            statistics == null ? LIconUtility.SUMMARYDETAIL : LIconUtility.SUMMARY,
            color: LIcon.C_ICON_TEXT_DEFAULT,
            size: LIcon.C_ICON__X_SMALL);
        if (statistics == null) {
          String title = data.record.who;
          if (title.isEmpty)
            title = data.record.drv;
          icon.title = title;
          rowElement.title = title;
        } else {
          icon.title = lTableSumRowSummary();
        }
        tc.append(icon.element);
        continue;
      }
      if (name == DataRecord.URV || name == "Id") {
        Element small = new Element.tag("small")
          ..text = data.record.drv;
        tc.append(small);
        continue;
      }
      //
      String value = "";
      String align = null;

      if (statistics == null) { // group by
        DataColumn dataColumn = findColumn(name);
        if (dataColumn != null && dataColumn.isValueRenderElement) {
          continue; // boolean
        }
        DEntry entry = data.getEntry(null, name, false);
        if (entry != null) {
          value = DataRecord.getEntryValue(entry);
          align = _displayAlign(dataColumn);
          //
          _displayRo(name, value, align, dataColumn, entry, false, tc:tc);
        }
      } else { // footer
        //
        StatCalc calc = findCalc(name);
        if (calc == null) {
          continue;
        }

        String label = calc.column.label;
        DataType dt = calc.column.dataType;
        if (DataTypeUtil.isCenterAligned(dt))
          align = LTable.C_TEXT_CENTER;
        else if (DataTypeUtil.isRightAligned(dt))
          align = LTable.C_TEXT_RIGHT;
        //
        if (DataTypeUtil.isNumber(dt) || dt == DataType.DURATIONHOUR) {
          value = calc.sum.toStringAsFixed(calc.decimalDigits);
        } else if (dt == DataType.DURATION) {
          value = calc.count.toString();
        } else {
          value = calc.count.toString();
        }
        new LTableSumCell(tc, name, label, value, align, calc);
      } // statistics
    } // for all column names
  } // display


  /// find calc with name
  StatCalc findCalc(String name) {
    if (statistics != null) {
      for (StatCalc calc in statistics.calcList) {
        if (calc.column.name == name) {
          return calc;
        }
      }
    }
    return null;
  }

  /// add group by cell
  LTableCell addCell(Element content,
      String name,
      String value,
      String align,
      DataColumn dataColumn,
      {bool fieldEdit: false,
      bool addStatistics: true,
      TableCellElement tc}) {
    if (content != null)
      content.classes.add("cell-by");
    return super.addCell(content,
        name, value, align, dataColumn,
        fieldEdit:fieldEdit, addStatistics:addStatistics, tc:tc);
  }


  static String lTableSumRowSummary() => Intl.message("Summary", name: "lTableSumRowSummary");

} // LTableSumRow
