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
  LTableHeaderRow(TableRowElement element,
      int rowNo,
      String idPrefix,
      String cssClass,
      bool rowSelect,
      List<String> nameList,
      Map<String,String> nameLabelMap,
      this.tableSortClicked,
      List<AppsAction> tableActions,
      List<DataColumn> dataColumns)
      : super (element,
        rowNo,
        idPrefix,
        null, // rowValue
        cssClass,
        rowSelect,
        nameList,
        nameLabelMap,
        LTableRow.TYPE_HEAD,
        tableActions,
        dataColumns);

  /**
   * Add Cell with Header Text
   * with [label] of column [name] with optional [value]
   * - name/label are used for responsive
   */
  LTableHeaderCell addHeaderCell(String name, String label, {String value, String align, DataColumn dataColumn}) {
    SpanElement span = new SpanElement()
      ..classes.add(LText.C_TRUNCATE)
      ..text = label == null ? "" : label;

    if (name != null && name.isNotEmpty && label != null && label.isNotEmpty) {
      int index = rowElement.children.length;
      while (nameList.length < index)
        nameList.add(null);
      nameList.add(name);
      nameLabelMap[name] = label;
    }

    TableCellElement tc = new Element.th()
      ..attributes["scope"] = "col";
    if (_actionCell == null) {
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
