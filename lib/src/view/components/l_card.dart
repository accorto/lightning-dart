/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Card
 */
class LCard {

  static const String C_CARD = "slds-card";

  static const String C_CARD__HEADER = "slds-card__header";
  static const String C_CARD__BODY = "slds-card__body";
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
  void setHeader(LIcon icon, String label, LButtonGroup group) {
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
    if (group != null) {
      DivElement groupDiv = new DivElement()
        ..classes.add(LGrid.C_NO_FLEX);
      _header.append(groupDiv);
      groupDiv.append(group.element);
    }
  } // setHeader

  /**
   * set Body to [table] (classes set)
   */
  void setBody(LTable table) {
    table.bordered = true;
    table.responsiveStackedHorizontal = true;
    table.element.classes.add(LTable.C_NO_ROW_HOVER);
    //
    _body.append(table.element);
  } // setBody

  /**
   * Add to Footer
   */
  void addFooter(Element fe) {
    _footer.append(fe);
  }

} // LCard


/**
 * Compact Card
 */
class LCardCompact extends LCard {

  /// List
  UListElement _list = new UListElement();

  /**
   * Compact Card
   */
  LCardCompact(String idPrefix)
      : super(idPrefix) {
    element.classes.add(LCard.C_CARD__COMPACT);
    _body.append(_list);
  }

  /// Ignored
  @override
  void setBody(LTable ignored) {
  }

  /**
   * Add to the Body
   */
  void addBody(LCardCompactEntry entry) {
    _list.append(entry.element);
  }

  /// clear body entries
  void clearBody() {
    _list.children.clear();
  }

} // LCardCompact


/**
 * Compact Card Entry
 */
class LCardCompactEntry {

  /// Compact Entry
  final LIElement element = new LIElement()
    ..classes.addAll([LTile.C_TILE, LButton.C_HINT_PARENT]);

  /// Detail Tile
  final LTileDetail _detail = new LTileDetail();

  /**
   * label - e.g. link
   * // TODO standard button?
   */
  LCardCompactEntry(Element label, LButton button) {
    DivElement div = new DivElement()
      ..classes.addAll([LGrid.C_GRID, LGrid.C_GRID__ALIGN_SPREAD, LGrid.C_HAS_FLEXI_TRUNCATE]);
    element.append(div);
    ParagraphElement labelPara = new ParagraphElement()
      ..classes.addAll([LTile.C_TILE__TITLE, LText.C_TRUNCATE]);
    labelPara.append(label);
    div.append(labelPara);
    //
    if (button != null) {
      button.classes.addAll([LButton.C_BUTTON__ICON_BORDER_FILLED, LButton.C_BUTTON__ICON_BORDER_SMALL, LGrid.C_SHRINK_NONE]);
      button.icon.size = LIcon.C_ICON__SMALL;
      button.icon.classes.addAll([LButton.C_BUTTON__ICON, LButton.C_BUTTON__ICON__HINT, LButton.C_BUTTON__ICON__SMALL]);
      div.append(button.element);
    }
    //
    element.append(_detail.element);

  } // LCardCompactEntry


  /// Add Card details
  void addEntry(String label, String value, {bool addColonsToLabel: true})
    => _detail.addEntry(label, value, addColonsToLabel:addColonsToLabel);

} // LCardCompactEntry

