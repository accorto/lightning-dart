/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Navigation
 */
class LNavigation {

  /// slds-navigation-list--vertical (div): Initializes Vertical Navigation
  static const String C_NAVIGATION_LIST__VERTICAL = "slds-navigation-list--vertical";
  /// slds-navigation-list--vertical__action (a): Hyperlink inside navigation's list items
  static const String C_NAVIGATION_LIST__VERTICAL__ACTION = "slds-navigation-list--vertical__action";

  /// Navigation Element
  final Element element = new Element.nav()
    ..classes.addAll([LGrid.C_GRID, LGrid.C_GRID__VERTICAL]);

  /// create/add navigation list with optional header
  LNavigationList addList({String header}) {
    if (header != null && header.isNotEmpty) {
      HeadingElement h2 = new HeadingElement.h2()
          ..classes.addAll([LText.C_TEXT_TITLE__CAPS, LPadding.C_AROUND__SMALL]) // TODO check
          ..text = header;
      element.append(h2);
    }
    LNavigationList navList = new LNavigationList();
    element.append(navList.element);
    return navList;
  }

} // LNavigation



/**
 * Navigation (Item) List
 */
class LNavigationList {

  final UListElement element = new UListElement()
      ..classes.addAll([LNavigation.C_NAVIGATION_LIST__VERTICAL, LList.C_HAS_BLOCK_LINKS__SPACE]);

  LNavigationList() {

  } // LNavigationList

  LNavigationItem addItem(final String label, {String title}) {
    LNavigationItem item = new LNavigationItem(label, title: title);
    element.append(item.element);
    return item;
  }

} // LNavigationList



/**
 * Navigation Item
 */
class LNavigationItem {

  final LIElement element = new LIElement();

  final AnchorElement a = new AnchorElement(href: "#")
    ..classes.addAll([LNavigation.C_NAVIGATION_LIST__VERTICAL__ACTION, LInteraction.C_TEXT_LINK__RESET]);

  /// Navigation Item
  LNavigationItem(final String label, {String title}) {
    element.append(a);
    a.text = label;
    if (title != null)
      a.title = title;
  } // LNavigationItem

} // LNavigationItem
