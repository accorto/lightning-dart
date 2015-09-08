/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;


/**
 * Object/Table Controller
 * = List Records in Grid
 * = Search "saved queries"
 * = ability to define filters
 *
 * Structure
 * - LObjectHome
 * - Table
 * -- Row
 *    - click: RecordCtrl
 *    - action: Edit/Delete
 */
class ObjectCtrl extends LComponent {

  static final Logger _log = new Logger("ObjectCtrl");

  /// Object / Table Element
  final Element element = new Element.section();
  /// Header
  final LObjectHome _header = new LObjectHome();
  /// Content
  final CDiv _content = new CDiv.article();
  /// Record Control (single record view)
  RecordCtrl recordCtrl;

  /// Meta Data
  final UI ui;
  /// Actual Data Records
  List<DRecord> _records;


  /**
   * Object Controller
   */
  ObjectCtrl(UI this.ui) {
    element.append(_header.element);
    element.append(_content.element);
    //
    _header.setUi(ui);
    // layout change table/..
    _header.viewLayoutChange = onViewLayoutChange;
    // find
    _header.findEditorChange = onFindEditorChange;

    // Actions
    if (!ui.isReadOnly)
      _header.addAction(AppsAction.createNew(onAppsActionNew));

    _header.filterList.settings.dropdown.editorChange = onFilterChange;

    //_header.filterList.addFilter()
    _header.filterList.filterSelectionChange = onFilterSelectionChange;
    _doQuery();
  } // ObjectCtrl

  /// table name
  String get tableName => ui.tableName;

  /// Find in Table
  void onFindEditorChange(String name, String newValue, DEntry entry, var details) {
    _log.config("onFindEditorChange ${tableName} ${newValue}");
    if (_table != null) {
      _table.findInTable(newValue);
    }
  }

  /// Editor Change callback
  void onViewLayoutChange(String name, String newValue, DEntry ignored, var details) {
    _log.config("onViewLayoutChange ${tableName} ${newValue}");
    _display();
  }

  /// Filter Change
  void onFilterChange(String name, String newValue, DEntry entry, var details) {
    // see LObjectHomeFilter
    String filter = _header.filterList.filterValue;
    SavedQuery query = _header.filterList.savedQuery;
    _log.config("onFilterChange ${tableName} ${newValue} ${filter}");
    if (newValue != AppsAction.NEW && (filter == LObjectHomeFilter.RECENT || filter == LObjectHomeFilter.ALL)) {
      AppsAction filterNew = AppsAction.createYes(onFilterNewConfirmed);
      LConfirmation conf = new LConfirmation("fn", label: objectCtrlFilterNew(),
        text:objectCtrlFilterNewText(),
        actions:[filterNew], addCancel: true);
      conf.showInElement(element);
      return;
    }
    if (newValue == AppsAction.DELETE) {
      LIElement li = new LIElement()
        ..text = filter;
      UListElement ul = new UListElement()
        ..classes.add(LList.C_LIST__DOTTED)
        ..append(li);
      AppsAction filterDelete = AppsAction.createYes(onFilterDeleteConfirmed)
        ..actionVar = query;
      LConfirmation conf = new LConfirmation("fn", label: objectCtrlFilterDelete(),
        text:objectCtrlFilterDeleteText(), contentElements:[ul],
        actions:[filterDelete], addCancel: true);
      conf.showInElement(element);
      return;
    }
    if (newValue == AppsAction.NEW) {
      query = new SavedQuery();
    }
    ObjectFilter fe = new ObjectFilter(ui.table, query, onFilterUpdated);
    fe.modal.showInElement(element);
  }
  void onFilterDeleteConfirmed(String value, DRecord record, DEntry entry, var actionVar) {
    if (value == AppsAction.YES && actionVar is SavedQuery) {
      SavedQuery query = actionVar as SavedQuery;
      _log.config("onFilterDeleteConfirmed ${tableName} ${value} ${query.name}");
    }
  }
  void onFilterNewConfirmed(String value, DRecord record, DEntry entry, var actionVar) {
    if (value == AppsAction.YES) {
      ObjectFilter fe = new ObjectFilter(ui.table, new SavedQuery(), onFilterUpdated);
      fe.modal.showInElement(element);
    }
  }
  /// callback after filter updated
  void onFilterUpdated(SavedQuery query) {
    // add query to lookup + set active
    // save query
    // execute query
  }

  /// Filter changed - query
  void onFilterSelectionChange(String name, SavedQuery savedQuery) {
    _log.config("onFilterSelectionChange ${tableName} ${name}");
    _doQuery();
  }
  void _doQuery() {
    String filter = _header.filterList.filterValue;
    _log.config("doQuery ${tableName} ${filter}");
    // set lists
    // get current list
    _display();
  }


  /// Display Items
  void display(List<DRecord> records) {
    _records = records;
    _display();
  } // display
  void _display() {
    _content.clear();
    if (_records == null || _records.isEmpty) {
      _header.summary = objectCtrlNoRecords();
      DivElement div = new DivElement()
        ..classes.addAll([LTheme.C_THEME__SHADE, LText.C_TEXT_ALIGN__CENTER])
        ..style.lineHeight = "200px"
        ..style.verticalAlign = "middle"
        ..text = objectCtrlNoRecordInfo();
      _content.append(div);
    } else {
      String viewLayout = _header.viewLayout;
      _table = null; // reset
      _cardCompact = null;
      if (viewLayout == LObjectHome.VIEW_LAYOUT_COMPACT) {
        _displayCompact();
        onTableSorted(null);
      //} else if (viewLayout == LObjectHome.VIEW_LAYOUT_CARDS) {
      //  _displayCards();
      } else /* if (viewLayout == LObjectHome.VIEW_LAYOUT_TABLE) */ {
        _displayTable();
        onTableSorted(_table.tableSorting);
      }
    }
  } // display

  /// Display Table Sort
  void onTableSorted(List<LTableSort> tableSorting) {
    if (_records.length == 1) {
      _header.summary = objectCtrl1Record();
    } else if (tableSorting == null || tableSorting.isEmpty) {
      _header.summary = "${_records.length} ${objectCtrlRecords()}";
    } else {
      String info = "${_records.length} ${objectCtrlRecords()} ${LightningDart.DOT} ${objectCtrlSortedBy()}";
      String prefix = " ";
      for (LTableSort sort in tableSorting) {
        info += prefix + sort.columnLabel + (sort.asc ? "\u{2193}" : "\u{2191}");
        prefix = LightningDart.DOT;
      }
      _header.summary = info;
    }
  }


  /**
   * Table
   */
  void _displayTable() {
    _table = new TableCtrlUi(ui, idPrefix:id, editMode:LTable.EDIT_FIELD)
      ..bordered = true;
    _table.recordSaved = onRecordSaved;
    _table.recordDeleted = onRecordDeleted;
    _table.recordsDeleted = onRecordsDeleted;
    _table.tableSorted = onTableSorted;
    _table.setRecords(_records, recordAction:onAppsActionRecord); // urv click
    _content.add(_table);
  } // displayTable
  TableCtrl _table;

  /**
   * Compact
   */
  void _displayCompact() {
    _cardCompact = new LCardCompact(id);
    _cardCompact.setUi(ui); // header
    _cardCompact.addTableAction(AppsAction.createNew(onAppsActionNew));
    _cardCompact.addTableAction(AppsAction.createLayout(onAppsActionCompactLayout));

    _cardCompact.addRowAction(AppsAction.createEdit(onAppsActionEdit));
    _cardCompact.addRowAction(AppsAction.createDelete(onAppsActionDelete));
    _cardCompact.display(_records, recordAction:onAppsActionRecord); // urv click
    _content.add(_cardCompact);
  } // displayTable
  LCardCompact _cardCompact;



  /// Table selected row count
  int get selectedRowCount {
    if (_table != null) {
      return _table.selectedRowCount;
    }
    return 0;
  }
  /// Get Selected Records or null
  List<DRecord> get selectedRecords {
    if (_table != null)
      return _table.selectedRecords;
    return null;
  }


  /// Application Action Record - clicked on urv
  void onAppsActionRecord(String value, DRecord record, DEntry entry, var actionVar) {
    _log.config("onAppsActionRecord ${tableName} ${value} ${record.recordId}");
    _switchRecordCtrl(record, RecordCtrl.EDIT_FIELD);
  } // onAppsActionRecord

  /// Application Action New (if not table)
  void onAppsActionNew(String value, DRecord record, DEntry entry, var actionVar) {
    _log.config("onAppsActionNew ${tableName} ${value}");
    DRecord newRecord = new DataRecord(null).newRecord(ui.table, null);
    //
    ObjectEdit oe = new ObjectEdit(ui);
    oe.setRecord(newRecord, -1);
    oe.recordSaved = onRecordSaved;
    oe.modal.showInElement(element);
  } // onAppsActionNew

  /// Record Saved (from new/table)
  String onRecordSaved(DRecord record) {
    _log.config("onRecordSaved ${tableName}");
    if (record.hasRecordId()) {
      // TODO update
    } else {
      // TODO save
      _records.add(record);
    }
    _display();
    return null;
  }

  /// Record Deleted (from table)
  String onRecordDeleted(DRecord record) {
    _log.config("onRecordDeleted ${tableName}");
    // TODO delete
    _records.remove(record);
    _display();
    return null;
  }

  /// Records Deleted (from table)
  String onRecordsDeleted(List<DRecord> records) {
    _log.config("onRecordsDeleted ${tableName}");
    // TODO delete
    for (DRecord record in records) {
      _records.remove(record);
    }
    _display();
    return null;
  }



  /// Application Action Delete
  void onAppsActionDelete(String value, DRecord record, DEntry entry, var actionVar) {
    if (record != null) {
      _log.config("onAppsActionDelete ${tableName} ${value}");
      LIElement li = new LIElement()
          ..text = record.drv;
      UListElement ul = new UListElement()
        ..classes.add(LList.C_LIST__DOTTED)
        ..append(li);
      AppsAction deleteYes = AppsAction.createYes(onAppsActionDeleteConfirmed)
        ..actionVar = record;
      LConfirmation conf = new LConfirmation("ds", label:TableCtrl.tableCtrlDelete1Record(),
        text:TableCtrl.tableCtrlDelete1RecordText(), contentElements:[ul],
        actions:[deleteYes], addCancel: true);
      conf.showInElement(element);
    }
  } // onAppsActionDelete
  /// Application Action Delete Confirmed
  void onAppsActionDeleteConfirmed(String value, DRecord record, DEntry entry, var actionVar) {
    if (actionVar is DRecord && value == AppsAction.YES) {
      DRecord record = actionVar;
      _log.info("onAppsActionDeleteConfirmed ${tableName} ${value} id=${record.recordId}");
      onRecordDeleted(record);
    }
  } // onAppsActionDeleteConfirmed

  /// Application Action Delete Selected Records
  void onAppsActionDeleteSelected(String value, DRecord record, DEntry entry, var actionVar) {
    _log.config("onAppsActionDeleteSelected ${tableName} ${value}");
    List<DRecord> records = selectedRecords;
    if (records == null || records.isEmpty) {
      LToast toast = new LToast(label: "No rows selected");
      toast.showBottomRight(element, autohideSeconds: 15);
    } else {
      UListElement ul = new UListElement()
        ..classes.add(LList.C_LIST__DOTTED);
      for (DRecord record in records) {
        LIElement li = new LIElement()
          ..text = record.drv;
        ul.append(li);
      }
      AppsAction deleteYes = AppsAction.createYes(onAppsActionDeleteSelectedConfirmed)
        ..actionVar = records;
      LConfirmation conf = new LConfirmation("ds", label: TableCtrl.tableCtrlDeleteRecords(),
        text:TableCtrl.tableCtrlDeleteRecordsText(), contentElements:[ul],
        actions:[deleteYes], addCancel: true);
      conf.showInElement(element);
    }
  }
  /// Application Action Delete Selected Record Confirmed
  void onAppsActionDeleteSelectedConfirmed(String value, DRecord record, DEntry entry, var actionVar) {
    if (actionVar is List<DRecord> && value == AppsAction.YES) {
      List<DRecord> records = actionVar;
      _log.info("onAppsActionDeleteSelectedConfirmed ${tableName} ${value} #${records.length}");
      onRecordsDeleted(records);
    }
  }


  /// Application Action Edit
  void onAppsActionEdit(String value, DRecord record, DEntry entry, var actionVar) {
    _log.config("onAppsActionEdit ${tableName} ${value} id=${record.recordId}");
    _switchRecordCtrl(record, RecordCtrl.EDIT_RW);
    // ObjectEdit oe = new ObjectEdit(ui);
    // oe.setRecord(record, );
    // oe.recordSaved = onRecordSaved;
    // oe.modal.showInElement(element);
  }

  void _switchRecordCtrl(DRecord record, String editMode) {
    if (recordCtrl == null) {
      recordCtrl = new RecordCtrl(ui);
      recordCtrl.element.classes.add(LMargin.C_TOP__X_LARGE);
      element.parent.append(recordCtrl.element);
    }
    recordCtrl.editMode = editMode;
    recordCtrl.record = record;
  }

  /// Application Action Compact Layout
  void onAppsActionCompactLayout(String value, DRecord record, DEntry entry, var actionVar) {
    _log.config("onAppsActionCompactLayout ${tableName} ${value}");
  }


  static String objectCtrlNoRecords() => Intl.message("No records", name: "objectCtrlNoRecords");
  static String objectCtrlNoRecordInfo() => Intl.message("No records to display - change Filter or create New", name: "objectCtrlNoRecordInfo");
  // query
  static String objectCtrl1Record() => Intl.message("One record", name: "objectCtrl1Record");
  static String objectCtrlRecords() => Intl.message("records", name: "objectCtrlRecords");
  static String objectCtrlSortedBy() => Intl.message("Sorted by", name: "objectCtrlSortedBy");


  static String objectCtrlFilterNew() => Intl.message("Create new Filter?", name: "objectCtrlFilterNew");
  static String objectCtrlFilterNewText() => Intl.message("The current filer cannot be changed. Do you wnat to create a new Filter?", name: "objectCtrlFilterNewText");
  static String objectCtrlFilterDelete() => Intl.message("Delete Filter?", name: "objectCtrlFilterDelete");
  static String objectCtrlFilterDeleteText() => Intl.message("Do you want to delete the current filter?", name: "objectCtrlFilterDeleteText");


} // ObjectCtrl
