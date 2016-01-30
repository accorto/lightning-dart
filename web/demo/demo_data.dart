/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart.demo;

/**
 * Demo Table Data
 */
class DemoData extends Datasource {

  static const TABLE_NAME = "demo";

  static const COL_NAME = "name";
  static const COL_STATUS = "status"; // pick
  static const COL_TOWN = "town"; // pick
  static const COL_AGE = "age";
  static const COL_AMOUNT = "amount";
  static const COL_DATE = "date";


  /// Prefilled Data Source
  static Datasource createDatasource() {
    DemoData ds = new DemoData();
    ds.prefillDemo();
    return ds;
  }


  /// create UI
  static UI createUI() {
    UI ui = new UI();
    UiUtil uiu = new UiUtilDemo(ui);
    ui.uiId = nextId();
    DTable table = new DTable()
      ..tableId = nextId()
      ..name = TABLE_NAME
      ..label = "Demo Object"
      ..description = "My brief Object description"
      ..help = "This is an example object to demonstrate the workbench"
      ..tutorialUrl = "http://lightning,accorto.com"
      ..iconImage = "slds-icon-standard-contact";

    // Set Table
    uiu.setTable(table);
    uiu.addPanel()
      ..uiPanelId = nextId();

    // Columns
    DColumn col = new DColumn()
      ..columnId = nextId()
      ..name = COL_NAME
      ..label = "Member Name"
      ..dataType = DataType.STRING
      ..uniqueSeqNo = 2
      ..displaySeqNo = 1
      ..isMandatory = true;
    uiu.addColumn(col);

    col = new DColumn()
      ..columnId = nextId()
      ..name = COL_STATUS
      ..label = "Status"
      ..dataType = DataType.PICK;
    col.pickValueList.add(new DOption()..value ="new" ..label="New");
    col.pickValueList.add(new DOption()..value ="due" ..label="Due");
    col.pickValueList.add(new DOption()..value ="paid" ..label="Paid");
    col.pickValueList.add(new DOption()..value ="default" ..label="In Default");
    uiu.addColumn(col);

    col = new DColumn()
      ..columnId = nextId()
      ..name = COL_TOWN
      ..label = "Town"
      ..dataType = DataType.STRING;
    uiu.addColumn(col);

    col = new DColumn()
      ..columnId = nextId()
      ..name = COL_AGE
      ..label = "Age"
      ..dataType = DataType.INT;
    uiu.addColumn(col);

    col = new DColumn()
      ..columnId = nextId()
      ..name = COL_AMOUNT
      ..label = "Amount"
      ..dataType = DataType.AMOUNT;
    uiu.addColumn(col);

    col = new DColumn()
      ..columnId = nextId()
      ..name = COL_DATE
      ..label = "Date"
      ..dataType = DataType.DATE;
    uiu.addColumn(col);

    return ui;
  } // createUI


  /// create Record List
  static List<DRecord> createRecordList({UiUtilDemo uiu}) {
    List<DRecord> list = new List<DRecord>();
    list.add(createRecord("Joe",    "new",  "San Francisco",  22, 12.3, new DateTime.utc(2015, 1, 1)));
    list.add(createRecord("John",   "paid", "San Jose",       23, 2.34, new DateTime.utc(2015, 1, 4)));
    list.add(createRecord("Jorg",   "paid", "Redwood City",   24, 22.3, new DateTime.utc(2015, 1, 9)));
    list.add(createRecord("Jorge",  "due",  "Santa Clara",    24, 42.3, new DateTime.utc(2015, 2, 1)));
    list.add(createRecord("George", "due",  "San Mateo",      26, 12.3, new DateTime.utc(2015, 2, 4)));
    list.add(createRecord("Josh",   "new",  "San Francisco",  26, 52.3, new DateTime.utc(2015, 2, 9)));
    list.add(createRecord("Oddie",  null,   null,             23, 32.3, new DateTime.utc(2015, 6, 1)));

    if (uiu != null) {
      for (DRecord record in list) {
        uiu.updateHeader(record);
      }
    }
    return list;
  } // createRecordList

  /// create record
  static DRecord createRecord(String name,
      String status, String town,
      int age, double amount, DateTime date) {
    DRecord r = new DRecord()
      ..recordId = "${_id}"
      ..urv = "${_id}"
      ..drv = name;
    r.entryList.add(new DEntry()
      ..columnName = COL_NAME
      ..valueOriginal = name);
    if (status != null)
      r.entryList.add(new DEntry()
        ..columnName = COL_STATUS
        ..valueOriginal = status);
    if (town != null)
      r.entryList.add(new DEntry()
        ..columnName = COL_TOWN
        ..valueOriginal = town);
    if (age != null)
      r.entryList.add(new DEntry()
        ..columnName = COL_AGE
        ..valueOriginal = age.toString());
    if (amount != null)
      r.entryList.add(new DEntry()
        ..columnName = COL_AMOUNT
        ..valueOriginal = amount.toString()
        ..valueDisplay = amount.toStringAsFixed(2));
    if (date != null)
      r.entryList.add(new DEntry()
        ..columnName = COL_DATE
        ..valueOriginal = date.millisecondsSinceEpoch.toString()
        ..valueDisplay = date.toIso8601String().substring(0,10));

    return r;
  } // createRecord

  /// next meta id
  static String nextId() {
    return "${_nid++}";
  }
  static int _nid = 1;
  static int _id = 1;

  /// Simulated Server
  List<DRecord> _exampleList;
  /// UI Utility
  UiUtilDemo uiu;

  /**
   * Demo Data Source
   */
  DemoData() : super(TABLE_NAME, "demo", "demo") {
  }

  void prefillDemo() {
    ui = createUI();
    uiu = new UiUtilDemo(ui);
    UiUtil.validate(ui);
    _exampleList = createRecordList(uiu: uiu);
    recordList = _exampleList;
  }

  /// simulate server
  @override
  Future<UI> uiFuture() {
    if (ui == null)
      ui = createUI();
    if (uiu == null)
      uiu = new UiUtilDemo(ui);

    Completer<UI> completer = new Completer<UI>();

    new Timer(new Duration(seconds: 2), (){
      completer.complete(ui);
    });

    return completer.future;
  } // execute_ui


  /// simulate server
  @override
  Future<DataResponse> execute_data(DataRequest request, {String info, bool setBusy: true}) {
    if (ui == null)
      ui = createUI();
    if (uiu == null)
      uiu = new UiUtilDemo(ui);
    if (_exampleList == null)
      _exampleList = createRecordList(uiu: uiu);

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


} // DemoData
