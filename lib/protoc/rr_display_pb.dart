///
//  Generated code. Do not modify.
///
library protoc.rr_display;

import 'package:protobuf/protobuf.dart';
import 'rr_pb.dart';
import 'display_pb.dart';
import 'structure_pb.dart';

class DisplayRequestType extends ProtobufEnum {
  static const DisplayRequestType LIST = const DisplayRequestType._(1, 'LIST');
  static const DisplayRequestType GET = const DisplayRequestType._(2, 'GET');
  static const DisplayRequestType UPDATE = const DisplayRequestType._(3, 'UPDATE');

  static const List<DisplayRequestType> values = const <DisplayRequestType> [
    LIST,
    GET,
    UPDATE,
  ];

  static final Map<int, dynamic> _byValue = ProtobufEnum.initByValue(values);
  static DisplayRequestType valueOf(int value) => _byValue[value] as DisplayRequestType;
  static void $checkItem(DisplayRequestType v) {
    if (v is !DisplayRequestType) checkItemFailed(v, 'DisplayRequestType');
  }

  const DisplayRequestType._(int v, String n) : super(v, n);
}

class DisplayRequest extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DisplayRequest')
    ..a/*<CRequest>*/(1, 'request', PbFieldType.QM, CRequest.getDefault, CRequest.create)
    ..e/*<DisplayRequestType>*/(5, 'type', PbFieldType.QE, DisplayRequestType.GET, DisplayRequestType.valueOf)
    ..a/*<String>*/(6, 'listPattern', PbFieldType.OS)
    ..a/*<bool>*/(7, 'isNoCache', PbFieldType.OB)
    ..pp/*<UIInfo>*/(10, 'display', PbFieldType.PM, UIInfo.$checkItem, UIInfo.create)
    ..pp/*<UI>*/(14, 'updatedUi', PbFieldType.PM, UI.$checkItem, UI.create)
    ..a/*<String>*/(15, 'uiId', PbFieldType.OS)
    ..a/*<String>*/(16, 'updatedLabel', PbFieldType.OS)
    ..a/*<String>*/(17, 'updatedTenantId', PbFieldType.OS)
    ..a/*<String>*/(18, 'updatedRoleId', PbFieldType.OS)
    ..a/*<String>*/(19, 'updatedUserId', PbFieldType.OS)
    ..a/*<String>*/(20, 'uiUpdateFlag', PbFieldType.OS)
    ..pp/*<UIGridColumn>*/(30, 'updatedGridColumn', PbFieldType.PM, UIGridColumn.$checkItem, UIGridColumn.create)
    ..pp/*<UIPanel>*/(31, 'updatedPanel', PbFieldType.PM, UIPanel.$checkItem, UIPanel.create)
    ..pp/*<UIProcess>*/(32, 'updatedProcess', PbFieldType.PM, UIProcess.$checkItem, UIProcess.create)
    ..pp/*<UILink>*/(33, 'updatedLink', PbFieldType.PM, UILink.$checkItem, UILink.create)
    ..pp/*<UIQueryColumn>*/(34, 'updatedQueryColumn', PbFieldType.PM, UIQueryColumn.$checkItem, UIQueryColumn.create)
  ;

  DisplayRequest() : super();
  DisplayRequest.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DisplayRequest.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DisplayRequest clone() => new DisplayRequest()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DisplayRequest create() => new DisplayRequest();
  static PbList<DisplayRequest> createRepeated() => new PbList<DisplayRequest>();
  static DisplayRequest getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyDisplayRequest();
    return _defaultInstance;
  }
  static DisplayRequest _defaultInstance;
  static void $checkItem(DisplayRequest v) {
    if (v is !DisplayRequest) checkItemFailed(v, 'DisplayRequest');
  }

  CRequest get request => $_get(0, 1, null);
  void set request(CRequest v) { setField(1, v); }
  bool hasRequest() => $_has(0, 1);
  void clearRequest() => clearField(1);

  DisplayRequestType get type => $_get(1, 5, null);
  void set type(DisplayRequestType v) { setField(5, v); }
  bool hasType() => $_has(1, 5);
  void clearType() => clearField(5);

  String get listPattern => $_get(2, 6, '');
  void set listPattern(String v) { $_setString(2, 6, v); }
  bool hasListPattern() => $_has(2, 6);
  void clearListPattern() => clearField(6);

  bool get isNoCache => $_get(3, 7, false);
  void set isNoCache(bool v) { $_setBool(3, 7, v); }
  bool hasIsNoCache() => $_has(3, 7);
  void clearIsNoCache() => clearField(7);

  List<UIInfo> get displayList => $_get(4, 10, null);

  List<UI> get updatedUiList => $_get(5, 14, null);

  String get uiId => $_get(6, 15, '');
  void set uiId(String v) { $_setString(6, 15, v); }
  bool hasUiId() => $_has(6, 15);
  void clearUiId() => clearField(15);

  String get updatedLabel => $_get(7, 16, '');
  void set updatedLabel(String v) { $_setString(7, 16, v); }
  bool hasUpdatedLabel() => $_has(7, 16);
  void clearUpdatedLabel() => clearField(16);

  String get updatedTenantId => $_get(8, 17, '');
  void set updatedTenantId(String v) { $_setString(8, 17, v); }
  bool hasUpdatedTenantId() => $_has(8, 17);
  void clearUpdatedTenantId() => clearField(17);

  String get updatedRoleId => $_get(9, 18, '');
  void set updatedRoleId(String v) { $_setString(9, 18, v); }
  bool hasUpdatedRoleId() => $_has(9, 18);
  void clearUpdatedRoleId() => clearField(18);

  String get updatedUserId => $_get(10, 19, '');
  void set updatedUserId(String v) { $_setString(10, 19, v); }
  bool hasUpdatedUserId() => $_has(10, 19);
  void clearUpdatedUserId() => clearField(19);

  String get uiUpdateFlag => $_get(11, 20, '');
  void set uiUpdateFlag(String v) { $_setString(11, 20, v); }
  bool hasUiUpdateFlag() => $_has(11, 20);
  void clearUiUpdateFlag() => clearField(20);

  List<UIGridColumn> get updatedGridColumnList => $_get(12, 30, null);

  List<UIPanel> get updatedPanelList => $_get(13, 31, null);

  List<UIProcess> get updatedProcessList => $_get(14, 32, null);

  List<UILink> get updatedLinkList => $_get(15, 33, null);

  List<UIQueryColumn> get updatedQueryColumnList => $_get(16, 34, null);
}

class _ReadonlyDisplayRequest extends DisplayRequest with ReadonlyMessageMixin {}

class DisplayResponse extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DisplayResponse')
    ..a/*<SResponse>*/(1, 'response', PbFieldType.QM, SResponse.getDefault, SResponse.create)
    ..pp/*<UI>*/(10, 'ui', PbFieldType.PM, UI.$checkItem, UI.create)
    ..pp/*<DTable>*/(11, 'table', PbFieldType.PM, DTable.$checkItem, DTable.create)
    ..pp/*<UIInfo>*/(12, 'display', PbFieldType.PM, UIInfo.$checkItem, UIInfo.create)
  ;

  DisplayResponse() : super();
  DisplayResponse.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DisplayResponse.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DisplayResponse clone() => new DisplayResponse()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DisplayResponse create() => new DisplayResponse();
  static PbList<DisplayResponse> createRepeated() => new PbList<DisplayResponse>();
  static DisplayResponse getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyDisplayResponse();
    return _defaultInstance;
  }
  static DisplayResponse _defaultInstance;
  static void $checkItem(DisplayResponse v) {
    if (v is !DisplayResponse) checkItemFailed(v, 'DisplayResponse');
  }

  SResponse get response => $_get(0, 1, null);
  void set response(SResponse v) { setField(1, v); }
  bool hasResponse() => $_has(0, 1);
  void clearResponse() => clearField(1);

  List<UI> get uiList => $_get(1, 10, null);

  List<DTable> get tableList => $_get(2, 11, null);

  List<UIInfo> get displayList => $_get(3, 12, null);
}

class _ReadonlyDisplayResponse extends DisplayResponse with ReadonlyMessageMixin {}

const DisplayRequestType$json = const {
  '1': 'DisplayRequestType',
  '2': const [
    const {'1': 'LIST', '2': 1},
    const {'1': 'GET', '2': 2},
    const {'1': 'UPDATE', '2': 3},
  ],
};

const DisplayRequest$json = const {
  '1': 'DisplayRequest',
  '2': const [
    const {'1': 'request', '3': 1, '4': 2, '5': 11, '6': '.CRequest'},
    const {'1': 'type', '3': 5, '4': 2, '5': 14, '6': '.DisplayRequestType', '7': 'GET'},
    const {'1': 'list_pattern', '3': 6, '4': 1, '5': 9},
    const {'1': 'is_no_cache', '3': 7, '4': 1, '5': 8, '7': 'false'},
    const {'1': 'display', '3': 10, '4': 3, '5': 11, '6': '.UIInfo'},
    const {'1': 'updated_ui', '3': 14, '4': 3, '5': 11, '6': '.UI'},
    const {'1': 'ui_id', '3': 15, '4': 1, '5': 9},
    const {'1': 'updated_label', '3': 16, '4': 1, '5': 9},
    const {'1': 'updated_tenant_id', '3': 17, '4': 1, '5': 9},
    const {'1': 'updated_role_id', '3': 18, '4': 1, '5': 9},
    const {'1': 'updated_user_id', '3': 19, '4': 1, '5': 9},
    const {'1': 'ui_update_flag', '3': 20, '4': 1, '5': 9},
    const {'1': 'updated_grid_column', '3': 30, '4': 3, '5': 11, '6': '.UIGridColumn'},
    const {'1': 'updated_panel', '3': 31, '4': 3, '5': 11, '6': '.UIPanel'},
    const {'1': 'updated_process', '3': 32, '4': 3, '5': 11, '6': '.UIProcess'},
    const {'1': 'updated_link', '3': 33, '4': 3, '5': 11, '6': '.UILink'},
    const {'1': 'updated_query_column', '3': 34, '4': 3, '5': 11, '6': '.UIQueryColumn'},
  ],
};

const DisplayResponse$json = const {
  '1': 'DisplayResponse',
  '2': const [
    const {'1': 'response', '3': 1, '4': 2, '5': 11, '6': '.SResponse'},
    const {'1': 'ui', '3': 10, '4': 3, '5': 11, '6': '.UI'},
    const {'1': 'table', '3': 11, '4': 3, '5': 11, '6': '.DTable'},
    const {'1': 'display', '3': 12, '4': 3, '5': 11, '6': '.UIInfo'},
  ],
};

