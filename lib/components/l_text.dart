/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;


/**
 * Text
 * https://www.getslds.com/components/utilities/text
 */
class LText {

  /// CSS Class
  static const String C_TEXT_BODY__REGULAR = "slds-text-body--regular";
  static const String C_TEXT_BODY__SMALL = "slds-text-body--small";
  static const String C_TEXT_INTRODUCTION = "slds-text-introduction";

  static const String C_TEXT_HEADING__LARGE = "slds-text-heading--large";
  static const String C_TEXT_HEADING__MEDIUM = "slds-text-heading--medium";
  static const String C_TEXT_HEADING__SMALL = "slds-text-heading--small";
  static const String C_TEXT_HEADING__LABEL = "slds-text-heading--label";

  static const String C_TEXT_ALIGN__LEFT = "slds-text-align--left";
  static const String C_TEXT_ALIGN__CENTER = "slds-text-align--center";
  static const String C_TEXT_ALIGN__RIGHT = "slds-text-align--right";
  static const String C_TEXT_LONGFORM = "slds-text-longform";

  static const String C_TYPE_FOCUS = "slds-type-focus";

  static const String C_SECTION_TITLE = "slds-section-title";
  static const String C_SECTION_GROUP__IS_OPEN = "section-group--is-open";
  static const String C_SECTION_GROUP__IS_CLOSED = "slds-section-group--is-closed";

  /// Truncate Text
  static const String C_TRUNCATE = "slds-truncate";

  /// Heading Sizes
  static final List<String> HEADING_SIZES = [C_TEXT_HEADING__LARGE, C_TEXT_HEADING__MEDIUM, C_TEXT_HEADING__SMALL];

} // LText


/**
 * Section title with open/closed toggle
 */
class LSectionTitle {

  /// The Element
  final Element element;
  /// Label element
  final SpanElement _labelElement = new SpanElement();

  /**
   * element
   * - a
   * -- icon
   * -- label
   */
  LSectionTitle(Element this.element, {bool open: true, String label}) {
    // structure
    element.classes.add(LText.C_SECTION_TITLE);
    AnchorElement a = new AnchorElement(href: "#");
    element.append(a);
    //
    LIcon icon = new LIcon.utility("switch");
    a.append(icon.element);
    a.append(_labelElement);
    //
    this.open = open;
    this.label = label;
  }
  LSectionTitle.div({bool open: true, String label})
      : this(new DivElement(), open:open, label:label);

  /// The Label
  String get label => _labelText;
  void set label (String newValue) {
    _labelText = newValue == null ? "" : newValue;
    _labelElement.text = _labelText;
  }
  String _labelText;

  /// State
  bool get open => _open;
  void set open (bool newValue) {
    _open = newValue;
    if (_open) {
      element.classes.add(LText.C_SECTION_GROUP__IS_OPEN);
      element.classes.remove(LText.C_SECTION_GROUP__IS_CLOSED);
    } else {
      element.classes.remove(LText.C_SECTION_GROUP__IS_OPEN);
      element.classes.add(LText.C_SECTION_GROUP__IS_CLOSED);
    }
  }
  bool _open;


} // LSectionTitle
