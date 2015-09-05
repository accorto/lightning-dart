/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/// Execute Filter / Saved Query
typedef void FilterSelectionChange(String name, SavedQuery savedQuery);


/**
 * Maintains Dropdown, Selection and List Maintenance
 */
class LObjectHomeFilter {

  static final Logger _log = new Logger("LObjectHomeFilter");

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
      assistiveText: lObjectHomeFilter()),
    "filter-settings");


  /**
   * Filter Maintenance
   */
  LObjectHomeFilter() {
    lookup.editorChange = onEditorChange;
    addFilter(null); // init list
    filterValue = RECENT;

    /// Settings
    settings.classes.add(LMargin.C_LEFT__LARGE);
    settings.headingLabel = lObjectHomeFilter();
    settings.dropdown.nubbinTop = true; // see ObjectCtr.onFilterChange
    settings.dropdown.addItem(LDropdownItem.create(label: AppsAction.appsActionEdit(), value: AppsAction.EDIT));
    settings.dropdown.addItem(LDropdownItem.create(label: AppsAction.appsActionNew(), value: AppsAction.NEW));
    settings.dropdown.addItem(LDropdownItem.create(label: AppsAction.appsActionDelete(), value: AppsAction.DELETE));
  } // LObjectHomeFilter

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
      ..label = lObjectHomeFilterRecent());
    for (SavedQuery query in _savedQueries) {
      options.add(new DOption()
        ..value = query.savedQueryId
        ..label = query.name);
    }
    options.add(new DOption()
      ..value = ALL
      ..label = lObjectHomeFilterAll());
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


  static String lObjectHomeFilter() => Intl.message("Filter", name: "lObjectHomeFilter");
  static String lObjectHomeFilterRecent() => Intl.message("Recently viewed", name: "lObjectHomeFilterRecent");
  static String lObjectHomeFilterAll() => Intl.message("All records", name: "lObjectHomeFilterAll");

} // LObjectHomeFilter


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
  static String lObjectHomeLookupList() => Intl.message("Filter List", name: "lObjectHomeLookupList");

} // LObjectHomeLookup
