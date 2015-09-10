/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/**
 * Page Main Entry point with
 * - menu bar on left and
 * - header with
 * - content on right
 */
class AppsMain extends PageSimple {

  static final Logger _log = new Logger("AppsMain");

  /// Head
  AppsHeader header;
  /// Menu
  AppsMenu _menu;
  /// Content
  DivElement content = new DivElement();
  /// Footer
  CDiv footer;

  /// Current Apps
  AppsCtrl apps;

  /**
   * Main Page with this [element]
   * optional [classList] (if not defined, container/fluid)
   */
  AppsMain(DivElement element, String id, {List<String> classList})
      : super(element, id, classList:classList) {

    DivElement mainGrid = new DivElement()
      ..classes.add(LGrid.C_GRID);
    element.append(mainGrid);
    _menu = new AppsMenu();
    mainGrid.append(_menu.element);

    // Left Side
    DivElement leftSide = new DivElement()
      ..classes.add(LGrid.C_COL);
    mainGrid.append(leftSide);
    header = new AppsHeader();
    leftSide.append(header.element);
    leftSide.append(content);
    footer = new CDiv.footer();
    leftSide.append(footer.element);
    //
    AppsPage.routeHandler = onRouteEnter;
    LightningCtrl.router.fallbackHandler = onRouteEnter;
  } // AppsMain

  /**
   * Set Application
   */
  void set(AppsCtrl apps) {
    for (StreamSubscription<MouseEvent> sub in _subscriptions) {
      sub.cancel();
    }
    this.apps = apps;
    header.set(apps);
    _menu.set(apps);
    for (AppsPage pe in apps.pages) {
      _subscriptions.add(pe.menuEntry.onClick.listen(onMenuClick));
      pe.active = false;
    }
    //if (apps.pages.isNotEmpty)
    //  _setPageEntry(apps.pages.first);
    LightningCtrl.router.start();
    LightningCtrl.router.route(null);

  } // set
  List<StreamSubscription<MouseEvent>> _subscriptions = new List<StreamSubscription<MouseEvent>>();

  /// on menu click
  void onMenuClick (Event evt) {
    Element target = evt.target;
    String theId = target.id;
    String name = null;
    while (element != null && !theId.contains(AppsPage.MENU_SUFFIX)) {
      target = target.parent;
      if (target != null) {
        theId = target.id;
        name = target.attributes[Html0.DATA_VALUE];
      }
    }
    if (name == null)
      name = theId.replaceAll(AppsPage.MENU_SUFFIX, "");
    if (LightningCtrl.router.goto(name)) {
      evt.preventDefault(); // internal
    }
/*
    AppsPage page = findPage(theId, name);
    if (page != null) {
      if (page.internal) {
        evt.preventDefault();
        _setPage(page);
      }
    } else {
      _log.fine("onMenuClick - not found: ${theId}");
    } */
  } // onMenuClick

  /// Set Page Entry
  void _setPage(AppsPage page) {
    _log.fine("setPageEntry ${page.name}");
    page.active = true;
    content.children.clear();
    content.append(page.element);
  }

  /// On Route Enter
  bool onRouteEnter(RouterPath path) {
    String name = path.toString();
    AppsPage page = null;
    for (AppsPage pe in apps.pages) {
      if (pe.name == name) {
        page = pe;
      } else {
        pe.active = false;
      }
    }
    if (page == null) {
      _log.info("onRouteEnter NotFound path=${path} name=${name}");
      return false;
    } else {
      _log.info("onRouteEnter path=${path} name=${name}");
      if (page.internal) {
        _setPage(page);
        return true;
      } else {
        return false; // external
      }
    }
  } // onRouteEnter

  /// append element to main
  void append(Element newValue) {
    content.append(newValue);
  }
  /// append component to main
  void add(LComponent component) {
    content.append(component.element);
  }

} // AppsMain

