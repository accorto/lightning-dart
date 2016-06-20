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

  /// Label
  String label;
  final String title;
  final TableSortClicked tableSortClicked;
  final String idPrefix;

  /**
   * Table Header Cell
   * th
   * - div .slds-truncate
   * -- text
   */
  LTableHeaderCell(TableCellElement element,
      Element content, // div
      String name,
      String label,
      String this.title,
      String value,
      String align,
      TableSortClicked this.tableSortClicked,
      DataColumn dataColumn,
      String this.idPrefix)
      : super(element,
          content,
          name,
          label,
          value,
          align,
          dataColumn,
          false) { // no stats
    this.label = label;

    if (tableSortClicked == null) {
      content
          ..classes.add(LText.C_TRUNCATE)
          ..text = label;
    } else {
      _addSort();
    }
    if (title != null)
      element.title = title;
  } // LTableHeaderCell

  /// Sortable
  bool get sortable => cellElement.classes.contains(LTable.C_IS_SORTABLE);
  void set sortable (bool newValue) {
    cellElement.classes.toggle(LTable.C_IS_SORTABLE, newValue);
    if (newValue) {
      _addSort();
      if (_sortAsc != null)
        sortAsc = _sortAsc;
    } else {
      cellElement.classes.remove(LTable.C_IS_SORTED__ASC);
      cellElement.classes.remove(LTable.C_IS_SORTED__DESC);
      cellElement.attributes.remove(Html0.ARIA_SORT);
    }
  } // sortable

  /// Sort Direction
  bool get sortAsc => _sortAsc != null && _sortAsc;
  void set sortAsc (bool newValue) {
    _addSort(); // ensure setup
    _sortAsc = newValue;

    if (sortAsc) {
      cellElement.classes.add(LTable.C_IS_SORTED__ASC);
      cellElement.classes.remove(LTable.C_IS_SORTED__DESC);
      //  _sortButton.icon.linkName = LIconUtility.ARROWDOWN;
      //  _sortButton.assistiveText = LTable.lTableColumnSortDec();
      cellElement.attributes[Html0.ARIA_SORT] = "ascending";
    } else {
      cellElement.classes.remove(LTable.C_IS_SORTED__ASC);
      cellElement.classes.add(LTable.C_IS_SORTED__DESC);
      //  _sortButton.icon.linkName = LIconUtility.ARROWUP;
      //  _sortButton.assistiveText = LTable.lTableColumnSortAsc();
      cellElement.attributes[Html0.ARIA_SORT] = "descending";
    }
  } // sortAsc
  bool _sortAsc;
  AnchorElement _sort;

  /// Add Sort
  void _addSort() {
    // - a .slds-th__action
    // -- span .slad-assistive-text
    // -- span .truncate
    // -- div .slds-icon_container
    // --- svg
    if (_sort == null) {
      cellElement.classes.add(LTable.C_IS_SORTABLE);
      _sort = new AnchorElement(href: "#")
        ..classes.addAll([LTable.C_TH__ACTION, LInteraction.C_TEXT_LINK__RESET])
        ..id = LComponent.createId(idPrefix, "sort");
      _sort.append(new SpanElement()
        ..classes.add(LText.C_ASSISTIVE_TEXT)
        ..text = label);
      _sort.append(new SpanElement()
        ..classes.add(LText.C_TRUNCATE)
        ..title = (title == null || title.isEmpty) ? label : title
        ..text = label);
      LIcon icon = new LIconUtility(LIconUtility.ARROWDOWN, size: LIcon.C_ICON__X_SMALL,
        color: LIcon.C_ICON_TEXT_DEFAULT, addlCss: [LTable.C_IS_SORTABLE__ICON]);
      _sort.append(new DivElement()
        ..classes.add(LIcon.C_ICON_CONTAINER)
        ..append(icon.element));

      _sort.onClick.listen((MouseEvent evt) {
        evt.preventDefault();
        evt.stopPropagation();
        sortAsc = !sortAsc; // toggle
        tableSortClicked(name, sortAsc, dataType, evt);
      });

      cellElement.children.clear();
      cellElement.append(_sort);
      if (_resizeDiv != null) {
        cellElement.append(_resizeDiv);
      }
    }
  } // addSort

  /// Resizable
  bool get resizeable => cellElement.classes.contains(LTable.C_IS_RESIZABLE);
  void set resizable (bool newValue) {
    cellElement.classes.toggle(LTable.C_IS_RESIZABLE, newValue);
    if (newValue)
      _addResizable();
  }

  /// add resize
  void _addResizable() {
    // table: slds-table--fixed-layout
    // cellElement.style.width = "${}px";
    if (_resizeDiv == null) {
      String resizeId = LComponent.createId(idPrefix, "resize");
      _resizeDiv = new DivElement()
          ..classes.add(LTable.C_RESIZABLE);
      _resizeDiv.append(new LabelElement()
        ..classes.add(LText.C_ASSISTIVE_TEXT)
        ..htmlFor = resizeId
        ..text = "click and drag to resize"
      );
      _resizeDiv.append(new InputElement(type:EditorI.TYPE_RANGE)
        ..classes.addAll([LTable.C_RESIZABLE__INPUT, LText.C_ASSISTIVE_TEXT])
        ..id = resizeId
        ..min = "20"
        ..max = "1000"
      );
      _resizeDiv.append(new SpanElement()
        ..classes.add(LTable.C_RESIZABLE__HANDLE)
        ..append(new SpanElement()
          ..classes.add(LTable.C_RESIZABLE__DIVIDER))
      );
      //
      cellElement.append(_resizeDiv);
    }
  } // _addResizable
  DivElement _resizeDiv;

} // LTableHeaderCell
