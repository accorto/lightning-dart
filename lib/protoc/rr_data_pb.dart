/**
 * Generated Protocol Buffers code. Do not modify.
 */
library protoc.rr_data;

import 'dart:async';

import 'package:protobuf/protobuf.dart';
import 'rr_pb.dart';
import 'data_pb.dart';
import 'structure_pb.dart';

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
  static void $checkItem(DataRequestType v) {
    if (v is !DataRequestType) checkItemFailed(v, 'DataRequestType');
  }

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
  static void $checkItem(DataExportType v) {
    if (v is !DataExportType) checkItemFailed(v, 'DataExportType');
  }

  const DataExportType._(int v, String n) : super(v, n);
}

class DataRequest extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DataRequest')
    ..a(1, 'request', PbFieldType.OM, CRequest.getDefault, CRequest.create)
    ..e(3, 'type', PbFieldType.QE, DataRequestType.QUERY, DataRequestType.valueOf)
    ..a(4, 'tableName', PbFieldType.QS)
    ..a(5, 'windowNo', PbFieldType.OS)
    ..pp(6, 'context', PbFieldType.PM, DKeyValue.$checkItem, DKeyValue.create)
    ..a(7, 'uiExternalKey', PbFieldType.OS)
    ..a(8, 'fieldExternalKey', PbFieldType.OS)
    ..a(9, 'queryRef', PbFieldType.OS)
    ..a(10, 'queryOffset', PbFieldType.O3)
    ..a(11, 'queryLimit', PbFieldType.O3)
    ..p(12, 'queryColumnName', PbFieldType.PS)
    ..a(13, 'isQueryForce', PbFieldType.OB)
    ..a(14, 'isIncludeStats', PbFieldType.OB, true)
    ..pp(15, 'queryFilter', PbFieldType.PM, DFilter.$checkItem, DFilter.create)
    ..a(16, 'queryFilterLogic', PbFieldType.OS)
    ..pp(17, 'querySort', PbFieldType.PM, DSort.$checkItem, DSort.create)
    ..a(18, 'savedQuery', PbFieldType.OM, SavedQuery.getDefault, SavedQuery.create)
    ..a(25, 'fkId', PbFieldType.OS)
    ..a(26, 'fkParentColumnName', PbFieldType.OS)
    ..a(27, 'fkParentValue', PbFieldType.OS)
    ..a(28, 'fkRestrictionSql', PbFieldType.OS)
    ..pp(30, 'record', PbFieldType.PM, DRecord.$checkItem, DRecord.create)
    ..a(31, 'validationCallout', PbFieldType.OS)
    ..a(32, 'columnChanged', PbFieldType.OM, DEntry.getDefault, DEntry.create)
    ..a(35, 'exportTitle', PbFieldType.OS)
    ..p(36, 'exportColumnName', PbFieldType.PS)
    ..e(37, 'exportType', PbFieldType.OE, DataExportType.PDF, DataExportType.valueOf)
    ..p(38, 'emailRecipient', PbFieldType.PS)
    ..a(39, 'emailMessage', PbFieldType.OS)
  ;

  DataRequest() : super();
  DataRequest.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DataRequest.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DataRequest clone() => new DataRequest()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DataRequest create() => new DataRequest();
  static PbList<DataRequest> createRepeated() => new PbList<DataRequest>();
  static DataRequest getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyDataRequest();
    return _defaultInstance;
  }
  static DataRequest _defaultInstance;
  static void $checkItem(DataRequest v) {
    if (v is !DataRequest) checkItemFailed(v, 'DataRequest');
  }

  CRequest get request => $_get(0, 1, null);
  void set request(CRequest v) { setField(1, v); }
  bool hasRequest() => $_has(0, 1);
  void clearRequest() => clearField(1);

  DataRequestType get type => $_get(1, 3, null);
  void set type(DataRequestType v) { setField(3, v); }
  bool hasType() => $_has(1, 3);
  void clearType() => clearField(3);

  String get tableName => $_get(2, 4, '');
  void set tableName(String v) { $_setString(2, 4, v); }
  bool hasTableName() => $_has(2, 4);
  void clearTableName() => clearField(4);

  String get windowNo => $_get(3, 5, '');
  void set windowNo(String v) { $_setString(3, 5, v); }
  bool hasWindowNo() => $_has(3, 5);
  void clearWindowNo() => clearField(5);

  List<DKeyValue> get contextList => $_get(4, 6, null);

  String get uiExternalKey => $_get(5, 7, '');
  void set uiExternalKey(String v) { $_setString(5, 7, v); }
  bool hasUiExternalKey() => $_has(5, 7);
  void clearUiExternalKey() => clearField(7);

  String get fieldExternalKey => $_get(6, 8, '');
  void set fieldExternalKey(String v) { $_setString(6, 8, v); }
  bool hasFieldExternalKey() => $_has(6, 8);
  void clearFieldExternalKey() => clearField(8);

  String get queryRef => $_get(7, 9, '');
  void set queryRef(String v) { $_setString(7, 9, v); }
  bool hasQueryRef() => $_has(7, 9);
  void clearQueryRef() => clearField(9);

  int get queryOffset => $_get(8, 10, 0);
  void set queryOffset(int v) { $_setUnsignedInt32(8, 10, v); }
  bool hasQueryOffset() => $_has(8, 10);
  void clearQueryOffset() => clearField(10);

  int get queryLimit => $_get(9, 11, 0);
  void set queryLimit(int v) { $_setUnsignedInt32(9, 11, v); }
  bool hasQueryLimit() => $_has(9, 11);
  void clearQueryLimit() => clearField(11);

  List<String> get queryColumnNameList => $_get(10, 12, null);

  bool get isQueryForce => $_get(11, 13, false);
  void set isQueryForce(bool v) { $_setBool(11, 13, v); }
  bool hasIsQueryForce() => $_has(11, 13);
  void clearIsQueryForce() => clearField(13);

  bool get isIncludeStats => $_get(12, 14, true);
  void set isIncludeStats(bool v) { $_setBool(12, 14, v); }
  bool hasIsIncludeStats() => $_has(12, 14);
  void clearIsIncludeStats() => clearField(14);

  List<DFilter> get queryFilterList => $_get(13, 15, null);

  String get queryFilterLogic => $_get(14, 16, '');
  void set queryFilterLogic(String v) { $_setString(14, 16, v); }
  bool hasQueryFilterLogic() => $_has(14, 16);
  void clearQueryFilterLogic() => clearField(16);

  List<DSort> get querySortList => $_get(15, 17, null);

  SavedQuery get savedQuery => $_get(16, 18, null);
  void set savedQuery(SavedQuery v) { setField(18, v); }
  bool hasSavedQuery() => $_has(16, 18);
  void clearSavedQuery() => clearField(18);

  String get fkId => $_get(17, 25, '');
  void set fkId(String v) { $_setString(17, 25, v); }
  bool hasFkId() => $_has(17, 25);
  void clearFkId() => clearField(25);

  String get fkParentColumnName => $_get(18, 26, '');
  void set fkParentColumnName(String v) { $_setString(18, 26, v); }
  bool hasFkParentColumnName() => $_has(18, 26);
  void clearFkParentColumnName() => clearField(26);

  String get fkParentValue => $_get(19, 27, '');
  void set fkParentValue(String v) { $_setString(19, 27, v); }
  bool hasFkParentValue() => $_has(19, 27);
  void clearFkParentValue() => clearField(27);

  String get fkRestrictionSql => $_get(20, 28, '');
  void set fkRestrictionSql(String v) { $_setString(20, 28, v); }
  bool hasFkRestrictionSql() => $_has(20, 28);
  void clearFkRestrictionSql() => clearField(28);

  List<DRecord> get recordList => $_get(21, 30, null);

  String get validationCallout => $_get(22, 31, '');
  void set validationCallout(String v) { $_setString(22, 31, v); }
  bool hasValidationCallout() => $_has(22, 31);
  void clearValidationCallout() => clearField(31);

  DEntry get columnChanged => $_get(23, 32, null);
  void set columnChanged(DEntry v) { setField(32, v); }
  bool hasColumnChanged() => $_has(23, 32);
  void clearColumnChanged() => clearField(32);

  String get exportTitle => $_get(24, 35, '');
  void set exportTitle(String v) { $_setString(24, 35, v); }
  bool hasExportTitle() => $_has(24, 35);
  void clearExportTitle() => clearField(35);

  List<String> get exportColumnNameList => $_get(25, 36, null);

  DataExportType get exportType => $_get(26, 37, null);
  void set exportType(DataExportType v) { setField(37, v); }
  bool hasExportType() => $_has(26, 37);
  void clearExportType() => clearField(37);

  List<String> get emailRecipientList => $_get(27, 38, null);

  String get emailMessage => $_get(28, 39, '');
  void set emailMessage(String v) { $_setString(28, 39, v); }
  bool hasEmailMessage() => $_has(28, 39);
  void clearEmailMessage() => clearField(39);
}

class _ReadonlyDataRequest extends DataRequest with ReadonlyMessageMixin {}

class DataResponse extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DataResponse')
    ..a(1, 'response', PbFieldType.OM, SResponse.getDefault, SResponse.create)
    ..a(4, 'tableName', PbFieldType.OS)
    ..a(5, 'totalRows', PbFieldType.O3)
    ..a(6, 'queryOffset', PbFieldType.O3)
    ..a(9, 'queryRef', PbFieldType.OS)
    ..pp(10, 'record', PbFieldType.PM, DRecord.$checkItem, DRecord.create)
    ..a(11, 'recordsProcessed', PbFieldType.O3)
    ..pp(12, 'contextChange', PbFieldType.PM, DKeyValue.$checkItem, DKeyValue.create)
    ..pp(15, 'fks', PbFieldType.PM, DFK.$checkItem, DFK.create)
    ..a(16, 'isFkComplete', PbFieldType.OB)
    ..a(17, 'table', PbFieldType.OM, DTable.getDefault, DTable.create)
    ..pp(20, 'statistic', PbFieldType.PM, DStatistics.$checkItem, DStatistics.create)
    ..a(25, 'exportUrl', PbFieldType.OS)
  ;

  DataResponse() : super();
  DataResponse.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DataResponse.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DataResponse clone() => new DataResponse()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DataResponse create() => new DataResponse();
  static PbList<DataResponse> createRepeated() => new PbList<DataResponse>();
  static DataResponse getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyDataResponse();
    return _defaultInstance;
  }
  static DataResponse _defaultInstance;
  static void $checkItem(DataResponse v) {
    if (v is !DataResponse) checkItemFailed(v, 'DataResponse');
  }

  SResponse get response => $_get(0, 1, null);
  void set response(SResponse v) { setField(1, v); }
  bool hasResponse() => $_has(0, 1);
  void clearResponse() => clearField(1);

  String get tableName => $_get(1, 4, '');
  void set tableName(String v) { $_setString(1, 4, v); }
  bool hasTableName() => $_has(1, 4);
  void clearTableName() => clearField(4);

  int get totalRows => $_get(2, 5, 0);
  void set totalRows(int v) { $_setUnsignedInt32(2, 5, v); }
  bool hasTotalRows() => $_has(2, 5);
  void clearTotalRows() => clearField(5);

  int get queryOffset => $_get(3, 6, 0);
  void set queryOffset(int v) { $_setUnsignedInt32(3, 6, v); }
  bool hasQueryOffset() => $_has(3, 6);
  void clearQueryOffset() => clearField(6);

  String get queryRef => $_get(4, 9, '');
  void set queryRef(String v) { $_setString(4, 9, v); }
  bool hasQueryRef() => $_has(4, 9);
  void clearQueryRef() => clearField(9);

  List<DRecord> get recordList => $_get(5, 10, null);

  int get recordsProcessed => $_get(6, 11, 0);
  void set recordsProcessed(int v) { $_setUnsignedInt32(6, 11, v); }
  bool hasRecordsProcessed() => $_has(6, 11);
  void clearRecordsProcessed() => clearField(11);

  List<DKeyValue> get contextChangeList => $_get(7, 12, null);

  List<DFK> get fksList => $_get(8, 15, null);

  bool get isFkComplete => $_get(9, 16, false);
  void set isFkComplete(bool v) { $_setBool(9, 16, v); }
  bool hasIsFkComplete() => $_has(9, 16);
  void clearIsFkComplete() => clearField(16);

  DTable get table => $_get(10, 17, null);
  void set table(DTable v) { setField(17, v); }
  bool hasTable() => $_has(10, 17);
  void clearTable() => clearField(17);

  List<DStatistics> get statisticList => $_get(11, 20, null);

  String get exportUrl => $_get(12, 25, '');
  void set exportUrl(String v) { $_setString(12, 25, v); }
  bool hasExportUrl() => $_has(12, 25);
  void clearExportUrl() => clearField(25);
}

class _ReadonlyDataResponse extends DataResponse with ReadonlyMessageMixin {}

class DataServiceApi {
  RpcClient _client;
  DataServiceApi(this._client);

  Future<DataResponse> data(ClientContext ctx, DataRequest request) {
    var emptyResponse = new DataResponse();
    return _client.invoke(ctx, 'DataService', 'Data', request, emptyResponse);
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

  Future<GeneratedMessage> handleCall(ServerContext ctx, String method, GeneratedMessage request) {
    switch (method) {
      case 'Data': return data(ctx, request);
      default: throw new ArgumentError('Unknown method: $method');
    }
  }

  Map<String, dynamic> get $json => DataService$json;
  Map<String, dynamic> get $messageJson => DataService$messageJson;
}

const DataRequestType$json = const {
  '1': 'DataRequestType',
  '2': const [
    const {'1': 'QUERY', '2': 1},
    const {'1': 'QUERYFK', '2': 2},
    const {'1': 'QUERYCOUNT', '2': 3},
    const {'1': 'CALLOUT', '2': 4},
    const {'1': 'SAVE', '2': 5},
    const {'1': 'DELETE', '2': 6},
    const {'1': 'EXPORT', '2': 7},
    const {'1': 'NEW', '2': 8},
  ],
};

const DataExportType$json = const {
  '1': 'DataExportType',
  '2': const [
    const {'1': 'PDF', '2': 1},
    const {'1': 'XML', '2': 2},
    const {'1': 'JSON', '2': 3},
    const {'1': 'CSV', '2': 4},
    const {'1': 'HTML', '2': 5},
  ],
};

const DataRequest$json = const {
  '1': 'DataRequest',
  '2': const [
    const {'1': 'request', '3': 1, '4': 1, '5': 11, '6': '.CRequest'},
    const {'1': 'type', '3': 3, '4': 2, '5': 14, '6': '.DataRequestType'},
    const {'1': 'table_name', '3': 4, '4': 2, '5': 9},
    const {'1': 'window_no', '3': 5, '4': 1, '5': 9},
    const {'1': 'ui_external_key', '3': 7, '4': 1, '5': 9},
    const {'1': 'field_external_key', '3': 8, '4': 1, '5': 9},
    const {'1': 'context', '3': 6, '4': 3, '5': 11, '6': '.DKeyValue'},
    const {'1': 'query_ref', '3': 9, '4': 1, '5': 9},
    const {'1': 'query_offset', '3': 10, '4': 1, '5': 5, '7': '0'},
    const {'1': 'query_limit', '3': 11, '4': 1, '5': 5, '7': '0'},
    const {'1': 'query_column_name', '3': 12, '4': 3, '5': 9},
    const {'1': 'is_query_force', '3': 13, '4': 1, '5': 8, '7': 'false'},
    const {'1': 'is_include_stats', '3': 14, '4': 1, '5': 8, '7': 'true'},
    const {'1': 'query_filter', '3': 15, '4': 3, '5': 11, '6': '.DFilter'},
    const {'1': 'query_filter_logic', '3': 16, '4': 1, '5': 9},
    const {'1': 'query_sort', '3': 17, '4': 3, '5': 11, '6': '.DSort'},
    const {'1': 'saved_query', '3': 18, '4': 1, '5': 11, '6': '.SavedQuery'},
    const {'1': 'fk_id', '3': 25, '4': 1, '5': 9},
    const {'1': 'fk_parent_column_name', '3': 26, '4': 1, '5': 9},
    const {'1': 'fk_parent_value', '3': 27, '4': 1, '5': 9},
    const {'1': 'fk_restriction_sql', '3': 28, '4': 1, '5': 9},
    const {'1': 'record', '3': 30, '4': 3, '5': 11, '6': '.DRecord'},
    const {'1': 'validation_callout', '3': 31, '4': 1, '5': 9},
    const {'1': 'column_changed', '3': 32, '4': 1, '5': 11, '6': '.DEntry'},
    const {'1': 'export_title', '3': 35, '4': 1, '5': 9},
    const {'1': 'export_column_name', '3': 36, '4': 3, '5': 9},
    const {'1': 'export_type', '3': 37, '4': 1, '5': 14, '6': '.DataExportType'},
    const {'1': 'email_recipient', '3': 38, '4': 3, '5': 9},
    const {'1': 'email_message', '3': 39, '4': 1, '5': 9},
  ],
};

const DataResponse$json = const {
  '1': 'DataResponse',
  '2': const [
    const {'1': 'response', '3': 1, '4': 1, '5': 11, '6': '.SResponse'},
    const {'1': 'table_name', '3': 4, '4': 1, '5': 9},
    const {'1': 'total_rows', '3': 5, '4': 1, '5': 5},
    const {'1': 'query_offset', '3': 6, '4': 1, '5': 5},
    const {'1': 'query_ref', '3': 9, '4': 1, '5': 9},
    const {'1': 'record', '3': 10, '4': 3, '5': 11, '6': '.DRecord'},
    const {'1': 'records_processed', '3': 11, '4': 1, '5': 5},
    const {'1': 'context_change', '3': 12, '4': 3, '5': 11, '6': '.DKeyValue'},
    const {'1': 'fks', '3': 15, '4': 3, '5': 11, '6': '.DFK'},
    const {'1': 'is_fk_complete', '3': 16, '4': 1, '5': 8},
    const {'1': 'table', '3': 17, '4': 1, '5': 11, '6': '.DTable'},
    const {'1': 'statistic', '3': 20, '4': 3, '5': 11, '6': '.DStatistics'},
    const {'1': 'export_url', '3': 25, '4': 1, '5': 9},
  ],
};

const DataService$json = const {
  '1': 'DataService',
  '2': const [
    const {'1': 'Data', '2': '.DataRequest', '3': '.DataResponse'},
  ],
};

const DataService$messageJson = const {
  '.DataRequest': DataRequest$json,
  '.CRequest': CRequest$json,
  '.CEnv': CEnv$json,
  '.DKeyValue': DKeyValue$json,
  '.DFilter': DFilter$json,
  '.DSort': DSort$json,
  '.SavedQuery': SavedQuery$json,
  '.DRecord': DRecord$json,
  '.DEntry': DEntry$json,
  '.DStatistics': DStatistics$json,
  '.DataResponse': DataResponse$json,
  '.SResponse': SResponse$json,
  '.DFK': DFK$json,
  '.DTable': DTable$json,
  '.DColumn': DColumn$json,
  '.DOption': DOption$json,
};

