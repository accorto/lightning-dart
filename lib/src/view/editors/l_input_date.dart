/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Date Editor
 */
class LInputDate extends LInput {

  /// The Icon
  final LIcon _iconRight = new LIconUtility(LIconUtility.EVENT);

  /// Date Formatter
  DateFormat _formatter;
  ///
  String _invalidInput = "??";
  String _type = EditorI.TYPE_DATE;

  /**
   *
   */
  LInputDate(String name, String type, {String idPrefix}) : super(name, type, idPrefix:idPrefix) {
    _initDate(type);
  }

  LInputDate.from(DColumn column, {String idPrefix, String type}) :super.from(column, idPrefix:idPrefix, type:type) {
    _initDate(type);
  }

  @override
  void _initEditor() {
    input.onChange.listen(onInputChange);
    input.onKeyUp.listen(onInputKeyUp);
  }

  void _initDate(String type) {
    if (!_html5) {
      input.type = EditorI.TYPE_TEXT;
    }
    if (type == EditorI.TYPE_DATETIME) {
      _formatter = ClientEnv.dateFormat_ymd_hm;
      _invalidInput = lInputDateInvalidInputDateTime();
      _type = EditorI.TYPE_DATETIME;
    } else if (type == EditorI.TYPE_TIME) {
      _formatter = ClientEnv.dateFormat_hm; // new DateFormat.Hm(ClientEnv.localeName);
      _invalidInput = lInputDateInvalidInputTime();
      _type = EditorI.TYPE_TIME;
    } else {
      _formatter = ClientEnv.dateFormat_ymd; //  new DateFormat.yMd(ClientEnv.localeName);
      _invalidInput = lInputDateInvalidInputDate();
      _type = EditorI.TYPE_DATE;
    }
  } // initDate

  @override
  LIcon getIconRight() => _iconRight;

  /**
   * Value - (milliseconds)
   */
  @override
  String get value {
    String v = input.value;
    return parse(v, true);
  } // value

  /// Set new value
  @override
  void set value(String newValue) {
    String display = render(newValue, true);
    input.value = display;
    // check
    String x = value; // read back
    if (newValue != null && newValue != x) {
      if (type == EditorI.TYPE_DATE) {
        _log.config("setValue ${name}=${newValue} <> ${x} -- ${DataUtil.asDateString(newValue, _html5)} display=${display}");
      } else if (type == EditorI.TYPE_DATETIME) {
        _log.config("setValue ${name}=${newValue} <> ${x} -- ${DataUtil.asDateTimeString(newValue, _html5)} display=${display}");
      } else if (type == EditorI.TYPE_TIME) {
        _log.config("setValue ${name}=${newValue} <> ${x} -- ${DataUtil.asTimeString(newValue, data, _html5)} display=${display}");
      }
      //  updateData(x); // actual parsed value
    }
  } // value

  @override
  void set valueOriginal(String newValue) {
    if (_isEmpty(newValue)) {
      super.valueOriginal = newValue;
    } else {
      int ms = int.parse(newValue, onError: (String value) {
        return 0; // variable
      });
      if (ms == 0) {
        ms = DataUtil.parseDateVariable(newValue, type);
        if (ms == 0)
          _valueOriginal = null;
        else
          _valueOriginal = ms.toString();
      } else {
        _valueOriginal = newValue;
      }
      defaultValue = render(newValue, false); // variables;
    }
  } // valueOriginal

  /**
   * Rendered Value (different from value)
   */
  @override
  String get valueDisplay {
    return input.value;
  }
  /// is the rendered [valueDisplay] different from the [value]
  @override
  bool get valueRendered {
    return true;
  }

  /**
   * Render [value] in ms for display or ""
   */
  @override
  String render(String valueMs, bool setValidity) {
    if (setValidity)
      input.setCustomValidity("");
    if (_isEmpty(valueMs) || valueMs == "0")
      return "";
    String display = null;
    if (type == EditorI.TYPE_DATE) {
      display = DataUtil.asDateString(valueMs, _html5); // UTC
    } else if (type == EditorI.TYPE_DATETIME) {
      display = DataUtil.asDateTimeString(valueMs, _html5); // local
    } else if (type == EditorI.TYPE_TIME) {
      display = DataUtil.asTimeString(valueMs, data, _html5); //
    }
    if (display == null || display.isEmpty) {
      if (setValidity)
        input.setCustomValidity("${lInputDateInvalidValue()}=${valueMs}");
      _log.config("formatTime error value=${valueMs}");
      return valueMs; // invalid
    }
    return display == null ? "" : display;
  } // render

  /// parse display [newValue] to ms or empty string
  String parse(String newValue, bool setValidity) {
    if (setValidity)
      input.setCustomValidity("");
    if (_isEmpty(newValue))
      return "";
    DateTime dt = null;
    if (type == EditorI.TYPE_DATE) {
      dt = DataUtil.asDate(newValue, _html5); // UTC
    } else if (type == EditorI.TYPE_DATETIME) {
      dt = DataUtil.asDateTime(newValue, _html5); // local
    } else if (type == EditorI.TYPE_TIME) {
      dt = DataUtil.asTime(newValue, data, _html5); //
    }
    if (dt == null) {
      if (setValidity)
        input.setCustomValidity("${_invalidInput}=${newValue} [${_formatter.pattern}]");
      return newValue; // invalid
    }
    int time = dt.millisecondsSinceEpoch;
    if (time == 0)
      return "";
    return time.toString();
  } // render


  @override
  String get type {
    return _type;
  }

  @override
  void set readOnly (bool newValue) {
    input.readOnly = newValue;
    if (newValue) {
      input.type = EditorI.TYPE_TEXT; // don't show dd/mm/yyyy when empty
    } else {
      if (_html5)
        input.type = _type;
    }
  }

  @override
  String get defaultValue {
    String userInput = input.defaultValue;
    return parse(userInput, false);
  }
  @override
  void set defaultValue(String newValue) {
    if (_isEmpty(newValue) || newValue == "0") {
      input.defaultValue = "";
    } else {
      input.defaultValue = newValue;
    }
  } // defaultValue

  /// Is the value changed from original
  @override
  bool get changed {
    String v = value;
    if (v == null) v = "";
    String o = _valueOriginal == null ? "" : _valueOriginal;
    if (v != o) {
      // 1424750049000
      if (o.length == 13 && v.length == 13) {
        o = o.substring(0, 10); // remove ms
        v = v.substring(0, 10);
      }
    }
    return v != o;
  } // isChanged



  /// translation
  static String lInputDateInvalidValue() => Intl.message("Invalid value", name: "lInputDateInvalidValue");
  static String lInputDateInvalidInputDate() => Intl.message("Invalid input for date", name: "lInputDateInvalidInputDate");
  static String lInputDateInvalidInputTime() => Intl.message("Invalid input for time", name: "lInputDateInvalidInputTime");
  static String lInputDateInvalidInputDateTime() => Intl.message("Invalid input for date time", name: "lInputDateInvalidInputDateTime");

} // LInputDate