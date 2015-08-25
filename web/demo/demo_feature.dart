/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart.demo;

/**
 * Demo Feature Mgt
 */
abstract class DemoFeature extends LComponent {

  static const String SLDS_URL = "https://www.getslds.com/components";
  static const String SLDS_TXT = "SLDS reference";

  final DivElement element = new DivElement();

  final String id;
  final String label;

  /**
   * Feature
   */
  DemoFeature(String this.id, String this.label, String description) {
    element.id = id;
    DivElement hdr = new DivElement()
      ..classes.addAll([LMargin.C_TOP__X_LARGE, LTheme.C_BOX, LTheme.C_THEME__SHADE]);
    HeadingElement h2 = new HeadingElement.h2()
      ..classes.add(LText.C_TEXT_HEADING__MEDIUM)
      ..text = label;
    hdr.append(h2);

    ParagraphElement descr = new ParagraphElement()
      ..text = description;
    hdr.append(descr);

    ParagraphElement ref = new ParagraphElement()
      ..classes.add(LText.C_TEXT_BODY__SMALL)
      ..text = "See: "
      ..append(createSldsLink());
    hdr.append(ref);

    UListElement ul = new UListElement()
      ..classes.add(LList.C_LIST__VERTICAL)
      ..classes.add(LList.C_HAS_CARDS);
    for (DivElement option in options) {
      LIElement li = new LIElement()
        ..classes.add(LList.C_LIST__ITEM);
      li.append(option);
      ul.append(li);
    }
    // element.append(new HRElement());
    element.append(hdr);
    element.append(ul);


    //
    LTab tab = new LTab(idPrefix: id);
    tab.element.style.marginTop = "20px";
    element.append(tab.element);
    Element sc = tab.addTab("Small", name: "s")
      ..classes.add(LGrid.C_CONTAINER__SMALL);
    sc.style.width = "480px";
    sc.style.border = "1px solid lightgray";
    Element mc = tab.addTab("Medium", name: "m")
      ..classes.add(LGrid.C_CONTAINER__MEDIUM);
    mc.style.width = "768px";
    mc.style.border = "1px solid gray";
    Element lc = tab.addTab("Large", name: "l")
      ..classes.add(LGrid.C_CONTAINER__LARGE);
    lc.style.width = "1024px";
    lc.style.border = "1px solid black";
    Element xc = tab.addTab("Fluid", name: "x")
      ..classes.add(LGrid.C_CONTAINER__FLUID);
    xc.style.width = "100%";
    xc.style.border = "1px solid black";

    Element dc = tab.addTab("Source", name: "d");
    ParagraphElement src = new ParagraphElement()
      ..classes.add(LText.C_TEXT_BODY__SMALL)
      ..style.whiteSpace = "pre"
      ..text = source;
    dc.append(src);

    tab.onTabChanged.listen(onTabChanged); // init display on tab add
    tab.selectTabByPos(3); // tab
  } // DemoFeature

  /// Link to Feature
  void toc(Element toc) {
    LIElement li = new LIElement()
      ..classes.add(LList.C_LIST__ITEM);
    toc.append(li);
    li.append(new AnchorElement(href: "#${id}")
      ..text = label);
  }

  AnchorElement createSldsLink() {
    return new AnchorElement(href: "${SLDS_URL}/$id")
      ..target = "slds"
      ..text = SLDS_TXT;
  }


  LComponent get content => contentNIY;
  String get source => sourceNIY;
  List<DivElement> get options => [];


  // Tab changed
  void onTabChanged(LTab tab){
    if (_theContent == null)
      _theContent = content;
    else
      _theContent.element.remove();
    //
    _theCurrentElement = tab.currentContent;
    _theCurrentElement.append(_theContent.element);
    //
    // window.location.hash = id;
  }
  LComponent _theContent;
  Element _theCurrentElement;

  /*
  LComponent get content {
    CDiv div = new CDiv();
    return div;
  }
  String get source {
    return '''
    ''';
  }
  */

  //option changed
  void optionChanged() {
    _theContent.element.remove();
    _theContent = content; // new
    if (_theCurrentElement != null)
      _theCurrentElement.append(_theContent.element);
  }


  LComponent get contentNIY {
    return new CDiv()
        ..text = "Not Implemented Yet";
  }
  String get sourceNIY {
    return "Not Implemented Yet";
  }

  /// Generate List items
  List<ListItem> generateListItems(int count,
      {String prefix: "Item", int increment: 4, bool iconLeft: false}) {
    List<ListItem> list = new List<ListItem>();
    int no = 1;
    for (int i = 0; i < count; i++) {
      String label = "${prefix} ${no}";
      String value = "${prefix.toLowerCase()}${no}";

      LIcon leftIcon = null;
      if (iconLeft) {
        leftIcon = new LIconCustom("custom-${no}");
      }
      DOption option = new DOption()
        ..id = value
        ..value = value
        ..label = label;
      ListItem li = new ListItem(option, leftIcon:leftIcon);
      list.add(li);
      no += increment;
    }
    return list;
  }

} // DemoFeature
