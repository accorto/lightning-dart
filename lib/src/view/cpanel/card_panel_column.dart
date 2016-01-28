/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;


class CardPanelColumn
    extends LComponent {

  final DivElement element = new DivElement();

  final String value;

  List<LCard> cardList = new List<LCard>();
  /**
   *
   */
  CardPanelColumn(String this.value, String label, {String idPrefix}) {

  }


  void addData(DataRecord data) {
    // LCard card = new LCard();

  }


} // CardPanelColumn
