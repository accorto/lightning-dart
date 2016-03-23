/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;


/**
 * Left Side Menu
 */
class AppsMenu
    extends LComponent {

  static const String C_APPS_MENU = "apps-menu";
  /// Show = Button
  static const String C_APPS_MENU_SHOW = "apps-menu-show";
  /// Normal menu entry button
  static const String C_APPS_MENU_ENTRY = "apps-menu-entry";

  /// Menu expanded indicator
  static const String _C_EXPANDED = "expaned";

  /// Menu Element
  final Element element = new Element.nav()
    ..classes.addAll([LGrid.C_COL, LGrid.C_SHRINK_NONE, LTheme.C_THEME__ALT_INVERSE, C_APPS_MENU])
    ..style.zIndex = "1" // LTable scrolling header
    ..id = "a-menu";

  /// Show Button
  final AnchorElement _menuShow = new AnchorElement(href: "#")
    ..classes.add(AppsMenu.C_APPS_MENU_SHOW)
    ..id = "a-menu-show";
  /// Help Link
  AnchorElement _menuHelp;
  String _label = "";

  /// Left Side Menu
  AppsMenu() {
    LIcon showIcon = new LIconUtility(LIconUtility.ROWS, size: LIcon.C_ICON__SMALL);
    _menuShow.append(showIcon.element);
    _menuShow.onClick.listen((MouseEvent evt){
      expanded = !expanded; // toggle
    });
    element.append(_menuShow);
  } // AppsMenu

  /**
   * Set Application
   */
  void set(AppsCtrl apps) {
    element.children.clear();
    _label = apps.label;
    setTitle();
    element.append(_menuShow);
    // entries
    for (AppsPage pe in apps.pageList) {
      element.append(pe.menuEntry);
    }
    // help
    if (_menuHelp == null && apps.helpUrl != null && apps.helpUrl.isNotEmpty) {
      _menuHelp = new AnchorElement(href: apps.helpUrl)
        ..classes.add(AppsMenu.C_APPS_MENU_ENTRY)
        ..id = "a-menu-help"
        ..target = "help"
        ..title = appsMenuHelp();
      //..style.cursor = "help";

      LIcon helpIcon = new LIconUtility(LIconUtility.HELP, size: LIcon.C_ICON__SMALL);
      _menuHelp.append(helpIcon.element);
      _menuHelp.append(new SpanElement()..text = appsMenuHelp());
    }
    if (_menuHelp != null)
      element.append(_menuHelp);
  } // set

  /// Set Title
  void setTitle() {
    _menuShow.title = _label;
    if (ClientEnv.session != null) {
      _menuShow.title = "${_label} - ${ClientEnv.session.userName} - ${ClientEnv.session.tenantName}";
    }
  }

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

  static String appsMenuHelp() => Intl.message("Help", name: "appsMenuHelp");

} // AppsMenu

