/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Html Page with [container]
 */
class LPage {



} // LPage

/**
 * Lightning Container
 */
class LContainer extends CDiv {


  /**
   * Main Page Entry Point (returns the last created container)
   */
  static LContainer get container {
    if (_container == null)
      create();
    return _container;
  }
  static LContainer _container;

  /**
   * Create Page
   * [id] id of the application
   * [containerId] element id of the container, if not found looks for slds-container, if not found adds section to the body.
   * [clearContainer] clears all content from container
   */
  static LContainer create({String id: "wrap",
      bool clearContainer: true,
      String containerSize,
      String containerHAlign}) {
    // Top Level Main
    Element e = querySelector("#${id}");
    if (e == null) {
      e = querySelector(".${LGrid.C_CONTAINER__SMALL}");
      if (e == null) {
        e = querySelector(".${LGrid.C_CONTAINER__MEDIUM}");
        if (e == null) {
          e = querySelector(".${LGrid.C_CONTAINER__LARGE}");
        }
      }
    }
    if (e == null) {
      Element body = querySelector("body");
      _container = new LContainer.section(id);
      body.append(_container.element);
    } else {
      _container = new LContainer(e, id);
    }

    // remove children
    if (clearContainer) {
      _container.clear();
    }
    if (containerSize != null)
      _container.size = containerSize;
    if (containerHAlign != null)
      _container.hAlign = containerHAlign;
    return _container;
  } // init


  /// The Header
  LHeader header;
  /// The Footer
  LFooter footer;


  /**
   * Container with [id]
   */
  LContainer(Element element, String id) : super._(element) {
    element.id = id == null || id.isEmpty ? LComponent.createId("c", null) : id;
  }
  /// Create new div Container
  LContainer.div(String id) : this(new DivElement(), id);
  /// Create new section Container
  LContainer.section(String id) : this(new Element.section(), id);
  /// Create new article Container
  LContainer.article(String id) : this(new Element.article(), id);

  /// element id
  String get id => element.id;

  /// clear children
  void clear() => element.children.clear();

  /**
   * Set Container [size] LGrid.C_CONTAINER__SMALL/MEDIUM/LARGE
   */
  void set size(String size) {
    element.classes.removeAll(LGrid.CONTAINER_SIZES);
    if (size != null && size.isNotEmpty)
      element.classes.add(size);
  }
  /// first size found or null
  String get size {
    for (String cls in element.classes) {
      if (LGrid.CONTAINER_SIZES.contains(cls))
        return cls;
    }
    return null;
  }

  /**
   * Set Container horizontal [alignment] LGrid.C_CONTAINER__CENTER/RIGHT/LEFT
   */
  void set hAlign(String alignment) {
    element.classes.removeAll(LGrid.CONTAINER_HALIGN);
    if (alignment != null && alignment.isNotEmpty)
      element.classes.add(alignment);
  }
  /// first alignment or null
  String get hAlign {
    for (String cls in element.classes) {
      if (LGrid.CONTAINER_HALIGN.contains(cls))
        return cls;
    }
    return null;
  }

  /// add header
  LHeader addHeader(String text, {String size: LText.C_TEXT_HEADING__LARGE}) {
    header = new LHeader()
      ..text = text
      ..size = size;
    //
    add(header);
    return header;
  }

  /// add footer
  LFooter addFooter(String text, {String size: LText.C_TEXT_HEADING__SMALL}) {
    footer = new LFooter()
      ..text = text
      ..size = size;
    //
    add(footer);
    return footer;
  }

} // LContainer


/**
 * Page Header
 */
class LHeader extends LComponent {

  /// The Element
  final Element element = new Element.header()
    ..setAttribute(Html0.ROLE, Html0.ROLE_BANNER);
  /// h1
  final HeadingElement h1 = new HeadingElement.h1()
    ..classes.add(LText.C_TEXT_HEADING__LABEL);

  /// Header
  LHeader({String margin: LMargin.C_TOP__MEDIUM}) {
    element.append(h1);
    element.classes.add(margin);
  }

  /// Text
  void set text (String newValue) {
    h1.text = newValue;
  }
  /// Text
  String get text => h1.text;


  /// Size
  void set size (String newValue) {
    h1.classes.removeAll(LText.HEADING_SIZES);
    if (newValue != null && newValue.isNotEmpty)
      h1.classes.add(newValue);
  }
  String get size {
    for (String cls in element.classes) {
      if (LText.HEADING_SIZES.contains(cls))
        return cls;
    }
    return null;
  }

} // LHeader


/**
 * Page Footer
 */
class LFooter extends LComponent {

  /// footer element
  final Element element = new Element.footer()
    ..setAttribute(Html0.ROLE, Html0.ROLE_CONTENTINFO);
  /// h2
  final HeadingElement h2 = new HeadingElement.h2();

  /// Page Footer
  LFooter({String margin: LMargin.C_VERTICAL__MEDIUM}) {
    element.append(h2);
    element.classes.add(margin);
  }

  /// Text
  void set text (String newValue) {
    h2.text = newValue;
  }
  /// Text
  String get text => h2.text;

  /// Size
  void set size (String newValue) {
    h2.classes.removeAll(LText.HEADING_SIZES);
    if (newValue != null && newValue.isNotEmpty)
      h2.classes.add(newValue);
  }
  String get size {
    for (String cls in element.classes) {
      if (LText.HEADING_SIZES.contains(cls))
        return cls;
    }
    return null;
  }

  /// Add Footer Class
  void addFooterClass(String footerClass) {
    if (footerClass != null && footerClass.isNotEmpty)
      element.classes.add(footerClass);
  }
  /// Add Footer Classes, e.g. LPadding.C_TOP__X_LARGE, LPadding.C_BOTTOM__X_LARGE
  void addFooterClasses(List<String> footerClasses) {
    for (String cls in footerClasses)
      addFooterClass(cls);
  }


  /// Add Footer Heading Class
  void addHeadingClass(String headingClass) {
    if (headingClass != null && headingClass.isNotEmpty)
      h2.classes.add(headingClass);
  }
  /// Add Footer Heading Classes e.g. LText.C_TEXT_HEADING__LARGE, LPadding.C_TOP__X_LARGE
  void addHeadingClasses(List<String> headingClasses) {
    for (String cls in headingClasses)
      addHeadingClass(cls);
  }

} // LFooter
