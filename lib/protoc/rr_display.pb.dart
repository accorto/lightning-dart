///
//  Generated code. Do not modify.
///
library rr_display;

import 'dart:async';

import 'package:protobuf/protobuf.dart';
import 'rr.pb.dart';
import 'display.pb.dart';
import 'structure.pb.dart';

class DisplayRequestType extends ProtobufEnum {
  static const DisplayRequestType LIST = const DisplayRequestType._(1, 'LIST');
  static const DisplayRequestType GET = const DisplayRequestType._(2, 'GET');
  static const DisplayRequestType UPDATE = const DisplayRequestType._(3, 'UPDATE');

  static const List<DisplayRequestType> values = const <DisplayRequestType> [
    LIST,
    GET,
    UPDATE,
  ];

  static final Map<int, DisplayRequestType> _byValue = ProtobufEnum.initByValue(values);
  static DisplayRequestType valueOf(int value) => _byValue[value];

  const DisplayRequestType._(int v, String n) : super(v, n);
}

class DisplayRequest extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DisplayRequest')
    ..a(1, 'request', GeneratedMessage.QM, CRequest.create, CRequest.create)
    ..e(5, 'type', GeneratedMessage.QE, DisplayRequestType.GET, (var v) => DisplayRequestType.valueOf(v))
    ..a(6, 'listPattern', GeneratedMessage.OS)
    ..a(7, 'isNoCache', GeneratedMessage.OB)
    ..m(10, 'display', UIInfo.create, UIInfo.createRepeated)
    ..a(15, 'uiId', GeneratedMessage.OS)
    ..a(16, 'updatedLabel', GeneratedMessage.OS)
    ..a(17, 'updatedTenantId', GeneratedMessage.OS)
    ..a(18, 'updatedRoleId', GeneratedMessage.OS)
    ..a(19, 'updatedUserId', GeneratedMessage.OS)
    ..a(20, 'uiUpdateFlag', GeneratedMessage.OS)
    ..m(30, 'updatedGridColumn', UIGridColumn.create, UIGridColumn.createRepeated)
    ..m(31, 'updatedPanel', UIPanel.create, UIPanel.createRepeated)
    ..m(32, 'updatedProcess', UIProcess.create, UIProcess.createRepeated)
    ..m(33, 'updatedLink', UILink.create, UILink.createRepeated)
    ..m(34, 'updatedQueryColumn', UIQueryColumn.create, UIQueryColumn.createRepeated)
  ;

  DisplayRequest() : super();
  DisplayRequest.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DisplayRequest.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DisplayRequest clone() => new DisplayRequest()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DisplayRequest create() => new DisplayRequest();
  static PbList<DisplayRequest> createRepeated() => new PbList<DisplayRequest>();

  CRequest get request => getField(1);
  void set request(CRequest v) { setField(1, v); }
  bool hasRequest() => hasField(1);
  void clearRequest() => clearField(1);

  DisplayRequestType get type => getField(5);
  void set type(DisplayRequestType v) { setField(5, v); }
  bool hasType() => hasField(5);
  void clearType() => clearField(5);

  String get listPattern => getField(6);
  void set listPattern(String v) { setField(6, v); }
  bool hasListPattern() => hasField(6);
  void clearListPattern() => clearField(6);

  bool get isNoCache => getField(7);
  void set isNoCache(bool v) { setField(7, v); }
  bool hasIsNoCache() => hasField(7);
  void clearIsNoCache() => clearField(7);

  List<UIInfo> get displayList => getField(10);

  String get uiId => getField(15);
  void set uiId(String v) { setField(15, v); }
  bool hasUiId() => hasField(15);
  void clearUiId() => clearField(15);

  String get updatedLabel => getField(16);
  void set updatedLabel(String v) { setField(16, v); }
  bool hasUpdatedLabel() => hasField(16);
  void clearUpdatedLabel() => clearField(16);

  String get updatedTenantId => getField(17);
  void set updatedTenantId(String v) { setField(17, v); }
  bool hasUpdatedTenantId() => hasField(17);
  void clearUpdatedTenantId() => clearField(17);

  String get updatedRoleId => getField(18);
  void set updatedRoleId(String v) { setField(18, v); }
  bool hasUpdatedRoleId() => hasField(18);
  void clearUpdatedRoleId() => clearField(18);

  String get updatedUserId => getField(19);
  void set updatedUserId(String v) { setField(19, v); }
  bool hasUpdatedUserId() => hasField(19);
  void clearUpdatedUserId() => clearField(19);

  String get uiUpdateFlag => getField(20);
  void set uiUpdateFlag(String v) { setField(20, v); }
  bool hasUiUpdateFlag() => hasField(20);
  void clearUiUpdateFlag() => clearField(20);

  List<UIGridColumn> get updatedGridColumnList => getField(30);

  List<UIPanel> get updatedPanelList => getField(31);

  List<UIProcess> get updatedProcessList => getField(32);

  List<UILink> get updatedLinkList => getField(33);

  List<UIQueryColumn> get updatedQueryColumnList => getField(34);
}

class DisplayResponse extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DisplayResponse')
    ..a(1, 'response', GeneratedMessage.QM, SResponse.create, SResponse.create)
    ..m(10, 'ui', UI.create, UI.createRepeated)
    ..m(11, 'table', DTable.create, DTable.createRepeated)
    ..m(12, 'display', UIInfo.create, UIInfo.createRepeated)
  ;

  DisplayResponse() : super();
  DisplayResponse.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DisplayResponse.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DisplayResponse clone() => new DisplayResponse()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DisplayResponse create() => new DisplayResponse();
  static PbList<DisplayResponse> createRepeated() => new PbList<DisplayResponse>();

  SResponse get response => getField(1);
  void set response(SResponse v) { setField(1, v); }
  bool hasResponse() => hasField(1);
  void clearResponse() => clearField(1);

  List<UI> get uiList => getField(10);

  List<DTable> get tableList => getField(11);

  List<UIInfo> get displayList => getField(12);
}

class DisplayServiceApi {
  RpcClient _client;
  DisplayServiceApi(this._client);

  Future<DisplayResponse> display(ClientContext ctx, DisplayRequest request) async {
    var emptyResponse = new DisplayResponse();
    var result = await _client.invoke(ctx, 'DisplayService', 'Display', request, emptyResponse);
    return result;
  }
}

abstract class DisplayServiceBase extends GeneratedService {
  Future<DisplayResponse> display(ServerContext ctx, DisplayRequest request);

  GeneratedMessage createRequest(String method) {
    switch (method) {
      case 'Display': return new DisplayRequest();
      default: throw new ArgumentError('Unknown method: $method');
    }
  }

  Future<GeneratedMessage> handleCall(ServerContext ctx, String method, GeneratedMessage request) async {
    switch (method) {
      case 'Display': return await display(ctx, request);
      default: throw new ArgumentError('Unknown method: $method');
    }
  }
}

