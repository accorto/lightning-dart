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
 *
 *    // example: http://lightningdart.com/exampleWorkspace.html
 *    // https://github.com/accorto/lightning-dart/blob/master/web/exampleWorkspace.dart
 *    LightningCtrl.createAppsMain();
 *
 */
class AppsMain
    extends PageSimple {

  static final Logger _log = new Logger("AppsMain");

  /// Current Instance
  static AppsMain instance;
  /// Modal Div
  static DivElement get modals => instance._modalDiv;
  /// Login Required
  static bool loginRequired = false;

  /// Head
  final AppsHeader _header = new AppsHeader();
  /// Menu Full Size
  final AppsMenu _menu = new AppsMenu();
  /// Small Menu
  final DivElement _menuSmall = new DivElement()
    ..classes.addAll([LGrid.C_COL, LGrid.C_GROW_NONE , LVisibility.C_HIDE, "apps-menu-small"]);
  /// Content
  final DivElement _content = new DivElement()
    ..id = "a-content";
  /// Footer
  final CDiv _footer = new CDiv.footer(id:"a-footer");
  /// Modal Div Area
  final DivElement _modalDiv = new DivElement()
    ..id = "a-modals";

  /// Current Apps
  AppsCtrl _currentApps;
  /// Current Page
  AppsPage _currentPage;

  /**
   * Main Page with this [element]
   * optional [classList] (if not defined, container/fluid)
   */
  AppsMain(DivElement element, String id, {List<String> classList})
      : super(element, id, classList:classList) {
    instance = this;

    // Right Side
    DivElement rightSide = new DivElement()
      ..classes.add(LGrid.C_COL)
      ..id = "a-right"
      ..append(_header.element)
      ..append(_content)
      ..append(_footer.element);

    // Small Menu
    DivElement smallBtn = new DivElement()
      ..classes.add("apps-menu-btn");
    _menuSmall.append(smallBtn);
    smallBtn.onClick.listen(onSmallMenuClick);

    // Main grid
    DivElement mainGrid = new DivElement()
      ..classes.add(LGrid.C_GRID)
      ..id = "a-main"
      ..append(_menu.element) // left
      ..append(_menuSmall)
      ..append(rightSide);
    //
    element.classes.remove(LGrid.C_GRID);
    element.append(mainGrid);
    element.append(_modalDiv);
    //
    AppsPage.routeHandler = onRouteEnter;
    LightningCtrl.router.fallbackHandler = onRouteEnter;
  } // AppsMain

  /**
   * Set Application
   */
  void set(AppsCtrl apps) {
    if (_currentPage != null) {
      String error = _currentPage.hidePrevent();
      if (error != null) {
        showError(appsMainHidePrevent(), _currentPage.label, error);
        return;
      }
    }
    // reset
    for (StreamSubscription<MouseEvent> sub in _subscriptions) {
      sub.cancel();
    }
    _currentApps = apps;
    _currentPage = null;
    // set
    _header.set(apps);
    _menu.set(apps);
    for (AppsPage pe in apps.pageList) {
      _subscriptions.add(pe.menuEntry.onClick.listen(onMenuClick));
      pe.active = false;
    }
    loggedIn = ClientEnv.session != null;
    //
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
    bool result = LightningCtrl.router.goto(name);
    if (result == null || result){
      evt.preventDefault(); // internal or "stay there"
    }
  } // onMenuClick

  /// On Route Enter - return false for external or not found
  bool onRouteEnter(RouterPath path) {
    if (_currentPage != null) {
      String error = _currentPage.hidePrevent();
      if (error != null) {
        showError(appsMainHidePrevent(), _currentPage.label, error);
        return null;
      }
    }

    String name = path.toString();
    AppsPage page = null;
    for (AppsPage pe in _currentApps.pageList) {
      if (pe.name == name) {
        page = pe;
      } else {
        pe.active = false;
      }
    }
    if (page == null) {
      _log.info("onRouteEnter NotFound path=${path} name=${name}");
      return false;
    }

    _log.info("onRouteEnter path=${path} name=${name}");
    String error = page.showPrevent();
    if (error != null) {
      showError(appsMainShowPrevent(), page.label, error);
      return null;
    }
    if (page.internal) {
      _setPage(page);
      return true;
    }
    page.showingNow();
    return false; // external
  } // onRouteEnter

  /// Set Page Entry
  void _setPage(AppsPage page) {
    _log.fine("setPageEntry ${page.name}");
    page.active = true;
    _content.children.clear();
    _content.append(page.element);
    page.showingNow();
    _currentPage = page;
  }


  /// append element to main
  void append(Element newValue) {
    _content.append(newValue);
  }
  /// append component to main
  void add(LComponent component) {
    _content.append(component.element);
  }

  /**
   * Logged In
   */
  void set loggedIn (bool newValue) {
    if (loginRequired) {
      // cannot use hide as it does not have !important
      if (newValue && ClientEnv.session != null) {
        for (AppsPage pe in _currentApps.pageList) {
          if (pe.name == Route.NAME_LOGIN)
            pe.menuEntry.style.display = "none"; // hide login
          else
            pe.menuEntry.style.removeProperty("display");
        }
      } else {
        for (AppsPage pe in _currentApps.pageList) {
          if (pe.name == Route.NAME_LOGIN)
            pe.menuEntry.style.removeProperty("display");
          else
            pe.menuEntry.style.display = "none";
          // hide others
        }
      }
    }
  } // loggedIn


  /// Show Header
  void showHeader(bool show) {
    _header.element.classes.toggle(LVisibility.C_HIDE, !show);
  } // showHeader

  /// Show Full Menu Bar
  void showMenuBar(bool show) {
    _menu.element.classes.toggle(LVisibility.C_HIDE, !show);
    _menuSmall.classes.add(LVisibility.C_HIDE);
  }

  /// click on Small Menu Bar
  void onSmallMenuClick(Event evt) {
    showMenuBarSmall(false);
  }

  /// Show Small Menu Bar
  void showMenuBarSmall(bool show) {
    _menuSmall.classes.toggle(LVisibility.C_HIDE, !show);
    _menu.element.classes.toggle(LVisibility.C_HIDE, show);
  }


  /// Show Error
  void showError(String heading, String label, String error) {
    LToast toast = new LToast.error(label:"${heading}: ${label}", text:error);
    toast.showBottomRight(element, autohideSeconds: 15);
  }


  static String appsMainHidePrevent() => Intl.message("Cannot Hide", name: "appsMainHidePrevent");
  static String appsMainShowPrevent() => Intl.message("Cannot Show", name: "appsMainShowPrevent");

} // AppsMain

