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
  //  return DateTime.MONDAY;
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

  /// One Day
  static final Duration DAY = new Duration(days: 1);
  /// One Week
  static final Duration WEEK = new Duration(days: 7);

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

  final SelectElement _yearSelect = new SelectElement()
    ..name = "year"
    ..classes.add(LForm.C_SELECT); // LPicklist.C_PICKLIST__LABEL

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

  // Date Format
  final DateFormat _dateFormat = new DateFormat.yMd();
  final DateTime _today = new DateTime.now();

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
    _year.append(_yearSelect);
    _cal.attributes[Html0.ARIA_LABELLEDBY] = _monthLabel.id;
    // Table
    element.append(_cal);
    //
    _prev_label.id = "prev"; // TODO
    _monthPrev.attributes[Html0.ARIA_LABELLEDBY] = _prev_label.id;
    element.append(_prev_label);
    _next_label.id = "next"; // TODO
    _monthNext.attributes[Html0.ARIA_LABELLEDBY] = _next_label.id;
    element.append(_next_label);

    _initYear();
    // Events
    _monthPrevButton.onClick.listen((MouseEvent evt) {
      _monthDelta(-1);
    });
    _monthNextButton.onClick.listen((MouseEvent evt) {
      _monthDelta(1);
    });
    _cal.onClick.listen(onCalClick);
  } // LDatePickerDropdown

  void _initYear() {
    for (int i = 1915; i < 2045; i++) {
      _yearSelect.append(new OptionElement(data:i.toString(), value:i.toString()));
    }
    _yearSelect.onChange.listen(onYearChange);
  }


  /// Set Date in ms
  void set value (String newValue) {
    DateTime dt = DataUtil.toDate(newValue, type: EditorI.TYPE_DATE);
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
    _date = newValue;
    if (_date == null)
      _date = _today;
    else if (!date.isUtc)
      _date = _date.toUtc();
    _buildCalendar();
  }
  /// Get Date (utc)
  DateTime get date => _date;
  DateTime _date;


  /// Move -1/+1 months
  void _monthDelta(int delta) {
    _log.fine("monthDelta ${delta}");
    _date = _date.add(new Duration(days: delta*28)); // 4 weeks
    _buildCalendar();
  }


  void onYearChange(Event evt) {
    String y = _yearSelect.value;
    if (y != null) {
      int yyyy = int.parse(y);
      _date = new DateTime(yyyy, _date.month, _date.day);
      _buildCalendar();
    }

  }

  void onCalClick(MouseEvent event) {
    Element target = event.target;
    String dateString = target.attributes[Html0.DATA_VALUE];
    if (dateString == null) {
      target = target.parent;
      dateString = target.attributes[Html0.DATA_VALUE];
    }
    if (dateString != null) {
      _log.config("onCalClick ${dateString}");
      // de-select
      for (TableSectionElement tbody in _cal.tBodies) {
        for (TableRowElement tr in tbody.rows) {
          for (TableCellElement td in tr.cells) {
            td.classes.remove(LDatepicker.C_IS_SELECTED);
            td.attributes[Html0.ARIA_SELECTED] = "false";
          }
        }
      }
      if (target is TableCellElement) {
        if (target.classes.contains(LDatepicker.C_DISABLED_TEXT)) {
          value = dateString;
        } else {
          target.classes.add(LDatepicker.C_IS_SELECTED);
          target.attributes[Html0.ARIA_SELECTED] = "true";
          _date = DataUtil.toDate(dateString, type: EditorI.TYPE_DATE);
        }
      }
    }
  } // onCalClick


  /// Build Calendar
  void _buildCalendar() {
    int year = _date.year;
    int month = _date.month;
    _cal.children.clear();
    TableSectionElement thead = _cal.createTHead();
    TableRowElement headRow = thead.addRow()
      ..classes.add("weekdays");
    _buildCalendarWeekdays(headRow);
    _buildCalendarDays();

    List<String> monthNames = _dateFormat.dateSymbols.MONTHS;
    _monthLabel.text = monthNames[month-1];
    _yearSelect.value = year.toString();

  } // buildCalendar

  /// build first row S..S
  void _buildCalendarWeekdays(TableRowElement headRow) {
    List<String> dayNames = _dateFormat.dateSymbols.WEEKDAYS;
    List<String> dayAbbr = _dateFormat.dateSymbols.NARROWWEEKDAYS;
    for (int i = 0; i < 7; i++) {
      int day = LDatepicker.firstDayInWeek + i;
      if (day >= DateTime.SUNDAY)
        day -= 7;
      Element abbr = new Element.tag("abbr")
        ..title = dayNames[day]
        ..text = dayAbbr[day];
      TableCellElement th = new Element.th()
        ..append(abbr);
      headRow.append(th);
    }
  } // _buildCalendarWeekdays

  /// build weeks
  void _buildCalendarDays() {
    TableSectionElement tbody = _cal.createTBody();
    List<String> dayNames = _dateFormat.dateSymbols.WEEKDAYS;

    DateTime weekStart = new DateTime.utc(_date.year, _date.month, 1);
    while (weekStart.weekday != LDatepicker.firstDayInWeek)
      weekStart = weekStart.subtract(DAY);

    DateTime theDay = weekStart;
    do {
      TableRowElement row = tbody.addRow();
      for (int i = 0; i < 7; i++) {
        int day = LDatepicker.firstDayInWeek + i;
        if (day >= DateTime.SUNDAY)
          day -= 7;
        SpanElement span = new SpanElement()
          ..classes.add(LDatepicker.C_DAY)
          ..text = theDay.day.toString();
        TableCellElement dayElement = row.addCell()
          ..attributes["headers"] = dayNames[day]
          ..attributes[Html0.ROLE] = Html0.ROLE_GRIDCELL
          ..attributes[Html0.ARIA_SELECTED] = "false"
          ..attributes[Html0.DATA_VALUE] = theDay.millisecondsSinceEpoch.toString()
          ..append(span);
        //
        if (theDay.month != _date.month) {
          dayElement.classes.add(LDatepicker.C_DISABLED_TEXT);
        }
        if (theDay.year == _today.year && theDay.month == _today.month && theDay.day == _today.day) {
          dayElement.classes.add(LDatepicker.C_IS_TODAY);
        }
        if (theDay.year == _date.year && theDay.month == _date.month && theDay.day == _date.day) {
          dayElement.classes.add(LDatepicker.C_IS_SELECTED);
          dayElement.attributes[Html0.ARIA_SELECTED] = "true";
        }
        //
        theDay = theDay.add(DAY);
      }
      weekStart = weekStart.add(WEEK);
    } while (weekStart.month == _date.month);
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


  static String LDatePickerDropdownPrev() => Intl.message("Go to previous month", name: "LDatePickerDropdownPrev");
  static String LDatePickerDropdownNext() => Intl.message("Go to next month", name: "LDatePickerDropdownNext");

} // LDatePickerDropdown
