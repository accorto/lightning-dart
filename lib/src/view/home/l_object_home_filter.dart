/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/// Execute Filter / Saved Query
typedef void FilterSelectionChange(String name, SavedQuery savedQuery);


/**
 * Filter Controller
 *
 * Maintains [filterValue] and [savedQuery]
 * informs via [filterSelectionChange]
 *
 * [lookup] - Lookup/Dropdown of [SavedQuery] list
 *
 * [settings] - Dropdown to edit/new/delete
 *
 * [filterButton] - Toggle button to show/hide
 * [filterPanel] - Pop-In
 *
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
  final LDropdown settings = new LDropdown(
      new LButton(new ButtonElement(), "filterList", null,
        icon: new LIconUtility(LIconUtility.SETTINGS),
        buttonClasses: [LButton.C_BUTTON__ICON_CONTAINER],
        assistiveText: lObjectHomeFilter()),
      "filter-settings");

  // Filter Button
  final LButton filterButton = new LButton.iconContainer("filterButton",
      new LIconUtility(LIconUtility.FILTERLIST),
      "Edit Filter");

  // Filter Pop-In
  ObjectHomeFilterPanel filterPanel;


  /**
   * Filter Maintenance
   */
  LObjectHomeFilter(String idPrefix) {
    filterPanel = new ObjectHomeFilterPanel(idPrefix);
    filterButton.setIdPrefix(idPrefix);

    //
    lookup.editorChange = onEditorChange;
    addFilter(null); // init list
    filterValue = ALL;

    /// Settings
    settings.classes.add(LMargin.C_LEFT__LARGE);
    settings.headingLabel = lObjectHomeFilter();
    settings.dropdown.nubbinTop = true; // see ObjectCtr.onFilterChange
    settings.dropdown.addDropdownItem(LDropdownItem.create(label: AppsAction.appsActionEdit(), value: AppsAction.EDIT));
    settings.dropdown.addDropdownItem(LDropdownItem.create(label: AppsAction.appsActionNew(), value: AppsAction.NEW));
    settings.dropdown.addDropdownItem(LDropdownItem.create(label: AppsAction.appsActionDelete(), value: AppsAction.DELETE));
    // TODO Add Layout Action  - select fields to display
  } // LObjectHomeFilter

  /// Set UI
  void setUi(UI ui) {
    filterPanel.setUi(ui);
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


