/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/// Sort Clicked
typedef void TableSortClicked(String name, bool asc, DataType dataType, MouseEvent evt);

/// Row Select Clicked (select or unselect)
typedef void TableRowSelectClicked(DataRecord data);
/// Head Select Clicked may return null if no row select all
typedef bool TableHeadSelectClicked(bool newValue);

/// Graph Selection Changed with selection [count] or null if no selection
typedef void GraphSelectionChange(int count);

/**
 * Table
 */
class LTable
    extends LComponent {

  /// slds-table (table): Initializes data table
  static const String C_TABLE = "slds-table";
  /// slds-table--bordered (slds-table): Adds borders to the table
  static const String C_TABLE__BORDERED = "slds-table--bordered";
  /// slds-table--striped (slds-table): Adds stripes to alternating rows
  static const String C_TABLE__STRIPED = "slds-table--striped";
  /// slds-table--fixed-layout (slds-table): Styles for resizeable columns
  static const String C_TABLE__FIXED_LAYOUT = "slds-table--fixed-layout";
  /// slds-is-selected (tr): Changes row to selected state
  static const String C_IS_SELECTED = "slds-is-selected";
  /// slds-is-sortable (th): Enables user interactions for sorting a column
  static const String C_IS_SORTABLE = "slds-is-sortable";
  /// slds-is-resizable (th): Enables table cell to be resized
  static const String C_IS_RESIZABLE = "slds-is-resizable";
  /// slds-cell-wrap (td): Forces text to wrap in a cell
  static const String C_CELL_WRAP = "slds-cell-wrap";
  /// slds-cell-shrink (th, <td): Shrinks cell to width of content - Use if cell contains a checkbox or action menu
  static const String C_CELL_SHRINK = "slds-cell-shrink";
  /// slds-no-row-hover (slds-table): Removes hover state on row - Rows have a hover state by default
  static const String C_NO_ROW_HOVER = "slds-no-row-hover";
  /// slds-scrollable--x (parent div): Creates a scrollable container for a table on smaller viewports
  static const String C_SCROLLABLE__X = "slds-scrollable--x";
  /// slds-max-medium-table--stacked (slds-table): Modifies table layout by stacking cells to accommodate smaller viewports
  static const String C_MAX_MEDIUM_TABLE__STACKED = "slds-max-medium-table--stacked";
  /// slds-max-medium-table--stacked-horizontal (slds-table): Modifies table layout by displaying the header and row data side by side for smaller viewports
  static const String C_MAX_MEDIUM_TABLE__STACKED_HORIZONTAL = "slds-max-medium-table--stacked-horizontal";
  /// slds-hint-parent (tr): Highlights action overflow ribbons on row hover - When you have an overflow action menu
  static const String C_HINT_PARENT = "slds-hint-parent";


  static const String C_RESIZABLE = "slds-resizable";
  static const String C_RESIZABLE__HANDLE = "slds-resizable__handle";
  static const String C_RESIZABLE__DIVIDER = "slds-resizable__divider";


  /// space below edit table for dropdowns
  static const String C_INFO_BOTTOM = "r-table-info";


  /// Table Edit Mode - Read Only
  static const String EDIT_RO = "ro";
  /// Table Edit Mode - R/O Select Multiple Rows
  static const String EDIT_RO_SELECT_MULTI = "roSelX";
  /// Table Edit Mode - R/O Select Single Rows
  static const String EDIT_RO_SELECT_SINGLE = "roSel1";
  /// Table Edit Mode - Field Click
  static const String EDIT_FIELD = "field";
  /// Table Edit Mode - Selected Rows
  static const String EDIT_SEL = "sel";
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
  TableElement _tableHead;
  TableElement _tableFoot;

  TableSectionElement _thead;
  TableSectionElement _tbody;
  TableSectionElement _tfoot;
  final List<LTableHeaderRow> theadRows = new List<LTableHeaderRow>();
  final List<LTableRow> tbodyRows = new List<LTableRow>();
  final List<LTableRow> tfootRows = new List<LTableRow>();


  /// Column Name-Label Map - required for responsive
  final Map<String,String> nameLabelMap = new Map<String,String>();
  /// Name list by column #
  final List<String> nameList = new List<String>();

  /// Actions
  final List<AppsAction> tableActions = new List<AppsAction>();
  final List<AppsAction> rowActions = new List<AppsAction>();

  /// Record Sort List
  final List<DRecord> recordList = new List<DRecord>();
  /// Record action (click on drv) - display urv
  final AppsActionTriggered recordAction;
  /// Table Head Select callback
  TableHeadSelectClicked tableHeadSelectClicked;
  /// Table Row Select callback
  TableRowSelectClicked tableRowSelectClicked;

  /// Row Select
  final bool rowSelect;
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
      {bool this.rowSelect:true,
      RecordSortList this.recordSorting,
      AppsActionTriggered this.recordAction}) {
    _table.id = LComponent.createId(idPrefix, "table");
    if (recordSorting == null)
      this.recordSorting = new RecordSortList();
  } // LTable

  /// Responsive Stacked (not horizontal)
  bool get responsiveStacked => element.classes.contains(C_MAX_MEDIUM_TABLE__STACKED);
  void set responsiveStacked (bool newValue) {
    element.classes.remove(C_MAX_MEDIUM_TABLE__STACKED_HORIZONTAL);
    if (newValue)
      element.classes.add(C_MAX_MEDIUM_TABLE__STACKED);
    else
      element.classes.remove(C_MAX_MEDIUM_TABLE__STACKED);
  }
  /// Responsive Stacked Horizontal (not responsive)
  bool get responsiveStackedHorizontal => element.classes.contains(C_MAX_MEDIUM_TABLE__STACKED_HORIZONTAL);
  void set responsiveStackedHorizontal (bool newValue) {
    element.classes.remove(C_MAX_MEDIUM_TABLE__STACKED);
    if (newValue)
      element.classes.add(C_MAX_MEDIUM_TABLE__STACKED_HORIZONTAL);
    else
      element.classes.remove(C_MAX_MEDIUM_TABLE__STACKED_HORIZONTAL);
  }

  /// responsive overflow scrollable-x wrapper with table
  LTableResponsive get responsiveOverflow => _overflow;
  /// responsive overflow - wrapper for table
  void set responsiveOverflow (LTableResponsive newValue) {
    _overflow = newValue;
    if (_overflow == LTableResponsive.NONE) {
      _table.remove();
      _wrapper = null;
      //_wrapper2 = null;
      if (_tableHead != null && _thead != null) {
        _thead.remove();
        _table.append(_thead);
      }
      _tableHead = null;
      if (_tableFoot != null && _tfoot != null) {
        _tfoot.remove();
        _table.append(_tfoot);
      }
      _tableFoot = null;
    } else {
      if (_wrapper == null) {
        _wrapper = new DivElement()
          ..classes.add("r-table-wrap")
          ..classes.add(LScrollable.C_SCROLLABLE__X)
          //..style.position = "relative"
          ..append(_table);
      }

      // head
      if (_overflow == LTableResponsive.OVERFLOW_HEAD || _overflow == LTableResponsive.OVERFLOW_HEAD_FOOT) {
        if (_tableHead == null) {
          _tableHead = new TableElement()
            ..classes.add("r-table-head")
            ..classes.addAll(_table.classes)
            ..style.top = "0"
            ..style.left = "0";
        }
        _tableHead.remove();
        _wrapper.append(_tableHead);
        if (_thead != null) {
          _thead.remove();
          _tableHead.append(_thead);
        }
        _table.style.margin = "36px 0";
      } else {
        if (_thead != null) {
          _thead.remove();
          _table.append(_thead);
        }
        _tableHead = null;
        _table.style.removeProperty("margin");
      }

      // body
      _table.remove();
      _wrapper.append(_table);

      // foot
      if (_overflow == LTableResponsive.OVERFLOW_HEAD_FOOT) {
        if (_tableFoot == null) {
          _tableFoot = new TableElement()
            ..classes.add("r-table-foot")
            ..classes.addAll(_table.classes)
            //..style.position = "absolute"
            //..style.zIndex = "1"
            ..style.bottom = "0"
            ..style.left = "0";
        }
        _tableFoot.remove();
        _wrapper.append(_tableFoot);
        if (_tfoot != null) {
          _tfoot.remove();
          _tableFoot.append(_tfoot);
        }
      } else {
        if (_tfoot != null) {
          _tfoot.remove();
          _table.append(_tfoot);
        }
        _tableFoot = null;
      }
    }
    if (_info != null)
      infoText = infoText; // re-attach
    fixWidth(null);
  } // set responsiveOverflow
  LTableResponsive _overflow = LTableResponsive.NONE;

  /// Y scroll - call after attached to dom
  /// - if [height] == 0, calculate remainder
  void setResponsiveScroll (int height) {
    if (_overflow == LTableResponsive.NONE || _overflow == LTableResponsive.OVERFLOW_X) {
      responsiveOverflow = LTableResponsive.OVERFLOW_HEAD;
    }
    _scrollHeight = height;
    if (_onScrollSubscription == null) {
      _onScrollSubscription = _wrapper.onScroll.listen(onScrollTableWrapper);
    }
    showingNow();
  }
  StreamSubscription _onScrollSubscription;
  int _scrollHeight;

  /// Showing now - sync
  void showingNow() {
    if (_overflow == LTableResponsive.NONE || _overflow == LTableResponsive.OVERFLOW_X) {
      return;
    }
    int height = _scrollHeight;
    if (height == 0) {
      if (_onScrollSubscription != null) {
        _wrapper.style.overflowY = "visible";
        _wrapper.style.removeProperty("height");
      }
      Rectangle wrapRect = _wrapper.getBoundingClientRect();
      int winHeight = window.innerHeight;
      int docHeight = document.body.getBoundingClientRect().height;
      int hdr = wrapRect.top;
      int ftr = docHeight - hdr - wrapRect.height;
      height = winHeight - hdr - ftr;
      _log.config("showingNow height=${height} win=${winHeight} doc=${docHeight} wrap${wrapRect}");
    } else {
      _log.config("showingNow height=${height}");
    }
    _wrapper.style.overflowY = "auto";
    _wrapper.style.height = "${height}px";
    fixWidth(null);
  } // showingNow

  /// scroll body with fixed header
  void onScrollTableWrapper(Event evt) {
    int top = _wrapper.scrollTop;
    int width = _wrapper.offsetWidth;
    if (_tableHead != null) {
      _tableHead.style.top = "${top}px";
    }
    if (_tableFoot != null) {
      _tableFoot.style.bottom = "-${top}px";
    }
    if (_lastWidth != width) {
      fixWidth(null);
      _lastWidth = width;
    }
    //_log.finer("onScrollTableWrapper"
    //    " scroll t=${_wrapper.scrollTop} h=${_wrapper.scrollHeight} l=${_wrapper.scrollLeft} w=${_wrapper.scrollWidth}"
    //    " offset t=${_wrapper.offsetTop} h=${_wrapper.offsetHeight} l=${_wrapper.offsetLeft} w=${_wrapper.offsetWidth}");
  } // onScrollTableWrapper
  int _lastWidth;

  /// sync column width
  void fixWidth(Timer timer) {
    // fix height
    if (_tableHead != null && _thead != null) {
      int height = 37;
      if (_thead != null) {
        if (_thead.clientHeight > height)
          height = _thead.clientHeight;
      }
      _table.style.margin = "${height-1}px 0";
    }

    // count
    int rowTypeCount = 0;
    int rowCount = 0;
    int colCount = 0;
    // body
    Element tr = null;
    _table.style.tableLayout = "auto";
    if (_tbody != null && _tbody.children.isNotEmpty) {
      tr = _tbody.children.first;
      rowTypeCount++;
      rowCount = _tbody.children.length;
      colCount = tr.children.length;
    }
    String info = "fixWidth ${id} (${colCount}x${rowCount})#${_fixWidthCount}";
    Element tr_h = null;
    if (_tableHead != null) {
      _tableHead.style.tableLayout = "auto";
      if (_thead != null && _thead.children.isNotEmpty) {
        tr_h = _thead.children.first;
        rowTypeCount++;
        if (colCount == 0) {
          colCount = tr_h.children.length;
        } else if (colCount > tr_h.children.length) { // addl cols are ok
          info += " header cols=${tr_h.children.length}";
          tr_h = null;
          rowTypeCount--;
        }
      }
    }
    Element tr_f = null;
    if (_tableFoot != null) {
      _tableFoot.style.tableLayout = "auto";
      if (_tfoot != null && _tfoot.children.isNotEmpty) {
        tr_f = _tfoot.children.first;
        rowTypeCount++;
        if (colCount == 0) {
          colCount = tr_f.children.length;
        } else if (colCount > tr_f.children.length) { // addl ok
          info += " footer cols=${tr_f.children.length}";
          tr_f = null;
          rowTypeCount--;
        }
      }
    }
    if ((_tableHead == null && _tableFoot == null) || rowTypeCount < 2) {
      _log.fine(info + " auto");
      if (_timer != null) {
        _timer.cancel();
        _timer = null;
      }
      return; // nothing to do
    }
    // for each column
    for (int c = 0; c < colCount; c++) {
      int width = 0;
      Element td = null;
      if (tr != null) {
        td = tr.children[c];
        width = _fixWidthTd(td, width);
      }
      Element td_h = null;
      if (tr_h != null) {
        td_h = tr_h.children[c];
        width = _fixWidthTd(td_h, width);
      }
      Element td_f = null;
      if (tr_f != null) {
        td_f = tr_f.children[c];
        width = _fixWidthTd(td_f, width);
      }
      info += " " + width.toString();
      if (width == 0) {
        _lastWidth = null;
        if (timer == null && _timer == null) {
          info += " timer";
          _timer = new Timer.periodic(new Duration(milliseconds: 250), fixWidth);
          _fixWidthCount = 0;
        } else if (timer != null) {
          _fixWidthCount++;
          if (_fixWidthCount > 2) {
            timer.cancel();
            _timer = null;
          }
        }
        _log.fine(info);
        return;
      }
      String widthString = "${width}px";
      if (td != null) {
        td.style.width = widthString;
      }
      if (td_h != null) {
          td_h.style.width = widthString;
      }
      if (td_f != null) {
        td_f.style.width = widthString;
      }
    }
    _table.style.tableLayout = "fixed";
    if (_tableHead != null)
      _tableHead.style.tableLayout = "fixed";
    if (_tableFoot != null)
      _tableFoot.style.tableLayout = "fixed";
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
    _fixWidthCount = 0;
    _log.fine(info);
  } // fixWith
  int _fixWidthCount = 0;
  Timer _timer;

  /// return max width
  int _fixWidthTd(Element td, int width) {
    int w = width;
    td.style.removeProperty("width");
    int ow = td.offsetWidth;
    if (ow > w)
      w = ow;
    return w;
  } // fixWidthTx

  /// Table bordered
  bool get bordered => element.classes.contains(C_TABLE__BORDERED);
  /// Table bordered
  void set bordered (bool newValue) {
    element.classes.toggle(C_TABLE__BORDERED, newValue);
  }
  /// Table striped
  bool get striped => element.classes.contains(C_TABLE__STRIPED);
  /// Table striped
  void set striped (bool newValue) {
    element.classes.toggle(C_TABLE__STRIPED, newValue);
  }


  /**
   * Add Table Head Row
   * for responsive - use row.addHeaderCell to add name-label info
   */
  LTableHeaderRow addHeadRow(bool enableSort, {LTableHeaderRow row}) {
    if (row == null) {
      row = new LTableHeaderRow(this, createHeadRow(),
          headRowIndex,
          LText.C_TEXT_HEADING__LABEL,
          enableSort ? onTableSortClicked : null,
          tableActions);
      if (rowSelect && theadRows.isEmpty) {
        row.selectCb.onClick.listen((MouseEvent evt) {
          bool selValue = onTableHeadSelectClicked(row.selectCb);
          if (selValue != null)
            row.selectCb.checked = selValue;
        });
      }
    }
    _headerRow = row;
    /* } else if (row == null) {
      row = new LTableRow(this, createHeadRow(),
          headRowIndex,
          null, // rowValue
          LText.C_TEXT_HEADING__LABEL,
          LTableRow.TYPE_HEAD,
          null);
    } */
    row.editMode = _editMode;
    theadRows.add(row);
    // add urv
    if (recordAction != null && _ui != null) {
      row.addHeaderCell(DataRecord.URV, _ui.table.label);
    }
    return row;
  } // addHeadRow
  LTableHeaderRow _headerRow;

  /// create/add head row
  TableRowElement createHeadRow() {
    if (_thead == null) {
      if (_tableHead == null)
        _thead = _table.createTHead();
      else
        _thead = _tableHead.createTHead();
    }
    _headRowIndex++;
    return _thead.addRow();
  }
  int get headRowIndex => _headRowIndex;
  int _headRowIndex = -1;

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
    if (tbodyRows.length > 1) {
      if (sortRemoteOk && recordSorting.sortRemote()) {
        for (AppsAction action in tableActions) {
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
        _log.fine("sort local #${tbodyRows.length}");
        tbodyRows.sort((LTableRow one, LTableRow two) {
          return recordSorting.recordSortCompare(one.record, two.record);
        });
        _tbody.children.clear();
        for (LTableRow row in tbodyRows) {
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
    if (tableRowSelectClicked != null) {
      tableRowSelectClicked(data);
    }
  }

  /// table header
  bool onTableHeadSelectClicked(InputElement selectCb) {
    bool newValue = selectCb.checked;
    _log.config("onTableHeadSelectClicked ${newValue}");
    if (tableHeadSelectClicked == null) {
      selectAll(newValue);
    } else {
      bool selValue = tableHeadSelectClicked(newValue);
      if (selValue == null) {
        selectCb.checked = false;
      } else {
        selectAll(selValue);
      }
    }
    return null; // no change
  }

  /// Find In Table
  int findInTable(String findString) {
    int count = 0;
    RegExp regEx = LUtil.createRegExp(findString);
    if (regEx == null) {
      for (LTableRow row in tbodyRows) {
        row.record.clearIsMatchFind();
        row.show = true;
      }
      count = recordList.length;
    } else {
      for (LTableRow row in tbodyRows) {
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
      for (LTableRow row in tbodyRows) {
        row.record.clearIsMatchFind();
        row.show = true;
      }
      if (_withStatistics && _statisticsRow != null) {
        _statisticsRow.setStatistics(_statistics, lTableStatisticTotal(),
            rowSelect && tableActions.isNotEmpty);
      }
      if (graphSelectionChange != null)
        graphSelectionChange(null);
      return recordList.length;
    }
    // show matching
    int count = 0;
    for (LTableRow row in tbodyRows) {
      bool match = graphMatch(row.record);
      row.record.isMatchFind = match;
      row.show = match;
      if (match && !row.record.isGroupBy)
        count++;
    }
    if (_withStatistics && _statisticsRow != null) {
      TableStatistics temp = _statistics.summary(recordList);
      _statisticsRow.setStatistics(temp, lTableStatisticGraphSelect(),
          rowSelect && tableActions.isNotEmpty);
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
    for (LTableRow row in theadRows) {
      row.editMode = newValue;
    }
    for (LTableRow row in tbodyRows) {
      row.editMode = newValue;
    }
  }
  String _editMode = EDIT_RO;

  /**
   * Add Table Action - needs to be called before creating header
   */
  void addTableAction(AppsAction action) {
    tableActions.add(action);
    if (theadRows.isNotEmpty) {
      theadRows.first.addActions([action]);
    }
  } // addTableAction

  /**
   * Add Row Action - needs to be called before creating header
   */
  void addRowAction(AppsAction action) {
    rowActions.add(action);
  }

  /// Create and Add Table Body Row and set [record]
  /// - with optionally existing [row]
  LTableRow addBodyRow({String rowValue, LTableRow row, DRecord record, int rowNo}) {
    if (rowValue == null && record != null)
      rowValue = record.recordId;
    if (row == null) {
      row = new LTableRow(this, createBodyRow(),
          bodyRowIndex,
          rowValue,
          LButton.C_HINT_PARENT,
          LTableRow.TYPE_BODY,
          rowActions);
    }
    row.editMode = _editMode;
    row.tableSelectClicked = onTableRowSelectClicked;
    tbodyRows.add(row);
    if (record != null) {
      if (rowNo == null)
        rowNo = tbodyRows.length - 1;
      row.setRecord(record, rowNo);
    }
    return row;
  }
  /// create/add body row
  TableRowElement createBodyRow() {
    if (_tbody == null)
      _tbody = _table.createTBody();
    _bodyRowIndex++;
    return _tbody.addRow();
  }
  int get bodyRowIndex => _bodyRowIndex;
  int _bodyRowIndex = -1;

  /// Exclude Body Row with [record]
  LTableRow excludeBodyRow(DRecord record) {
    for (int i = 0; i < tbodyRows.length; i++) {
      LTableRow row = tbodyRows[i];
      if (row.record == record) {
        String info = "excludeBodyRow ${record.urv} #${i}";
        record.isExcluded = true;
        row.rowElement.remove(); // dom
        tbodyRows.removeAt(i); // table row
        if (!recordList.remove(record))
          info += " NOT found in recordList";
        displayFoot();
        _log.config(info);
        return row;
      }
    }
    return null;
  } // deleteBodyRow

  /// Delete Body Row with [record]
  LTableRow deleteBodyRow(DRecord record) {
    for (int i = 0; i < tbodyRows.length; i++) {
      LTableRow row = tbodyRows[i];
      if (row.record == record) {
        String info = "deleteBodyRow ${record.urv} #${i}";
        row.rowElement.remove(); // dom
        tbodyRows.removeAt(i); // table row
        if (!recordList.remove(record))
          info += " NOT found in recordList";
        displayFoot();
        _log.config(info);
        return row;
      }
    }
    return null;
  } // deleteBodyRow

  /// action row delete - override for server delete
  void onActionRowDelete(String value, DataRecord data, DEntry entry, var actionVar) {
    LTableRow row = deleteBodyRow(data.record);
    _log.config("onActionRowDelete row=${row}");
  } // onLineActionDelete

  /// action row reset
  void onActionRowReset(String value, DataRecord data, DEntry entry, var actionVar) {
    _log.config("onActionRowReset ${actionVar}");
    if (actionVar is LTableRow) {
      actionVar.data.resetRecord();
      actionVar.display(true);
    } else {
      data.resetRecord();
    }
    displayFoot();
  }

  /// action row exclude
  void onActionRowExclude(String value, DataRecord data, DEntry entry, var actionVar) {
    LTableRow row = excludeBodyRow(data.record);
    _log.config("onActionRowExclude row=${row}");
  } // onLineActionExclude

  /// get Body Row with record
  LTableRow getBodyRow(DRecord record) {
    for (LTableRow row in tbodyRows) {
      if (row.record == record)
        return row;
    }
    return null;
  }

  /// Add Table Foot Row
  LTableRow addFootRow({LTableRow row}) {
    if (row == null) {
      row = new LTableRow(
          this,
          createFootRow(),
          footRowIndex,
          null, // rowValue
          LButton.C_HINT_PARENT,
          LTableRow.TYPE_FOOT,
          null); // rowAction
    }
    tfootRows.add(row);
    return row;
  }

  /// create/add foot row
  TableRowElement createFootRow() {
    if (_tfoot == null) {
      if (_tableFoot == null)
        _tfoot = _table.createTFoot();
      else
        _tfoot = _tableFoot.createTFoot();
    }
    _footRowIndex++;
    return _tfoot.addRow();
  }
  int get footRowIndex => _footRowIndex;
  int _footRowIndex = -1;

  /// add sum row to Body (with a [record]) or Footer
  LTableSumRow addStatRow(DRecord record) {
    TableRowElement tr = null;
    int rowNo = 0;
    if (record == null) {
      tr = createFootRow();
      rowNo = footRowIndex;
    } else {
      tr = createBodyRow();
      rowNo = bodyRowIndex;
    }
    //
    LTableSumRow row = new LTableSumRow(this, tr,
        rowNo,
        LButton.C_HINT_PARENT,
        record == null ? LTableRow.TYPE_FOOT : LTableRow.TYPE_BODY);
    //
    if (record == null) {
      tfootRows.add(row);
    } else {
      tbodyRows.add(row);
      row.setRecord(record, tbodyRows.length - 1);
    }
    return row;
  } // addStatRow

  /// Select/Unselect All Body Rows
  void selectAll(bool select) {
    for (LTableRow row in tbodyRows) {
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
  /// set ui - does not initialize - use [setUi]
  void set ui (UI ui) {
    _ui = ui;
  }
  /// Table Meta Data
  final List<DataColumn> dataColumns = new List<DataColumn>();
  /// Statistics
  TableStatistics _statistics;

  /// Reset Table Structure
  void resetStructure() {
    _table.children.clear();
    if (_tableHead != null)
      _tableHead.children.clear();
    if (_tableFoot != null)
      _tableFoot.children.clear();
    _thead = null;
    _tbody = null;
    _tfoot = null;
    //
    theadRows.clear();
    tbodyRows.clear();
    tfootRows.clear();
    _headRowIndex = -1;
    _bodyRowIndex = -1;
    _footRowIndex = -1;
    //
    nameLabelMap.clear();
    nameList.clear();
    responsiveOverflow = _overflow;
  }


  /// Set Records
  void setRecords(List<DRecord> records) {
    recordList.clear();
    recordList.addAll(records);
    display();
    if (_headerRow != null) {
      _headerRow.setSorting(recordSorting);
    }
  } // setRecords

  /// clear table
  void clear() {
    if (_thead != null)
      _thead.children.clear();
    if (_tbody != null)
      _tbody.children.clear();
    if (_tfoot != null)
      _tfoot.children.clear();
    theadRows.clear();
    tbodyRows.clear();
    tfootRows.clear();

    nameLabelMap.clear();
    nameList.clear();
    recordList.clear();
  } // clear

  /// clear body
  void clearBody() {
    if (_tbody != null)
      _tbody.children.clear();
    tbodyRows.clear();
    recordList.clear();
  }

  /// clear all records + display
  void clearRecords() {
    setRecords(new List<DRecord>());
    displayFoot();
  }

  /// Display Records (calculates statistics)
  void display() {
    if (_tbody != null) {
      _tbody.children.clear();
      tbodyRows.clear();
      _bodyRowIndex = -1;
    }
    bool needSort = _displayCalculateStatistics();
    //_log.fine("display records=${recordList.length}");
    for (DRecord record in recordList) {
      if (record.hasIsExcluded() && record.isExcluded)
        continue;
      if (record.hasIsGroupBy()) {
        addStatRow(record);
      } else {
        addBodyRow(record: record); // adds to _tbodyRows
      }
    }
    if (needSort) {
      _sortGroupBy(); // LTableRow
    }

    // Statistics
    if (_withStatistics && _statistics != null) {
      if (_statisticsRow == null)
        _statisticsRow = addStatRow(null); // LTableSumRow
      _statisticsRow.setStatistics(_statistics, null,
          rowSelect && tableActions.isNotEmpty);
    } else {
      if (_statisticsRow != null) {
        _statisticsRow.rowElement.remove();
        tfootRows.remove(_statisticsRow);
      }
    }
    fixWidth(null);
  } // display
  LTableSumRow _statisticsRow;

  /// update / display footer
  /// - [LTableRow#setRecord] [LTableRow#onRecordChange]
  void displayFoot() {
    for (LTableRow row in tfootRows) {
      row.display(false);
    }
  } // displayFooter


  /// show/hide column
  void showColumn(String columnName, bool newValue) {
    int index = nameList.indexOf(columnName);
    if (index < 0) {
      _log.config("showColumn ${columnName} NotFound");
      return;
    }
    if (newValue) {
      _hideColumnNameSet.remove(columnName);
    } else {
      _hideColumnNameSet.add(columnName);
    }
    if (rowSelect || rowActions.isNotEmpty) {
      index++; // first column
    }
    _hideColumnIndexList = null; // recalc
    _log.fine("showColumn ${columnName} #${index} ${newValue}");
    for (LTableHeaderRow row in theadRows) {
      row.showColumn(index, newValue);
    }
    for (LTableRow row in tbodyRows) {
      row.showColumn(index, newValue);
    }
    for (LTableRow row in tfootRows) {
      row.showColumn(index, newValue);
    }
  } // showColumn
  final Set<String> _hideColumnNameSet = new Set<String>();

  /// hidden column index list
  List<int> get hideColumnIndexList {
    if (_hideColumnIndexList == null) {
      _hideColumnIndexList = new List<int>();
      for (String columnName in _hideColumnNameSet) {
        int index = nameList.indexOf(columnName);
        if (rowSelect || rowActions.isNotEmpty) {
          index++; // first column
        }
        _hideColumnIndexList.add(index);
      }
    }
    return _hideColumnIndexList;
  }
  List<int> _hideColumnIndexList = new List<int>();

  /// Table selected row count
  int get selectedRowCount {
    int count = 0;
    for (LTableRow row in tbodyRows) {
      if (row.selected)
        count++;
    }
    return count;
  }

  /// Table selected row records
  List<DRecord> get selectedRecords {
    List<DRecord> records = new List<DRecord>();
    for (LTableRow row in tbodyRows) {
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
    TableRowElement tr = createHeadRow();
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
    TableRowElement tr = createBodyRow();

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
    TableRowElement tr = createBodyRow();

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
    TableRowElement tr = createBodyRow();

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


  /// Show Info Element (below table)
  void set infoShow (bool newValue) {
    if (newValue) {
      if (_info == null) {
        infoText = "";
      }
    } else if (_info != null) {
      _info.remove();
      _info = null;
    }
  }
  Element _info;
  bool get infoShow => _info != null && _info.parent != null;

  // show Info Element (below table) with text
  void set infoText (String newValue) {
    if (newValue == null) {
      if (_info != null) {
        _info.remove();
        _info = null;
      }
    } else {
      if (_info == null) {
        _info = new DivElement()
          ..classes.add(C_INFO_BOTTOM);
      } else {
        _info.remove();
      }
      // add to wrapper or below table/wrapper
      if (_wrapper == null || _overflow == LTableResponsive.OVERFLOW_HEAD_FOOT) {
        Element ee = _wrapper == null ? _table : _wrapper;
        if (ee.parent != null) {
          if (ee.parent.children.length == 1) {
            ee.parent.append(_info);
          } else {
            ee.parent.insertBefore(_info, _table.nextElementSibling);
          }
        }
      } else {
        _wrapper.append(_info);
      }
      _info.text = newValue;
    }
  }
  String get infoText => _info == null ? null : _info.text;

  /// set info size - true=10rem|false=2rem|null=6rem - set after show/text
  void set infoSize (bool large) {
    if (_info != null) {
      if (large != null) {
        _info.classes.toggle("large", large);
        _info.classes.toggle("small", !large);
      } else {
        _info.classes.removeAll(["large", "small"]);
      }
    }
  } // info size


  static String lTableRowSelectAll() => Intl.message("Select All", name: "lTableRowSelectAll", args: []);
  static String lTableRowSelectRow() => Intl.message("Select Row", name: "lTableRowSelectRow", args: []);

  static String lTableColumnSortAsc() => Intl.message("Sort Ascending", name: "lTableColumnSortAsc", args: []);
  static String lTableColumnSortDec() => Intl.message("Sort Decending", name: "lTableColumnSortDec", args: []);

  static String lTableStatisticTotal() => Intl.message("Total", name: "lTableStatisticTotal");
  static String lTableStatisticGraphSelect() => Intl.message("Graph Selection", name: "lTableStatisticGraphSelect");
  static String lTableStatisticMatchSelect() => Intl.message("Match Selection", name: "lTableStatisticMatchSelect");


} // LTable


enum LTableResponsive {
  NONE,
  OVERFLOW_X,
  OVERFLOW_HEAD,
  OVERFLOW_HEAD_FOOT
}
