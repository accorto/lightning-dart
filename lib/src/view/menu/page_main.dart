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
class PageMain extends LComponent {

  static final Logger _log = new Logger("PageMain");

  /// Search for classes to find main element
  static final List<String> MAIN_CLASSES = [LGrid.C_CONTAINER, LGrid.C_CONTAINER__FLUID,
    LGrid.C_CONTAINER__LARGE, LGrid.C_CONTAINER__MEDIUM, LGrid.C_CONTAINER__SMALL, LGrid.C_GRID];

  /**
   * Create Page (slds-grid)
   * [id] id of the application
   * [clearContainer] clears all content from container
   * optional [classList] (if mot defined, container/fluid)
   */
  static PageMain create({String id: "wrap",
      bool clearContainer: true, List<String> classList}) {
    // Top Level Main
    Element e = querySelector("#${id}");
    if (e == null) {
      for (String cls in MAIN_CLASSES) {
        e = querySelector(".${cls}");
        if (e != null) {
          break;
        }
      }
    }
    PageMain main = null;
    if (e == null) {
      Element body = document.body; // querySelector("body");
      main = new PageMain(new DivElement(), id, classList);
      body.append(main.element);
    } else {
      if (clearContainer) {
        e.children.clear();
      }
      main = new PageMain(e, id, classList);
    }
    return main;
  } // init

  /// Main Element
  final DivElement element;
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
  PageMain(DivElement this.element, String id, List<String> classList) {
    element.classes.clear();
    if (classList != null && classList.isNotEmpty) {
      element.classes.addAll(classList);
    } else {
      element.classes.addAll([LGrid.C_CONTAINER, LGrid.C_CONTAINER__FLUID]);
    }
    element.id = id;
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
    for (PageEntry pe in apps.entries) {
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
    while (element != null && !theId.contains(PageEntry.MENU_SUFFIX)) {
      target = target.parent;
      if (target != null)
        theId = target.id;
    }
    theId = theId.replaceAll(PageEntry.MENU_SUFFIX, "");
    PageEntry entry = null;
    for (PageEntry pe in apps.entries) {
      if (pe.id == theId) {
        evt.preventDefault();
        entry = pe;
      } else {
        pe.active = false;
      }
    }
    if (entry != null) {
      _setPageEntry(entry);
    } else {
      _log.fine("onMenuClick - not found: ${theId}");
    }
  } // onMenuClick

  /// Set Page Entry
  void _setPageEntry(PageEntry page) {
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

/**
 * Left Side Menu
 */
class PageMainMenu extends LComponent {

  static const String C_MENU_MAIN = "menu-main";
  static const String C_MENU_MAIN_SHOW = "menu-main-show";
  static const String C_MENU_MAIN_ENTRY = "menu-main-entry";

  final Element element = new Element.nav()
    ..classes.addAll([LGrid.C_COL, LTheme.C_THEME__ALT_INVERSE, C_MENU_MAIN]);

  AnchorElement menuShow = new AnchorElement(href: "#")
    ..classes.add(PageMainMenu.C_MENU_MAIN_SHOW);


  /// Left Side Menu
  PageMainMenu() {
    LIcon showIcon = new LIconUtility(LIconUtility.ROWS, size: LIcon.C_ICON__SMALL);
    menuShow.append(showIcon.element);
    element.append(menuShow);
  }


  /**
   * Set Application
   */
  void set(PageApplication apps) {
    element.children.clear();
    element.append(menuShow);
    for (PageEntry pe in apps.entries) {
      element.append(pe.menuEntry);
    }
  } // set




} // PageMainMenu


/**
 * Page Main Header - Logo (for the moment)
 */
class PageMainHeader extends LComponent {

  final Element element = new Element.header()
    ..classes.add(LMargin.C_AROUND__SMALL);

  /**
   * Set Application
   */
  void set(PageApplication apps) {
    element.children.clear();
    if (apps.imageSrc != null) {
      LImage img = new LImage.srcMedium(apps.imageSrc, apps.label, circle: false);
      element.append(img.element);
    }
  } // set

} // PageMainHeader
