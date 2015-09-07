/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

class LInputDuration extends LInput {

  /**
   * Duration
   */
  LInputDuration(String name, {String idPrefix, bool inGrid:false})
    : super(name, EditorI.TYPE_DURATION, idPrefix:idPrefix, inGrid:inGrid);

  LInputDuration.from(DColumn column, {String idPrefix, bool inGrid:false})
    : super.from(column, EditorI.TYPE_DURATION, idPrefix:idPrefix, inGrid:inGrid);

  /**
   * Value
   */
  @override
  String get value {
    String v = input.value;
    return parse(v, true);
  } // get value

  /// Set new value
  @override
  void set value(String newValue) {
    input.value = render(newValue, true);
  } // set value


  /// user -> value - sets validity
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
    return dd.asXml();
  } // parseDuration

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
    return input.value;
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


  /// translation
  static String lInputDurationInvalidValue() => Intl.message("Invalid value", name: "lInputDurationInvalidValue");
  static String lInputDurationInvalidInput() => Intl.message("Invalid input for duration", name: "lInputDurationInvalidInput");


} // LInputDuration
