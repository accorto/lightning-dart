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

  /// This class allows the .slds-list__item to display in the breadcrumb style
  static const String C_BREADCRUMB  = "slds-breadcrumb";

  /// Auto Id Numbering
  static int _autoId = 1;

  /// Breadcrumb Nav element
  final Element element = new Element.nav()
    ..attributes[Html0.ROLE] = Html0.ROLE_NAVIGATION ;

  final ParagraphElement _p = new ParagraphElement()
    ..classes.add(LText.C_ASSISTIVE_TEXT);
  final OListElement _list = new OListElement()
    ..classes.addAll([C_BREADCRUMB, LList.C_LIST__HORIZONTAL]);

  String idPrefix;

  /**
   * Breadcrumb
   */
  LBreadcrumb({String this.idPrefix, String assistiveText}) {
    if (idPrefix == null || idPrefix.isEmpty)
      this.idPrefix = "bc${_autoId++}";
    _p.id = "${this.idPrefix}-label";
    _p.text = assistiveText == null ? lBreadcrumbText() : assistiveText;
    element.append(_p);
    _list.attributes[Html0.ARIA_LABELLEDBY] = _p.id;
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
    for (LIElement ee in _list.children) {
      if (count == level) {
        li = ee;
      } else if (removeKinds && count > level) {
        toremove.add(ee);
      }
      count++;
    }
    // remove
    for (LIElement ee in toremove)
      ee.remove();
    // none found at level
    if (li == null) {
      while (_list.children.length <= level) {
        li = new LIElement()
          ..classes.addAll([LList.C_LIST__ITEM, LText.C_TEXT_HEADING__LABEL]);
        _list.append(li);
      }
    }
    return li;
  } // getOrCreateLi



  static String lBreadcrumbText() => Intl.message("You are here", name: "lBreadcrumbText", args: []);

} // LBreadcrumb
