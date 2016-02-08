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
class ObjectCtrl
    extends LComponent {

  static final Logger _log = new Logger("ObjectCtrl");

  /// Object / Table Element
  final Element element = new Element.section();

  /// Header
  LObjectHome _header;
  /// Content
  final CDiv _content = new CDiv.article();
  /// Record Control (single record view)
  RecordCtrl recordCtrl;
  /// Meta Data
  final Datasource datasource;

  /**
   * Object Controller
   */
  ObjectCtrl(Datasource this.datasource,
      {String containerClass: LGrid.C_CONTAINER__FLUID,
      bool queryExecute:true}) {
    String idPrefix = "oc-" + datasource.tableName;
    element.id = idPrefix;
    if (containerClass != null && containerClass.isNotEmpty) {
      element.classes.add(containerClass);
    }
    // Header
    _header = new LObjectHome(onSortClicked, idPrefix:idPrefix,
        onGraphClick: onGraphClick);
    element.append(_header.element);
    // Content
    _content.element.id = "${idPrefix}-content";
    _content.element.style.minHeight = "100px";
    element.append(_content.element);

    // layout change table/..
    _header.viewLayoutChange = onViewLayoutChange;
    // find
    _header.findEditorChange = onFindEditorChange;

    _header.filterList.settings.dropdown.editorChange = onFilterChange;
    _header.filterList.filterSelectionChange = onFilterSelectionChange;

    // load UI
    _header.loading = true;
    datasource.uiFuture()
    .then((UI ui) {
      element.attributes[Html0.DATA_VALUE] = ui.tableName;
      UiUtil.validate(ui);
      _header.setUi(ui);
      // actions
      _header.addAction(AppsAction.createRefresh(onAppsActionRefresh)
        ..showLabel = false);
      if (!ui.isReadOnly) {
        _header.addAction(AppsAction.createNew(onAppsActionNew));
      }
      _header.loading = false;

      // TODO _header.filterList.addFilter()
      if (queryExecute)
        _doQuery();
    })
    .catchError((error, stackTrace) {
      _header.loading = false;
      _log.warning(idPrefix, error, stackTrace);
      _header.setUiFail("${error}");
    });


  } // ObjectCtrl

  // ObjectCtrl

  /// table name
  String get tableName => datasource.tableName;

  /// Find in Table
  void onFindEditorChange(String name, String findString, DEntry entry, var details) {
    if (_table != null) {
      int count = _table.findInTable(findString);
      _log.config("onFindEditorChange ${tableName} '${findString}' #${count}");
      _displaySummary(findString: findString, findCount: count);
    }
  }

  /// Editor Change callback
  void onViewLayoutChange(String name, String newValue, DEntry ignored, var details) {
    _log.config("onViewLayoutChange ${tableName} ${newValue}");
    display();
  }

  /// Filter Change
  void onFilterChange(String name, String newValue, DEntry entry, var details) {
    // see LObjectHomeFilter
    String filter = _header.filterList.filterValue;
    SavedQuery query = _header.filterList.savedQuery;
    _log.config("onFilterChange ${tableName} ${newValue} ${filter}");
    if (newValue != AppsAction.NEW && (filter == LObjectHomeFilter.RECENT || filter == LObjectHomeFilter.ALL)) {
      AppsAction filterNew = AppsAction.createYes(onFilterNewConfirmed);
      LConfirmation conf = new LConfirmation("fn",
          title: objectCtrlFilterNew(),
          text: objectCtrlFilterNewText(),
          actions:[filterNew],
          addCancel: true);
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
      LConfirmation conf = new LConfirmation("fn",
          title: objectCtrlFilterDelete(),
          text: objectCtrlFilterDeleteText(),
          contentElements:[ul],
          actions:[filterDelete],
          addCancel: true);
      conf.showInElement(element);
      return;
    }
    if (newValue == AppsAction.NEW) {
      query = new SavedQuery();
    }
    ObjectFilter fe = new ObjectFilter(datasource.tableDirect, query, onFilterUpdated);
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
      ObjectFilter fe = new ObjectFilter(datasource.tableDirect, new SavedQuery(), onFilterUpdated);
      fe.modal.showInElement(element);
    }
  }

  /// callback after filter updated
  Future<SResponse> onFilterUpdated(SavedQuery query) {
    _log.config("onFilterUpdated NIY");
    Completer<SResponse> completer = new Completer<SResponse>();
    // TODO add query to lookup + set active
    // save query
    // execute query
    completer.completeError(null);
    return completer.future;
  }

  /// Filter changed - query
  void onFilterSelectionChange(String name, SavedQuery savedQuery) {
    _log.config("onFilterSelectionChange ${tableName} ${name}");
    _doQuery();
  }

  void _doQuery() {
    String filter = _header.filterList.filterValue;
    _log.config("doQuery ${tableName} ${filter}");
    _content.loading = true;
    _header.summary = "${objectCtrlQuerying()} ...";
    datasource.query()
    .then((DataResponse response) {
      _header.summary = "${objectCtrlProcessing()} ...";
      display();
      _content.loading = false;
    });
  } // doQuery

  // display
  void display() {
    _content.clear();
    if (datasource.recordList == null || datasource.recordList.isEmpty) {
      DivElement div = new DivElement()
        ..classes.addAll([LTheme.C_THEME__SHADE, LText.C_TEXT_ALIGN__CENTER])
        ..style.lineHeight = "200px"
        ..style.verticalAlign = "middle"
        ..text = objectCtrlNoRecordInfo();
      _content.append(div);
      _displaySummary();
    } else {
      String viewLayout = _header.viewLayout;
      if (viewLayout == LObjectHome.VIEW_LAYOUT_COMPACT) {
        if (_table != null)
          _table.element.remove();
        if (_cardPanel != null)
          _cardPanel.element.remove();
        _displayCompact();
      } else if (viewLayout == LObjectHome.VIEW_LAYOUT_CARDS) {
        if (_table != null)
          _table.element.remove();
        if (_cardCompact != null)
          _cardCompact.element.remove();
        _displayCards();
      } else /* if (viewLayout == LObjectHome.VIEW_LAYOUT_TABLE) */ {
        if (_cardCompact != null)
          _cardCompact.element.remove();
        if (_cardPanel != null)
          _cardPanel.element.remove();
        _displayTable();
      }
      _displaySummary();
    }
    if (recordCtrl != null) {
      DRecord oldRecord = recordCtrl.record;
      bool found = false;
      for (DRecord record in datasource.recordList) {
        if (oldRecord.hasRecordId()) {
          if (oldRecord.recordId == record.recordId) {
            recordCtrl.record = record;
            found = true;
            break;
          }
        } else if (oldRecord.hasUrv()) {
          if (oldRecord.urv == record.urv) {
            recordCtrl.record = record;
            found = true;
            break;
          }
        }
      }
      if (!found) {
        recordCtrl.record = new DRecord(); // empty
        // TODO close detail
      }
    }
  } // display

  /// display summary
  void _displaySummary({String findString, int findCount}) {
    if (datasource.recordList == null || datasource.recordList.isEmpty) {
      _header.summary = objectCtrlNoRecords();
    } else if (datasource.recordList.length == 1) {
      _header.summary = objectCtrl1Record();
    } else if (datasource.recordSorting.isEmpty) {
      String info = "${datasource.recordList.length} ${objectCtrlRecords()}";
      if (findString != null && findString.isNotEmpty) {
        info += " (${findCount} ${objectCtrlMatching()} '${findString}')";
      }
      _header.summary = info;
    } else {
      String info = "${datasource.recordList.length} ${objectCtrlRecords()} ${LUtil.DOT_SPACE} ${objectCtrlSortedBy()}";
      String prefix = " ";
      for (RecordSort sort in datasource.recordSorting.list) {
        info += prefix + sort.columnLabel + (sort.isAscending ? LUtil.SORT_ASC : LUtil.SORT_DESC);
        prefix = LUtil.DOT_SPACE;
      }
      if (findString != null && findString.isNotEmpty) {
        info += " (${findCount} ${objectCtrlMatching()} '${findString}')";
      }
      _header.summary = info;
    }
  } // displaySummary

  /**
   * UI Table
   */
  void _displayTable() {
    if (_table == null) {
      _table = new TableCtrl(idPrefix: id,
          tableUi: datasource.ui,
          optionCreateNew: true,
          optionRowSelect: true,
          recordSorting: datasource.recordSorting,
          optionLayout: true,
          optionEdit: true,
          editMode: LTable.EDIT_FIELD,
          alwaysOneEmptyLine: false)
        ..bordered = true
        ..responsiveOverflow = true
        ..withStatistics = true;
      _table.recordSaved = onRecordSaved;
      _table.recordDeleted = onRecordDeleted;
      _table.recordsDeleted = onRecordsDeleted;
      _table.setRecords(datasource.recordList, recordAction: onAppsActionRecord); // urv click
    }
    if (_table.element.parent == null) {
      _content.add(_table);
    }
  } // displayTable
  TableCtrl _table;

  /**
   * Card Panel
   */
  void _displayCards() {
    if (_cardPanel == null) {
      _cardPanel = new CardPanel(id);
      _cardPanel.setUi(datasource.ui); // header
      _cardPanel.setRecords(datasource.recordList, recordAction: onAppsActionRecord); // urv click
    }
    if (_cardPanel.element.parent == null) {
      _content.add(_cardPanel);
    }
  }
  CardPanel _cardPanel;

  /**
   * Compact
   */
  void _displayCompact() {
    if (_cardCompact == null) {
      _cardCompact = new LCardCompact(id);
      _cardCompact.setUi(datasource.ui); // header
      _cardCompact.addTableAction(AppsAction.createNew(onAppsActionNew));
      _cardCompact.addTableAction(AppsAction.createLayout(onAppsActionCompactLayout));

      _cardCompact.addRowAction(AppsAction.createEdit(onAppsActionEdit));
      _cardCompact.addRowAction(AppsAction.createDelete(onAppsActionDelete));
      _cardCompact.setRecords(datasource.recordList, recordAction: onAppsActionRecord); // urv click
    }
    if (_cardCompact.element.parent == null) {
      _content.add(_cardCompact);
    }
  } // displayTable
  LCardCompact _cardCompact;


  /// Sort Dropdown selected
  void onSortClicked(String name, bool asc, DataType dataType, MouseEvent evt) {
    if (_table != null) {
      _table.onTableSortClicked(name, asc, dataType, evt);
    }
  }

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
    DataRecord data = new DataRecord(null)
      ..table = datasource.tableDirect;
    DRecord parentRecord = null;
    DRecord newRecord = data.newRecord(parentRecord);
    //
    ObjectEdit oe = new ObjectEdit(datasource.ui);
    oe.setRecord(newRecord, -1);
    oe.recordSaved = onRecordSaved;
    oe.modal.showInElement(element);
  } // onAppsActionNew


  /// Application Action Refresh/Requery
  void onAppsActionRefresh(String value, DRecord record, DEntry entry, var actionVar) {
    _log.config("onAppsActionRefresh ${tableName}");
    _doQuery();
  }


    /// Record Saved (from new/table)
  Future<SResponse> onRecordSaved(DRecord record) {
    _log.config("onRecordSaved ${tableName}");
    Completer<SResponse> completer = new Completer<SResponse>();
    _content.loading = true;
    datasource.save(record)
    .then((DataResponse response) {
      completer.complete(response.response);
      display();
      _content.loading = false;
    });
    return completer.future;
  }

  /// Record Deleted (from table)
  Future<SResponse> onRecordDeleted(DRecord record) {
    _log.config("onRecordDeleted ${tableName}");
    Completer<SResponse> completer = new Completer<SResponse>();
    _content.loading = true;
    datasource.delete(record)
    .then((DataResponse response) {
      completer.complete(response.response);
      display();
      _content.loading = false;
    });
    return completer.future;
  }

  /// Records Deleted (from table)
  Future<SResponse> onRecordsDeleted(List<DRecord> records) {
    _log.config("onRecordsDeleted ${tableName}");
    Completer<SResponse> completer = new Completer<SResponse>();
    _content.loading = true;
    datasource.deleteAll(records)
    .then((DataResponse response) {
      completer.complete(response.response);
      display();
      _content.loading = false;
    });
    return completer.future;
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
      LConfirmation conf = new LConfirmation("ds",
          title: TableCtrl.tableCtrlDelete1Record(),
          text:TableCtrl.tableCtrlDelete1RecordText(),
          contentElements:[ul],
          actions:[deleteYes],
          addCancel: true);
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
      LConfirmation conf = new LConfirmation("ds",
          title: TableCtrl.tableCtrlDeleteRecords(),
          text: TableCtrl.tableCtrlDeleteRecordsText(),
          contentElements:[ul],
          actions:[deleteYes],
          addCancel: true);
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

  /// Switch to Record Edit mode
  void _switchRecordCtrl(DRecord record, String editMode) {
    if (recordCtrl == null) {
      recordCtrl = new RecordCtrl(datasource.ui);
      recordCtrl._details.recordSaved = onRecordSaved;

      AnchorElement back = new AnchorElement(href: "#")
        ..id = "${id}-back"
        ..text = "${LUtil.ARROW_LEFT_D} ${objectCtrlBackList()}"
        ..tabIndex = -1;
      back.onClick.listen((Event evt){
        evt.preventDefault();
        showRecord = false;
      });
      _recordCtrlBack = new DivElement()
        ..classes.add(LPadding.C_AROUND__XX_SMALL)
        ..append(back);
      element.parent.append(_recordCtrlBack);
      element.parent.append(recordCtrl.element);
    }
    recordCtrl.editMode = editMode;
    recordCtrl.record = record;
    showRecord = true;
  }
  DivElement _recordCtrlBack;

  /// toggle record/list view
  void set showRecord (bool newValue) {
    if (recordCtrl == null)
      return;
    if (newValue) {
      _recordCtrlBack.classes.remove(LVisibility.C_HIDE);
      recordCtrl.element.classes.remove(LVisibility.C_HIDE);
      element.classes.add(LVisibility.C_HIDE);
    } else {
      element.classes.remove(LVisibility.C_HIDE);
      _recordCtrlBack.classes.add(LVisibility.C_HIDE);
      recordCtrl.element.classes.add(LVisibility.C_HIDE);
    }
  } // showRecord


  /// Application Action Compact Layout
  void onAppsActionCompactLayout(String value, DRecord record, DEntry entry, var actionVar) {
    _log.config("onAppsActionCompactLayout ${tableName} ${value}");
  }


  void onGraphClick(MouseEvent evt) {
    if (_graph == null) {
      _graph = new GraphElement(datasource, _table, true);
      element.insertBefore(_graph.element, _content.element);
    }
    _graph.syncTable = _table;
    _graph.show = true;
  }
  GraphElement _graph;

  bool get graphEnabled => _header.graphEnabled;
  void set graphEnabled (bool newValue) {
    _header.graphEnabled = newValue;
  }


  static String objectCtrlQuerying() => Intl.message("Querying", name: "objectCtrlQuerying");
  static String objectCtrlProcessing() => Intl.message("Processing", name: "objectCtrlProcessing");

  static String objectCtrlMatching() => Intl.message("matching", name: "objectCtrlMatching");
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

  static String objectCtrlBackList() => Intl.message("Back to List", name: "objectCtrlBackList");


} // ObjectCtrl
