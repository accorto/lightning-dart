/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;


/**
 * Picklist (Select Element alternative)
 * div .form-element
 * * div .picklist
 * -- button
 * -- div .dropdown
 */
class LPicklist extends LEditor implements LSelectI {

  /// slds-picklist - Initializes picklist | Required
  static const String C_PICKLIST = "slds-picklist";
  /// slds-picklist__label - Custom select | Required
  static const String C_PICKLIST__LABEL = "slds-picklist__label";
  /// slds-picklist--draggable - Initializes draggable picklists | Required
  static const String C_PICKLIST__DRAGGABLE = "slds-picklist--draggable";
  /// slds-picklist__options - Custom select group of options | Required
  static const String C_PICKLIST__OPTIONS = "slds-picklist__options";
  /// slds-picklist__item - Styles for items within the optiongroup | Required
  static const String C_PICKLIST__ITEM = "slds-picklist__item";

  /// Picklist form element
  final DivElement element = new DivElement()
    ..classes.add(LForm.C_FORM_ELEMENT);
  final DivElement _pl = new DivElement()
    ..classes.add(C_PICKLIST);
  final SpanElement _buttonLabel = new SpanElement()
    ..classes.add(LText.C_TRUNCATE);
  LButton _button;
  LDropdownElement dropdown;

  /**
   * Picklist
   * div  element .form_element
   * - div .picklist
   * -- button .form-element--label
   * -- div .dropdown
   */
  LPicklist(String idPrefix) {
    element.append(_pl);
    _button = new LButton(new ButtonElement(), "select", null, idPrefix:idPrefix,
      buttonClasses: [LButton.C_BUTTON__NEUTRAL, C_PICKLIST__LABEL],
      labelElement: _buttonLabel,
      icon: new LIconUtility(LIconUtility.DOWN));
    _button.element.attributes[Html0.ARIA_HASPOPUP] = "true";
    _button.onClick.listen(onButtonClick);
    _pl.append(_button.element);
    _buttonLabel.text = "Select an option";
    //
    dropdown = new LDropdownElement(
        new DivElement()
          ..classes.addAll([LDropdown.C_DROPDOWN, LDropdown.C_DROPDOWN__LEFT,
              LDropdown.C_DROPDOWN__SMALL, LDropdown.C_DROPDOWN__MENU]),
        name:name, idPrefix:id);
    _pl.append(dropdown.element);
    expanded = false;
  } // LPicklist

  String get id => _button.id;
  void set id (String newValue) {
    if (newValue != null && newValue.isNotEmpty) {
      _button.element.id = newValue;
    //  if (_labelElement != null)
    //    _labelElement.htmlFor = newValue;
    }
  }
  void updateId(String idPrefix) {
    id = createId(idPrefix, name);
  }

  String get name => _button.name;
  String get type => EditorI.TYPE_SELECT;
  Element get input => _button.element;
  bool get multiple => false;

  String get title => _button.title;
  void set title (String newValue) {
    _button.title = newValue;
  }

  /// Get Editor Label
  @override
  LabelElement get labelElement { // TODO
    if (_labelElement == null) {
      _labelElement = new LabelElement()
        ..classes.add(LForm.C_FORM_ELEMENT__LABEL);
      if (id != null || id.isNotEmpty)
        _labelElement.htmlFor = id;
      if (label != null)
        _labelElement.text = label;
    }
    return _labelElement;
  }
  LabelElement _labelElement;

  /// Get Editor Label
  @override
  Element get labelSmall { // TODO
    if (_labelSmall == null) {
      _labelSmall = new Element.tag("small");
      if (label != null)
        _labelSmall.text = label;
    }
    return _labelSmall;
  }
  Element _labelSmall;


  /// String Value

  String get value => _value;
  void set value (String newValue) {
    _value = newValue;
    // TODO
  }
  String _value;

  String get defaultValue => null; // not supported
  void set defaultValue (String newValue) {
  }


  /// base editor methods

  bool get readOnly => _button.disabled;
  void set readOnly (bool newValue) {
    _button.disabled = newValue;
  }

  bool get disabled => _button.disabled;
  void set disabled (bool newValue) {
    _button.disabled = newValue;
  }

  bool get required => _required;
  void set required (bool newValue) {
    _required = newValue; // don't male inut required (= checked)
    if (newValue) {
      element.classes.add(LForm.C_IS_REQUIRED);
    } else {
      element.classes.remove(LForm.C_IS_REQUIRED);
    }
  }
  bool _required = false;

  bool get spellcheck => false;
  void set spellcheck (bool newValue) { // ignore
  }

  bool get autofocus => false;
  void set autofocus (bool newValue) { // ignore
  }

  /// Validation state from Input
  ValidityState get validationState => null;
  /// Validation Message from Input
  String get validationMsg => null;


  /// Get options
  List<OptionElement> get options => dropdown.options;
  /// Set options
  void set options (List<OptionElement> list) {
    dropdown.options = list;
  }
  /// Add Option
  void addOption(OptionElement oe) {
    dropdown.addOption(oe);
  }
  /// Add Option
  void addSelectOption(SelectOption op) {
    dropdown.addSelectOption(op);
  }
  /// Add Option List
  void set selectOptions(List<SelectOption> list) {
    dropdown.selectOptions = list;
  }
  /// Add Option List
  void set dOptions(List<DOption> options) {
    dropdown.dOptions = options;
  }
  /// Set List Items
  void set listItems (List<ListItem> listItems) {
    dropdown.listItems = listItems;
  }

  /// Button clicked
  void onButtonClick(MouseEvent evt) {
    expanded = !expanded; // toggle
  }


  /// PickList Expanded
  bool get expanded => _pl.attributes[Html0.ARIA_EXPANED] == "true";
  /// PickList Expanded
  void set expanded (bool newValue) {
    _pl.attributes[Html0.ARIA_EXPANED] = newValue.toString();
    dropdown.show = newValue;
  }

} // LPicklist



class LPicklistMulti {


}


class LPicklistFind {


}

