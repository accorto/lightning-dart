/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_graph;

/**
 * Graph Match Criteria
 */
class GraphMatch {

  static final Logger _log = new Logger("GraphMatch");

  /// column name
  final String columnName;
  /// match type
  final MatchType type;

  /// match regex
  RegExp regex;
  /// match num op
  MatchOpNum numOp;
  /// match num value
  num numValue;
  /// match date
  MatchOpDate dateOp;

  /**
   * Record Match
   */
  GraphMatch(String this.columnName, MatchType this.type) {
  }


  /**
   * Match Record
   */
  bool recordMatch(DRecord record) {
    for (DEntry entry in record.entryList) {
      if (columnName == entry.columnName) {
        String value = DataRecord.getEntryValue(entry);
        // looking for null
        if (type == MatchType.Null)
          return value == null || value.isEmpty;
        // looking for not null
        if (type == MatchType.NotNull)
          return value != null && value.isNotEmpty;
        // value null/empty
        if (value == null || value.isEmpty)
          return false;

        if (type == MatchType.Regex) {
          return recordValueRegex(value);
        }
        if (type == MatchType.Num) {
          return recordValueNum(value);
        }
        if (type == MatchType.Date) {
          return recordValueDate(value);
        }
        _log.warning("recordMatch ${columnName} not found type=${type}");
        return false;
      }
    }
    // column not found
    if (type == MatchType.Null)
      return true;
    return false;
  } // recordMatch

  /// match value
  bool valueMatch(num value, String stringValue) {
    // looking for null
    if (type == MatchType.Null)
      return value == null;
    // looking for not null
    if (type == MatchType.NotNull)
      return value != null;
    // value null/empty
    if (value == null)
      return false;

    if (type == MatchType.Regex) {
      return recordValueRegex(stringValue);
    }
    if (type == MatchType.Num) {
      // see recordValueNum
      if (numOp == MatchOpNum.EQ)
        return value == numValue;
      if (numOp == MatchOpNum.GE)
        return value >= numValue;
      if (numOp == MatchOpNum.GT)
        return value > numValue;
      if (numOp == MatchOpNum.LE)
        return value <= numValue;
      if (numOp == MatchOpNum.LT)
        return value < numValue;
      _log.warning("valueMatch ${columnName} not found op=${numOp}");
    }
    if (type == MatchType.Date) {
      return recordValueDate(stringValue);
    }
    _log.warning("valueMatch ${columnName} not found type=${type}");
    return false;
  } // valueMatch

  /// match date
  bool dateMatch(DateTime date, String stringDate) {
    // looking for null
    if (type == MatchType.Null)
      return date == null;
    // looking for not null
    if (type == MatchType.NotNull)
      return date != null;
    // value null/empty
    if (date == null)
      return false;

    if (type == MatchType.Regex) {
      return recordValueRegex(stringDate);
    }
    if (type == MatchType.Num) {
      return recordValueNum(stringDate);
    }
    if (type == MatchType.Date) {
      // see recordValueDate
      if (dateOp == MatchOpDate.Today) {
        return recordValueDateToday(date);
      }
      if (dateOp == MatchOpDate.ThisWeek) {
        return recordValueDateThisWeek(date);
      }
      if (dateOp == MatchOpDate.LastWeek) {
        return recordValueDateLastWeek(date);
      }
      if (dateOp == MatchOpDate.Last4Weeks) {
        return recordValueDateLast4Weeks(date);
      }
      _log.warning("dateMatch ${columnName} not found op=${dateOp}");
    }
    _log.warning("dateMatch ${columnName} not found type=${type}");
    return false;
  } // dateMatch


  /// match number
  bool recordValueNum(String value) {
    if (numOp == null || numValue == null) {
      _log.warning("recordValueNum ${columnName} no num ${numOp} ${numValue}");
      return false;
    }
    try {
      double dd = double.parse(value);
      // see valueMatch
      if (numOp == MatchOpNum.EQ)
        return dd == numValue;
      if (numOp == MatchOpNum.GE)
        return dd >= numValue;
      if (numOp == MatchOpNum.GT)
        return dd > numValue;
      if (numOp == MatchOpNum.LE)
        return dd <= numValue;
      if (numOp == MatchOpNum.LT)
        return dd < numValue;
      _log.warning("recordValueNum ${columnName} not found op=${numOp}");
    } catch (error) {
      _log.warning("recordValueNum ${columnName} invalid value=${value}");
    }
    return false;
  } // recordValueNum


  /// match date
  bool recordValueDate(String value) {
    if (dateOp == null) {
      _log.warning("recordValueDate ${columnName} no op");
      return false;
    }
    try {
      int time = int.parse(value);
      DateTime dt = new DateTime.fromMillisecondsSinceEpoch(time, isUtc: true);
      // see dateMatch
      if (dateOp == MatchOpDate.Today) {
        return recordValueDateToday(dt);
      }
      if (dateOp == MatchOpDate.ThisWeek) {
        return recordValueDateThisWeek(dt);
      }
      if (dateOp == MatchOpDate.LastWeek) {
        return recordValueDateLastWeek(dt);
      }
      if (dateOp == MatchOpDate.Last4Weeks) {
        return recordValueDateLast4Weeks(dt);
      }
      _log.warning("recordValueDate ${columnName} not found op=${dateOp}");
    } catch (error) {
      _log.warning("recordValueDate ${columnName} invalid value=${value}");
    }
    return false;
  } // recordValueDate


  /// regex match
  bool recordValueRegex(String value) {
    if (regex == null) {
      _log.warning("recordValueRegex ${columnName} no regex");
      return false;
    }
    return regex.hasMatch(value);
  }

  /// match date today
  bool recordValueDateToday(DateTime dt) {
    if (_today == null) {
      _today = new DateTime.now();
      _today = new DateTime.utc(_today.year, _today.month, _today.day);
    }
    Duration diff = dt.difference(_today);
    if (diff.inDays == 0) {
      //  _log.finer("recordValueDateToday ${columnName} true ${dt} today=${_today} diff=${diff}");
      return true;
    }
    // _log.finer("recordValueDateToday ${columnName} FALSE ${dt} today=${_today} diff=${diff}");
    return false;
  } // recordValueDateToday
  DateTime _today;

  /// match date this week
  bool recordValueDateThisWeek(DateTime dt) {
    if (_thisWeekStart == null) {
      _today = new DateTime.now();
      _today = new DateTime.utc(_today.year, _today.month, _today.day);
      int weekDay = _today.weekday; // monday == 1
      if (weekDay == DateTime.SUNDAY) // == 7
        _thisWeekStart = _today;
      else
        _thisWeekStart = _today.subtract(new Duration(days: weekDay));
      _thisWeekEnd = _thisWeekStart.add(new Duration(days: 6, hours: 23, minutes: 59));
    }
    if (!dt.isBefore(_thisWeekStart) && !dt.isAfter(_thisWeekEnd)) {
      //  _log.finer("recordValueDateThisWeek ${columnName} true ${dt} start=${_thisWeekStart} end=${_thisWeekEnd}");
      return true;
    }
    // _log.finer("recordValueDateThisWeek ${columnName} FALSE ${dt} start=${_thisWeekStart} end=${_thisWeekEnd}");
    return false;
  }
  DateTime _thisWeekStart;
  DateTime _thisWeekEnd;

  /// match date last week
  bool recordValueDateLastWeek(DateTime dt) {
    if (_lastWeekStart == null) {
      _today = new DateTime.now().toUtc();
      _today = new DateTime.utc(_today.year, _today.month, _today.day);
      int weekDay = _today.weekday; // monday == 1
      if (weekDay == DateTime.SUNDAY) // == 7
        _lastWeekStart = _today.subtract(new Duration(days: 7));
      else
        _lastWeekStart = _today.subtract(new Duration(days: weekDay+7));
      _lastWeekEnd = _lastWeekStart.add(new Duration(days: 6, hours: 23, minutes: 59));
    }
    if (!dt.isBefore(_lastWeekStart) && !dt.isAfter(_lastWeekEnd)) {
      //  _log.finer("recordValueDateLastWeek ${columnName} true ${dt} start=${_lastWeekStart} end=${_lastWeekEnd}");
      return true;
    }
    // _log.finer("recordValueDateLastWeek ${columnName} FALSE ${dt} start=${_lastWeekStart} end=${_lastWeekEnd}");
    return false;

  }
  DateTime _lastWeekStart;
  DateTime _lastWeekEnd;

  /// match date last 4 weeks
  bool recordValueDateLast4Weeks(DateTime dt) {
    if (_lastWeekStart == null) {
      _today = new DateTime.now().toUtc();
      _today = new DateTime.utc(_today.year, _today.month, _today.day);
      int weekDay = _today.weekday; // monday == 1
      if (weekDay == DateTime.SUNDAY) // == 7
        _last4WeekStart = _today.subtract(new Duration(days: 7*5));
      else
        _last4WeekStart = _today.subtract(new Duration(days: weekDay+(7*5)));
    }
    if (!dt.isBefore(_last4WeekStart)) {
      //  _log.finer("recordValueDateLas4tWeeks ${columnName} true ${dt} start=${_lastWeekStart} end=${_lastWeekEnd}");
      return true;
    }
    // _log.finer("recordValueDateLast4Weeks ${columnName} FALSE ${dt} start=${_lastWeekStart} end=${_lastWeekEnd}");
    return false;

  }
  DateTime _last4WeekStart;

} // GraphMatch
