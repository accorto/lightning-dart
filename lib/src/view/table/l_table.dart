/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/// Sort Clicked
typedef void TableSortClicked(String name, bool asc, MouseEvent evt);

/// Select Clicked (select or unselect)
typedef void TableSelectClicked(DataRecord data);


/**
 * Table
 */
class LTable
    extends LComponent {

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

  static const String C_TEXT_CENTER = "slds-text-center";
  static const String C_TEXT_RIGHT = "slds-text-right";


  /// Table Edit Mode - Read Only
  static const String EDIT_RO = "ro";
  /// Table Edit Mode - Field Click
  static const String EDIT_FIELD = "field";
  /// Table Edit Mode - Selected Rows
  static const String EDIT_SEL = "sel";
  /// Table Edit Mode - R/O Select Multiple Rows
  static const String EDIT_SELECT_MULTI = "roSelX";
  /// Table Edit Mode - R/O Select Single Rows
  static const String EDIT_SELECT_SINGLE = "roSel1";
  /// Table Edit Mode - All Rows
  static const String EDIT_ALL = "all";

  static final Logger _log = new Logger("LTable");


  /// Table Element
  Element get element {
    if (_wrapper != null)
      return _wrapper;
    return _table;
  }
  /// Table id (not wrapper)
  String get id => _table.id;
  /// responsive wrapper
  DivElement _wrapper;

  /// Table Element
  final TableElement _table = new TableElement()
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
  /// Table Row Select callback
  TableSelectClicked tableSelectClicked;

  /// Row Select
  final bool optionRowSelect;
  /// Record Sort List
  RecordSorting recordSorting;
  /// IdPrefix
  final String idPrefix;

  /**
   * Table
   */
  LTable(String this.idPrefix, {bool this.optionRowSelect:true, RecordSorting this.recordSorting}) {
    _table.id = LComponent.createId(idPrefix, "table");
    if (recordSorting == null)
      this.recordSorting = new RecordSorting();
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

  /// responsive overflow scrollable-x wrapper with table
  bool get responsiveOverflow => _wrapper != null;
  /// responsive overflow scrollable-x wrapper with table
  void set responsiveOverflow (bool newValue) {
    if (newValue) {
      if (_wrapper == null) {
        _wrapper = new DivElement()
          ..classes.add(LScrollable.C_SCROLLABLE__X)
          ..append(element);
      }
    } else if (_wrapper != null) {
      _table.remove();
      _wrapper = null;
    }
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
      _thead = _table.createTHead();
    LTableHeaderRow row = null;
    if (primary) {
      _headerRow = new LTableHeaderRow(_thead.addRow(), _theadRows.length, id,
        LText.C_TEXT_HEADING__LABEL, optionRowSelect, nameList, nameLabelMap,
        enableSort ? onTableSortClicked : null, _tableActions, dataColumns);
      if (optionRowSelect && _theadRows.isEmpty) {
        _headerRow.selectCb.onClick.listen((MouseEvent evt) {
          selectAll(_headerRow.selectCb.checked);
        });
      }
      row = _headerRow;
    } else {
      row = new LTableRow(_thead.addRow(), _tbodyRows.length, idPrefix, null,
        LText.C_TEXT_HEADING__LABEL, optionRowSelect, nameList, nameLabelMap,
        LTableRow.TYPE_HEAD, null, dataColumns);
    }
    row.editMode = _editMode;
    _theadRows.add(row);
    // add urv
    if (_ui != null) {
      row.addHeaderCell(DataRecord.URV, _ui.table.label);
    }
    return row;
  } // addHeadRow
  LTableHeaderRow _headerRow;

  /// Table Sort
  void onTableSortClicked(String name, bool asc, MouseEvent evt) {
    bool shiftMeta = (evt.shiftKey || evt.metaKey);
    _log.config("onTableSortClicked ${name} ${asc} shiftMeta=${shiftMeta}");
    if (shiftMeta) {
      RecordSort sortFound = recordSorting.getSort(name);
      if (sortFound != null)
        recordSorting.remove(sortFound);
    } else {
      recordSorting.clear();
    }
    RecordSort sort = new RecordSort.create(name, asc);
    if (_ui == null) {
      sort.columnLabel = name;
    } else {
      sort.setLabelFrom(_ui.table);
    }
    recordSorting.add(sort);
    if (recordSorting.sort()) { // sortLocal
      recordSorting.sortList(recordList);
      display();
    }
  } // onTableSortClicked

  /**
   * Table Row Selected Clicked
   */
  void onTableRowSelectClicked(DataRecord data) {
    // _log.config("onTableRowSelectClicked ${data.selected}");
    if (tableSelectClicked != null) {
      tableSelectClicked(data);
    }
  }

  /// Find In Table
  int findInTable(String findExpression) {
    int count = 0;
    RegExp regEx = LUtil.createRegExp(findExpression);
    if (regEx == null) {
      for (DRecord record in recordList) {
        record.clearIsMatchFind();
      }
      count = recordList.length;
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
        if (match)
          count++;
      } // for record
    }
    display();
    return count;
  } // findInTable

  /// Table Edit Mode
  String get editMode => _editMode;
  /// Set Edit Mode
  void set editMode (String newValue) {
    _editMode = newValue;
    for (LTableRow row in _theadRows) {
      row.editMode = newValue;
    }
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
      _tbody = _table.createTBody();
    LTableRow row = new LTableRow(_tbody.addRow(), _tbodyRows.length, idPrefix, rowValue,
        LButton.C_HINT_PARENT, optionRowSelect, nameList, nameLabelMap,
        LTableRow.TYPE_BODY, _rowActions, dataColumns);
    row.editMode = _editMode;
    row.tableSelectClicked = onTableRowSelectClicked;
    _tbodyRows.add(row);
    return row;
  }

  /// Add Table Foot Row
  LTableRow addFootRow() {
    if (_tfoot == null)
      _tfoot = _table.createTFoot();
    LTableRow row = new LTableRow(_tfoot.addRow(), _tfootRows.length, idPrefix, null,
        LButton.C_HINT_PARENT, optionRowSelect, nameList, nameLabelMap,
        LTableRow.TYPE_FOOT, null, dataColumns);
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
  void setUi(UI ui, {bool fromQueryColumns:false}) {
    _ui = ui;
    dataColumns.clear();

    if (fromQueryColumns) {
      for (UIQueryColumn qc in ui.queryColumnList) {
        dataColumns.add(DataColumn.fromUi(ui, qc.columnName));
      }
    }
    // Grid Columns
    if (dataColumns.isEmpty) {
      for (UIGridColumn gc in _ui.gridColumnList) {
        dataColumns.add(DataColumn.fromUi(_ui, gc.columnName, gridColumn:gc));
      }
    }
    // table column fallback
    if (dataColumns.isEmpty) {
      for (DColumn col in _ui.table.columnList) {
        dataColumns.add(DataColumn.fromUi(_ui, col.name, tableColumn:col));
      }
    }
    LTableHeaderRow row = addHeadRow(true);
    for (DataColumn dataColumn in dataColumns) {
      if (dataColumn.isActiveGrid) {
        row.addGridColumn(dataColumn);
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
    if (_headerRow != null)
      _headerRow.setSorting(recordSorting);
  } // setRecords

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

  /**
   * Add Body Row
   */
  void addRowHdrData(String thText, String tdText) {
    if (_tbody == null)
      _tbody = _table.createTBody();
    TableRowElement tr = _tbody.addRow();

    Element th = new Element.th();
    tr.append(tr);
    if (thText != null)
      th.text = thText;

    TableCellElement td = tr.addCell();
    if (tdText != null)
      td.text = tdText;
  } // addRowHdrData

  /**
   * Add Body Row
   */
  void addRowHdrDataList(String thText, List<String> tdTexts) {
    if (_tbody == null)
      _tbody = _table.createTBody();
    TableRowElement tr = _tbody.addRow();

    Element th = new Element.th();
    tr.append(tr);
    if (thText != null)
      th.text = thText;

    for (String tdText in tdTexts) {
      TableCellElement td = tr.addCell();
      if (tdText != null)
        td.text = tdText;
    }
  } // addRowHdrDataList


  static String lTableRowSelectAll() => Intl.message("Select All", name: "lTableRowSelectAll", args: []);
  static String lTableRowSelectRow() => Intl.message("Select Row", name: "lTableRowSelectRow", args: []);

  static String lTableColumnSortAsc() => Intl.message("Sort Ascending", name: "lTableColumnSortAsc", args: []);
  static String lTableColumnSortDec() => Intl.message("Sort Decending", name: "lTableColumnSortDec", args: []);

} // LTable
