/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Breadcrumb (list of anchors) based on ol
 */
class LBreadcrumb extends LComponent {

  /// slds-breadcrumb (ol): Initializes a breadcrumb component - This class allows the .slds-list__item to display in the breadcrumb style
  static const String C_BREADCRUMB = "slds-breadcrumb";
  /// slds-breadcrumb__item (li): Item of the breadcrumb list
  static const String C_BREADCRUMB__ITEM = "slds-breadcrumb__item";

  /// Auto Id Numbering
  static int _autoId = 1;

  /// Breadcrumb Nav element
  final Element element = new Element.nav()
    ..attributes[Html0.ROLE] = Html0.ROLE_NAVIGATION ;
  /// Ordered List Parent
  final OListElement _list = new OListElement()
    ..classes.addAll([C_BREADCRUMB, LList.C_LIST__HORIZONTAL]);

  String idPrefix;

  /**
   * Breadcrumb
   */
  LBreadcrumb({String this.idPrefix}) {
    if (idPrefix == null || idPrefix.isEmpty)
      this.idPrefix = "bc${_autoId++}";
    element.append(_list);
  } // LBreadcrumb

  /**
   * Set Anchor [a] at [level] 0..x
   */
  void setLink(AnchorElement a, int level, {bool removeKids: true}) {
    if (a == null || level < 0)
      return;
    LIElement li = _getOrCreateLi(level, removeKids);
    li.children.clear();
    li.append(a);
  }

  /**
   * create Anchor with [label] and [href] at [level] 0..x
   */
  void setLinkText(String label, String href, int level, {bool removeKids: true}) {
    String theRef = href;
    if (theRef == null || theRef.isEmpty)
      theRef = "#";
    AnchorElement a = new AnchorElement(href: theRef)
      ..text = label
      ..title = label;
    setLink(a, level, removeKids:removeKids);
  }


  /// Get Or Create LI
  LIElement _getOrCreateLi(int level, bool removeKinds) {
    LIElement li = null;
    int count = 0;
    List<LIElement> toremove = new List<LIElement>();
    for (Element ee in _list.children) {
      if (ee is LIElement) {
        if (count == level) {
          li = ee;
        } else if (removeKinds && count > level) {
          toremove.add(ee);
        }
        count++;
      }
    }
    // remove
    for (LIElement ee in toremove)
      ee.remove();
    // none found at level
    if (li == null) {
      while (_list.children.length <= level) {
        li = new LIElement()
          ..classes.addAll([C_BREADCRUMB__ITEM, LText.C_TEXT_TITLE__CAPS]);
        _list.append(li);
      }
    }
    return li;
  } // getOrCreateLi


} // LBreadcrumb
