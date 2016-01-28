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

  /// the card panel
  final DivElement element = new DivElement();
  final DivElement _header = new DivElement();
  /// Column Selector
  LPicklist _columnPicklist;
  /// Show All Columns
  LCheckbox _showAllColumns;

  /// Content Wrapper
  final DivElement _wrapper = new DivElement()
    ..classes.add(LScrollable.C_SCROLLABLE__X);
  /// panel column list
  final List<CardPanelColumn> _panelColumnList = new List<CardPanelColumn>();


  /// Record Sort List
  final List<DRecord> recordList = new List<DRecord>();
  /// Record action (click on drv)
  AppsActionTriggered recordAction;

  final String idPrefix;

  /**
   * Card Panel
   */
  CardPanel(String this.idPrefix) {
    element.id = LComponent.createId(idPrefix, "cpanel");
    element.append(_header);
    element.append(_wrapper);

    _columnPicklist = new LPicklist("col-select", idPrefix:idPrefix)
      ..label = "Column Selector"
      ..placeholder = "select a column to organize the records";
    _columnPicklist.editorChange = onColumnSelectChange;
    _header.append(_columnPicklist.element);

    _showAllColumns = new LCheckbox("all-columns", idPrefix: idPrefix)
      ..label = "Show all columns"
      ..checked = true;
    _showAllColumns.editorChange = onAllColumnsChange;
    _header.append(_showAllColumns.element);


  } // CardPanel


  void addColumnSelectOption(DOption option) {
    _columnPicklist.addDOption(option);
  }


  void addColumn(CardPanelColumn pcolumn) {
    _wrapper.append(pcolumn.element);
    _panelColumnList.add(pcolumn);
  }

  /// Set UI
  void setUi(UI ui) {
    _ui = ui;

    _columnPicklist.clearOptions();
    for (DColumn col in _ui.table.columnList) {
      if (DataTypeUtil.isPick(col.dataType)) {
        DOption option = new DOption()
            ..value = col.name
            ..label = col.label;
        if (col.hasColumnId())
          option.id = col.columnId;
        addColumnSelectOption(option);
      }
    }

  } // setUI
  /// UI Meta Data
  UI _ui;
  /// overwrite for fixed ui
  UI get ui => _ui;

  /// Column Select Change
  void onColumnSelectChange(String name, String columnName, DEntry entry, var details) {
    display();
  } // onColumnSelectChange

  /// Show All Columns Changed
  void onAllColumnsChange(String name, String columnName, DEntry entry, var details) {
    bool all = _showAllColumns.checked;
    for (CardPanelColumn pcolumn in _panelColumnList) {
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
    String columnName = _columnPicklist.value;
    if (columnName == null || columnName.isEmpty)
      return;

    _wrapper.children.clear();
    _panelColumnList.clear();

    // get options from table column
    if (_ui != null) {
      DColumn column = DataUtil.getTableColumn(_ui.table, columnName);
      for (DOption option in column.pickValueList) {
        CardPanelColumn pcolumn = new CardPanelColumn(option.value, option.label, idPrefix:idPrefix);
        addColumn(pcolumn);
      }
    }
    // get options from records
    if (_panelColumnList.isEmpty) {
      for (DRecord record in recordList) {

      }
    }

    CardPanelColumn otherColumn = new CardPanelColumn("otherValues", "Other Values", idPrefix:idPrefix);
    addColumn(otherColumn);


    /// Add Records to Columns
    for (DRecord record in recordList) {
      DataRecord data = new DataRecord(null, value: record);
      String columnValue = data.getValue(name:columnName);
      bool found = false;
      for (CardPanelColumn pcolumn in _panelColumnList) {
        if (pcolumn.value == columnValue) {
          pcolumn.addData(data);
          found = true;
          break;
        }
      }
      if (!found) {
        otherColumn.addData(data);
      }
    }

    if (_showAllColumns.checked) {
      for (CardPanelColumn pcolumn in _panelColumnList) {
        pcolumn.show = pcolumn.cardList.isNotEmpty;
      }
    }
  } // display

} // CardPanel
