/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Left Side Menu
 */
class PageMainMenu extends LComponent {

  static const String C_MENU_MAIN = "menu-main";
  static const String C_MENU_MAIN_SHOW = "menu-main-show";
  static const String C_MENU_MAIN_ENTRY = "menu-main-entry";

  static const String _C_EXPANDED = "expaned";

  final Element element = new Element.nav()
    ..classes.addAll([LGrid.C_COL, LTheme.C_THEME__ALT_INVERSE, C_MENU_MAIN]);

  AnchorElement _menuShow = new AnchorElement(href: "#")
    ..classes.add(PageMainMenu.C_MENU_MAIN_SHOW);


  /// Left Side Menu
  PageMainMenu() {
    LIcon showIcon = new LIconUtility(LIconUtility.ROWS, size: LIcon.C_ICON__SMALL);
    _menuShow.append(showIcon.element);
    _menuShow.onClick.listen((MouseEvent evt){
      expanded = !expanded; // toggle
    });
    element.append(_menuShow);
  }

  /**
   * Set Application
   */
  void set(PageApplication apps) {
    element.children.clear();
    _menuShow.title = apps.label;
    element.append(_menuShow);
    // entries
    for (PageMainEntry pe in apps.entries) {
      element.append(pe.menuEntry);
    }
  } // set

  /**
   * Menu Expanded
   */
  bool get expanded => element.classes.contains(_C_EXPANDED);
  void set expanded (bool newValue) {
    if (newValue) {
      element.classes.add(_C_EXPANDED);
    } else {
      element.classes.remove(_C_EXPANDED);
    }
  }

} // PageMainMenu

