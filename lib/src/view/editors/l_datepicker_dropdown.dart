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

  final InputElement _yearInput = new InputElement(type: EditorI.TYPE_NUMBER)
    ..name = "year"
    ..classes.add(LForm.C_INPUT)
    ..style.border = "none"
    ..style.textAlign = "center"
    ..step = "1"
    ..min = "1900"
    ..max = "2050";

  final TableElement _cal = new TableElement()
    ..classes.add(LDatepicker.C_DATEPICKER__MONTH)
    ..attributes[Html0.ROLE] = Html0.ROLE_GRID;

  final AnchorElement _todayLink = new AnchorElement(href:"#")
    ..text = lDatePickerDropdownToday();

  final DateTime _today = new DateTime.now();

  final String name;
  final DateFormat dateFormat;
  final int firstDayOfWeek;

  /**
   * Date Picker Dropdown
   */
  LDatePickerDropdown(String this.name, String idPrefix, DateFormat this.dateFormat, int this.firstDayOfWeek) {
    // header
    final DivElement _grid = new DivElement()
      ..classes.addAll([LDatepicker.C_DATEPICKER__FILTER, LGrid.C_GRID]);
    element.append(_grid);
    // header parts
    final DivElement _month = new DivElement()
      ..classes.addAll([LDatepicker.C_DATEPICKER__FILTER__MONTH, LGrid.C_GRID, LGrid.C_GRID__ALIGN_SPREAD, LSizing.C_SIZE__3_OF_4]);
    _grid.append(_month);
    final DivElement _year = new DivElement()
      ..classes.addAll([LPicklist.C_PICKLIST, LPicklist.C_PICKLIST__FLUID, LGrid.C_SHRINK_NONE]);
    _grid.append(_year);

    // - month
    _month.append(_monthPrev);
    _monthPrev.append(_monthPrevButton.element);
    _monthLabel.id = LComponent.createId(idPrefix, "month");
    _month.append(_monthLabel);
    _month.append(_monthNext);
    _monthNext.append(_monthNextButton.element);
    // - year
    _year.append(_yearInput);
    // _cal.attributes[Html0.ARIA_LABELLEDBY] = _monthLabel.id;

    // Table
    element.append(_cal);
    // Events
    _monthPrevButton.onClick.listen((MouseEvent evt) {
      _monthDelta(-1);
    });
    _monthNextButton.onClick.listen((MouseEvent evt) {
      _monthDelta(1);
    });
    _year.onInput.listen(onYearInput);
    _cal.onClick.listen(onCalClick);
    _todayLink.onClick.listen(onTodayClick);
  } // LDatePickerDropdown


  /// Select Mode
  String mode = LDatepicker.MODE_SINGLE;
  /// Utc
  bool isUtc = true;

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
    _setDateTo();
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
    int yy = _date.year;
    int mm = _date.month + delta;
    int dd = _date.day;
    while (mm < DateTime.JANUARY) {
      mm += 12;
      yy--;
    }
    while (mm > DateTime.DECEMBER) {
      mm -= 12;
      yy++;
    }
    _date = new DateTime.utc(yy, mm, dd);
    _setDateTo();
    _log.fine("monthDelta ${delta} - ${_date} ${_dateTo}");
    _buildCalendar();
  }

  /// Year Change
  void onYearInput(Event evt) {
    String y = _yearInput.value;
    if (y != null && y.isNotEmpty) {
      int yyyy = int.parse(y, onError: (String s){
        _log.warning("onYearChange ${y}");
        return _date.year;
      });
      _date = new DateTime.utc(yyyy, _date.month, _date.day);
      _setDateTo();
      _log.fine("onYearInput ${y} - ${_date} ${dateTo}");
      _buildCalendar();
    }
  } // onYearChange

  /// Select/Click on Calendar
  void onCalClick(MouseEvent evt) {
    Element target = evt.target;
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
      DateTime clickDate = DataUtil.toDate(dateString, type: EditorI.TYPE_DATE, isUtc: isUtc);
      String info = "onCalClick ${dateString} ${clickDate} ${mode} utc=${isUtc}";

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
              editorChange(name, _date.millisecondsSinceEpoch.toString(), null, _date);
            } else {
              editorChange(name, _dateTo.millisecondsSinceEpoch.toString(), null, _dateTo);
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
            editorChange(name, dateString, null, _date);
          }
        } // single
      } // table cell
    }
  } // onCalClick

  /// today Clicked
  void onTodayClick(MouseEvent evt) {
    evt.preventDefault(); // link
    evt.stopPropagation();
    _date = new DateTime.utc(_today.year, _today.month, _today.day);
    _setDateTo();
    _log.fine("onClickToday - ${_date} ${_dateTo}");
    _buildCalendar();
  }

  /// adjust date set date to if first|last
  void _setDateTo() {
    if (mode == LDatepicker.MODE_WEEK_FIRST || mode == LDatepicker.MODE_WEEK_LAST) {
      while (_date.weekday != firstDayOfWeek)
        _date = _date.subtract(DAY);
      _dateTo = _date.add(new Duration(days:6));
    }
  }

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
    _yearInput.value = year.toString();
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
        ..classes.add("day") // margin overwritten if in table
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
    TableRowElement row;
    do {
      row = tbody.addRow();
      for (int i = 0; i < 7; i++) {
        int day = firstDayOfWeek + i;
        if (day >= DateTime.SUNDAY)
          day -= 7;
        SpanElement span = new SpanElement()
          ..classes.add(LDatepicker.C_DAY)
          ..text = theDay.day.toString();
        TableCellElement dayElement = row.addCell()
          ..classes.add("day") // margin overwritten if in table
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
    row = tbody.addRow();
    row.addCell()
      ..colSpan = 7
      ..append(_todayLink);
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

  static String lDatePickerDropdownToday() => Intl.message("today", name: "lDatePickerDropdownToday");

} // LDatePickerDropdown
