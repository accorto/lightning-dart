/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Tab Set
 * (maintains set of Element == may be changed to LComponent)
 * (see LPath)
 */
class LTab
    extends LComponent {

  /// slds-tabs--default - Initializes default tabset | Required
  static const String C_TABS__DEFAULT = "slds-tabs--default";
  /// slds-tabs--default__nav - Creates the container for the default tabs | Required
  static const String C_TABS__DEFAULT__NAV = "slds-tabs--default__nav";
  /// slds-tabs--default__item - Styles each list item as a single tab | Required
  static const String C_TABS__DEFAULT__ITEM = "slds-tabs--default__item";
  /// slds-tabs--default__link - Styles each <a> element in the <li> | Required
  static const String C_TABS__DEFAULT__LINK = "slds-tabs--default__link";
  /// slds-tabs--default__content - Styles each tab content wrapper | Required
  static const String C_TABS__DEFAULT__CONTENT = "slds-tabs--default__content";
  /// slds-tabs--scoped - Initializes scoped tabset | Required
  static const String C_TABS__SCOPED = "slds-tabs--scoped";
  /// slds-tabs--scoped__nav - Creates the container for the tabs | Required
  static const String C_TABS__SCOPED__NAV = "slds-tabs--scoped__nav";
  /// slds-tabs--scoped__item - Styles each list item as a single tab | Required
  static const String C_TABS__SCOPED__ITEM = "slds-tabs--scoped__item";
  /// slds-tabs--scoped__link - Styles each <a> element in the <li> | Required
  static const String C_TABS__SCOPED__LINK = "slds-tabs--scoped__link";
  /// slds-tabs--scoped__content - Styles each tab content wrapper | Required
  static const String C_TABS__SCOPED__CONTENT = "slds-tabs--scoped__content";
  /// slds-tabs--path - Initializes default tabset | Required
  static const String C_TABS__PATH = "slds-tabs--path";
  /// slds-tabs--path__nav - Creates the container for the default tabs | Required
  static const String C_TABS__PATH__NAV = "slds-tabs--path__nav";
  /// slds-tabs--path__item - Styles each list item as a single tab | Required
  static const String C_TABS__PATH__ITEM = "slds-tabs--path__item";
  /// slds-tabs--path__link - Styles each <a> element in the <li> | Required
  static const String C_TABS__PATH__LINK = "slds-tabs--path__link";
  /// tabs--path__content - Styles each tab content wrapper | Required
  static const String C_TABS__PATH__CONTENT = "tabs--path__content";
  /// slds-tabs--path__stage - Contains the check mark when the stage is completed | Required
  static const String C_TABS__PATH__STAGE = "slds-tabs--path__stage";
  /// slds-tabs--path__title - Contains the name of the stage | Required
  static const String C_TABS__PATH__TITLE = "slds-tabs--path__title";
  /// slds-is-complete - Creates the completed stage of the sales path
  static const String C_IS_COMPLETE = "slds-is-complete";
  /// slds-is-current - Creates the current stage of the sales path
  static const String C_IS_CURRENT = "slds-is-current";
  /// slds-is-incomplete - Creates the incomplete stage of the sales path
  static const String C_IS_INCOMPLETE = "slds-is-incomplete";
  /// slds-is-active - Creates the active stage of the sales path
  static const String C_IS_ACTIVE = "slds-is-active";
  /// slds-tabs__item--overflow - Styles an overflow tab item
  static const String C_TABS__ITEM__OVERFLOW = "slds-tabs__item--overflow";
  /// slds-dropdown-trigger - Initializes tab item as menu | Required
  static const String C_DROPDOWN_TRIGGER = "slds-dropdown-trigger";
  /// slds-dropdown--overflow - Applies size settings on tab item menu | Required
  static const String C_DROPDOWN__OVERFLOW = "slds-dropdown--overflow";
  /// slds-active - Applies the active state to a tab list item | Required
  static const String C_ACTIVE = "slds-active";
  /// slds-show - Shows the tab panel | Required
  static const String C_SHOW = "slds-show";
  /// slds-hide - Hide the tab panel | Required
  static const String C_HIDE = "slds-hide";


  static final Logger _log = new Logger("LTab");

  /// Tab element
  final DivElement element = new DivElement();
  /// Tab List
  final UListElement _tablist = new UListElement()
    ..attributes[Html0.ROLE] = Html0.ROLE_TABLIST;

  final bool scoped;

  /// List of tabs
  final List<LTabContent> _contentList = new List<LTabContent>();

  /**
   * Tab
   */
  LTab({String idPrefix, bool this.scoped: false}) {
    element.classes.add(scoped ? C_TABS__SCOPED : C_TABS__DEFAULT);
    _tablist.classes.add(scoped ? C_TABS__SCOPED__NAV : C_TABS__DEFAULT__NAV);
    element.append(_tablist);
    element.id = idPrefix == null || idPrefix.isEmpty ? LComponent.createId("tab", null) : idPrefix;
  } // LTab

  /// Set id (prefix)
  void set id (String newValue) {
    element.id = newValue;
  }

  /**
   * Add Tab
   */
  void addTabContent (LTabContent tab) {
    tab._init(_tablist.children.length, scoped);
    tab._a.onClick.listen(onTabClick);

    _contentList.add(tab);
    element.append(tab.element);
    _tablist.append(tab._li);

    // Name + id
    if (tab.name != null && tab.name.isNotEmpty) {
      tab._li.attributes[Html0.DATA_NAME] = tab.name;
      tab._a.attributes[Html0.DATA_NAME] = tab.name;
      tab.element.attributes[Html0.DATA_NAME] = tab.name;
    }
    tab._a.id = LComponent.createId(id, tab.name);
    tab.element.id = tab._a.id + "-content";
    tab._a.attributes[Html0.ARIA_CONTROLS] = tab.element.id;

    selectTabByPos(currentPos, false);
  } // addTabContent

  /**
   * Add Tab - returns content element
   */
  Element addTab (String label, {String name, String href, Element content}) {
    LTabContent tc = new LTabContent(name, label)
        ..href = href;
    if (content != null)
      tc.element = content;
    addTabContent(tc);
    return tc.element;
  } // addTab

  /// Current position
  int get currentPos => _currentPos;
  int _currentPos = 0;

  /// Current Content
  Element get currentContent => _currentContent;
  Element _currentContent;

  /**
   * Select Tab By Position [pos] 0..x returns false if not found
   */
  bool selectTabByPos(int pos, bool logIt) {
    if (pos < 0 || pos >= _contentList.length)
      return false;
    //
    if (logIt)
      _log.fine("selectTabByPos #${pos} - tablist=${_tablist.children.length}, elements=${element.children.length}");
    int i = 0;
    for (LTabContent tc in _contentList) {
      if (pos == i) {
        tc.active = true;
        _currentContent = tc.element;
        tc.showingNow();
      } else {
        tc.active = false;
      }
      i++;
    }
    /*
    for (int i = 0; i < _tablist.children.length; i++) {
      LIElement li = _tablist.children[i];
      AnchorElement a = li.children.first;
      Element content = element.children[i+1]; // 0=_tabList
      if (pos == i) {
        li.classes.add(LVisibility.C_ACTIVE);
        a.tabIndex = 0;
        a.attributes[Html0.ARIA_SELECTED] = "true";
        content.classes.remove(LVisibility.C_HIDE);
        content.classes.add(LVisibility.C_SHOW);
        _currentContent = content;
      } else {
        li.classes.remove(LVisibility.C_ACTIVE);
        a.tabIndex = -1;
        a.attributes[Html0.ARIA_SELECTED] = "false";
        content.classes.remove(LVisibility.C_SHOW);
        content.classes.add(LVisibility.C_HIDE);
      }
    } */
    _currentPos = pos;
    if (_sc != null) {
      _sc.add(this); // notify tabChanged
    }
    return true;
  } // selectByPos

  /**
   * Select Tab By name - returns false if not found
   */
  bool selectTabByName(String name) {
    if (name == null || name.isEmpty)
      return false;

    for (int i = 0; i < _tablist.children.length; i++) {
      LIElement li = _tablist.children[i];
      String ref = li.attributes[Html0.DATA_NAME];
      if (ref == name) {
        return selectTabByPos(i, true);
      }
    }
    return false;
  } // selectByName

  /// click on anchor - switch to tab
  void onTabClick(MouseEvent evt) {
    if (evt.target is AnchorElement) {
      AnchorElement a = evt.target;
      String href = a.href;
      bool found = false;
      String index = a.attributes[Html0.DATA_VALUE];
      if (index != null && index.isNotEmpty) {
        int ii = int.parse(index, onError: (source){return -1;});
        found = selectTabByPos(ii, true);
      }
      if (!found) {
        String name = a.attributes[Html0.DATA_NAME];
        found = selectTabByName(name);
      }
      if (found && href.endsWith("#")) {
        evt.stopPropagation();
        evt.preventDefault();
      }
    }
  } // onTabClick


  /// Tab Changed - use [currentContent] or [currentPos]
  Stream<LTab> get onTabChanged {
    if (_sc == null) {
      _sc = new StreamController();
    }
    return _sc.stream;
  }
  StreamController _sc;

} // LTab


/**
 * Tab Content
 */
class LTabContent {

  final String label;
  final String name;

  /// Tab Content
  Element element = new DivElement();

  /// internal Tab Header
  final LIElement _li = new LIElement()
    ..classes.add(LText.C_TEXT_HEADING__LABEL)
    ..attributes[Html0.ROLE] = Html0.ROLE_PRESENTATION;

  /// internal Tab Header Link
  final AnchorElement _a = new AnchorElement()
    ..href = "#"
    ..attributes[Html0.ROLE] = Html0.ROLE_TAB
    ..tabIndex = -1
    ..attributes[Html0.ARIA_SELECTED] = "false";

  /**
   * Tab Content
   */
  LTabContent(String this.name, String this.label) {
    _li.title = label;
    _a.text = label;
    _li.append(_a);
  }

  /// Initialize
  void _init(int length, bool scoped) {
    element.attributes[Html0.ROLE] = Html0.ROLE_TABPANEL;
    element.classes.add(scoped ? LTab.C_TABS__SCOPED__CONTENT : LTab.C_TABS__DEFAULT__CONTENT);
    _li.classes.add(scoped ? LTab.C_TABS__SCOPED__ITEM : LTab.C_TABS__DEFAULT__ITEM);
    _a.classes.add(scoped ? LTab.C_TABS__SCOPED__LINK : LTab.C_TABS__DEFAULT__LINK);
    _a.attributes[Html0.DATA_VALUE] = length.toString();
  } // init

  /// Set href
  void set href (String newValue) {
    if (newValue == null || newValue.isEmpty)
      _a.href = "#";
    else
      _a.href = newValue;
  }

  /// active
  bool get active => _li.classes.contains(LVisibility.C_ACTIVE);
  /// active
  void set active (bool newValue) {
    if (newValue) {
      _li.classes.add(LVisibility.C_ACTIVE);
      _a.tabIndex = 0;
      _a.attributes[Html0.ARIA_SELECTED] = "true";
      element.classes.remove(LVisibility.C_HIDE);
      element.classes.add(LVisibility.C_SHOW);
    } else {
      _li.classes.remove(LVisibility.C_ACTIVE);
      _a.tabIndex = -1;
      _a.attributes[Html0.ARIA_SELECTED] = "false";
      element.classes.remove(LVisibility.C_SHOW);
      element.classes.add(LVisibility.C_HIDE);
    }
  } // active

  /// Showing Tab
  void showingNow() {
  }

} // LTabI
