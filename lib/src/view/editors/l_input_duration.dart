/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Duration Editor
 */
class LInputDuration
    extends LInput {

  static final Logger _log = new Logger("LInputDuration");

  /// Type
  bool _isHour = false;

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
    _isHour = (type == EditorI.TYPE_DURATIONHOUR);
    if (hint == null) {
      hint = _isHour ? lInputDurationHourHint() : lInputDurationHint();
    }
    input.onBlur.listen((Event evt){
      input.value = render(input.value, true);
    });
  }

  /**
   * Value
   */
  @override
  String get value {
    String display = input.value;
    return parse(display, true);
  } // get value

  /// Set new value
  @override
  void set value(String newValue) {
    input.value = render(newValue, true);
  } // set value

  /// is the value in hours (number)
  bool get isHour => _isHour;

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
    return render(inp, true);
  }
  /// is the rendered [valueDisplay] different from the [value]
  @override
  bool get valueRendered {
    return true;
  }

  /**
   * Render [value] for display
   */
  @override
  String render(String newValue, bool setValidity) {
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
    input.defaultValue = render(newValue, false);
  } // defaultValue

  /// maxlength ignored
  @override
  void set maxlength (int ignored) {
  }


  /// translation
  static String lInputDurationInvalidValue() => Intl.message("Invalid value", name: "lInputDurationInvalidValue");
  static String lInputDurationInvalidInput() => Intl.message("Invalid input for duration", name: "lInputDurationInvalidInput");

  static String lInputDurationHint() => Intl.message("without indicator enter hours with decimal or colon (1.5 = 1:30); e.g.: 5d1h20m or 5d 1h 10", name: "lInputDurationHint");
  static String lInputDurationHourHint() => Intl.message("hours with decimal or colon (1.5 = 1:30)", name: "lInputDurationHourHint");


} // LInputDuration
