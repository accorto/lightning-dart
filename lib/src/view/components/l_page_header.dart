/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

class LPageHeader extends LComponent {

  static const String C_PAGE_HEADER = "slds-page-header";

  /// slds-page-header__detail-row - Creates margins around the detail section of record home
  static const String C_PAGE_HEADER__DETAIL_ROW = "slds-page-header__detail-row";

  // TODO changed
  static const String C_MEDIA__REC_HOME = "slds-media--rec-home";
  static const String C_MEDIA__REC_HOME__TITLE = "slds-media--rec-home__title";
  static const String C_MEDIA__REC_HOME__BUTTON = "slds-media--rec-home__button";

  static const String C_PAGE_HEADER__REC_HOME_DETAIL__ROW = "slds-page-header--rec-home__detail-row";

  static const String C_PAGE_HEADER__DETAIL = "slds-page-header__detail";

  /// Page Header
  final DivElement element = new DivElement()
    ..classes.add(C_PAGE_HEADER);

}
// LPageHeader



/**
 * Record Title
 */
class LRecordTitle extends LPageHeader {

  /// Top Row - Icon - Title - Label - Follow - Actions
  final DivElement header = new DivElement()
    ..classes.add(LGrid.C_GRID);

  /// Top row left
  final DivElement headerLeft = new DivElement()
    ..classes.addAll([LGrid.C_COL, LGrid.C_HAS_FLEXI_TRUNCATE]);

  /// Image Div
  final DivElement headerLeftMedia = new DivElement()
    ..classes.add(LMedia.C_MEDIA)
    ..classes.add(LPageHeader.C_MEDIA__REC_HOME);

  /// Figure Image Div
  final DivElement headerLeftMediaFigure = new DivElement()
    ..classes.add(LMedia.C_MEDIA__FIGURE);

  /// Figure Image
  LIcon headerLeftMediaFigureSvg;

  /// Figure Image Div
  final DivElement headerLeftMediaBody = new DivElement()
    ..classes.add(LMedia.C_MEDIA__BODY);

  /// Record Type
  final ParagraphElement headerLeftMediaBodyRecordType = new ParagraphElement()
    ..classes.add(LText.C_TEXT_HEADING__LABEL);
  final HeadingElement headerLeftMediaBodyRecordTitle = new HeadingElement.h1()
    ..classes.addAll([LText.C_TEXT_HEADING__MEDIUM, LPageHeader.C_MEDIA__REC_HOME__TITLE,
  LText.C_TRUNCATE, LGrid.C_ALIGN_MIDDLE]);

  /// Follow Button
  LButtonStateful followButton;

  /// Top row
  final DivElement headerRight = new DivElement()
    ..classes.addAll([LGrid.C_COL, LGrid.C_NO_FLEX, LGrid.C_ALIGN_BOTTOM]);

  /// Detail row
  DivElement detail;

  /**
   * [followButton] optional Follow Button override
   */
  LRecordTitle(LIcon icon, {String recordType, String recordTitle,
      LButtonStateful followButton, LButtonGroup buttonGroup}) {
    // Header Row
    element.append(header);
    // div .slds-col
    // - div .slds-media
    header.append(headerLeft);
    headerLeft.append(headerLeftMedia);
    // -- div .slds-media__figure
    // --- svg
    headerLeftMedia.append(headerLeftMediaFigure);
    headerLeftMediaFigureSvg = icon;
    headerLeftMediaFigure.append(headerLeftMediaFigureSvg.element);
    // -- div .slds-media__body
    // --- p
    // --- div .grid
    // ---- h1
    // ---- div
    // ----- button
    headerLeftMedia.append(headerLeftMediaBody);
    headerLeftMediaBody.append(headerLeftMediaBodyRecordType); // p
    DivElement headerLeftMediaBodyGrid = new DivElement()
      ..classes.add(LGrid.C_GRID);
    headerLeftMediaBody.append(headerLeftMediaBodyGrid);
    headerLeftMediaBodyGrid.append(headerLeftMediaBodyRecordTitle);
    DivElement headerLeftMediaBodyGridBtn = new DivElement()
      ..classes.addAll([LGrid.C_SHRINK_NONE, LGrid.C_ALIGN_BOTTOM]);
    headerLeftMediaBodyGrid.append(headerLeftMediaBodyGridBtn);
    if (followButton == null) {
      this.followButton = new LButtonStateful("follow");
    } else {
      this.followButton = followButton;
    }
    headerLeftMediaBodyGridBtn.append(this.followButton.element);

    // right - actions
    header.append(headerRight);
    if (buttonGroup != null)
      headerRight.append(buttonGroup.element);

    // Values
    if (recordType != null) {
      this.recordType = recordType;
    }
    if (recordTitle != null) {
      headerLeftMediaBodyRecordTitle.title = recordTitle;
      this.recordTitle = recordTitle;
    }
  } // LRecordTitle


  /// Record Type Text
  String get recordType => headerLeftMediaBodyRecordType.text;
  /// Record Type Text
  void set recordType(String newValue) {
    headerLeftMediaBodyRecordType.text = newValue;
  }

  /// Record Title Text
  String get recordTitle => headerLeftMediaBodyRecordTitle.text;
  /// Record Title Text
  void set recordTitle(String newValue) {
    headerLeftMediaBodyRecordTitle.text = newValue;
  }

  void addDetail(String fieldName, String fieldLabel) {
    if (detail == null) {
      detail = new DivElement()
        ..classes.addAll([LGrid.C_GRID, LPageHeader.C_PAGE_HEADER__REC_HOME_DETAIL__ROW]);
      header.append(detail);
    }
    // TODO slds-col--padded slds-size--1-of-4 + dl
  }

  void setDetail(String fieldName, String fieldValue) {

  }

} // LRecordTitle


/**
 * Object Home
 */
class LObjectHome extends LPageHeader {

  /// Top Row - Icon - Title - Label - Follow - Actions
  final DivElement header = new DivElement()
    ..classes.add(LGrid.C_GRID);
  /// Top row left
  final DivElement headerLeft = new DivElement()
    ..classes.addAll([LGrid.C_COL, LGrid.C_HAS_FLEXI_TRUNCATE]);

  final ParagraphElement headerLeftLabel = new ParagraphElement()
    ..classes.add(LText.C_TEXT_HEADING__LABEL);
  final HeadingElement headerLeftGridFocusTitle = new HeadingElement.h1()
    ..classes.addAll([LText.C_TEXT_HEADING__MEDIUM, LText.C_TRUNCATE]);

  /// Top row left
  final DivElement headerRight = new DivElement()
    ..classes.addAll([LGrid.C_COL, LGrid.C_NO_FLEX, LGrid.C_ALIGN_BOTTOM]);

  LObjectHome() {
    // Header Row
    element.append(header);
    // div .slds-col
    // - p
    header.append(headerLeft);
    headerLeft.append(headerLeftLabel);
    // - div .slds-grid
    // -- div .slds-grid focus
    // --- h1
    // --- button
    // -- button more
    // -- button save
    DivElement headerLeftGrid = new DivElement()
      ..classes.add(LGrid.C_GRID);
    headerLeft.append(headerLeftGrid);
    DivElement headerLeftGridFocus = new DivElement()
      ..classes.addAll([LGrid.C_GRID, "slds-type-focus","slds-no-space", LGrid.C_ALIGN_MIDDLE]); // TODO
    headerLeftGrid.append(headerLeftGridFocus);
    headerLeftGridFocus.append(headerLeftGridFocusTitle);
    LButton headerLeftGridFocusFind = new LButton(new ButtonElement(), "find", null,
      buttonClasses: [LButton.C_BUTTON__ICON_BARE, LGrid.C_SHRINK_NONE, LGrid.C_ALIGN_MIDDLE, LMargin.C_LEFT__X_SMALL]);
    headerLeftGridFocus.append(headerLeftGridFocusFind.element);

    LButton headerLeftGridMore = new LButton(new ButtonElement(), "more", null,
      buttonClasses: [LButton.C_BUTTON, LButton.C_BUTTON__ICON_MORE, LGrid.C_SHRINK_NONE, LMargin.C_LEFT__LARGE]);
    headerLeftGrid.append(headerLeftGridMore.element);

    LButton headerLeftGridSave = new LButton(new ButtonElement(), "save", lObjectHomeSave(),
      buttonClasses: [LButton.C_BUTTON, LButton.C_BUTTON__BRAND, "slds-button-space-left", // TODO
        LMargin.C_RIGHT__MEDIUM, LGrid.C_SHRINK_NONE, LGrid.C_ALIGN_MIDDLE, "slds-hide"]);
    headerLeftGrid.append(headerLeftGridSave.element);

    // TODO right side
    header.append(headerRight);

  } // LObjectHome

  /// Record Type Text
  String get recordType => headerLeftLabel.text;
  /// Record Type Text
  void set recordType(String newValue) {
    headerLeftLabel.text = newValue;
  }

  /// Record Title Text
  String get recordTitle => headerLeftGridFocusTitle.text;
  /// Record Title Text
  void set recordTitle(String newValue) {
    headerLeftGridFocusTitle.text = newValue;
  }


  // Trl
  static String lObjectHomeSave() => Intl.message("Save", name: "lObjectHomeSave", args: []);

} // LObjectHome



/**
 * Object Related List
 */
class LRelatedList extends LPageHeader {


  LRelatedList() {
    // nav Breadcrumb
    // div Grid
    // - div left
    // - div right
    // p detail
  }

} // LRelatedList


