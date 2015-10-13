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

  /// Table Edit Mode - Read Only
  static const String EDIT_RO = "ro";
  /// Table Edit Mode - Field Click
  static const String EDIT_FIELD = "field";
  /// Table Edit Mode - Read/Write
  static const String EDIT_RW = "rw";


  /// Record
  Element element = new Element.article()
    ..id = "rc";
  /// Header
  LRecordHome _header;
  LBreadcrumb _breadcrumb;
  /// Left Side (related/details)
  final LTab _leftTab = new LTab();
  RecordCtrlRelated _related;
  /// Form
  RecordCtrlDetails _details;
  /// UI
  final UI ui;


  /**
   * Record Control
   */
  RecordCtrl(UI this.ui, {String containerClass: LGrid.C_CONTAINER__FLUID}) {
    String idPrefix = "rc-" + ui.tableName;
    element.id = idPrefix;
    if (containerClass != null && containerClass.isNotEmpty) {
      element.classes.add(containerClass);
    }
    // Structure
    _header = new LRecordHome.from(ui)
      ..id = "rc-h";
    element.append(_header.element);
    //
    _breadcrumb = new LBreadcrumb(idPrefix:idPrefix);
    element.append(_breadcrumb.element);
    //
    _leftTab.id = idPrefix + "-tab";
    element.append(_leftTab.element);
    _related = new RecordCtrlRelated(ui);

    // form
    _details = new RecordCtrlDetails(ui, id);
    //
    _leftTab.addTab(lRecordCtrlRelated(), name: "related", content:_related.element);
    _leftTab.addTab(lRecordCtrlDetails(), name: "details", content:_details.element);
    _leftTab.selectTabByPos(1);
  } // RecordCtrl


  /// get (details) record
  DRecord get record => _details.record;
  /// set record to header, details, related
  void set record (DRecord newValue) {
    _header.record = newValue;
    _details.record = newValue;
    _related.record = newValue;
  } // setRecord


  /// display current record
  void display() {
    _header.display();
    // _breadcrumb
    _details.display();
    _related.display();
  }

  String get editMode => _editMode;
  void set editMode (String newValue) {
    _editMode = newValue;
    _details.display();
  }
  String _editMode = EDIT_FIELD;



  static String lRecordCtrlRelated() => Intl.message("Related", name: "lRecordCtrlRelated");
  static String lRecordCtrlDetails() => Intl.message("Details", name: "lRecordCtrlDetails");

} // RecordCtrl
