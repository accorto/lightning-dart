/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Duration Editor
 * http://www.w3.org/TR/xmlschema11-2/#duration
 * https://en.wikipedia.org/wiki/ISO_8601#Durations
 */
class LInputDuration
    extends LInput {

  static final Logger _log = new Logger("LInputDuration");

  /// Type
  bool _isHour = false;
  String _type;

  /**
   * Duration
   */
  LInputDuration(String name, {String type:EditorI.TYPE_DURATION, String idPrefix, bool inGrid:false})
    : super(name, type, idPrefix:idPrefix, inGrid:inGrid);

  /**
   * Duration
   */
  LInputDuration.from(DataColumn dataColumn, String type, {String idPrefix, bool inGrid:false})
    : super.from(dataColumn, type, idPrefix:idPrefix, inGrid:inGrid);


  @override
  void _initEditor(String type) {
    super._initEditor(type);
    _type = type;
    _isHour = (type == EditorI.TYPE_DURATIONHOUR);
    mobileUi = Settings.getAsBool(Settings.MOBILE_UI, defaultValue: ClientEnv.isMobileUserAgent);
    input.onBlur.listen((Event evt){
      input.value = renderSync(input.value, true);
    });
  }

  bool get mobileUi => _mobileUi;
  /// mobile ui if Hour use number
  void set mobileUi (bool newValue) {
    _mobileUi = newValue;
    if (_isHour) {
      if (_mobileUi) {
        input.type = _validateType(EditorI.TYPE_NUMBER);
        input.step = "any";
        hint = lInputDurationNumberHint();
      } else {
        input.type = _validateType(_type);
        hint = lInputDurationHourHint();
      }
    } else {
      input.type = _validateType(_type);
      hint = lInputDurationHint();
    }
  }
  bool _mobileUi;

  /**
   * Value (e.g. PT12H ot 12.00)
   */
  @override
  String get value {
    String display = input.value;
    return parse(display, true);
  } // get value

  /// Set new value
  @override
  void set value(String newValue) {
    input.value = renderSync(newValue, true);
  } // set value

  /// get Value as Duration
  Duration get valueAsDuration {
    String display = input.value;
    DurationUtil du = DurationUtil.parse(display);
    if (du != null)
      return du.asDuration();
    return new Duration();
  }
  /// set value - call also: updateData(..) or onInputChange(..)
  void set valueAsDuration(Duration newValue) {
    input.setCustomValidity("");
    if (newValue == null) {
      input.value = "";
    } else {
      DurationUtil dd = new DurationUtil.seconds(newValue.inSeconds);
      if (_isHour) {
        // return ClientEnv.numberFormat_2.format(dd.asHours()); // 8/20
        input.value = dd.asHours().toStringAsFixed(2); // 8/20
      } else {
        input.value = dd.asString(); // user
      }
    }
  }

  /// is the value in hours (number)
  bool get isHour => _isHour;
  String get type => _type;

  /// display -> value - sets validity
  String parse(String userInput, bool setValidity) {
    if (setValidity)
      input.setCustomValidity("");
    if (userInput == null || userInput.isEmpty)
      return userInput;
    DurationUtil dd = DurationUtil.parse(userInput);
    if (dd == null) {
      if (setValidity)
        input.setCustomValidity("${lInputDurationInvalidInput()}=${userInput}");
      return null;
    }
    if (_isHour) {
      // return ClientEnv.numberFormat_2.format(dd.asHours()); // 8/20
      return dd.asHours().toStringAsFixed(2); // 8/20
    }
    return dd.asXml();
  } // parse

  /// get string value as duration
  DurationUtil parseValue(String newValue) {
    if (newValue == null || newValue.isEmpty)
      return new DurationUtil.seconds(0);
    DurationUtil d = DurationUtil.parse(newValue);
    if (d == null) {
      _log.info("parseValue error=${newValue}");
      return new DurationUtil.seconds(0);
    }
    return d;
  } // parseValue

  /**
   * Rendered Value (different from value)
   */
  @override
  String get valueDisplay {
    String inp = input.value;
    return renderSync(inp, true);
  }
  /// is the rendered [valueDisplay] different from the [value]
  @override
  bool get isValueDisplay {
    return true;
  }

  /**
   * Render [value] for display
   */
  String renderSync(String newValue, bool setValidity) {
    if (setValidity)
      input.setCustomValidity("");
    if (_isEmpty(newValue)) {
      return "";
    }
    DurationUtil dd = null;
    try {
      dd = new DurationUtil.xml(newValue);
    } catch (ex) {
      dd = DurationUtil.parse(newValue);
    }
    if (dd == null) {
      if (setValidity)
        input.setCustomValidity("${lInputDurationInvalidValue()}=${newValue}");
      return newValue; // invalid
    }
    if (_isHour) {
      // return ClientEnv.numberFormat_2.format(dd.asHours()); // 8/20
      return dd.asHours().toStringAsFixed(2); // 8/20
    }
    return dd.asString(); // user
  } // render
  /// render [newValue]
  @override
  Future<String> render(String newValue, bool setValidity) {
    Completer<String> completer = new Completer<String>();
    completer.complete(renderSync(newValue, setValidity));
    return completer.future;
  } // render


  /// Is the value changed from original
  bool get changed {
    bool chg = super.changed;
    if (chg && _isNotEmpty(_valueOriginal)) {
      DurationUtil originalValue = parseValue(_valueOriginal);
      DurationUtil currentValue = parseValue(input.value);
      return originalValue.asSeconds() != currentValue.asSeconds();
    }
    return chg;
  } // isChanged

  @override
  String get defaultValue {
    return parse(input.defaultValue, false);
  }
  @override
  void set defaultValue(String newValue) {
    input.defaultValue = renderSync(newValue, false);
  } // defaultValue

  /// maxlength ignored
  @override
  void set maxlength (int ignored) {
  }


  /// translation
  static String lInputDurationInvalidValue() => Intl.message("Invalid value", name: "lInputDurationInvalidValue");
  static String lInputDurationInvalidInput() => Intl.message("Invalid input for duration", name: "lInputDurationInvalidInput");

  static String lInputDurationHint() => Intl.message("hours with decimal or colon (1.5 = 1:30) -or- with indicator (5d1h20m or 5d 1h 10) -or- minutes (>=15)", name: "lInputDurationHint");
  static String lInputDurationHourHint() => Intl.message("browser: hours with decimal or colon (1.5 = 1:30) or minutes (>=15)", name: "lInputDurationHourHint");
  static String lInputDurationNumberHint() => Intl.message("mobile: hours with decimal (1.5) or minutes (>=15)", name: "lInputDurationNumberHint");


} // LInputDuration
