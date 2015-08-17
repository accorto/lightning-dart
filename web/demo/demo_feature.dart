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
    HeadingElement h2 = new HeadingElement.h2()
      ..text = label;
    ParagraphElement descr = new ParagraphElement()
      ..text = description;
    ParagraphElement ref = new ParagraphElement()
      ..text = "See: "
      ..append(createSldsLink());
    UListElement ul = new UListElement();
    for (DivElement option in options) {
      LIElement li = new LIElement();
      li.append(option);
      ul.append(li);
    }
    //
    element.append(new HRElement());
    element.append(h2);
    element.append(descr);
    element.append(ref);
    element.append(ul);


    //
    LTab tab = new LTab(idPrefix: id);
    tab.element.style.marginTop = "20px";
    element.append(tab.element);
    Element sc = tab.addTab("Small", name: "s");
    sc.style.width = "480px";
    sc.style.border = "1px solid lightgray";
    Element mc = tab.addTab("Medium", name: "m");
    mc.style.width = "768px";
    mc.style.border = "1px solid gray";
    Element lc = tab.addTab("Large", name: "l");
    lc.style.width = "1024px";
    lc.style.border = "1px solid black";
    Element xc = tab.addTab("Flex", name: "x");
    xc.style.border = "1px solid black";

    Element dc = tab.addTab("Source", name: "d");
    ParagraphElement src = new ParagraphElement()
      ..style.whiteSpace = "pre"
      ..text = source;
    dc.append(src);

    tab.onTabChanged.listen(onTabChanged); // init display on tab add
    tab.selectTabByPos(3); // tab
  } // DemoFeature

  /// Link to Feature
  void toc(Element toc) {
    LIElement li = new LIElement();
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

} // DemoFeature
