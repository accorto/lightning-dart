/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Dropdown Item
 */
class LDropdownItem
    extends ListItem {

  /// Dropdown
  static LDropdownItem create({String value, String label, LIcon icon}) {
    DOption option = OptionUtil.option(value, label);
    return new LDropdownItem(option, rightIcon:icon);
  }

  static LIcon createSelect() {
    return new LIconUtility(
        LIconUtility.CHECK, size: LIcon.C_ICON__X_SMALL,
        color: LIcon.C_ICON_TEXT_DEFAULT,
        addlCss: [LIcon.C_ICON__SELECTED, LMargin.C_RIGHT__SMALL]);
  }

  /**
   * Dropdown item (leftIcon is used for selection)
   */
  LDropdownItem(DOption option, {LIcon rightIcon})
    : super(option, leftIcon:createSelect(), rightIcon:rightIcon) {

    element
      ..classes.add(LDropdown.C_DROPDOWN__ITEM)
      ..tabIndex = -1
      ..attributes[Html0.ROLE] = Html0.ROLE_MENUITEM + " " + Html0.ROLE_OPTION;
    a
      ..classes.add(LText.C_TRUNCATE)
      ..tabIndex = -1;

    if (_rightIcon != null) {
      _rightIcon.size = LIcon.C_ICON__X_SMALL;
      _rightIcon.classes.addAll([LIcon.C_ICON_TEXT_DEFAULT,
        LMargin.C_LEFT__SMALL, LGrid.C_SHRINK_NONE]);
    }
  } // LDropdownItem

  /// Dropdown Item from List
  LDropdownItem.from(ListItem item)
    : this(item.option, rightIcon:item.rightIcon);

  /// create drop-down from button - with left icon!
  LDropdownItem.fromButton(LButton button)
    : this(button.asDOption(),
      rightIcon:button.icon == null ? null : button.icon.copy());

  /// Lookup Item from Option
  LDropdownItem.fromOption(OptionElement option)
    : this(OptionUtil.optionFromElement(option));

  /// Lookup Item from SelectOption
  LDropdownItem.fromSelectOption(SelectOption option)
    : this(option.option);

  /// On Click
  ElementStream<MouseEvent> get onClick => a.onClick;

  /// Divider
  bool get divider => element.classes.contains(LDropdown.C_HAS_DIVIDER);
  void set divider (bool newValue) {
    if (newValue)
      element.classes.add(LDropdown.C_HAS_DIVIDER);
    else
      element.classes.remove(LDropdown.C_HAS_DIVIDER);
  }

  /// Right Icon (left icon used for select)
  LIcon get icon => _rightIcon;


  bool get hasIconRight => _rightIcon != null;
  void set hasIconRight (bool newValue) { // NOP
  }

  bool get hasIconLeft => true;
  void set hasIconLeft (bool newValue) { // NOP
  }


  String toString() => "LDropdown[${option.value}]";

} // LDropdownItem
