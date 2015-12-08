/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Date Picker
 */
class LDatepicker
    extends LInputDate {

  /// slds-datepicker - Initializes datepicker | Required
  static const String C_DATEPICKER = "slds-datepicker";
  /// slds-datepicker__filter - Aligns filter items horizontally | Required
  static const String C_DATEPICKER__FILTER = "slds-datepicker__filter";
  /// slds-datepicker__filter--month - Spaces out month filter | Required
  static const String C_DATEPICKER__FILTER__MONTH = "slds-datepicker__filter--month";
  /// slds-day - Style for calendar days | Required
  static const String C_DAY = "slds-day";
  /// slds-is-today - Indicates today
  static const String C_IS_TODAY = "slds-is-today";
  /// slds-is-selected - Indicates selected days
  static const String C_IS_SELECTED = "slds-is-selected";
  /// slds-is-selected-multi - Indicates if selected days are apart of a date range
  static const String C_IS_SELECTED_MULTI = "slds-is-selected-multi";
  /// slds-has-multi-row-selection - Helper class that styles date range appropriately
  static const String C_HAS_MULTI_ROW_SELECTION = "slds-has-multi-row-selection";
  /// slds-disabled-text - Indicates days that are in previous/next months
  static const String C_DISABLED_TEXT = "slds-disabled-text";


  /// Table marker
  static const String C_DATEPICKER__MONTH = "datepicker__month";
  /// Attribute
  static const String DATA_SELECTION = "data-selection";
  /// Attribute value
  static const String DATA_SELECTION_SINGLE = "single";
  static const String DATA_SELECTION_MULTI = "multi";
  static const String DATA_SELECTION_TIME = "time";

  // Select Mode - Single (default)
  static const String MODE_SINGLE = "s";
  // Select Mode - Week - first day
  static const String MODE_WEEK_FIRST = "w";
  // Select Mode - Week - last day
  static const String MODE_WEEK_LAST = "W";
  // Select Range - NIY
  static const String MODE_RANGE = "r";

  static final Logger _log = new Logger("LDatepicker");

  /// Dropdown
  LDatePickerDropdown _dropdown;

  /**
   * Date Input
   */
  LDatepicker(String name, {String idPrefix, bool inGrid:false})
    : super(name, type:EditorI.TYPE_TEXT, idPrefix:idPrefix, inGrid:inGrid);

  LDatepicker.from(DataColumn dataColumn, String type, {String idPrefix, bool inGrid:false})
    : super.from(dataColumn, type, idPrefix:idPrefix, inGrid:inGrid);

  @override
  void _initEditor(String type) {
    html5 = false;
    element.onClick.listen(onInputClick); // w/o wrapper
    //
    _firstDayOfWeek = _formatter.dateSymbols.FIRSTDAYOFWEEK + 1; // zero based
    super._initEditor(type);
  } // initEditor

  @override
  String get type => EditorI.TYPE_DATE;

  /// ignore html5 setting
  void set html5 (bool ignored) {
    super.html5 = false;
  }

  /// Select Mode
  String get mode => mode;
  /// Select Mode
  void set mode (String newValue) {
    _mode = newValue;
    if (_dropdown != null) {
      _dropdown.mode = _mode;
    }
  }
  String _mode = LDatepicker.MODE_SINGLE;

  /// First Day 1=Mo .. 7=Su
  int get firstDayOfWeek => _firstDayOfWeek;
  /// First Dat 1=Mo .. 7=Su
  void set firstDayOfWeek (int first) {
    if (first >= DateTime.MONDAY && first <= DateTime.SUNDAY)
      _firstDayOfWeek = first;
  }
  int _firstDayOfWeek = DateTime.SUNDAY;

  /// Field Clicked - show dropdown
  void onInputClick(MouseEvent evt) {
    if (_dropdown == null) {
      _dropdown = new LDatePickerDropdown(id, _formatter, _firstDayOfWeek);
      _dropdown.editorChange = onDropdownChange;
      _dropdown.show = false;
    }
    _dropdown.mode = _mode;
    // attach
    if (!_dropdown.show) { // not showing yet
      Element next = element.nextElementSibling;
      if (next != null)
        element.parent.insertBefore(_dropdown.element, next);
      else
        element.parent.append(_dropdown.element);
    }
    // toggle
    _dropdown.show = !_dropdown.show;
    // value
    _dropdown.value = value;
    // detach
    if (!_dropdown.show) { // not showing anymore
      _dropdown.element.remove();
    }
  } // onInputClicked

  /// Dropdown Changed
  void onDropdownChange(String name, String newValue, DEntry entry, var details) {
    _dropdown.show = false;
    _dropdown.element.remove();
    if (readOnly) {
      return;
    }
    value = newValue;
    String theValue = value;
    _log.config("onInputChange ${name}=${theValue}");
    if (data != null && entry != null) {
      data.updateEntry(entry, theValue);
    }
    if (editorChange != null) {
      editorChange(name, theValue, entry, null);
    }
  } // onDropdownChange

  /// Show/Hide Popup
  void set showDropdown (bool newValue) {
    if (_dropdown != null)
      _dropdown.show = newValue;
  }

} // LDatePicker
