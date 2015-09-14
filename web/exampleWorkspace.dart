/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

import "dart:async";

import "package:lightning/lightning_ctrl.dart";

/**
 * Workbench Example
 * - Object Home with records
 */
void main() {

  LightningDart.init() // client env
  .then((_) {
    WorbenchData wbData = new WorbenchData();

    ObjectCtrl ctrl = new ObjectCtrl(wbData);

    PageSimple page = LightningDart.createPageSimple();
    page.add(ctrl);

  });

} // main


/**
 * Data Structure for Workbench
 */
class WorbenchData extends Datasource {


  Future<UI> meta_ui() {
    Completer<UI> completer = new Completer<UI>();

    new Timer(new Duration(seconds: 5), (){
      _create();
      completer.complete(_ui);
    });

    return completer.future;
  } // meta_ui


  Future<DataResponse> query(DataRequest request) {
    Completer<DataResponse> completer = new Completer<DataResponse>();

    new Timer(new Duration(seconds: 5), (){
      DataResponse response = new DataResponse();
      response.recordList.addAll(_exampleList);
      completer.complete(response);
    });

    return completer.future;
  }


  static const String NAME =  "MyContact";

  final UI _ui = new UI();
  final List<DRecord> _exampleList = new List<DRecord>();

  WorbenchData()
    : super (NAME) {
  } // WorkbenchData


  void _create() {
    _ui.uiId = _nextId();
    UiUtil uiu = new UiUtil(_ui, exampleList:_exampleList);
    DTable table = new DTable()
      ..tableId = _nextId()
      ..name = NAME
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
  } // create

  /// next id
  String _nextId() {
    return "${_nid++}";
  }
  int _nid = 1;

} // WorkbenchData
