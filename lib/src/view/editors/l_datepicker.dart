/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

class LDatepicker extends LInput {

  /// slds-datepicker - Initializes datepicker | Required
  static const String C_DATEPICKER = "slds-datepicker";
  /// slds-datepicker__filter - Aligns filter items horizontally | Required
  static const String C_DATEPICKER__FILTER = "slds-datepicker__filter";
  /// slds-datepicker__filter--month - Spaces out month filter | Required
  static const String C_DATEPICKER__FILTER__MONTH = "slds-datepicker__filter--month";
  static const String C_DATEPICKER__FILTER__YEAR = "slds-datepicker__filter--year";

  /// Table
  static const String C_DATEPICKER__MONTH = "slds-datepicker__month";

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

  static const String DATA_SELECTION = "data-selection";
  static const String DATA_SELECTION_SINGLE = "single";


  static int get firstDayInWeek {
    return DateTime.SUNDAY;
  }

  /// The Icon
  final LIcon _iconRight = new LIconUtility(LIconUtility.EVENT);

  LDatePickerDropdown _dropdown;

  /**
   * Date Input
   */
  LDatepicker(String name, String type, {String idPrefix})
    : super(name, type, idPrefix:idPrefix);

  @override
  void _initEditor() {

    input.onChange.listen(onInputChange);
    input.onKeyUp.listen(onInputKeyUp);
    input.onClick.listen(onInputClick);
  }

  @override
  LIcon getIconRight() => _iconRight;

  /// Field Clicked
  void onInputClick(MouseEvent evt) {
    if (_dropdown == null) {
      _dropdown = new LDatePickerDropdown();
      element.parent.insertBefore(_dropdown.element, element); // should be after
    }
    _dropdown.show = !_dropdown.show; // toggle
    _dropdown.value = value;
  } // onInputClicked


} // LDatePicker

/**
 * Date Picker Dropdown
 */
class LDatePickerDropdown {

  static final Logger _log = new Logger("LDatePickerDropdown");


  /// Dropdown Date Picker
  final DivElement element = new DivElement()
    ..classes.addAll([LDropdown.C_DROPDOWN, LDropdown.C_DROPDOWN__LEFT, LDatepicker.C_DATEPICKER])
    ..attributes[Html0.ARIA_HIDDEN] = "true"
    ..attributes[LDatepicker.DATA_SELECTION] = LDatepicker.DATA_SELECTION_SINGLE;

  final DivElement _grid = new DivElement()
    ..classes.addAll([LDatepicker.C_DATEPICKER__FILTER, LGrid.C_GRID]);

  final DivElement _month = new DivElement()
    ..classes.addAll([LDatepicker.C_DATEPICKER__FILTER__MONTH, LGrid.C_GRID, LGrid.C_GRID__ALIGN_SPREAD, LSizing.C_SIZE__3_OF_4]);
  final DivElement _monthPrev = new DivElement()
    ..classes.add(LGrid.C_ALIGN_MIDDLE)
    ..attributes[Html0.ROLE] = Html0.ROLE_BUTTON
    ..tabIndex = 0;
  final LButton _monthPrevButton = new LButton(new ButtonElement(), "prev", null,
    buttonClasses: [LButton.C_BUTTON__ICON_CONTAINER],
    icon: new LIconUtility(LIconUtility.LEFT, className: LButton.C_BUTTON__ICON, size: LButton.C_BUTTON__ICON__SMALL),
    assistiveText: LDatePickerDropdownPrev());
  final DivElement _monthLabel = new DivElement()
    ..classes.add(LGrid.C_ALIGN_MIDDLE)
    ..attributes[Html0.ROLE] = Html0.ROLE_HEADING
    ..attributes[Html0.ARIA_LIVE] = Html0.ARIA_LIVE_ASSERTIVE
    ..attributes[Html0.ARIA_ATOMIC] = "true"
    ..text = "...";
  final DivElement _monthNext = new DivElement()
    ..classes.add(LGrid.C_ALIGN_MIDDLE)
    ..attributes[Html0.ROLE] = Html0.ROLE_BUTTON
    ..tabIndex = 0;
  final LButton _monthNextButton = new LButton(new ButtonElement(), "next", null,
    buttonClasses: [LButton.C_BUTTON__ICON_CONTAINER],
    icon: new LIconUtility(LIconUtility.RIGHT, className: LButton.C_BUTTON__ICON, size: LButton.C_BUTTON__ICON__SMALL),
    assistiveText: LDatePickerDropdownNext());
  final DivElement _year = new DivElement()
    ..classes.addAll([LPicklist.C_PICKLIST, LDatepicker.C_DATEPICKER__FILTER__YEAR, LGrid.C_SHRINK_NONE]);
  final LButton _yearButton = new LButton(new ButtonElement(), "year", "...",
    buttonClasses: [LButton.C_BUTTON__NEUTRAL, LPicklist.C_PICKLIST__LABEL]);
  final LIcon _yearButtonIcon = new LIconUtility(LIconUtility.DOWN, size: LIcon.C_ICON__SMALL);

  final TableElement _cal = new TableElement()
    ..classes.add(LDatepicker.C_DATEPICKER__MONTH)
    ..attributes[Html0.ROLE] = Html0.ROLE_GRID
    ..tabIndex = 0;

  final SpanElement _prev_label = new SpanElement()
    ..classes.add(LText.C_ASSISTIVE_TEXT)
    ..text = LDatePickerDropdownPrev();
  final SpanElement _next_label = new SpanElement()
    ..classes.add(LText.C_ASSISTIVE_TEXT)
    ..text = LDatePickerDropdownNext();


  /**
   * Date Picker Dropdown
   */
  LDatePickerDropdown() {
    element.append(_grid);
    _grid.append(_month);
    _month.append(_monthPrev);
    _monthPrev.append(_monthPrevButton.element);
    _monthLabel.id = "month"; // TODO
    _month.append(_monthLabel);
    _month.append(_monthNext);
    _monthNext.append(_monthNextButton.element);
    _grid.append(_year);
    _yearButton.element
      ..attributes[Html0.ARIA_HASPOPUP] = "true"
      ..attributes[Html0.ARIA_DISABLED] = "false";
    _year.append(_yearButton.element);
    _cal.attributes[Html0.ARIA_LABELLEDBY] = _monthLabel.id;

    element.append(_cal);
    //
    _prev_label.id = "prev"; // TODO
    _monthPrev.attributes[Html0.ARIA_LABELLEDBY] = _prev_label.id;
    element.append(_prev_label);
    _next_label.id = "next"; // TODO
    _monthNext.attributes[Html0.ARIA_LABELLEDBY] = _next_label.id;
    element.append(_next_label);

    // Events
    _monthPrevButton.onClick.listen((MouseEvent evt) {
      _monthDelta(-1);
    });
    _monthNextButton.onClick.listen((MouseEvent evt) {
      _monthDelta(1);
    });
    _yearButton.onClick.listen(onYearButtonClick); // select might be a better option as potentially a long list
  } // LDatePickerDropdown


  /// Set Date in ms
  void set value (String newValue) {
    DateTime dt = null;
    date = dt;
  }
  /// Get Date as ms
  String get value {
    DateTime dt = date;
    if (dt != null) {
      return dt.millisecondsSinceEpoch.toString();
    }
    return null;
  }

  /// Set Date
  void set date (DateTime newValue) {
    DateTime dt = newValue;
    if (dt == null)
      dt = new DateTime.now();
    _buildCalendar(dt);
  }
  /// Get Date
  DateTime get date {
    return null;
  }

  /// Move -1/+1 months
  void _monthDelta(int delta) {
    _log.fine("monthDelta ${delta}");
    // TODO
  }


  void onYearButtonClick(MouseEvent evt) {

  }


  /// Build Calendar
  void _buildCalendar(DateTime dt) {
    int year = dt.year;
    int month = dt.month;
    if (year != _yearNo || month != _monthNo) {
      _cal.children.clear();
      TableSectionElement thead = _cal.createTHead();
      TableRowElement headRow = thead.addRow()
        ..classes.add("weekdays");
      _buildCalendarWeekdays(headRow);
      _buildCalendarDays(dt);
    }
    _yearNo = year;
    _monthNo = month;

    _monthLabel.text = "???";
    _setYear(year);

  } // buildCalendar
  int _yearNo = -1;
  int _monthNo = -1;

  /// Set Year in Button
  void _setYear(int year) {
    _yearButton.element.children.clear();
    _yearButton.element.appendText(year.toString());
    _yearButton.element.append(_yearButtonIcon.element);
  }

  void _buildCalendarWeekdays(TableRowElement headRow) {
    for (int i = 0; i < 7; i++) {
      int day = LDatepicker.firstDayInWeek + i;
      if (day > DateTime.SUNDAY)
        day -= 7;

      Element abbr = new Element.tag("abbr")
        ..title = "Sunday"
        ..text = "S";
      TableCellElement th = new Element.th()
        ..append(abbr);
      headRow.append(th);
    }
  } // _buildCalendarWeekdays

  void _buildCalendarDays(DateTime dt) {
    TableSectionElement tbody = _cal.createTBody();

    TableRowElement row = tbody.addRow();

    SpanElement span = new SpanElement()
      ..classes.add(LDatepicker.C_DAY)
      ..text = "11";
    TableCellElement day = row.addCell()
      ..attributes["headers"] = "Sunday"
      ..attributes[Html0.ROLE] = Html0.ROLE_GRIDCELL
      ..attributes[Html0.ARIA_SELECTED] = "false"
      ..append(span);

    // day.classes.add(LDatepicker.C_DISABLED_TEXT);

    day.classes.add(LDatepicker.C_IS_TODAY);


    // day.classes.add(LDatepicker.C_IS_SELECTED);
    // day.attributes[Html0.ARIA_SELECTED] = "true";


  } // _buildCalendarDays


  /// Dropdown showing
  bool get show => element.attributes[Html0.ARIA_HIDDEN] == "false";
  /// Show Dropdown
  void set show (bool newValue) {
    if (newValue) {
      element.attributes[Html0.ARIA_HIDDEN] = "false";
    } else {
      element.attributes[Html0.ARIA_HIDDEN] = "true";
    }
  }


  void set showYear (bool newValue) {
    _yearButton.element.attributes[Html0.ARIA_EXPANED] = newValue.toString();
    if (newValue) {
    } else {
    }
  }




  static String LDatePickerDropdownPrev() => Intl.message("Go to previous month", name: "LDatePickerDropdownPrev");
  static String LDatePickerDropdownNext() => Intl.message("Go to next month", name: "LDatePickerDropdownNext");

} // LDatePickerDropdown
