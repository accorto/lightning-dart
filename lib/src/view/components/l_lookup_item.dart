/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Lookup Item
 * - li > a|span
 */
class LLookupItem extends ListItem {

  /**
   * Lookup Option
   */
  LLookupItem(DOption option, {LIcon leftIcon, LIcon rightIcon})
    : super(option, leftIcon:leftIcon, rightIcon:rightIcon) {

    element
      ..classes.add(LLookup.C_LOOKUP__ITEM)
      ..attributes[Html0.ROLE] = Html0.ROLE_PRESENTATION;
    a
      ..attributes[Html0.ROLE] = Html0.ROLE_OPTION;
  } // LLookupItem


  /// Lookup Item from List
  LLookupItem.from(ListItem item)
    : this(item.option, leftIcon:item.leftIcon, rightIcon:item.rightIcon);

  /// Lookup Item from Option
  LLookupItem.fromOption(OptionElement option)
    : this(OptionUtil.optionFromElement(option));

  /// Lookup Item from SelectOption
  LLookupItem.fromSelectOption(SelectOption option)
    : this(option.option);


  /// On Click
  ElementStream<MouseEvent> get onClick => a.onClick;

} // LLookupItem
