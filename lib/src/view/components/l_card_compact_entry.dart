/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;


/**
 * Compact Card Entry (Tile)
 * - target: same api as row
 */
class LCardCompactEntry {

  /// Compact Entry
  final LIElement element = new LIElement()
    ..classes.addAll([LTile.C_TILE, LButton.C_HINT_PARENT]);

  /// Detail Tile
  final LTileDetail _detail = new LTileDetail();

  /**
   * label - e.g. link
   */
  LCardCompactEntry(Element label, Element button) {
    DivElement div = new DivElement()
      ..classes.addAll([LGrid.C_GRID, LGrid.C_GRID__ALIGN_SPREAD, LGrid.C_HAS_FLEXI_TRUNCATE]);
    element.append(div);
    ParagraphElement labelPara = new ParagraphElement()
      ..classes.addAll([LTile.C_TILE__TITLE, LText.C_TRUNCATE]);
    labelPara.append(label);
    div.append(labelPara);
    //
    if (button != null) {
      div.append(button);
    }
    element.append(_detail.element);
  } // LCardCompactEntry

  /// Add Card details
  void addDetail(String label, String value, {bool addColonsToLabel: true})
    => _detail.addEntry(label, value, addColonsToLabel:addColonsToLabel);

} // LCardCompactEntry

