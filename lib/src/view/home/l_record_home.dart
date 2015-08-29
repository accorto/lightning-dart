/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Record Home
 */
class LRecordHome extends LPageHeader {

  /// Top Row - Icon - Title - Label - Follow - Actions
  final DivElement _header = new DivElement()
    ..classes.add(LGrid.C_GRID);

  /// Top row left
  final DivElement _headerLeft = new DivElement()
    ..classes.addAll([LGrid.C_COL, LGrid.C_HAS_FLEXI_TRUNCATE]);
  /// Media
  final LMedia _headerLeftMedia = new LMedia();
  /// Record Type
  final ParagraphElement _headerLeftRecordType = new ParagraphElement()
    ..classes.add(LText.C_TEXT_HEADING__LABEL);
  final HeadingElement _headerLeftRecordTitle = new HeadingElement.h1()
    ..classes.addAll([LText.C_TEXT_HEADING__MEDIUM, LMargin.C_RIGHT__SMALL, LText.C_TRUNCATE, LGrid.C_ALIGN_MIDDLE]);
  // Follow Button
  final LButtonStateful followButton = new LButtonStateful("follow");

  /// Top row
  final DivElement _headerRight = new DivElement()
    ..classes.addAll([LGrid.C_COL, LGrid.C_NO_FLEX, LGrid.C_ALIGN_BOTTOM]);
  final LButtonGroup _actionButtonGroup = new LButtonGroup();


  /// Detail row
  DivElement detail;

  /**
   * Record Home
   */
  LRecordHome() {
    _initComponent();
  } // LRecordHome

  /// Record Home from UI
  LRecordHome.ui(UI ui) {
    _initComponent();
    DTable table = ui.table;
    // image
    String iconImage = table.iconImage;
    if (iconImage != null && iconImage.isNotEmpty) {
      if (iconImage.startsWith(LIconStandard.C_ICON_STANDARD_)) {
        String linkName = iconImage.substring(LIconStandard.C_ICON_STANDARD_.length);
        icon = new LIconStandard(linkName, size: LIcon.C_ICON__LARGE);
      }
    }
    // record type
    recordType = table.label;
  } // LRecordHome.ui

  /// Initialize Component Structure
  void _initComponent() {
    // Header Row
    element.append(_header);
    // div .slds-col
    // - div .slds-media
    _header.append(_headerLeft);
    // Left: record type, title and follow button
    _headerLeft.append(_headerLeftMedia.element);
    _headerLeftMedia.append(_headerLeftRecordType);
    DivElement leftGrid = new DivElement()
      ..classes.add(LGrid.C_GRID);
    _headerLeftMedia.append(leftGrid);
    leftGrid.append(_headerLeftRecordTitle);
    DivElement followDiv = new DivElement()
      ..classes.addAll([LGrid.C_SHRINK_NONE, LGrid.C_ALIGN_BOTTOM]);
    leftGrid.append(followDiv);
    followDiv.append(followButton.element);

    // right - actions
    _header.append(_headerRight);
    _headerRight.append(_actionButtonGroup.element);
  } // initComponent

  /// Set Icon
  void set icon (LIcon icon) {
    _headerLeftMedia.setIcon(icon);
  }
  /// Record Type Text
  String get recordType => _headerLeftRecordType.text;
  /// Record Type Text
  void set recordType(String newValue) {
    _headerLeftRecordType.text = newValue;
  }

  /// Record Title Text
  String get recordTitle => _headerLeftRecordTitle.text;
  /// Record Title Text
  void set recordTitle(String newValue) {
    _headerLeftRecordTitle.text = newValue;
  }

  /// insert before Actions
  void insertElement(Element div) {
    _header.insertBefore(div, _headerRight);
  }


  /**
   * Add Actions
   */
  void addAction(LButton action) {
    _actionButtonGroup.add(action);
  }

  void set record (DRecord newValue) {
    recordTitle = newValue.drv;
    // set Details


  } // setData




  void addDetail(String fieldName, String fieldLabel) {
    if (detail == null) {
      detail = new DivElement()
        ..classes.addAll([LGrid.C_GRID, LPageHeader.C_PAGE_HEADER__REC_HOME_DETAIL__ROW]);
      _header.append(detail);
    }
    // TODO slds-col--padded slds-size--1-of-4 + dl
  }

  void setDetail(String fieldName, String fieldValue) {

  }

} // LRecordHome

