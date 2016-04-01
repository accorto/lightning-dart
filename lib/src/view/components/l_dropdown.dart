/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Dropdown with triggering button
 */
class LDropdown
    extends LComponent {

  /// slds-dropdown (div): Initializes dropdown - Applies positioning and container styles, by default, dropdown appears below and center of target
  static const String C_DROPDOWN = "slds-dropdown";
  /// slds-dropdown-trigger (div): Enables dropdown to show on hover - The target HTML element and dropdown need to be wrapped in this class
  static const String C_DROPDOWN_TRIGGER = "slds-dropdown-trigger";
  /// slds-dropdown-trigger--click (any element): Modifier that enables dropdown to show on click - Forces display:none on dropdown, applying .slds-is-open to .slds-dropdown-trigger will show the dropdown
  static const String C_DROPDOWN_TRIGGER__CLICK = "slds-dropdown-trigger--click";
  /// slds-dropdown__item (li): Initializes dropdown item
  static const String C_DROPDOWN__ITEM = "slds-dropdown__item";
  /// slds-dropdown--bottom (slds-dropdown): Positions dropdown to above target
  static const String C_DROPDOWN__BOTTOM = "slds-dropdown--bottom";
  /// slds-dropdown--left (slds-dropdown): Positions dropdown to left side of target
  static const String C_DROPDOWN__LEFT = "slds-dropdown--left";
  /// slds-dropdown--right (slds-dropdown): Positions dropdown to right side of target
  static const String C_DROPDOWN__RIGHT = "slds-dropdown--right";
  /// slds-dropdown--small (slds-dropdown): Sets min-width of 15rem/240px
  static const String C_DROPDOWN__SMALL = "slds-dropdown--small";
  /// slds-dropdown--medium (slds-dropdown): Sets min-width of 20rem/320px
  static const String C_DROPDOWN__MEDIUM = "slds-dropdown--medium";
  /// slds-dropdown--large (slds-dropdown): Sets min-width of 25rem/400px
  static const String C_DROPDOWN__LARGE = "slds-dropdown--large";
  /// slds-dropdown__header: Adds padding to area above dropdown menu list
  static const String C_DROPDOWN__HEADER = "slds-dropdown__header";

  /// slds-nubbin--top (slds-popover): Triangle that points upwards which is horizontally centered
  static const String C_NUBBIN__TOP = "slds-nubbin--top";
  /// slds-nubbin--top-left (slds-popover): Triangle that points upwards which is left aligned
  static const String C_NUBBIN__TOP_LEFT = "slds-nubbin--top-left";
  /// slds-nubbin--top-right (slds-popover): Triangle that points upwards which is right aligned
  static const String C_NUBBIN__TOP_RIGHT = "slds-nubbin--top-right";
  /// slds-nubbin--bottom (slds-popover): Triangle that points downwards which is horizontally centered
  static const String C_NUBBIN__BOTTOM = "slds-nubbin--bottom";
  /// slds-nubbin--bottom-left (slds-popover): Triangle that points downwards which is left aligned
  static const String C_NUBBIN__BOTTOM_LEFT = "slds-nubbin--bottom-left";
  /// slds-nubbin--bottom-right (slds-popover): Triangle that points downwards which is right aligned
  static const String C_NUBBIN__BOTTOM_RIGHT = "slds-nubbin--bottom-right";
  /// slds-dropdown--length-5 (ul): Forces overflow scrolling after 5 list items
  static const String C_DROPDOWN__LENGTH_5 = "slds-dropdown--length-5";
  /// slds-dropdown--length-7 (ul): Forces overflow scrolling after 7 list items
  static const String C_DROPDOWN__LENGTH_7 = "slds-dropdown--length-7";
  /// slds-dropdown--length-10 (ul): Forces overflow scrolling after 10 list items
  static const String C_DROPDOWN__LENGTH_10 = "slds-dropdown--length-10";
  /// slds-dropdown--length-with-icon-5 (ul): Forces overflow scrolling after 5 list items - Use if an icon is within the list items
  static const String C_DROPDOWN__LENGTH_WITH_ICON_5 = "slds-dropdown--length-with-icon-5";
  /// slds-dropdown--length-with-icon-7 (ul): Forces overflow scrolling after 7 list items - Use if an icon is within the list items
  static const String C_DROPDOWN__LENGTH_WITH_ICON_7 = "slds-dropdown--length-with-icon-7";
  /// slds-dropdown--length-with-icon-10 (ul): Forces overflow scrolling after 10 list items - Use if an icon is within the list items
  static const String C_DROPDOWN__LENGTH_WITH_ICON_10 = "slds-dropdown--length-with-icon-10";
  /// slds-is-selected (slds-dropdown__item): Applies selected state to dropdown item - Class modifies the visibility of .slds-icon-selected
  static const String C_IS_SELECTED = "slds-is-selected";
  /// slds-icon--selected (svg): Creates icon when a user selects a .slds-dropdown__item
  static const String C_ICON__SELECTED = "slds-icon--selected";
  /// slds-dropdown--nubbin-top (slds-dropdown): Applies triangle indicator pointing at content - Deprecated
  static const String C_DROPDOWN__NUBBIN_TOP = "slds-dropdown--nubbin-top";
  /// slds-has-icon (slds-dropdown__item): Lets dropdown item know how to position icon - Deprecated
  static const String C_HAS_ICON = "slds-has-icon";
  /// slds-has-icon--left (slds-dropdown__item): Position icon in dropdown item to the left - Deprecated
  static const String C_HAS_ICON__LEFT = "slds-has-icon--left";
  /// slds-has-icon--right (slds-dropdown__item): Position icon in dropdown item to the right - Deprecated
  static const String C_HAS_ICON__RIGHT = "slds-has-icon--right";
  /// slds-action-overflow--touch (div): Positions the Action overflow for touch to take up full screen
  static const String C_ACTION_OVERFLOW__TOUCH = "slds-action-overflow--touch";
  /// slds-action-overflow--touch__container (div): Pushes the menu to the bottom of the screen.
  static const String C_ACTION_OVERFLOW__TOUCH__CONTAINER = "slds-action-overflow--touch__container";
  /// slds-action-overflow--touch__content (div): Creates a scrolling area that is pushed down the screen by a third of the viewport height.
  static const String C_ACTION_OVERFLOW__TOUCH__CONTENT = "slds-action-overflow--touch__content";
  /// slds-action-overflow--touch__body (div): Draws the white menu.
  static const String C_ACTION_OVERFLOW__TOUCH__BODY = "slds-action-overflow--touch__body";
  /// slds-action-overflow--touch__footer (div): Creates the footer for the Cancel button.
  static const String C_ACTION_OVERFLOW__TOUCH__FOOTER = "slds-action-overflow--touch__footer";

  /// trigger__click show/hide
  static const String C_IS_OPEN = "slds-is-open";

  //static const String C_DROPDOWN__MENU = "slds-dropdown--menu";
  static const String C_DROPDOWN__ACTIONS = "slds-dropdown--actions";

  static final List<String> C_SIZE_LIST = [C_DROPDOWN__SMALL, C_DROPDOWN__MEDIUM, C_DROPDOWN__LARGE];

  // Marker class
  static const String C_DROPDOWN__LIST = "dropdown__list";

  static const String C_HAS_DIVIDER = "slds-has-divider";
  /// Item
  static const String C_ICON__LEFT = "slds-icon--left";
  static const String C_ICON__RIGHT = "slds-icon--right";

  static List<String> POSITIONS = [C_DROPDOWN__LEFT, C_DROPDOWN__RIGHT];


  static final Logger _log = new Logger("LDropdown");

  /// Dropdown with Button
  final DivElement element = new DivElement()
    ..classes.add(C_DROPDOWN_TRIGGER);

  /// Dropdown Button
  final LButton button;

  /// Dropdown Panel
  LDropdownElement dropdown;
  /// Heading Label
  SpanElement _dropdownHeading;

  /// Id Prefix
  final String idPrefix;
  /// Show Label for selected value
  bool showValueLabel = false;

  /// Callback on Change
  EditorChange editorChange;

  /**
   * Dropdown for [button] (classes are set here)
   * div  .trigger
   * - button
   * - div  .dropdown
   * -- div .header
   * -- ul .dropdown__list
   */
  LDropdown(LButton this.button, String this.idPrefix, {List<String> dropdownClasses}) {
    button.classes.addAll([LButton.C_BUTTON]);
    button.element.setAttribute(Html0.ARIA_HASPOPUP, "true");
    if (button.icon != null)
      button.icon.classes.add(LButton.C_BUTTON__ICON);
    add(button);
    dropdown = new LDropdownElement(new DivElement()
        ..classes.addAll([C_DROPDOWN]),
      name:button.name, idPrefix:idPrefix);
    //
    if (dropdownClasses != null) {
      dropdown.element.classes.addAll(dropdownClasses);
    }
    element.append(dropdown.element);
    button.onClick.listen(onButtonClick);
  } // LDropdown

  /// Settings Icon Button + Dropdown
  LDropdown.settings({String idPrefix, String title: "Settings"})
    : this(new LButton(new ButtonElement(), "settings", null,
        icon: new LIconUtility(LIconUtility.SETTINGS),
        buttonClasses: [LButton.C_BUTTON__ICON_CONTAINER],
        assistiveText: title,
        idPrefix:idPrefix),
    idPrefix);

  /// Icon Button + Dropdown
  LDropdown.icon (String name, LIcon icon, {String idPrefix, String assistiveText})
    : this(new LButton(new ButtonElement(), name, null,
        icon:icon,
        buttonClasses: [LButton.C_BUTTON__ICON_CONTAINER],
        assistiveText:assistiveText,
        idPrefix:idPrefix),
    idPrefix);

  /// Action: More Button + Dropdown
  LDropdown.action({String idPrefix, String title: "More"})
    : this(new LButton(new ButtonElement(), "more", null,
        buttonClasses: [LButton.C_BUTTON__ICON_BORDER_FILLED],
        icon: new LIconUtility(LIconUtility.DOWN),
        assistiveText: title,
        idPrefix:idPrefix),
      idPrefix,
      dropdownClasses: [C_DROPDOWN__RIGHT, C_DROPDOWN__ACTIONS]);

  /**
   * Select Dropdown
   */
  LDropdown.selectIcon({String idPrefix})
    : this(new LButton(new ButtonElement(), "select", null,
        buttonClasses: [LButton.C_BUTTON__ICON_MORE], idPrefix:idPrefix),
      idPrefix,
      dropdownClasses: [C_DROPDOWN__SMALL]);


  /**
   * Search Drop Down
   */
  @deprecated
  LDropdown.search(String this.idPrefix, LButton this.button, InputElement input, {
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
        LForm.C_INPUT_HAS_ICON, LForm.C_INPUT_HAS_ICON__LEFT, LMargin.C_BOTTOM__X_SMALL]);
    header.append(searchDiv);
    LIcon searchIcon = new LIconUtility(LIconUtility.SEARCH, className: "slds-input__icon");
    searchDiv.append(searchIcon.element);
    input
      ..type = "search"
      ..placeholder = placeholder
      ..classes.add(LForm.C_INPUT)
      ..id = LComponent.createId(idPrefix, "-search");
    LabelElement labelEle = new LabelElement()
      ..classes.add(LText.C_ASSISTIVE_TEXT)
      ..htmlFor = input.id
      ..text = placeholder;
    searchDiv.append(labelEle);
    searchDiv.append(input);
    //
    _dropdownHeading = new SpanElement()
      ..classes.add(LText.C_TEXT_HEADING__LABEL)
      ..text = placeholder;
    header.append(_dropdownHeading);
  } // search

  /// button name
  String get name => button.name;

  /// left aligned  |=
  bool get left => dropdown.left;
  void set left (bool newValue) {
    dropdown.left = newValue;
  }
  /// right aligned  =|
  bool get right => dropdown.right;
  void set right (bool newValue) {
    dropdown.right = newValue;
  }

  /// Heading Label
  String get headingLabel => _dropdownHeading == null ? null : _dropdownHeading.text;
  /// Heading Label
  void set headingLabel (String newValue) {
    if (_dropdownHeading == null) {
      DivElement dropdownHeading = new DivElement()
        ..classes.add(C_DROPDOWN__HEADER);
      _dropdownHeading = new SpanElement()
        ..classes.add(LText.C_TEXT_HEADING__LABEL);
      dropdownHeading.append(_dropdownHeading);
      dropdown.element.insertBefore(dropdownHeading, dropdown._dropdownList);
    }
    _dropdownHeading.text = newValue;
  }

  /// Get Value
  String get value => dropdown.value;
  /// Set Value
  void set value (String newValue) {
    selectMode = true;
    dropdown.value = newValue;
  } // value

  /// Set Button - Label/Icon
  void _setValue(ListItem item) {
    if (showValueLabel && item != null && item.label != null && item.label.isNotEmpty) {
      button.label = item.label;
    } else {
      button.label = "";
    }
    // button icon
    if (item != null && item.icon != null) {
      button.icon = item.icon.copy();
    } else {
      button.icon = null;
    }
  } // _setValue

  /// Selection (toggle) mode - update value
  bool get selectMode => dropdown.selectMode;
  void set selectMode (bool newValue) {
    dropdown.selectMode = newValue;
    if (newValue)
      dropdown.editorChange = onEditorChange;
  }

  /// Editor Change callback
  void onEditorChange(String name, String newValue, DEntry ignored, var details) {
    if (details is ListItem) {
      _setValue(details); // as ListItem);
    }
    if (editorChange != null) // if this were an EditorI
      editorChange(name, newValue, ignored, details);
  }

  bool get opneOnClickOnly => element.classes.contains(C_DROPDOWN_TRIGGER__CLICK);
  void set openOnClickOnly (bool newValue) {
    element.classes.toggle(C_DROPDOWN_TRIGGER__CLICK, newValue);
    showDropdown = !newValue;
  }

  /// Button click - toggle
  void onButtonClick(MouseEvent evt) {
    _log.config("onButtonClick ${name}");
    showDropdown = !showDropdown;
  }

  bool get showDropdown => dropdown.show;
  void set showDropdown (bool newValue) {
    dropdown.show = newValue;
    element.classes.toggle(C_IS_OPEN, newValue); // TRIGGER__CLICK
    element.attributes[Html0.ARIA_EXPANED] = newValue.toString();
  }



  @override
  String toString() {
    int length = 0;
    if (dropdown != null)
      length = dropdown.length;
    return "LDropdown[${name}=${value} #${length}]";
  }

} // LDropdown
