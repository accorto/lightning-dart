///
//  Generated code. Do not modify.
///
library rr_data;

import 'dart:async';

import 'package:protobuf/protobuf.dart';
import 'rr.pb.dart';
import 'data.pb.dart';

class DataRequestType extends ProtobufEnum {
  static const DataRequestType QUERY = const DataRequestType._(1, 'QUERY');
  static const DataRequestType QUERYFK = const DataRequestType._(2, 'QUERYFK');
  static const DataRequestType QUERYCOUNT = const DataRequestType._(3, 'QUERYCOUNT');
  static const DataRequestType CALLOUT = const DataRequestType._(4, 'CALLOUT');
  static const DataRequestType SAVE = const DataRequestType._(5, 'SAVE');
  static const DataRequestType DELETE = const DataRequestType._(6, 'DELETE');
  static const DataRequestType EXPORT = const DataRequestType._(7, 'EXPORT');
  static const DataRequestType NEW = const DataRequestType._(8, 'NEW');

  static const List<DataRequestType> values = const <DataRequestType> [
    QUERY,
    QUERYFK,
    QUERYCOUNT,
    CALLOUT,
    SAVE,
    DELETE,
    EXPORT,
    NEW,
  ];

  static final Map<int, DataRequestType> _byValue = ProtobufEnum.initByValue(values);
  static DataRequestType valueOf(int value) => _byValue[value];

  const DataRequestType._(int v, String n) : super(v, n);
}

class DataExportType extends ProtobufEnum {
  static const DataExportType PDF = const DataExportType._(1, 'PDF');
  static const DataExportType XML = const DataExportType._(2, 'XML');
  static const DataExportType JSON = const DataExportType._(3, 'JSON');
  static const DataExportType CSV = const DataExportType._(4, 'CSV');
  static const DataExportType HTML = const DataExportType._(5, 'HTML');

  static const List<DataExportType> values = const <DataExportType> [
    PDF,
    XML,
    JSON,
    CSV,
    HTML,
  ];

  static final Map<int, DataExportType> _byValue = ProtobufEnum.initByValue(values);
  static DataExportType valueOf(int value) => _byValue[value];

  const DataExportType._(int v, String n) : super(v, n);
}

class DataRequest extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DataRequest')
    ..a(1, 'request', GeneratedMessage.OM, CRequest.create, CRequest.create)
    ..e(3, 'type', GeneratedMessage.QE, DataRequestType.QUERY, (var v) => DataRequestType.valueOf(v))
    ..a(4, 'tableName', GeneratedMessage.QS)
    ..a(5, 'windowNo', GeneratedMessage.OS)
    ..a(7, 'uiExternalKey', GeneratedMessage.OS)
    ..a(8, 'fieldExternalKey', GeneratedMessage.OS)
    ..m(6, 'context', DKeyValue.create, DKeyValue.createRepeated)
    ..a(9, 'queryRef', GeneratedMessage.OS)
    ..a(10, 'queryOffset', GeneratedMessage.O3)
    ..a(11, 'queryLimit', GeneratedMessage.O3)
    ..p(12, 'queryColumnName', GeneratedMessage.PS)
    ..a(13, 'isQueryForce', GeneratedMessage.OB)
    ..a(14, 'isIncludeStats', GeneratedMessage.OB, true)
    ..m(15, 'queryFilter', DFilter.create, DFilter.createRepeated)
    ..a(16, 'queryFilterLogic', GeneratedMessage.OS)
    ..m(17, 'querySort', DSort.create, DSort.createRepeated)
    ..a(18, 'querySaved', GeneratedMessage.OM, SavedQuery.create, SavedQuery.create)
    ..p(19, 'queryGroup', GeneratedMessage.PS)
    ..a(20, 'isQuerySave', GeneratedMessage.OB)
    ..a(21, 'querySavedName', GeneratedMessage.OS)
    ..a(25, 'fkId', GeneratedMessage.OS)
    ..a(26, 'fkParentColumnName', GeneratedMessage.OS)
    ..a(27, 'fkParentValue', GeneratedMessage.OS)
    ..a(28, 'fkRestrictionSql', GeneratedMessage.OS)
    ..m(30, 'record', DRecord.create, DRecord.createRepeated)
    ..a(31, 'validationCallout', GeneratedMessage.OS)
    ..a(32, 'columnChanged', GeneratedMessage.OM, DEntry.create, DEntry.create)
    ..a(35, 'exportTitle', GeneratedMessage.OS)
    ..p(36, 'exportColumnName', GeneratedMessage.PS)
    ..e(37, 'exportType', GeneratedMessage.OE, DataExportType.PDF, (var v) => DataExportType.valueOf(v))
    ..p(38, 'emailRecipient', GeneratedMessage.PS)
    ..a(39, 'emailMessage', GeneratedMessage.OS)
  ;

  DataRequest() : super();
  DataRequest.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DataRequest.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DataRequest clone() => new DataRequest()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DataRequest create() => new DataRequest();
  static PbList<DataRequest> createRepeated() => new PbList<DataRequest>();

  CRequest get request => getField(1);
  void set request(CRequest v) { setField(1, v); }
  bool hasRequest() => hasField(1);
  void clearRequest() => clearField(1);

  DataRequestType get type => getField(3);
  void set type(DataRequestType v) { setField(3, v); }
  bool hasType() => hasField(3);
  void clearType() => clearField(3);

  String get tableName => getField(4);
  void set tableName(String v) { setField(4, v); }
  bool hasTableName() => hasField(4);
  void clearTableName() => clearField(4);

  String get windowNo => getField(5);
  void set windowNo(String v) { setField(5, v); }
  bool hasWindowNo() => hasField(5);
  void clearWindowNo() => clearField(5);

  String get uiExternalKey => getField(7);
  void set uiExternalKey(String v) { setField(7, v); }
  bool hasUiExternalKey() => hasField(7);
  void clearUiExternalKey() => clearField(7);

  String get fieldExternalKey => getField(8);
  void set fieldExternalKey(String v) { setField(8, v); }
  bool hasFieldExternalKey() => hasField(8);
  void clearFieldExternalKey() => clearField(8);

  List<DKeyValue> get contextList => getField(6);

  String get queryRef => getField(9);
  void set queryRef(String v) { setField(9, v); }
  bool hasQueryRef() => hasField(9);
  void clearQueryRef() => clearField(9);

  int get queryOffset => getField(10);
  void set queryOffset(int v) { setField(10, v); }
  bool hasQueryOffset() => hasField(10);
  void clearQueryOffset() => clearField(10);

  int get queryLimit => getField(11);
  void set queryLimit(int v) { setField(11, v); }
  bool hasQueryLimit() => hasField(11);
  void clearQueryLimit() => clearField(11);

  List<String> get queryColumnNameList => getField(12);

  bool get isQueryForce => getField(13);
  void set isQueryForce(bool v) { setField(13, v); }
  bool hasIsQueryForce() => hasField(13);
  void clearIsQueryForce() => clearField(13);

  bool get isIncludeStats => getField(14);
  void set isIncludeStats(bool v) { setField(14, v); }
  bool hasIsIncludeStats() => hasField(14);
  void clearIsIncludeStats() => clearField(14);

  List<DFilter> get queryFilterList => getField(15);

  String get queryFilterLogic => getField(16);
  void set queryFilterLogic(String v) { setField(16, v); }
  bool hasQueryFilterLogic() => hasField(16);
  void clearQueryFilterLogic() => clearField(16);

  List<DSort> get querySortList => getField(17);

  SavedQuery get querySaved => getField(18);
  void set querySaved(SavedQuery v) { setField(18, v); }
  bool hasQuerySaved() => hasField(18);
  void clearQuerySaved() => clearField(18);

  List<String> get queryGroupList => getField(19);

  bool get isQuerySave => getField(20);
  void set isQuerySave(bool v) { setField(20, v); }
  bool hasIsQuerySave() => hasField(20);
  void clearIsQuerySave() => clearField(20);

  String get querySavedName => getField(21);
  void set querySavedName(String v) { setField(21, v); }
  bool hasQuerySavedName() => hasField(21);
  void clearQuerySavedName() => clearField(21);

  String get fkId => getField(25);
  void set fkId(String v) { setField(25, v); }
  bool hasFkId() => hasField(25);
  void clearFkId() => clearField(25);

  String get fkParentColumnName => getField(26);
  void set fkParentColumnName(String v) { setField(26, v); }
  bool hasFkParentColumnName() => hasField(26);
  void clearFkParentColumnName() => clearField(26);

  String get fkParentValue => getField(27);
  void set fkParentValue(String v) { setField(27, v); }
  bool hasFkParentValue() => hasField(27);
  void clearFkParentValue() => clearField(27);

  String get fkRestrictionSql => getField(28);
  void set fkRestrictionSql(String v) { setField(28, v); }
  bool hasFkRestrictionSql() => hasField(28);
  void clearFkRestrictionSql() => clearField(28);

  List<DRecord> get recordList => getField(30);

  String get validationCallout => getField(31);
  void set validationCallout(String v) { setField(31, v); }
  bool hasValidationCallout() => hasField(31);
  void clearValidationCallout() => clearField(31);

  DEntry get columnChanged => getField(32);
  void set columnChanged(DEntry v) { setField(32, v); }
  bool hasColumnChanged() => hasField(32);
  void clearColumnChanged() => clearField(32);

  String get exportTitle => getField(35);
  void set exportTitle(String v) { setField(35, v); }
  bool hasExportTitle() => hasField(35);
  void clearExportTitle() => clearField(35);

  List<String> get exportColumnNameList => getField(36);

  DataExportType get exportType => getField(37);
  void set exportType(DataExportType v) { setField(37, v); }
  bool hasExportType() => hasField(37);
  void clearExportType() => clearField(37);

  List<String> get emailRecipientList => getField(38);

  String get emailMessage => getField(39);
  void set emailMessage(String v) { setField(39, v); }
  bool hasEmailMessage() => hasField(39);
  void clearEmailMessage() => clearField(39);
}

class DataResponse extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DataResponse')
    ..a(1, 'response', GeneratedMessage.OM, SResponse.create, SResponse.create)
    ..a(4, 'tableName', GeneratedMessage.OS)
    ..a(5, 'totalRows', GeneratedMessage.O3)
    ..a(6, 'queryOffset', GeneratedMessage.O3)
    ..a(9, 'queryRef', GeneratedMessage.OS)
    ..m(10, 'record', DRecord.create, DRecord.createRepeated)
    ..a(11, 'recordsProcessed', GeneratedMessage.O3)
    ..m(12, 'contextChange', DKeyValue.create, DKeyValue.createRepeated)
    ..m(15, 'fks', DFK.create, DFK.createRepeated)
    ..a(16, 'isFkComplete', GeneratedMessage.OB)
    ..m(20, 'statistic', DStatistics.create, DStatistics.createRepeated)
    ..a(25, 'exportUrl', GeneratedMessage.OS)
  ;

  DataResponse() : super();
  DataResponse.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DataResponse.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DataResponse clone() => new DataResponse()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DataResponse create() => new DataResponse();
  static PbList<DataResponse> createRepeated() => new PbList<DataResponse>();

  SResponse get response => getField(1);
  void set response(SResponse v) { setField(1, v); }
  bool hasResponse() => hasField(1);
  void clearResponse() => clearField(1);

  String get tableName => getField(4);
  void set tableName(String v) { setField(4, v); }
  bool hasTableName() => hasField(4);
  void clearTableName() => clearField(4);

  int get totalRows => getField(5);
  void set totalRows(int v) { setField(5, v); }
  bool hasTotalRows() => hasField(5);
  void clearTotalRows() => clearField(5);

  int get queryOffset => getField(6);
  void set queryOffset(int v) { setField(6, v); }
  bool hasQueryOffset() => hasField(6);
  void clearQueryOffset() => clearField(6);

  String get queryRef => getField(9);
  void set queryRef(String v) { setField(9, v); }
  bool hasQueryRef() => hasField(9);
  void clearQueryRef() => clearField(9);

  List<DRecord> get recordList => getField(10);

  int get recordsProcessed => getField(11);
  void set recordsProcessed(int v) { setField(11, v); }
  bool hasRecordsProcessed() => hasField(11);
  void clearRecordsProcessed() => clearField(11);

  List<DKeyValue> get contextChangeList => getField(12);

  List<DFK> get fksList => getField(15);

  bool get isFkComplete => getField(16);
  void set isFkComplete(bool v) { setField(16, v); }
  bool hasIsFkComplete() => hasField(16);
  void clearIsFkComplete() => clearField(16);

  List<DStatistics> get statisticList => getField(20);

  String get exportUrl => getField(25);
  void set exportUrl(String v) { setField(25, v); }
  bool hasExportUrl() => hasField(25);
  void clearExportUrl() => clearField(25);
}

class DataServiceApi {
  RpcClient _client;
  DataServiceApi(this._client);

  Future<DataResponse> data(ClientContext ctx, DataRequest request) async {
    var emptyResponse = new DataResponse();
    var result = await _client.invoke(ctx, 'DataService', 'Data', request, emptyResponse);
    return result;
  }
}

abstract class DataServiceBase extends GeneratedService {
  Future<DataResponse> data(ServerContext ctx, DataRequest request);

  GeneratedMessage createRequest(String method) {
    switch (method) {
      case 'Data': return new DataRequest();
      default: throw new ArgumentError('Unknown method: $method');
    }
  }

  Future<GeneratedMessage> handleCall(ServerContext ctx, String method, GeneratedMessage request) async {
    switch (method) {
      case 'Data': return await data(ctx, request);
      default: throw new ArgumentError('Unknown method: $method');
    }
  }
}

