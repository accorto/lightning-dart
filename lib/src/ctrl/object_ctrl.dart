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
    _header.addAction(AppsAction.createNew(onAppsActionTriggered));

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
      if (viewLayout == LObjectHome.VIEW_LAYOUT_TABLE) {
        LTable table = new LTable("id", true)
          ..bordered = true;
        table.setUi(ui); // header
        table.display(_records);
        _content.add(table);
      }


      if (_records.length == 1)
        _header.summary = lObjectCtrl1Record();
      else
        _header.summary = "${_records.length} ${lObjectCtrlRecords()} * ${lObjectCtrlSortedBy()} x";
    }

  } // display


  void onAppsActionTriggered(String value, DRecord record, DEntry entry) {
    _log.config("onAppsActionTriggered ${tableName} ${value}");
  }


  static String lObjectCtrlNoRecords() => Intl.message("No records", name: "lObjectCtrlNoRecords");
  static String lObjectCtrlNoRecordInfo() => Intl.message("No records to display - change Filter or create New", name: "lObjectCtrlNoRecordInfo");

  static String lObjectCtrl1Record() => Intl.message("One record", name: "lObjectCtrl1Record");
  static String lObjectCtrlRecords() => Intl.message("records", name: "lObjectCtrlRecords");
  static String lObjectCtrlSortedBy() => Intl.message("Sorted by", name: "lObjectCtrlSortedBy");


} // ObjectCtrl
