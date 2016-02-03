/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Table Header Cell
 */
class LTableHeaderCell
    extends LTableCell {

  /**
   * Table Header Cell
   */
  LTableHeaderCell(TableCellElement element,
      Element content,
      String name,
      String label,
      String value,
      String align,
      TableSortClicked tableSortClicked,
      DataColumn dataColumn)
      : super(element,
          content,
          name,
          label,
          value,
          align,
          dataColumn,
          false) {

    // set before element.attributes["scope"] = "col";
    if (tableSortClicked != null) {
      sortable = true;
      sortAsc = true;
      DataType dataType = null;
      if (dataColumn != null)
        dataType = dataColumn.tableColumn.dataType;
      element.onClick.listen((MouseEvent evt) {
        sortAsc = !sortAsc; // toggle
        tableSortClicked(name, sortAsc, dataType, evt);
      });
    }
  } // LTableHeaderCell

  /// Sortable
  bool get sortable => cellElement.classes.contains(LTable.C_IS_SORTABLE);
  void set sortable (bool newValue) {
    if (newValue) {
      cellElement.classes.add(LTable.C_IS_SORTABLE);
      if (sortAsc == null)
        sortAsc = true;
    } else {
      cellElement.classes.remove(LTable.C_IS_SORTABLE);
    }
  }

  /// Sort Direction
  bool get sortAsc => _sortAsc != null && _sortAsc;
  void set sortAsc (bool newValue) {
    // ensure th class
    if (!cellElement.classes.contains(LTable.C_IS_SORTABLE))
      cellElement.classes.add(LTable.C_IS_SORTABLE);
    _sortAsc = newValue;
    _addSort();
    if (_sortAsc) {
      _sortButton.icon.linkName = LIconUtility.ARROWDOWN;
      _sortButton.assistiveText = LTable.lTableColumnSortDec();
    } else {
      _sortButton.icon.linkName = LIconUtility.ARROWUP;
      _sortButton.assistiveText = LTable.lTableColumnSortAsc();
    }
  }
  bool _sortAsc;
  LButton _sortButton;

  /// Add Sort button
  void _addSort() {
    if (_sortButton == null) {
      _sortButton = new LButton.iconBare("sort-",
          new LIconUtility(LIconUtility.ARROWDOWN, className: LButton.C_BUTTON__ICON, size: LButton.C_BUTTON__ICON__SMALL),
          LTable.lTableColumnSortDec());
      cellElement.append(_sortButton.element);
    }
  }

} // LTableHeaderCell
