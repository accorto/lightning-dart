/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Dropdown with triggering button
 */
class LDropdown extends LComponent {

  static const String C_DROPDOWN = "slds-dropdown";
  static const String C_DROPDOWN_TRIGGER = "slds-dropdown-trigger";
  static const String C_DROPDOWN__HEADER = "slds-dropdown__header";

  static const String C_DROPDOWN__MENU = "slds-dropdown--menu";
  static const String C_DROPDOWN__NUBBIN_TOP = "slds-dropdown--nubbin-top";
  static const String C_DROPDOWN__ACTIONS = "slds-dropdown--actions";

  static const String C_DROPDOWN__LEFT = "slds-dropdown--left";
  static const String C_DROPDOWN__RIGHT = "slds-dropdown--right";
  static const String C_DROPDOWN__SMALL = "slds-dropdown--small";

  static const String C_DROPDOWN__LIST = "slds-dropdown__list";
  static const String C_DROPDOWN__ITEM = "slds-dropdown__item";

  static const String C_HAS_DIVIDER = "slds-has-divider";
  /// Item
  static const String C_HAS_ICON__LEFT = "slds-has-icon--left";
  static const String C_IS_SELECTED = "slds-is-selected";
  static const String C_ICON__LEFT = "slds-icon--left";
  static const String C_ICON__RIGHT = "slds-icon--right";


  static List<String> POSITIONS = [C_DROPDOWN__LEFT, C_DROPDOWN__RIGHT];


  /// Dropdown with Button
  final DivElement element = new DivElement()
    ..classes.add(C_DROPDOWN_TRIGGER)
    ..setAttribute(Html0.ARIA_HASPOPUP, "true");

  /// Dropdown Button
  final LButton button;

  /// Dropdown Panel
  final LDropdownElement dropdown = new LDropdownElement(new DivElement()
    ..classes.addAll([C_DROPDOWN, C_DROPDOWN__MENU]));
  /// Heading Label
  SpanElement dropdownHeadingLabel;

  /// Id Prefix
  final String idPrefix;


  /**
   * Dropdown for [button] (classes are set here)
   * div  .trigger
   * - button
   * - div  .dropdown
   * -- div .header
   * -- ul .dropdown__list
   */
  LDropdown(LButton this.button, String this.idPrefix) {
    button.classes.addAll([LButton.C_BUTTON, LButton.C_BUTTON__ICON_CONTAINER]);
    button.icon.classes.add(LButton.C_BUTTON__ICON);
    add(button);
    //
    element.append(dropdown.element);
  } // LDropdown

  /// Settings Button+Dropdown
  LDropdown.settings(String idPrefix) : this(new LButton(new ButtonElement(), "settings", null,
      icon: new LIconUtility(LIconUtility.SETTINGS),
      assistiveText: "Settings"), idPrefix);

  LDropdown.action(String idPrefix) : this(new LButton(new ButtonElement(), "more", null,
      buttonClasses: [LButton.C_BUTTON__ICON_BORDER_FILLED],
      icon: new LIconUtility(LIconUtility.DOWN), // slds-dropdown--right slds-dropdown--actions
      assistiveText: "More"), idPrefix);


  /**
   * Search Drop Down
   */
  LDropdown.search(LButton this.button, InputElement input, String this.idPrefix, {
      String placeholder: "Find in list...",
      String headingLabel: "List"}) {
    button.classes.addAll([LButton.C_BUTTON, LButton.C_BUTTON__ICON_CONTAINER]);
    button.icon.classes.add(LButton.C_BUTTON__ICON);
    add(button);
    //
    dropdown.element.classes.add(C_DROPDOWN__SMALL);
    element.append(dropdown.element);
    //
    DivElement header = new DivElement()
      ..classes.add(C_DROPDOWN__HEADER);
    element.append(header);
    DivElement searchDiv = new DivElement()
      ..classes.addAll([
        LEditor.C_INPUT_HAS_ICON, LEditor.C_INPUT_HAS_ICON__LEFT, LMargin.C_BOTTOM__X_SMALL]);
    header.append(searchDiv);
    LIcon searchIcon = new LIconUtility(LIconUtility.SEARCH, className: "slds-input__icon");
    searchDiv.append(searchIcon.element);
    input
      ..type = "search"
      ..placeholder = placeholder
      ..classes.add(LEditor.C_INPUT)
      ..id = idPrefix + "-search";
    LabelElement labelEle = new LabelElement()
      ..classes.add(LText.C_ASSISTIVE_TEXT)
      ..htmlFor = input.id
      ..text = placeholder;
    searchDiv.append(labelEle);
    searchDiv.append(input);
    //
    dropdownHeadingLabel = new SpanElement()
      ..classes.add(LText.C_TEXT_HEADING__LABEL)
      ..text = placeholder;
    header.append(dropdownHeadingLabel);
  } // search


  /// Heading Label
  String get headingLabel => dropdownHeadingLabel == null ? null : dropdownHeadingLabel.text;
  /// Heading Label
  void set headingLabel (String newValue) {
    if (dropdownHeadingLabel == null) {
    DivElement dropdownHeading = new DivElement()
      ..classes.add(C_DROPDOWN__HEADER);
    dropdownHeadingLabel = new SpanElement()
      ..classes.add(LText.C_TEXT_HEADING__LABEL);
    dropdownHeading.append(dropdownHeadingLabel);
    dropdown.element.insertBefore(dropdownHeading, dropdown.dropdownList);
    }
    dropdownHeadingLabel.text = newValue;
  }

} // LDropdown


/**
 * Dropdown Element maintains list
 */
class LDropdownElement {

  /// Dropdown Element
  final DivElement element;
  /// Dropdown Items
  final List<LDropdownItem> items = new List<LDropdownItem>();


  /// Dropdown List
  final UListElement dropdownList = new UListElement()
    ..classes.add(LDropdown.C_DROPDOWN__LIST)
    ..setAttribute(Html0.ROLE, Html0.ROLE_MENU);

  /// Dropdown Element
  LDropdownElement(DivElement this.element) {
    element.append(dropdownList);
  }

  /// Nub on top
  bool get nubbinTop => element.classes.contains(LDropdown.C_DROPDOWN__NUBBIN_TOP);
  void set nubbinTop (bool newValue) {
    if (newValue)
      element.classes.add(LDropdown.C_DROPDOWN__NUBBIN_TOP);
    else
      element.classes.remove(LDropdown.C_DROPDOWN__NUBBIN_TOP);
  }

  /// Center Position
  bool get center => !element.classes.contains(LDropdown.C_DROPDOWN__LEFT)
      && !element.classes.contains(LDropdown.C_DROPDOWN__RIGHT);
  void set center (bool newValue) {
    if (newValue)
      element.classes.removeAll(LDropdown.POSITIONS);
  }

  /// Right Position (button is right)
  bool get right => element.classes.contains(LDropdown.C_DROPDOWN__RIGHT);
  void set right (bool newValue) {
    if (newValue) {
      element.classes.remove(LDropdown.C_DROPDOWN__LEFT);
      element.classes.add(LDropdown.C_DROPDOWN__RIGHT);
    } else {
      element.classes.remove(LDropdown.C_DROPDOWN__RIGHT);
    }
  }

  /// Left Position (button is left)
  bool get left => element.classes.contains(LDropdown.C_DROPDOWN__LEFT);
  void set left (bool newValue) {
    if (newValue) {
      element.classes.add(LDropdown.C_DROPDOWN__LEFT);
      element.classes.remove(LDropdown.C_DROPDOWN__RIGHT);
    } else {
      element.classes.remove(LDropdown.C_DROPDOWN__LEFT);
    }
  }

  /// Small
  bool get small => element.classes.contains(LDropdown.C_DROPDOWN__SMALL);
  void set small (bool newValue) {
    if (newValue) {
      element.classes.add(LDropdown.C_DROPDOWN__SMALL);
    } else {
      element.classes.remove(LDropdown.C_DROPDOWN__SMALL);
    }
  }

  /**
   * Add Menu Item
   */
  void addMenuItem(LDropdownItem item) {
    items.add(item);
    dropdownList.append(item.element);
  }


} // LDropdownElement



/**
 * Dropdown Item
 */
class LDropdownItem extends ListItem {


  /**
   * Dropdown item
   */
  LDropdownItem({String id, String label, String href, LIcon leftIcon, LIcon rightIcon})
      : super(id:id, label:label, href:href, leftIcon:leftIcon, rightIcon:rightIcon) {
    element
      ..classes.add(LDropdown.C_DROPDOWN__ITEM)
      ..tabIndex = -1
      ..attributes[Html0.ROLE] = Html0.ROLE_MENUITEM + " " + Html0.ROLE_OPTION;
    a
      ..classes.add(LText.C_TRUNCATE)
      ..tabIndex = -1;
  } // LDropdownItem

  /// Divider
  bool get divider => element.classes.contains(LDropdown.C_HAS_DIVIDER);
  void set divider (bool newValue) {
    if (newValue)
      element.classes.add(LDropdown.C_HAS_DIVIDER);
    else
      element.classes.remove(LDropdown.C_HAS_DIVIDER);
  }

  /**
   * Create Link
   */
  void _rebuildLink() {
    if (_selected) {
      if (_selectedIcon == null) {
        _selectedIcon = new LIconStandard("task2", size: LIcon.C_ICON__SMALL)
          ..classes.add(LDropdown.C_ICON__LEFT);
      }
      _leftIcon = _selectedIcon;
    } else {
      _leftIcon = null;
    }
    super._rebuildLink();
  }
  LIcon _selectedIcon;

} // LDropdownItem
