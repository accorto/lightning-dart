/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/**
 * Main Page Menu Item
 * - a menu Item and the container for the content
 */
abstract class AppsPage
    extends LComponent {

  static const String MENU_SUFFIX = "-menu";

  static final Logger _log = new Logger("AppsPage");

  /// Route Handler
  static RouteEventHandler routeHandler;

  // Menu Entry
  AnchorElement menuEntry = new AnchorElement(href: "#")
    ..classes.add(AppsMenu.C_APPS_MENU_ENTRY);

  final String name;
  final String label;
  final String title;
  final LIcon icon;
  final String externalHref;

  /**
   * Page element with Menu
   *
   * the [icon] is best an action or utility icon (no padding) - standard and custom items have a different size
   * if [externalHref] is provided, the user is redirected with the optional [target]
   *
   * the [name] is also the router name
   * if the [path] is not provided, it is [name]
   * (needs to be created after AppsMain!)
   */
  AppsPage(String id, String this.name,
      LIcon this.icon,
      String this.label,
      String this.title,
      {String this.externalHref, String target, String path,
      bool defaultRoute:false,
      bool handleRouteEvents:false}) {
    element.id = id;
    // Menu Entry
    menuEntry.id = id + MENU_SUFFIX;
    menuEntry.attributes[Html0.DATA_VALUE] = name;
    if (externalHref != null && externalHref.isNotEmpty) {
      menuEntry.href = externalHref;
      if (target != null && target.isNotEmpty)
        menuEntry.target = target;
    } else { // internal
      menuEntry.href = "#" + id;
    }
    // Menu Icon
    icon.removeColor();
    icon.classes.addAll([LIcon.C_ICON, LIcon.C_ICON__SMALL]);
    // Menu
    menuEntry.append(icon.element);
    if (label != null && label.isNotEmpty) {
      menuEntry.append(new SpanElement()..text = label);
    }
    // Router
    LightningCtrl.router.addRoute(name:name, path:path==null?name:path, title:title,
      defaultRoute:defaultRoute, enter:handleRouteEvents?onRouteEnter:routeHandler);

    // Setting changes
    AppsSettings.onChange.listen((bool saved){
      rebuildUi();
    });
  } // AppsPage

  /// Active
  bool get active => menuEntry.classes.contains(LButton.C_IS_SELECTED);
  /// Set Active
  void set active (bool newValue) {
    if (newValue) {
      menuEntry.classes.add(LButton.C_IS_SELECTED);
    } else {
      menuEntry.classes.remove(LButton.C_IS_SELECTED);
    }
  }

  /// External Reference
  bool get external => externalHref != null && externalHref.isNotEmpty;
  /// Internal Reference
  bool get internal => externalHref == null || externalHref.isEmpty;


  /// On Route Enter - to be overwritten by subclass when route handled
  bool onRouteEnter(RouterPath path) {
    _log.info("onRouteEnter path=${path}");
    return false;
  }

  /// prevent display (e.g. not logged in) - error or null
  String showPrevent() {
    _log.fine("showPrevent");
    return null;
  }
  /// showing now
  void showingNow() {
    _log.config("showingNow");
  }
  /// prevent navigation (e.g. not saved) - error or null
  String hidePrevent() {
    _log.fine("hidePrevent");
    return null;
  }

  /// rebuild ui (e.g. preferences changed)
  void rebuildUi() {
  }

} // AppsPage
