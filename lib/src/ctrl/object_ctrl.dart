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
    _header.viewLayoutChange = onViewLayoutChange;

    // Actions
    _header.addAction(AppsAction.createNew(onAppsActionNew));

    //_header.filterList.addFilter()
    _header.filterList.filterSelectionChange = onFilterSelectionChange;
    _doQuery();
  } // ObjectCtrl

  /// table name
  String get tableName => ui.tableName;


  /// Editor Change callback
  void onViewLayoutChange(String name, String newValue, DEntry ignored, var details) {
    _log.config("onViewLayoutChange ${tableName} ${newValue}");
    _display();
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
      _header.summary = lObjectCtrlNoRecords();
      DivElement div = new DivElement()
        ..classes.addAll([LTheme.C_THEME__SHADE, LText.C_TEXT_ALIGN__CENTER])
        ..style.lineHeight = "200px"
        ..style.verticalAlign = "middle"
        ..text = lObjectCtrlNoRecordInfo();
      _content.append(div);
    } else {
      String viewLayout = _header.viewLayout;
      _table = null; // reset
      if (viewLayout == LObjectHome.VIEW_LAYOUT_TABLE) {
        _displayTable();
      }


      if (_records.length == 1)
        _header.summary = lObjectCtrl1Record();
      else
        _header.summary = "${_records.length} ${lObjectCtrlRecords()} * ${lObjectCtrlSortedBy()} x";
    }

  } // display

  LTable _table;
  void _displayTable() {
    _table = new LTable("id", true)
      ..bordered = true;
    _table.setUi(ui); // header
    _table.addTableAction(AppsAction.createNew(onAppsActionNew));
    _table.addTableAction(AppsAction.createDeleteSelected(onAppsActionDeleteSelected));
    _table.addRowAction(AppsAction.createEdit(onAppsActionEdit));
    _table.addRowAction(AppsAction.createDelete(onAppsActionDelete));
    _table.display(_records, viewAction:onAppsActionView);
    _content.add(_table);
  } // displayTable

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


  /// Application Action New
  void onAppsActionView(String value, DRecord record, DEntry entry, var actionVar) {
    _log.config("onAppsActionView ${tableName} ${value} ${record.recordId}");
  }

  /// Application Action New
  void onAppsActionNew(String value, DRecord record, DEntry entry, var actionVar) {
    _log.config("onAppsActionNew ${tableName} ${value}");
  }

  /// Application Action Delete
  void onAppsActionDelete(String value, DRecord record, DEntry entry, var actionVar) {
    if (record == null) {

    } else {
      _log.config("onAppsActionDelete ${tableName} ${value}");
        LIElement li = new LIElement()
          ..text = record.drv;
      UListElement ul = new UListElement()
        ..classes.add(LList.C_LIST__DOTTED)
        ..append(li);
      AppsAction deleteYes = AppsAction.createYes(onAppsActionDeleteConfirmed)
        ..actionVar = record;
      LConfirmation conf = new LConfirmation("ds", label: lObjectCtrlDelete1Record(),
        text:lObjectCtrlDelete1Record(), contentElements:[ul],
        actions:[deleteYes], addCancel: true);
      conf.showInElement(element);
    }
  } // onAppsActionDelete
  /// Application Action Delete Confirmed
  void onAppsActionDeleteConfirmed(String value, DRecord record, DEntry entry, var actionVar) {
    if (actionVar is DRecord && value == AppsAction.YES) {
      DRecord record = actionVar;
      _log.info("onAppsActionDeleteConfirmed ${tableName} ${value} id=${record.recordId}");
      // TODO delete
    } else {
      _log.info("onAppsActionDeleteConfirmed ${tableName} ${value} - ${actionVar}");
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
      LConfirmation conf = new LConfirmation("ds", label: lObjectCtrlDeleteRecords(),
        text:lObjectCtrlDeleteRecordsText(), contentElements:[ul],
        actions:[deleteYes], addCancel: true);
      conf.showInElement(element);
    }
  }
  /// Application Action Delete Selected Record Confirmed
  void onAppsActionDeleteSelectedConfirmed(String value, DRecord record, DEntry entry, var actionVar) {
    if (actionVar is List<DRecord> && value == AppsAction.YES) {
      List<DRecord> records = actionVar;
      _log.info("onAppsActionDeleteSelectedConfirmed ${tableName} ${value} #${records.length}");
      // TODO delete
    } else {
      _log.info("onAppsActionDeleteSelectedConfirmed ${tableName} ${value} - ${actionVar}");
    }
  }


  /// Application Action Edit
  void onAppsActionEdit(String value, DRecord record, DEntry entry, var actionVar) {
    _log.config("onAppsActionEdit ${tableName} ${value} id=${record.recordId}");
  }


  static String lObjectCtrlNoRecords() => Intl.message("No records", name: "lObjectCtrlNoRecords");
  static String lObjectCtrlNoRecordInfo() => Intl.message("No records to display - change Filter or create New", name: "lObjectCtrlNoRecordInfo");
  // query
  static String lObjectCtrl1Record() => Intl.message("One record", name: "lObjectCtrl1Record");
  static String lObjectCtrlRecords() => Intl.message("records", name: "lObjectCtrlRecords");
  static String lObjectCtrlSortedBy() => Intl.message("Sorted by", name: "lObjectCtrlSortedBy");

  // delete confirmation
  static String lObjectCtrlDelete1Record() => Intl.message("Delete current record", name: "lObjectCtrlDelete1Record");
  static String lObjectCtrlDeleteRecords() => Intl.message("Delete selected Records?", name: "lObjectCtrlDeleteRecords");
  static String lObjectCtrlDelete1RecordText() => Intl.message("Do you want to delete the current record?", name: "lObjectCtrlDelete1RecordText");
  static String lObjectCtrlDeleteRecordsText() => Intl.message("Do you want to delete the selected records?", name: "lObjectCtrlDeleteRecordsText");


} // ObjectCtrl
