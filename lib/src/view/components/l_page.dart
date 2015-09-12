/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Html Page with [container]
 */
class LPage extends CDiv {

  /**
   * Main Page Entry Point (returns the last created container)
   */
  static LPage get page {
    if (_page == null)
      create();
    return _page;
  }
  static LPage _page;

  /**
   * Create Page (slds-grid)
   * [id] id of the application
   * [clearContainer] clears all content from container
   */
  static LPage create({String id: "wrap",
    bool clearContainer: true}) {
    // Top Level Main
    Element e = querySelector("#${id}");
    if (e == null) {
      e = querySelector(".container");
      if (e == null) {
        e = querySelector(".${LGrid.C_GRID}");
      }
    }
    if (e == null) {
      Element body = document.body; // querySelector("body");
      _page = new LPage(new DivElement(), id);
      body.append(_page.element);
    } else {
      if (clearContainer) {
        e.children.clear();
      }
      _page = new LPage(e, id);
    }
    return _page;
  } // init

  /// The Header
  LHeader header;
  /// Main Content
  CDiv main;
  /// The Footer
  LFooter footer;

  /**
   * Container with [id]
   */
  LPage(Element element, String id,
      {String baseClass: LGrid.C_GRID,
        String wrap: LGrid.C_WRAP,
        String margin: LMargin.C_AROUND__LARGE,
        List<String> addlClasses,
        bool createHeaderMainFooter: true,
        CDiv mainSection
      })
      : super._(element, null) {
    element.id = id == null || id.isEmpty ? LComponent.createId("c", null) : id;
    if (baseClass.isNotEmpty)
      element.classes.add(baseClass);
    if (wrap.isNotEmpty)
      element.classes.add(wrap);
    if (margin.isNotEmpty)
      element.classes.add(margin);
    if (addlClasses != null) {
      element.classes.addAll(addlClasses);
    }
    main = mainSection;
    if (main == null) {
      main = new CDiv.section()
        ..role = Html0.ROLE_MAIN;
    }
    if (createHeaderMainFooter) {
      header = new LHeader();

      element.append(header.element);
      element.append(main.element);
      footer = new LFooter();
      element.append(footer.element);
    } else {
      super.add(main);
    }
  } // LPage


  /// element id
  String get id => element.id;
  /// clear children
  void clear() => element.children.clear();

  /// append component to page
  void append(Element newValue,
      {String colClass: LGrid.C_COL,
      String size: LSizing.C_SIZE__1_OF_1,
      String margin: LMargin.C_VERTICAL__SMALL}) {
    main.element.append(newValue);
    if (colClass.isNotEmpty)
      newValue.classes.add(colClass);
    if (size.isNotEmpty)
      newValue.classes.add(size);
    if (margin.isNotEmpty)
      newValue.classes.add(margin);
  }
  /// append component to page
  void add(LComponent component,
      {String colClass: LGrid.C_COL,
      String size: LSizing.C_SIZE__1_OF_1,
      String margin: LMargin.C_VERTICAL__SMALL}) {
    main.element.append(component.element);
    if (colClass.isNotEmpty)
      component.element.classes.add(colClass);
    if (size.isNotEmpty)
      component.element.classes.add(size);
    if (margin.isNotEmpty)
      component.element.classes.add(margin);
  }

} // LPage

/**
 * Page Header with h1
 */
class LHeader extends LComponent {

  /// The Element
  final Element element = new Element.header()
    ..setAttribute(Html0.ROLE, Html0.ROLE_BANNER);
  /// h1
  final HeadingElement h1 = new HeadingElement.h1();

  /// Header
  LHeader({String colClass: LGrid.C_COL,
      String size: LSizing.C_SIZE__1_OF_1,
      String margin: LMargin.C_VERTICAL__SMALL}) {
    element.append(h1);
    if (colClass.isNotEmpty)
      element.classes.add(colClass);
    if (size.isNotEmpty)
      element.classes.add(size);
    if (margin.isNotEmpty)
      element.classes.add(margin);
  }

  /// Text
  void set text (String newValue) {
    h1.text = newValue;
  }
  /// Text
  String get text => h1.text;

} // LHeader


/**
 * Page Footer with h2
 */
class LFooter extends LComponent {

  /// footer element
  final Element element = new Element.footer()
    ..setAttribute(Html0.ROLE, Html0.ROLE_CONTENTINFO);
  /// h2
  final HeadingElement h2 = new HeadingElement.h2();

  /// Page Footer
  LFooter({String colClass: LGrid.C_COL,
      String size: LSizing.C_SIZE__1_OF_1,
      String margin: LMargin.C_VERTICAL__SMALL}) {
    element.append(h2);
    if (colClass.isNotEmpty)
      element.classes.add(colClass);
    if (size.isNotEmpty)
      element.classes.add(size);
    if (margin.isNotEmpty)
      element.classes.add(margin);
  }

  /// Text
  void set text (String newValue) {
    h2.text = newValue;
  }
  /// Text
  String get text => h2.text;

} // LFooter
