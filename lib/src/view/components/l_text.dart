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

  /// slds-text-body--regular - Creates the 14px regular body copy
  static const String C_TEXT_BODY__REGULAR = "slds-text-body--regular";
  /// slds-text-body--small - Creates 12px copy
  static const String C_TEXT_BODY__SMALL = "slds-text-body--small";
  /// slds-text-heading--large - Very large 32px heading
  static const String C_TEXT_HEADING__LARGE = "slds-text-heading--large";
  /// slds-text-heading--medium - Large 24px heading
  static const String C_TEXT_HEADING__MEDIUM = "slds-text-heading--medium";
  /// slds-text-heading--small - Smaller 18px heading
  static const String C_TEXT_HEADING__SMALL = "slds-text-heading--small";
  /// slds-text-heading--label - All caps 12px heading
  static const String C_TEXT_HEADING__LABEL = "slds-text-heading--label";
  /// slds-text-longform - Adds default spacing and list styling within a wrapper
  static const String C_TEXT_LONGFORM = "slds-text-longform";
  /// slds-text-align--left - Aligns text left
  static const String C_TEXT_ALIGN__LEFT = "slds-text-align--left";
  /// slds-text-align--center - Aligns text center
  static const String C_TEXT_ALIGN__CENTER = "slds-text-align--center";
  /// slds-text-align--right - Aligns text right
  static const String C_TEXT_ALIGN__RIGHT = "slds-text-align--right";
  /// slds-section-title - Interactive titles with icons that open and close sections
  static const String C_SECTION_TITLE = "slds-section-title";
  /// slds-type-focus - Creates a faux link with interactions
  static const String C_TYPE_FOCUS = "slds-type-focus";







  static const String C_SECTION_GROUP__IS_OPEN = "section-group--is-open";
  static const String C_SECTION_GROUP__IS_CLOSED = "slds-section-group--is-closed";

  /// Icon Text
  static const String C_ASSISTIVE_TEXT = "slds-assistive-text";
  /// Truncate Text
  static const String C_TRUNCATE = "slds-truncate";

  static const String C_TEXT_CENTER = "slds-text-center";
  static const String C_TEXT_RIGHT = "slds-text-right";

  static const String C_TEXT_NOT_SELECTED = "slds-text-not-selected";
  static const String C_TEXT_SELECTED = "slds-text-selected";
  static const String C_TEXT_SELECTED_FOCUS = "slds-text-selected-focus";

  /// Heading Sizes
  static final List<String> HEADING_SIZES = [C_TEXT_HEADING__LABEL, C_TEXT_HEADING__LARGE, C_TEXT_HEADING__MEDIUM, C_TEXT_HEADING__SMALL];

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
    LIcon icon = new LIconUtility(LIconUtility.SWITCH);
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
