/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

class LPageHeader extends LComponent {

  static const String C_PAGE_HEADER = "slds-page-header";
  static const String C_PAGE_HEADER__REC_HOME_DETAIL__ROW = "slds-page-header--rec-home__detail-row";
  static const String C_PAGE_HEADER__DETAIL = "slds-page-header__detail";

  /// Page Header
  final DivElement element = new DivElement()
    ..classes.add(C_PAGE_HEADER);

  /// Top Row - Icon - Title - Label - Follow - Actions
  final DivElement header = new DivElement()
    ..classes.add(LGrid.C_GRID);

  /// Top row left
  final DivElement headerLeft = new DivElement()
    ..classes.addAll([LGrid.C_COL, LGrid.C_HAS_FLEXI_TRUNCATE]);
  /// Image Div
  final DivElement headerLeftMedia = new DivElement()
    ..classes.add(LMedia.C_MEDIA)
    ..classes.add("media--rec-home");
  /// Figure Image Div
  final DivElement headerLeftMediaFigure = new DivElement()
    ..classes.add(LMedia.C_MEDIA__FIGURE);
  /// Figure Image
  LIcon headerLeftMediaFigureSvg;
  /// Figure Image Div
  final DivElement headerLeftMediaBody = new DivElement()
    ..classes.add(LMedia.C_MEDIA__BODY);



  /// Top row
  final DivElement headerRight = new DivElement()
    ..classes.addAll([LGrid.C_COL, LGrid.C_NO_FLEX, LGrid.C_ALIGN_BOTTOM]);

  /// Detail row
  final DivElement detail = new DivElement();

  LPageHeader(LIcon icon) {
    element.append(header);
    // Header Row
    header.append(headerLeft);
    headerLeft.append(headerLeftMedia);
    headerLeftMedia.append(headerLeftMediaFigure);
    headerLeftMediaFigureSvg = icon;
    headerLeftMediaFigure.append(headerLeftMediaFigureSvg.element);
    //
    headerLeftMedia.append(headerLeftMediaBody);


    // right
    header.append(headerRight);

    // Detail Row
    header.append(detail);
  }



} // LPageHeader



/**
 *
 */
class LRecordTitle extends LPageHeader {

  LRecordTitle(LIcon icon) : super(icon) {

  } // LRecordTitle



} // LRecordTitle



class LObjectHome {

}

class LRelatedList {

}


