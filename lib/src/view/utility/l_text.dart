/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;


/**
 * Text
 * https://www.getslds.com/components/utilities/text
 */
class LText {

  /// slds-text-body--regular: Creates the 13px regular body copy - This is the base body font size and is rarely needed
  static const String C_TEXT_BODY__REGULAR = "slds-text-body--regular";
  /// slds-text-body--small: Creates a more pale-colored 12px copy - Typically used as supportive text
  static const String C_TEXT_BODY__SMALL = "slds-text-body--small";

  /// slds-text-heading--large (Any heading): Very large 28px heading - These are rarely used in the app and are reserved for extremely large text to showcase data (such as totals or stats).
  static const String C_TEXT_HEADING__LARGE = "slds-text-heading--large";
  /// slds-text-heading--medium (Any heading): Large 20px heading - Typically the largest heading on a page
  static const String C_TEXT_HEADING__MEDIUM = "slds-text-heading--medium";
  /// slds-text-heading--small (Any heading): Smaller 16px heading - Used for smaller content areas such as list sections or card titles
  static const String C_TEXT_HEADING__SMALL = "slds-text-heading--small";
  /// slds-text-title (Any heading): 12px heading that is not all caps - Usually labels small content areas like list sections.
  static const String C_TEXT_TITLE = "slds-text-title";
  /// slds-text-title--caps (Any heading): All caps 12px heading - Usually labels small content areas like tabs and page header titles.
  static const String C_TEXT_TITLE__CAPS = "slds-text-title--caps";
  /// slds-text-longform (div): Adds default spacing and list styling within a wrapper - Our application framework removes default text styling. This adds in margins to large area
  static const String C_TEXT_LONGFORM = "slds-text-longform";

  /// slds-text-align--left (Any text): Aligns text left
  static const String C_TEXT_ALIGN__LEFT = "slds-text-align--left";
  /// slds-text-align--center (Any text): Aligns text center
  static const String C_TEXT_ALIGN__CENTER = "slds-text-align--center";
  /// slds-text-align--right (Any text): Aligns text right
  static const String C_TEXT_ALIGN__RIGHT = "slds-text-align--right";

  /// slds-text-color--default (Any text): Default color of text
  static const String C_TEXT_COLOR__DEFAULT = "slds-text-color--default";
  /// slds-text-color--weak (Any text): Weak color of text
  static const String C_TEXT_COLOR__WEAK = "slds-text-color--weak";
  /// slds-text-color--error (Any text): Error color of text
  static const String C_TEXT_COLOR__ERROR = "slds-text-color--error";

  /// slds-section: Container for a collapsable sub section through interaction with the section title - These are typically on a form, if content exists to be expanded, applying the .slds-is-open will expand .slds-section__content
  static const String C_SECTION = "slds-section";
  /// slds-section__title: Title of a section, can contain an interactive button icon to expand/collapse sub section(s)
  static const String C_SECTION__TITLE = "slds-section__title";
  /// slds-section__title-action: Interactive titles with icons that open and close sections
  static const String C_SECTION__TITLE_ACTION = "slds-section__title-action";
  /// slds-section__content: Content of a section that can be expanded/collapse through interaction with the .slds-section__title-action
  static const String C_SECTION__CONTENT = "slds-section__content";

  /// slds-section-title (DEPRECATED): Interactive titles with icons that open and close sections - These are typically on a form
  //static const String C_SECTION_TITLE = "slds-section-title";
  /// slds-section-title--divider (DEPRECATED): Titles that also act as a divider with a grey background - These are typically on a form
  //static const String C_SECTION_TITLE__DIVIDER = "slds-section-title--divider";

  /// slds-type-focus (container): Creates a faux link with interactions - This is used when an actual anchor element can not be used. For example — when a heading and button are next to each other and both need the text underline
  static const String C_TYPE_FOCUS = "slds-type-focus";

  /// slds-text-heading--label (Any heading): All caps 12px heading - Usually labels small content areas like tabs and page header titles
  //static const String C_TEXT_HEADING__LABEL = "slds-text-heading--label";
  /// slds-text-heading--label-normal (Any heading): 12px heading that is not all caps - Usually labels small content areas like list sections.
  //static const String C_TEXT_HEADING__LABEL_NORMAL = "slds-text-heading--label-normal";



  /// undocumented
  static const String U_TEXT_NOT_SELECTED = "slds-text-not-selected";
  static const String U_TEXT_SELECTED = "slds-text-selected";
  static const String U_TEXT_SELECTED_FOCUS = "slds-text-selected-focus";

  /// Heading Sizes
  static final List<String> HEADING_SIZES = [C_TEXT_HEADING__LARGE, C_TEXT_HEADING__MEDIUM, C_TEXT_HEADING__SMALL];


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
class LSectionTitle
    extends LComponent {

  /// The Section Title Element
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
  LSectionTitle(Element this.element, {bool open:true, String label, String margin,
      Element contentElement}) {
    // structure
    _sectionElement = contentElement == null ? new DivElement() : contentElement;
    _sectionElement.classes.add(LText.C_SECTION__CONTENT);
    _sectionParts.add(_sectionElement);
    //
    element.classes.addAll([LText.C_SECTION__TITLE, LText.C_SECTION__TITLE_ACTION]);
    if (margin != null && margin.isNotEmpty) {
      element.classes.add(margin);
    }
    LIcon icon = new LIconUtility(LIconUtility.SWITCH, className: LButton.C_BUTTON__ICON_);
    sectionAnchor
        ..append(icon.element)
        ..append(_labelElement);
    element.append(sectionAnchor);
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
      : this(new LegendElement(), open:open, label:label);

  /// Content Element to show or hide
  Element get sectionContent => _sectionElement;
  Element _sectionElement;

  /// add new Section Element Part and make it current
  void addSectionElement(Element newElement) {
    newElement.classes.add(LText.C_SECTION__CONTENT);
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

  /// create section
  Element createSectionParent(final String sectionId, final Element parentElement) {
    sectionAnchor.id = "${sectionId}a";
    sectionContent.id = "${sectionId}b";
    _parent = parentElement
      ..id = sectionId
      ..classes.add(LText.C_SECTION)
      ..classes.add(LVisibility.C_IS_OPEN)
      ..append(element) // header
      ..append(sectionContent); // content
    open = _open; // set ui
    return _parent;
  }
  Element _parent;

  /// State
  bool get open => _open;
  /// Section open
  void set open (bool newValue) {
    _open = newValue;
    if (!_open && !showLabel) {
        showLabel = true; // ensure we can open again
    }
    if (_parent != null) {
      _parent.classes.toggle(LVisibility.C_IS_OPEN, newValue);
    }
    for (Element part in _sectionParts) {
      part.classes.toggle(LVisibility.C_HIDE, !_open); // hight=0 does not reliably work
      part.classes.toggle(LVisibility.C_IS_COLLAPSED, !_open);
      part.classes.toggle(LVisibility.C_IS_EXPANDED, _open);
    }
  }
  bool _open = true;

} // LSectionTitle
