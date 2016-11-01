///
//  Generated code. Do not modify.
///
library protoc.rr_login;

import 'package:protobuf/protobuf.dart';
import 'rr_pb.dart';
import 'data_pb.dart';
import 'display_pb.dart';

class LoginRequest extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('LoginRequest')
    ..a/*<CRequest>*/(1, 'request', PbFieldType.QM, CRequest.getDefault, CRequest.create)
    ..a/*<LoginInfo>*/(2, 'loginInfo', PbFieldType.OM, LoginInfo.getDefault, LoginInfo.create)
    ..pp/*<DEntry>*/(10, 'param', PbFieldType.PM, DEntry.$checkItem, DEntry.create)
  ;

  LoginRequest() : super();
  LoginRequest.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  LoginRequest.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  LoginRequest clone() => new LoginRequest()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static LoginRequest create() => new LoginRequest();
  static PbList<LoginRequest> createRepeated() => new PbList<LoginRequest>();
  static LoginRequest getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyLoginRequest();
    return _defaultInstance;
  }
  static LoginRequest _defaultInstance;
  static void $checkItem(LoginRequest v) {
    if (v is !LoginRequest) checkItemFailed(v, 'LoginRequest');
  }

  CRequest get request => $_get(0, 1, null);
  void set request(CRequest v) { setField(1, v); }
  bool hasRequest() => $_has(0, 1);
  void clearRequest() => clearField(1);

  LoginInfo get loginInfo => $_get(1, 2, null);
  void set loginInfo(LoginInfo v) { setField(2, v); }
  bool hasLoginInfo() => $_has(1, 2);
  void clearLoginInfo() => clearField(2);

  List<DEntry> get paramList => $_get(2, 10, null);
}

class _ReadonlyLoginRequest extends LoginRequest with ReadonlyMessageMixin {}

class LoginResponse extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('LoginResponse')
    ..a/*<SResponse>*/(1, 'response', PbFieldType.QM, SResponse.getDefault, SResponse.create)
    ..a/*<Session>*/(2, 'session', PbFieldType.OM, Session.getDefault, Session.create)
    ..a/*<String>*/(3, 'sso', PbFieldType.OS)
    ..pp/*<UIPanelColumn>*/(5, 'parameter', PbFieldType.PM, UIPanelColumn.$checkItem, UIPanelColumn.create)
    ..a/*<String>*/(10, 'tenantId', PbFieldType.OS)
    ..a/*<String>*/(11, 'tenantName', PbFieldType.OS)
    ..a/*<String>*/(12, 'tenantLogo', PbFieldType.OS)
    ..a/*<String>*/(13, 'googleAnalytics', PbFieldType.OS)
  ;

  LoginResponse() : super();
  LoginResponse.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  LoginResponse.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  LoginResponse clone() => new LoginResponse()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static LoginResponse create() => new LoginResponse();
  static PbList<LoginResponse> createRepeated() => new PbList<LoginResponse>();
  static LoginResponse getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyLoginResponse();
    return _defaultInstance;
  }
  static LoginResponse _defaultInstance;
  static void $checkItem(LoginResponse v) {
    if (v is !LoginResponse) checkItemFailed(v, 'LoginResponse');
  }

  SResponse get response => $_get(0, 1, null);
  void set response(SResponse v) { setField(1, v); }
  bool hasResponse() => $_has(0, 1);
  void clearResponse() => clearField(1);

  Session get session => $_get(1, 2, null);
  void set session(Session v) { setField(2, v); }
  bool hasSession() => $_has(1, 2);
  void clearSession() => clearField(2);

  String get sso => $_get(2, 3, '');
  void set sso(String v) { $_setString(2, 3, v); }
  bool hasSso() => $_has(2, 3);
  void clearSso() => clearField(3);

  List<UIPanelColumn> get parameterList => $_get(3, 5, null);

  String get tenantId => $_get(4, 10, '');
  void set tenantId(String v) { $_setString(4, 10, v); }
  bool hasTenantId() => $_has(4, 10);
  void clearTenantId() => clearField(10);

  String get tenantName => $_get(5, 11, '');
  void set tenantName(String v) { $_setString(5, 11, v); }
  bool hasTenantName() => $_has(5, 11);
  void clearTenantName() => clearField(11);

  String get tenantLogo => $_get(6, 12, '');
  void set tenantLogo(String v) { $_setString(6, 12, v); }
  bool hasTenantLogo() => $_has(6, 12);
  void clearTenantLogo() => clearField(12);

  String get googleAnalytics => $_get(7, 13, '');
  void set googleAnalytics(String v) { $_setString(7, 13, v); }
  bool hasGoogleAnalytics() => $_has(7, 13);
  void clearGoogleAnalytics() => clearField(13);
}

class _ReadonlyLoginResponse extends LoginResponse with ReadonlyMessageMixin {}

const LoginRequest$json = const {
  '1': 'LoginRequest',
  '2': const [
    const {'1': 'request', '3': 1, '4': 2, '5': 11, '6': '.CRequest'},
    const {'1': 'login_info', '3': 2, '4': 1, '5': 11, '6': '.LoginInfo'},
    const {'1': 'param', '3': 10, '4': 3, '5': 11, '6': '.DEntry'},
  ],
};

const LoginResponse$json = const {
  '1': 'LoginResponse',
  '2': const [
    const {'1': 'response', '3': 1, '4': 2, '5': 11, '6': '.SResponse'},
    const {'1': 'session', '3': 2, '4': 1, '5': 11, '6': '.Session'},
    const {'1': 'sso', '3': 3, '4': 1, '5': 9},
    const {'1': 'parameter', '3': 5, '4': 3, '5': 11, '6': '.UIPanelColumn'},
    const {'1': 'tenant_id', '3': 10, '4': 1, '5': 9},
    const {'1': 'tenant_name', '3': 11, '4': 1, '5': 9},
    const {'1': 'tenant_logo', '3': 12, '4': 1, '5': 9},
    const {'1': 'google_analytics', '3': 13, '4': 1, '5': 9},
  ],
};

