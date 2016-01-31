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

  /**
   * Table Summary Cell
   */
  LTableSumCell(TableCellElement element,
      Element content,
      String name,
      String label,
      String value,
      String align,
      DataColumn dataColumn)
      :super(element,
        content,
        name,
        label,
        value,
        align,
        dataColumn) {

  } // LTableSumCell

} // LTableSumCell
