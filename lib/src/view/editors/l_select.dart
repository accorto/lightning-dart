/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Select Editor
 *
 *    LSelect s = new LSelect("s");
 *    // either use OptionElement
 *    s.options = optionList;
 *    s.addOption(oe);
 *
 *    // and/or use SelectOption
 *    s.selectOptions = selectOptionList;
 *    s.addSelectOption(so);
 *
 *    // and/or
 *    s.addOptionValue(myValue, label:myLabel);
 */
class LSelect
    extends LEditor with LFormElement, LSelectI {

  static final Logger _log = new Logger("LSelect");

  /// Select Element
  final SelectElement input = new SelectElement();
  /// all options
  final List<SelectOption> _selectOptionList = new List<SelectOption>();

  /**
   * Select Editor
   */
  LSelect(String name, {String idPrefix, bool multiple:false, bool inGrid:false}) {
    createSelectLayout(this, inGrid: inGrid);
    input.name = name;
    id = createId(idPrefix, name);
    input.multiple = multiple;
    if (multiple && !inGrid)
      size = 2;
    _initEditor();
  }

  /// Select Editor
  LSelect.from(DataColumn dataColumn, {String idPrefix, bool multiple:false, bool inGrid:false}) {
    createSelectLayout(this, inGrid: inGrid);
    DColumn tableColumn = dataColumn.tableColumn;
    input.name = tableColumn.name;
    id = createId(idPrefix, input.name);
    if (multiple != null) {
      input.multiple = multiple;
    } else {
      input.multiple = tableColumn.dataType == DataType.PICKMULTI || tableColumn.dataType == DataType.PICKMULTICHOICE;
    }
    if (multiple && !inGrid)
      size = 2;
    // Selection List
    if (tableColumn.pickValueList.isNotEmpty) {
      dOptionList = tableColumn.pickValueList;
    }
    this.dataColumn = dataColumn;
    _initEditor();
  } // LSelect

  /// Init Editor
  void _initEditor() {
    //
    input.onChange.listen(onInputChange);
    // Alternative display
    if (dataColumn != null && dataColumn.tableColumn.pickValueList.isEmpty
        && dataColumn.tableColumn.dataType == DataType.BOOLEAN) {
      dOptionList = OptionUtil.optionsYesNo(false);
      // make optional
      if (dataColumn.uiPanelColumn != null
        && dataColumn.uiPanelColumn.hasIsMandatory()
        && !dataColumn.uiPanelColumn.isMandatory) {
        dataColumn.tableColumn.clearIsMandatory();
        required = false;
      }
    }
  } // initEditor

  void updateId(String idPrefix) {
    id = createId(idPrefix, name);
  }

  String get name => input.name;
  String get type => input.type;

  bool get multiple => input.multiple;
  void set multiple (bool newValue) {
    input.multiple = newValue;
  }

  /// Size of Select
  int get size => input.size;
  /// Size of Select
  void set size (int newValue) {
    if (newValue > 0) {
      input.size = newValue;
      if (newValue > 2) { // set size to prevent re-render if options change
        input.style.height = "${2.125*newValue}rem"; // line height
      } else {
        input.style.removeProperty("height");
      }
    }
  }

  /// String Value
  String get value {
    if (multiple) {
      List<String> list = valueList;
      return list.join(",");
    }
    return input.value;
  }
  void set value (String newValue) {
    validateOptions();
    input.value = newValue;
  }

  /// get values as list
  List<String> get valueList {
    List<String> list = new List<String>();
    for (OptionElement op in input.selectedOptions) {
      list.add(op.value);
    }
    return list;
  }

  /// notification that dependent changed
  void onDependentOnChanged(DEntry dependentEntity) {
    super.onDependentOnChanged(dependentEntity);
    validateOptions();
  }

  /**
   * Rendered Value (different from value)
   */
  String get valueDisplay => renderSync(value, false);
  /// is the rendered [valueDisplay] different from the [value]
  bool get isValueDisplay => true;
  /// render [newValue]
  Future<String> render(String newValue, bool setValidity) {
    Completer<String> completer = new Completer<String>();
    completer.complete(renderSync(newValue, setValidity));
    return completer.future;
  } // render
  /// render [newValue]
  String renderSync(String newValue, bool setValidity) {
    if (setValidity) {
      input.setCustomValidity("");
    }
    if (newValue == null || newValue.isEmpty) {
      return "";
    }
    for (OptionElement oe in options) {
      if (oe.value == newValue)
        return oe.label;
    }
    if (setValidity) {
      input.setCustomValidity("Invalid Value: ${newValue}");
    }
    return "?${newValue}?";
  } // renderSync



  String get defaultValue => _defaultValue;
  void set defaultValue (String newValue) {
    _defaultValue = newValue;
  }
  String _defaultValue;

  /// set value by synonym (alternative representations) - returns true if found - null if not supported
  bool setValueSynonym (String newValue) {
    if (newValue == null || newValue.isEmpty) {
      value = newValue;
      return true;
    }
    for (SelectOption item in _selectOptionList) {
      if (OptionUtil.isSynonym(item.option, newValue)) {
        _log.config("setValueSynonym ${name}=${item.value}[${item.label}] value=${newValue}");
        value = item.value;
        return true;
      }
    }
    return false;
  } // setValueSynonym


  /// base editor methods

  bool get readOnly => _readOnly;
  void set readOnly (bool newValue) {
    _readOnly = newValue;
    input.disabled = _readOnly || _disabled;
    if (_readOnly)
      input.classes.add("read-only");
    else
      input.classes.remove("read-only");
  }
  bool _readOnly = false;

  bool get disabled => _disabled;
  void set disabled (bool newValue) {
    _disabled = newValue;
    input.disabled = _readOnly || _disabled;
  }
  bool _disabled = false;

  /// required - add/remove optional element
  void set required (bool newValue) {
    super.required = newValue; // UI - LFormElement
    if (listId != null && listId.isNotEmpty)
      return; // don't change data list

    // Add/Remove Optional element for single selection
    if (!multiple) {
      if (input.options.isNotEmpty) {
        OptionElement oe = input.options.first;
        if (oe.value.isEmpty) {
          if (newValue) { // required
            input.children.removeAt(0);
          }
        } else if (!newValue) { // add optional
          input.children.insert(0, new OptionElement());
        }
      }
    }
  } // required

  bool get spellcheck => input.spellcheck;
  void set spellcheck (bool newValue) {
    input.spellcheck = newValue;
  }

  bool get autofocus => input.autofocus;
  void set autofocus (bool newValue) {
    input.autofocus = newValue;
  }

  /// Validation

  int get maxlength => 60;
  void set maxlength (int newValue) {
  }

  String get pattern => null;
  void set pattern (String newValue) {
  }

  /// Validation state from Input
  ValidityState get inputValidationState => input.validity;
  /// Validation Message from Input
  String get inputValidationMsg => input.validationMessage;
  /// set custom validity explicitly
  void setCustomValidity(String newValue) {
    input.setCustomValidity(newValue);
  }
  /// Display

  String get placeholder => null;
  void set placeholder (String newValue) {
  }


  /// get Data List Id
  String get listId => input.attributes["list"];
  /// get Data List Id
  void set listId (String newValue) {
    input.attributes["list"] = newValue;
  }
  /// Set Data List
  void set list (SelectDataList dl) {
    input.attributes["list"] = dl.id;
  }

  /// -- options --

  /// Get options
  List<OptionElement> get options => input.options;
  /// Add Option List
  void set options (List<OptionElement> list) {
    clearOptions();
    for (OptionElement oe in list) {
      addSelectOption(new SelectOption.fromElement(oe));
    }
    required = required; // handle optional
  }
  /// Add Option
  void addOption(OptionElement oe) {
    addSelectOption(new SelectOption.fromElement(oe));
  }

  /// -- select options --

  /// get updated Option list
  List<SelectOption> get selectOptionList {
    for (SelectOption so in _selectOptionList) {
      so.option.isSelected = so.oe.selected;
    }
    return _selectOptionList;
  }
  /// Add Option List
  void set selectOptionList(List<SelectOption> list) {
    clearOptions();
    for (SelectOption so in list) {
      _selectOptionList.add(so);
      input.append(so.asOptionElement());
      if (so.option.validationList.isNotEmpty) {
        addDependentOnValidation(so.option.validationList);
      }
    }
    required = required; // handle optional
  }
  /// Add Option
  void addSelectOption(SelectOption so) {
    _selectOptionList.add(so);
    input.append(so.asOptionElement());
    if (so.option.validationList.isNotEmpty) {
      addDependentOnValidation(so.option.validationList);
    }
  }

  /// clear options
  void clearOptions() {
    _selectOptionList.clear();
    input.children.clear();
  }

  /// Add DOption
  void addDOption(DOption option) {
    SelectOption so = new SelectOption(option);
    addSelectOption(so);
  }

  /// Option Count
  int get length {
    return input.length;
  }

  /// Selected Count
  int get selectedCount {
    return input.selectedOptions.length;
  }

  /**
   * dis|en/ables options
   */
  void validateOptions() {
    if (data != null && hasDependentOn) {
      String currentValue = input.value;
      int count = 0;
      bool invalidated = false;
      List<OptionElement> options = input.options;
      for (OptionElement oe in options) {
        bool valid = _validateOption(oe.value);
        oe.disabled = !valid;
        if (valid) {
          oe.classes.remove(LVisibility.C_HIDE);
        } else {
          count++;
          oe.classes.add(LVisibility.C_HIDE);
          if (oe.value == currentValue) {
            input.value = ""; // invalidate current
            invalidated = true;
          }
        }
      }
      _log.fine("validateOptions disabled=${count} of ${options.length} - invalidated=${invalidated}");
    }
  } // validateOptions

  /// Validate option - returns true if valid
  bool _validateOption(String optionValue) {
    for (SelectOption so in _selectOptionList) {
      if (so.option.value == optionValue) {
        if (so.option.validationList.isEmpty) {
          return true; // no restrictions
        }
        for (DKeyValue val in so.option.validationList) {
          DEntry entry = data.getEntry(null, val.key, false); // key = columnName
          if (entry != null && val.value == entry.value) {
            return true; // one is enough - show
          }
        }
        return false; // not in positive list
      } // found option
    }
    return true; // disabled
  } // validate option

  String toString() {
    int size = 0;
    if (dataColumn != null && dataColumn.tableColumn != null)
      size = dataColumn.tableColumn.pickListSize;
    return "LSelect[${name}=${input.value} #${input.size}(${size})]";
  }

} // LSelect
