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
  /// Dropdown
  LDropdownElement _dropdown;
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
      if (_dropdown != null)
        _dropdown.show = !_dropdown.show;
    });
  } // LButton

  void set id (String newValue) {
    element.id = newValue;
  }

  /// add component
  void add(LComponent component) {
    if (component is LButton) {
      addButton(component);
    } else {
      super.add(component);
    }
  }

  /// remove all children
  void clear() {
    element.children.clear();
    _buttonList.clear();
    _actionList.clear();
  }

  /**
   * Add and append button
   * if icon button - iconBorder (transparent)
   * - iconBorderFilled (white) - iconContainer (no border)
   */
  void addButton(LButton button, {bool append:true}) {
    if (inverse) {
      button.classes.add(LButton.C_BUTTON__INVERSE);
      button.classes.remove(LButton.C_BUTTON__NEUTRAL);
    }
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

  /// overflow layout with [showCount] 0 for all -1 for dropdown
  void layout(int showCount, {bool autoDropdown:true}) {
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
    addMore(dropdownItems, autoDropdown:autoDropdown);
  } // layout

  /// Add More Button with DropDown
  void addMore(List<LDropdownItem> dropdownItems, {bool autoDropdown:false}) {
    if (dropdownItems.isEmpty) {
      _more.disabled = true;
      element.classes.remove(LDropdown.C_DROPDOWN_TRIGGER);
      element.attributes.remove(Html0.ARIA_HASPOPUP);
      return;
    }
    element.append(_more.element);
    _more.disabled = false;
    _more.classes.add(C_BUTTON__LAST);
    //
    //if (autoDropdown)
    element.classes.add(LDropdown.C_DROPDOWN_TRIGGER);
    element.attributes[Html0.ARIA_HASPOPUP] = "true";

    String name = element.id;
    if (name == null || name.isEmpty)
      name = "button-group";
    DivElement dd = new DivElement()
      ..classes.addAll([LDropdown.C_DROPDOWN, LDropdown.C_DROPDOWN__RIGHT, LDropdown.C_DROPDOWN__ACTIONS]);
    _dropdown = new LDropdownElement(dd, name:name);
    element.append(_dropdown.element);
    for (LDropdownItem ddi in dropdownItems) {
      _dropdown.addDropdownItem(ddi);
    }
  } // addMore

  /// Trl
  static String lButtonGroupMore() => Intl.message("More", name: "lButtonGroupMore", args: []);

} // LButtonGroup
