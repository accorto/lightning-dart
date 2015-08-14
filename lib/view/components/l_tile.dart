/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Tiles
 */
class LTile {


  static const String C_TILE = "slds-tile";
  static const String C_TILE__TITLE = "tile__title";
  static const String C_TILE__DETAIL = "tile__detail";
  static const String C_TILE__META = "slds-tile__meta";



} // LTile


/**
 * Tile Detail with Horizontal Label/Value pairs
 */
class LTileDetail {

  final DivElement element = new DivElement()
    ..classes.add(LTile.C_TILE__DETAIL);

  final DListElement _dl = new DListElement()
    ..classes.addAll([LList.C_DL__HORIZONTAL, LText.C_TEXT_BODY__SMALL]);

  /// Tile Detail Info
  LTileDetail() {
    element.append(_dl);
  }

  /**
   * Add Entry
   */
  void addEntry(String label, String value, {bool addColonsToLabel: true}) {
    String labelText = label;
    if (addColonsToLabel)
      labelText += ":";
    ParagraphElement dte = new ParagraphElement()
      ..classes.add(LText.C_TRUNCATE)
      ..text = labelText;
    Element dt = new Element.tag("dt")
      ..classes.add(LList.C_DL__HORIZONTAL__LABEL)
      ..append(dte);
    _dl.append((dt));
    //
    ParagraphElement dde = new ParagraphElement()
      ..classes.add(LText.C_TRUNCATE);
    if (value != null)
      dde.text = value;
    Element dd = new Element.tag("dd")
      ..classes.addAll([LList.C_DL__HORIZONTAL__DETAIL, LTile.C_TILE__META])
      ..append(dde);
    _dl.append((dd));
  }

} // LTileDetail
