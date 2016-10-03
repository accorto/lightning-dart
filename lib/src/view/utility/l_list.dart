/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
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
  /// slds-list--vertical (Any element): Marks a vertical list
  static const String C_LIST__VERTICAL = "slds-list--vertical";
  /// slds-list--horizontal (Any element): Causes items of a list to display horizontally - This lists stacks in a mobile context. The output differs on the name-value variant, name-value display horizontally but stacks after each name-value
  static const String C_LIST__HORIZONTAL = "slds-list--horizontal";
  /// slds-list--inline (Any element): Causes items of a list to display horizontally
  static const String C_LIST__INLINE = "slds-list--inline";

  /// slds-item (Any element): Marks a list item - All lists use this class. Different CSS applies depending on the parent class.
  static const String C_ITEM = "slds-item";

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

  /// slds-item--label (div): Label of the name-value pair variant. Layout is modified by its parent class.
  static const String C_ITEM__LABEL = "slds-item--label";
  /// slds-item--detail (div): Detail of the name-value pair variant. Layout is modified by its parent class.
  static const String C_ITEM__DETAIL = "slds-item--detail";
  /// slds-has-divider--top (Any element): Adds 1px border divider above an HTML element
  ///
  static const String C_HAS_DIVIDER__TOP = "slds-has-divider--top";
  /// slds-has-divider--top-space (Any element): Adds 1px border divider above an HTML element with a 0.5rem separation between the item above it
  static const String C_HAS_DIVIDER__TOP_SPACE = "slds-has-divider--top-space";
  /// slds-has-divider--bottom (Any element): Adds 1px border divider below an HTML element
  static const String C_HAS_DIVIDER__BOTTOM = "slds-has-divider--bottom";
  /// slds-has-divider--bottom-space (Any element): Adds 1px border divider below an HTML element with a 0.5rem separation between the item below it
  static const String C_HAS_DIVIDER__BOTTOM_SPACE = "slds-has-divider--bottom-space";
  /// slds-has-divider--right (Any element): Adds dot separator to the right of an HTML element
  static const String C_HAS_DIVIDER__RIGHT = "slds-has-divider--right";
  /// slds-has-divider--left (Any element): Adds dot separator to the left of an HTML element
  static const String C_HAS_DIVIDER__LEFT = "slds-has-divider--left";
  /// slds-has-block-links (Any element): Gives the anchors within the list block styling
  static const String C_HAS_BLOCK_LINKS = "slds-has-block-links";
  /// slds-has-inline-block-links (Any element): Gives the anchors within the list inline-block styling
  static const String C_HAS_INLINE_BLOCK_LINKS = "slds-has-inline-block-links";
  /// slds-has-block-links--space (Any element): Gives the anchors within the list block styling with 0.5rem padding
  static const String C_HAS_BLOCK_LINKS__SPACE = "slds-has-block-links--space";
  /// slds-has-inline-block-links--space (Any element): Gives the anchors within the list inline-block styling with 0.5rem padding
  static const String C_HAS_INLINE_BLOCK_LINKS__SPACE = "slds-has-inline-block-links--space";
  /// slds-has-dividers--top (Any element, children elements require .slds-item): Adds 1px border divider above list items
  static const String C_HAS_DIVIDERS__TOP = "slds-has-dividers--top";
  /// slds-has-dividers--bottom (Any element, children elements require .slds-item): Adds 1px border divider below list items
  static const String C_HAS_DIVIDERS__BOTTOM = "slds-has-dividers--bottom";
  /// slds-has-dividers--top-space (Any element, children elements require .slds-item): Adds 1px border divider above list items and 0.5rem padding between items
  static const String C_HAS_DIVIDERS__TOP_SPACE = "slds-has-dividers--top-space";
  /// slds-has-dividers--bottom-space (Any element, children elements require .slds-item): Adds 1px border divider below list items and 0.5rem padding between items
  static const String C_HAS_DIVIDERS__BOTTOM_SPACE = "slds-has-dividers--bottom-space";
  /// slds-has-dividers--left (slds-list--horizontal, children elements require .slds-item): Adds dot separators to the left of horizontal list items
  static const String C_HAS_DIVIDERS__LEFT = "slds-has-dividers--left";
  /// slds-has-dividers--right (slds-list--horizontal, children elements require .slds-item): Adds dot separators to the right of horizontal list items
  static const String C_HAS_DIVIDERS__RIGHT = "slds-has-dividers--right";
  /// slds-has-list-interactions (slds-item): Adds hover and selected styles to list items - the selected class .slds-is-selected needs to be applied via JavaScript
  static const String C_HAS_LIST_INTERACTIONS = "slds-has-list-interactions";


  /// undocumented
  static const String U_HAS_DIVIDERS__AROUND = "slds-has-dividers--around";
  static const String U_HAS_DIVIDERS__AROUND_SPACE = "slds-has-dividers--around-space";

  /// UList Element
  Element element = new UListElement();

  /// Vertical List
  LList() {
  }
  /// Vertical List dotted
  LList.dotted() {
    element.classes.add(C_LIST__DOTTED);
  }
  /// Vertical ordered list
  LList.ordered() {
    element = new OListElement();
    element.classes.add(C_LIST__ORDERED);
  }
  /// Horizontal dotted
  LList.horizontal() {
    element.classes.add(C_LIST__HORIZONTAL);
  }

  void setDividersAround({bool space:true}) {
    element.classes.add(space ? U_HAS_DIVIDERS__AROUND_SPACE: U_HAS_DIVIDERS__AROUND);
  }
  void setBlockLinks({bool space:true}) {
    element.classes.add(space ? C_HAS_BLOCK_LINKS__SPACE: C_HAS_BLOCK_LINKS);
  }
  void setInlineBlockLinks({bool space:true}) {
    element.classes.add(space ? C_HAS_INLINE_BLOCK_LINKS__SPACE: C_HAS_INLINE_BLOCK_LINKS);
  }


  /// add nested List
  void addList(LList nested) {
    //nested.element.classes.add(C_IS_NESTED);
    element.append(nested.element);
  }

  // li with text
  LIElement addText(String text) {
    LIElement li = new LIElement();
      if (text != null && text.isNotEmpty)
        li.text = text;
    element.append(li);
    return li;
  }

  // li with text
  LIElement addElement(Element ele) {
    LIElement li = new LIElement();
    if (ele != null)
      li.append(ele);
    element.append(li);
    return li;
  }

  AnchorElement addLink(final String href, {String text}) {
    AnchorElement a = new AnchorElement(href:href);
    if (text != null)
      a.text = text;
    addElement(a);
    return a;
  }


} // LList
