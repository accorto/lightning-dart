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
  final List<SavedQuery> _savedQueryList = new List<SavedQuery>();
  /// current query
  SavedQuery _savedQuery;

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
    lookup.editorChange = onSavedQueryChange;
    filterPanel.editorChange = onSavedQueryChange;
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
    savedQueryList = ui.savedQueryList;
    for (SavedQuery sq in ui.savedQueryList) {
      if (sq.isDefault) {
        savedQuery = sq;
        return;
      }
    }
    // no default query
    savedQuery = null;
  }

  /// Filter Value/Name
  String get filterValue => lookup.value;
  /// Filter Value/Name
  void set filterValue (String newValue) {
    lookup.value = newValue;
  }
  /// Get selected saved query
  SavedQuery get savedQuery {
    if (_savedQuery != null) {
      return _savedQuery;
    }
    String value = filterValue;
    for (SavedQuery query in _savedQueryList) {
      if (query.savedQueryId == value) {
        return query;
      }
    }
    return null;
  } // getSavedQuery
  /// set saved query
  void set savedQuery (SavedQuery sq) {
    _savedQuery = sq;
    if (sq == null) {
      filterPanel.savedQuery = null;
      filterValue = ALL;
    } else {
      filterPanel.savedQuery = sq;
      filterValue = sq.name;
    }
  }


  /// Set Filter List
  void set savedQueryList(List<SavedQuery> savedQueryList) {
    _savedQueryList.clear();
    if (savedQueryList != null) {
      _savedQueryList.addAll(savedQueryList);
    }
    List<DOption> options = new List<DOption>();
    options.add(new DOption()
      ..value = ALL
      ..label = lObjectHomeFilterAll());
    options.add(new DOption()
      ..value = RECENT
      ..label = lObjectHomeFilterRecent());
    //
    for (SavedQuery query in _savedQueryList) {
      options.add(new DOption()
        ..value = query.savedQueryId
        ..label = query.name);
    }
    lookup.options = options;
    _savedQuery = null;
  }


  /// Saved Query Lookup selection changed
  /// - update panel
  /// - execute query  ObjectCtrl.onFilterSelectionChange
  void onSavedQueryChange(String name, String newValue, DEntry entry, var details) {
    _savedQuery = null;
    if (details is SavedQuery) {
      _savedQuery = details;
      filterPanel.savedQuery = details;
      filterValue = newValue;
      if (filterSelectionChange != null)
        filterSelectionChange(newValue, details);
      return;
    }

    if (newValue == ALL || newValue == RECENT) {
      filterPanel.savedQuery = null;
      filterValue = newValue;
      if (filterSelectionChange != null)
        filterSelectionChange(newValue, null);
    } else {
      for (SavedQuery query in _savedQueryList) {
        if (query.savedQueryId == newValue) {
          filterPanel.savedQuery = query;
          filterValue = newValue;
          if (filterSelectionChange != null)
            filterSelectionChange(newValue, query);
          return;
        }
      }
    }
    _log.info("onSavedQueryChange - not found ${newValue}");
  } // onSavedQueryChange


  static String lObjectHomeFilter() => Intl.message("Filter", name: "lObjectHomeFilter");
  static String lObjectHomeFilterRecent() => Intl.message("Recently viewed", name: "lObjectHomeFilterRecent");
  static String lObjectHomeFilterAll() => Intl.message("All records", name: "lObjectHomeFilterAll");

} // LObjectHomeFilter


