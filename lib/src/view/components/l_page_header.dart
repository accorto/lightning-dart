/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Page Header
 * for implementations check [LObjectHome] [LRecordHome] [LRelatedList]
 */
class LPageHeader
    extends LComponent {

  /// slds-page-header (div): Applies background color and padding - Required on the main container for the page header
  static const String C_PAGE_HEADER = "slds-page-header";
  /// slds-page-header__title (p): Page title (header text).
  static const String C_PAGE_HEADER__TITLE = "slds-page-header__title";
  /// slds-page-header__info (p): For the small supporting info text after the heading
  //static const String C_PAGE_HEADER__INFO = "slds-page-header__info";
  /// slds-page-header__detail-row (div): Creates margins around the detail section of record home - Only the record home page header contains this detail area
  static const String C_PAGE_HEADER__DETAIL_ROW = "slds-page-header__detail-row";


  //static const String C_PAGE_HEADER__DETAIL = "slds-page-header__detail";


  /// Page Header
  final Element element = new Element.header()
    ..classes.add(C_PAGE_HEADER)
    ..attributes[Html0.ROLE] = Html0.ROLE_BANNER;

} // LPageHeader


/**
 * Base Page Header
 * - icon | title/info
 */
class LPageHeaderBase
    extends LPageHeader {

  final LMedia _media = new LMedia();

  /**
   * Base Page Header
   */
  LPageHeaderBase(LIcon icon, String title, String info, {String idPrefix}) {
    element.id = LComponent.createId(idPrefix, "home");
    icon.classes.add(LIcon.C_ICON__LARGE);
    _media.setIcon(icon);
    ParagraphElement _title = new ParagraphElement()
      ..classes.addAll([LPageHeader.C_PAGE_HEADER__TITLE, LTruncate.C_TRUNCATE, LGrid.C_ALIGN_MIDDLE])
      ..title = title
      ..text = title;
    ParagraphElement _info = new ParagraphElement()
      ..classes.addAll([LText.C_TEXT_BODY__SMALL])
      ..text = info;
    _media.body
      ..append(_title)
      ..append(_info);
    element.append(_media.element);
  } // LPageHeaderBase


} // LPageHeaderBase

