/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */


import "dart:html";

//import "package:lightning/lightning.dart";
import "package:lightning/lightning_ctrl.dart";

/**
 * Workbench Example
 * - Object Home with records
 */
void main() {

  LightningDart.init() // client env
  .then((_) {
    WorbenchData wbData = new WorbenchData();

    ObjectCtrl ctrl = new ObjectCtrl(wbData.ui);
    ctrl.display(wbData.exampleList);


    PageSimple page = LightningDart.createPageSimple();
    page.add(ctrl);

  });

} // main


/**
 * Data Structure for Workbench
 */
class WorbenchData {

  final UI ui = new UI();
  final List<DRecord> recordList = new List<DRecord>();
  final List<DRecord> exampleList = new List<DRecord>();


  WorbenchData() {
    ui.uiId = _nextId();
    UiUtil uiu = new UiUtil(ui, exampleList:exampleList);
    DTable table = new DTable()
      ..tableId = _nextId()
      ..name = "MyContact"
      ..label = "My Contact"
      ..description = "My brief Object description"
      ..help = "This is an example object to demonstrate the workbench"
      ..tutorialUrl = "http://lightning,accorto.com"
      ..iconImage = "slds-icon-standard-contact";

    // Set Table
    uiu.setTable(table);
    uiu.addPanel(null)
      ..uiPanelId = _nextId();

    // Columns
    DColumn col = new DColumn()
      ..columnId = _nextId()
      ..name = "FName"
      ..label = "First Name"
      ..dataType = DataType.STRING
      ..uniqueSeqNo = 2
      ..displaySeqNo = 1
      ..isMandatory = true;
    uiu.addColumn(col, examples:["Joe", "Peter", "Marie"]);

    col = new DColumn()
      ..columnId = _nextId()
      ..name = "LName"
      ..label = "Last Name"
      ..dataType = DataType.STRING
      ..uniqueSeqNo = 1
      ..displaySeqNo = 2
      ..isMandatory = true;
    uiu.addColumn(col, examples:["Black", "Smith", "Johnson"]);

    col = new DColumn()
      ..columnId = _nextId()
      ..name = "First"
      ..label = "First Contact"
      ..dataType = DataType.DATE;
    uiu.addColumn(col, examples:[]);

    col = new DColumn()
      ..columnId = _nextId()
      ..name = "Level"
      ..label = "Level"
      ..dataType = DataType.PICK;
    col.pickValueList.add(new DOption()..value ="v" ..label="virtual");
    col.pickValueList.add(new DOption()..value ="e" ..label="email exchange");
    col.pickValueList.add(new DOption()..value ="p" ..label="talked on phone");
    col.pickValueList.add(new DOption()..value ="p" ..label="met in person");
    col.pickValueList.add(new DOption()..value ="f" ..label="friend");
    uiu.addColumn(col, examples:[]);

    uiu.updateExamples();
  } // WorkbenchData


  /// next id
  String _nextId() {
    return "${_nid++}";
  }
  int _nid = 1;

} // WorkbenchData
