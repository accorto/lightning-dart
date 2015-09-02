/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Date Picker
 */
class LDatepicker extends LInputDate {

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

  // Select Mode - Single (default)
  static const String MODE_SINGLE = "s";
  // Select Mode - Week - first day
  static const String MODE_WEEK_FIRST = "w";
  // Select Mode - Week - last day
  static const String MODE_WEEK_LAST = "W";
  // Select Range - NIY
  static const String MODE_RANGE = "r";


  static int get firstDayInWeek {
    return DateTime.SUNDAY;
  //  return DateTime.MONDAY;
  }

  /// Dropdown
  LDatePickerDropdown _dropdown;

  /**
   * Date Input
   */
  LDatepicker(String name, {String idPrefix})
    : super(name, EditorI.TYPE_TEXT, idPrefix:idPrefix);

  @override
  void _initEditor() {
    _html5 = false;
    element.onClick.listen(onInputClick); // w/o wrapper
    wrapper = new DivElement();
    //  ..classes.add(LDropdown.C_DROPDOWN_TRIGGER);
    _dropdown = new LDatePickerDropdown(id);
    _dropdown.mode = _mode;
    _dropdown.editorChange = onDropdownChange;
    _dropdown.show = false;
    wrapper.append(_dropdown.element);
    //
    super._initEditor();
  } // initEditor

  @override
  String get type => EditorI.TYPE_DATE;


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


  /// Field Clicked
  void onInputClick(MouseEvent evt) {
    _dropdown.show = !_dropdown.show; // toggle
    _dropdown.value = value;
  } // onInputClicked

  /// Dropdown Changed
  void onDropdownChange(String name, String newValue, DEntry entry, var details) {
    value = newValue;
    _dropdown.show = false;
  }

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

  /// Callback
  EditorChange editorChange;

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
    assistiveText: lDatePickerDropdownPrev());
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
    assistiveText: lDatePickerDropdownNext());
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
    ..text = lDatePickerDropdownPrev();
  final SpanElement _next_label = new SpanElement()
    ..classes.add(LText.C_ASSISTIVE_TEXT)
    ..text = lDatePickerDropdownNext();

  // Date Format
  final DateFormat _dateFormat = new DateFormat.yMd();
  final DateTime _today = new DateTime.now();
  int _yearFirst = 1915;
  int _yearLast = 2045;

  /**
   * Date Picker Dropdown
   */
  LDatePickerDropdown(String idPrefix) {
    element.append(_grid);
    _grid.append(_month);
    _month.append(_monthPrev);
    _monthPrev.append(_monthPrevButton.element);
    _monthLabel.id = LComponent.createId(idPrefix, "month");
    _month.append(_monthLabel);
    _month.append(_monthNext);
    _monthNext.append(_monthNextButton.element);
    _grid.append(_year);
    _year.append(_yearSelect);
    _cal.attributes[Html0.ARIA_LABELLEDBY] = _monthLabel.id;
    // Table
    element.append(_cal);
    //
    _prev_label.id = LComponent.createId(idPrefix, "prev");
    _monthPrev.attributes[Html0.ARIA_LABELLEDBY] = _prev_label.id;
    element.append(_prev_label);
    _next_label.id = LComponent.createId(idPrefix, "next");
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

  /// initiate year options
  void _initYear() {
    for (int i = _yearFirst; i <= _yearLast; i++) {
      _yearSelect.append(new OptionElement(data:i.toString(), value:i.toString()));
    }
    _yearSelect.onChange.listen(onYearChange);
  }

  /// Select Mode
  String mode = LDatepicker.MODE_SINGLE;


  /// Set Date in ms
  void set value (String newValue) {
    date = DataUtil.toDate(newValue, type: EditorI.TYPE_DATE);
  }
  /// Get Date as ms
  String get value {
    if (_date != null) {
      return _date.millisecondsSinceEpoch.toString();
    }
    return null;
  }
  /// Set Date Ro in ms
  void set valueTo (String newValue) {
    dateTo = DataUtil.toDate(newValue, type: EditorI.TYPE_DATE);
  }
  /// Get Date To as ms
  String get valueTo {
    if (_dateTo != null) {
      return _dateTo.millisecondsSinceEpoch.toString();
    }
    return null;
  }

  /// Set Date
  void set date (DateTime newValue) {
    _date = newValue;
    if (_date == null)
      _date = _today;
    else if (!_date.isUtc)
      _date = _date.toUtc();
    _date = new DateTime.utc(_date.year, _date.month, _date.day); // normalize
    _buildCalendar();
  }
  /// Get Date (utc)
  DateTime get date => _date;
  DateTime _date;

  /// Set Date To
  void set dateTo (DateTime newValue) {
    _dateTo = newValue;
    if (_dateTo == null)
      _dateTo = _today;
    else if (!_dateTo.isUtc)
      _dateTo = _dateTo.toUtc();
    _dateTo = new DateTime.utc(_dateTo.year, _dateTo.month, _dateTo.day); // normalize
    _buildCalendar();
  }
  /// Get Date (utc)
  DateTime get dateTo => _dateTo;
  DateTime _dateTo;


  /// Move -1/+1 months
  void _monthDelta(int delta) {
    _log.fine("monthDelta ${delta}");
    _date = _date.add(new Duration(days: delta*28)); // 4 weeks
    _buildCalendar();
  }

  /// Year Change
  void onYearChange(Event evt) {
    String y = _yearSelect.value;
    if (y != null && y.isNotEmpty) {
      int yyyy = int.parse(y, onError: (String s){
        _log.warning("onYearChange ${y}");
        return _date.year;
      });
      _date = new DateTime(yyyy, _date.month, _date.day);
      _buildCalendar();
    }
  } // onYearChange

  /// Select/Click on Calendar
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
            td.classes.remove(LDatepicker.C_IS_SELECTED_MULTI);
            td.attributes[Html0.ARIA_SELECTED] = "false";
          }
        }
      }
      if (target is TableCellElement) {
        if (mode == LDatepicker.MODE_WEEK_FIRST || mode == LDatepicker.MODE_WEEK_LAST) {
          _date = DataUtil.toDate(dateString, type: EditorI.TYPE_DATE);
          while (_date.weekday != LDatepicker.firstDayInWeek)
            _date = _date.subtract(DAY);
          _dateTo = _date.add(new Duration(days:6));
          _buildCalendar();
          if (editorChange != null) {
            if (mode == LDatepicker.MODE_WEEK_FIRST) {
              editorChange("date", _date.millisecondsSinceEpoch.toString(), null, _date);
            } else {
              editorChange("date", _dateTo.millisecondsSinceEpoch.toString(), null, _dateTo);
            }
          }
        // } else if (mode == MODE_RANGE) {
        } else { // single
          if (target.classes.contains(LDatepicker.C_DISABLED_TEXT)) {
            value = dateString;
          } else {
            target.classes.add(LDatepicker.C_IS_SELECTED);
            target.attributes[Html0.ARIA_SELECTED] = "true";
            _date = DataUtil.toDate(dateString, type: EditorI.TYPE_DATE);
          }
          if (editorChange != null) {
            editorChange("date", dateString, null, _date);
          }
        } // single
      } // table cell
    }
  } // onCalClick


  /// Build+Display Calendar
  void _buildCalendar() {
    int year = _date.year;
    int month = _date.month; // 1..12
    _cal.children.clear();
    TableSectionElement thead = _cal.createTHead();
    TableRowElement headRow = thead.addRow()
      ..classes.add("weekdays");
    _buildCalendarWeekdays(headRow);
    _buildCalendarDays();
    // month
    List<String> monthNames = _dateFormat.dateSymbols.MONTHS;
    _monthLabel.text = monthNames[month-1];
    // Year
    const int buffer = 1; // additional years to add
    if (year < _yearFirst) {
      OptionElement firstYearElement = _yearSelect.options.first;
      for (int i = year-buffer; i <= _yearFirst-1; i++) {
        _yearSelect.insertBefore(new OptionElement(data:i.toString(), value:i.toString()), firstYearElement);
      }
      _yearFirst = year;
    } else if (year > _yearLast) {
      for (int i = _yearLast+1; i <= year+buffer; i++) {
        _yearSelect.append(new OptionElement(data:i.toString(), value:i.toString()));
      }
      _yearLast = year;
    }
    _yearSelect.value = year.toString();

  } // buildCalendar

  /// build first row S..S
  void _buildCalendarWeekdays(TableRowElement headRow) {
    List<String> dayNames = _dateFormat.dateSymbols.WEEKDAYS;
    List<String> dayAbbr = _dateFormat.dateSymbols.NARROWWEEKDAYS;
    for (int i = 0; i < 7; i++) {
      int day = LDatepicker.firstDayInWeek + i;
      if (day >= DateTime.SUNDAY) { // Mo=1 Su=7
        day -= 7;
      }
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
        // prev/next month
        if (theDay.month != _date.month) {
          dayElement.classes.add(LDatepicker.C_DISABLED_TEXT);
        }
        // Today
        if (theDay.year == _today.year && theDay.month == _today.month && theDay.day == _today.day) {
          dayElement.classes.add(LDatepicker.C_IS_TODAY);
        }
        // Select
        if (_dateTo != null && (mode == LDatepicker.MODE_WEEK_FIRST || mode == LDatepicker.MODE_WEEK_FIRST || mode == LDatepicker.MODE_RANGE)) {
          if (theDay.millisecondsSinceEpoch >= _date.millisecondsSinceEpoch
            && theDay.millisecondsSinceEpoch <= _dateTo.millisecondsSinceEpoch) {
            dayElement.classes.add(LDatepicker.C_IS_SELECTED);
            dayElement.classes.add(LDatepicker.C_IS_SELECTED_MULTI);
            dayElement.attributes[Html0.ARIA_SELECTED] = "true";
          }
        } else {
          if (theDay.millisecondsSinceEpoch == _date.millisecondsSinceEpoch) {
            dayElement.classes.add(LDatepicker.C_IS_SELECTED);
            dayElement.attributes[Html0.ARIA_SELECTED] = "true";
          }
        }
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
      element.classes.remove(LVisibility.C_HIDE);
      element.attributes[Html0.ARIA_HIDDEN] = "false";
    } else {
      element.classes.add(LVisibility.C_HIDE);
      element.attributes[Html0.ARIA_HIDDEN] = "true";
    }
  }


  static String lDatePickerDropdownPrev() => Intl.message("Go to previous month", name: "lDatePickerDropdownPrev");
  static String lDatePickerDropdownNext() => Intl.message("Go to next month", name: "lDatePickerDropdownNext");

} // LDatePickerDropdown
