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

  /// slds-button-group - Initializes a grouped set of buttons | Required
  static const String C_BUTTON_GROUP = "slds-button-group";
  /// slds-button--last - Identifies the last button when wrapped in another element
  static const String C_BUTTON__LAST = "slds-button--last";
  /// slds-toggle-visibility - Identifies the last icon button when it should be hidden when `[disabled]`
  static const String C_TOGGLE_VISIBILITY = "slds-toggle-visibility";


  /// Button Group
  DivElement element = new DivElement()
    ..classes.add(C_BUTTON_GROUP)
    ..setAttribute(Html0.ROLE, Html0.ROLE_GROUP);

  /// all buttons in group
  final List<AppsAction> _actionList = new List<AppsAction>();
  final List<LButton> _buttonList = new List<LButton>();
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
      _more.icon.classes.add(LButton.C_BUTTON__ICON_INVERSE);
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
    _buttonList.add(button);
    if (append)
      element.append(button.element);
  }

  /// add and attach action (as button)
  void addAction(AppsAction action, String idPrefix, {bool append: true}) {
    LButton button = action.asButton(true, idPrefix:id); // always create button
    button.classes.add(inverse ? LButton.C_BUTTON__INVERSE : LButton.C_BUTTON__NEUTRAL);
    _actionList.add(action);
    if (append)
      element.append(button.element);
  }

  /// Buttons
  List<LButton> get buttonList => _buttonList;

  /// layout with [showCount] 0 for all -1 for dropdown
  void layout(int showCount) {
    element.children.clear();
    List<LDropdownItem> dropdownItems = new List<LDropdownItem>();
    int items = 0;

    for (AppsAction action in _actionList) {
      items++;
      if (showCount == 0 || items <= showCount) {
        LButton button = action._btn;
        button.classes.remove(C_BUTTON__LAST);
        element.append(button.element);
      } else {
        LDropdownItem ddi = action.asDropdown(true);
        dropdownItems.add(ddi);
      }
    } // for all actions

    for (LButton button in _buttonList) {
      items++;
      if (showCount == 0 || items <= showCount) {
        button.classes.remove(C_BUTTON__LAST);
        element.append(button.element);
      } else {
        LDropdownItem ddi = new LDropdownItem.fromButton(button);
        ddi.onClick.listen((Event evt) {
          button.element.click();
        });
        dropdownItems.add(ddi);
      }
    } // for all buttons

    // add dropdown
    if (dropdownItems.isEmpty) {
      _more.disabled = true;
      element.classes.remove(LDropdown.C_DROPDOWN_TRIGGER);
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
        dde.addDropdownItem(ddi);
      }
    }
  } // layout


  /// Trl
  static String lButtonGroupMore() => Intl.message("More", name: "lButtonGroupMore", args: []);

} // LButtonGroup
