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
  LTableSumRow(LTable ltable, TableRowElement rowElement,
      int rowIndex,
      String cssClass,
      String type)
      : super (ltable, rowElement,
        rowIndex,
        null, // rowValue
        cssClass,
        type,
        null); // actions


  /// set Record statistics
  void setStatistics(TableStatistics statistics, String label,
      bool addTrailingCell) {
    this.statistics = statistics;
    //
    if (label == null)
      data.record.clearDrv();
    else
      data.record.drv = label;
    //
    rowElement.children.clear();
    display(false);
    if (addTrailingCell) {
      rowElement.addCell();
    }
  }
  TableStatistics statistics;


  /// display stat record
  void display(bool redisplay) {
    rowElement.children.clear();
    for (String name in ltable.nameList) {
      TableCellElement tc = rowElement.addCell();

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
          align = getDisplayAlign(dataColumn);
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
          align = LText.C_TEXT_ALIGN__CENTER;
        else if (DataTypeUtil.isRightAligned(dt))
          align = LText.C_TEXT_ALIGN__RIGHT;
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
    display_hideColumns();
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
      String label,
      String value,
      String align,
      DataColumn dataColumn,
      {bool fieldEdit: false,
      bool addStatistics: true,
      TableCellElement tc}) {
    if (content != null)
      content.classes.add("cell-by");
    return super.addCell(content,
        name, label, value, align, dataColumn,
        fieldEdit:fieldEdit, addStatistics:addStatistics, tc:tc);
  }


  static String lTableSumRowSummary() => Intl.message("Summary", name: "lTableSumRowSummary");

} // LTableSumRow
