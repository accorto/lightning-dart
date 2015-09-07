/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * DataList Element
 */
class SelectDataList {

  /// DataList element
  final DataListElement element = new DataListElement();

  /// Data list
  SelectDataList(String id) {
    element.id = id == null || id.isEmpty ? LComponent.createId("data", null) : id;
  }

  /// Data List Id
  String get id => element.id;
  /// dynamic Pick changes
  bool dynamicPickUpdate = false;


  /// Add Option
  void add(SelectOption op) {
    element.append(op.asOptionElement());
    if (op.option.validationList.isNotEmpty) {
      dynamicPickUpdate = true;
    //  _addDependentOnValidation(op.option.validationList);
    }
  }
  /// Add Option List
  void addList(List<SelectOption> list) {
    for (SelectOption op in list) {
      element.append(op.asOptionElement());
      if (op.option.validationList.isNotEmpty) {
        dynamicPickUpdate = true;
      //  _addDependentOnValidation(op.option.validationList);
      }
    }
  }
  /// Get options
  List<OptionElement> get options => element.options;


  /// Add Option
  void addOption(OptionElement oe) {
    element.append(oe);
  }
  /// Add Option List
  void addOptionList(List<OptionElement> list) {
    for (OptionElement oe in list) {
      element.append(oe);
    }
  }

  /// required
  bool get required {
    if (element.options.isEmpty)
      return false;
    OptionElement oe = element.options.first;
    return oe.value.isNotEmpty;
  }
  /// required - add/remove optional element
  void set required (bool newValue) {
    if (element.options.isEmpty)
      return;
    OptionElement oe = element.options.first;
    if (oe.value.isEmpty) {
      if (newValue) {
        element.options.removeAt(0); // required
      }
    } else if (!newValue) {
      element.options.insert(0, new OptionElement()); // optional
    }
  } // required


} // SelectDataList
