/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;


/**
 * Form Radio Group - Alternative to Select
 */
class LRadioGroup
    extends LEditor with LSelectI {

  /// Radio Form Element
  final FieldSetElement element = new FieldSetElement()
    ..classes.add(LForm.C_FORM_ELEMENT);

  /// label
  final LegendElement _legend = new LegendElement()
    ..classes.addAll([LForm.C_FORM_ELEMENT__LABEL]);
  /// required flag
  final Element _requiredElement = new Element.tag("abbr")
    ..classes.add(LForm.C_REQUIRED)
    ..title = LFormElement.lFormElementRequired();
  /// Label Span
  final SpanElement _labelSpan = new SpanElement();

  final DivElement _control = new DivElement()
    ..classes.add(LForm.C_FORM_ELEMENT__CONTROL);
  final DivElement _controlDiv = new DivElement();
  final SpanElement _hintElement = new SpanElement()
    ..classes.add(LForm.C_FORM_ELEMENT__HELP);



  String get name => _name;
  String _name;
  String idPrefix;
  final bool multiple;
  final bool asButtons;

  final List<LRadioOption> _optionList = new List<LRadioOption>();

  /**
   * Form Radio Group
   */
  LRadioGroup(String name, {String this.idPrefix, bool this.multiple:false, bool this.asButtons:false}) {
    _name = name;
    element.id = LComponent.createId(idPrefix, _name);
    _legend.append(_requiredElement);
    _legend.append(_labelSpan);
    element.append(_legend);
    if (asButtons)
      _controlDiv.classes.add(multiple ? LForm.C_CHECKBOX__BUTTON_GROUP : LForm.C_RADIO__BUTTON_GROUP);
    _control.append(_controlDiv);
    element.append(_control);
    element.append(_hintElement);
  } // LRadioGroup

  /// Form Radio Group - Select Editor API
  LRadioGroup.from(DataColumn dataColumn, {String this.idPrefix, bool this.multiple:false, bool this.asButtons:false}) {
    DColumn tableColumn = dataColumn.tableColumn;
    _name = dataColumn.name;
    element.id = createId(idPrefix, _name);
    _legend.append(_requiredElement);
    _legend.append(_labelSpan);
    element.append(_legend);
    if (asButtons)
      _controlDiv.classes.add(multiple ? LForm.C_CHECKBOX__BUTTON_GROUP : LForm.C_RADIO__BUTTON_GROUP);
    _control.append(_controlDiv);
    element.append(_control);
    element.append(_hintElement);

    // Selection List
    if (tableColumn.pickValueList.isNotEmpty) {
      dOptionList = tableColumn.pickValueList;
    }
    this.dataColumn = dataColumn;
  } // LRadioGroup

  @override
  String get value {
    String theValue = "";
    for (LRadioOption radioOption in _optionList) {
      if (radioOption.selected) {
        if (multiple) {
          if (theValue.isNotEmpty)
            theValue += LSelectI.MULTI_SEP;
          theValue += radioOption.value;
        } else {
          return radioOption.value;
        }
      }
    }
    return theValue;
  }
  @override
  void set value (String newValue) {
    List<String> values = newValue == null ? new List<String>() : newValue.split(LSelectI.MULTI_SEP);
    for (LRadioOption radioOption in _optionList) {
      if (multiple) {
        radioOption.selected = false;
        for (String vv in values) {
          if (vv == radioOption.value) {
            radioOption.selected = true;
            break;
          }
        }
      } else {
        radioOption.selected = newValue == radioOption.value;
      }
    }
  } // setValue

  void set label (String newValue) {
    _labelSpan.text = newValue;
  }


  @override
  bool autofocus = false;

  @override
  String defaultValue;

  @override
  bool get disabled => _disabled;
  void set disabled (bool newValue) {
    _disabled = newValue;
    for (LRadioOption radioOption in _optionList) {
      radioOption.disabled = newValue;
    }
  }
  bool _disabled = false;

  // TODO help
  @override
  String help;

  @override
  String get hint => _hintElement.text;
  void set hint (String newValue) {
    _hintElement.text = newValue;
  }

  @override
  bool get readOnly => _readOnly;
  void set readOnly (bool newValue) {
    _readOnly = newValue;
    for (LRadioOption radioOption in _optionList) {
      radioOption.readOnly = newValue;
    }
  }
  bool _readOnly = false;

  /// Required
  bool get required => _required;
  /// set required
  void set required (bool newValue) {
    _required = newValue;
    if (newValue) {
      element.classes.add(LForm.C_IS_REQUIRED);
      _requiredElement.title = LFormElement.lFormElementRequired();
      _requiredElement.text = "* ";
    } else {
      element.classes.remove(LForm.C_IS_REQUIRED);
      _requiredElement.title = LFormElement.lFormElementNotRequired();
      _requiredElement.text = "";
    }
  }
  bool _required = false;

  @override
  bool spellcheck;

  @override
  String get title => element.title;
  void set title (String newValue) {
    element.title = newValue;
  }

  @override
  String get id => element.id;

  @override
  String get type => EditorI.TYPE_SELECT;

  @override
  void updateId(String idPrefix) {
    idPrefix = idPrefix;
    element.id = LComponent.createId(idPrefix, name);
  }

  @override
  bool get inGrid => false;

  @override
  Element get input => element; // onFocus

  // TODO: implement inputValidationMsg
  @override
  String get inputValidationMsg => element.validationMessage;

  // TODO: implement inputValidationState
  @override
  ValidityState get inputValidationState => null;

  @override
  void setCustomValidity(String newValue) {
    // TODO: implement setCustomValidity
  }

  @override
  void updateStatusValidationState() {
    // TODO: implement updateStatusValidationState
  }


  @override
  List<OptionElement> get options {
    List<OptionElement> list = new List<OptionElement>();
    for (LRadioOption radioOption in _optionList) {
      list.add(radioOption.oe);
    }
    return list;
  }
  @override
  void set options (List<OptionElement> newValue) {
    clearOptions();
    for (OptionElement oe in newValue)
        addOption(oe);
  }

  @override
  void clearOptions() {
    _optionList.clear();
    _controlDiv.children.clear();
  }

  @override
  void addDOption(DOption option) {
    LRadioOption radioOption = new LRadioOption(name, idPrefix, onInputChange,
        option, OptionUtil.element(option), multiple, asButtons);
    _optionList.add(radioOption);
    _controlDiv.append(radioOption.element);
  }

  @override
  void addOption(OptionElement oe) {
    LRadioOption radioOption = new LRadioOption(name, idPrefix, onInputChange,
        OptionUtil.optionFromElement(oe), oe, multiple, asButtons);
    _optionList.add(radioOption);
    _controlDiv.append(radioOption.element);
  }

  @override
  void addSelectOption(SelectOption op) {
    LRadioOption radioOption = new LRadioOption(name, idPrefix, onInputChange,
        op.option, op.oe, multiple, asButtons);
    _optionList.add(radioOption);
    _controlDiv.append(radioOption.element);
  }

  @override
  int get length => _optionList.length;

  @override
  List<SelectOption> get selectOptionList {
    List<SelectOption> list = new List<SelectOption>();
    for (LRadioOption radioOption in _optionList) {
      list.add(new SelectOption(radioOption.option));
    }
    return list;
  }

  @override
  int get selectedCount {
    int count = 0;
    for (LRadioOption radioOption in _optionList) {
      if (radioOption.selected)
        count++;
    }
    return count;
  }

} // LRadio


/**
 * Radio Option
 */
class LRadioOption {

  final LabelElement element = new LabelElement();

  final InputElement _input = new InputElement();
  final SpanElement _labelSpan = new SpanElement();

  final DOption option;
  final OptionElement oe;

  /**
   * Radio Option
   */
  LRadioOption(String name, String idPrefix, void onInputChange(Event evt),
      DOption this.option, OptionElement this.oe, bool multiple, bool asButtons) {
    if (asButtons) {
      element.classes.add(LButton.C_BUTTON);
      element.classes.add(multiple ? LForm.C_CHECKBOX__BUTTON : LForm.C_RADIO__BUTTON);
    } else {
      element.classes.add(multiple ? LForm.C_CHECKBOX : LForm.C_RADIO);
    }
    String id = "${idPrefix}-${name}-${option.value}";
    element.htmlFor = id;
    //
    _input
        ..type = multiple ? EditorI.TYPE_CHECKBOX : EditorI.TYPE_RADIO
        ..name = name
        ..id = id;
    element.append(_input);
    //
    if (asButtons) {
      _labelSpan
        ..classes.add(multiple ? LForm.C_CHECKBOX__FAUX : LForm.C_RADIO__FAUX);
    } else {
      element.append(new SpanElement()
        ..classes.add(multiple ? LForm.C_CHECKBOX__FAUX : LForm.C_RADIO__FAUX));
      _labelSpan
        ..classes.add(LForm.C_FORM_ELEMENT__LABEL);
    }
    element.append(_labelSpan);
    //
    _labelSpan.text = option.label;
    //
    selected = option.hasIsDefault() && option.isDefault;
    //
    _input.onClick.listen((MouseEvent evt) {
      if (readOnly) {
        evt.preventDefault();
        evt.stopPropagation();
      } else {
        onInputChange(evt);
      }
    });
  } // LRadioOption

  bool get selected => _input.checked;
  void set selected (bool newValue) {
    _input.checked = newValue;
  }

  bool get disabled => _input.disabled;
  void set disabled (bool newValue) {
    _input.disabled = newValue;
  }

  bool get readOnly => _input.readOnly;
  void set readOnly (bool newValue) {
    _input.readOnly = newValue; // does not prevent click
    _input.disabled = newValue;
  }

  String get value => option.value;

} // LRadioOption
