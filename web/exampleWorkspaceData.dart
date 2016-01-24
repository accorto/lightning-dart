/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning.exampleWorkspace;

/**
 * Data Structure for Workspace
 */
class WorkspaceData extends Datasource {


  /// simulate server
  @override
  Future<UI> uiFuture() {
    Completer<UI> completer = new Completer<UI>();

    new Timer(new Duration(seconds: 2), (){
      _create();
      completer.complete(ui);
    });

    return completer.future;
  } // execute_ui


  /// simulate server
  @override
  Future<DataResponse> execute_data(DataRequest request, {String info, bool setBusy: true}) {
    Completer<DataResponse> completer = new Completer<DataResponse>();

    new Timer(new Duration(seconds: 2), (){
      DataResponse response = new DataResponse();
      response.response = new SResponse()
        ..isSuccess = true
        ..msg = "example data";

      if (request.type == DataRequestType.SAVE) {
        for (DRecord record in request.recordList) {
          bool isNew = !record.hasRecordId();
          uiu.updateHeader(record);
          if (isNew) {
            _exampleList.add(record);
          }
        }
      }
      if (request.type == DataRequestType.DELETE) {
        for (DRecord record in request.recordList) {
          _exampleList.remove(record);
        }
      }

      response.totalRows = _exampleList.length;
      response.queryOffset = 0;
      response.recordList.addAll(_exampleList);

      completer.complete(response);
    });

    return completer.future;
  } // execute_data


  static const String NAME =  "MyContact";

  UiUtilDemo uiu;
  final List<DRecord> _exampleList = new List<DRecord>();

  /**
   * Workspace Demo Data
   */
  WorkspaceData()
    : super (NAME, "dummy", "dummy") {
  } // WorkbenchData


  void _create() {
    ui = new UI();
    uiu = new UiUtilDemo(ui, exampleList:_exampleList);
    ui.uiId = uiu.nextId();
    DTable table = new DTable()
      ..tableId = uiu.nextId()
      ..name = NAME
      ..label = "My Contact"
      ..description = "My brief Object description"
      ..help = "This is an example object to demonstrate the workbench"
      ..tutorialUrl = "http://lightning,accorto.com"
      ..iconImage = "slds-icon-standard-contact";

    // Set Table
    uiu.setTable(table);
    uiu.addPanel()
      ..uiPanelId = uiu.nextId();

    // Columns
    DColumn col = new DColumn()
      ..columnId = uiu.nextId()
      ..name = "FName"
      ..label = "First Name"
      ..dataType = DataType.STRING
      ..uniqueSeqNo = 2
      ..displaySeqNo = 1
      ..isMandatory = true;
    uiu.addColumn(col, examples:["Joe", "Peter", "Marie"]);

    col = new DColumn()
      ..columnId = uiu.nextId()
      ..name = "LName"
      ..label = "Last Name"
      ..dataType = DataType.STRING
      ..uniqueSeqNo = 1
      ..displaySeqNo = 2
      ..isMandatory = true;
    uiu.addColumn(col, examples:["Smith", "Johnson", "Bold"]);

    col = new DColumn()
      ..columnId = uiu.nextId()
      ..name = "First"
      ..label = "First Contact"
      ..dataType = DataType.DATE;
    uiu.addColumn(col, examples:[]);

    col = new DColumn()
      ..columnId = uiu.nextId()
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


} // WorkspaceData
