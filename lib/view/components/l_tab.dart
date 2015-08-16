/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Tab Set
 */
class LTab {

  static const String C_TABS__DEFAULT = "slds-tabs--default";
  static const String C_TABS__DEFAULT__NAV = "slds-tabs--default__nav";
  static const String C_TABS__SCOPED = "slds-tabs--scoped";
  static const String C_TABS__SCOPED__NAV = "slds-tabs--scoped__nav";

  static const String C_TABS__ITEM = "slds-tabs__iteml";
  static const String C_TABS__CONTENT = "slds-tabs__content";

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
      ..attributes[Html0.DATA_VALUE] = _tablist.children.length.toString();
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
    return theContent;
  } // addTab

  /**
   * Select Tab By Position [pos] 0..x returns false if not found
   */
  bool selectByPos(int pos) {
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
      } else {
        li.classes.remove(LVisibility.C_ACTIVE);
        a.tabIndex = -1;
        a.attributes[Html0.ARIA_SELECTED] = "false";
        content.classes.remove(LVisibility.C_SHOW);
        content.classes.add(LVisibility.C_HIDE);
      }
    }
    return true;
  }

  /**
   * Select Tab By name - returns false if not found
   */
  bool selectByName(String name) {
    if (name == null || name.isEmpty)
      return false;

    for (int i = 0; i < _tablist.children.length; i++) {
      LIElement li = _tablist.children[i];
      String ref = li.attributes[Html0.DATA_NAME];
      if (ref == name) {
        return selectByPos(i);
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
        found= selectByPos(ii);
      }
      if (!found) {
        String name = a.attributes[Html0.DATA_NAME];
        found = selectByName(name);
      }
      if (found && href == "#") {
        evt.stopPropagation();
        evt.preventDefault();
      }
    }
  } // onTabClick

} // LTab
