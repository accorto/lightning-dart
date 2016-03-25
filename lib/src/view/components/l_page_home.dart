/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Flexible Page Header
 * -icon | recordType/recordTitle | column(s) | action
 */
class LPageHome
    extends LPageHeader {

  final String idPrefix;

  Element _firstLine = new DivElement()
    ..classes.add(LGrid.C_GRID);
  /// Media
  final LMedia _media = new LMedia();
  /// Record Type
  final ParagraphElement _recordType = new ParagraphElement()
    ..classes.add(LText.C_TEXT_HEADING__LABEL);
  /// Record Title
  final HeadingElement _recordTitle = new HeadingElement.h1()
    ..classes.addAll([LPageHeader.C_PAGE_HEADER__TITLE, LMargin.C_RIGHT__SMALL, LText.C_TRUNCATE, LGrid.C_ALIGN_MIDDLE]);
  /// Action Buttons
  LButtonGroup _actionButtonGroup;
  /// Header Info
  ParagraphElement _info;

  /**
   * Page Header Home
   */
  LPageHome(String this.idPrefix, {Element followElement, bool wrap:true}) {
    element.id = LComponent.createId(idPrefix, "home");
    // first line
    element.append(_firstLine);

    // - media with icon | recordType/recordTitle
    _recordType.id = LComponent.createId(idPrefix, "record-type");
    _media.append(_recordType);

    _recordTitle.id = LComponent.createId(idPrefix, "record-title");
    DivElement mediaGrid = new DivElement()
      ..classes.add(LGrid.C_GRID)
      ..append(_recordTitle);
    _media.append(mediaGrid);
    if (followElement != null) {
      Element buttonWrap = new DivElement()
          ..classes.addAll([LGrid.C_COL, LGrid.C_SHRINK_NONE])
          ..append(followElement);
      mediaGrid.append(buttonWrap);
    }

    Element mediaWrap = new DivElement()
      ..classes.addAll([LGrid.C_COL, LGrid.C_HAS_FLEXI_TRUNCATE])
      ..append(_media.element);
    _firstLine.append(mediaWrap);

    if (wrap) {
      _firstLine.classes.add(LGrid.C_WRAP);
      mediaWrap.classes.remove(LGrid.C_HAS_FLEXI_TRUNCATE);
      _firstLine.style.justifyContent = "flex-end";
    }
  } // LPageHome

  /// set Page Header Icon
  void set icon (LIcon icon) {
    icon.size = LIcon.C_ICON__LARGE;
    _media.setIcon(icon);
  }

  /// set Page Header Record Type
  void set recordType (String newValue) {
    _recordType.text = newValue;
    _recordType.title = newValue;
  }
  String get recordType => _recordType.text;

  // set Page Header Title (h1)
  void set recordTitle (String newValue) {
    _recordTitle.text = newValue;
    _recordTitle.title = newValue;
  }
  String get recordTitle => _recordTitle.text;

  /// add (padded) column to first line
  void addColumn (Element column,
      {String columnClass : LGrid.C_COL__PADDED}) {
    if (columnClass != null && columnClass.isNotEmpty)
      column.classes.add(columnClass);
    _firstLine.children.last.classes.add(LMargin.C_BOTTOM__X_SMALL);
    _firstLine.append(column);
  } // addColumn

  /**
   * Add Button Group (set after columns)
   * (alignBottom if there is a follow button)
   */
  void addActionGroup({bool alignBottom: false}) {
    if (_actionButtonGroup == null) {
      _actionButtonGroup = new LButtonGroup();
      Element wrap = new DivElement()
        ..classes.addAll([LGrid.C_COL, LGrid.C_NO_FLEX])
        ..append(_actionButtonGroup.element);
      if (alignBottom)
        wrap.classes.add(LGrid.C_ALIGN_BOTTOM);
      if (_firstLine.children.length > 1)
        _firstLine.children.last.classes.add(LMargin.C_BOTTOM__X_SMALL);
      _firstLine.append(wrap);
    }
  } // addActionGroup

  /// Add Action
  void addAction(AppsAction action) {
    if (_actionButtonGroup == null)
      addActionGroup();
    _actionButtonGroup.addAction(action, id);
  }

  /// Add Action Button
  void addActionButton(LButton btn) {
    if (_actionButtonGroup == null)
      addActionGroup();
    _actionButtonGroup.addButton(btn);
  }

  /// Show Action Group Buttons
  void set showActions (bool newValue) {
    if (_actionButtonGroup != null) {
      _actionButtonGroup.classes.toggle(LVisibility.C_HIDE, !newValue);
    }
  }

  /// Action Group Show Count
  void actionGroupLayout(int showCount) {
    if (_actionButtonGroup != null) {
      _actionButtonGroup.layout(showCount);
    }
  }

  /// header info
  void set info (String newValue) {
    if (_info == null) {
      _info = new ParagraphElement()
          ..classes.addAll([LText.C_TEXT_BODY__SMALL, LPageHeader.C_PAGE_HEADER__INFO]);
      element.append(_info);
    }
    _info.text = newValue;
  } // setInfo

} // LPageHome
