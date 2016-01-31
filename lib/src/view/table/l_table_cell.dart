/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Table Cell
 */
class LTableCell {

  /// td/th
  final TableCellElement cellElement;
  /// Meta Data
  final DataColumn dataColumn;
  /// (Column)Name
  final String name;

  /**
   * Table Cell with [cellElement] all other optional
   */
  LTableCell(TableCellElement this.cellElement,
      Element content,
      String this.name,
      String label,
      String value,
      String align,
      DataColumn this.dataColumn) {
    if (align != null && align.isNotEmpty)
      cellElement.classes.add(align);

    if (name != null)
      cellElement.attributes[Html0.DATA_NAME] = name;
    if (label != null)
      cellElement.attributes[Html0.DATA_LABEL] = label;
    if (value != null)
      cellElement.attributes[Html0.DATA_VALUE] = value;
    if (content != null)
      cellElement.append(content);
  } // LTableCell

} // LTableCell
