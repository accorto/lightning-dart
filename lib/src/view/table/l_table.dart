/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/// Sort Clicked
typedef void TableSortClicked(String name, bool asc, DataType dataType, MouseEvent evt);

/// Select Clicked (select or unselect)
typedef void TableSelectClicked(DataRecord data);

/// Graph Selection Changed with selection [count] or null if no selection
typedef void GraphSelectionChange(int count);

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
  RecordSortList recordSorting;
  /// IdPrefix
  final String idPrefix;
  /// Callback for Graph Selection
  GraphSelectionChange graphSelectionChange;

  /**
   * Table
   */
  LTable(String this.idPrefix,
      {bool this.optionRowSelect:true,
      RecordSortList this.recordSorting}) {
    _table.id = LComponent.createId(idPrefix, "table");
    if (recordSorting == null)
      this.recordSorting = new RecordSortList();
  } // LTable

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
          ..append(_table);
      }
    } else if (_wrapper != null) {
      _table.remove();
      _wrapper = null;
    }
  }
  /// Scroll Wrapper
  Element get wrapper => _wrapper;

  /// Y scroll - call after attached to dom
  /// - if [height] == 0, calculate remainder
  void setResponsiveScroll (int height) {
    if (_wrapper == null)
      responsiveOverflow = true; // X
    if (height == 0) {
      Rectangle rect = _wrapper.getBoundingClientRect();
      int winHeight = window.innerHeight;
      int docHeight = document.body.getBoundingClientRect().height;
      int hdr = rect.top;
      int ftr = docHeight - hdr - rect.height;
      height = winHeight - hdr - ftr;
    }
    _wrapper.style.overflowY = "auto";
    _wrapper.style.height = "${height}px";
    _wrapper.onScroll.listen(onScrollTableWrapper);
  }

  /// scroll body with fixed header
  void onScrollTableWrapper(Event evt) {
    int top = _wrapper.getBoundingClientRect().top;
    //_log.config("scroll top=${_wrapper.scrollTop} left=${_wrapper.scrollLeft} "
    //    "clientTop=${_wrapper.clientTop} offsetTop=${_wrapper.offsetTop} scrollTop=${_wrapper.scrollTop} top=${top}");
    if (_theadHeight == null) {
      _theadHeight = _thead.getBoundingClientRect().height;
      // (1) keep header on top - issue: checkboxes and action dropdown
      //_thead.style.background = "white";
      //_thead.style.transform = "translateY(${_wrapper.scrollTop}px)";

      // (2) convert to fixed
      _fixTableLayout();
      _wrapper.style.marginTop = "${_theadHeight}px";
      _thead.style.position = "absolute";
      _thead.style.top = "${top}px";
    } // init
    _thead.style.left = "-${_wrapper.scrollLeft}px";
  }
  int _theadHeight;

  /// fix table Layout
  void _fixTableLayout() {
    // must be displayed
    Element colgroup = new Element.tag("colgroup");
    Element tr = _thead.children.first;
    for (Element th in tr.children) {
      int width = th.getBoundingClientRect().width;
      th.style.minWidth = "${width}px"; // required if detached
      Element col = new Element.tag("col")
        ..style.width = "${width}px";
      colgroup.children.add(col);
    }
    _table.children.add(colgroup);
    _table.style.tableLayout = "fixed"; // auto
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
      _headerRow = new LTableHeaderRow(_thead.addRow(),
          _theadRows.length,
          idPrefix,
          LText.C_TEXT_HEADING__LABEL,
          optionRowSelect,
          nameList,
          nameLabelMap,
          enableSort ? onTableSortClicked : null,
          _tableActions,
          dataColumns);
      if (optionRowSelect && _theadRows.isEmpty) {
        _headerRow.selectCb.onClick.listen((MouseEvent evt) {
          selectAll(_headerRow.selectCb.checked);
        });
      }
      row = _headerRow;
    } else {
      row = new LTableRow(_thead.addRow(),
          _tbodyRows.length,
          idPrefix,
          null, // rowValue
          LText.C_TEXT_HEADING__LABEL,
          optionRowSelect,
          nameList,
          nameLabelMap,
          LTableRow.TYPE_HEAD,
          null, // rowAction
          dataColumns);
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

  /// Table Sort = shift - multiple
  void onTableSortClicked(String name, bool asc, DataType dataType, MouseEvent evt) {
    bool shiftMeta = evt != null && (evt.shiftKey || evt.metaKey);
    _log.config("onTableSortClicked ${name} ${asc} shiftMeta=${shiftMeta}");
    if (shiftMeta) {
      recordSorting.removeColumnName(name);
    } else {
      recordSorting.clear();
    }
    RecordSort sort = new RecordSort.create(name, asc)
      ..dataType = dataType;
    if (_ui == null) {
      sort.columnLabel = name;
    } else {
      sort.setLabelFrom(_ui.table);
      if (sort.dataType == null) {
        sort.dataType = DataTypeUtil.getDataType(_ui.table, null, name);
      }
    }
    recordSorting.add(sort);

    // group by
    bool redisplay = false;
    if (_groupByColumnName == null) {
      redisplay = clearRecordListGroupBy();
    } else {
      RecordSort group = recordSorting.getSort(_groupByColumnName);
      if (group == null) {
        _groupByColumnName = null;
        redisplay = clearRecordListGroupBy();
        display();
      } else {
        recordSorting.setFirst(group);
      }
    }
    _sort(true, redisplay);
  } // onTableSortClicked

  /// Sort Group by local only
  void _sortGroupBy() {
    if (_groupByColumnName == null) {
      return;
    }
    RecordSort group = recordSorting.getSort(_groupByColumnName);
    if (group == null) {
      group = new RecordSort.create(_groupByColumnName, true);
    }
    group.isGroupBy = true;
    recordSorting.setFirst(group);
    _sort(false, false);
  }

  /// Sort Table body Rows
  /// - local: sort LTableRow then recreate tbody/rows
  void _sort(bool sortRemoteOk, bool redisplay) {
    if (_tbodyRows.length > 1) {
      if (sortRemoteOk && recordSorting.sortRemote()) {
        for (AppsAction action in _tableActions) {
          if (action.value == AppsAction.REFRESH) {
            action.callback(null, null, null, null);
            return;
          }
        }
        _log.warning("sort NO_Action sortRemote");
      } else { // local
        if (redisplay) {
          display(); //
        }
        _log.fine("sort local #${_tbodyRows.length}");
        _tbodyRows.sort((LTableRow one, LTableRow two) {
          return recordSorting.recordSortCompare(one.record, two.record);
        });
        _tbody.children.clear();
        for (LTableRow row in _tbodyRows) {
          _tbody.children.add(row.rowElement);
        }
      }
    }
  } // sport


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
  int findInTable(String findString) {
    int count = 0;
    RegExp regEx = LUtil.createRegExp(findString);
    if (regEx == null) {
      for (LTableRow row in _tbodyRows) {
        row.record.clearIsMatchFind();
        row.show = true;
      }
      count = recordList.length;
    } else {
      for (LTableRow row in _tbodyRows) {
        bool match = false;
        for (DEntry entry in row.record.entryList) {
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
        row.record.isMatchFind = match;
        row.show = match;
        if (match)
          count++;
      } // for record
    }
    return count;
  } // findInTable

  /// show rows based on selected Graph portion
  /// returns matched row count
  int graphSelect(bool graphMatch(DRecord record)) {
    // show all
    if (graphMatch == null) {
      for (LTableRow row in _tbodyRows) {
        row.record.clearIsMatchFind();
        row.show = true;
      }
      if (_withStatistics && _statisticsRow != null) {
        _statisticsRow.setStatistics(_statistics, label: lTableStatisticTotal());
      }
      if (graphSelectionChange != null)
        graphSelectionChange(null);
      return recordList.length;
    }
    // show matching
    int count = 0;
    for (LTableRow row in _tbodyRows) {
      bool match = graphMatch(row.record);
      row.record.isMatchFind = match;
      row.show = match;
      if (match && !row.record.isGroupBy)
        count++;
    }
    if (_withStatistics && _statisticsRow != null) {
      TableStatistics temp = _statistics.summary(recordList);
      _statisticsRow.setStatistics(temp, label: lTableStatisticGraphSelect());
    }
    if (graphSelectionChange != null)
      graphSelectionChange(count);
    return count;
  } // graphSelect


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

  /// Create and Add Table Body Row
  LTableRow addBodyRow({String rowValue}) {
    if (_tbody == null)
      _tbody = _table.createTBody();
    LTableRow row = new LTableRow(_tbody.addRow(),
        _tbodyRows.length,
        idPrefix,
        rowValue,
        LButton.C_HINT_PARENT,
        optionRowSelect,
        nameList,
        nameLabelMap,
        LTableRow.TYPE_BODY,
        _rowActions,
        dataColumns);
    row.editMode = _editMode;
    row.tableSelectClicked = onTableRowSelectClicked;
    _tbodyRows.add(row);
    return row;
  }

  /// Add Table Foot Row
  LTableRow addFootRow() {
    if (_tfoot == null)
      _tfoot = _table.createTFoot();
    LTableRow row = new LTableRow(_tfoot.addRow(),
        _tfootRows.length,
        idPrefix,
        null, // rowValue
        LButton.C_HINT_PARENT,
        optionRowSelect,
        nameList,
        nameLabelMap,
        LTableRow.TYPE_FOOT,
        null, // rowAction
        dataColumns);
    _tfootRows.add(row);
    return row;
  }
  /// add sum row to Footer or Body
  LTableSumRow addStatRow(bool foot) {
    TableRowElement tr = null;
    int rowNo = 0;
    if (foot) {
      if (_tfoot == null)
        _tfoot = _table.createTFoot();
      tr = _tfoot.addRow();
      rowNo = _tfootRows.length;
    } else {
      if (_tbody == null)
        _tbody = _table.createTBody();
      tr = _tbody.addRow();
      rowNo = _tbodyRows.length;
    }
    //
    LTableSumRow row = new LTableSumRow(tr,
        rowNo,
        idPrefix,
        LButton.C_HINT_PARENT,
        false, // rowSelect
        nameList,
        nameLabelMap,
        foot ? LTableRow.TYPE_FOOT : LTableRow.TYPE_BODY,
        dataColumns);
    //
    if (foot)
      _tfootRows.add(row);
    else
      _tbodyRows.add(row);
    return row;
  }

  /// Select/Unselect All Body Rows
  void selectAll(bool select) {
    for (LTableRow row in _tbodyRows) {
      row.selected = select;
    }
  }

  /// Set UI
  void setUi(UI ui, {bool fromQueryColumns:false}) {
    _ui = ui;
    dataColumns.clear();

    if (fromQueryColumns) {
      for (UIQueryColumn qc in ui.queryColumnList) {
        dataColumns.add(DataColumn.fromUi(ui, qc.columnName));
      }
    }
    // Grid Columns
    if (dataColumns.isEmpty) { // nothing added yet
      for (UIGridColumn gc in _ui.gridColumnList) {
        dataColumns.add(DataColumn.fromUi(_ui,
            gc.columnName, columnId: gc.columnId, gridColumn:gc));
      }
    }
    // table column fallback
    if (dataColumns.isEmpty) { // nothing added yet
      for (DColumn col in _ui.table.columnList) {
        dataColumns.add(DataColumn.fromUi(_ui, col.name, tableColumn:col));
      }
    }
    // Header
    LTableHeaderRow row = addHeadRow(true);
    for (DataColumn dataColumn in dataColumns) {
      if (dataColumn.isActiveGrid) {
        row.addGridColumn(dataColumn);
      }
    }
    _statistics = new TableStatistics(ui.table.name, dataColumns);
  } // setUi
  /// UI Meta Data
  UI _ui;
  /// overwrite for fixed ui
  UI get ui => _ui;
  /// Table Meta Data
  final List<DataColumn> dataColumns = new List<DataColumn>();
  /// Statistics
  TableStatistics _statistics;

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


  /// Set Records - [recordAction] click on drv/urv
  void setRecords(List<DRecord> records, {AppsActionTriggered recordAction}) {
    recordList.clear();
    recordList.addAll(records);
    this.recordAction = recordAction;
    display();
    if (_headerRow != null) {
      _headerRow.setSorting(recordSorting);
    }
  } // setRecords

  /// Display Records (calculates statistics)
  void display() {
    if (_tbody != null) {
      _tbody.children.clear();
      _tbodyRows.clear();
    }
    if (_tfoot != null) {
      _tfoot.children.clear();
      _tfootRows.clear();
    }
    bool needSort = _displayCalculateStatistics();
    //_log.fine("display records=${recordList.length}");
    int i = 0;
    for (DRecord record in recordList) {
      if (record.hasIsGroupBy()) {
        LTableSumRow row = addStatRow(false);
        row.setRecord(record, i++);
      } else {
        LTableRow row = addBodyRow(
            rowValue: record.recordId); // adds to _tbodyRows
        row.setRecord(record, i++, recordAction: recordAction);
      }
    }
    if (needSort) {
      _sortGroupBy(); // LTableRow
    }
    // Statistics
    if (_statistics != null && _withStatistics) {
      _statisticsRow = addStatRow(true); // LTableSumRow
      _statisticsRow.setStatistics(_statistics);
    }
  } // display
  LTableSumRow _statisticsRow;

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
   * Add Plain Headings
   */
  void addHeadings(List<String> thTexts) {
    if (_thead == null)
      _thead = _table.createTHead();
    TableRowElement tr = _thead.addRow();
    for (String thText in thTexts) {
      Element th = new Element.th();
      tr.append(th);
      if (thText != null) {
        th.text = thText;
      }
    }
  } // addHeadings

  /**
   * Add Plain Body Row with header element and data element
   */
  void addRowHdrData(String thText, dynamic tdValue, {int colSpan:0}) {
    if (_tbody == null)
      _tbody = _table.createTBody();
    TableRowElement tr = _tbody.addRow();

    Element th = new Element.th();
    tr.append(th);
    if (thText != null) {
      th.text = thText;
    }
    TableCellElement td = tr.addCell();
    if (colSpan > 0) {
      td.colSpan = colSpan;
      td.style.whiteSpace = "normal"; // defaults to no-wrap
      td.style.wordBreak = "break-word";
      th.style.verticalAlign = "top";
    }
    if (tdValue != null) {
      if (tdValue is String) {
        td.text = tdValue;
      } else if (tdValue is Element) {
        td.append(tdValue);
      } else {
        td.text = tdValue.toString();
      }
    }
  } // addRowHdrData

  /**
   * Add Plain Body Row with header text and values, colSpan for values
   */
  void addRowHdrDataList(String thText, List<dynamic> tdValues, {int colSpan:0}) {
    if (_tbody == null)
      _tbody = _table.createTBody();
    TableRowElement tr = _tbody.addRow();

    Element th = new Element.th();
    tr.append(th);
    if (thText != null)
      th.text = thText;

    for (dynamic tdValue in tdValues) {
      TableCellElement td = tr.addCell();
      if (colSpan > 0) {
        td.colSpan = colSpan;
        td.style
            ..whiteSpace = "normal" // defaults to no-wrap
            ..wordBreak = "break-word"
            ..verticalAlign = "top";
        th.style.verticalAlign = "top";
      }
      if (tdValue != null) {
        if (tdValue is String) {
          td.text = tdValue;
        } else if (tdValue is Element) {
          td.append(tdValue);
        } else {
          td.text = tdValue.toString();
        }
      }
    }
  } // addRowHdrDataList

  /**
   * Add Plain Body Row
   */
  TableRowElement addRowDataList(List<dynamic> tdValues) {
    if (_tbody == null)
      _tbody = _table.createTBody();
    TableRowElement tr = _tbody.addRow();

    for (dynamic tdValue in tdValues) {
      TableCellElement td = tr.addCell();
      if (tdValue != null) {
        if (tdValue is String) {
          td.text = tdValue;
        } else if (tdValue is Element) {
          td.append(tdValue);
        } else {
          td.text = tdValue.toString();
        }
      }
    }
    return tr;
  } // addRowDataList

  /// Add col element to table
  Element addColElement() {
    Element col = new Element.tag("col");
    _table.append(col);
    return col;
  }

  /// Total Row
  bool get withStatistics => _withStatistics;
  /// set statistics - call display
  void set withStatistics (bool newValue) {
    _withStatistics = newValue;
  }
  bool _withStatistics = false;

  /**
   * Calculate statistics (called from display)
   * returns true if display needs to be sorted
   */
  bool _displayCalculateStatistics() {
    if (_statistics == null) {
      return false;
    }
    clearRecordListGroupBy(); // remove group by
    //
    List<StatBy> byList = new List<StatBy>();
    if (_groupByColumnName != null && _ui != null) {
      DColumn byColumn = DataUtil.findColumn(_ui.table, null, _groupByColumnName);
      if (byColumn != null) {
        byList.add(new StatBy.column(byColumn));
      }
    }
    DColumn dateColumn = null;
    ByPeriod byPeriod = null;

    if (byList.isNotEmpty || _withStatistics) {
      return _statistics.calculate(recordList,
            byList, dateColumn, byPeriod); // add group by records
    }
    return false;
  } // calculateStatistics


  /// Set Group By Column
  String get groupByColumnName => _groupByColumnName;
  /// Set Group By Column - call display
  void set groupByColumnName (String newValue) {
    if (newValue != null
      && (newValue.isEmpty || newValue == "-")) {
      newValue = null;
    }
    if (newValue == _groupByColumnName) {
      return; // no change
    }
    // remove old sort
    recordSorting.removeColumnName(_groupByColumnName);
    //
    _groupByColumnName = newValue;
    display();
    if (graphSelectionChange != null)
      graphSelectionChange(null);
  }
  String _groupByColumnName;

  /// clear group by records
  /// return true if records were removed
  bool clearRecordListGroupBy() {
    List<DRecord> removeList = new List<DRecord>();
    for (DRecord record in recordList) {
      if (record.hasIsGroupBy())
        removeList.add(record);
    }
    if (removeList.isNotEmpty) {
      int origLength = recordList.length;
      for (DRecord record in removeList) {
        recordList.remove(record);
      }
      bool ok = (recordList.length == origLength-removeList.length);
      _log.log(ok ? Level.CONFIG : Level.WARNING, "clearRecordListGroupBy ${recordList.length}=${origLength}-${removeList.length}");
    }
    if (graphSelectionChange != null)
      graphSelectionChange(null);
    return removeList.isNotEmpty;
  } // clearRecordListGroupBy

  static String lTableRowSelectAll() => Intl.message("Select All", name: "lTableRowSelectAll", args: []);
  static String lTableRowSelectRow() => Intl.message("Select Row", name: "lTableRowSelectRow", args: []);

  static String lTableColumnSortAsc() => Intl.message("Sort Ascending", name: "lTableColumnSortAsc", args: []);
  static String lTableColumnSortDec() => Intl.message("Sort Decending", name: "lTableColumnSortDec", args: []);

  static String lTableStatisticTotal() => Intl.message("Total", name: "lTableStatisticTotal");
  static String lTableStatisticGraphSelect() => Intl.message("Graph Selection", name: "lTableStatisticGraphSelect");
  static String lTableStatisticMatchSelect() => Intl.message("Match Selection", name: "lTableStatisticMatchSelect");


} // LTable
