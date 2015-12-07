/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_model;

/**
 * Duration Management
 * http://www.w3.org/TR/xmlschema11-2/#duration
 * https://en.wikipedia.org/wiki/ISO_8601#Durations
 */
class DurationUtil {

  /**
   * Parse duration String
   * @param inputText user text
   * @return instance or null
   */
  static DurationUtil parse(String inputText) {
    if (inputText == null || inputText.isEmpty) {
      return null;
    }
    // xml
    if (inputText.contains("P")) {
      return new DurationUtil.xml(inputText);
    }

    int years = 0;
    int months = 0;
    int days = 0;
    int hours = 0;
    int minutes = 0;
    int seconds = 0;

    final String unsigned = inputText.replaceAll("-", "");
    bool negative = inputText.contains("-");

    // is it a number 1 10
    int intError = -12345;
    int numberInt = int.parse(unsigned, onError: (String i) {return intError;});
    if (numberInt != intError) {
      if (numberInt < INTEGERISMINUTES) {
        hours = numberInt;
      } else {
        minutes = numberInt;
      }
      return new DurationUtil(!negative, years, months, days, hours, minutes, seconds);
    }
    // is it a number 1.0 1.5
    double numberDouble = double.parse(unsigned,
        (String value) {return double.INFINITY;});
    if (numberDouble != double.INFINITY) {
      hours = numberDouble.floor();
      num remaining = numberDouble - hours.toDouble();
      minutes = (remaining * SEC_MINUTES_D).floor();
      remaining -= minutes.toDouble() / SEC_MINUTES;
      seconds = (remaining * SEC_HOURS_D).floor();
      return new DurationUtil(!negative, years, months, days, hours, minutes, seconds);
    }

    // it is hh:mm
    int index = unsigned.indexOf(':');
    if (index != -1) {
      try {
        final String hh = unsigned.substring(0, index);
        final String mm = unsigned.substring(index + 1);
        if (hh.isNotEmpty) {
          hours = int.parse(hh);
        }
        if (mm.isNotEmpty) {
          minutes = int.parse(mm);
        }
        return new DurationUtil(!negative, years, months, days, hours, minutes, seconds);
      } catch (e) {
      }
    }

    // European decimal ,
    index = unsigned.indexOf(',');
    if (index != -1) {
      // final String converted = unsigned.replaceAll(",", ".");
      // is it a number 1 10
      numberInt = int.parse(unsigned, onError: (String i) {return intError;});
      if (numberInt != intError) {
        if (numberInt < INTEGERISMINUTES) {
          hours = numberInt;
        } else {
          minutes = numberInt;
        }
        return new DurationUtil(!negative, years, months, days, hours, minutes, seconds);
      }
      // is it a number 1.0 1.5
      numberDouble = double.parse(unsigned,
          (String value) {return double.INFINITY;});
      if (numberDouble != double.MIN_POSITIVE) {
        hours = numberDouble.floor();
        minutes = ((numberDouble - hours.toDouble()) * SEC_MINUTES_D).floor();
        seconds = ((numberDouble - hours.toDouble()) * SEC_HOURS_D).floor();
        return new DurationUtil(!negative, years, months, days, hours, minutes, seconds);
      }
    }

    // other
    try {
      List<int> codeIgnore = "- ".codeUnits;
      List<int> codeYear = "yY".codeUnits;
      List<int> codeMonth = "M".codeUnits;
      List<int> codeDay = "dD".codeUnits;
      List<int> codeHour = "hH".codeUnits;
      List<int> codeMinute = "m".codeUnits;
      List<int> codeSecond = "sS".codeUnits;

      String str = "";
      for (int c in inputText.codeUnits) {
        if (codeIgnore.contains(c)) {
          continue; // negative handled later
        }
        if (codeYear.contains(c)) {
          if (str.length > 0) {
            years = int.parse(str);
          }
          str = "";
        }
        else if (codeMonth.contains(c)) {
          if (str.length > 0) {
            months = int.parse(str);
          }
          str = "";
        }
        else if (codeDay.contains(c)) {
          if (str.length > 0) {
            days = int.parse(str);
          }
          str = "";
        }
        else if (codeHour.contains(c)) {
          if (str.length > 0) {
            hours = int.parse(str);
          }
          str = "";
        }
        else if (codeMinute.contains(c)) {
          if (str.length > 0) {
            minutes = int.parse(str);
          }
          str = "";
        }
        else if (codeSecond.contains(c)) {
          if (str.length > 0) {
            seconds = int.parse(str);
          }
          str = "";
        }
        else {
          str += new String.fromCharCode(c);
        }
      } // loop
      if (str.length > 0) {
        final int xx = int.parse(str);
        if (minutes == 0) {
          minutes = xx;
        }
      }
    }
    catch (error) {
    //_log.warning("parse ${inputText}", error, stackTrace);
      return null; // parse error
    }
    return new DurationUtil(!negative, years, months, days, hours, minutes, seconds);
  } // parse

  /// format mm:hh:ss
  static String formatDuration(Duration dur) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }
    String threeDigits(int n) {
      if (n >= 100) return "$n";
      if (n >= 10) return "0$n";
      return "00$n";
    }
    String twoDigitSeconds = twoDigits(dur.inSeconds.remainder(Duration.SECONDS_PER_MINUTE));
    String threeDigitUs = threeDigits(dur.inMilliseconds.remainder(Duration.MILLISECONDS_PER_SECOND));
    if (dur.inHours != 0) {
      String twoDigitMinutes = twoDigits(dur.inMinutes.remainder(Duration.MINUTES_PER_HOUR));
      return "${dur.inHours}:${twoDigitMinutes}:${twoDigitSeconds}.${threeDigitUs}s";
    }
    if (dur.inMinutes != 0) {
      return "${dur.inMinutes}:${twoDigitSeconds}.${threeDigitUs}s";
    }
    return "${dur.inSeconds}.${threeDigitUs}s";
  } // formatDuration


  /** Day in Seconds 24h (86400). */
  static const int SEC_DAYS = 60 * 60 * 24;
  /** Hour in Seconds (3600). */
  static const int SEC_HOURS = 60 * 60;
  /** Minute in Seconds. */
  static const int SEC_MINUTES = 60;
  /** Month in Seconds 24h 30d. */
  static const int SEC_MONTHS = 60 * 60 * 24 * 30;
  /** Year in Seconds 24h 30d. (360) */
  static const int SEC_YEARS = 60 * 60 * 24 * 30 * 12;
  /** Month in Days 30d. */
  static const int DAY_MONTHS = 30;
  /** Year in Days 30dx12 = 360 */
  static const int DAY_YEARS = 30 * 12;
  /** When is an integer interpreted as minutes - 14h 15m */
  static const int INTEGERISMINUTES = 15;
  /** Hour in Seconds (3600.0). */
  static const double SEC_HOURS_D = 60.0 * 60.0;
  /** Minute in Seconds. */
  static const double SEC_MINUTES_D = 60.0;

  static final Logger _log = new Logger("BizDuration");


  int _signum = 0;
  int _years = 0;
  int _months = 0;
  int _days = 0;
  int _hours = 0;
  int _minutes = 0;
  int _seconds = 0;

  /**
   * Duration Detail Constructor
   */
  DurationUtil(bool isPositive, this._years, this._months, this._days, this._hours, this._minutes, this._seconds) {
    _signum = isPositive ? 1 : -1;
  } // BizDuration

  /**
   * Duration Second Constructor converts based on 360d year, 30d month, 24h day
   * e.g. new DurationUtil.seconds(duration.inSeconds);
   */
  DurationUtil.seconds(int seconds) {
    int remaining = seconds;
    if (seconds == 0) {
      _signum = 0;
    }
    else if (seconds < 0)  {
      _signum = -1;
      remaining = -seconds;
    }
    else {
      _signum = 1;
    }
    int years = remaining ~/ SEC_YEARS;
    if (years != 0) {
      _years = years;
    }
    remaining = remaining - (years * SEC_YEARS);
    int months = remaining ~/ SEC_MONTHS;
    if (months != 0) {
      _months = months;
    }
    remaining = remaining - (months * SEC_MONTHS);
    int days = remaining ~/ SEC_DAYS;
    if (days != 0) {
      _days = days;
    }
    remaining = remaining - (days * SEC_DAYS);
    int hours = remaining ~/ SEC_HOURS;
    if (hours != 0) {
      _hours = hours;
    }
    remaining = remaining - (hours * SEC_HOURS);
    int minutes = remaining ~/ SEC_MINUTES;
    if (minutes != 0) {
      _minutes = minutes;
    }
    remaining = remaining - (minutes * SEC_MINUTES);
    if (remaining != 0) {
      _seconds = remaining;
    }
  } // BizDuration.seconds

  /**
   * Xml Duration Constructor
   */
  DurationUtil.xml(String xmlDuration) {
    if (xmlDuration != null && xmlDuration.isNotEmpty) {
      _signum = xmlDuration.startsWith("-") ? -1 : 1;
      final int pPos = xmlDuration.indexOf('P');
      if (pPos == -1) {
        throw new Exception("Invalid: no 'P' - " + xmlDuration);
      }
      int tPos = xmlDuration.indexOf('T');
      if (tPos == -1) {
        _parseDatePart(xmlDuration.substring(pPos + 1));
      } else {
        _parseDatePart(xmlDuration.substring(pPos + 1, tPos));
        _parseTimePart(xmlDuration.substring(tPos + 1));
      }
    }
    asSeconds();
  } // BizDuration.xml


  /// As Duration (30 days per month, 360 per year)
  Duration asDuration() {
    int durationDays = _days * (DAY_MONTHS * _months) + (DAY_YEARS * _years);
    return new Duration(days: durationDays, hours: _hours, minutes: _minutes, seconds: _seconds);
  } // asDuration

  /**
   * Get as "nice" display string
   * @return nice display string
   */
  String asString() {
    // output
    final StringBuffer sb = new StringBuffer();
    if (isNegative) {
      sb.write('-');
    }
    if (_years > 0) {
      sb..write(_years)
        ..write("y");
    }
    if (_months > 0) {
      if (sb.length > 0) {
        sb.write(' ');
      }
      sb..write(_months)
        ..write("M");
    }
    if (_days > 0) {
      if (sb.length > 0) {
        sb.write(' ');
      }
      sb..write(_days)
        ..write("d");
    }
    // Hours
    if (_hours > 0 || _minutes > 0 || _seconds > 0) {
      // no days, etc and h<10  and m/s < 60
      if (sb.length == 0
      && _hours < 10 && _minutes < 60 && _seconds < 60) {
        if (_minutes == 0 && _seconds == 0) {
          sb..write(_hours)
            ..write('h');
        }
        else {
          sb..write(_hours)
            ..write(':');
          if (_minutes < 10) {
            sb.write('0');
          }
          sb.write(_minutes);
          if (_seconds > 0) {
            sb.write(':');
            if (_seconds < 10) {
              sb.write('0');
            }
            sb.write(_seconds);
          }
        }
      }
      else { // value and indicator
        if (_hours > 0) {
          if (sb.length > 0) {
            sb.write(' ');
          }
          sb..write(_hours)
            ..write("h");
        }
        if (_minutes > 0) {
          if (sb.length > 0) {
            sb.write(' ');
          }
          sb..write(_minutes)
            ..write("m");
        }
        if (_seconds > 0) {
          if (sb.length > 0) {
            sb.write(' ');
          }
          sb..write(_seconds)
            ..write("s");
        }
      }
    }
    return sb.toString();
  } // asString


  /// As Xml P88D
  String asXml() {
    StringBuffer sb = new StringBuffer();
    if (isZero) {
      return "P0D";
    }
    if (_signum < 0) {
      sb.write('-');
    }
    // Date
    sb.write('P');
    if (_years != 0) {
      sb..write(_years)
        ..write('Y');
    }
    if (_months != 0) {
      sb..write(_months)
        ..write('M');
    }
    if (_days != 0) {
      sb..write(_days)
        ..write('D');
    }
    // Time
    if (_hours != 0 || _minutes != 0 || _seconds != 0) {
      sb..write('T');
      if (_hours != 0) {
        sb..write(_hours)
          ..write('H');
      }
      if (_minutes != 0) {
        sb..write(_minutes)
          ..write('M');
      }
      if (_seconds != 0) {
        sb..write(_seconds)
          ..write('S');
      }
    }
    String retValue = sb.toString();
    if ("P" == retValue)
      return "P0D";
    return retValue;
  } // asXml

  /**
   * As Seconds based on 24h 30d
   * (sets signum)
   */
  int asSeconds() {
    int sec = _seconds;
    if (_minutes != 0) {
      sec += _minutes * SEC_MINUTES;
    }
    if (_hours != 0) {
      sec += _hours * SEC_HOURS;
    }
    if (_days != 0) {
      sec += _days * SEC_DAYS;
    }
    if (_months != 0) {
      sec += _months * SEC_MONTHS;
    }
    if (_years != 0) {
      sec += _years * SEC_YEARS;
    }
    if (sec == 0) {
      _signum = 0;
    }
    return sec * _signum;
  } // asSeconds

  /**
   * As Hours based on [hoursPerDay] and [daysPerMonth]
   */
  double asHours({int hoursPerDay: 8, int daysPerMonth: 20}) {
    double hours = _hours.toDouble();
    if (_minutes > 0) {
      hours += (_minutes / SEC_MINUTES);
    }
    if (_seconds > 0) {
      hours += (_seconds / SEC_HOURS);
    }
    if (_days != 0) {
      hours += _days * hoursPerDay;
    }
    if (_months != 0) {
      hours += _months * hoursPerDay * daysPerMonth;
    }
    if (_years != 0) {
      hours += _years * 12 * hoursPerDay * daysPerMonth;
    }
    if (_signum < 0) {
      return -hours;
    }
    return hours;
  }

  /// Zero Duration
  bool get isZero => _signum == 0;
  /// Negative Duration
  bool get isNegative => _signum < 0;

  @override
  String toString() => asXml();

  /**
   * Parse Year-Month-Day
   * @param xmlDatePart nYnMnD
   * @return remainder
   * @throws NumberFormatException format issue
   */
  String _parseDatePart(String xmlDatePart) {
    if (xmlDatePart == null || xmlDatePart.isEmpty) {
      return xmlDatePart;
    }
    String rest = xmlDatePart;
    // Y
    int index = rest.indexOf('Y');
    if (index != -1) {
      String s = rest.substring(0, index);
      if (s.isNotEmpty) {
        _years = int.parse(s);
      }
      rest = rest.substring(index + 1);
    }
    // M
    index = rest.indexOf('M');
    if (index != -1) {
      final String s = rest.substring(0, index);
      if (s.isNotEmpty) {
        _months = int.parse(s);
      }
      rest = rest.substring(index + 1);
    }
    // D
    index = rest.indexOf('D');
    if (index != -1) {
      final String s = rest.substring(0, index);
      if (s.isNotEmpty) {
        _days = int.parse(s);
      }
      rest = rest.substring(index + 1);
    }
    return rest;
  } // parseDatePart

  /**
   * Parse Hour-Minute-Second
   * @param xmlTimePart nHnMnS
   * @return remainder
   * @throws NumberFormatException format issue
   */
  String _parseTimePart(String xmlTimePart) {
    if (xmlTimePart == null || xmlTimePart.isEmpty) {
      return xmlTimePart;
    }
    String rest = xmlTimePart;
    // H
    int index = rest.indexOf('H');
    if (index != -1) {
      final String s = rest.substring(0, index);
      if (s.isNotEmpty) {
        _hours = int.parse(s);
      }
      rest = rest.substring(index + 1);
    }
    // M
    index = rest.indexOf('M');
    if (index != -1) {
      final String s = rest.substring(0, index);
      if (s.isNotEmpty) {
        _minutes = int.parse(s);
      }
      rest = rest.substring(index + 1);
    }
    // S
    index = rest.indexOf('S');
    if (index != -1) {
      final String s = rest.substring(0, index);
      if (s.isNotEmpty) {
        _seconds = int.parse(s);
      }
      rest = rest.substring(index + 1);
    }
    return rest;
  } // parseTimePart

} // DurationUtil
