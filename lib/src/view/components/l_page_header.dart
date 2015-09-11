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
class LPageHeader extends LComponent {

  static const String C_PAGE_HEADER = "slds-page-header";

  /// slds-page-header__detail-row - Creates margins around the detail section of record home
  static const String C_PAGE_HEADER__DETAIL_ROW = "slds-page-header__detail-row";


  static const String C_MEDIA__REC_HOME = "slds-media--rec-home";
  static const String C_MEDIA__REC_HOME__TITLE = "slds-media--rec-home__title";
  static const String C_MEDIA__REC_HOME__BUTTON = "slds-media--rec-home__button";

  static const String C_PAGE_HEADER__REC_HOME_DETAIL__ROW = "slds-page-header--rec-home__detail-row";

  static const String C_PAGE_HEADER__DETAIL = "slds-page-header__detail";


  /// Page Header
  final Element element = new Element.header()
    ..classes.add(C_PAGE_HEADER)
    ..attributes[Html0.ROLE] = Html0.ROLE_BANNER;

} // LPageHeader

