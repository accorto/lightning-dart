/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/**
 * Record Controller
 * = Follow record
 * = Actions: Edit - Create new main related items - Delete
 *
 *
 * Structure
 * - LRecordHome
 * - LeftSide
 * -- LTab
 * --- Related
 * --- Details
 * - RightSide
 * -- LTab
 * --- Activity
 * --- Collaborate
 */
class RecordCtrl extends LComponent {

  /// Record
  Element element = new Element.article();
  /// Header
  LRecordHome _header;
  LBreadcrumb _breadcrumb;
  /// Left Side (related/details)
  final LTab _leftTab = new LTab();
  RecordCtrlRelated _related;
  RecordCtrlDetails _details;

  final UI ui;
  final DataRecord data = new DataRecord(null);




  RecordCtrl(UI this.ui) {
    // Structure
    String idPrefix = ui.tableName;
    _header = new LRecordHome.from(ui, data);
    element.append(_header.element);
    _breadcrumb = new LBreadcrumb(idPrefix:idPrefix);
    element.append(_breadcrumb.element);
    //
    _leftTab.id = idPrefix + "-tab";
    element.append(_leftTab.element);
    _related = new RecordCtrlRelated(ui, data);
    _details = new RecordCtrlDetails(ui, data);
    _leftTab.addTab(lRecordCtrlRelated(), name: "related", content:_related.element);
    _leftTab.addTab(lRecordCtrlDetails(), name: "details", content:_details.element);
    _leftTab.selectTabByPos(1);
    //

  } // RecordCtrl


  DRecord get record => data.record;
  void set record (DRecord newValue) {
    data.setRecord(newValue, 0);
    display();
  } // setData


  void display() {
    _header.display();
    // _breadcrumb
    _details.display();
    _related.display();
  }



  static String lRecordCtrlRelated() => Intl.message("Related", name: "lRecordCtrlRelated");
  static String lRecordCtrlDetails() => Intl.message("Details", name: "lRecordCtrlDetails");

} // RecordCtrl
