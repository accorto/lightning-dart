/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;


/**
 * Object Controller
 * = List Records in Grid
 * = Search "saved queries"
 * = ability to define queries
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


  final Element element = new Element.section();
  /// Header
  LObjectHome _header = new LObjectHome();

  CDiv _content = new CDiv.article();



  final UI ui;
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
    if (_records == null || _records.isEmpty) {
      _header.summary = lObjectCtrlNoItems();
      _content.clear();
      DivElement div = new DivElement()
        ..classes.addAll([LTheme.C_BOX, LTheme.C_THEME__SHADE, LText.C_TEXT_ALIGN__CENTER, LMargin.C_VERTICAL__SMALL])
        ..style.lineHeight = "200px"
        ..style.verticalAlign = "middle"
        ..text = lObjectCtrlNoRecords();
      _content.append(div);
    } else {
      String viewLayout = _header.viewLayout;
      if (viewLayout == LObjectHome.VIEW_LAYOUT_TABLE) {
        //_content
      }


      if (_records.length == 1)
        _header.summary = lObjectCtrlOneItem();
      else
        _header.summary = "${_records.length} ${lObjectCtrlItems()} * ${lObjectCtrlSortedBy()} x";
    }

  } // display


  void onAppsActionTriggered(String value, DRecord record, DEntry entry) {
    _log.config("onAppsActionTriggered ${tableName} ${value}");
  }


  static String lObjectCtrlNoItems() => Intl.message("No items", name: "lObjectCtrlNoItems");
  static String lObjectCtrlNoRecords() => Intl.message("No items to display - change query or create New", name: "lObjectCtrlNoRecords");

  static String lObjectCtrlOneItem() => Intl.message("One item", name: "lObjectCtrlOneItem");
  static String lObjectCtrlItems() => Intl.message("Items", name: "lObjectCtrlItems");
  static String lObjectCtrlSortedBy() => Intl.message("Sorted by", name: "lObjectCtrlSortedBy");


} // ObjectCtrl
