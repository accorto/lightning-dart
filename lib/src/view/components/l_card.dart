/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Card - container for table, form
 */
class LCard extends LComponent {

  /// slds-card - Initializes card | Required
  static const String C_CARD = "slds-card";
  /// slds-card__header - Initializes card header | Required
  static const String C_CARD__HEADER = "slds-card__header";
  /// slds-card__body - Initializes card body | Required
  static const String C_CARD__BODY = "slds-card__body";
  /// slds-card__footer - Initializes card footer | Required
  static const String C_CARD__FOOTER = "slds-card__footer";

  static const String C_TILE = "slds-tile";

  static const String C_CARD__COMPACT = "slds-card--compact";
  static const String C_CARD__EMPTY = "slds-card--empty";


  /// Card element
  final DivElement element = new DivElement()
    ..classes.add(C_CARD);

  final Element _header = new Element.header()
    ..classes.addAll([C_CARD__HEADER, LGrid.C_GRID]);
  final Element _body = new Element.section()
    ..classes.add(C_CARD__BODY);
  final Element _footer = new Element.footer()
    ..classes.add(C_CARD__FOOTER);

  /// prefix
  final String idPrefix;

  /**
   * Card
   */
  LCard(String this.idPrefix) {
    element.append(_header);
    element.append(_body);
    element.append(_footer);
  } // LCard


  /// Compact Layout
  bool get compact => element.classes.contains(C_CARD__COMPACT);

  /**
   * set Header with [label] and optional [icon] and button [group]
   */
  void setHeader(LIcon icon, String label, {LComponent action}) {
    _header.children.clear();
    DivElement headerDiv = new DivElement()
      ..classes.addAll([LMedia.C_MEDIA, LMedia.C_MEDIA__CENTER, LGrid.C_HAS_FLEXI_TRUNCATE]);
    _header.append(headerDiv);
    // Icon
    if (icon != null) {
      DivElement iconDiv = new DivElement()
        ..classes.add(LMedia.C_MEDIA__FIGURE);
      headerDiv.append(iconDiv);
      icon.size = LIcon.C_ICON__SMALL;
      iconDiv.append(icon.element);
    }
    // Label
    DivElement hDiv = new DivElement()
      ..classes.add(LMedia.C_MEDIA__BODY);
    headerDiv.append(hDiv);
    HeadingElement h3 = new HeadingElement.h3()
      ..classes.addAll([LText.C_TEXT_HEADING__SMALL, LText.C_TRUNCATE])
      ..text = label;
    hDiv.append(h3);
    // Button
    if (action != null) {
      DivElement actionDiv = new DivElement()
        ..classes.add(LGrid.C_NO_FLEX);
      _header.append(actionDiv);
      actionDiv.append(action.element);
    }
  } // setHeader

  /**
   * add [table] to body (classes set)
   */
  void addTable(LTable table) {
    table.bordered = true;
    table.responsiveStackedHorizontal = true;
    table.element.classes.add(LTable.C_NO_ROW_HOVER);
    //
    _body.append(table.element);
  } // setBody

  /// add [form] to body
  void addForm(LForm form) {
    form.classes.add(LMargin.C_HORIZONTAL__SMALL);
    _body.append(form.element);
  }

  /// append element
  void append(Element newValue) {
    _body.append(newValue);
  }
  /// add component
  void add(LComponent component) {
    _body.append(component.element);
  }


  /**
   * Add to Footer
   */
  void addFooter(LComponent fe) {
    _footer.append(fe.element);
  }
  void appendFooter(Element fe) {
    _footer.append(fe);
  }

} // LCard
