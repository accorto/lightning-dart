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
class LRecordHome
    extends LPageHeader {

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
    ..classes.addAll([LPageHeader.C_PAGE_HEADER__TITLE, LMargin.C_RIGHT__SMALL, LText.C_TRUNCATE, LGrid.C_ALIGN_MIDDLE]);
  // Follow Button
  final LButton followButton;

  /// Top row
  final DivElement _headerRight = new DivElement()
    ..classes.addAll([LGrid.C_COL, LGrid.C_NO_FLEX, LGrid.C_ALIGN_BOTTOM]);
  final LButtonGroup _actionButtonGroup = new LButtonGroup();

  //
  UI ui;
  final List<LRecordHomeDetail> _detailList = new List<LRecordHomeDetail>();

  /**
   * Record Home with optional button [followElement]
   * and optional [centerElement] (grid column)
   */
  LRecordHome({LButton this.followButton, Element centerElement, bool wrap:false, String idPrefix}) {
    _initComponent(centerElement, wrap, idPrefix);
  } // LRecordHome

  /// Record Home with Follow Button
  LRecordHome.follow({String idPrefix})
      : this(followButton: new LButtonStateful.follow("follow"), idPrefix: idPrefix);

  /**
   * Record Home from UI [homeIcon] large with padding and color
   * with optional button [followElement] and optional [centerElement]
   */
  LRecordHome.from(UI this.ui, {LIcon homeIcon, LButton this.followButton, Element centerElement, bool wrap:false, String idPrefix}) {
    _initComponent(centerElement, wrap, idPrefix);
    element.attributes[Html0.DATA_VALUE] = ui.tableName;
    DTable table = ui.table;
    // image
    if (homeIcon != null) {
      this.icon = homeIcon;
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
        ..classes.addAll([LGrid.C_GRID, LPageHeader.C_PAGE_HEADER__DETAIL_ROW]);
      element.append(detail);

      for (UIQueryColumn qc in ui.queryColumnList) {
        String columnName = qc.columnName;
        UIGridColumn gc = UiUtil.findGridColumn(ui, columnName);
        UIPanelColumn pc = UiUtil.findPanelColumn(ui, columnName, gc);
        DataColumn dataColumn = new DataColumn(ui.table, qc.column, pc, gc);
        if (dataColumn.tableColumn.displaySeqNo > 0)
          continue; // already displayed
        String label = qc.columnLabel;
        if (label.isEmpty)
          label = dataColumn.label;
        LRecordHomeDetail d = new LRecordHomeDetail(columnName, label, dataColumn);
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
  void _initComponent(Element centerElement, bool wrap, String idPrefix) {
    element.id = LComponent.createId(idPrefix, "home");
    // Header Row
    element.append(_header);
    // div .slds-col
    // - div .slds-media
    _header.append(_headerLeft);
    // Left: record type, title and follow button
    _headerLeft.append(_headerLeftMedia.element);
    _headerLeftRecordType.id = "${idPrefix}-record-type";
    _headerLeftMedia.append(_headerLeftRecordType);
    DivElement leftGrid = new DivElement()
      ..classes.add(LGrid.C_GRID);
    _headerLeftMedia.append(leftGrid);
    _headerLeftRecordTitle.id = "${idPrefix}-record-title";
    leftGrid.append(_headerLeftRecordTitle);
    if (followButton != null) {
      DivElement followDiv = new DivElement()
        ..classes.addAll([LGrid.C_SHRINK_NONE, LGrid.C_ALIGN_BOTTOM]);
      leftGrid.append(followDiv);
      followDiv.append(followButton.element);
    }
    if (centerElement != null) {
      centerElement.classes.addAll([LGrid.C_COL, LGrid.C_NO_FLEX, LGrid.C_ALIGN_BOTTOM, LMargin.C_RIGHT__SMALL]);
      _header.append(centerElement);
    }
    // right - actions
    _header.append(_headerRight);
    _headerRight.append(_actionButtonGroup.element);
    //
    if (wrap) {
      _header.classes.add(LGrid.C_WRAP);
      _headerLeft.classes.remove(LGrid.C_HAS_FLEXI_TRUNCATE);
      _header.style.justifyContent = "flex-end";
    }
  } // initComponent

  /// Set Icon
  void set icon (LIcon icon) {
    icon.size = LIcon.C_ICON__LARGE;
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
    _headerLeftRecordTitle.title = newValue;
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
    _actionButtonGroup.addAction(action, id);
  }

  /// Show Action Group Buttons
  void set showActions (bool newValue) {
    if (newValue) {
      _actionButtonGroup.classes.add(LVisibility.C_HIDE);
    } else {
      _actionButtonGroup.classes.remove(LVisibility.C_HIDE);
    }
  }

  /// Action Group Show Count
  void actionGroupLayout(int showCount) {
    _actionButtonGroup.layout(showCount);
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
    _headerLeftRecordTitle.title = _record.who;
    //
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
  final DataColumn dataColumn;
  LEditor _editor;

  /// Record Home Detail
  LRecordHomeDetail(String this.columnName, String label, DataColumn this.dataColumn) {
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
    //
    _editor = EditorUtil.createFromColumn(columnName, dataColumn, true);
  } // LRecordHomeDetail

  /// Display Value
  void display(DRecord record) {
    _dd.children.clear();
    for (DEntry entry in record.entryList) {
      if (columnName == entry.columnName) {
        _display(entry);
        return;
      }
    }
    // no value
    _dd.attributes[Html0.DATA_VALUE] = "";
    _dd.append(new ParagraphElement());
  } // display

  /// display header details
  void _display(DEntry entry) {
    String value = DataRecord.getEntryValue(entry);
    if (value == null || value.isEmpty) {
      _dd.attributes[Html0.DATA_VALUE] = "";
    } else {
      _dd.attributes[Html0.DATA_VALUE] = value;
      if (_editor.isValueRenderElement) {
        _dd.append(_editor.getValueRenderElement(value));
      } else {
        // show value
        ParagraphElement pp = new ParagraphElement()
          ..classes.add(LText.C_TEXT_BODY__REGULAR)
          ..classes.add(LText.C_TRUNCATE);
        _dd.append(pp);
        pp.text = value;
        // show display value
        if (_editor.isValueDisplay) {
          _editor.render(value, false)
              .then((String display) {
            pp.text = display;
            entry.valueDisplay = display;
          });
        }
      }
    }
  } // display

} // LRecordHomeDetail
