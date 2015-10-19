/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Record Home
 *
 * header element has data-id/value/name (from record)
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

  //
  UI ui;
  final List<LRecordHomeDetail> _detailList = new List<LRecordHomeDetail>();

  /**
   * Record Home
   */
  LRecordHome({bool withFollow:true}) {
    _initComponent(withFollow);
  } // LRecordHome

  /// Record Home from UI
  LRecordHome.from(UI this.ui, {LIcon icon, bool withFollow:true}) {
    _initComponent(withFollow);
    DTable table = ui.table;
    // image
    if (icon != null) {
      this.icon = icon;
    } else {
      String iconImage = table.iconImage;
      if (iconImage != null && iconImage.isNotEmpty) {
        if (iconImage.startsWith(LIconStandard.C_ICON_STANDARD_)) {
          String linkName = iconImage.substring(LIconStandard.C_ICON_STANDARD_.length);
          this.icon = new LIconStandard(linkName, size: LIcon.C_ICON__LARGE);
        }
      }
    }
    // record type
    recordType = table.label;

    // Details
    if (ui.queryColumnList.isNotEmpty) {
      DivElement detail = new DivElement()
        ..classes.addAll([LGrid.C_GRID, LPageHeader.C_PAGE_HEADER__DETAIL__ROW]);
      element.append(detail);

      for (UIQueryColumn qc in ui.queryColumnList) {
        String columnName = qc.columnName;
        String label = qc.columnLabel;
        LRecordHomeDetail d = new LRecordHomeDetail(columnName, label, qc.column);
        _detailList.add(d);
        DivElement div = new DivElement()
          ..classes.add(LGrid.C_COL__PADDED)
          ..classes.add(LSizing.size1ofY(ui.queryColumnList.length));
        div.append(d.element);
        detail.append(div);
      }
    }
  } // LRecordHome.ui

  /// Initialize Component Structure
  void _initComponent(bool withFollow) {
    element.id = "rec-home"; // LComponent.createId("rec-home", null);
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
    if (withFollow) {
      DivElement followDiv = new DivElement()
        ..classes.addAll([LGrid.C_SHRINK_NONE, LGrid.C_ALIGN_BOTTOM]);
      leftGrid.append(followDiv);
      followDiv.append(followButton.element);
    }
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
  void addAction(AppsAction action) {
    LButton btn = action.asButton(true);
    _actionButtonGroup.add(btn);
  }

  /// current record
  DRecord get record => _record;
  /// set record and display
  void set record (DRecord newValue) {
    _record = newValue;
    element.attributes[Html0.DATA_ID] = _record.recordId;
    element.attributes[Html0.DATA_VALUE] = _record.urv;
    element.attributes[Html0.DATA_LABEL] = _record.drv;
    element.attributes[Html0.DATA_NAME] = _record.tableName;
    display();
  } // setData
  DRecord _record;

  /// Display data
  void display() {
    if (_record.hasDrv()) {
      recordTitle = _record.drv;
    } else if (ui != null) {
      recordTitle = ui.label;
    }
    for (LRecordHomeDetail detail in _detailList) {
      detail.display(_record);
    }
  } // display

} // LRecordHome



/// Record Home Detail
class LRecordHomeDetail {

  /// List Element
  DListElement element = new DListElement();
  /// Value Element
  final Element _dd = new Element.tag('dd');

  final String columnName;
  final DColumn column;

  /// Record Home Detail
  LRecordHomeDetail(String this.columnName, String label, DColumn this.column) {
    ParagraphElement p = new ParagraphElement()
      ..classes.add(LText.C_TEXT_HEADING__LABEL)
      ..classes.add(LText.C_TRUNCATE)
      ..text = label
      ..title = label;
    Element dt = new Element.tag('dt')
      ..append(p);
    element.append(dt);
    _dd.attributes[Html0.DATA_NAME] = columnName;
    element.append(_dd);
  }

  /// Display Value
  void display(DRecord record) {
    _dd.children.clear();
    for (DEntry entry in record.entryList) {
      if (columnName == entry.columnName) {
        _display(entry);
        return;
      }
    }
    _dd.attributes[Html0.DATA_VALUE] = "";
    _dd.append(new ParagraphElement());
  } // display

  void _display(DEntry entry) {
    String value = null;
    if (entry.hasValue())
      value = entry.value;
    else if (entry.hasValueOriginal())
      value = entry.valueOriginal;
    if (value == DataRecord.NULLVALUE)
      value = null;

    ParagraphElement p = new ParagraphElement()
      ..classes.add(LText.C_TEXT_BODY__REGULAR)
      ..classes.add(LText.C_TRUNCATE);
    _dd.append(p);
    if (value == null) {
      _dd.attributes[Html0.DATA_VALUE] = "";
    } else {
      _dd.attributes[Html0.DATA_VALUE] = value;
      String display = value;
      if (entry.hasValueDisplay())
        display = entry.valueDisplay;
      p.text = display;
    }
  } // display

} // LRecordHomeDetail
