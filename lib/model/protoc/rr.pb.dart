///
//  Generated code. Do not modify.
///
library rr;

import 'package:protobuf/protobuf.dart';
import 'package:fixnum/fixnum.dart';

class CRequest extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('CRequest')
    ..a(1, 'trxNo', GeneratedMessage.Q3)
    ..a(2, 'trxType', GeneratedMessage.QS)
    ..a(3, 'clientRequestTime', GeneratedMessage.Q6, Int64.ZERO)
    ..a(5, 'sid', GeneratedMessage.OS)
    ..a(6, 'info', GeneratedMessage.OS)
    ..a(7, 'env', GeneratedMessage.OM, CEnv.create, CEnv.create)
    ..a(8, 'clientId', GeneratedMessage.OS)
    ..a(10, 'sfEndpoint', GeneratedMessage.OS)
    ..a(11, 'sfToken', GeneratedMessage.OS)
  ;

  CRequest() : super();
  CRequest.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CRequest.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CRequest clone() => new CRequest()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static CRequest create() => new CRequest();
  static PbList<CRequest> createRepeated() => new PbList<CRequest>();

  int get trxNo => getField(1);
  void set trxNo(int v) { setField(1, v); }
  bool hasTrxNo() => hasField(1);
  void clearTrxNo() => clearField(1);

  String get trxType => getField(2);
  void set trxType(String v) { setField(2, v); }
  bool hasTrxType() => hasField(2);
  void clearTrxType() => clearField(2);

  Int64 get clientRequestTime => getField(3);
  void set clientRequestTime(Int64 v) { setField(3, v); }
  bool hasClientRequestTime() => hasField(3);
  void clearClientRequestTime() => clearField(3);

  String get sid => getField(5);
  void set sid(String v) { setField(5, v); }
  bool hasSid() => hasField(5);
  void clearSid() => clearField(5);

  String get info => getField(6);
  void set info(String v) { setField(6, v); }
  bool hasInfo() => hasField(6);
  void clearInfo() => clearField(6);

  CEnv get env => getField(7);
  void set env(CEnv v) { setField(7, v); }
  bool hasEnv() => hasField(7);
  void clearEnv() => clearField(7);

  String get clientId => getField(8);
  void set clientId(String v) { setField(8, v); }
  bool hasClientId() => hasField(8);
  void clearClientId() => clearField(8);

  String get sfEndpoint => getField(10);
  void set sfEndpoint(String v) { setField(10, v); }
  bool hasSfEndpoint() => hasField(10);
  void clearSfEndpoint() => clearField(10);

  String get sfToken => getField(11);
  void set sfToken(String v) { setField(11, v); }
  bool hasSfToken() => hasField(11);
  void clearSfToken() => clearField(11);
}

class CEnv extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('CEnv')
    ..a(1, 'clientUrl', GeneratedMessage.OS)
    ..a(2, 'locale', GeneratedMessage.OS)
    ..a(3, 'timeZone', GeneratedMessage.OS)
    ..a(4, 'timeZoneUtcOffset', GeneratedMessage.O3)
    ..a(5, 'serverUrl', GeneratedMessage.OS)
    ..a(9, 'isDevMode', GeneratedMessage.OB)
    ..a(10, 'lat', GeneratedMessage.OD)
    ..a(11, 'lon', GeneratedMessage.OD)
    ..a(12, 'alt', GeneratedMessage.OD)
    ..a(13, 'dir', GeneratedMessage.OD)
    ..a(14, 'speed', GeneratedMessage.OD)
    ..a(15, 'geoError', GeneratedMessage.O3)
    ..hasRequiredFields = false
  ;

  CEnv() : super();
  CEnv.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CEnv.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CEnv clone() => new CEnv()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static CEnv create() => new CEnv();
  static PbList<CEnv> createRepeated() => new PbList<CEnv>();

  String get clientUrl => getField(1);
  void set clientUrl(String v) { setField(1, v); }
  bool hasClientUrl() => hasField(1);
  void clearClientUrl() => clearField(1);

  String get locale => getField(2);
  void set locale(String v) { setField(2, v); }
  bool hasLocale() => hasField(2);
  void clearLocale() => clearField(2);

  String get timeZone => getField(3);
  void set timeZone(String v) { setField(3, v); }
  bool hasTimeZone() => hasField(3);
  void clearTimeZone() => clearField(3);

  int get timeZoneUtcOffset => getField(4);
  void set timeZoneUtcOffset(int v) { setField(4, v); }
  bool hasTimeZoneUtcOffset() => hasField(4);
  void clearTimeZoneUtcOffset() => clearField(4);

  String get serverUrl => getField(5);
  void set serverUrl(String v) { setField(5, v); }
  bool hasServerUrl() => hasField(5);
  void clearServerUrl() => clearField(5);

  bool get isDevMode => getField(9);
  void set isDevMode(bool v) { setField(9, v); }
  bool hasIsDevMode() => hasField(9);
  void clearIsDevMode() => clearField(9);

  double get lat => getField(10);
  void set lat(double v) { setField(10, v); }
  bool hasLat() => hasField(10);
  void clearLat() => clearField(10);

  double get lon => getField(11);
  void set lon(double v) { setField(11, v); }
  bool hasLon() => hasField(11);
  void clearLon() => clearField(11);

  double get alt => getField(12);
  void set alt(double v) { setField(12, v); }
  bool hasAlt() => hasField(12);
  void clearAlt() => clearField(12);

  double get dir => getField(13);
  void set dir(double v) { setField(13, v); }
  bool hasDir() => hasField(13);
  void clearDir() => clearField(13);

  double get speed => getField(14);
  void set speed(double v) { setField(14, v); }
  bool hasSpeed() => hasField(14);
  void clearSpeed() => clearField(14);

  int get geoError => getField(15);
  void set geoError(int v) { setField(15, v); }
  bool hasGeoError() => hasField(15);
  void clearGeoError() => clearField(15);
}

class SResponse extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('SResponse')
    ..a(1, 'trxNo', GeneratedMessage.Q3)
    ..a(2, 'trxType', GeneratedMessage.QS)
    ..a(3, 'clientRequestTime', GeneratedMessage.Q6, Int64.ZERO)
    ..a(4, 'clientReceiptTime', GeneratedMessage.O6, Int64.ZERO)
    ..a(5, 'serverQueueMs', GeneratedMessage.O3)
    ..a(6, 'serverDurationMs', GeneratedMessage.Q3)
    ..a(7, 'remoteMs', GeneratedMessage.O3)
    ..a(8, 'isSuccess', GeneratedMessage.QB)
    ..a(9, 'msg', GeneratedMessage.QS)
    ..a(10, 'info', GeneratedMessage.OS)
  ;

  SResponse() : super();
  SResponse.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  SResponse.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  SResponse clone() => new SResponse()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static SResponse create() => new SResponse();
  static PbList<SResponse> createRepeated() => new PbList<SResponse>();

  int get trxNo => getField(1);
  void set trxNo(int v) { setField(1, v); }
  bool hasTrxNo() => hasField(1);
  void clearTrxNo() => clearField(1);

  String get trxType => getField(2);
  void set trxType(String v) { setField(2, v); }
  bool hasTrxType() => hasField(2);
  void clearTrxType() => clearField(2);

  Int64 get clientRequestTime => getField(3);
  void set clientRequestTime(Int64 v) { setField(3, v); }
  bool hasClientRequestTime() => hasField(3);
  void clearClientRequestTime() => clearField(3);

  Int64 get clientReceiptTime => getField(4);
  void set clientReceiptTime(Int64 v) { setField(4, v); }
  bool hasClientReceiptTime() => hasField(4);
  void clearClientReceiptTime() => clearField(4);

  int get serverQueueMs => getField(5);
  void set serverQueueMs(int v) { setField(5, v); }
  bool hasServerQueueMs() => hasField(5);
  void clearServerQueueMs() => clearField(5);

  int get serverDurationMs => getField(6);
  void set serverDurationMs(int v) { setField(6, v); }
  bool hasServerDurationMs() => hasField(6);
  void clearServerDurationMs() => clearField(6);

  int get remoteMs => getField(7);
  void set remoteMs(int v) { setField(7, v); }
  bool hasRemoteMs() => hasField(7);
  void clearRemoteMs() => clearField(7);

  bool get isSuccess => getField(8);
  void set isSuccess(bool v) { setField(8, v); }
  bool hasIsSuccess() => hasField(8);
  void clearIsSuccess() => clearField(8);

  String get msg => getField(9);
  void set msg(String v) { setField(9, v); }
  bool hasMsg() => hasField(9);
  void clearMsg() => clearField(9);

  String get info => getField(10);
  void set info(String v) { setField(10, v); }
  bool hasInfo() => hasField(10);
  void clearInfo() => clearField(10);
}

class LoginInfo extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('LoginInfo')
    ..a(1, 'un', GeneratedMessage.OS)
    ..a(2, 'pw', GeneratedMessage.OS)
    ..a(3, 'sid', GeneratedMessage.OS)
    ..a(4, 'tenant', GeneratedMessage.OS)
    ..a(5, 'externalKey', GeneratedMessage.OS)
    ..a(6, 'ssoId', GeneratedMessage.OS)
    ..a(7, 'isRestOrSoap', GeneratedMessage.OB)
    ..a(10, 'sfSid', GeneratedMessage.OS)
    ..a(11, 'sfEndpoint', GeneratedMessage.OS)
    ..a(12, 'sfOrgId', GeneratedMessage.OS)
    ..a(13, 'sfUserId', GeneratedMessage.OS)
    ..a(14, 'sfUn', GeneratedMessage.OS)
    ..a(15, 'sfPw', GeneratedMessage.OS)
    ..a(16, 'token', GeneratedMessage.OS)
    ..hasRequiredFields = false
  ;

  LoginInfo() : super();
  LoginInfo.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  LoginInfo.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  LoginInfo clone() => new LoginInfo()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static LoginInfo create() => new LoginInfo();
  static PbList<LoginInfo> createRepeated() => new PbList<LoginInfo>();

  String get un => getField(1);
  void set un(String v) { setField(1, v); }
  bool hasUn() => hasField(1);
  void clearUn() => clearField(1);

  String get pw => getField(2);
  void set pw(String v) { setField(2, v); }
  bool hasPw() => hasField(2);
  void clearPw() => clearField(2);

  String get sid => getField(3);
  void set sid(String v) { setField(3, v); }
  bool hasSid() => hasField(3);
  void clearSid() => clearField(3);

  String get tenant => getField(4);
  void set tenant(String v) { setField(4, v); }
  bool hasTenant() => hasField(4);
  void clearTenant() => clearField(4);

  String get externalKey => getField(5);
  void set externalKey(String v) { setField(5, v); }
  bool hasExternalKey() => hasField(5);
  void clearExternalKey() => clearField(5);

  String get ssoId => getField(6);
  void set ssoId(String v) { setField(6, v); }
  bool hasSsoId() => hasField(6);
  void clearSsoId() => clearField(6);

  bool get isRestOrSoap => getField(7);
  void set isRestOrSoap(bool v) { setField(7, v); }
  bool hasIsRestOrSoap() => hasField(7);
  void clearIsRestOrSoap() => clearField(7);

  String get sfSid => getField(10);
  void set sfSid(String v) { setField(10, v); }
  bool hasSfSid() => hasField(10);
  void clearSfSid() => clearField(10);

  String get sfEndpoint => getField(11);
  void set sfEndpoint(String v) { setField(11, v); }
  bool hasSfEndpoint() => hasField(11);
  void clearSfEndpoint() => clearField(11);

  String get sfOrgId => getField(12);
  void set sfOrgId(String v) { setField(12, v); }
  bool hasSfOrgId() => hasField(12);
  void clearSfOrgId() => clearField(12);

  String get sfUserId => getField(13);
  void set sfUserId(String v) { setField(13, v); }
  bool hasSfUserId() => hasField(13);
  void clearSfUserId() => clearField(13);

  String get sfUn => getField(14);
  void set sfUn(String v) { setField(14, v); }
  bool hasSfUn() => hasField(14);
  void clearSfUn() => clearField(14);

  String get sfPw => getField(15);
  void set sfPw(String v) { setField(15, v); }
  bool hasSfPw() => hasField(15);
  void clearSfPw() => clearField(15);

  String get token => getField(16);
  void set token(String v) { setField(16, v); }
  bool hasToken() => hasField(16);
  void clearToken() => clearField(16);
}

class Session extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('Session')
    ..a(1, 'sid', GeneratedMessage.QS)
    ..a(2, 'soapUrl', GeneratedMessage.OS)
    ..a(3, 'description', GeneratedMessage.OS)
    ..a(4, 'locale', GeneratedMessage.OS)
    ..a(5, 'languageIsoCode', GeneratedMessage.OS)
    ..a(6, 'currencyIsoCode', GeneratedMessage.OS)
    ..a(7, 'dateFormatLong', GeneratedMessage.OS)
    ..a(8, 'dateFormatShort', GeneratedMessage.OS)
    ..a(9, 'timeFormatLong', GeneratedMessage.OS)
    ..a(10, 'timeFormatShort', GeneratedMessage.OS)
    ..a(11, 'isDecimalPoint', GeneratedMessage.OB)
    ..a(12, 'timeZone', GeneratedMessage.OS)
    ..a(13, 'timeZoneUtcOffset', GeneratedMessage.O3)
    ..a(15, 'googleAnalytics', GeneratedMessage.OS)
    ..a(16, 'customCss', GeneratedMessage.OS)
    ..a(20, 'tenantId', GeneratedMessage.OS)
    ..a(21, 'tenantName', GeneratedMessage.QS)
    ..a(22, 'tenantLogo', GeneratedMessage.OS)
    ..a(23, 'isTenantMultiCurrency', GeneratedMessage.OB)
    ..a(24, 'isTenantSystem', GeneratedMessage.OB)
    ..a(25, 'userId', GeneratedMessage.OS)
    ..a(26, 'userEmail', GeneratedMessage.OS)
    ..a(27, 'userName', GeneratedMessage.OS)
    ..a(28, 'userFullName', GeneratedMessage.OS)
    ..a(29, 'userResourceId', GeneratedMessage.OS)
    ..a(30, 'isUserExpert', GeneratedMessage.OB)
    ..m(31, 'roles', Role.create, Role.createRepeated)
    ..m(32, 'context', DKeyValue.create, DKeyValue.createRepeated)
    ..a(40, 'nrLicense', GeneratedMessage.OS)
    ..a(41, 'nrApplication', GeneratedMessage.OS)
    ..a(45, 'sfEndpoint', GeneratedMessage.OS)
    ..a(46, 'sfRefreshToken', GeneratedMessage.OS)
    ..a(47, 'sfToken', GeneratedMessage.OS)
    ..a(50, 'awsAccessKey', GeneratedMessage.OS)
    ..a(51, 'awsSecretKey', GeneratedMessage.OS)
    ..a(52, 'awsSnsArnInfo', GeneratedMessage.OS)
    ..a(53, 'awsSnsArnWarn', GeneratedMessage.OS)
  ;

  Session() : super();
  Session.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Session.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Session clone() => new Session()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static Session create() => new Session();
  static PbList<Session> createRepeated() => new PbList<Session>();

  String get sid => getField(1);
  void set sid(String v) { setField(1, v); }
  bool hasSid() => hasField(1);
  void clearSid() => clearField(1);

  String get soapUrl => getField(2);
  void set soapUrl(String v) { setField(2, v); }
  bool hasSoapUrl() => hasField(2);
  void clearSoapUrl() => clearField(2);

  String get description => getField(3);
  void set description(String v) { setField(3, v); }
  bool hasDescription() => hasField(3);
  void clearDescription() => clearField(3);

  String get locale => getField(4);
  void set locale(String v) { setField(4, v); }
  bool hasLocale() => hasField(4);
  void clearLocale() => clearField(4);

  String get languageIsoCode => getField(5);
  void set languageIsoCode(String v) { setField(5, v); }
  bool hasLanguageIsoCode() => hasField(5);
  void clearLanguageIsoCode() => clearField(5);

  String get currencyIsoCode => getField(6);
  void set currencyIsoCode(String v) { setField(6, v); }
  bool hasCurrencyIsoCode() => hasField(6);
  void clearCurrencyIsoCode() => clearField(6);

  String get dateFormatLong => getField(7);
  void set dateFormatLong(String v) { setField(7, v); }
  bool hasDateFormatLong() => hasField(7);
  void clearDateFormatLong() => clearField(7);

  String get dateFormatShort => getField(8);
  void set dateFormatShort(String v) { setField(8, v); }
  bool hasDateFormatShort() => hasField(8);
  void clearDateFormatShort() => clearField(8);

  String get timeFormatLong => getField(9);
  void set timeFormatLong(String v) { setField(9, v); }
  bool hasTimeFormatLong() => hasField(9);
  void clearTimeFormatLong() => clearField(9);

  String get timeFormatShort => getField(10);
  void set timeFormatShort(String v) { setField(10, v); }
  bool hasTimeFormatShort() => hasField(10);
  void clearTimeFormatShort() => clearField(10);

  bool get isDecimalPoint => getField(11);
  void set isDecimalPoint(bool v) { setField(11, v); }
  bool hasIsDecimalPoint() => hasField(11);
  void clearIsDecimalPoint() => clearField(11);

  String get timeZone => getField(12);
  void set timeZone(String v) { setField(12, v); }
  bool hasTimeZone() => hasField(12);
  void clearTimeZone() => clearField(12);

  int get timeZoneUtcOffset => getField(13);
  void set timeZoneUtcOffset(int v) { setField(13, v); }
  bool hasTimeZoneUtcOffset() => hasField(13);
  void clearTimeZoneUtcOffset() => clearField(13);

  String get googleAnalytics => getField(15);
  void set googleAnalytics(String v) { setField(15, v); }
  bool hasGoogleAnalytics() => hasField(15);
  void clearGoogleAnalytics() => clearField(15);

  String get customCss => getField(16);
  void set customCss(String v) { setField(16, v); }
  bool hasCustomCss() => hasField(16);
  void clearCustomCss() => clearField(16);

  String get tenantId => getField(20);
  void set tenantId(String v) { setField(20, v); }
  bool hasTenantId() => hasField(20);
  void clearTenantId() => clearField(20);

  String get tenantName => getField(21);
  void set tenantName(String v) { setField(21, v); }
  bool hasTenantName() => hasField(21);
  void clearTenantName() => clearField(21);

  String get tenantLogo => getField(22);
  void set tenantLogo(String v) { setField(22, v); }
  bool hasTenantLogo() => hasField(22);
  void clearTenantLogo() => clearField(22);

  bool get isTenantMultiCurrency => getField(23);
  void set isTenantMultiCurrency(bool v) { setField(23, v); }
  bool hasIsTenantMultiCurrency() => hasField(23);
  void clearIsTenantMultiCurrency() => clearField(23);

  bool get isTenantSystem => getField(24);
  void set isTenantSystem(bool v) { setField(24, v); }
  bool hasIsTenantSystem() => hasField(24);
  void clearIsTenantSystem() => clearField(24);

  String get userId => getField(25);
  void set userId(String v) { setField(25, v); }
  bool hasUserId() => hasField(25);
  void clearUserId() => clearField(25);

  String get userEmail => getField(26);
  void set userEmail(String v) { setField(26, v); }
  bool hasUserEmail() => hasField(26);
  void clearUserEmail() => clearField(26);

  String get userName => getField(27);
  void set userName(String v) { setField(27, v); }
  bool hasUserName() => hasField(27);
  void clearUserName() => clearField(27);

  String get userFullName => getField(28);
  void set userFullName(String v) { setField(28, v); }
  bool hasUserFullName() => hasField(28);
  void clearUserFullName() => clearField(28);

  String get userResourceId => getField(29);
  void set userResourceId(String v) { setField(29, v); }
  bool hasUserResourceId() => hasField(29);
  void clearUserResourceId() => clearField(29);

  bool get isUserExpert => getField(30);
  void set isUserExpert(bool v) { setField(30, v); }
  bool hasIsUserExpert() => hasField(30);
  void clearIsUserExpert() => clearField(30);

  List<Role> get rolesList => getField(31);

  List<DKeyValue> get contextList => getField(32);

  String get nrLicense => getField(40);
  void set nrLicense(String v) { setField(40, v); }
  bool hasNrLicense() => hasField(40);
  void clearNrLicense() => clearField(40);

  String get nrApplication => getField(41);
  void set nrApplication(String v) { setField(41, v); }
  bool hasNrApplication() => hasField(41);
  void clearNrApplication() => clearField(41);

  String get sfEndpoint => getField(45);
  void set sfEndpoint(String v) { setField(45, v); }
  bool hasSfEndpoint() => hasField(45);
  void clearSfEndpoint() => clearField(45);

  String get sfRefreshToken => getField(46);
  void set sfRefreshToken(String v) { setField(46, v); }
  bool hasSfRefreshToken() => hasField(46);
  void clearSfRefreshToken() => clearField(46);

  String get sfToken => getField(47);
  void set sfToken(String v) { setField(47, v); }
  bool hasSfToken() => hasField(47);
  void clearSfToken() => clearField(47);

  String get awsAccessKey => getField(50);
  void set awsAccessKey(String v) { setField(50, v); }
  bool hasAwsAccessKey() => hasField(50);
  void clearAwsAccessKey() => clearField(50);

  String get awsSecretKey => getField(51);
  void set awsSecretKey(String v) { setField(51, v); }
  bool hasAwsSecretKey() => hasField(51);
  void clearAwsSecretKey() => clearField(51);

  String get awsSnsArnInfo => getField(52);
  void set awsSnsArnInfo(String v) { setField(52, v); }
  bool hasAwsSnsArnInfo() => hasField(52);
  void clearAwsSnsArnInfo() => clearField(52);

  String get awsSnsArnWarn => getField(53);
  void set awsSnsArnWarn(String v) { setField(53, v); }
  bool hasAwsSnsArnWarn() => hasField(53);
  void clearAwsSnsArnWarn() => clearField(53);
}

class Role extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('Role')
    ..a(1, 'roleId', GeneratedMessage.OS)
    ..a(2, 'tenantId', GeneratedMessage.OS)
    ..a(3, 'name', GeneratedMessage.OS)
    ..a(4, 'label', GeneratedMessage.OS)
    ..a(5, 'isAdministrator', GeneratedMessage.OB)
    ..hasRequiredFields = false
  ;

  Role() : super();
  Role.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Role.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Role clone() => new Role()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static Role create() => new Role();
  static PbList<Role> createRepeated() => new PbList<Role>();

  String get roleId => getField(1);
  void set roleId(String v) { setField(1, v); }
  bool hasRoleId() => hasField(1);
  void clearRoleId() => clearField(1);

  String get tenantId => getField(2);
  void set tenantId(String v) { setField(2, v); }
  bool hasTenantId() => hasField(2);
  void clearTenantId() => clearField(2);

  String get name => getField(3);
  void set name(String v) { setField(3, v); }
  bool hasName() => hasField(3);
  void clearName() => clearField(3);

  String get label => getField(4);
  void set label(String v) { setField(4, v); }
  bool hasLabel() => hasField(4);
  void clearLabel() => clearField(4);

  bool get isAdministrator => getField(5);
  void set isAdministrator(bool v) { setField(5, v); }
  bool hasIsAdministrator() => hasField(5);
  void clearIsAdministrator() => clearField(5);
}

class DValueDisplay extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DValueDisplay')
    ..a(1, 'id', GeneratedMessage.OS)
    ..a(2, 'value', GeneratedMessage.QS)
    ..a(3, 'display', GeneratedMessage.OS)
  ;

  DValueDisplay() : super();
  DValueDisplay.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DValueDisplay.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DValueDisplay clone() => new DValueDisplay()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DValueDisplay create() => new DValueDisplay();
  static PbList<DValueDisplay> createRepeated() => new PbList<DValueDisplay>();

  String get id => getField(1);
  void set id(String v) { setField(1, v); }
  bool hasId() => hasField(1);
  void clearId() => clearField(1);

  String get value => getField(2);
  void set value(String v) { setField(2, v); }
  bool hasValue() => hasField(2);
  void clearValue() => clearField(2);

  String get display => getField(3);
  void set display(String v) { setField(3, v); }
  bool hasDisplay() => hasField(3);
  void clearDisplay() => clearField(3);
}

class DKeyValue extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DKeyValue')
    ..a(1, 'id', GeneratedMessage.OS)
    ..a(2, 'key', GeneratedMessage.QS)
    ..a(3, 'value', GeneratedMessage.OS)
  ;

  DKeyValue() : super();
  DKeyValue.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DKeyValue.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DKeyValue clone() => new DKeyValue()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DKeyValue create() => new DKeyValue();
  static PbList<DKeyValue> createRepeated() => new PbList<DKeyValue>();

  String get id => getField(1);
  void set id(String v) { setField(1, v); }
  bool hasId() => hasField(1);
  void clearId() => clearField(1);

  String get key => getField(2);
  void set key(String v) { setField(2, v); }
  bool hasKey() => hasField(2);
  void clearKey() => clearField(2);

  String get value => getField(3);
  void set value(String v) { setField(3, v); }
  bool hasValue() => hasField(3);
  void clearValue() => clearField(3);
}

