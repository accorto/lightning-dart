///
//  Generated code. Do not modify.
///
library protoc.check;

import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart';
import 'rr_pb.dart';
import 'data_pb.dart';

class CheckRequest extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('CheckRequest')
    ..a/*<CRequest>*/(1, 'request', PbFieldType.OM, CRequest.getDefault, CRequest.create)
    ..a/*<String>*/(2, 'versionNo', PbFieldType.OS)
    ..a/*<String>*/(3, 'info', PbFieldType.OS)
    ..pp/*<DRecord>*/(5, 'record', PbFieldType.PM, DRecord.$checkItem, DRecord.create)
    ..a/*<double>*/(10, 'dataDouble', PbFieldType.OD)
    ..a/*<double>*/(11, 'dataFloat', PbFieldType.OF)
    ..a/*<int>*/(12, 'dataInt', PbFieldType.O3)
    ..a/*<Int64>*/(13, 'dataLong', PbFieldType.O6, Int64.ZERO)
    ..a/*<int>*/(14, 'dataSint', PbFieldType.OS3)
    ..a/*<Int64>*/(15, 'dataSlong', PbFieldType.OS6, Int64.ZERO)
    ..a/*<bool>*/(16, 'dataBool', PbFieldType.OB)
    ..a/*<String>*/(17, 'dataString', PbFieldType.OS)
    ..a/*<String>*/(18, 'dataBytes', PbFieldType.OS)
    ..p/*<String>*/(20, 'dataString2', PbFieldType.PS)
  ;

  CheckRequest() : super();
  CheckRequest.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CheckRequest.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CheckRequest clone() => new CheckRequest()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static CheckRequest create() => new CheckRequest();
  static PbList<CheckRequest> createRepeated() => new PbList<CheckRequest>();
  static CheckRequest getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyCheckRequest();
    return _defaultInstance;
  }
  static CheckRequest _defaultInstance;
  static void $checkItem(CheckRequest v) {
    if (v is !CheckRequest) checkItemFailed(v, 'CheckRequest');
  }

  CRequest get request => $_get(0, 1, null);
  void set request(CRequest v) { setField(1, v); }
  bool hasRequest() => $_has(0, 1);
  void clearRequest() => clearField(1);

  String get versionNo => $_get(1, 2, '');
  void set versionNo(String v) { $_setString(1, 2, v); }
  bool hasVersionNo() => $_has(1, 2);
  void clearVersionNo() => clearField(2);

  String get info => $_get(2, 3, '');
  void set info(String v) { $_setString(2, 3, v); }
  bool hasInfo() => $_has(2, 3);
  void clearInfo() => clearField(3);

  List<DRecord> get recordList => $_get(3, 5, null);

  double get dataDouble => $_get(4, 10, null);
  void set dataDouble(double v) { $_setDouble(4, 10, v); }
  bool hasDataDouble() => $_has(4, 10);
  void clearDataDouble() => clearField(10);

  double get dataFloat => $_get(5, 11, null);
  void set dataFloat(double v) { $_setFloat(5, 11, v); }
  bool hasDataFloat() => $_has(5, 11);
  void clearDataFloat() => clearField(11);

  int get dataInt => $_get(6, 12, 0);
  void set dataInt(int v) { $_setUnsignedInt32(6, 12, v); }
  bool hasDataInt() => $_has(6, 12);
  void clearDataInt() => clearField(12);

  Int64 get dataLong => $_get(7, 13, null);
  void set dataLong(Int64 v) { $_setInt64(7, 13, v); }
  bool hasDataLong() => $_has(7, 13);
  void clearDataLong() => clearField(13);

  int get dataSint => $_get(8, 14, 0);
  void set dataSint(int v) { $_setSignedInt32(8, 14, v); }
  bool hasDataSint() => $_has(8, 14);
  void clearDataSint() => clearField(14);

  Int64 get dataSlong => $_get(9, 15, null);
  void set dataSlong(Int64 v) { $_setInt64(9, 15, v); }
  bool hasDataSlong() => $_has(9, 15);
  void clearDataSlong() => clearField(15);

  bool get dataBool => $_get(10, 16, false);
  void set dataBool(bool v) { $_setBool(10, 16, v); }
  bool hasDataBool() => $_has(10, 16);
  void clearDataBool() => clearField(16);

  String get dataString => $_get(11, 17, '');
  void set dataString(String v) { $_setString(11, 17, v); }
  bool hasDataString() => $_has(11, 17);
  void clearDataString() => clearField(17);

  String get dataBytes => $_get(12, 18, '');
  void set dataBytes(String v) { $_setString(12, 18, v); }
  bool hasDataBytes() => $_has(12, 18);
  void clearDataBytes() => clearField(18);

  List<String> get dataString2List => $_get(13, 20, null);
}

class _ReadonlyCheckRequest extends CheckRequest with ReadonlyMessageMixin {}

class CheckResponse extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('CheckResponse')
    ..a/*<SResponse>*/(1, 'response', PbFieldType.OM, SResponse.getDefault, SResponse.create)
    ..a/*<String>*/(2, 'versionNo', PbFieldType.OS)
    ..a/*<String>*/(3, 'info', PbFieldType.OS)
    ..pp/*<DRecord>*/(5, 'record', PbFieldType.PM, DRecord.$checkItem, DRecord.create)
    ..a/*<double>*/(10, 'dataDouble', PbFieldType.OD)
    ..a/*<double>*/(11, 'dataFloat', PbFieldType.OF)
    ..a/*<int>*/(12, 'dataInt', PbFieldType.O3)
    ..a/*<Int64>*/(13, 'dataLong', PbFieldType.O6, Int64.ZERO)
    ..a/*<int>*/(14, 'dataSint', PbFieldType.OS3)
    ..a/*<Int64>*/(15, 'dataSlong', PbFieldType.OS6, Int64.ZERO)
    ..a/*<bool>*/(16, 'dataBool', PbFieldType.OB)
    ..a/*<String>*/(17, 'dataString', PbFieldType.OS)
    ..a/*<String>*/(18, 'dataBytes', PbFieldType.OS)
    ..p/*<String>*/(20, 'dataString2', PbFieldType.PS)
  ;

  CheckResponse() : super();
  CheckResponse.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CheckResponse.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CheckResponse clone() => new CheckResponse()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static CheckResponse create() => new CheckResponse();
  static PbList<CheckResponse> createRepeated() => new PbList<CheckResponse>();
  static CheckResponse getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyCheckResponse();
    return _defaultInstance;
  }
  static CheckResponse _defaultInstance;
  static void $checkItem(CheckResponse v) {
    if (v is !CheckResponse) checkItemFailed(v, 'CheckResponse');
  }

  SResponse get response => $_get(0, 1, null);
  void set response(SResponse v) { setField(1, v); }
  bool hasResponse() => $_has(0, 1);
  void clearResponse() => clearField(1);

  String get versionNo => $_get(1, 2, '');
  void set versionNo(String v) { $_setString(1, 2, v); }
  bool hasVersionNo() => $_has(1, 2);
  void clearVersionNo() => clearField(2);

  String get info => $_get(2, 3, '');
  void set info(String v) { $_setString(2, 3, v); }
  bool hasInfo() => $_has(2, 3);
  void clearInfo() => clearField(3);

  List<DRecord> get recordList => $_get(3, 5, null);

  double get dataDouble => $_get(4, 10, null);
  void set dataDouble(double v) { $_setDouble(4, 10, v); }
  bool hasDataDouble() => $_has(4, 10);
  void clearDataDouble() => clearField(10);

  double get dataFloat => $_get(5, 11, null);
  void set dataFloat(double v) { $_setFloat(5, 11, v); }
  bool hasDataFloat() => $_has(5, 11);
  void clearDataFloat() => clearField(11);

  int get dataInt => $_get(6, 12, 0);
  void set dataInt(int v) { $_setUnsignedInt32(6, 12, v); }
  bool hasDataInt() => $_has(6, 12);
  void clearDataInt() => clearField(12);

  Int64 get dataLong => $_get(7, 13, null);
  void set dataLong(Int64 v) { $_setInt64(7, 13, v); }
  bool hasDataLong() => $_has(7, 13);
  void clearDataLong() => clearField(13);

  int get dataSint => $_get(8, 14, 0);
  void set dataSint(int v) { $_setSignedInt32(8, 14, v); }
  bool hasDataSint() => $_has(8, 14);
  void clearDataSint() => clearField(14);

  Int64 get dataSlong => $_get(9, 15, null);
  void set dataSlong(Int64 v) { $_setInt64(9, 15, v); }
  bool hasDataSlong() => $_has(9, 15);
  void clearDataSlong() => clearField(15);

  bool get dataBool => $_get(10, 16, false);
  void set dataBool(bool v) { $_setBool(10, 16, v); }
  bool hasDataBool() => $_has(10, 16);
  void clearDataBool() => clearField(16);

  String get dataString => $_get(11, 17, '');
  void set dataString(String v) { $_setString(11, 17, v); }
  bool hasDataString() => $_has(11, 17);
  void clearDataString() => clearField(17);

  String get dataBytes => $_get(12, 18, '');
  void set dataBytes(String v) { $_setString(12, 18, v); }
  bool hasDataBytes() => $_has(12, 18);
  void clearDataBytes() => clearField(18);

  List<String> get dataString2List => $_get(13, 20, null);
}

class _ReadonlyCheckResponse extends CheckResponse with ReadonlyMessageMixin {}

class CheckServiceApi {
  RpcClient _client;
  CheckServiceApi(this._client);

  Future<CheckResponse> check(ClientContext ctx, CheckRequest request) {
    var emptyResponse = new CheckResponse();
    return _client.invoke(ctx, 'CheckService', 'Check', request, emptyResponse);
  }
}

abstract class CheckServiceBase extends GeneratedService {
  Future<CheckResponse> check(ServerContext ctx, CheckRequest request);

  GeneratedMessage createRequest(String method) {
    switch (method) {
      case 'Check': return new CheckRequest();
      default: throw new ArgumentError('Unknown method: $method');
    }
  }

  Future<GeneratedMessage> handleCall(ServerContext ctx, String method, GeneratedMessage request) {
    switch (method) {
      case 'Check': return check(ctx, request);
      default: throw new ArgumentError('Unknown method: $method');
    }
  }

  Map<String, dynamic> get $json => CheckService$json;
  Map<String, dynamic> get $messageJson => CheckService$messageJson;
}

const CheckRequest$json = const {
  '1': 'CheckRequest',
  '2': const [
    const {'1': 'request', '3': 1, '4': 1, '5': 11, '6': '.CRequest'},
    const {'1': 'version_no', '3': 2, '4': 1, '5': 9},
    const {'1': 'info', '3': 3, '4': 1, '5': 9},
    const {'1': 'record', '3': 5, '4': 3, '5': 11, '6': '.DRecord'},
    const {'1': 'data_double', '3': 10, '4': 1, '5': 1},
    const {'1': 'data_float', '3': 11, '4': 1, '5': 2},
    const {'1': 'data_int', '3': 12, '4': 1, '5': 5},
    const {'1': 'data_long', '3': 13, '4': 1, '5': 3},
    const {'1': 'data_sint', '3': 14, '4': 1, '5': 17},
    const {'1': 'data_slong', '3': 15, '4': 1, '5': 18},
    const {'1': 'data_bool', '3': 16, '4': 1, '5': 8},
    const {'1': 'data_string', '3': 17, '4': 1, '5': 9},
    const {'1': 'data_bytes', '3': 18, '4': 1, '5': 9},
    const {'1': 'data_string2', '3': 20, '4': 3, '5': 9},
  ],
};

const CheckResponse$json = const {
  '1': 'CheckResponse',
  '2': const [
    const {'1': 'response', '3': 1, '4': 1, '5': 11, '6': '.SResponse'},
    const {'1': 'version_no', '3': 2, '4': 1, '5': 9},
    const {'1': 'info', '3': 3, '4': 1, '5': 9},
    const {'1': 'record', '3': 5, '4': 3, '5': 11, '6': '.DRecord'},
    const {'1': 'data_double', '3': 10, '4': 1, '5': 1},
    const {'1': 'data_float', '3': 11, '4': 1, '5': 2},
    const {'1': 'data_int', '3': 12, '4': 1, '5': 5},
    const {'1': 'data_long', '3': 13, '4': 1, '5': 3},
    const {'1': 'data_sint', '3': 14, '4': 1, '5': 17},
    const {'1': 'data_slong', '3': 15, '4': 1, '5': 18},
    const {'1': 'data_bool', '3': 16, '4': 1, '5': 8},
    const {'1': 'data_string', '3': 17, '4': 1, '5': 9},
    const {'1': 'data_bytes', '3': 18, '4': 1, '5': 9},
    const {'1': 'data_string2', '3': 20, '4': 3, '5': 9},
  ],
};

const CheckService$json = const {
  '1': 'CheckService',
  '2': const [
    const {'1': 'Check', '2': '.CheckRequest', '3': '.CheckResponse'},
  ],
};

const CheckService$messageJson = const {
  '.CheckRequest': CheckRequest$json,
  '.CRequest': CRequest$json,
  '.CEnv': CEnv$json,
  '.DRecord': DRecord$json,
  '.DEntry': DEntry$json,
  '.DStatistics': DStatistics$json,
  '.CheckResponse': CheckResponse$json,
  '.SResponse': SResponse$json,
};

