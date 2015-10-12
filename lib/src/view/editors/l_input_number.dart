/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Number Input
 * - issue: if using number -> stepper, simple formatted, wheel, - no thousands.
 */
class LInputNumber
    extends LInput {

  /// Number Format
  NumberFormat numberFormat = new NumberFormat("#,###,##0", ClientEnv.localeName);
  /// Data Type
  DataType dataType;

  /**
   * Number Editor
   */
  LInputNumber(String name, String type, {String idPrefix, bool inGrid:false})
    : super(name, type, idPrefix:idPrefix, inGrid:inGrid);

  /**
   * Number Editor
   */
  LInputNumber.from(DataColumn dataColumn, String type, {String idPrefix, bool inGrid:false})
    : super.from(dataColumn, type, idPrefix:idPrefix, inGrid:inGrid);


  @override
  void _initEditor(String type) {
    super._initEditor(type);
    // alignment
    input.classes.add(LText.C_TEXT_ALIGN__RIGHT);
    // pattern
    input.pattern = "[0-9+-.,]*";
    //
    if (dataType == DataType.CURRENCY) {
      // TODO
    }
  } // initEditor

  /**
   * Value
   */
  @override
  String get value {
    String vv = input.value; // will be "" if invalid
    return parse(vv, true);
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
    //
    try {
      num vv = numberFormat.parse(userInput);
      return vv.toString(); // value as string
    } catch (error) {
    }
    try {
      num vv = num.parse(userInput);
      return vv.toString(); // value as string
    } catch (error) {
      if (setValidity)
        input.setCustomValidity("${error}");
    }
    return null;
  } // parse


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
    try {
      num vv = numberFormat.parse(newValue);
      return numberFormat.format(vv);
    } catch (error) {
    }
    // fallback
    try {
      num vv = num.parse(newValue);
      return numberFormat.format(vv);
    } catch (error) {
      if (setValidity)
        input.setCustomValidity("${error}");
    }
    return newValue; // invalid
  } // render

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

  /// Set Column (digits)
  @override
  void set column (DataColumn newValue) {
    super.column = newValue; // min/max
    dataType = newValue.tableColumn.dataType;
    decimalDigits = newValue.tableColumn.decimalDigits;
  }

  /// Decimal Digits
  int get decimalDigits => numberFormat.maximumFractionDigits;
  /// Decimal Digits
  void set decimalDigits (int newValue) {
    if (newValue > 0) {
      input.classes.add("decimal");
      numberFormat = new NumberFormat("#,###,##0." + "0000000000000".substring(0,newValue), ClientEnv.localeName);
      input.step = "0." + "0000000000000".substring(1,newValue) + "1";
    } else {
      numberFormat = new NumberFormat("#,###,##0", ClientEnv.localeName);
      input.step = "1";
    }
    numberFormat.minimumFractionDigits = newValue;
    numberFormat.maximumFractionDigits = newValue;

  } // decimalDigits


} // LInputNumber
