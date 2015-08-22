/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Select Editor
 */
class LSelect extends LEditor with LFormElement implements LSelectI {

  /// Select Element
  final SelectElement input = new SelectElement();

  /**
   * Select Editor
   */
  LSelect(String name, {String idPrefix, bool multiple:false}) {
    createStandard(input);
    input.name = name;
    input.id = createId(idPrefix, name);
    input.multiple = multiple;
  }

  /// Select Editor
  LSelect.from(DColumn column, {String idPrefix, bool multiple}) {
    createStandard(input);
    input.name = column.name;
    input.id = createId(idPrefix, name);
    if (multiple != null)
      input.multiple = multiple;
    else
      input.multiple = column.dataType == DataType.PICKMULTI || column.dataType == DataType.PICKMULTICHOICE;

    //
    if (column.pickValueList.isNotEmpty) {
      dOptions = column.pickValueList;
    }
    this.column = column;
  } // LSelect


  void updateId(String idPrefix) {
    id = createId(idPrefix, name);
  }

  String get name => input.name;
  String get type => input.type;

  bool get multiple => input.multiple;

  /// String Value

  String get value => input.value;
  void set value (String newValue) {
    input.value = newValue;
  }

  String get defaultValue => _defaultValue;
  void set defaultValue (String newValue) {
    _defaultValue = newValue;
  }
  String _defaultValue;

  /// base editor methods

  bool get readOnly => input.disabled;
  void set readOnly (bool newValue) {
    input.disabled = newValue;
  }

  bool get disabled => input.disabled;
  void set disabled (bool newValue) {
    input.disabled = newValue;
  }

  /// required
  bool get required => input.required;
  /// required - add/remove optional element
  void set required (bool newValue) {
    super.required = newValue; // ui
    input.required = newValue;
    if (listId.isNotEmpty)
      return; // don't change data list

    // Add/Remove Optional element for single selection
    if (!multiple) {
      if (input.options.isNotEmpty) {
        OptionElement oe = input.options.first;
        if (oe.value.isEmpty) {
          if (newValue) {
            input.options.removeAt(0);
            // required
          }
        } else if (!newValue) {
          input.options.insert(0, new OptionElement());
          // optional
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
  ValidityState get validationState => input.validity;
  /// Validation Message from Input
  String get validationMsg => input.validationMessage;

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

  /// Add Option List
  void set selectOptions(List<SelectOption> list) {
    for (SelectOption op in list) {
      input.append(op.asOptionElement());
    }
  }
  /// Get options
  List<OptionElement> get options => input.options;
  /// Add Option List
  void set options (List<OptionElement> list) {
    for (OptionElement oe in list) {
      input.append(oe);
    }
  }
  /// Add Option
  void addOption(OptionElement oe) {
    input.append(oe);
  }

  /// Add Option
  void addSelectOption(SelectOption op) {
    input.append(op.asOptionElement());
  }
  /// Add DOption List
  void set dOptions(List<DOption> options) {
    for (DOption option in options) {
      SelectOption so = new SelectOption(option);
      addSelectOption(so);
    }
  }
  /// Set List Items
  void set listItems (List<ListItem> listItems) {
    for (ListItem li in listItems) {
      SelectOption so = new SelectOption(li.asDOption());
      addSelectOption(so);
    }
  }

} // LSelect



/**
 * Select Interface
 */
abstract class LSelectI {

  String get name;

  String get value;
  void set value (String newValue);

  /// Multi
  bool get multiple;

  /// required
  bool get required;
  /// required - add/remove optional element
  void set required(bool newValue);


  /// Get options
  List<OptionElement> get options;
  /// Set options
  void set options (List<OptionElement> list);
  /// Add Option
  void addOption(OptionElement oe);


  /// Set List Items
  void set listItems (List<ListItem> listItems);
  /// Add Option List
  void set selectOptions(List<SelectOption> list);
  /// Add Option
  void addSelectOption(SelectOption op);

  /// Add Option List
  void set dOptions(List<DOption> options);

} // LSelectI
