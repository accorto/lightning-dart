/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * CardPanel a "table" with columns of cards (records)
 * - User selects, which pick/select column is used for column (e.g. status)
 * - User can drag/drop cards between columns updating the value
 */
class CardPanel
    extends LComponent {

  static final Logger _log = new Logger("CardPanel");

  static const String C_CPANEL = "cpanel";
  static const String C_CPANEL_COLUMN = "cpanel-column";


  /// the card panel
  final Element element = new Element.section()
    ..classes.add(C_CPANEL);
  final Element _header = new Element.header()
    ..classes.add(LText.C_TEXT_ALIGN__RIGHT);
  /// Column Selector
  LPicklist _groupPicklist;
  /// Show All Columns
  LCheckbox _showEmptyColumns;

  /// Content Wrapper
  final Element _content = new Element.div()
    ..classes.add(LGrid.C_GRID);
  /// panel column list
  final List<CardPanelColumn> _panelColumnList = new List<CardPanelColumn>();


  /// Record Sort List
  final List<DRecord> recordList = new List<DRecord>();

  final String idPrefix;
  /// Record action (click on drv)
  AppsActionTriggered recordAction;

  /**
   * Card Panel
   */
  CardPanel(String this.idPrefix) {
    element.id = LComponent.createId(idPrefix, "cpanel");
    element.append(_header);
    Element wrapper = new Element.div()
      ..classes.add(LScrollable.C_SCROLLABLE__X)
      ..append(_content);
    element.append(wrapper);

    LForm form = new LForm.inline("form", idPrefix:idPrefix)
      ..formRecordChange = onFormRecordChange;
    _header.append(form.element);

    _groupPicklist = new LPicklist("group", idPrefix:idPrefix)
      ..label = cardPanelGroupBy()
      ..title = cardPanelGroupByTitle()
      ..placeholder = cardPanelGroupByTitle()
      ..small = true;
    form.addEditor(_groupPicklist);

    _showEmptyColumns = new LCheckbox("empty", idPrefix: idPrefix)
      ..label = cardPanelShowEmpty()
      ..title = cardPanelShowEmptyTitle()
      ..checked = true;
    form.addEditor(_showEmptyColumns);
  } // CardPanel


  /// Add Column Group Option
  void addGroupOption(DOption option) {
    _groupPicklist.addDOption(option);
  }

  /// Set UI
  void setUi(UI ui) {
    _ui = ui;

    _groupPicklist.clearOptions();
    for (DColumn col in _ui.table.columnList) {
      if (DataTypeUtil.isPick(col.dataType)) {
        DOption option = new DOption()
            ..value = col.name
            ..label = col.label;
        if (col.hasColumnId())
          option.id = col.columnId;
        addGroupOption(option);
      }
    }

  } // setUI
  /// UI Meta Data
  UI _ui;
  /// overwrite for fixed ui
  UI get ui => _ui;

  /// parameter changed
  void onFormRecordChange(DRecord record, DEntry columnChanged, int rowNo) {
    if (columnChanged.columnName == "group") {
      display();
    } else {
      onShowEmptyColumnsChange();
    }
  }

  /// Show All Columns Changed
  void onShowEmptyColumnsChange() {
    bool all = _showEmptyColumns.checked;
    _log.config("onShowEmptyColumnsChange ${all}");
    for (CardPanelColumn pcolumn in _panelColumnList) {
      if (pcolumn.isOtherColumn)
        pcolumn.show = pcolumn.cardList.isNotEmpty;
      else
        pcolumn.show = all || pcolumn.cardList.isNotEmpty;
    }
  }

  /// Set Records - [recordAction] click on drv/urv
  void setRecords(List<DRecord> records, {AppsActionTriggered recordAction}) {
    recordList.clear();
    recordList.addAll(records);
    this.recordAction = recordAction;
    display();
  } // setRecords

  /**
   * Display
   */
  void display() {
    String columnName = _groupPicklist.value;
    if (columnName == null || columnName.isEmpty)
      return;

    _content.children.clear();
    _panelColumnList.clear();

    // get options from table column
    DTable table = null;
    if (_ui != null) {
      table = _ui.table;
      DColumn column = DataUtil.getTableColumn(table, columnName);
      for (DOption option in column.pickValueList) {
        _addColumn( new CardPanelColumn(option.value, option.label, idPrefix:idPrefix));
      }
    }
    // get options from records
    if (_panelColumnList.isEmpty) {
      Set<String> values = new Set<String>();
      for (DRecord record in recordList) {
        String value = DataRecord.getColumnValue(record, columnName);
        if (value != null && value.isNotEmpty)
          values.add(value);
      }
      for (String value in values) {
        _addColumn(new CardPanelColumn(value, value, idPrefix:idPrefix));
      }
    }
    _log.config("display columns=${_panelColumnList.length}");
    CardPanelColumn otherColumn = new CardPanelColumn("other-values",
        cardPanelOthers(), idPrefix:idPrefix, isOtherColumn: true);
    _addColumn(otherColumn);


    /// Add Records to Columns
    for (DRecord record in recordList) {
      DataRecord data = new DataRecord(table, null, value: record);
      String columnValue = data.getValue(name:columnName);
      LCardCompactEntry card;
      for (CardPanelColumn pcolumn in _panelColumnList) {
        if (pcolumn.value == columnValue) {
          card = pcolumn.addRecord(record, recordAction);
          break;
        }
      }
      if (card == null) {
        card = otherColumn.addRecord(record, recordAction);
      }
      if (_ui == null) {
        card.displayRecord();
      } else {
        card.display(_ui, useQueryColumnList: true);
      }
    }

    if (!_showEmptyColumns.checked) {
      for (CardPanelColumn pcolumn in _panelColumnList) {
        pcolumn.show = pcolumn.cardList.isNotEmpty;
      }
    }
    // remove others if empty
    if (otherColumn.cardList.isEmpty) {
      otherColumn.element.remove();
    } else {
      otherColumn.show = true;
    }
  } // display

  void _addColumn(CardPanelColumn pcolumn) {
    _content.append(pcolumn.element);
    _panelColumnList.add(pcolumn);
  }


  static String cardPanelGroupBy() => Intl.message("Group by", name: "cardPanelGroupBy");
  static String cardPanelGroupByTitle() => Intl.message("select a column to group records", name: "cardPanelGroupByTitle");

  static String cardPanelShowEmpty() => Intl.message("Show empty", name: "cardPanelShowEmpty");
  static String cardPanelShowEmptyTitle() => Intl.message("Show empty columns", name: "cardPanelShowEmptyTitle");

  static String cardPanelOthers() => Intl.message("Other values", name: "cardPanelOthers");

} // CardPanel
