/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Tab Set
 * (maintains set of Element == may be changed to LComponent)
 */
class LTab extends LComponent {

  /// slds-tabs--default - Initializes default tabset | Required
  static const String C_TABS__DEFAULT = "slds-tabs--default";
  /// slds-tabs--scoped - Initializes scoped tabset | Required
  static const String C_TABS__SCOPED = "slds-tabs--scoped";
  /// slds-tabs--default__nav - Initializes default tablist | Required
  static const String C_TABS__DEFAULT__NAV = "slds-tabs--default__nav";
  /// slds-tabs--scoped__nav - Initializes scoped tablist | Required
  static const String C_TABS__SCOPED__NAV = "slds-tabs--scoped__nav";
  /// slds-tabs__item - Styles tab items in tablist | Required
  static const String C_TABS__ITEM = "slds-tabs__item";
  /// slds-tabs__content - Styles tab content wrapper in tabset | Required
  static const String C_TABS__CONTENT = "slds-tabs__content";
  /// is-active - Applies the active state to a tab list item | Required
  static const String C_IS_ACTIVE = "is-active";
  /// slds-text-heading--label - Applies text styling to a tab list item | Required
  static const String C_TEXT_HEADING__LABEL = "slds-text-heading--label";

  /// slds-show - Shows the tab panel | Required
  static const String C_SHOW = "slds-show";
  /// slds-hide - Hide the tab panel | Required
  static const String C_HIDE = "slds-hide";


  /// Tab element
  final DivElement element = new DivElement();
  /// Tab List
  final UListElement _tablist = new UListElement()
    ..attributes[Html0.ROLE] = Html0.ROLE_TABLIST;

  final String idPrefix;
  final bool scoped;

  /**
   * Tab
   */
  LTab({String this.idPrefix, bool this.scoped: false}) {
    element.classes.add(scoped ? C_TABS__SCOPED : C_TABS__DEFAULT);
    _tablist.classes.add(scoped ? C_TABS__SCOPED__NAV : C_TABS__DEFAULT__NAV);
    element.append(_tablist);
    if (idPrefix != null && idPrefix.isNotEmpty)
      element.id = idPrefix;
  } // LTab

  /**
   * Add Tab - returns content element
   */
  Element addTab (String label, {String name, String href, Element content}) {
    Element theContent = content;
    if (theContent == null)
      theContent = new DivElement();
    theContent.classes.add(C_TABS__CONTENT);
    theContent.attributes[Html0.ROLE] = Html0.ROLE_TABPANEL;
    element.append(theContent);

    //
    AnchorElement a = new AnchorElement()
      ..href = href == null || href.isEmpty ? "#" : href
      ..attributes[Html0.ROLE] = Html0.ROLE_TAB
      ..tabIndex = -1
      ..attributes[Html0.ARIA_SELECTED] = "false"
      ..attributes[Html0.DATA_VALUE] = _tablist.children.length.toString()
      ..text = label;
    a.onClick.listen(onTabClick);
    LIElement entry = new LIElement()
      ..classes.addAll([C_TABS__ITEM, LText.C_TEXT_HEADING__LABEL])
      ..title = label
      ..attributes[Html0.ROLE] = Html0.ROLE_PRESENTATION;
    entry.append(a);
    _tablist.append(entry);

    // Name + id
    if (name != null && name.isNotEmpty) {
      entry.attributes[Html0.DATA_NAME] = name;
      a.attributes[Html0.DATA_NAME] = name;
      theContent.attributes[Html0.DATA_NAME] = name;
      if (idPrefix != null && idPrefix.isNotEmpty) {
        a.id = "${idPrefix}-${name}";
        theContent.id = "${idPrefix}-${name}-content";
      }
    }
    selectTabByPos(currentPos);
    return theContent;
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
  bool selectTabByPos(int pos) {
    if (pos < 0 || pos >= _tablist.children.length)
      return false;
    //
    for (int i = 0; i < _tablist.children.length; i++) {
      LIElement li = _tablist.children[i];
      AnchorElement a = li.children.first;
      Element content = element.children[i+1];
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
    }
    _currentPos = pos;
    if (_sc != null)
      _sc.add(this); // notify
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
        return selectTabByPos(i);
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
        found= selectTabByPos(ii);
      }
      if (!found) {
        String name = a.attributes[Html0.DATA_NAME];
        found = selectTabByName(name);
      }
      if (found && href == "#") {
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
