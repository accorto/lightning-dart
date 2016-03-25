/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * (Individual) Record Home
 * - icon  | recordType/recordTitle | follow | center | actions
 * - fieldLabel1/fieldValue1 | ..
 * header element has data-id/value/name (from record)
 */
class LRecordHome
    extends LPageHome {

  //
  UI ui;
  final List<LRecordHomeDetail> _detailList = new List<LRecordHomeDetail>();

  /**
   * Record Home with optional button [followElement]
   * e.g. new LButtonStateful.follow("follow").element
   */
  LRecordHome(String idPrefix,
        {Element followElement, bool wrap:true})
      : super(idPrefix, followElement:followElement, wrap:wrap) {
  } // LRecordHome

  /**
   * Record Home from UI [homeIcon] large with padding and color
   * with optional button [followElement] and optional [centerElement]
   */
  LRecordHome.from(String idPrefix, UI this.ui,
        {LIcon homeIcon, Element followElement, bool wrap:true})
      : super(idPrefix, followElement:followElement, wrap:wrap) {
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
    _recordTitle.title = _record.who;
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
