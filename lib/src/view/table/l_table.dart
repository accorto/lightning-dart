/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/// Sort Clicked
typedef void TableSortClicked(String name, bool asc, MouseEvent evt);

/// Table Sorted
typedef void TableSorted(List<LTableSort> tableSorting);

/**
 * Table
 */
class LTable extends LComponent {

  /// slds-table - Initializes data table | Required
  static const String C_TABLE = "slds-table";
  /// slds-table--bordered - Adds borders to the table |
  static const String C_TABLE__BORDERED = "slds-table--bordered";
  /// slds-table--striped - Adds stripes to alternating rows |
  static const String C_TABLE__STRIPED = "slds-table--striped";
  /// slds-is-selected - Changes row to selected state |
  static const String C_IS_SELECTED = "slds-is-selected";
  /// slds-is-sortable - Enables user interactions for sorting a column |
  static const String C_IS_SORTABLE = "slds-is-sortable";
  /// slds-cell-wrap - Forces text to wrap in a cell |
  static const String C_CELL_WRAP = "slds-cell-wrap";
  /// slds-cell-shrink - Shrinks cell to width of content |
  static const String C_CELL_SHRINK = "slds-cell-shrink";
  /// slds-no-row-hover - Removes hover state on row |
  static const String C_NO_ROW_HOVER = "slds-no-row-hover";
  /// slds-max-medium-table--stacked - Modifies table layout to accommodate smaller viewports |
  static const String C_MAX_MEDIUM_TABLE__STACKED = "slds-max-medium-table--stacked";
  /// slds-max-medium-table--stacked-horizontal - Modifies table layout to accommodate smaller viewports |
  static const String C_MAX_MEDIUM_TABLE__STACKED_HORIZONTAL = "slds-max-medium-table--stacked-horizontal";
  /// slds-hint-parent - Highlights action overflow ribbons on row hover |
  static const String C_HINT_PARENT = "slds-hint-parent";

  static const String C_ROW_SELECT = "slds-row-select";
  static const String C_ROW_ACTION = "slds-row-action";

  static const String URV = "urv";

  /// Table Edit Mode - Read Only
  static const String EDIT_RO = "ro";
  /// Table Edit Mode - Field Click
  static const String EDIT_FIELD = "field";
  /// Table Edit Mode - Selected Rows
  static const String EDIT_SEL = "sel";
  /// Table Edit Mode - All Rows
  static const String EDIT_ALL = "all";

  static final Logger _log = new Logger("LTable");


  /// Table Element
  final TableElement element = new TableElement()
    ..classes.add(C_TABLE);

  TableSectionElement _thead;
  TableSectionElement _tbody;
  TableSectionElement _tfoot;
  final List<LTableHeaderRow> _theadRows = new List<LTableHeaderRow>();
  final List<LTableRow> _tbodyRows = new List<LTableRow>();
  final List<LTableRow> _tfootRows = new List<LTableRow>();


  /// Column Name-Label Map - required for responsive
  final Map<String,String> nameLabelMap = new Map<String,String>();
  /// Name list by column #
  final List<String> nameList = new List<String>();

  /// Actions
  List<AppsAction> _tableActions = new List<AppsAction>();
  List<AppsAction> _rowActions = new List<AppsAction>();

  /// Record Sort List
  final List<DRecord> recordList = new List<DRecord>();
  /// Record action (click on drv)
  AppsActionTriggered recordAction;

  /// Row Select
  final bool optionRowSelect;

  /// Table Sorting
  final List<LTableSort> tableSorting = new List<LTableSort>();
  /// Callback
  TableSorted tableSorted;

  /**
   * Table
   */
  LTable(String idPrefix, {bool this.optionRowSelect:true}) {
    element.id = idPrefix == null || idPrefix.isEmpty ? LComponent.createId("table", null) : idPrefix;
  }

  /// scrollable-x wrapper with table
  CDiv responsiveOverflow() {
    CDiv wrapper = new CDiv()
      ..classes.add(LScrollable.C_SCROLLABLE__X);
    wrapper.append(element);
    return wrapper;
  }

  /// Responsive Stacked
  bool get responsiveStacked => element.classes.contains(C_MAX_MEDIUM_TABLE__STACKED);
  void set responsiveStacked (bool newValue) {
    element.classes.remove(C_MAX_MEDIUM_TABLE__STACKED_HORIZONTAL);
    if (newValue)
      element.classes.add(C_MAX_MEDIUM_TABLE__STACKED);
    else
      element.classes.remove(C_MAX_MEDIUM_TABLE__STACKED);
  }
  /// Responsive Stacked Horizontal
  bool get responsiveStackedHorizontal => element.classes.contains(C_MAX_MEDIUM_TABLE__STACKED_HORIZONTAL);
  void set responsiveStackedHorizontal (bool newValue) {
    element.classes.remove(C_MAX_MEDIUM_TABLE__STACKED);
    if (newValue)
      element.classes.add(C_MAX_MEDIUM_TABLE__STACKED_HORIZONTAL);
    else
      element.classes.remove(C_MAX_MEDIUM_TABLE__STACKED_HORIZONTAL);
  }

  /// Table bordered
  bool get bordered => element.classes.contains(C_TABLE__BORDERED);
  /// Table bordered
  void set bordered (bool newValue) {
    element.classes.remove(C_TABLE__STRIPED);
    if (newValue) {
      element.classes.add(C_TABLE__BORDERED);
    } else {
      element.classes.remove(C_TABLE__BORDERED);
    }
  }
  /// Table striped
  bool get striped => element.classes.contains(C_TABLE__STRIPED);
  /// Table striped
  void set striped (bool newValue) {
    element.classes.remove(C_TABLE__BORDERED);
    if (newValue) {
      element.classes.add(C_TABLE__STRIPED);
    } else {
      element.classes.remove(C_TABLE__STRIPED);
    }
  }

  /**
   * Add Table Head Row
   * for responsive - use row.addHeaderCell to add name-label info
   */
  LTableHeaderRow addHeadRow(bool enableSort, {bool primary:true}) {
    if (_thead == null)
      _thead = element.createTHead();
    LTableHeaderRow row = null;
    if (primary) {
      row = new LTableHeaderRow(_thead.addRow(), _theadRows.length, id,
        LText.C_TEXT_HEADING__LABEL, optionRowSelect, nameList, nameLabelMap,
        enableSort ? onTableSortClicked : null, _tableActions, dataColumns);
      if (optionRowSelect && _theadRows.isEmpty) {
        row.selectCb.onClick.listen((MouseEvent evt) {
          selectAll(row.selectCb.checked);
        });
      }
    } else {
      row = new LTableRow(_thead.addRow(), _tbodyRows.length, id, null,
        LText.C_TEXT_HEADING__LABEL, optionRowSelect, nameList, nameLabelMap, LTableRow.TYPE_HEAD, null, dataColumns);
    }
    _theadRows.add(row);
    // add urv
    if (_ui != null) {
      row.addHeaderCell(URV, _ui.table.label);
    }
    return row;
  } // addHeadRow

  /// Table Sort
  void onTableSortClicked(String name, bool asc, MouseEvent evt) {
    bool shiftMeta = (evt.shiftKey || evt.metaKey);
    _log.info("onTableSortClicked ${name} ${asc} shiftMeta=${shiftMeta}");
    if (shiftMeta) {
      LTableSort sortFound = null;
      for (LTableSort sort in tableSorting) {
        if (sort.columnName == name) {
          sortFound = sort;
          break;
        }
      }
      if (sortFound != null)
        tableSorting.remove(sortFound);
    } else {
      tableSorting.clear();
    }
    tableSorting.add(new LTableSort(name, asc)..setLabel(_ui.table));
    recordList.sort(recordSort);
    display();
    if (tableSorted != null)
      tableSorted(tableSorting);
  } // onTableSortClicked

  /// Record Sort
  int recordSort(DRecord one, DRecord two) {
    int cmp = 0;
    for (LTableSort sort in tableSorting) {
      String oneValue = sort.columnName == URV ? one.drv : DataRecord.columnValue(one, sort.columnName);
      if (oneValue == null)
        oneValue = "";
      String twoValue = sort.columnName == URV ? two.drv : DataRecord.columnValue(two, sort.columnName);
      if (twoValue == null)
        twoValue = "";
      cmp = oneValue.compareTo(twoValue);
      if (cmp != 0) {
        if (!sort.asc)
          cmp *= -1;
        break;
      }
    }
    return cmp;
  } // recordSort

  /// Find In Table
  void findInTable(String findExpression) {
    RegExp regEx = LightningDart.createRegExp(findExpression);
    if (regEx == null) {
      for (DRecord record in recordList) {
        record.clearIsMatchFind();
      }
    } else {
      for (DRecord record in recordList) {
        bool match = false;
        for (DEntry entry in record.entryList) {
          if (entry.hasValueDisplay()) {
            if (entry.valueDisplay.contains(regEx)) {
              match = true;
              break;
            }
          } else if (entry.hasValue()) {
            if (entry.value.contains(regEx)) {
              match = true;
              break;
            }
          } else if (entry.hasValueOriginal()) {
            if (entry.valueOriginal.contains(regEx)) {
              match = true;
              break;
            }
          }
        }
        record.isMatchFind = match;
      }
    }
    display();
  } // findInTable

  /// Table Edit Mode
  String get editMode => _editMode;
  /// Set Edit Mode
  void set editMode (String newValue) {
    _editMode = newValue;
    for (LTableRow row in _tbodyRows) {
      row.editMode = newValue;
    }
  }
  String _editMode = EDIT_RO;

  /**
   * Add Table Action - needs to be called before creating header
   */
  void addTableAction(AppsAction action) {
    _tableActions.add(action);
    if (_theadRows.isNotEmpty) {
      _theadRows.first.addActions([action]);
    }
  } // addTableAction

  /**
   * Add Row Action - needs to be called before creating header
   */
  void addRowAction(AppsAction action) {
    _rowActions.add(action);
  }

  /// Add Table Body Row
  LTableRow addBodyRow({String rowValue}) {
    if (_tbody == null)
      _tbody = element.createTBody();
    LTableRow row = new LTableRow(_tbody.addRow(), _tbodyRows.length, id, rowValue,
        LButton.C_HINT_PARENT, optionRowSelect, nameList, nameLabelMap, LTableRow.TYPE_BODY, _rowActions, dataColumns);
    row.editMode = _editMode;
    _tbodyRows.add(row);
    return row;
  }

  /// Add Table Foot Row
  LTableRow addFootRow() {
    if (_tfoot == null)
      _tfoot = element.createTFoot();
    LTableRow row = new LTableRow(_tfoot.addRow(), _tfootRows.length, id, null,
        LButton.C_HINT_PARENT, optionRowSelect, nameList, nameLabelMap, LTableRow.TYPE_FOOT, null, dataColumns);
    _tfootRows.add(row);
    return row;
  }

  /// Select/Unselect All Body Rows
  void selectAll(bool select) {
    for (LTableRow row in _tbodyRows) {
      row.selected = select;
    }
  }

  /// Set Header
  void setUi(UI ui) {
    _ui = ui;
    dataColumns.clear();
    for (DColumn col in _ui.table.columnList) {
      dataColumns.add(DataColumn.fromUi(_ui, col.name, tableColumn:col));
    }
    LTableHeaderRow hdr = addHeadRow(true);
    for (DataColumn dataColumn in dataColumns) {
      if (dataColumn.isActiveGrid) {
        hdr.addGridColumn(dataColumn);
      }
    }
  } // setUi
  /// Reset Table Structure
  void resetStructure() {
    element.children.clear();
    _thead = null;
    _tbody = null;
    _tfoot = null;
    //
    _theadRows.clear();
    _tbodyRows.clear();
    _tfootRows.clear();
    //
    nameLabelMap.clear();
    nameList.clear();
  }
  /// UI Meta Data
  UI _ui;
  /// Table Meta Data
  final List<DataColumn> dataColumns = new List<DataColumn>();


  /// Set Records - [recordAction] click on drv/urv
  void setRecords(List<DRecord> records, {AppsActionTriggered recordAction}) {
    recordList.clear();
    recordList.addAll(records);
    this.recordAction = recordAction;
    display();
  }

  /// Display Records
  void display() {
    if (_tbody != null) {
      _tbody.children.clear();
      _tbodyRows.clear();
    }
    int i = 0;
    for (DRecord record in recordList) {
      if (record.hasIsMatchFind() && !record.isMatchFind)
        continue;
      LTableRow row = addBodyRow(rowValue: record.recordId);
      row.setRecord(record, i++, recordAction:recordAction);
    }
  } // display

  /// Table selected row count
  int get selectedRowCount {
    int count = 0;
    for (LTableRow row in _tbodyRows) {
      if (row.selected)
        count++;
    }
    return count;
  }

  /// Table selected row records
  List<DRecord> get selectedRecords {
    List<DRecord> records = new List<DRecord>();
    for (LTableRow row in _tbodyRows) {
      if (row.selected && row.record != null) {
        records.add(row.record);
      }
    }
    return records;
  }



  static String lTableRowSelectAll() => Intl.message("Select All", name: "lTableRowSelectAll", args: []);
  static String lTableRowSelectRow() => Intl.message("Select Row", name: "lTableRowSelectRow", args: []);

  static String lTableColumnSortAsc() => Intl.message("Sort Ascending", name: "lTableColumnSortAsc", args: []);
  static String lTableColumnSortDec() => Intl.message("Sort Decending", name: "lTableColumnSortDec", args: []);

} // LTable


/// Table Sorting
class LTableSort {

  final String columnName;
  final bool asc;

  LTableSort(String this.columnName, bool this.asc);

  String get columnLabel => _columnLabel == null ? columnName : _columnLabel;
  void set columnLabel (String newValue) {
    _columnLabel = newValue;
  }
  String _columnLabel;

  /// set label from table column name
  void setLabel(DTable table) {
    if (columnName == LTable.URV)
      _columnLabel = "record name";
    else {
      for (DColumn col in table.columnList) {
        if (col.name == columnName) {
          _columnLabel = col.label;
          break;
        }
      }
    }
  } // setLabel

} // LTableSort
