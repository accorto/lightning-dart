/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * List Styling
 */
class LList {

  /// slds-list--dotted (ul): Creates an unordered list with markers - Our application framework takes away default list styling. This recreates it
  static const String C_LIST__DOTTED = "slds-list--dotted";
  /// slds-list--ordered (ol): Creates an ordered list with decimals - Our application framework removes default list styling. This recreates it
  static const String C_LIST__ORDERED = "slds-list--ordered";
  /// slds-list--vertical (ul): Marks a vertical list
  static const String C_LIST__VERTICAL = "slds-list--vertical";
  /// slds-list--horizontal (ul): Causes list to display horizontally - This lists stacks in a mobile context
  static const String C_LIST__HORIZONTAL = "slds-list--horizontal";
  /// slds-list__item (li): Marks a list item - All lists use this class. Different CSS applies depending on the parent class.
  static const String C_LIST__ITEM = "slds-list__item";
  /// slds-dl--inline (dl): Causes description list to display horizontally with dt followed immediately by the dd. - This lists stacks in a mobile context
  static const String C_DL__INLINE = "slds-dl--inline";
  /// slds-dl--inline__label (dt): Marks a term
  static const String C_DL__INLINE__LABEL = "slds-dl--inline__label";
  /// slds-dl--inline__detail (dd): Marks a description
  static const String C_DL__INLINE__DETAIL = "slds-dl--inline__detail";
  /// slds-dl--horizontal (dl): Causes description list to display horizontally with dt consuming 33% of the space and the dd taking up the rest. - This lists stacks in a mobile context. It can also take different sizing utilities to change the widths (which must always total 100%).
  static const String C_DL__HORIZONTAL = "slds-dl--horizontal";
  /// slds-dl--horizontal__label (dt): Marks a term
  static const String C_DL__HORIZONTAL__LABEL = "slds-dl--horizontal__label";
  /// slds-dl--horizontal__detail (dd): Marks a description
  static const String C_DL__HORIZONTAL__DETAIL = "slds-dl--horizontal__detail";
  /// slds-has-block-links (.slds-list--vertical or .slds-list--vertical): Gives the anchors within the list block styling
  static const String C_HAS_BLOCK_LINKS = "slds-has-block-links";
  /// slds-has-inline-block-links (.slds-list--vertical or .slds-list--vertical): Gives the anchors within the list inline-block styling
  static const String C_HAS_INLINE_BLOCK_LINKS = "slds-has-inline-block-links";
  /// slds-has-block-links--space (.slds-list--vertical or .slds-list--vertical): Gives the anchors within the list block styling with 0.5rem padding
  static const String C_HAS_BLOCK_LINKS__SPACE = "slds-has-block-links--space";
  /// slds-has-inline-block-links--space (.slds-list--vertical or .slds-list--vertical): Gives the anchors within the list inline-block styling with 0.5rem padding
  static const String C_HAS_INLINE_BLOCK_LINKS__SPACE = "slds-has-inline-block-links--space";
  /// slds-has-dividers (.slds-list--horizontal): Adds spacing and dividers between list items - Deprecated - Both vertical and horizontal lists use this class when separators are needed.
  static const String C_HAS_DIVIDERS = "slds-has-dividers";
  /// slds-has-dividers--top (.slds-list--vertical): Adds 1px border divider above list items
  static const String C_HAS_DIVIDERS__TOP = "slds-has-dividers--top";
  /// slds-has-dividers--bottom (.slds-list--vertical): Adds 1px border divider below list items
  static const String C_HAS_DIVIDERS__BOTTOM = "slds-has-dividers--bottom";
  /// slds-has-dividers--top-space (.slds-list--vertical): Adds 1px border divider above list items and 0.5rem padding between list items
  static const String C_HAS_DIVIDERS__TOP_SPACE = "slds-has-dividers--top-space";
  /// slds-has-dividers--bottom-space (.slds-list--vertical): Adds 1px border divider below list items and 0.5rem padding between list items
  static const String C_HAS_DIVIDERS__BOTTOM_SPACE = "slds-has-dividers--bottom-space";
  /// slds-has-dividers--left (.slds-list--horizontal): Adds dot separators to the left of horizontal list items
  static const String C_HAS_DIVIDERS__LEFT = "slds-has-dividers--left";
  /// slds-has-dividers--right (.slds-list--horizontal): Adds dot separators to the right of horizontal list items
  static const String C_HAS_DIVIDERS__RIGHT = "slds-has-dividers--right";
  /// slds-has-cards (.slds-list--vertical): Adds 1px border around list items
  static const String C_HAS_CARDS = "slds-has-cards";
  /// slds-has-cards--space (.slds-list--vertical): Adds 1px border around list items and 0.5rem padding inside list items
  static const String C_HAS_CARDS__SPACE = "slds-has-cards--space";
  /// slds-has-list-interactions (.slds-list__item): Adds hover and selected styles to list items - the selected class .slds-is-selected needs to be applied via Javascript
  static const String C_HAS_LIST_INTERACTIONS = "slds-has-list-interactions";


} // LList
