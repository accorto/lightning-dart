/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Lightning Component
 */
abstract class LComponent {

  /// Aria Labelled By Auto Numbering
  static int _autoAriaLabel = 1;
  /// Auto Id Numbering
  static int _autoId = 1;

  /// Get Element
  Element get element;

  /// Get Element Id
  String get id => element.id;

  /// append component
  void append(LComponent component) {
    element.append(component.element);
  }

  /**
   * Set [roleAttribute] e.g. Html0.V_ROLE_MAIN
   */
  void set role (String roleAttribute) {
    element.setAttribute(Html0.A_ROLE, roleAttribute);
  }

  /// Append Div
  CDiv appendDiv() {
    CDiv div = new CDiv();
    element.append(div.element);
    return div;
  }

  /// Append Section
  CSection appendSection() {
    CSection div = new CSection();
    element.append(div.element);
    return div;
  }

  /// element css classes
  CssClassSet get classes => element.classes;

  /**
   * Add Heading
   * if no [id] is provided the element.id is suffixed with -heading, if element has no id, it it auto numbered
   */
  HeadingElement addHeading(HeadingElement h, String text, {String id, String headingClass, List<String> headingClasses}) {
    h.text = text;
    // labelled by
    String theId = _subId("heading", autoAriaLabel: true);
    h.id = theId;
    element.setAttribute(Html0.A_ARIA_LABELLEDBY, theId);

    // Classes
    if (headingClass != null && headingClass.isNotEmpty)
      h.classes.add(headingClass);
    if (headingClasses != null) {
      for (String cls in headingClasses) {
        if (cls != null && cls.isNotEmpty)
          h.classes.add(cls);
      }
    }
    element.append(h);
    return h;
  } // addHeading

  /// add h1
  HeadingElement addHeading1(String text, {String id, String headingClass, List<String> headingClasses}) {
    return addHeading(new HeadingElement.h1(), text, id:id, headingClass:headingClass, headingClasses:headingClasses);
  }
  /// add h2
  HeadingElement addHeading2(String text, {String id, String headingClass, List<String> headingClasses}) {
    return addHeading(new HeadingElement.h2(), text, id:id, headingClass:headingClass, headingClasses:headingClasses);
  }
  /// add h3
  HeadingElement addHeading3(String text, {String id, String headingClass, List<String> headingClasses}) {
    return addHeading(new HeadingElement.h3(), text, id:id, headingClass:headingClass, headingClasses:headingClasses);
  }
  /// add h3
  HeadingElement addHeading4(String text, {String id, String headingClass, List<String> headingClasses}) {
    return addHeading(new HeadingElement.h4(), text, id:id, headingClass:headingClass, headingClasses:headingClasses);
  }

  /// create sub element id with [suffix] if id exists, otherwise auto id
  String _subId(String suffix, {bool autoAriaLabel: false}) {
    String theId = id;
    if (theId != null && theId.isNotEmpty) {
      return "${theId}-${suffix}";
    }
    if (autoAriaLabel)
      return "autoAria${_autoAriaLabel++}";
    return "autoId${_autoId++}";
  } // subId

} // LComponent


/**
 * Simple Div Element Component
 */
class CDiv extends LComponent {

  /// Div Element
  final DivElement element = new DivElement();
}

/**
 * Simple Section Element Component
 */
class CSection extends LComponent {

  /// Section Element
  final Element element = new Element.section();
}

/**
 * Simple Section Element Component
 */
class CArticle extends LComponent {

  /// Article Element
  final Element element = new Element.article();
}
