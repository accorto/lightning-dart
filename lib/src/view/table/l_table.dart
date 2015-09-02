/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;


typedef void TableSortClicked(String name, bool asc);

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

  final bool rowSelect;

  /// Column Name-Label Map - required for responsive
  final Map<String,String> nameLabelMap = new Map<String,String>();
  /// Name list by column #
  final List<String> nameList = new List<String>();

  List<AppsAction> _tableActions = new List<AppsAction>();
  List<AppsAction> _rowActions = new List<AppsAction>();

  /// UI Meta Data
  UI _ui;

  /**
   * Table
   */
  LTable(String idPrefix, bool this.rowSelect) {
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
        LText.C_TEXT_HEADING__LABEL, rowSelect, nameList, nameLabelMap,
        enableSort ? onTableSortClicked : null, _tableActions);
      if (rowSelect && _theadRows.isEmpty) {
        row.selectCb.onClick.listen((MouseEvent evt) {
          selectAll(row.selectCb.checked);
        });
      }
    } else {
      row = new LTableRow(_thead.addRow(), _tbodyRows.length, id, null,
        LText.C_TEXT_HEADING__LABEL, rowSelect, nameList, nameLabelMap, LTableRow.TYPE_HEAD, null);
    }
    _theadRows.add(row);
    // add urv
    if (_ui != null) {
      row.addHeaderCell(URV, _ui.table.label);
    }
    return row;
  } // addHeadRow

  /// Table Sort
  void onTableSortClicked(String name, bool asc) {
    _log.info("onTableSortClicked ${name} ${asc}");
    // TODO table data sort
  }

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
    LTableRow row = new LTableRow(_thead.addRow(), _tbodyRows.length, id, rowValue,
        LButton.C_HINT_PARENT, rowSelect, nameList, nameLabelMap, LTableRow.TYPE_BODY, _rowActions);
    _tbodyRows.add(row);
    return row;
  }

  /// Add Table Foot Row
  LTableRow addFootRow() {
    if (_tfoot == null)
      _tfoot = element.createTFoot();
    LTableRow row = new LTableRow(_thead.addRow(), _tfootRows.length, id, null,
        LButton.C_HINT_PARENT, rowSelect, nameList, nameLabelMap, LTableRow.TYPE_FOOT, null);
    _tbodyRows.add(row);
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
    LTableHeaderRow hdr = addHeadRow(true);
    for (UIGridColumn gc in ui.gridColumnList) {
      hdr.addGridColumn(gc);
    }
  } // setUi

  /// Set Records
  void display(List<DRecord> records, {AppsActionTriggered viewAction}) {
    if (_tbody != null) {
      _tbody.children.clear();
    }
    int i = 0;
    for (DRecord record in records) {
      LTableRow row = addBodyRow(rowValue: record.recordId);
      row.setRecord(record, i++, viewAction:viewAction);
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


