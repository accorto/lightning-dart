/**
 * Generated Protocol Buffers code. Do not modify.
 */
library protoc.rr;

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart';

class CRequest extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('CRequest')
    ..a(1, 'trxNo', PbFieldType.Q3)
    ..a(2, 'trxType', PbFieldType.QS)
    ..a(3, 'clientRequestTime', PbFieldType.Q6, Int64.ZERO)
    ..a(5, 'sid', PbFieldType.OS)
    ..a(6, 'info', PbFieldType.OS)
    ..a(7, 'env', PbFieldType.OM, CEnv.getDefault, CEnv.create)
    ..a(8, 'clientId', PbFieldType.OS)
    ..a(10, 'sfEndpoint', PbFieldType.OS)
    ..a(11, 'sfToken', PbFieldType.OS)
  ;

  CRequest() : super();
  CRequest.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CRequest.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CRequest clone() => new CRequest()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static CRequest create() => new CRequest();
  static PbList<CRequest> createRepeated() => new PbList<CRequest>();
  static CRequest getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyCRequest();
    return _defaultInstance;
  }
  static CRequest _defaultInstance;
  static void $checkItem(CRequest v) {
    if (v is !CRequest) checkItemFailed(v, 'CRequest');
  }

  int get trxNo => $_get(0, 1, 0);
  void set trxNo(int v) { $_setUnsignedInt32(0, 1, v); }
  bool hasTrxNo() => $_has(0, 1);
  void clearTrxNo() => clearField(1);

  String get trxType => $_get(1, 2, '');
  void set trxType(String v) { $_setString(1, 2, v); }
  bool hasTrxType() => $_has(1, 2);
  void clearTrxType() => clearField(2);

  Int64 get clientRequestTime => $_get(2, 3, null);
  void set clientRequestTime(Int64 v) { $_setInt64(2, 3, v); }
  bool hasClientRequestTime() => $_has(2, 3);
  void clearClientRequestTime() => clearField(3);

  String get sid => $_get(3, 5, '');
  void set sid(String v) { $_setString(3, 5, v); }
  bool hasSid() => $_has(3, 5);
  void clearSid() => clearField(5);

  String get info => $_get(4, 6, '');
  void set info(String v) { $_setString(4, 6, v); }
  bool hasInfo() => $_has(4, 6);
  void clearInfo() => clearField(6);

  CEnv get env => $_get(5, 7, null);
  void set env(CEnv v) { setField(7, v); }
  bool hasEnv() => $_has(5, 7);
  void clearEnv() => clearField(7);

  String get clientId => $_get(6, 8, '');
  void set clientId(String v) { $_setString(6, 8, v); }
  bool hasClientId() => $_has(6, 8);
  void clearClientId() => clearField(8);

  String get sfEndpoint => $_get(7, 10, '');
  void set sfEndpoint(String v) { $_setString(7, 10, v); }
  bool hasSfEndpoint() => $_has(7, 10);
  void clearSfEndpoint() => clearField(10);

  String get sfToken => $_get(8, 11, '');
  void set sfToken(String v) { $_setString(8, 11, v); }
  bool hasSfToken() => $_has(8, 11);
  void clearSfToken() => clearField(11);
}

class _ReadonlyCRequest extends CRequest with ReadonlyMessageMixin {}

class CEnv extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('CEnv')
    ..a(1, 'clientUrl', PbFieldType.OS)
    ..a(2, 'locale', PbFieldType.OS)
    ..a(3, 'timeZone', PbFieldType.OS)
    ..a(4, 'timeZoneUtcOffset', PbFieldType.O3)
    ..a(5, 'serverUrl', PbFieldType.OS)
    ..a(9, 'isDevMode', PbFieldType.OB)
    ..a(10, 'lat', PbFieldType.OD)
    ..a(11, 'lon', PbFieldType.OD)
    ..a(12, 'alt', PbFieldType.OD)
    ..a(13, 'dir', PbFieldType.OD)
    ..a(14, 'speed', PbFieldType.OD)
    ..a(15, 'geoError', PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  CEnv() : super();
  CEnv.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CEnv.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CEnv clone() => new CEnv()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static CEnv create() => new CEnv();
  static PbList<CEnv> createRepeated() => new PbList<CEnv>();
  static CEnv getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyCEnv();
    return _defaultInstance;
  }
  static CEnv _defaultInstance;
  static void $checkItem(CEnv v) {
    if (v is !CEnv) checkItemFailed(v, 'CEnv');
  }

  String get clientUrl => $_get(0, 1, '');
  void set clientUrl(String v) { $_setString(0, 1, v); }
  bool hasClientUrl() => $_has(0, 1);
  void clearClientUrl() => clearField(1);

  String get locale => $_get(1, 2, '');
  void set locale(String v) { $_setString(1, 2, v); }
  bool hasLocale() => $_has(1, 2);
  void clearLocale() => clearField(2);

  String get timeZone => $_get(2, 3, '');
  void set timeZone(String v) { $_setString(2, 3, v); }
  bool hasTimeZone() => $_has(2, 3);
  void clearTimeZone() => clearField(3);

  int get timeZoneUtcOffset => $_get(3, 4, 0);
  void set timeZoneUtcOffset(int v) { $_setUnsignedInt32(3, 4, v); }
  bool hasTimeZoneUtcOffset() => $_has(3, 4);
  void clearTimeZoneUtcOffset() => clearField(4);

  String get serverUrl => $_get(4, 5, '');
  void set serverUrl(String v) { $_setString(4, 5, v); }
  bool hasServerUrl() => $_has(4, 5);
  void clearServerUrl() => clearField(5);

  bool get isDevMode => $_get(5, 9, false);
  void set isDevMode(bool v) { $_setBool(5, 9, v); }
  bool hasIsDevMode() => $_has(5, 9);
  void clearIsDevMode() => clearField(9);

  double get lat => $_get(6, 10, null);
  void set lat(double v) { $_setDouble(6, 10, v); }
  bool hasLat() => $_has(6, 10);
  void clearLat() => clearField(10);

  double get lon => $_get(7, 11, null);
  void set lon(double v) { $_setDouble(7, 11, v); }
  bool hasLon() => $_has(7, 11);
  void clearLon() => clearField(11);

  double get alt => $_get(8, 12, null);
  void set alt(double v) { $_setDouble(8, 12, v); }
  bool hasAlt() => $_has(8, 12);
  void clearAlt() => clearField(12);

  double get dir => $_get(9, 13, null);
  void set dir(double v) { $_setDouble(9, 13, v); }
  bool hasDir() => $_has(9, 13);
  void clearDir() => clearField(13);

  double get speed => $_get(10, 14, null);
  void set speed(double v) { $_setDouble(10, 14, v); }
  bool hasSpeed() => $_has(10, 14);
  void clearSpeed() => clearField(14);

  int get geoError => $_get(11, 15, 0);
  void set geoError(int v) { $_setUnsignedInt32(11, 15, v); }
  bool hasGeoError() => $_has(11, 15);
  void clearGeoError() => clearField(15);
}

class _ReadonlyCEnv extends CEnv with ReadonlyMessageMixin {}

class SResponse extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('SResponse')
    ..a(1, 'trxNo', PbFieldType.Q3)
    ..a(2, 'trxType', PbFieldType.QS)
    ..a(3, 'clientRequestTime', PbFieldType.Q6, Int64.ZERO)
    ..a(4, 'clientReceiptTime', PbFieldType.O6, Int64.ZERO)
    ..a(5, 'serverQueueMs', PbFieldType.O3)
    ..a(6, 'serverDurationMs', PbFieldType.Q3)
    ..a(7, 'remoteMs', PbFieldType.O3)
    ..a(8, 'isSuccess', PbFieldType.QB)
    ..a(9, 'msg', PbFieldType.QS)
    ..a(10, 'info', PbFieldType.OS)
  ;

  SResponse() : super();
  SResponse.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  SResponse.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  SResponse clone() => new SResponse()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static SResponse create() => new SResponse();
  static PbList<SResponse> createRepeated() => new PbList<SResponse>();
  static SResponse getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlySResponse();
    return _defaultInstance;
  }
  static SResponse _defaultInstance;
  static void $checkItem(SResponse v) {
    if (v is !SResponse) checkItemFailed(v, 'SResponse');
  }

  int get trxNo => $_get(0, 1, 0);
  void set trxNo(int v) { $_setUnsignedInt32(0, 1, v); }
  bool hasTrxNo() => $_has(0, 1);
  void clearTrxNo() => clearField(1);

  String get trxType => $_get(1, 2, '');
  void set trxType(String v) { $_setString(1, 2, v); }
  bool hasTrxType() => $_has(1, 2);
  void clearTrxType() => clearField(2);

  Int64 get clientRequestTime => $_get(2, 3, null);
  void set clientRequestTime(Int64 v) { $_setInt64(2, 3, v); }
  bool hasClientRequestTime() => $_has(2, 3);
  void clearClientRequestTime() => clearField(3);

  Int64 get clientReceiptTime => $_get(3, 4, null);
  void set clientReceiptTime(Int64 v) { $_setInt64(3, 4, v); }
  bool hasClientReceiptTime() => $_has(3, 4);
  void clearClientReceiptTime() => clearField(4);

  int get serverQueueMs => $_get(4, 5, 0);
  void set serverQueueMs(int v) { $_setUnsignedInt32(4, 5, v); }
  bool hasServerQueueMs() => $_has(4, 5);
  void clearServerQueueMs() => clearField(5);

  int get serverDurationMs => $_get(5, 6, 0);
  void set serverDurationMs(int v) { $_setUnsignedInt32(5, 6, v); }
  bool hasServerDurationMs() => $_has(5, 6);
  void clearServerDurationMs() => clearField(6);

  int get remoteMs => $_get(6, 7, 0);
  void set remoteMs(int v) { $_setUnsignedInt32(6, 7, v); }
  bool hasRemoteMs() => $_has(6, 7);
  void clearRemoteMs() => clearField(7);

  bool get isSuccess => $_get(7, 8, false);
  void set isSuccess(bool v) { $_setBool(7, 8, v); }
  bool hasIsSuccess() => $_has(7, 8);
  void clearIsSuccess() => clearField(8);

  String get msg => $_get(8, 9, '');
  void set msg(String v) { $_setString(8, 9, v); }
  bool hasMsg() => $_has(8, 9);
  void clearMsg() => clearField(9);

  String get info => $_get(9, 10, '');
  void set info(String v) { $_setString(9, 10, v); }
  bool hasInfo() => $_has(9, 10);
  void clearInfo() => clearField(10);
}

class _ReadonlySResponse extends SResponse with ReadonlyMessageMixin {}

class LoginInfo extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('LoginInfo')
    ..a(1, 'un', PbFieldType.OS)
    ..a(2, 'pw', PbFieldType.OS)
    ..a(3, 'sid', PbFieldType.OS)
    ..a(4, 'tenant', PbFieldType.OS)
    ..a(5, 'externalKey', PbFieldType.OS)
    ..a(6, 'ssoId', PbFieldType.OS)
    ..a(7, 'isRestOrSoap', PbFieldType.OB)
    ..a(9, 'sfRefresh', PbFieldType.OS)
    ..a(10, 'sfSid', PbFieldType.OS)
    ..a(11, 'sfEndpoint', PbFieldType.OS)
    ..a(12, 'sfOrgId', PbFieldType.OS)
    ..a(13, 'sfUserId', PbFieldType.OS)
    ..a(14, 'sfUn', PbFieldType.OS)
    ..a(15, 'sfPw', PbFieldType.OS)
    ..a(16, 'token', PbFieldType.OS)
    ..hasRequiredFields = false
  ;

  LoginInfo() : super();
  LoginInfo.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  LoginInfo.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  LoginInfo clone() => new LoginInfo()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static LoginInfo create() => new LoginInfo();
  static PbList<LoginInfo> createRepeated() => new PbList<LoginInfo>();
  static LoginInfo getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyLoginInfo();
    return _defaultInstance;
  }
  static LoginInfo _defaultInstance;
  static void $checkItem(LoginInfo v) {
    if (v is !LoginInfo) checkItemFailed(v, 'LoginInfo');
  }

  String get un => $_get(0, 1, '');
  void set un(String v) { $_setString(0, 1, v); }
  bool hasUn() => $_has(0, 1);
  void clearUn() => clearField(1);

  String get pw => $_get(1, 2, '');
  void set pw(String v) { $_setString(1, 2, v); }
  bool hasPw() => $_has(1, 2);
  void clearPw() => clearField(2);

  String get sid => $_get(2, 3, '');
  void set sid(String v) { $_setString(2, 3, v); }
  bool hasSid() => $_has(2, 3);
  void clearSid() => clearField(3);

  String get tenant => $_get(3, 4, '');
  void set tenant(String v) { $_setString(3, 4, v); }
  bool hasTenant() => $_has(3, 4);
  void clearTenant() => clearField(4);

  String get externalKey => $_get(4, 5, '');
  void set externalKey(String v) { $_setString(4, 5, v); }
  bool hasExternalKey() => $_has(4, 5);
  void clearExternalKey() => clearField(5);

  String get ssoId => $_get(5, 6, '');
  void set ssoId(String v) { $_setString(5, 6, v); }
  bool hasSsoId() => $_has(5, 6);
  void clearSsoId() => clearField(6);

  bool get isRestOrSoap => $_get(6, 7, false);
  void set isRestOrSoap(bool v) { $_setBool(6, 7, v); }
  bool hasIsRestOrSoap() => $_has(6, 7);
  void clearIsRestOrSoap() => clearField(7);

  String get sfRefresh => $_get(7, 9, '');
  void set sfRefresh(String v) { $_setString(7, 9, v); }
  bool hasSfRefresh() => $_has(7, 9);
  void clearSfRefresh() => clearField(9);

  String get sfSid => $_get(8, 10, '');
  void set sfSid(String v) { $_setString(8, 10, v); }
  bool hasSfSid() => $_has(8, 10);
  void clearSfSid() => clearField(10);

  String get sfEndpoint => $_get(9, 11, '');
  void set sfEndpoint(String v) { $_setString(9, 11, v); }
  bool hasSfEndpoint() => $_has(9, 11);
  void clearSfEndpoint() => clearField(11);

  String get sfOrgId => $_get(10, 12, '');
  void set sfOrgId(String v) { $_setString(10, 12, v); }
  bool hasSfOrgId() => $_has(10, 12);
  void clearSfOrgId() => clearField(12);

  String get sfUserId => $_get(11, 13, '');
  void set sfUserId(String v) { $_setString(11, 13, v); }
  bool hasSfUserId() => $_has(11, 13);
  void clearSfUserId() => clearField(13);

  String get sfUn => $_get(12, 14, '');
  void set sfUn(String v) { $_setString(12, 14, v); }
  bool hasSfUn() => $_has(12, 14);
  void clearSfUn() => clearField(14);

  String get sfPw => $_get(13, 15, '');
  void set sfPw(String v) { $_setString(13, 15, v); }
  bool hasSfPw() => $_has(13, 15);
  void clearSfPw() => clearField(15);

  String get token => $_get(14, 16, '');
  void set token(String v) { $_setString(14, 16, v); }
  bool hasToken() => $_has(14, 16);
  void clearToken() => clearField(16);
}

class _ReadonlyLoginInfo extends LoginInfo with ReadonlyMessageMixin {}

class Session extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('Session')
    ..a(1, 'sid', PbFieldType.QS)
    ..a(2, 'soapUrl', PbFieldType.OS)
    ..a(3, 'description', PbFieldType.OS)
    ..a(4, 'locale', PbFieldType.OS)
    ..a(5, 'languageIsoCode', PbFieldType.OS)
    ..a(6, 'currencyIsoCode', PbFieldType.OS)
    ..a(7, 'dateFormatLong', PbFieldType.OS)
    ..a(8, 'dateFormatShort', PbFieldType.OS)
    ..a(9, 'timeFormatLong', PbFieldType.OS)
    ..a(10, 'timeFormatShort', PbFieldType.OS)
    ..a(11, 'isDecimalPoint', PbFieldType.OB)
    ..a(12, 'timeZone', PbFieldType.OS)
    ..a(13, 'timeZoneUtcOffset', PbFieldType.O3)
    ..a(15, 'googleAnalytics', PbFieldType.OS)
    ..a(16, 'customCss', PbFieldType.OS)
    ..a(20, 'tenantId', PbFieldType.OS)
    ..a(21, 'tenantName', PbFieldType.QS)
    ..a(22, 'tenantLogo', PbFieldType.OS)
    ..a(23, 'isTenantMultiCurrency', PbFieldType.OB)
    ..a(24, 'isTenantSystem', PbFieldType.OB)
    ..a(25, 'userId', PbFieldType.OS)
    ..a(26, 'userEmail', PbFieldType.OS)
    ..a(27, 'userName', PbFieldType.OS)
    ..a(28, 'userFullName', PbFieldType.OS)
    ..a(29, 'userResourceId', PbFieldType.OS)
    ..a(30, 'isUserExpert', PbFieldType.OB)
    ..pp(31, 'roles', PbFieldType.PM, Role.$checkItem, Role.create)
    ..pp(32, 'context', PbFieldType.PM, DKeyValue.$checkItem, DKeyValue.create)
    ..a(40, 'nrLicense', PbFieldType.OS)
    ..a(41, 'nrApplication', PbFieldType.OS)
    ..a(45, 'sfEndpoint', PbFieldType.OS)
    ..a(46, 'sfRefreshToken', PbFieldType.OS)
    ..a(47, 'sfToken', PbFieldType.OS)
    ..a(50, 'awsAccessKey', PbFieldType.OS)
    ..a(51, 'awsSecretKey', PbFieldType.OS)
    ..a(52, 'awsSnsArnInfo', PbFieldType.OS)
    ..a(53, 'awsSnsArnWarn', PbFieldType.OS)
  ;

  Session() : super();
  Session.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Session.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Session clone() => new Session()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static Session create() => new Session();
  static PbList<Session> createRepeated() => new PbList<Session>();
  static Session getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlySession();
    return _defaultInstance;
  }
  static Session _defaultInstance;
  static void $checkItem(Session v) {
    if (v is !Session) checkItemFailed(v, 'Session');
  }

  String get sid => $_get(0, 1, '');
  void set sid(String v) { $_setString(0, 1, v); }
  bool hasSid() => $_has(0, 1);
  void clearSid() => clearField(1);

  String get soapUrl => $_get(1, 2, '');
  void set soapUrl(String v) { $_setString(1, 2, v); }
  bool hasSoapUrl() => $_has(1, 2);
  void clearSoapUrl() => clearField(2);

  String get description => $_get(2, 3, '');
  void set description(String v) { $_setString(2, 3, v); }
  bool hasDescription() => $_has(2, 3);
  void clearDescription() => clearField(3);

  String get locale => $_get(3, 4, '');
  void set locale(String v) { $_setString(3, 4, v); }
  bool hasLocale() => $_has(3, 4);
  void clearLocale() => clearField(4);

  String get languageIsoCode => $_get(4, 5, '');
  void set languageIsoCode(String v) { $_setString(4, 5, v); }
  bool hasLanguageIsoCode() => $_has(4, 5);
  void clearLanguageIsoCode() => clearField(5);

  String get currencyIsoCode => $_get(5, 6, '');
  void set currencyIsoCode(String v) { $_setString(5, 6, v); }
  bool hasCurrencyIsoCode() => $_has(5, 6);
  void clearCurrencyIsoCode() => clearField(6);

  String get dateFormatLong => $_get(6, 7, '');
  void set dateFormatLong(String v) { $_setString(6, 7, v); }
  bool hasDateFormatLong() => $_has(6, 7);
  void clearDateFormatLong() => clearField(7);

  String get dateFormatShort => $_get(7, 8, '');
  void set dateFormatShort(String v) { $_setString(7, 8, v); }
  bool hasDateFormatShort() => $_has(7, 8);
  void clearDateFormatShort() => clearField(8);

  String get timeFormatLong => $_get(8, 9, '');
  void set timeFormatLong(String v) { $_setString(8, 9, v); }
  bool hasTimeFormatLong() => $_has(8, 9);
  void clearTimeFormatLong() => clearField(9);

  String get timeFormatShort => $_get(9, 10, '');
  void set timeFormatShort(String v) { $_setString(9, 10, v); }
  bool hasTimeFormatShort() => $_has(9, 10);
  void clearTimeFormatShort() => clearField(10);

  bool get isDecimalPoint => $_get(10, 11, false);
  void set isDecimalPoint(bool v) { $_setBool(10, 11, v); }
  bool hasIsDecimalPoint() => $_has(10, 11);
  void clearIsDecimalPoint() => clearField(11);

  String get timeZone => $_get(11, 12, '');
  void set timeZone(String v) { $_setString(11, 12, v); }
  bool hasTimeZone() => $_has(11, 12);
  void clearTimeZone() => clearField(12);

  int get timeZoneUtcOffset => $_get(12, 13, 0);
  void set timeZoneUtcOffset(int v) { $_setUnsignedInt32(12, 13, v); }
  bool hasTimeZoneUtcOffset() => $_has(12, 13);
  void clearTimeZoneUtcOffset() => clearField(13);

  String get googleAnalytics => $_get(13, 15, '');
  void set googleAnalytics(String v) { $_setString(13, 15, v); }
  bool hasGoogleAnalytics() => $_has(13, 15);
  void clearGoogleAnalytics() => clearField(15);

  String get customCss => $_get(14, 16, '');
  void set customCss(String v) { $_setString(14, 16, v); }
  bool hasCustomCss() => $_has(14, 16);
  void clearCustomCss() => clearField(16);

  String get tenantId => $_get(15, 20, '');
  void set tenantId(String v) { $_setString(15, 20, v); }
  bool hasTenantId() => $_has(15, 20);
  void clearTenantId() => clearField(20);

  String get tenantName => $_get(16, 21, '');
  void set tenantName(String v) { $_setString(16, 21, v); }
  bool hasTenantName() => $_has(16, 21);
  void clearTenantName() => clearField(21);

  String get tenantLogo => $_get(17, 22, '');
  void set tenantLogo(String v) { $_setString(17, 22, v); }
  bool hasTenantLogo() => $_has(17, 22);
  void clearTenantLogo() => clearField(22);

  bool get isTenantMultiCurrency => $_get(18, 23, false);
  void set isTenantMultiCurrency(bool v) { $_setBool(18, 23, v); }
  bool hasIsTenantMultiCurrency() => $_has(18, 23);
  void clearIsTenantMultiCurrency() => clearField(23);

  bool get isTenantSystem => $_get(19, 24, false);
  void set isTenantSystem(bool v) { $_setBool(19, 24, v); }
  bool hasIsTenantSystem() => $_has(19, 24);
  void clearIsTenantSystem() => clearField(24);

  String get userId => $_get(20, 25, '');
  void set userId(String v) { $_setString(20, 25, v); }
  bool hasUserId() => $_has(20, 25);
  void clearUserId() => clearField(25);

  String get userEmail => $_get(21, 26, '');
  void set userEmail(String v) { $_setString(21, 26, v); }
  bool hasUserEmail() => $_has(21, 26);
  void clearUserEmail() => clearField(26);

  String get userName => $_get(22, 27, '');
  void set userName(String v) { $_setString(22, 27, v); }
  bool hasUserName() => $_has(22, 27);
  void clearUserName() => clearField(27);

  String get userFullName => $_get(23, 28, '');
  void set userFullName(String v) { $_setString(23, 28, v); }
  bool hasUserFullName() => $_has(23, 28);
  void clearUserFullName() => clearField(28);

  String get userResourceId => $_get(24, 29, '');
  void set userResourceId(String v) { $_setString(24, 29, v); }
  bool hasUserResourceId() => $_has(24, 29);
  void clearUserResourceId() => clearField(29);

  bool get isUserExpert => $_get(25, 30, false);
  void set isUserExpert(bool v) { $_setBool(25, 30, v); }
  bool hasIsUserExpert() => $_has(25, 30);
  void clearIsUserExpert() => clearField(30);

  List<Role> get rolesList => $_get(26, 31, null);

  List<DKeyValue> get contextList => $_get(27, 32, null);

  String get nrLicense => $_get(28, 40, '');
  void set nrLicense(String v) { $_setString(28, 40, v); }
  bool hasNrLicense() => $_has(28, 40);
  void clearNrLicense() => clearField(40);

  String get nrApplication => $_get(29, 41, '');
  void set nrApplication(String v) { $_setString(29, 41, v); }
  bool hasNrApplication() => $_has(29, 41);
  void clearNrApplication() => clearField(41);

  String get sfEndpoint => $_get(30, 45, '');
  void set sfEndpoint(String v) { $_setString(30, 45, v); }
  bool hasSfEndpoint() => $_has(30, 45);
  void clearSfEndpoint() => clearField(45);

  String get sfRefreshToken => $_get(31, 46, '');
  void set sfRefreshToken(String v) { $_setString(31, 46, v); }
  bool hasSfRefreshToken() => $_has(31, 46);
  void clearSfRefreshToken() => clearField(46);

  String get sfToken => $_get(32, 47, '');
  void set sfToken(String v) { $_setString(32, 47, v); }
  bool hasSfToken() => $_has(32, 47);
  void clearSfToken() => clearField(47);

  String get awsAccessKey => $_get(33, 50, '');
  void set awsAccessKey(String v) { $_setString(33, 50, v); }
  bool hasAwsAccessKey() => $_has(33, 50);
  void clearAwsAccessKey() => clearField(50);

  String get awsSecretKey => $_get(34, 51, '');
  void set awsSecretKey(String v) { $_setString(34, 51, v); }
  bool hasAwsSecretKey() => $_has(34, 51);
  void clearAwsSecretKey() => clearField(51);

  String get awsSnsArnInfo => $_get(35, 52, '');
  void set awsSnsArnInfo(String v) { $_setString(35, 52, v); }
  bool hasAwsSnsArnInfo() => $_has(35, 52);
  void clearAwsSnsArnInfo() => clearField(52);

  String get awsSnsArnWarn => $_get(36, 53, '');
  void set awsSnsArnWarn(String v) { $_setString(36, 53, v); }
  bool hasAwsSnsArnWarn() => $_has(36, 53);
  void clearAwsSnsArnWarn() => clearField(53);
}

class _ReadonlySession extends Session with ReadonlyMessageMixin {}

class Role extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('Role')
    ..a(1, 'roleId', PbFieldType.OS)
    ..a(2, 'tenantId', PbFieldType.OS)
    ..a(3, 'name', PbFieldType.OS)
    ..a(4, 'label', PbFieldType.OS)
    ..a(5, 'isAdministrator', PbFieldType.OB)
    ..hasRequiredFields = false
  ;

  Role() : super();
  Role.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Role.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Role clone() => new Role()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static Role create() => new Role();
  static PbList<Role> createRepeated() => new PbList<Role>();
  static Role getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyRole();
    return _defaultInstance;
  }
  static Role _defaultInstance;
  static void $checkItem(Role v) {
    if (v is !Role) checkItemFailed(v, 'Role');
  }

  String get roleId => $_get(0, 1, '');
  void set roleId(String v) { $_setString(0, 1, v); }
  bool hasRoleId() => $_has(0, 1);
  void clearRoleId() => clearField(1);

  String get tenantId => $_get(1, 2, '');
  void set tenantId(String v) { $_setString(1, 2, v); }
  bool hasTenantId() => $_has(1, 2);
  void clearTenantId() => clearField(2);

  String get name => $_get(2, 3, '');
  void set name(String v) { $_setString(2, 3, v); }
  bool hasName() => $_has(2, 3);
  void clearName() => clearField(3);

  String get label => $_get(3, 4, '');
  void set label(String v) { $_setString(3, 4, v); }
  bool hasLabel() => $_has(3, 4);
  void clearLabel() => clearField(4);

  bool get isAdministrator => $_get(4, 5, false);
  void set isAdministrator(bool v) { $_setBool(4, 5, v); }
  bool hasIsAdministrator() => $_has(4, 5);
  void clearIsAdministrator() => clearField(5);
}

class _ReadonlyRole extends Role with ReadonlyMessageMixin {}

class DValueDisplay extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DValueDisplay')
    ..a(1, 'id', PbFieldType.OS)
    ..a(2, 'value', PbFieldType.QS)
    ..a(3, 'display', PbFieldType.OS)
  ;

  DValueDisplay() : super();
  DValueDisplay.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DValueDisplay.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DValueDisplay clone() => new DValueDisplay()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DValueDisplay create() => new DValueDisplay();
  static PbList<DValueDisplay> createRepeated() => new PbList<DValueDisplay>();
  static DValueDisplay getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyDValueDisplay();
    return _defaultInstance;
  }
  static DValueDisplay _defaultInstance;
  static void $checkItem(DValueDisplay v) {
    if (v is !DValueDisplay) checkItemFailed(v, 'DValueDisplay');
  }

  String get id => $_get(0, 1, '');
  void set id(String v) { $_setString(0, 1, v); }
  bool hasId() => $_has(0, 1);
  void clearId() => clearField(1);

  String get value => $_get(1, 2, '');
  void set value(String v) { $_setString(1, 2, v); }
  bool hasValue() => $_has(1, 2);
  void clearValue() => clearField(2);

  String get display => $_get(2, 3, '');
  void set display(String v) { $_setString(2, 3, v); }
  bool hasDisplay() => $_has(2, 3);
  void clearDisplay() => clearField(3);
}

class _ReadonlyDValueDisplay extends DValueDisplay with ReadonlyMessageMixin {}

class DKeyValue extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DKeyValue')
    ..a(1, 'id', PbFieldType.OS)
    ..a(2, 'key', PbFieldType.QS)
    ..a(3, 'value', PbFieldType.OS)
  ;

  DKeyValue() : super();
  DKeyValue.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DKeyValue.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DKeyValue clone() => new DKeyValue()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DKeyValue create() => new DKeyValue();
  static PbList<DKeyValue> createRepeated() => new PbList<DKeyValue>();
  static DKeyValue getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyDKeyValue();
    return _defaultInstance;
  }
  static DKeyValue _defaultInstance;
  static void $checkItem(DKeyValue v) {
    if (v is !DKeyValue) checkItemFailed(v, 'DKeyValue');
  }

  String get id => $_get(0, 1, '');
  void set id(String v) { $_setString(0, 1, v); }
  bool hasId() => $_has(0, 1);
  void clearId() => clearField(1);

  String get key => $_get(1, 2, '');
  void set key(String v) { $_setString(1, 2, v); }
  bool hasKey() => $_has(1, 2);
  void clearKey() => clearField(2);

  String get value => $_get(2, 3, '');
  void set value(String v) { $_setString(2, 3, v); }
  bool hasValue() => $_has(2, 3);
  void clearValue() => clearField(3);
}

class _ReadonlyDKeyValue extends DKeyValue with ReadonlyMessageMixin {}

const CRequest$json = const {
  '1': 'CRequest',
  '2': const [
    const {'1': 'trx_no', '3': 1, '4': 2, '5': 5},
    const {'1': 'trx_type', '3': 2, '4': 2, '5': 9},
    const {'1': 'client_request_time', '3': 3, '4': 2, '5': 3},
    const {'1': 'sid', '3': 5, '4': 1, '5': 9},
    const {'1': 'info', '3': 6, '4': 1, '5': 9},
    const {'1': 'env', '3': 7, '4': 1, '5': 11, '6': '.CEnv'},
    const {'1': 'client_id', '3': 8, '4': 1, '5': 9},
    const {'1': 'sf_endpoint', '3': 10, '4': 1, '5': 9},
    const {'1': 'sf_token', '3': 11, '4': 1, '5': 9},
  ],
};

const CEnv$json = const {
  '1': 'CEnv',
  '2': const [
    const {'1': 'client_url', '3': 1, '4': 1, '5': 9},
    const {'1': 'locale', '3': 2, '4': 1, '5': 9},
    const {'1': 'time_zone', '3': 3, '4': 1, '5': 9},
    const {'1': 'time_zone_utc_offset', '3': 4, '4': 1, '5': 5},
    const {'1': 'server_url', '3': 5, '4': 1, '5': 9},
    const {'1': 'is_dev_mode', '3': 9, '4': 1, '5': 8, '7': 'false'},
    const {'1': 'lat', '3': 10, '4': 1, '5': 1},
    const {'1': 'lon', '3': 11, '4': 1, '5': 1},
    const {'1': 'alt', '3': 12, '4': 1, '5': 1},
    const {'1': 'dir', '3': 13, '4': 1, '5': 1},
    const {'1': 'speed', '3': 14, '4': 1, '5': 1},
    const {'1': 'geo_error', '3': 15, '4': 1, '5': 5},
  ],
};

const SResponse$json = const {
  '1': 'SResponse',
  '2': const [
    const {'1': 'trx_no', '3': 1, '4': 2, '5': 5},
    const {'1': 'trx_type', '3': 2, '4': 2, '5': 9},
    const {'1': 'client_request_time', '3': 3, '4': 2, '5': 3},
    const {'1': 'client_receipt_time', '3': 4, '4': 1, '5': 3},
    const {'1': 'server_queue_ms', '3': 5, '4': 1, '5': 5},
    const {'1': 'server_duration_ms', '3': 6, '4': 2, '5': 5},
    const {'1': 'remote_ms', '3': 7, '4': 1, '5': 5},
    const {'1': 'is_success', '3': 8, '4': 2, '5': 8},
    const {'1': 'msg', '3': 9, '4': 2, '5': 9},
    const {'1': 'info', '3': 10, '4': 1, '5': 9},
  ],
};

const LoginInfo$json = const {
  '1': 'LoginInfo',
  '2': const [
    const {'1': 'un', '3': 1, '4': 1, '5': 9},
    const {'1': 'pw', '3': 2, '4': 1, '5': 9},
    const {'1': 'sid', '3': 3, '4': 1, '5': 9},
    const {'1': 'tenant', '3': 4, '4': 1, '5': 9},
    const {'1': 'external_key', '3': 5, '4': 1, '5': 9},
    const {'1': 'sso_id', '3': 6, '4': 1, '5': 9},
    const {'1': 'is_rest_or_soap', '3': 7, '4': 1, '5': 8, '7': 'false'},
    const {'1': 'sf_refresh', '3': 9, '4': 1, '5': 9},
    const {'1': 'sf_sid', '3': 10, '4': 1, '5': 9},
    const {'1': 'sf_endpoint', '3': 11, '4': 1, '5': 9},
    const {'1': 'sf_org_id', '3': 12, '4': 1, '5': 9},
    const {'1': 'sf_user_id', '3': 13, '4': 1, '5': 9},
    const {'1': 'sf_un', '3': 14, '4': 1, '5': 9},
    const {'1': 'sf_pw', '3': 15, '4': 1, '5': 9},
    const {'1': 'token', '3': 16, '4': 1, '5': 9},
  ],
};

const Session$json = const {
  '1': 'Session',
  '2': const [
    const {'1': 'sid', '3': 1, '4': 2, '5': 9},
    const {'1': 'soap_url', '3': 2, '4': 1, '5': 9},
    const {'1': 'description', '3': 3, '4': 1, '5': 9},
    const {'1': 'locale', '3': 4, '4': 1, '5': 9},
    const {'1': 'language_iso_code', '3': 5, '4': 1, '5': 9},
    const {'1': 'currency_iso_code', '3': 6, '4': 1, '5': 9},
    const {'1': 'date_format_long', '3': 7, '4': 1, '5': 9},
    const {'1': 'date_format_short', '3': 8, '4': 1, '5': 9},
    const {'1': 'time_format_long', '3': 9, '4': 1, '5': 9},
    const {'1': 'time_format_short', '3': 10, '4': 1, '5': 9},
    const {'1': 'is_decimal_point', '3': 11, '4': 1, '5': 8},
    const {'1': 'time_zone', '3': 12, '4': 1, '5': 9},
    const {'1': 'time_zone_utc_offset', '3': 13, '4': 1, '5': 5},
    const {'1': 'google_analytics', '3': 15, '4': 1, '5': 9},
    const {'1': 'custom_css', '3': 16, '4': 1, '5': 9},
    const {'1': 'tenant_id', '3': 20, '4': 1, '5': 9},
    const {'1': 'tenant_name', '3': 21, '4': 2, '5': 9},
    const {'1': 'tenant_logo', '3': 22, '4': 1, '5': 9},
    const {'1': 'is_tenant_multi_currency', '3': 23, '4': 1, '5': 8, '7': 'false'},
    const {'1': 'is_tenant_system', '3': 24, '4': 1, '5': 8, '7': 'false'},
    const {'1': 'user_id', '3': 25, '4': 1, '5': 9},
    const {'1': 'user_email', '3': 26, '4': 1, '5': 9},
    const {'1': 'user_name', '3': 27, '4': 1, '5': 9},
    const {'1': 'user_full_name', '3': 28, '4': 1, '5': 9},
    const {'1': 'user_resource_id', '3': 29, '4': 1, '5': 9},
    const {'1': 'is_user_expert', '3': 30, '4': 1, '5': 8, '7': 'false'},
    const {'1': 'roles', '3': 31, '4': 3, '5': 11, '6': '.Role'},
    const {'1': 'context', '3': 32, '4': 3, '5': 11, '6': '.DKeyValue'},
    const {'1': 'nr_license', '3': 40, '4': 1, '5': 9},
    const {'1': 'nr_application', '3': 41, '4': 1, '5': 9},
    const {'1': 'sf_endpoint', '3': 45, '4': 1, '5': 9},
    const {'1': 'sf_refresh_token', '3': 46, '4': 1, '5': 9},
    const {'1': 'sf_token', '3': 47, '4': 1, '5': 9},
    const {'1': 'aws_access_key', '3': 50, '4': 1, '5': 9},
    const {'1': 'aws_secret_key', '3': 51, '4': 1, '5': 9},
    const {'1': 'aws_sns_arn_info', '3': 52, '4': 1, '5': 9},
    const {'1': 'aws_sns_arn_warn', '3': 53, '4': 1, '5': 9},
  ],
};

const Role$json = const {
  '1': 'Role',
  '2': const [
    const {'1': 'role_id', '3': 1, '4': 1, '5': 9},
    const {'1': 'tenant_id', '3': 2, '4': 1, '5': 9},
    const {'1': 'name', '3': 3, '4': 1, '5': 9},
    const {'1': 'label', '3': 4, '4': 1, '5': 9},
    const {'1': 'is_administrator', '3': 5, '4': 1, '5': 8, '7': 'false'},
  ],
};

const DValueDisplay$json = const {
  '1': 'DValueDisplay',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9},
    const {'1': 'value', '3': 2, '4': 2, '5': 9},
    const {'1': 'display', '3': 3, '4': 1, '5': 9},
  ],
};

const DKeyValue$json = const {
  '1': 'DKeyValue',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9},
    const {'1': 'key', '3': 2, '4': 2, '5': 9},
    const {'1': 'value', '3': 3, '4': 1, '5': 9},
  ],
};

