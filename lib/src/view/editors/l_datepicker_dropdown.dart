/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

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
    ..classes.add(LGrid.C_ALIGN_MIDDLE);
  final LButton _monthPrevButton = new LButton(new ButtonElement(), "prev", null,
      buttonClasses: [LButton.C_BUTTON__ICON_CONTAINER],
      icon: new LIconUtility(LIconUtility.LEFT, className: LButton.C_BUTTON__ICON, size: LButton.C_BUTTON__ICON__SMALL),
      assistiveText: lDatePickerDropdownPrev());
  final HeadingElement _monthLabel = new HeadingElement.h2()
    ..classes.add(LGrid.C_ALIGN_MIDDLE)
    ..attributes[Html0.ARIA_LIVE] = Html0.ARIA_LIVE_ASSERTIVE
    ..attributes[Html0.ARIA_ATOMIC] = "true"
    ..text = "...";
  final DivElement _monthNext = new DivElement()
    ..classes.add(LGrid.C_ALIGN_MIDDLE);
  final LButton _monthNextButton = new LButton(new ButtonElement(), "next", null,
      buttonClasses: [LButton.C_BUTTON__ICON_CONTAINER],
      icon: new LIconUtility(LIconUtility.RIGHT, className: LButton.C_BUTTON__ICON, size: LButton.C_BUTTON__ICON__SMALL),
      assistiveText: lDatePickerDropdownNext());
  final DivElement _year = new DivElement()
    ..classes.addAll([LPicklist.C_PICKLIST, LPicklist.C_PICKLIST__FLUID, LGrid.C_SHRINK_NONE]);

  final SelectElement _yearSelect = new SelectElement()
    ..name = "year"
    ..classes.add(LForm.C_SELECT); // LPicklist.C_PICKLIST__LABEL

  final TableElement _cal = new TableElement()
    ..classes.add(LDatepicker.C_DATEPICKER__MONTH)
    ..attributes[Html0.ROLE] = Html0.ROLE_GRID;

  final SpanElement _prev_label = new SpanElement()
    ..classes.add(LText.C_ASSISTIVE_TEXT)
    ..text = lDatePickerDropdownPrev();
  final SpanElement _next_label = new SpanElement()
    ..classes.add(LText.C_ASSISTIVE_TEXT)
    ..text = lDatePickerDropdownNext();

  final DateTime _today = new DateTime.now();
  int _yearFirst = 1915;
  int _yearLast = 2045;

  final DateFormat dateFormat;
  final int firstDayOfWeek;

  /**
   * Date Picker Dropdown
   */
  LDatePickerDropdown(String idPrefix, DateFormat this.dateFormat, int this.firstDayOfWeek) {
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
    // _cal.attributes[Html0.ARIA_LABELLEDBY] = _monthLabel.id;
    // Table
    element.append(_cal);
    //
    _prev_label.id = LComponent.createId(idPrefix, "prev");
    // _monthPrev.attributes[Html0.ARIA_LABELLEDBY] = _prev_label.id;
    element.append(_prev_label);
    _next_label.id = LComponent.createId(idPrefix, "next");
    // _monthNext.attributes[Html0.ARIA_LABELLEDBY] = _next_label.id;
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
    if (mode == LDatepicker.MODE_WEEK_FIRST || mode == LDatepicker.MODE_WEEK_LAST) {
      while (_date.weekday != firstDayOfWeek)
        _date = _date.subtract(DAY);
      _dateTo = _date.add(new Duration(days:6));
    }
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
      DateTime clickDate = DataUtil.toDate(dateString, type: EditorI.TYPE_DATE);
      String info = "onCalClick ${dateString} ${clickDate.toString().substring(0,10)} ${mode}";

      if (target is TableCellElement) {
        if (mode == LDatepicker.MODE_WEEK_FIRST || mode == LDatepicker.MODE_WEEK_LAST) {
          _date = clickDate;
          while (_date.weekday != firstDayOfWeek) {
            _date = _date.subtract(DAY);
          }
          _dateTo = _date.add(new Duration(days: 6));
          _buildCalendar();
          info += " => ${_date.toString().substring(0,10)} - ${_dateTo.toString().substring(0,10)}";
          _log.config(info);
          if (editorChange != null) {
            if (mode == LDatepicker.MODE_WEEK_FIRST) {
              editorChange("date", _date.millisecondsSinceEpoch.toString(), null, _date);
            } else {
              editorChange("date", _dateTo.millisecondsSinceEpoch.toString(), null, _dateTo);
            }
          }
        } else if (mode == LDatepicker.MODE_RANGE) {
          _log.config(info);
        } else { // single
          if (target.classes.contains(LDatepicker.C_DISABLED_TEXT)) {
            value = dateString;
          } else {
            target.classes.add(LDatepicker.C_IS_SELECTED);
            target.attributes[Html0.ARIA_SELECTED] = "true";
            _date = clickDate;
          }
          _log.config(info);
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
    List<String> monthNames = dateFormat.dateSymbols.MONTHS;
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
    List<String> dayNames = dateFormat.dateSymbols.WEEKDAYS;
    List<String> dayAbbr = dateFormat.dateSymbols.NARROWWEEKDAYS;
    for (int i = 0; i < 7; i++) {
      int day = firstDayOfWeek + i;
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
    List<String> dayNames = dateFormat.dateSymbols.WEEKDAYS;
    // List<int> weekEndDays = dateFormat.dateSymbols.WEEKENDRANGE; // zero based

    DateTime weekStart = new DateTime.utc(_date.year, _date.month, 1);
    while (weekStart.weekday != firstDayOfWeek)
      weekStart = weekStart.subtract(DAY);

    DateTime theDay = weekStart;
    do {
      TableRowElement row = tbody.addRow();
      for (int i = 0; i < 7; i++) {
        int day = firstDayOfWeek + i;
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
