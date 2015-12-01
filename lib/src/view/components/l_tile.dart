/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Tile
 */
abstract class LTile extends LComponent {

  /// slds-tile - Initializes tile | Required
  static const String C_TILE = "slds-tile";
  /// slds-tile__title -  | Required
  static const String C_TILE__TITLE = "slds-tile__title";
  /// slds-tile__detail -  | Required
  static const String C_TILE__DETAIL = "slds-tile__detail";
  /// slds-tile__meta - Applies text color change
  static const String C_TILE__META = "slds-tile__meta";
  /// slds-media - Layout helper that aligns image and text
  static const String C_MEDIA = "slds-media";
  /// slds-media__body - Layout helper
  static const String C_MEDIA__BODY = "slds-media__body";
  /// slds-truncate - Applies overflow truncation to tile detail items
  static const String C_TRUNCATE = "slds-truncate";
  /// slds-list--horizontal - Horizontally aligns list items
  static const String C_LIST__HORIZONTAL = "slds-list--horizontal";
  /// slds-has-dividers - Adds dotted dividers in a horizontal list
  static const String C_HAS_DIVIDERS = "slds-has-dividers";
  /// slds-list--vertical - Vertically aligns list items
  static const String C_LIST__VERTICAL = "slds-list--vertical";
  /// slds-grid - Initializes a grid layout
  static const String C_GRID = "slds-grid";
  /// slds-grid--align-spread - Spreads the elements on each end of the same axis
  static const String C_GRID__ALIGN_SPREAD = "slds-grid--align-spread";
  /// slds-has-flexi-truncate - Layout helper applied to a parent .slds-grid when .slds-truncate is within a flex element
  static const String C_HAS_FLEXI_TRUNCATE = "slds-has-flexi-truncate";
  /// slds-hint-parent - Highlights dimmed action overflow icons on tile hover
  static const String C_HINT_PARENT = "slds-hint-parent";

  /// tile board
  static const String C_TILE__BOARD = "slds-tile--board";

  /// Tile Element
  final DivElement element = new DivElement()
    ..classes.add(C_TILE);

  /// Tile Title
  final ParagraphElement _title = new ParagraphElement()
    ..classes.addAll([C_TILE__TITLE, LText.C_TRUNCATE]);
  /// Tile Title Link
  final AnchorElement titleLink = new AnchorElement(href: "#");

  /// Detail div
  DivElement get _detail;
  DivElement __detail;


  /// add p with text to detail
  ParagraphElement addText(String text) {
    ParagraphElement p = new ParagraphElement()
      ..classes.add(LText.C_TRUNCATE)
      ..text = text;
    _detail.append(p);
    return p;
  }


  /// add label: value entry to detail
  void addEntry(String label, String value, {bool addColonsToLabel: true}) {
    if (_dl == null) {
      _dl = new DListElement()
        ..classes.addAll([LList.C_DL__HORIZONTAL, LText.C_TEXT_BODY__SMALL]);
      _detail.append(_dl);
    }
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
  } // addEntry
  DListElement _dl;

  /// Detail ul
  UListElement get _detailList;
  UListElement __detailList;


  /// Add li item to detail list (in one line with dots)
  LIElement addItem(String text) {
    LIElement li = new LIElement()
      ..classes.addAll([LText.C_TRUNCATE, LList.C_LIST__ITEM])
      ..text = text;
    _detailList.append(li);
    return li;
  }


  /// in board (position relative for use in  cards)
  bool get board => element.classes.contains(C_TILE__BOARD);
  /// Set board
  void set board (bool newValue) {
    if (newValue)
      element.classes.add(C_TILE__BOARD);
    else
      element.classes.remove(C_TILE__BOARD);
  }

} // LTile


/**
 * Base Tile with title and
 * - text (one or more lines of text) [addText]
 * - items (one line with multiple items [addItem)
 * - entries (one or more label/value pairs) [addEntry]
 */
class LTileBase extends LTile {

  /// Base Tile
  LTileBase(String title) {
    element.append(_title);
    _title.append(titleLink);
    //
    titleLink.text = title;
  }

  /// Get Detail Div
  DivElement get _detail {
    if (__detail == null) {
      __detail = new DivElement()
        ..classes.addAll([LTile.C_TILE__DETAIL, LText.C_TEXT_BODY__SMALL]);
      element.append(__detail);
    }
    return __detail;
  }

  /// Get Detail ul
  UListElement get _detailList {
    if (__detailList == null) {
      __detailList = new UListElement()
        ..classes.addAll([LTile.C_TILE__DETAIL, LList.C_LIST__HORIZONTAL, LList.C_HAS_DIVIDERS, LText.C_TEXT_BODY__SMALL]);
      element.append(__detailList);
    }
    return __detailList;
  }

} // LTileBase


/**
 * Base Tile with Icon, Image - subset of LTileGeneric with
 * - text (one or more lines of text) [addText]
 * - items (one line with multiple items [addItem)
 * - entries (one or more label/value pairs) [addEntry]
 */
class LTileIcon extends LTile {

  /// Figure Image Div
  final DivElement _figure = new DivElement()
    ..classes.add(LMedia.C_MEDIA__FIGURE);
  /// Body Text Div
  final DivElement _body = new DivElement()
    ..classes.add(LMedia.C_MEDIA__BODY);

  /// Base Tile with Icon
  LTileIcon(String title, {LIcon icon, String imgSrc, ImageElement img, String alt}) {
    element.classes.add(LMedia.C_MEDIA);
    element.append(_figure);
    if (icon != null) {
      icon.element.attributes[Html0.ARIA_HIDDEN] = "true";
      _figure.append(icon.element);
    } else {
      if (imgSrc != null) {
        img = new ImageElement(src:LImage.assetsSrc(imgSrc));
      }
      if (img != null) {
        if (alt != null)
          img.alt = alt;
        DivElement wrap = new DivElement()
          ..classes.addAll([LImage.C_AVATAR, LImage.C_AVATAR__SMALL, LImage.C_AVATAR__CIRCLE])
          ..append(img);
        _figure.append(wrap);
      }
    }

    element.append(_body);
    _body.append(_title);
    _title.append(titleLink);
    //
    titleLink.text = title;
  } // LTileIcon

  /// Get Detail Div
  DivElement get _detail {
    if (__detail == null) {
      __detail = new DivElement()
        ..classes.addAll([LTile.C_TILE__DETAIL, LText.C_TEXT_BODY__SMALL]);
      _body.append(__detail);
    }
    return __detail;
  }

  /// Get Detail ul
  UListElement get _detailList {
    if (__detailList == null) {
      __detailList = new UListElement()
        ..classes.addAll([LTile.C_TILE__DETAIL, LList.C_LIST__HORIZONTAL, LList.C_HAS_DIVIDERS, LText.C_TEXT_BODY__SMALL]);
      _body.append(__detailList);
    }
    return __detailList;
  }

} // LTileIcon




/*
class LTileList extends LTile {

  /// Get Detail Div
  DivElement get _detail {
    if (__detail == null) {
      __detail = new DivElement()
        ..classes.addAll([LTile.C_TILE__DETAIL, LText.C_TEXT_BODY__SMALL]);
      element.append(__detail);
    }
    return __detail;
  }

  /// Get Detail ul
  UListElement get _detailList {
    if (__detailList == null) {
      __detailList = new UListElement()
        ..classes.addAll([LTile.C_TILE__DETAIL, LList.C_LIST__HORIZONTAL, LList.C_HAS_DIVIDERS, LText.C_TEXT_BODY__SMALL]);
      element.append(__detailList);
    }
    return __detailList;
  }

} // LTileList */



/*
class LTileTask extends LTile {


} // LTileTask */

