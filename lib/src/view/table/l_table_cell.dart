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
  /// content renderer
  final Element content;
  /// (Column)Name
  final String name;
  /// Data Value
  final String value;
  /// Alignment
  final String align;
  /// Meta Data
  final DataColumn dataColumn;

  /**
   * Table Cell with [cellElement] all other optional
   * [align] like LTable.C_TEXT_CENTER
   */
  LTableCell(TableCellElement this.cellElement,
      Element this.content,
      String this.name,
      String label,
      String this.value,
      String this.align,
      DataColumn this.dataColumn,
      bool addStatistics) {
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
    //
    if (addStatistics)
      renderStatistics();
  } // LTableCell

  /**
   * Set Content Text
   */
  void set contentText(String text) {
    if (content != null)
      content.text = text;
  }

  /// render Statistics
  void renderStatistics() {
    if (dataColumn != null && value != null
        && dataColumn.statCol != null) {
      int percent = dataColumn.statCol.getPercent(value);
      if (percent > 0) {
        content.classes.add(align == LTable.C_TEXT_RIGHT
          ? "cell-stat-right" : "cell-stat-left");
        content.style.backgroundSize = "${percent}% auto";
      }
    }
  }

} // LTableCell
