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


  /// Top Row - Icon - Title - Label - Follow - Actions
  final DivElement _header = new DivElement()
    ..classes.add(LGrid.C_GRID);
  /// Top row left
  final DivElement _headerLeft = new DivElement()
    ..classes.addAll([LGrid.C_COL, LGrid.C_HAS_FLEXI_TRUNCATE]);
  final ParagraphElement _headerLeftRecordType = new ParagraphElement()
    ..classes.add(LText.C_TEXT_HEADING__LABEL);

  /// Filter List
  final LObjectHomeFilterList filterList = new LObjectHomeFilterList();

  /// Top row right
  final DivElement _headerRight = new DivElement()
    ..classes.addAll([LGrid.C_COL, LGrid.C_NO_FLEX, LGrid.C_ALIGN_BOTTOM]);
  final LDropdown _viewLayout = new LDropdown.selectIcon("vs");
  final LButtonGroup _actionButtonGroup = new LButtonGroup();

  final ParagraphElement _summary = new ParagraphElement()
    ..classes.addAll([LText.C_TEXT_BODY__SMALL, LMargin.C_TOP__X_SMALL]);

  /**
   * Object Home
   */
  LObjectHome() {
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

    _header.append(_headerRight);
    DivElement _headerRightGrid = new DivElement()
      ..classes.add(LGrid.C_GRID);
    _headerRight.append(_headerRightGrid);
    //
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
    _actionButtonGroup.classes.add(LButton.C_BUTTON_SPACE_LEFT);
    _headerRightGrid.append(_actionButtonGroup.element);

    element.append(_summary);
  } // LObjectHome

  /// Object Home from UI
  void setUi(UI ui) {
    recordType = ui.table.label + "s"; // TODO plural

  } // setUi

  /**
   * Add Action
   */
  void addAction(AppsAction action) {
    _actionButtonGroup.add(action.asButton(true));
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



  static String lObjectHomeSave() => Intl.message("Save", name: "lObjectHomeSave", args: []);

} // LObjectHome



/// Execute Filter / Saved Query
typedef void FilterSelectionChange(String name, SavedQuery savedQuery);



/**
 * Maintains Dropdown, Selection and List Maintenance
 */
class LObjectHomeFilterList {

  static final Logger _log = new Logger("LObjectHomeFilterList");

  /// Recent Query List
  static const String RECENT = "recent";
  /// All Query List
  static const String ALL = "all";


  /// Callback on Change
  FilterSelectionChange filterSelectionChange;
  /// Saved Queries
  final List<SavedQuery> _savedQueries = new List<SavedQuery>();

  /// Lookup
  final LObjectHomeFilterLookup lookup = new LObjectHomeFilterLookup();
  /// Filter Maintenance
  final LDropdown settings = new LDropdown(new LButton(new ButtonElement(), "filterList", null,
    icon: new LIconUtility(LIconUtility.FILTERLIST),
    buttonClasses: [LButton.C_BUTTON__ICON_CONTAINER],
    assistiveText: lObjectHomeFilterList()), "idPrefix");


  /**
   * Filter Maintenance
   */
  LObjectHomeFilterList() {
    lookup.editorChange = onEditorChange;
    addFilter(null); // init list
    filterValue = RECENT;

    /// Settings
    settings.classes.add(LMargin.C_LEFT__LARGE);
    settings.headingLabel = lObjectHomeFilterList();
    settings.dropdown.nubbinTop = true;
    settings.dropdown.addItem(LDropdownItem.create(label: "Edit"));
    settings.dropdown.addItem(LDropdownItem.create(label: "New"));
    // TODO _queryViewSettings.editorChange =

  }

  /// Filter Value/Name
  String get filterValue => lookup.value;
  /// Filter Value/Name
  void set filterValue (String newValue) {
    lookup.value = newValue;
  }


  /// Get saved query
  SavedQuery get savedQuery {
    String value = filterValue;
    for (SavedQuery query in _savedQueries) {
      if (query.savedQueryId == value) {
        return query;
      }
    }
    return null;
  } // getSavedQuery

  /// Add new Filter
  void addFilter(SavedQuery savedQuery) {
    if (savedQuery != null) {
      _savedQueries.add(savedQuery);
    }
    List<DOption> options = new List<DOption>();
    options.add(new DOption()
      ..value = RECENT
      ..label = lObjectHomeFilterListRecent());
    for (SavedQuery query in _savedQueries) {
      options.add(new DOption()
        ..value = query.savedQueryId
        ..label = query.name);
    }
    options.add(new DOption()
      ..value = ALL
      ..label = lObjectHomeFilterListAll());
    lookup.options = options;
  }

  /// Lookup changed
  void onEditorChange(String name, String newValue, DEntry entry, var details) {
    if (filterSelectionChange != null) {
      if (newValue == RECENT || newValue == ALL) {
        filterSelectionChange(newValue, null);
      } else {
        for (SavedQuery query in _savedQueries) {
          if (query.savedQueryId == newValue) {
            filterSelectionChange(newValue, query);
            break;
          }
        }
        _log.info("onEditorChange - not found ${newValue}");
      }
    }
  } // onEditorChange


  static String lObjectHomeFilterList() => Intl.message("Filter List", name: "lObjectHomeFilterList");
  static String lObjectHomeFilterListRecent() => Intl.message("Recently viewed", name: "lObjectHomeFilterListRecent");
  static String lObjectHomeFilterListAll() => Intl.message("All records", name: "lObjectHomeFilterListAll");

} // LObjectHomeQueryList


/**
 * Search List Lookup
 */
class LObjectHomeFilterLookup {

  static final Logger _log = new Logger("LObjectHomeQueryList");

  /// Callback
  EditorChange editorChange;

  final DivElement element = new DivElement()
    ..classes.addAll([LDropdown.C_DROPDOWN_TRIGGER]);

  final DivElement label = new DivElement()
    ..classes.addAll([LGrid.C_GRID, LText.C_TYPE_FOCUS, LGrid.C_NO_SPACE]);

  /// label
  HeadingElement _h1 = new HeadingElement.h1()
    ..classes.addAll([LText.C_TEXT_HEADING__MEDIUM, LText.C_TRUNCATE]);
  /// Drop down Button
  LButton _button = new LButton(new ButtonElement(), "more", null,
    icon: new LIconUtility(LIconUtility.DOWN),
    buttonClasses: [LButton.C_BUTTON__ICON_BARE, LGrid.C_SHRINK_NONE, LGrid.C_ALIGN_MIDDLE, LMargin.C_LEFT__X_SMALL],
    assistiveText:lObjectHomeLookupMore());

  DivElement _dropdown = new DivElement()
    ..classes.addAll([LDropdown.C_DROPDOWN, LDropdown.C_DROPDOWN__LEFT, LDropdown.C_DROPDOWN__SMALL, LDropdown.C_DROPDOWN__MENU]);
  DivElement _dropdownHeader = new DivElement()
    ..classes.add(LDropdown.C_DROPDOWN__HEADER);
  DivElement _dropdownHeaderFind = new DivElement()
    ..classes.addAll([LForm.C_INPUT_HAS_ICON, LForm.C_INPUT_HAS_ICON__LEFT, LMargin.C_BOTTOM__X_SMALL]);
  InputElement _dropdownHeaderFindInput = new InputElement(type: "text")
    ..classes.add(LForm.C_INPUT)
    ..placeholder = lObjectHomeLookupFindInList();
  SpanElement _dropdownHeaderLabel = new SpanElement()
    ..classes.add(LText.C_TEXT_HEADING__LABEL)
    ..text = lObjectHomeLookupList();

  LDropdownElement _dropdownElement;

  /**
   * Lookup
   */
  LObjectHomeFilterLookup() {
    element.append(label);
    label.append(_h1);
    label.append(_button.element);

    element.append(_dropdown);
    _dropdown.append(_dropdownHeader);
    _dropdownHeader.append(_dropdownHeaderFind);
    _dropdownHeaderFind.append(new LIconUtility(LIconUtility.SEARCH, className: LForm.C_INPUT__ICON).element);
    _dropdownHeaderFindInput.onKeyUp.listen(onSearchKeyUp);
    _dropdownHeaderFind.append(_dropdownHeaderFindInput);
    _dropdownHeader.append(_dropdownHeaderLabel);
    _dropdownElement = new LDropdownElement(_dropdown, name: "filter"); // adds List
    _dropdownElement.selectMode = true;
    _dropdownElement.editorChange = onEditorChange;
  } // LObjectHomeLookup


  String get value => _dropdownElement.value;
  void set value (String newValue) {
    _dropdownElement.value = newValue;
  }

  /// Set Options
  void set options (List<DOption> options) {
    _dropdownElement.dOptions = options;
  } // setOptions



  void onSearchKeyUp(KeyboardEvent evt) {
    lookupUpdateList(false);
  }

  /// update lookup list and display
  void lookupUpdateList(bool showAll) {
    String restriction = _dropdownHeaderFindInput.value;
    RegExp exp = null;
    if (!showAll && restriction.isNotEmpty) {
      exp = LLookup._createRegExp(restriction);
    }
    int count = 0;
    for (LDropdownItem item in _dropdownElement._items) {
      if (exp == null) {
        item.show = true;
        item.labelHighlightClear();
        //item.exampleUpdate();
        count++;
      }
      else if (item.labelHighlight(exp) || item.descriptionHighlight(exp)) {
        item.show = true;
        //item.exampleUpdate();
        count++;
      }
      else { // no match
        item.show = false;
      }
    }
    if (count == 0 && _dropdownElement._items.isNotEmpty) {
    //  input.setCustomValidity("No matching options"); // TODO Trl
      _dropdownHeaderFind.classes.add(LForm.C_HAS_ERROR);
    } else {
    //  input.setCustomValidity("");
      _dropdownHeaderFind.classes.remove(LForm.C_HAS_ERROR);
    }
    //doValidate();
    _log.fine("lookupUpdateList '${restriction}' ${count} of ${_dropdownElement._items.length}");
  } // lookupUpdateList


  /**
   * Dropdown Selected
   */
  void onEditorChange(String name, String newValue, DEntry entry, var details) {
    if (details is ListItem) {
      ListItem value = (details as ListItem);
      _h1.text = value.label;
      if (editorChange != null)
        editorChange("", newValue, null, null); // callback
    }
  }

  // Trl
  static String lObjectHomeLookupMore() => Intl.message("More", name: "lObjectHomeLookupMore");
  static String lObjectHomeLookupFindInList() => Intl.message("Find in Filter List", name: "lObjectHomeLookupFindInList");
  static String lObjectHomeLookupList() => Intl.message("List", name: "lObjectHomeLookupList");

} // LObjectHomeLookup
