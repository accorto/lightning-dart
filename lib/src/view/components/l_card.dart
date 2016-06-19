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

  /// slds-card (div): Initializes card
  static const String C_CARD = "slds-card";
  /// slds-card__header (div): Initializes card header
  static const String C_CARD__HEADER = "slds-card__header";
  /// slds-card__body (div): Initializes card body
  static const String C_CARD__BODY = "slds-card__body";
  /// slds-card__body--inner (Any element): Add spacing around inner elements of a card (e.g. a tile)
  static const String C_CARD__BODY__INNER = "slds-card__body--inner";
  /// slds-card__footer (div): Initializes card footer
  static const String C_CARD__FOOTER = "slds-card__footer";
  /// slds-card__tile (slds-tile): Use class if card consumes any form of a tile
  static const String C_CARD__TILE = "slds-card__tile";

  /// slds-card--narrow (slds-card): Modifies styles for card in a narrow column
  static const String C_CARD__NARROW = "slds-card--narrow";


  //static const String C_CARD__COMPACT = "slds-card--compact";


  /// Card element
  final DivElement element = new DivElement()
    ..classes.add(C_CARD);

  final Element _header = new DivElement()
    ..classes.addAll([C_CARD__HEADER, LGrid.C_GRID]);
  final Element _body = new DivElement()
    ..classes.add(C_CARD__BODY);
  final Element _footer = new DivElement()
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


  /**
   * set Header with [label] and optional [icon] and button [group]
   */
  void setHeader(LIcon icon, String label, {LComponent action}) {
    _header.children.clear();
    LMedia media = new LMedia(mediaClasses: [LMedia.C_MEDIA__CENTER, LGrid.C_HAS_FLEXI_TRUNCATE]);
    _header.append(media.element);
    // Icon
    if (icon != null) {
      icon.size = LIcon.C_ICON__SMALL;
      media.setIcon(icon);
    }
    // Label
    HeadingElement h3 = new HeadingElement.h3()
      ..classes.addAll([LText.C_TEXT_HEADING__SMALL, LText.C_TRUNCATE])
      ..text = label;
    media.append(h3);
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
    _body.classes.add(C_CARD__BODY__INNER);
    _body.append(table.element);
  } // setBody

  /// add [form] to body
  void addForm(LForm form) {
    //form.classes.add(LMargin.C_HORIZONTAL__SMALL);
    _body.classes.add(C_CARD__BODY__INNER);
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
