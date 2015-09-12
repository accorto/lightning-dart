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

  /// busy indicator class
  static const String _C_BUSY = "busy";
  /// loading indicator class
  static const String _C_LOADING = "loading";

  /// Auto Id Numbering
  static int _autoId = 1;

  /// Get Element
  Element get element;

  /// Get Element Id
  String get id => element.id;

  /// append element
  void append(Element newValue) {
    element.append(newValue);
  }
  /// add component
  void add(LComponent component) {
    element.append(component.element);
  }

  /**
   * Set [roleAttribute] e.g. Html0.V_ROLE_MAIN
   */
  void set role (String roleAttribute) {
    element.setAttribute(Html0.ROLE, roleAttribute);
  }

  /// element data-value
  String get dataValue => element.attributes[Html0.DATA_VALUE];
  /// element data-value
  void set dataValue (String newValue) {
    element.attributes[Html0.DATA_VALUE] = newValue;
  }

  /// element css classes
  CssClassSet get classes => element.classes;

  /// called by sub class (does not change Id of element)
  static String createId(String idPrefix, String name, {String autoPrefixId: "lc"}) {
    String theId = idPrefix;
    if (theId == null || theId.isEmpty) {
      theId = "${autoPrefixId}-${_autoId++}";
    }
    if (name != null && name.isNotEmpty)
      theId = "${theId}-${name}";
    else if (idPrefix != null && idPrefix.isNotEmpty)
      theId = "${theId}-${_autoId++}";
    return theId;
  }
  /// called by sub class based on current id of element
  String setAndCreateId(String name, {String autoPrefixId: "lc", String autoPrefixName: "c"}) {
    String theId = element.id;
    if (theId == null || theId.isEmpty) {
      theId = "${autoPrefixId}-${_autoId++}";
      element.id = theId;
    }
    if (name != null && name.isNotEmpty)
      return "${theId}-${name}";
    return "${theId}-${autoPrefixName}-${_autoId++}";
  }

  void themeDefault () {
    LTheme.themeDefault(element);
  }
  void themeShade () {
    LTheme.themeShade(element);
  }
  void themeInverse () {
    LTheme.themeInverse(element);
  }
  void themeAltInverse () {
    LTheme.themeAltInverse(element);
  }
  void themeSuccess () {
    LTheme.themeSuccess(element);
  }
  void themeWarning () {
    LTheme.themeWarning(element);
  }
  void themeError () {
    LTheme.themeError(element);
  }
  void themeOffline () {
    LTheme.themeOffline(element);
  }
  /// add alert texture (striped)
  void themeTexture () {
    LTheme.themeTexture(element);
  }


  /**
   * Busy (entire screen) - modal
   */
  bool get busy => element.classes.contains(_C_BUSY);
  /// set the page busy
  void set busy(bool newValue) {
    if (newValue) {
      element.classes.add(_C_BUSY);
      LSpinner spinner = new LSpinner.brand(size: LSpinner.C_SPINNER__LARGE);
      DivElement div = new DivElement()
        ..classes.add("center-center")
        ..append(spinner.element);
      _busy = new DivElement()
        ..classes.add("busy-backdrop")
        ..classes.add("busy-backdrop--open")
        ..append(div);
      element.append(_busy);
    }
    else {
      element.classes.remove(_C_BUSY);
      if (_busy != null) {
        _busy.remove();
      }
      _busy = null;
    }
  } // busy
  DivElement _busy;

  /**
   * Loading - container only
   */
  bool get loading => element.classes.contains(_C_LOADING);
  void set loading (bool newValue) {
    if (newValue) {
      element.classes.add(_C_LOADING);
      LSpinner spinner = new LSpinner.base(size: LSpinner.C_SPINNER__SMALL);
      DivElement div = new DivElement()
        ..classes.add("center-center")
        ..append(spinner.element);
      _loading = new DivElement()
        ..classes.add("loading-backdrop")
        ..classes.add("loading-backdrop--open")
        ..append(div);
      element.append(_loading);
    } else {
      element.classes.remove(_C_LOADING);
      if (_loading != null) {
        _loading.remove();
      }
      _loading = null;
    }
  }
  DivElement _loading;

} // LComponent


/**
 * Simple Div Element Component
 */
class CDiv extends LComponent {

  /// Div Element
  final Element element;

  /// Div Element
  CDiv({String id}) : this._(new DivElement(), id);
  /// Section Element
  CDiv.section({String id}) : this._(new Element.section(), id);
  /// Article Element
  CDiv.article({String id}) : this._(new Element.article(), id);
  /// Header Element
  CDiv.header({String id}) : this._(new Element.header(), id);
  /// Footer Element
  CDiv.footer({String id}) : this._(new Element.footer(), id);

  /// Component
  CDiv._(Element this.element, String id) {
    if (id != null)
      element.id = id;
  }

  /// Text
  String get text => element.text;
  /// Text
  void set text (String newValue) {
    element.text = newValue;
  }

  /**
   * Set Container [size] LGrid.C_CONTAINER__SMALL/MEDIUM/LARGE/FLUID
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

  /// clear all content
  void clear() {
    element.children.clear();
  }

  /// add horizontal rule [margin] top/bottom - default 2rem
  void appendHR({String margin}) {
    HRElement hr = new HRElement();
    hr.style.margin = "${margin} 0 ";
    element.append(hr);
  }
  /// add horizontal rule with .5rem top/bottom margin
  void appendHrSmall() {
    appendHR(margin: ".5rem");
  }

  /// create and add span with text
  SpanElement appendText(String text) {
    SpanElement span = new SpanElement()
      ..text = text;
    element.append(span);
    return span;
  }

  /**
   * Add Heading + handle aria
   */
  HeadingElement appendHeading(HeadingElement h, String text, {String headingClass, List<String> headingClasses}) {
    h.text = text;
    // labelled by
    if (element.id == null || element.id.isEmpty) {
      element.id = "lc-${LComponent._autoId++}";
    }
    h.id = LComponent.createId(element.id, "heading");
    element.setAttribute(Html0.ARIA_LABELLEDBY, h.id);

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
  HeadingElement appendHeading1(String text, {String id, String headingClass, List<String> headingClasses}) {
    return appendHeading(new HeadingElement.h1(), text, headingClass:headingClass, headingClasses:headingClasses);
  }
  /// add h2
  HeadingElement appendHeading2(String text, {String id, String headingClass, List<String> headingClasses}) {
    return appendHeading(new HeadingElement.h2(), text, headingClass:headingClass, headingClasses:headingClasses);
  }
  /// add h3
  HeadingElement appendHeading3(String text, {String id, String headingClass, List<String> headingClasses}) {
    return appendHeading(new HeadingElement.h3(), text, headingClass:headingClass, headingClasses:headingClasses);
  }
  /// add h3
  HeadingElement appendHeading4(String text, {String id, String headingClass, List<String> headingClasses}) {
    return appendHeading(new HeadingElement.h4(), text, headingClass:headingClass, headingClasses:headingClasses);
  }

  /// create and add Div
  CDiv addDiv() {
    CDiv div = new CDiv();
    add(div);
    return div;
  }

  /// create and add Section
  CDiv addSection() {
    CDiv div = new CDiv.section();
    add(div);
    return div;
  }

  /// create and add Article
  CDiv addArticle() {
    CDiv div = new CDiv.article();
    add(div);
    return div;
  }

} // CDiv
