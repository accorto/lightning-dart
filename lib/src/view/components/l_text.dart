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

  /// slds-text-body--regular: Creates the 14px regular body copy - This is the base body font size and is rarely needed
  static const String C_TEXT_BODY__REGULAR = "slds-text-body--regular";
  /// slds-text-body--small: Creates a more pale-colored 12px copy - Typically used as supportive text
  static const String C_TEXT_BODY__SMALL = "slds-text-body--small";
  /// slds-text-heading--large (Any heading): Very large 32px heading - These are rarely used in the app and are reserved for extremely large text to showcase data (such as totals or stats).
  static const String C_TEXT_HEADING__LARGE = "slds-text-heading--large";
  /// slds-text-heading--medium (Any heading): Large 24px heading - Typically the largest heading on a page
  static const String C_TEXT_HEADING__MEDIUM = "slds-text-heading--medium";
  /// slds-text-heading--small (Any heading): Smaller 18px heading - Used for smaller content areas such as list sections or card titles
  static const String C_TEXT_HEADING__SMALL = "slds-text-heading--small";
  /// slds-text-heading--label (Any heading): All caps 12px heading - Usually labels small content areas like table columns and list sections
  static const String C_TEXT_HEADING__LABEL = "slds-text-heading--label";
  /// slds-text-longform (div): Adds default spacing and list styling within a wrapper - Our application framework removes default text styling. This adds in margins to large areas
  static const String C_TEXT_LONGFORM = "slds-text-longform";
  /// slds-text-align--left (Any text): Aligns text left
  static const String C_TEXT_ALIGN__LEFT = "slds-text-align--left";
  /// slds-text-align--center (Any text): Aligns text center
  static const String C_TEXT_ALIGN__CENTER = "slds-text-align--center";
  /// slds-text-align--right (Any text): Aligns text right
  static const String C_TEXT_ALIGN__RIGHT = "slds-text-align--right";
  /// slds-section-title: Interactive titles with icons that open and close sections - These are typically on a form
  static const String C_SECTION_TITLE = "slds-section-title";
  /// slds-section-title--divider: Titles that also act as a divider - These are typically on a form
  static const String C_SECTION_TITLE__DIVIDER = "slds-section-title--divider";
  /// slds-type-focus (container): Creates a faux link with interactions - This is used when an actual anchor element can not be used. For example — when a heading and button are next to each other and both need the text underline
  static const String C_TYPE_FOCUS = "slds-type-focus";


  static const String C_SECTION_GROUP__IS_OPEN = "section-group--is-open";
  static const String C_SECTION_GROUP__IS_CLOSED = "slds-section-group--is-closed";

  /// Icon Text
  static const String C_ASSISTIVE_TEXT = "slds-assistive-text";
  /// Truncate Text
  static const String C_TRUNCATE = "slds-truncate";

  static const String C_TEXT_NOT_SELECTED = "slds-text-not-selected";
  static const String C_TEXT_SELECTED = "slds-text-selected";
  static const String C_TEXT_SELECTED_FOCUS = "slds-text-selected-focus";

  /// Heading Sizes
  static final List<String> HEADING_SIZES = [C_TEXT_HEADING__LABEL, C_TEXT_HEADING__LARGE, C_TEXT_HEADING__MEDIUM, C_TEXT_HEADING__SMALL];


  /// Ext Text Color Error
  static const String C_TEXT_ERROR = "text-error";
  /// Ext Text Color Warning
  static const String C_TEXT_WARNING = "text-warning";
  /// Ext Text Color Success
  static const String C_TEXT_SUCCESS = "text-success";


} // LText


/**
 * Section title with open/closed toggle
 */
class LSectionTitle {

  /// The Section Container Element
  final Element element;

  /// Clickable Element
  final AnchorElement sectionAnchor = new AnchorElement(href: "#");
  /// Label element
  final SpanElement _labelElement = new SpanElement()
    ..classes.add(LMargin.C_LEFT__X_SMALL);

  /// Part of the Sections
  List<Element> _sectionParts = new List<Element> ();

  /**
   * Section Title
   * (need to add element and sectionElement)
   * element
   * - a
   * -- icon
   * -- label
   */
  LSectionTitle(Element this.element, {bool open:true, String label,
      String margin: LMargin.C_VERTICAL__SMALL,
      Element sectionElement}) {
    // structure
    _sectionElement = sectionElement == null ? new DivElement() : sectionElement;
    _sectionParts.add(_sectionElement);
    //
    element.classes.add(LText.C_SECTION_TITLE);
    if (margin != null && margin.isNotEmpty) {
      element.classes.add(margin);
    }
    element.append(sectionAnchor);
    //
    LIcon icon = new LIconUtility(LIconUtility.SWITCH);
    sectionAnchor.append(icon.element);
    sectionAnchor.append(_labelElement);
    //
    this.open = open;
    this.label = label;
    if (label == null || label.isEmpty)
      showLabel = false;
    //
    element.onClick.listen((MouseEvent evt){
      evt.preventDefault();
      this.open = !_open; // toggle
    });
  }
  LSectionTitle.div({bool open: true, String label})
      : this(new DivElement(), open:open, label:label,
          margin: LMargin.C_VERTICAL__SMALL);
  LSectionTitle.h3({bool open: true, String label})
      : this(new HeadingElement.h3(), open:open, label:label,
          margin: LMargin.C_VERTICAL__SMALL);
  LSectionTitle.legend({bool open: true, String label})
      : this(new LegendElement(), open:open, label:label,
          margin: LMargin.C_VERTICAL__SMALL);

  /// Current Element to show or hide
  Element get sectionElement => _sectionElement;
  Element _sectionElement;

  /// add new Section Element Part
  void addSectionElement(Element newElement) {
    _sectionParts.add(newElement);
    _sectionElement = newElement;
  }

  /// The Label
  String get label => _labelText;
  void set label (String newValue) {
    _labelText = newValue == null ? "" : newValue;
    _labelElement.text = _labelText;
  }
  String _labelText;

  bool get showLabel => element.classes.contains(LVisibility.C_HIDE);
  void set showLabel (bool newValue) {
    if (newValue) {
      element.classes.remove(LVisibility.C_HIDE);
    } else {
      element.classes.add(LVisibility.C_HIDE);
      open = true; // show main
    }
  }


  /// State
  bool get open => _open;
  void set open (bool newValue) {
    _open = newValue;
    if (_open) {
      element.classes.add(LText.C_SECTION_GROUP__IS_OPEN);
      element.classes.remove(LText.C_SECTION_GROUP__IS_CLOSED);
      for (Element part in _sectionParts)
        part.classes.remove(LVisibility.C_HIDE);
    } else {
      if (!showLabel)
        showLabel = true; // ensure we can open again
      element.classes.remove(LText.C_SECTION_GROUP__IS_OPEN);
      element.classes.add(LText.C_SECTION_GROUP__IS_CLOSED);
      for (Element part in _sectionParts)
        part.classes.add(LVisibility.C_HIDE);
    }
  }
  bool _open;

} // LSectionTitle
