/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Table Header Row
 */
class LTableHeaderRow
    extends LTableRow {

  // callback
  TableSortClicked tableSortClicked;

  /**
   * Table Header Row
   */
  LTableHeaderRow(LTable ltable, TableRowElement element,
      int rowIndex,
      String cssClass,
      this.tableSortClicked,
      List<AppsAction> tableActions)
      : super (ltable, element,
        rowIndex,
        null, // rowValue
        cssClass,
        LTableRow.TYPE_HEAD,
        tableActions) {
    if (ltable.rowSelect)
      ltable.nameList.add(null);

  } // LTableHeaderRow

  /**
   * Add Cell with Header Text
   * with [label] of column [name] with optional [value]
   * - name/label are used for responsive
   */
  LTableHeaderCell addHeaderCell(String name, String label,
      {String value, String align, DataColumn dataColumn}) {
    SpanElement span = new SpanElement()
      ..classes.add(LText.C_TRUNCATE)
      ..text = label == null ? "" : label;

    if (name != null && name.isNotEmpty && label != null && label.isNotEmpty) {
      //int index = rowElement.children.length -1;
      //while (nameList.length < index)
      //  nameList.add(null);
      ltable.nameList.add(name);
      ltable.nameLabelMap[name] = label;
    }

    TableCellElement tc = new Element.th()
      ..attributes["scope"] = "col";
    if (_actionCell == null || !ltable.rowSelect) {
      rowElement.append(tc);
    } else {
      rowElement.insertBefore(tc, _actionCell.cellElement);
    }
    if (dataColumn == null) {
      dataColumn = findColumn(name);
    }
    LTableHeaderCell cell = new LTableHeaderCell(tc, span, name, label, value, align, tableSortClicked, dataColumn);
    _cells.add(cell);
    return cell;
  } // addHeaderCell

  List<LTableHeaderCell> _cells = new List<LTableHeaderCell>();

  /**
   * Add Grid Column
   */
  void addGridColumn(DataColumn dataColumn) {
    addHeaderCell(dataColumn.name, dataColumn.label, dataColumn:dataColumn);
  }

  /// Set Sorting
  void setSorting(RecordSortList recordSorting) {
    for (LTableHeaderCell cell in _cells) {
      if (cell.sortable) {
        RecordSort sort = recordSorting.getSort(cell.name);
        if (sort == null)
          cell.sortAsc = true;
        else
          cell.sortAsc = sort.isAscending;
      }
    }
  }


} // LTableHeaderRow
