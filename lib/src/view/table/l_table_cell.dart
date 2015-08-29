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
  final TableCellElement element;

  /**
   * Table Cell
   */
  LTableCell(TableCellElement this.element, Element content, String name, String label, String value, String align) {
    if (align != null && align.isNotEmpty)
      element.classes.add(align);

    if (name != null)
      element.attributes[Html0.DATA_NAME] = name;
    if (label != null)
      element.attributes[Html0.DATA_LABEL] = label;
    if (value != null)
      element.attributes[Html0.DATA_VALUE] = value;
    element.append(content);
  } // LTableCell

} // TableCell



/**
 * Table Header Cell
 */
class LTableHeaderCell extends LTableCell {

  /**
   * Table Header Cell
   */
  LTableHeaderCell(TableCellElement element, Element content, String name, String label, String value, String align,
        TableSortClicked tableSortClicked)
    : super(element, content, name, label, value, align) {
    // set before element.attributes["scope"] = "col";
    if (tableSortClicked != null) {
      sortable = true;
      sortAsc = true;
      element.onClick.listen((Event evt) {
        sortAsc = !sortAsc; // toggle
        tableSortClicked(name, sortAsc);
      });
    }
  }

  /// Sortable
  bool get sortable => element.classes.contains(LTable.C_IS_SORTABLE);
  void set sortable (bool newValue) {
    if (newValue) {
      element.classes.add(LTable.C_IS_SORTABLE);
      if (sortAsc == null)
        sortAsc = true;
    } else {
      element.classes.remove(LTable.C_IS_SORTABLE);
    }
  }

  /// Sort Direction
  bool get sortAsc => _sortAsc != null && _sortAsc;
  void set sortAsc (bool newValue) {
    // ensure th class
    if (!element.classes.contains(LTable.C_IS_SORTABLE))
      element.classes.add(LTable.C_IS_SORTABLE);
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
      element.append(_sortButton.element);
    }
  }

} // LTableHeaderCell

