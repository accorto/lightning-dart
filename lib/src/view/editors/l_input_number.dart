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

  static final Logger _log = new Logger("LInputNumber");

  /// Currency Column Name
  static String currencyColumnName;

  /// Number Format
  NumberFormat numberFormat = new NumberFormat("#,###,##0", ClientEnv.localeName);
  /// Data Type
  DataType dataType;
  /// Currency Column;
  DColumn _curColumn;
  /// Currency Selection Element
  SelectElement _currencySelect;

  /**
   * Number Editor
   */
  LInputNumber(String name, {String type:EditorI.TYPE_NUMBER, String idPrefix, bool inGrid:false})
    : super(name, type, idPrefix:idPrefix, inGrid:inGrid) {
    _initNumber();
  }

  /**
   * Number Editor
   */
  LInputNumber.from(DataColumn dataColumn, String type, {String idPrefix, bool inGrid:false})
    : super.from(dataColumn, type, idPrefix:idPrefix, inGrid:inGrid) {
    _initNumber();
  }


  @override
  void _initEditor(String type) {
    super._initEditor(type);
    // alignment
    input.classes.add(LText.C_TEXT_ALIGN__RIGHT);
    // pattern
    input.pattern = "[0-9+-.,]*";

    // stepper - onClick=stepper onChange=+key onInput=+wheel
    // input.onChange.listen(onInputChange); (in super)

    // blur - render value
    input.onBlur.listen((Event evt){
      input.value = renderSync(input.value, true);
    });
  } // initEditor

  void _initNumber() {
    if (html5 || dataType == DataType.INT) {
      input.type = _validateType(EditorI.TYPE_NUMBER);
    } else {
      input.type = EditorI.TYPE_TEXT;
    }
  } // initNumber

  /// use number (stepper) or text - always true if int
  void set html5 (bool newValue) {
    super.html5 = newValue;
    _initNumber();
  }

  /**
   * Value
   */
  @override
  String get value {
    String vv = input.value; // will be "" if html5 invalid
    return parse(vv, false);
  } // get value

  /// Set new value
  @override
  void set value(String newValue) {
    input.value = renderSync(newValue, true);
  } // set value

  /// value as number or NaN
  num get valueAsNumber {
    num nn = input.valueAsNumber;
    if (nn.isNaN && type != EditorI.TYPE_NUMBER) { // e.g. text
      try {
        nn = numberFormat.parse(input.value);
      } catch (error) {
      }
    }
    return nn;
  }
  /// set value - call also: updateData(..) or onInputChange(..)
  void set valueAsNumber(num newValue) {
    input.setCustomValidity("");
    if (newValue == null) {
      input.value = "";
    } else {
      input.valueAsNumber = newValue;
      if (newValue.isNaN || newValue.isInfinite) {
        input.setCustomValidity("invalid");
      }
    }
  }

  /// user -> value - sets validity
  String parse(String userInput, bool setValidity) {
    if (setValidity)
      input.setCustomValidity("");
    if (userInput == null || userInput.isEmpty)
      return userInput;
    //
    try {
      num vv = numberFormat.parse(userInput);
      return vv.toStringAsFixed(decimalDigits); // value as string
    } catch (error) {
    }
    try {
      num vv = num.parse(userInput);
      return vv.toStringAsFixed(decimalDigits); // value as string
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
    try {
      num vv = numberFormat.parse(newValue);
      if (html5)
        return vv.toStringAsFixed(decimalDigits); // no thousands
      return numberFormat.format(vv);
    } catch (error) {
    }
    // fallback
    try {
      num vv = num.parse(newValue);
      if (html5)
        return vv.toStringAsFixed(decimalDigits); // no thousands
      return numberFormat.format(vv);
    } catch (error) {
      if (setValidity)
        input.setCustomValidity("${error}");
    }
    return newValue; // invalid
  } // renderSync
  /// render [newValue]
  @override
  Future<String> render(String newValue, bool setValidity) {
    Completer<String> completer = new Completer<String>();
    completer.complete(renderSync(newValue, setValidity));
    return completer.future;
  } // render

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

  /// Set Column (currency, digits)
  @override
  void set column (DataColumn newValue) {
    super.column = newValue; // min/max
    // data type
    dataType = newValue.tableColumn.dataType;
    if (dataType == DataType.CURRENCY && _currencySelect == null) {
      _columnCurrency();
    }
    // digits (see StatCalc)
    if (newValue.tableColumn.hasDecimalDigits()) {
      decimalDigits = newValue.tableColumn.decimalDigits; // explicit
    } else if (dataType == DataType.AMOUNT || dataType == DataType.CURRENCY) {
      decimalDigits = 2;
      if (inGrid)
        input.classes.add(LInput.C_W160);
    } else if  (dataType == DataType.QUANTITY || dataType == DataType.DECIMAL) {
      decimalDigits = 1;
    } else if  (dataType == DataType.NUMBER) { // float
      decimalDigits = 3;
    } else { // DataType.INT, DataType.RATING
      decimalDigits = 0;
      if (inGrid)
        input.classes.add(LInput.C_W80);
    }
  } // column

  /// Decimal Digits
  int get decimalDigits => numberFormat.maximumFractionDigits;
  /// Decimal Digits
  void set decimalDigits (int newValue) {
    if (newValue > 0) {
      if (newValue > 15)
        newValue = 15;
      numberFormat = new NumberFormat("#,###,##0." + "000000000000000".substring(0,newValue), ClientEnv.localeName);
      input.step = "0." + "000000000000000".substring(1,newValue) + "1";
    } else {
      numberFormat = new NumberFormat("#,###,##0", ClientEnv.localeName);
      input.step = "1";
    }
    numberFormat.minimumFractionDigits = newValue;
    numberFormat.maximumFractionDigits = newValue;
  } // decimalDigits

  /// Left Inside Input Element
  static const String C_INPUT__CUR = "slds-input__cur";
  /// Input has Left Inside Input Element
  static const String C_INPUT_HAS_CUR = "slds-input-has-cur";


  // currency column
  void _columnCurrency() {
    if (currencyColumnName == null || dataColumn == null)
      return;
    // get currency column
    _curColumn = dataColumn.getTableColumn(currencyColumnName);
    if (_curColumn == null || _curColumn.pickValueList.isEmpty)
      return;
    // Currency Select
    _currencySelect = new SelectElement()
      ..name = currencyColumnName
      ..id = createId(id, currencyColumnName)
      ..classes.add(C_INPUT__CUR);
    _input.classes.add(C_INPUT_HAS_CUR);
    // get currency values
    String currencyDefault = null;
    for (DOption op in _curColumn.pickValueList) {
      _currencySelect.append(OptionUtil.element(op));
      if (op.hasIsDefault() && op.isDefault)
        currencyDefault = op.value;
    }
    if (_curColumn.hasDefaultValue()) {
      valueCurrency = _curColumn.defaultValue;
    } else {
      valueCurrency = currencyDefault;
    }
    createAddon(_currencySelect, null);
    input.style
      ..marginLeft = "0" // "${space}px"
      ..width = "100%"; // """calc(100% - ${space}px)";
    if (inGrid)
      input.classes.add(LInput.C_W160);
    //
    if (_currencySelect.options.length == 1) {
      _currencySelect.disabled = true;
    } else {
      _currencySelect.onInput.listen(onInputCurrency);
    }
    if (data != null) {
      DEntry entryC = data.getEntry(null, currencyColumnName, true);
      data.updateEntry(entryC, valueCurrency);
    }
  } // columnCurrency

  /// set value - also for currency
  void set entry (DEntry newValue) {
    super.entry = newValue;
    if (_currencySelect != null) {
      valueCurrency = data.getValue(currencyColumnName);
    }
  }

  /// currency or null
  String get valueCurrency {
    if (_currencySelect != null)
      return _currencySelect.value;
    return null;
  }

  /// set Currency
  void set valueCurrency (String newValue) {
    if (_currencySelect != null) {
      if (newValue == null || newValue.isEmpty) {
        if (_curColumn != null && _curColumn.hasDefaultValue())
          _currencySelect.value = _curColumn.defaultValue;
        else if (_currencySelect.options.isNotEmpty)
          _currencySelect.selectedIndex = 0;
      } else {
        _currencySelect.value = newValue;
      }
    }
  }

  /// Currency Changed
  void onInputCurrency(Event evt) {
    String theValue = valueCurrency;
    if (theValue == null)
      return;
    _log.config("onInputCurrency ${name}=${theValue}");
    if (data != null) {
      DEntry entryC = data.getEntry(null, currencyColumnName, true);
      data.updateEntry(entryC, theValue);
      if (editorChange != null) {
        editorChange(name, theValue, entryC, null);
      }
    }
    input.focus();
  } // onInputCurrency

  /// On Input Change
  void onInputChange(Event evt) {
    super.onInputChange(evt);
    if (_currencySelect != null) {
      onInputCurrency(evt); // unmodified currency
    }
  }

  void set readOnly(bool newValue) {
    super.readOnly = newValue;
    if (_currencySelect != null)
      _currencySelect.disabled = (newValue || disabled);
  }

  void set disabled(bool newValue) {
    super.disabled = newValue;
    if (_currencySelect != null)
      _currencySelect.disabled = (newValue || readOnly);
  }

  String toString() {
    return "LInputNumber@${name} text=${input.text} digits=${decimalDigits} html5=${html5}";
  }

} // LInputNumber
