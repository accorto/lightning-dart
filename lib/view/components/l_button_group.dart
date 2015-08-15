/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Button Group
 */
class LButtonGroup {

  static const String C_BUTTON_GROUP = "slds-button-group";
  static const String C_BUTTON__LAST = "slds-button--last";

  /// Button Group
  DivElement element = new DivElement()
    ..classes.add(C_BUTTON_GROUP)
    ..setAttribute(Html0.ROLE, Html0.ROLE_GROUP);

  /// all buttons in group
  List<LButton> buttons = new List<LButton>();
  /// buttons in dropdown
  List<LButton> dropdownButtons = new List<LButton>();
  /// More Button
  final LButton more = new LButton("more", null, icon: new LIconUtility("down"), assistiveText: "More");

  /// Inverse Button Bar
  final bool inverse;

  /**
   * Button Group
   */
  LButtonGroup({bool this.inverse: false}) {
    more.element.classes.add(inverse ? LButton.C_BUTTON__ICON_BORDER : LButton.C_BUTTON__ICON_BORDER_FILLED);
    if (inverse) {
      more.icon.element.classes.add(LButton.C_BUTTON__ICON__INVERSE);
    }
  } // LButton

  /// add and attach button
  void add(LButton button, {bool append: true}) {
    button.element.classes.add(inverse ? LButton.C_BUTTON__INVERSE : LButton.C_BUTTON__NEUTRAL);
    buttons.add(button);
    if (append)
      element.append(button.element);
  }

  /// layout
  void layout(int showCount) {
    element.children.clear();
    dropdownButtons.clear();
    for (int i = 0; i < buttons.length; i++) {
      LButton button = buttons[i];
      button.element.classes.remove(C_BUTTON__LAST);
      if (i < showCount) {
        element.append(button.element);
        if (i+1 == showCount) {
          button.element.classes.add(C_BUTTON__LAST);
        }
      } else {
        dropdownButtons.add(button);
      }
    }
    element.append(more.element);
    if (dropdownButtons.isEmpty) {
      more.disabled = true;
    } else {
      more.disabled = false;
      // TODO Dropdown
    }
  } // layout

} // LButtonGroup
