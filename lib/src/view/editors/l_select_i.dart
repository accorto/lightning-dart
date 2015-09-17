/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

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


  /// Get option list
  List<OptionElement> get options;
  /// Set options
  void set options (List<OptionElement> list);
  /// Add Option
  void addOption(OptionElement oe);
  /// Option Count
  int get length;
  /// Option Count
  int get optionCount => length;

  /// Get select option list
  List<SelectOption> get selectOptionList;
  /// Add Select Option List
  void set selectOptionList(List<SelectOption> list) {
    clearOptions();
    for (SelectOption so in list) {
      addSelectOption(so);
    }
  }
  /// Add Select Option
  void addSelectOption(SelectOption op);

  /// Add Option with value and optional label
  void addOptionValue(String value, {String label}) {
    DOption option = new DOption();
    if (value == null)
      option.value = "";
    else
      option.value = value;
    if (label == null)
      option.label = option.value;
    else
      option.label = label;
    addDOption(option);
  } // addOptionValue

  /// clear options
  void clearOptions();

  /// Set List Items
  void set listItemList (List<ListItem> listItems) {
    clearOptions();
    for (ListItem li in listItems) {
      SelectOption so = new SelectOption(li.asDOption());
      addSelectOption(so);
    }
    required = required; // optional
  }

  /// Add Option List
  void set dOptionList(List<DOption> options) {
    clearOptions();
    for (DOption option in options) {
      addDOption(option);
    }
    required = required; // optional
  }
  /// Add DOption
  void addDOption(DOption option);

  /// Set Options from text list
  void set listText (Iterable<String> textList) {
    selectOptionList = SelectOption.createListFromText(textList);
  }

  /// Selected Count
  int get selectedCount;

  /// Selected Value List
  Iterable<String> get values {
    String vv = value;
    if (vv != null && value.isNotEmpty) {
      return vv.split(",");
    }
    return new List<String>();
  }

  /// set selected values [newValues] could be null
  void set values(Iterable<String> newValues) {
    if (newValues == null || newValues.isEmpty) {
      value = "";
    } else {
      Set<String> vv = new Set<String>();
      for (String v in newValues) {
        if (v != null && v.isNotEmpty) {
          vv.add(v);
        }
      }
      value = vv.join(",");
    }
  } // selectedValueList

  /// clear selected values
  void clearSelected() => values = null;

} // LSelectI
