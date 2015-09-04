/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Page Main Entry point with
 * - menu bar on left and
 * - header with
 * - content on right
 */
class PageMain extends PageSimple {

  static final Logger _log = new Logger("PageMain");

  /// Search for classes to find main element
  static final List<String> MAIN_CLASSES = [LGrid.C_CONTAINER, LGrid.C_CONTAINER__FLUID,
    LGrid.C_CONTAINER__LARGE, LGrid.C_CONTAINER__MEDIUM, LGrid.C_CONTAINER__SMALL, LGrid.C_GRID];

  /// Menu
  PageMainMenu _menu;
  /// Current Apps
  PageApplication apps;
  /// Head
  PageMainHeader head;
  /// Content
  DivElement main = new DivElement();
  /// Footer
  CDiv foot;

  /**
   * Main Page
   * optional [classList] (if mot defined, container/fluid)
   */
  PageMain(DivElement element, String id, List<String> classList)
      : super(element, id, classList) {

    DivElement mainGrid = new DivElement()
      ..classes.add(LGrid.C_GRID);
    element.append(mainGrid);
    _menu = new PageMainMenu();
    mainGrid.append(_menu.element);

    // Left Side
    DivElement leftSide = new DivElement()
      ..classes.add(LGrid.C_COL);
    mainGrid.append(leftSide);
    head = new PageMainHeader();
    leftSide.append(head.element);
    leftSide.append(main);
    foot = new CDiv.footer();
    leftSide.append(foot.element);
  }

  /**
   * Set Application
   */
  void set(PageApplication apps) {
    for (StreamSubscription<MouseEvent> sub in _subscriptions) {
      sub.cancel();
    }
    this.apps = apps;
    head.set(apps);
    _menu.set(apps);
    for (PageMainEntry pe in apps.entries) {
      _subscriptions.add(pe.menuEntry.onClick.listen(onMenuClick));
      pe.active = false;
    }
    if (apps.entries.isNotEmpty)
      _setPageEntry(apps.entries.first);
  } // set
  List<StreamSubscription<MouseEvent>> _subscriptions = new List<StreamSubscription<MouseEvent>>();

  /// on menu click
  void onMenuClick (Event evt) {
    Element target = evt.target;
    String theId = target.id;
    while (element != null && !theId.contains(PageMainEntry.MENU_SUFFIX)) {
      target = target.parent;
      if (target != null)
        theId = target.id;
    }
    theId = theId.replaceAll(PageMainEntry.MENU_SUFFIX, "");
    PageMainEntry entry = null;
    for (PageMainEntry pe in apps.entries) {
      if (pe.id == theId) {
        entry = pe;
      } else {
        pe.active = false;
      }
    }
    if (entry != null) {
      if (entry.internal) {
        evt.preventDefault();
        _setPageEntry(entry);
      }
    } else {
      _log.fine("onMenuClick - not found: ${theId}");
    }
  } // onMenuClick

  /// Set Page Entry
  void _setPageEntry(PageMainEntry page) {
    _log.fine("setPageEntry ${page.id}");
    page.active = true;
    main.children.clear();
    main.append(page.element);
  }

  /// append element to main
  void append(Element newValue) {
    main.append(newValue);
  }
  /// append component to main
  void add(LComponent component) {
    main.append(component.element);
  }

} // PageMain

