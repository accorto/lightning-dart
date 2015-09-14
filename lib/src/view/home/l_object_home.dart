/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;


/**
 * Object Home
 * - List view of the Object with Record Lookup / Search
 */
class LObjectHome extends LPageHeader {

  static const String VIEW_LAYOUT_TABLE = "table";
  static const String VIEW_LAYOUT_CARDS = "cards";
  static const String VIEW_LAYOUT_COMPACT = "compact";

  static const String ID = "oh";

  /// Top Row - Icon - Title - Label - Follow - Actions
  final DivElement _header = new DivElement()
    ..classes.addAll([LGrid.C_GRID, LGrid.C_WRAP, LGrid.C_GRID__ALIGN_SPREAD]);
  /// Top row left
  final DivElement _headerLeft = new DivElement()
    ..classes.addAll([LGrid.C_COL]); // LGrid.C_HAS_FLEXI_TRUNCATE
  final ParagraphElement _headerLeftRecordType = new ParagraphElement()
    ..classes.add(LText.C_TEXT_HEADING__LABEL);

  /// Filter List
  final LObjectHomeFilter filterList = new LObjectHomeFilter();

  final DivElement _headerCenter = new DivElement()
    ..classes.addAll([LGrid.C_COL, LGrid.C_ALIGN_BOTTOM]);
  final LInputSearch _headerFind = new LInputSearch("find", idPrefix:ID);

  /// Top row right
  final DivElement _headerRight = new DivElement()
    ..classes.addAll([LGrid.C_COL, LGrid.C_NO_FLEX, LGrid.C_ALIGN_BOTTOM]);
  final LDropdown _sort = new LDropdown.icon("sort", new LIconUtility(LIconUtility.SORT),
      idPrefix:ID, assistiveText:lObjectHomeSort());
  final LDropdown _viewLayout = new LDropdown.selectIcon(idPrefix:ID);
  final LButtonGroup _actionButtonGroup = new LButtonGroup();

  final ParagraphElement _summary = new ParagraphElement()
    ..classes.addAll([LText.C_TEXT_BODY__SMALL, LMargin.C_TOP__X_SMALL]);

  /// Record Sort
  final RecordSorting recordSorting;

  /**
   * Object Home
   */
  LObjectHome(RecordSorting this.recordSorting) {
    // Header Row
    element.append(_header);
    // div .slds-col
    // - p
    _header.append(_headerLeft);
    _headerLeft.append(_headerLeftRecordType);
    // - div .slds-grid
    DivElement headerLeftGrid = new DivElement()
      ..classes.add(LGrid.C_GRID);
    _headerLeft.append(headerLeftGrid);
    // query options/settings
    headerLeftGrid.append(filterList.lookup.element);
    headerLeftGrid.append(filterList.settings.element);

    _headerFind.placeholder = lObjectHomeFind();
    _headerFind.maxWidth = "20rem";
    _headerCenter.append(_headerFind.element);
    _header.append(_headerCenter);

    _header.append(_headerRight);
    DivElement _headerRightGrid = new DivElement()
      ..classes.add(LGrid.C_GRID);
    _headerRight.append(_headerRightGrid);
    //
    if (recordSorting != null) {
      _sort.right = true;
      _headerRightGrid.append(_sort.element);
    }
    //
    _viewLayout.right = true;
    _viewLayout.headingLabel = lObjectHomeLayoutDisplay();
    _viewLayout.dropdown.addItem(LDropdownItem.create(label: lObjectHomeLayoutTable(), value: VIEW_LAYOUT_TABLE,
    icon: new LIconUtility(LIconUtility.TABLE)));
    _viewLayout.dropdown.addItem(LDropdownItem.create(label: lObjectHomeLayoutCards(), value: VIEW_LAYOUT_CARDS,
    icon: new LIconUtility(LIconUtility.KANBAN)));
    _viewLayout.dropdown.addItem(LDropdownItem.create(label: lObjectHomeLayoutCompact(), value: VIEW_LAYOUT_COMPACT,
    icon: new LIconUtility(LIconUtility.SIDE_LIST)));
    _viewLayout.value = VIEW_LAYOUT_TABLE; // toggles also selectMode
    DivElement _viewWrapper = new DivElement()
      ..classes.add(LButton.C_BUTTON_SPACE_LEFT)
      ..append(_viewLayout.element);
    _headerRightGrid.append(_viewWrapper);

    // Actions
    _actionButtonGroup.id = "oh-action-group";
    _actionButtonGroup.classes.add(LButton.C_BUTTON_SPACE_LEFT);
    _headerRightGrid.append(_actionButtonGroup.element);

    element.append(_summary);
  } // LObjectHome

  /// Object Home from UI
  void setUi(UI ui) {
    recordType = ui.table.label + "s"; // TODO plural
    // sort columns
    if (recordSorting != null) {
      _sort.dropdown.clear();
      for (UIGridColumn gc in ui.gridColumnList) {
        LDropdownItem item = LDropdownItem.create(value:gc.columnName, label:gc.column.label);
        _sort.dropdown.addItem(item);
      }
      _sort.dropdown.editorChange = onSortChange;
    }
  } // setUi

  /// Sort
  void onSortChange(String name, String newValue, DEntry entry, var details) {
    if (recordSorting != null) {
      recordSorting.set(new RecordSort.create(newValue, true));
      recordSorting.sort();
    }
  }

  /**
   * Add Action
   */
  void addAction(AppsAction action) {
    _actionButtonGroup.add(action.asButton(true));
  }
  void setActionGroupLayout(int showCount) {
    _actionButtonGroup.layout(showCount);
  }

  /// Set Find Editor Change
  void set findEditorChange (EditorChange editorChange) {
    _headerFind.editorChange = editorChange;

  }


  /// View Layout get e.g. VIEW_LAYOUT_TABLE
  String get viewLayout => _viewLayout.value;
  /// View Layout set e.g. VIEW_LAYOUT_TABLE
  void set viewLayout (String newValue) {
    _viewLayout.value = newValue;
  }
  /// View Change callback
  void set viewLayoutChange (EditorChange newValue) {
    _viewLayout.editorChange = newValue;
  }


  /// Record Type Text
  String get recordType => _headerLeftRecordType.text;
  /// Record Type Text
  void set recordType(String newValue) {
    _headerLeftRecordType.text = newValue;
  }

  /// Summary Info
  void set summary (String newValue) {
    _summary.text = newValue;
  }

  // Trl

  static String lObjectHomeLayoutDisplay() => Intl.message("Display as", name: "lObjectHomeLayoutDisplay");
  static String lObjectHomeLayoutTable() => Intl.message("Table", name: "lObjectHomeLayoutTable");
  static String lObjectHomeLayoutCards() => Intl.message("Cards", name: "lObjectHomeLayoutCards");
  static String lObjectHomeLayoutCompact() => Intl.message("Compact List", name: "lObjectHomeLayoutCompact");

  static String lObjectHomeFind() => Intl.message("Find in View", name: "lObjectHomeFind");

  static String lObjectHomeSort() => Intl.message("Sort", name: "lObjectHomeSort");

  static String lObjectHomeSave() => Intl.message("Save", name: "lObjectHomeSave", args: []);

} // LObjectHome
