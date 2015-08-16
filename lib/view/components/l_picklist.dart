/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;


/**
 * Picklist (Select Element alternative)
 */
class LPicklist { // }implements LSelectI {

  static const String C_PICKLIST = "slds-picklist";
  static const String C_PICKLIST__LABEL = "slds-picklist__label";

  /// Form Element
  final DivElement element = new DivElement()
    ..classes.add(LForm.C_FORM_ELEMENT);

  final DivElement _pl = new DivElement()
    ..classes.add(C_PICKLIST);
  final SpanElement _label = new SpanElement()
    ..classes.add(LText.C_TRUNCATE);
  LButton _button;
  final LDropdownElement dropdown = new LDropdownElement(new DivElement()
    ..classes.addAll([LDropdown.C_DROPDOWN, LDropdown.C_DROPDOWN__MENU]));

  /**
   * Picklist
   */
  LPicklist(String idPrefix) {
    element.append(_pl);
    _button = new LButton("select", null, idPrefix:idPrefix,
      buttonClasses: [LButton.C_BUTTON__NEUTRAL, C_PICKLIST__LABEL],
      labelElement: _label,
      icon: new LIconUtility("down"));
    _button.element.attributes[Html0.ARIA_HASPOPUP] = "true";
    _pl.append(_button.element);
    //
    dropdown.left = true;
    dropdown.small = true;
    element.append(dropdown.element);
  } //LPicklist


  /// PickList Expanded
  bool get expanded => _pl.attributes[Html0.ARIA_EXPANED] == "true";
  /// PickList Expanded
  void set expanded (bool newValue) {
    _pl.attributes[Html0.ARIA_EXPANED] = newValue.toString();

  }


} // LPicklist



class LPicklistMulti {


}


class LPicklistFind {


}

