/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Button Group
 */
class LButtonGroup extends LComponent {

  static const String C_BUTTON_GROUP = "slds-button-group";
  static const String C_BUTTON__LAST = "slds-button--last";

  /// Button Group
  DivElement element = new DivElement()
    ..classes.add(C_BUTTON_GROUP)
    ..setAttribute(Html0.ROLE, Html0.ROLE_GROUP);

  /// all buttons in group
  List<LButton> _buttons = new List<LButton>();
  /// More Button
  final LButton _more = new LButton(new ButtonElement(), "more", null,
      icon: new LIconUtility(LIconUtility.DOWN),
      assistiveText: lButtonGroupMore());
  /// Inverse Button Bar
  final bool inverse;

  /**
   * Button Group
   */
  LButtonGroup({bool this.inverse: false}) {
    _more.classes.add(inverse ? LButton.C_BUTTON__ICON_BORDER : LButton.C_BUTTON__ICON_BORDER_FILLED);
    if (inverse) {
      _more.icon.classes.add(LButton.C_BUTTON__ICON__INVERSE);
    }
    _more.onClick.listen((MouseEvent evt) {
      _more.element.classes.toggle(LVisibility.C_ACTIVE);
    });
  } // LButton

  void set id (String newValue) {
    element.id = newValue;
  }

  /// add and attach button
  void add(LButton button, {bool append: true}) {
    button.classes.add(inverse ? LButton.C_BUTTON__INVERSE : LButton.C_BUTTON__NEUTRAL);
    _buttons.add(button);
    if (append)
      element.append(button.element);
  }

  /// layout with [showCount] 0 for all -1 for dropdown
  void layout(int showCount) {
    element.children.clear();
    List<LDropdownItem> dropdownItems = new List<LDropdownItem>();
    for (int i = 0; i < _buttons.length; i++) {
      LButton button = _buttons[i];
      button.classes.remove(C_BUTTON__LAST);
      if (showCount == 0 || i < showCount) {
        element.append(button.element);
        if (i+1 == showCount) {
        //  button.element.classes.add(C_BUTTON__LAST);
        }
      } else {
        LDropdownItem ddi = new LDropdownItem.fromButton(button);
        ddi.onClick.listen((Event evt) {
          button.element.click();
        });
        dropdownItems.add(ddi);
      }
    }
    if (dropdownItems.isEmpty) {
      _more.disabled = true;
      element.classes.remove(LDropdown.C_DROPDOWN_TRIGGER);
      element.classes.remove(LDropdown.C_CLICK_TO_SHOW);
      element.attributes.remove(Html0.ARIA_HASPOPUP);
    } else { // dropdown
      element.append(_more.element);
      _more.disabled = false;
      _more.classes.add(C_BUTTON__LAST);
      //
      element.classes.add(LDropdown.C_DROPDOWN_TRIGGER);
    //  element.classes.add(LDropdown.C_CLICK_TO_SHOW);
      element.attributes[Html0.ARIA_HASPOPUP] = "true";

      String name = element.id;
      if (name == null || name.isEmpty)
        name = "button-group";
      DivElement dd = new DivElement()
        ..classes.addAll([LDropdown.C_DROPDOWN, LDropdown.C_DROPDOWN__RIGHT, LDropdown.C_DROPDOWN__ACTIONS, LDropdown.C_DROPDOWN__MENU]);
      LDropdownElement dde = new LDropdownElement(dd, name:name);
      element.append(dde.element);
      for (LDropdownItem ddi in dropdownItems) {
        dde.addItem(ddi);
      }
    }
  } // layout


  /// Trl
  static String lButtonGroupMore() => Intl.message("More", name: "lButtonGroupMore", args: []);

} // LButtonGroup
