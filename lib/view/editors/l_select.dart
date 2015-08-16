/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Select Editor
 */
class LSelect extends LEditorStd implements LSelectI {

  /// Select Element
  final SelectElement input = new SelectElement();

  LSelect(String name) {
    input.name = name;
  }

  String get id => input.id;
  void set id (String newValue) {
    input.id = newValue;
    if (_label != null)
      _label.htmlFor = newValue;
  }

  String get name => input.name;
  String get type => input.type;


  /// required
  bool get required => input.required;
  /// required - add/remove optional element
  void set required (bool newValue) {
    super.required = newValue;
    input.required = newValue;
    if (listId.isNotEmpty)
      return; // don't change data list

    // Add/Remove Optional element
    if (input.options.isNotEmpty) {
      OptionElement oe = input.options.first;
      if (oe.value.isEmpty) {
        if (newValue) {
          input.options.removeAt(0); // required
        }
      } else if (!newValue) {
        input.options.insert(0, new OptionElement()); // optional
      }
    }
  } // required

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

  /// Add Option
  void add(SelectOption op) {
    input.append(op.asOptionElement());
  }
  /// Add Option List
  void addList(List<SelectOption> list) {
    for (SelectOption op in list) {
      input.append(op.asOptionElement());
    }
  }
  /// Get options
  List<OptionElement> get options => input.options;


  /// Add Option
  void addOption(OptionElement oe) {
    input.append(oe);
  }
  /// Add Option List
  void addOptionList(List<OptionElement> list) {
    for (OptionElement oe in list) {
      input.append(oe);
    }
  }

} // LSelect



/**
 * Select Interface
 */
abstract class LSelectI {

  /// required
  bool get required;
  /// required - add/remove optional element
  void set required(bool newValue);

  /// Add Option
  void add(SelectOption op);

  /// Add Option List
  void addList(List<SelectOption> list);

  /// Add Option
  void addOption(OptionElement oe);

  /// Add Option List
  void addOptionList(List<OptionElement> list);

} // LSelectI
