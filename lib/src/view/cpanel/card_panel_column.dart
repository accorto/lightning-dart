/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Card Panel Column
 */
class CardPanelColumn
    extends LComponent {

  final Element element = new Element.article()
    ..classes.addAll([LGrid.C_COL, CardPanel.C_CPANEL_COLUMN]);
  final DivElement _listElement = new DivElement()
    ..classes.addAll([LScrollable.C_SCROLLABLE__Y, LMargin.C_TOP__SMALL]);

  final String value;
  final bool isOtherColumn;

  List<LCardCompactEntry> cardList = new List<LCardCompactEntry>();

  /**
   * Card Panel
   */
  CardPanelColumn(String this.value,
      String label,
      {String idPrefix,
      bool this.isOtherColumn:false}) {
    element.id = LComponent.createId(idPrefix, value);
    element.setAttribute(Html0.DATA_VALUE, value);
    Element header = new HeadingElement.h2()
      ..classes.addAll([LText.C_TEXT_HEADING__MEDIUM, LTruncate.C_TRUNCATE])
      ..text = label;
    element.append(header);
    //
    element.append(_listElement);
  }

  /// Add Record - create card
  LCardCompactEntry addRecord(DataRecord data, AppsActionTriggered recordAction) {
    LCardCompactEntry card = new LCardCompactEntry.from(data, recordAction: recordAction);
    cardList.add(card);

    _listElement.append(card.element);
    return card;
  }


} // CardPanelColumn
