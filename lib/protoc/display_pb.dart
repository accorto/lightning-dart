/**
 * Generated Protocol Buffers code. Do not modify.
 */
library protoc.display;

import 'package:protobuf/protobuf.dart';
import 'structure_pb.dart';
import 'data_pb.dart';

class UILabelPosition extends ProtobufEnum {
  static const UILabelPosition LEFT = const UILabelPosition._(1, 'LEFT');
  static const UILabelPosition RIGHT = const UILabelPosition._(2, 'RIGHT');
  static const UILabelPosition TOP = const UILabelPosition._(3, 'TOP');
  static const UILabelPosition BOTTOM = const UILabelPosition._(4, 'BOTTOM');
  static const UILabelPosition NONE = const UILabelPosition._(5, 'NONE');

  static const List<UILabelPosition> values = const <UILabelPosition> [
    LEFT,
    RIGHT,
    TOP,
    BOTTOM,
    NONE,
  ];

  static final Map<int, UILabelPosition> _byValue = ProtobufEnum.initByValue(values);
  static UILabelPosition valueOf(int value) => _byValue[value];
  static void $checkItem(UILabelPosition v) {
    if (v is !UILabelPosition) checkItemFailed(v, 'UILabelPosition');
  }

  const UILabelPosition._(int v, String n) : super(v, n);
}

class UIPanelType extends ProtobufEnum {
  static const UIPanelType DISPLAYED = const UIPanelType._(1, 'DISPLAYED');
  static const UIPanelType IOPEN = const UIPanelType._(2, 'IOPEN');
  static const UIPanelType ICLOSED = const UIPanelType._(3, 'ICLOSED');
  static const UIPanelType HIDDEN = const UIPanelType._(4, 'HIDDEN');

  static const List<UIPanelType> values = const <UIPanelType> [
    DISPLAYED,
    IOPEN,
    ICLOSED,
    HIDDEN,
  ];

  static final Map<int, UIPanelType> _byValue = ProtobufEnum.initByValue(values);
  static UIPanelType valueOf(int value) => _byValue[value];
  static void $checkItem(UIPanelType v) {
    if (v is !UIPanelType) checkItemFailed(v, 'UIPanelType');
  }

  const UIPanelType._(int v, String n) : super(v, n);
}

class UI extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('UI')
    ..a(1, 'uiId', PbFieldType.OS)
    ..a(2, 'name', PbFieldType.QS)
    ..a(3, 'label', PbFieldType.OS)
    ..a(4, 'description', PbFieldType.OS)
    ..a(5, 'tenantId', PbFieldType.OS)
    ..a(6, 'roleId', PbFieldType.OS)
    ..a(7, 'userId', PbFieldType.OS)
    ..a(8, 'etag', PbFieldType.OS)
    ..pp(9, 'display', PbFieldType.PM, UIInfo.$checkItem, UIInfo.create)
    ..a(10, 'table', PbFieldType.OM, DTable.getDefault, DTable.create)
    ..a(11, 'tableId', PbFieldType.OS)
    ..a(12, 'tableName', PbFieldType.OS)
    ..a(13, 'externalKey', PbFieldType.OS)
    ..a(15, 'isCanDelete', PbFieldType.OB, true)
    ..a(16, 'isCanInsert', PbFieldType.OB, true)
    ..a(17, 'isReadOnly', PbFieldType.OB)
    ..a(20, 'isDefaultGridMode', PbFieldType.OB, true)
    ..a(21, 'isShowIndicators', PbFieldType.OB)
    ..a(22, 'gridType', PbFieldType.OS)
    ..a(25, 'isShowGraph', PbFieldType.OB, true)
    ..a(26, 'graphType', PbFieldType.OS)
    ..a(27, 'graphWhat', PbFieldType.OS)
    ..a(28, 'graphBy', PbFieldType.OS)
    ..pp(30, 'gridColumn', PbFieldType.PM, UIGridColumn.$checkItem, UIGridColumn.create)
    ..pp(31, 'panel', PbFieldType.PM, UIPanel.$checkItem, UIPanel.create)
    ..pp(32, 'process', PbFieldType.PM, UIProcess.$checkItem, UIProcess.create)
    ..pp(33, 'link', PbFieldType.PM, UILink.$checkItem, UILink.create)
    ..pp(34, 'queryColumn', PbFieldType.PM, UIQueryColumn.$checkItem, UIQueryColumn.create)
    ..pp(35, 'savedQuery', PbFieldType.PM, SavedQuery.$checkItem, SavedQuery.create)
    ..a(40, 'isAlwaysQuery', PbFieldType.OB)
    ..a(41, 'defaultQuery', PbFieldType.OM, SavedQuery.getDefault, SavedQuery.create)
    ..a(44, 'isGridFind', PbFieldType.OB, true)
    ..a(45, 'isIncludeStats', PbFieldType.OB, true)
    ..pp(50, 'filter', PbFieldType.PM, DFilter.$checkItem, DFilter.create)
    ..pp(51, 'sort', PbFieldType.PM, DSort.$checkItem, DSort.create)
  ;

  UI() : super();
  UI.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  UI.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  UI clone() => new UI()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static UI create() => new UI();
  static PbList<UI> createRepeated() => new PbList<UI>();
  static UI getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyUI();
    return _defaultInstance;
  }
  static UI _defaultInstance;
  static void $checkItem(UI v) {
    if (v is !UI) checkItemFailed(v, 'UI');
  }

  String get uiId => $_get(0, 1, '');
  void set uiId(String v) { $_setString(0, 1, v); }
  bool hasUiId() => $_has(0, 1);
  void clearUiId() => clearField(1);

  String get name => $_get(1, 2, '');
  void set name(String v) { $_setString(1, 2, v); }
  bool hasName() => $_has(1, 2);
  void clearName() => clearField(2);

  String get label => $_get(2, 3, '');
  void set label(String v) { $_setString(2, 3, v); }
  bool hasLabel() => $_has(2, 3);
  void clearLabel() => clearField(3);

  String get description => $_get(3, 4, '');
  void set description(String v) { $_setString(3, 4, v); }
  bool hasDescription() => $_has(3, 4);
  void clearDescription() => clearField(4);

  String get tenantId => $_get(4, 5, '');
  void set tenantId(String v) { $_setString(4, 5, v); }
  bool hasTenantId() => $_has(4, 5);
  void clearTenantId() => clearField(5);

  String get roleId => $_get(5, 6, '');
  void set roleId(String v) { $_setString(5, 6, v); }
  bool hasRoleId() => $_has(5, 6);
  void clearRoleId() => clearField(6);

  String get userId => $_get(6, 7, '');
  void set userId(String v) { $_setString(6, 7, v); }
  bool hasUserId() => $_has(6, 7);
  void clearUserId() => clearField(7);

  String get etag => $_get(7, 8, '');
  void set etag(String v) { $_setString(7, 8, v); }
  bool hasEtag() => $_has(7, 8);
  void clearEtag() => clearField(8);

  List<UIInfo> get displayList => $_get(8, 9, null);

  DTable get table => $_get(9, 10, null);
  void set table(DTable v) { setField(10, v); }
  bool hasTable() => $_has(9, 10);
  void clearTable() => clearField(10);

  String get tableId => $_get(10, 11, '');
  void set tableId(String v) { $_setString(10, 11, v); }
  bool hasTableId() => $_has(10, 11);
  void clearTableId() => clearField(11);

  String get tableName => $_get(11, 12, '');
  void set tableName(String v) { $_setString(11, 12, v); }
  bool hasTableName() => $_has(11, 12);
  void clearTableName() => clearField(12);

  String get externalKey => $_get(12, 13, '');
  void set externalKey(String v) { $_setString(12, 13, v); }
  bool hasExternalKey() => $_has(12, 13);
  void clearExternalKey() => clearField(13);

  bool get isCanDelete => $_get(13, 15, true);
  void set isCanDelete(bool v) { $_setBool(13, 15, v); }
  bool hasIsCanDelete() => $_has(13, 15);
  void clearIsCanDelete() => clearField(15);

  bool get isCanInsert => $_get(14, 16, true);
  void set isCanInsert(bool v) { $_setBool(14, 16, v); }
  bool hasIsCanInsert() => $_has(14, 16);
  void clearIsCanInsert() => clearField(16);

  bool get isReadOnly => $_get(15, 17, false);
  void set isReadOnly(bool v) { $_setBool(15, 17, v); }
  bool hasIsReadOnly() => $_has(15, 17);
  void clearIsReadOnly() => clearField(17);

  bool get isDefaultGridMode => $_get(16, 20, true);
  void set isDefaultGridMode(bool v) { $_setBool(16, 20, v); }
  bool hasIsDefaultGridMode() => $_has(16, 20);
  void clearIsDefaultGridMode() => clearField(20);

  bool get isShowIndicators => $_get(17, 21, false);
  void set isShowIndicators(bool v) { $_setBool(17, 21, v); }
  bool hasIsShowIndicators() => $_has(17, 21);
  void clearIsShowIndicators() => clearField(21);

  String get gridType => $_get(18, 22, '');
  void set gridType(String v) { $_setString(18, 22, v); }
  bool hasGridType() => $_has(18, 22);
  void clearGridType() => clearField(22);

  bool get isShowGraph => $_get(19, 25, true);
  void set isShowGraph(bool v) { $_setBool(19, 25, v); }
  bool hasIsShowGraph() => $_has(19, 25);
  void clearIsShowGraph() => clearField(25);

  String get graphType => $_get(20, 26, '');
  void set graphType(String v) { $_setString(20, 26, v); }
  bool hasGraphType() => $_has(20, 26);
  void clearGraphType() => clearField(26);

  String get graphWhat => $_get(21, 27, '');
  void set graphWhat(String v) { $_setString(21, 27, v); }
  bool hasGraphWhat() => $_has(21, 27);
  void clearGraphWhat() => clearField(27);

  String get graphBy => $_get(22, 28, '');
  void set graphBy(String v) { $_setString(22, 28, v); }
  bool hasGraphBy() => $_has(22, 28);
  void clearGraphBy() => clearField(28);

  List<UIGridColumn> get gridColumnList => $_get(23, 30, null);

  List<UIPanel> get panelList => $_get(24, 31, null);

  List<UIProcess> get processList => $_get(25, 32, null);

  List<UILink> get linkList => $_get(26, 33, null);

  List<UIQueryColumn> get queryColumnList => $_get(27, 34, null);

  List<SavedQuery> get savedQueryList => $_get(28, 35, null);

  bool get isAlwaysQuery => $_get(29, 40, false);
  void set isAlwaysQuery(bool v) { $_setBool(29, 40, v); }
  bool hasIsAlwaysQuery() => $_has(29, 40);
  void clearIsAlwaysQuery() => clearField(40);

  SavedQuery get defaultQuery => $_get(30, 41, null);
  void set defaultQuery(SavedQuery v) { setField(41, v); }
  bool hasDefaultQuery() => $_has(30, 41);
  void clearDefaultQuery() => clearField(41);

  bool get isGridFind => $_get(31, 44, true);
  void set isGridFind(bool v) { $_setBool(31, 44, v); }
  bool hasIsGridFind() => $_has(31, 44);
  void clearIsGridFind() => clearField(44);

  bool get isIncludeStats => $_get(32, 45, true);
  void set isIncludeStats(bool v) { $_setBool(32, 45, v); }
  bool hasIsIncludeStats() => $_has(32, 45);
  void clearIsIncludeStats() => clearField(45);

  List<DFilter> get filterList => $_get(33, 50, null);

  List<DSort> get sortList => $_get(34, 51, null);
}

class _ReadonlyUI extends UI with ReadonlyMessageMixin {}

class UIInfo extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('UIInfo')
    ..a(1, 'uiId', PbFieldType.OS)
    ..a(2, 'uiName', PbFieldType.OS)
    ..a(3, 'label', PbFieldType.OS)
    ..a(4, 'description', PbFieldType.OS)
    ..a(5, 'tableName', PbFieldType.OS)
    ..a(9, 'etag', PbFieldType.OS)
    ..a(10, 'withTable', PbFieldType.OB, true)
    ..a(15, 'iconImage', PbFieldType.OS)
    ..a(16, 'tenantId', PbFieldType.OS)
    ..a(17, 'roleId', PbFieldType.OS)
    ..a(18, 'userId', PbFieldType.OS)
    ..hasRequiredFields = false
  ;

  UIInfo() : super();
  UIInfo.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  UIInfo.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  UIInfo clone() => new UIInfo()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static UIInfo create() => new UIInfo();
  static PbList<UIInfo> createRepeated() => new PbList<UIInfo>();
  static UIInfo getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyUIInfo();
    return _defaultInstance;
  }
  static UIInfo _defaultInstance;
  static void $checkItem(UIInfo v) {
    if (v is !UIInfo) checkItemFailed(v, 'UIInfo');
  }

  String get uiId => $_get(0, 1, '');
  void set uiId(String v) { $_setString(0, 1, v); }
  bool hasUiId() => $_has(0, 1);
  void clearUiId() => clearField(1);

  String get uiName => $_get(1, 2, '');
  void set uiName(String v) { $_setString(1, 2, v); }
  bool hasUiName() => $_has(1, 2);
  void clearUiName() => clearField(2);

  String get label => $_get(2, 3, '');
  void set label(String v) { $_setString(2, 3, v); }
  bool hasLabel() => $_has(2, 3);
  void clearLabel() => clearField(3);

  String get description => $_get(3, 4, '');
  void set description(String v) { $_setString(3, 4, v); }
  bool hasDescription() => $_has(3, 4);
  void clearDescription() => clearField(4);

  String get tableName => $_get(4, 5, '');
  void set tableName(String v) { $_setString(4, 5, v); }
  bool hasTableName() => $_has(4, 5);
  void clearTableName() => clearField(5);

  String get etag => $_get(5, 9, '');
  void set etag(String v) { $_setString(5, 9, v); }
  bool hasEtag() => $_has(5, 9);
  void clearEtag() => clearField(9);

  bool get withTable => $_get(6, 10, true);
  void set withTable(bool v) { $_setBool(6, 10, v); }
  bool hasWithTable() => $_has(6, 10);
  void clearWithTable() => clearField(10);

  String get iconImage => $_get(7, 15, '');
  void set iconImage(String v) { $_setString(7, 15, v); }
  bool hasIconImage() => $_has(7, 15);
  void clearIconImage() => clearField(15);

  String get tenantId => $_get(8, 16, '');
  void set tenantId(String v) { $_setString(8, 16, v); }
  bool hasTenantId() => $_has(8, 16);
  void clearTenantId() => clearField(16);

  String get roleId => $_get(9, 17, '');
  void set roleId(String v) { $_setString(9, 17, v); }
  bool hasRoleId() => $_has(9, 17);
  void clearRoleId() => clearField(17);

  String get userId => $_get(10, 18, '');
  void set userId(String v) { $_setString(10, 18, v); }
  bool hasUserId() => $_has(10, 18);
  void clearUserId() => clearField(18);
}

class _ReadonlyUIInfo extends UIInfo with ReadonlyMessageMixin {}

class UIGridColumn extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('UIGridColumn')
    ..a(1, 'uiGridColumnId', PbFieldType.OS)
    ..a(2, 'column', PbFieldType.OM, DColumn.getDefault, DColumn.create)
    ..a(3, 'columnId', PbFieldType.OS)
    ..a(4, 'columnName', PbFieldType.OS)
    ..a(5, 'seqNo', PbFieldType.O3)
    ..a(6, 'isActive', PbFieldType.OB, true)
    ..a(12, 'width', PbFieldType.O3)
    ..a(15, 'panelColumn', PbFieldType.OM, UIPanelColumn.getDefault, UIPanelColumn.create)
    ..a(50, 'updateFlag', PbFieldType.OS)
  ;

  UIGridColumn() : super();
  UIGridColumn.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  UIGridColumn.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  UIGridColumn clone() => new UIGridColumn()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static UIGridColumn create() => new UIGridColumn();
  static PbList<UIGridColumn> createRepeated() => new PbList<UIGridColumn>();
  static UIGridColumn getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyUIGridColumn();
    return _defaultInstance;
  }
  static UIGridColumn _defaultInstance;
  static void $checkItem(UIGridColumn v) {
    if (v is !UIGridColumn) checkItemFailed(v, 'UIGridColumn');
  }

  String get uiGridColumnId => $_get(0, 1, '');
  void set uiGridColumnId(String v) { $_setString(0, 1, v); }
  bool hasUiGridColumnId() => $_has(0, 1);
  void clearUiGridColumnId() => clearField(1);

  DColumn get column => $_get(1, 2, null);
  void set column(DColumn v) { setField(2, v); }
  bool hasColumn() => $_has(1, 2);
  void clearColumn() => clearField(2);

  String get columnId => $_get(2, 3, '');
  void set columnId(String v) { $_setString(2, 3, v); }
  bool hasColumnId() => $_has(2, 3);
  void clearColumnId() => clearField(3);

  String get columnName => $_get(3, 4, '');
  void set columnName(String v) { $_setString(3, 4, v); }
  bool hasColumnName() => $_has(3, 4);
  void clearColumnName() => clearField(4);

  int get seqNo => $_get(4, 5, 0);
  void set seqNo(int v) { $_setUnsignedInt32(4, 5, v); }
  bool hasSeqNo() => $_has(4, 5);
  void clearSeqNo() => clearField(5);

  bool get isActive => $_get(5, 6, true);
  void set isActive(bool v) { $_setBool(5, 6, v); }
  bool hasIsActive() => $_has(5, 6);
  void clearIsActive() => clearField(6);

  int get width => $_get(6, 12, 0);
  void set width(int v) { $_setUnsignedInt32(6, 12, v); }
  bool hasWidth() => $_has(6, 12);
  void clearWidth() => clearField(12);

  UIPanelColumn get panelColumn => $_get(7, 15, null);
  void set panelColumn(UIPanelColumn v) { setField(15, v); }
  bool hasPanelColumn() => $_has(7, 15);
  void clearPanelColumn() => clearField(15);

  String get updateFlag => $_get(8, 50, '');
  void set updateFlag(String v) { $_setString(8, 50, v); }
  bool hasUpdateFlag() => $_has(8, 50);
  void clearUpdateFlag() => clearField(50);
}

class _ReadonlyUIGridColumn extends UIGridColumn with ReadonlyMessageMixin {}

class UIPanel extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('UIPanel')
    ..a(1, 'uiPanelId', PbFieldType.OS)
    ..a(2, 'name', PbFieldType.QS)
    ..a(4, 'description', PbFieldType.OS)
    ..a(5, 'help', PbFieldType.OS)
    ..a(6, 'tutorialUrl', PbFieldType.OS)
    ..a(7, 'isActive', PbFieldType.OB, true)
    ..a(8, 'isExpert', PbFieldType.OB)
    ..a(9, 'iconClass', PbFieldType.OS)
    ..a(10, 'seqNo', PbFieldType.O3)
    ..e(11, 'type', PbFieldType.OE, UIPanelType.DISPLAYED, UIPanelType.valueOf)
    ..e(12, 'labelPosition', PbFieldType.OE, UILabelPosition.LEFT, UILabelPosition.valueOf)
    ..a(13, 'fieldInputWidth', PbFieldType.O3, 8)
    ..a(15, 'displayLogic', PbFieldType.OS)
    ..a(16, 'panelColumnNumber', PbFieldType.O3, 2)
    ..pp(20, 'panelColumn', PbFieldType.PM, UIPanelColumn.$checkItem, UIPanelColumn.create)
    ..a(50, 'updateFlag', PbFieldType.OS)
  ;

  UIPanel() : super();
  UIPanel.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  UIPanel.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  UIPanel clone() => new UIPanel()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static UIPanel create() => new UIPanel();
  static PbList<UIPanel> createRepeated() => new PbList<UIPanel>();
  static UIPanel getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyUIPanel();
    return _defaultInstance;
  }
  static UIPanel _defaultInstance;
  static void $checkItem(UIPanel v) {
    if (v is !UIPanel) checkItemFailed(v, 'UIPanel');
  }

  String get uiPanelId => $_get(0, 1, '');
  void set uiPanelId(String v) { $_setString(0, 1, v); }
  bool hasUiPanelId() => $_has(0, 1);
  void clearUiPanelId() => clearField(1);

  String get name => $_get(1, 2, '');
  void set name(String v) { $_setString(1, 2, v); }
  bool hasName() => $_has(1, 2);
  void clearName() => clearField(2);

  String get description => $_get(2, 4, '');
  void set description(String v) { $_setString(2, 4, v); }
  bool hasDescription() => $_has(2, 4);
  void clearDescription() => clearField(4);

  String get help => $_get(3, 5, '');
  void set help(String v) { $_setString(3, 5, v); }
  bool hasHelp() => $_has(3, 5);
  void clearHelp() => clearField(5);

  String get tutorialUrl => $_get(4, 6, '');
  void set tutorialUrl(String v) { $_setString(4, 6, v); }
  bool hasTutorialUrl() => $_has(4, 6);
  void clearTutorialUrl() => clearField(6);

  bool get isActive => $_get(5, 7, true);
  void set isActive(bool v) { $_setBool(5, 7, v); }
  bool hasIsActive() => $_has(5, 7);
  void clearIsActive() => clearField(7);

  bool get isExpert => $_get(6, 8, false);
  void set isExpert(bool v) { $_setBool(6, 8, v); }
  bool hasIsExpert() => $_has(6, 8);
  void clearIsExpert() => clearField(8);

  String get iconClass => $_get(7, 9, '');
  void set iconClass(String v) { $_setString(7, 9, v); }
  bool hasIconClass() => $_has(7, 9);
  void clearIconClass() => clearField(9);

  int get seqNo => $_get(8, 10, 0);
  void set seqNo(int v) { $_setUnsignedInt32(8, 10, v); }
  bool hasSeqNo() => $_has(8, 10);
  void clearSeqNo() => clearField(10);

  UIPanelType get type => $_get(9, 11, null);
  void set type(UIPanelType v) { setField(11, v); }
  bool hasType() => $_has(9, 11);
  void clearType() => clearField(11);

  UILabelPosition get labelPosition => $_get(10, 12, null);
  void set labelPosition(UILabelPosition v) { setField(12, v); }
  bool hasLabelPosition() => $_has(10, 12);
  void clearLabelPosition() => clearField(12);

  int get fieldInputWidth => $_get(11, 13, 8);
  void set fieldInputWidth(int v) { $_setUnsignedInt32(11, 13, v); }
  bool hasFieldInputWidth() => $_has(11, 13);
  void clearFieldInputWidth() => clearField(13);

  String get displayLogic => $_get(12, 15, '');
  void set displayLogic(String v) { $_setString(12, 15, v); }
  bool hasDisplayLogic() => $_has(12, 15);
  void clearDisplayLogic() => clearField(15);

  int get panelColumnNumber => $_get(13, 16, 2);
  void set panelColumnNumber(int v) { $_setUnsignedInt32(13, 16, v); }
  bool hasPanelColumnNumber() => $_has(13, 16);
  void clearPanelColumnNumber() => clearField(16);

  List<UIPanelColumn> get panelColumnList => $_get(14, 20, null);

  String get updateFlag => $_get(15, 50, '');
  void set updateFlag(String v) { $_setString(15, 50, v); }
  bool hasUpdateFlag() => $_has(15, 50);
  void clearUpdateFlag() => clearField(50);
}

class _ReadonlyUIPanel extends UIPanel with ReadonlyMessageMixin {}

class UIPanelColumn extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('UIPanelColumn')
    ..a(1, 'uiPanelColumnId', PbFieldType.OS)
    ..a(2, 'column', PbFieldType.OM, DColumn.getDefault, DColumn.create)
    ..a(3, 'columnId', PbFieldType.OS)
    ..a(4, 'columnName', PbFieldType.OS)
    ..a(5, 'isActive', PbFieldType.OB, true)
    ..a(6, 'externalKey', PbFieldType.OS)
    ..a(8, 'isExpert', PbFieldType.OB)
    ..a(10, 'seqNo', PbFieldType.O3)
    ..a(11, 'label', PbFieldType.OS)
    ..a(12, 'width', PbFieldType.O3, 1)
    ..a(13, 'height', PbFieldType.O3, 1)
    ..a(20, 'isNewRow', PbFieldType.OB)
    ..a(21, 'isReadOnly', PbFieldType.OB)
    ..a(22, 'isMandatory', PbFieldType.OB)
    ..a(25, 'displayLogic', PbFieldType.OS)
    ..a(26, 'readOnlyLogic', PbFieldType.OS)
    ..a(27, 'mandatoryLogic', PbFieldType.OS)
    ..a(28, 'isAlternativeDisplay', PbFieldType.OB)
    ..a(29, 'defaultValue', PbFieldType.OS)
    ..a(30, 'updateFlag', PbFieldType.OS)
  ;

  UIPanelColumn() : super();
  UIPanelColumn.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  UIPanelColumn.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  UIPanelColumn clone() => new UIPanelColumn()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static UIPanelColumn create() => new UIPanelColumn();
  static PbList<UIPanelColumn> createRepeated() => new PbList<UIPanelColumn>();
  static UIPanelColumn getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyUIPanelColumn();
    return _defaultInstance;
  }
  static UIPanelColumn _defaultInstance;
  static void $checkItem(UIPanelColumn v) {
    if (v is !UIPanelColumn) checkItemFailed(v, 'UIPanelColumn');
  }

  String get uiPanelColumnId => $_get(0, 1, '');
  void set uiPanelColumnId(String v) { $_setString(0, 1, v); }
  bool hasUiPanelColumnId() => $_has(0, 1);
  void clearUiPanelColumnId() => clearField(1);

  DColumn get column => $_get(1, 2, null);
  void set column(DColumn v) { setField(2, v); }
  bool hasColumn() => $_has(1, 2);
  void clearColumn() => clearField(2);

  String get columnId => $_get(2, 3, '');
  void set columnId(String v) { $_setString(2, 3, v); }
  bool hasColumnId() => $_has(2, 3);
  void clearColumnId() => clearField(3);

  String get columnName => $_get(3, 4, '');
  void set columnName(String v) { $_setString(3, 4, v); }
  bool hasColumnName() => $_has(3, 4);
  void clearColumnName() => clearField(4);

  bool get isActive => $_get(4, 5, true);
  void set isActive(bool v) { $_setBool(4, 5, v); }
  bool hasIsActive() => $_has(4, 5);
  void clearIsActive() => clearField(5);

  String get externalKey => $_get(5, 6, '');
  void set externalKey(String v) { $_setString(5, 6, v); }
  bool hasExternalKey() => $_has(5, 6);
  void clearExternalKey() => clearField(6);

  bool get isExpert => $_get(6, 8, false);
  void set isExpert(bool v) { $_setBool(6, 8, v); }
  bool hasIsExpert() => $_has(6, 8);
  void clearIsExpert() => clearField(8);

  int get seqNo => $_get(7, 10, 0);
  void set seqNo(int v) { $_setUnsignedInt32(7, 10, v); }
  bool hasSeqNo() => $_has(7, 10);
  void clearSeqNo() => clearField(10);

  String get label => $_get(8, 11, '');
  void set label(String v) { $_setString(8, 11, v); }
  bool hasLabel() => $_has(8, 11);
  void clearLabel() => clearField(11);

  int get width => $_get(9, 12, 1);
  void set width(int v) { $_setUnsignedInt32(9, 12, v); }
  bool hasWidth() => $_has(9, 12);
  void clearWidth() => clearField(12);

  int get height => $_get(10, 13, 1);
  void set height(int v) { $_setUnsignedInt32(10, 13, v); }
  bool hasHeight() => $_has(10, 13);
  void clearHeight() => clearField(13);

  bool get isNewRow => $_get(11, 20, false);
  void set isNewRow(bool v) { $_setBool(11, 20, v); }
  bool hasIsNewRow() => $_has(11, 20);
  void clearIsNewRow() => clearField(20);

  bool get isReadOnly => $_get(12, 21, false);
  void set isReadOnly(bool v) { $_setBool(12, 21, v); }
  bool hasIsReadOnly() => $_has(12, 21);
  void clearIsReadOnly() => clearField(21);

  bool get isMandatory => $_get(13, 22, false);
  void set isMandatory(bool v) { $_setBool(13, 22, v); }
  bool hasIsMandatory() => $_has(13, 22);
  void clearIsMandatory() => clearField(22);

  String get displayLogic => $_get(14, 25, '');
  void set displayLogic(String v) { $_setString(14, 25, v); }
  bool hasDisplayLogic() => $_has(14, 25);
  void clearDisplayLogic() => clearField(25);

  String get readOnlyLogic => $_get(15, 26, '');
  void set readOnlyLogic(String v) { $_setString(15, 26, v); }
  bool hasReadOnlyLogic() => $_has(15, 26);
  void clearReadOnlyLogic() => clearField(26);

  String get mandatoryLogic => $_get(16, 27, '');
  void set mandatoryLogic(String v) { $_setString(16, 27, v); }
  bool hasMandatoryLogic() => $_has(16, 27);
  void clearMandatoryLogic() => clearField(27);

  bool get isAlternativeDisplay => $_get(17, 28, false);
  void set isAlternativeDisplay(bool v) { $_setBool(17, 28, v); }
  bool hasIsAlternativeDisplay() => $_has(17, 28);
  void clearIsAlternativeDisplay() => clearField(28);

  String get defaultValue => $_get(18, 29, '');
  void set defaultValue(String v) { $_setString(18, 29, v); }
  bool hasDefaultValue() => $_has(18, 29);
  void clearDefaultValue() => clearField(29);

  String get updateFlag => $_get(19, 30, '');
  void set updateFlag(String v) { $_setString(19, 30, v); }
  bool hasUpdateFlag() => $_has(19, 30);
  void clearUpdateFlag() => clearField(30);
}

class _ReadonlyUIPanelColumn extends UIPanelColumn with ReadonlyMessageMixin {}

class UIProcess extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('UIProcess')
    ..a(1, 'uiProcessId', PbFieldType.OS)
    ..a(2, 'processId', PbFieldType.OS)
    ..a(3, 'name', PbFieldType.QS)
    ..a(4, 'processExternalKey', PbFieldType.OS)
    ..a(5, 'label', PbFieldType.OS)
    ..a(6, 'description', PbFieldType.OS)
    ..a(7, 'help', PbFieldType.OS)
    ..a(8, 'tutorialUrl', PbFieldType.OS)
    ..a(9, 'isActive', PbFieldType.OB, true)
    ..a(10, 'isExpert', PbFieldType.OB)
    ..a(11, 'seqNo', PbFieldType.O3)
    ..a(12, 'isInstanceMethod', PbFieldType.OB, true)
    ..a(13, 'isCallout', PbFieldType.OB)
    ..a(14, 'isMultiRecord', PbFieldType.OB)
    ..a(15, 'tableName', PbFieldType.OS)
    ..a(16, 'processTypeName', PbFieldType.OS)
    ..a(17, 'buttonStyle', PbFieldType.OS)
    ..a(18, 'iconImage', PbFieldType.OS)
    ..a(19, 'color', PbFieldType.OS)
    ..a(20, 'logic', PbFieldType.OS)
    ..a(21, 'webHookUrl', PbFieldType.OS)
    ..a(22, 'webLinkUrl', PbFieldType.OS)
    ..a(23, 'webLocation', PbFieldType.OS)
    ..pp(29, 'parameter', PbFieldType.PM, DProperty.$checkItem, DProperty.create)
    ..a(30, 'updateFlag', PbFieldType.OS)
  ;

  UIProcess() : super();
  UIProcess.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  UIProcess.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  UIProcess clone() => new UIProcess()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static UIProcess create() => new UIProcess();
  static PbList<UIProcess> createRepeated() => new PbList<UIProcess>();
  static UIProcess getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyUIProcess();
    return _defaultInstance;
  }
  static UIProcess _defaultInstance;
  static void $checkItem(UIProcess v) {
    if (v is !UIProcess) checkItemFailed(v, 'UIProcess');
  }

  String get uiProcessId => $_get(0, 1, '');
  void set uiProcessId(String v) { $_setString(0, 1, v); }
  bool hasUiProcessId() => $_has(0, 1);
  void clearUiProcessId() => clearField(1);

  String get processId => $_get(1, 2, '');
  void set processId(String v) { $_setString(1, 2, v); }
  bool hasProcessId() => $_has(1, 2);
  void clearProcessId() => clearField(2);

  String get name => $_get(2, 3, '');
  void set name(String v) { $_setString(2, 3, v); }
  bool hasName() => $_has(2, 3);
  void clearName() => clearField(3);

  String get processExternalKey => $_get(3, 4, '');
  void set processExternalKey(String v) { $_setString(3, 4, v); }
  bool hasProcessExternalKey() => $_has(3, 4);
  void clearProcessExternalKey() => clearField(4);

  String get label => $_get(4, 5, '');
  void set label(String v) { $_setString(4, 5, v); }
  bool hasLabel() => $_has(4, 5);
  void clearLabel() => clearField(5);

  String get description => $_get(5, 6, '');
  void set description(String v) { $_setString(5, 6, v); }
  bool hasDescription() => $_has(5, 6);
  void clearDescription() => clearField(6);

  String get help => $_get(6, 7, '');
  void set help(String v) { $_setString(6, 7, v); }
  bool hasHelp() => $_has(6, 7);
  void clearHelp() => clearField(7);

  String get tutorialUrl => $_get(7, 8, '');
  void set tutorialUrl(String v) { $_setString(7, 8, v); }
  bool hasTutorialUrl() => $_has(7, 8);
  void clearTutorialUrl() => clearField(8);

  bool get isActive => $_get(8, 9, true);
  void set isActive(bool v) { $_setBool(8, 9, v); }
  bool hasIsActive() => $_has(8, 9);
  void clearIsActive() => clearField(9);

  bool get isExpert => $_get(9, 10, false);
  void set isExpert(bool v) { $_setBool(9, 10, v); }
  bool hasIsExpert() => $_has(9, 10);
  void clearIsExpert() => clearField(10);

  int get seqNo => $_get(10, 11, 0);
  void set seqNo(int v) { $_setUnsignedInt32(10, 11, v); }
  bool hasSeqNo() => $_has(10, 11);
  void clearSeqNo() => clearField(11);

  bool get isInstanceMethod => $_get(11, 12, true);
  void set isInstanceMethod(bool v) { $_setBool(11, 12, v); }
  bool hasIsInstanceMethod() => $_has(11, 12);
  void clearIsInstanceMethod() => clearField(12);

  bool get isCallout => $_get(12, 13, false);
  void set isCallout(bool v) { $_setBool(12, 13, v); }
  bool hasIsCallout() => $_has(12, 13);
  void clearIsCallout() => clearField(13);

  bool get isMultiRecord => $_get(13, 14, false);
  void set isMultiRecord(bool v) { $_setBool(13, 14, v); }
  bool hasIsMultiRecord() => $_has(13, 14);
  void clearIsMultiRecord() => clearField(14);

  String get tableName => $_get(14, 15, '');
  void set tableName(String v) { $_setString(14, 15, v); }
  bool hasTableName() => $_has(14, 15);
  void clearTableName() => clearField(15);

  String get processTypeName => $_get(15, 16, '');
  void set processTypeName(String v) { $_setString(15, 16, v); }
  bool hasProcessTypeName() => $_has(15, 16);
  void clearProcessTypeName() => clearField(16);

  String get buttonStyle => $_get(16, 17, '');
  void set buttonStyle(String v) { $_setString(16, 17, v); }
  bool hasButtonStyle() => $_has(16, 17);
  void clearButtonStyle() => clearField(17);

  String get iconImage => $_get(17, 18, '');
  void set iconImage(String v) { $_setString(17, 18, v); }
  bool hasIconImage() => $_has(17, 18);
  void clearIconImage() => clearField(18);

  String get color => $_get(18, 19, '');
  void set color(String v) { $_setString(18, 19, v); }
  bool hasColor() => $_has(18, 19);
  void clearColor() => clearField(19);

  String get logic => $_get(19, 20, '');
  void set logic(String v) { $_setString(19, 20, v); }
  bool hasLogic() => $_has(19, 20);
  void clearLogic() => clearField(20);

  String get webHookUrl => $_get(20, 21, '');
  void set webHookUrl(String v) { $_setString(20, 21, v); }
  bool hasWebHookUrl() => $_has(20, 21);
  void clearWebHookUrl() => clearField(21);

  String get webLinkUrl => $_get(21, 22, '');
  void set webLinkUrl(String v) { $_setString(21, 22, v); }
  bool hasWebLinkUrl() => $_has(21, 22);
  void clearWebLinkUrl() => clearField(22);

  String get webLocation => $_get(22, 23, '');
  void set webLocation(String v) { $_setString(22, 23, v); }
  bool hasWebLocation() => $_has(22, 23);
  void clearWebLocation() => clearField(23);

  List<DProperty> get parameterList => $_get(23, 29, null);

  String get updateFlag => $_get(24, 30, '');
  void set updateFlag(String v) { $_setString(24, 30, v); }
  bool hasUpdateFlag() => $_has(24, 30);
  void clearUpdateFlag() => clearField(30);
}

class _ReadonlyUIProcess extends UIProcess with ReadonlyMessageMixin {}

class UILink extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('UILink')
    ..a(1, 'uiLinkId', PbFieldType.OS)
    ..a(2, 'uiRelatedId', PbFieldType.OS)
    ..a(3, 'uiRelatedName', PbFieldType.OS)
    ..a(4, 'isActive', PbFieldType.OB, true)
    ..a(5, 'seqNo', PbFieldType.O3)
    ..a(8, 'isExpert', PbFieldType.OB)
    ..a(9, 'isChild', PbFieldType.OB)
    ..a(10, 'isPrimaryChild', PbFieldType.OB)
    ..a(12, 'isDisplayRecords', PbFieldType.OB)
    ..a(13, 'restrictionSql', PbFieldType.OS)
    ..a(20, 'uiName', PbFieldType.OS)
    ..a(21, 'label', PbFieldType.OS)
    ..a(22, 'description', PbFieldType.OS)
    ..a(23, 'tableName', PbFieldType.OS)
    ..a(24, 'etag', PbFieldType.OS)
    ..a(25, 'linkColumnName', PbFieldType.OS)
    ..a(26, 'iconImage', PbFieldType.OS)
    ..a(27, 'tenantId', PbFieldType.OS)
    ..a(28, 'roleId', PbFieldType.OS)
    ..a(29, 'userId', PbFieldType.OS)
    ..a(30, 'updateFlag', PbFieldType.OS)
    ..hasRequiredFields = false
  ;

  UILink() : super();
  UILink.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  UILink.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  UILink clone() => new UILink()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static UILink create() => new UILink();
  static PbList<UILink> createRepeated() => new PbList<UILink>();
  static UILink getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyUILink();
    return _defaultInstance;
  }
  static UILink _defaultInstance;
  static void $checkItem(UILink v) {
    if (v is !UILink) checkItemFailed(v, 'UILink');
  }

  String get uiLinkId => $_get(0, 1, '');
  void set uiLinkId(String v) { $_setString(0, 1, v); }
  bool hasUiLinkId() => $_has(0, 1);
  void clearUiLinkId() => clearField(1);

  String get uiRelatedId => $_get(1, 2, '');
  void set uiRelatedId(String v) { $_setString(1, 2, v); }
  bool hasUiRelatedId() => $_has(1, 2);
  void clearUiRelatedId() => clearField(2);

  String get uiRelatedName => $_get(2, 3, '');
  void set uiRelatedName(String v) { $_setString(2, 3, v); }
  bool hasUiRelatedName() => $_has(2, 3);
  void clearUiRelatedName() => clearField(3);

  bool get isActive => $_get(3, 4, true);
  void set isActive(bool v) { $_setBool(3, 4, v); }
  bool hasIsActive() => $_has(3, 4);
  void clearIsActive() => clearField(4);

  int get seqNo => $_get(4, 5, 0);
  void set seqNo(int v) { $_setUnsignedInt32(4, 5, v); }
  bool hasSeqNo() => $_has(4, 5);
  void clearSeqNo() => clearField(5);

  bool get isExpert => $_get(5, 8, false);
  void set isExpert(bool v) { $_setBool(5, 8, v); }
  bool hasIsExpert() => $_has(5, 8);
  void clearIsExpert() => clearField(8);

  bool get isChild => $_get(6, 9, false);
  void set isChild(bool v) { $_setBool(6, 9, v); }
  bool hasIsChild() => $_has(6, 9);
  void clearIsChild() => clearField(9);

  bool get isPrimaryChild => $_get(7, 10, false);
  void set isPrimaryChild(bool v) { $_setBool(7, 10, v); }
  bool hasIsPrimaryChild() => $_has(7, 10);
  void clearIsPrimaryChild() => clearField(10);

  bool get isDisplayRecords => $_get(8, 12, false);
  void set isDisplayRecords(bool v) { $_setBool(8, 12, v); }
  bool hasIsDisplayRecords() => $_has(8, 12);
  void clearIsDisplayRecords() => clearField(12);

  String get restrictionSql => $_get(9, 13, '');
  void set restrictionSql(String v) { $_setString(9, 13, v); }
  bool hasRestrictionSql() => $_has(9, 13);
  void clearRestrictionSql() => clearField(13);

  String get uiName => $_get(10, 20, '');
  void set uiName(String v) { $_setString(10, 20, v); }
  bool hasUiName() => $_has(10, 20);
  void clearUiName() => clearField(20);

  String get label => $_get(11, 21, '');
  void set label(String v) { $_setString(11, 21, v); }
  bool hasLabel() => $_has(11, 21);
  void clearLabel() => clearField(21);

  String get description => $_get(12, 22, '');
  void set description(String v) { $_setString(12, 22, v); }
  bool hasDescription() => $_has(12, 22);
  void clearDescription() => clearField(22);

  String get tableName => $_get(13, 23, '');
  void set tableName(String v) { $_setString(13, 23, v); }
  bool hasTableName() => $_has(13, 23);
  void clearTableName() => clearField(23);

  String get etag => $_get(14, 24, '');
  void set etag(String v) { $_setString(14, 24, v); }
  bool hasEtag() => $_has(14, 24);
  void clearEtag() => clearField(24);

  String get linkColumnName => $_get(15, 25, '');
  void set linkColumnName(String v) { $_setString(15, 25, v); }
  bool hasLinkColumnName() => $_has(15, 25);
  void clearLinkColumnName() => clearField(25);

  String get iconImage => $_get(16, 26, '');
  void set iconImage(String v) { $_setString(16, 26, v); }
  bool hasIconImage() => $_has(16, 26);
  void clearIconImage() => clearField(26);

  String get tenantId => $_get(17, 27, '');
  void set tenantId(String v) { $_setString(17, 27, v); }
  bool hasTenantId() => $_has(17, 27);
  void clearTenantId() => clearField(27);

  String get roleId => $_get(18, 28, '');
  void set roleId(String v) { $_setString(18, 28, v); }
  bool hasRoleId() => $_has(18, 28);
  void clearRoleId() => clearField(28);

  String get userId => $_get(19, 29, '');
  void set userId(String v) { $_setString(19, 29, v); }
  bool hasUserId() => $_has(19, 29);
  void clearUserId() => clearField(29);

  String get updateFlag => $_get(20, 30, '');
  void set updateFlag(String v) { $_setString(20, 30, v); }
  bool hasUpdateFlag() => $_has(20, 30);
  void clearUpdateFlag() => clearField(30);
}

class _ReadonlyUILink extends UILink with ReadonlyMessageMixin {}

class UIQueryColumn extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('UIQueryColumn')
    ..a(1, 'uiQueryColumnId', PbFieldType.OS)
    ..a(2, 'column', PbFieldType.OM, DColumn.getDefault, DColumn.create)
    ..a(3, 'columnId', PbFieldType.OS)
    ..a(4, 'columnName', PbFieldType.OS)
    ..a(5, 'columnLabel', PbFieldType.OS)
    ..a(6, 'isActive', PbFieldType.OB, true)
    ..a(10, 'seqNo', PbFieldType.O3)
    ..a(11, 'isParent', PbFieldType.OB)
    ..a(50, 'updateFlag', PbFieldType.OS)
  ;

  UIQueryColumn() : super();
  UIQueryColumn.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  UIQueryColumn.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  UIQueryColumn clone() => new UIQueryColumn()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static UIQueryColumn create() => new UIQueryColumn();
  static PbList<UIQueryColumn> createRepeated() => new PbList<UIQueryColumn>();
  static UIQueryColumn getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyUIQueryColumn();
    return _defaultInstance;
  }
  static UIQueryColumn _defaultInstance;
  static void $checkItem(UIQueryColumn v) {
    if (v is !UIQueryColumn) checkItemFailed(v, 'UIQueryColumn');
  }

  String get uiQueryColumnId => $_get(0, 1, '');
  void set uiQueryColumnId(String v) { $_setString(0, 1, v); }
  bool hasUiQueryColumnId() => $_has(0, 1);
  void clearUiQueryColumnId() => clearField(1);

  DColumn get column => $_get(1, 2, null);
  void set column(DColumn v) { setField(2, v); }
  bool hasColumn() => $_has(1, 2);
  void clearColumn() => clearField(2);

  String get columnId => $_get(2, 3, '');
  void set columnId(String v) { $_setString(2, 3, v); }
  bool hasColumnId() => $_has(2, 3);
  void clearColumnId() => clearField(3);

  String get columnName => $_get(3, 4, '');
  void set columnName(String v) { $_setString(3, 4, v); }
  bool hasColumnName() => $_has(3, 4);
  void clearColumnName() => clearField(4);

  String get columnLabel => $_get(4, 5, '');
  void set columnLabel(String v) { $_setString(4, 5, v); }
  bool hasColumnLabel() => $_has(4, 5);
  void clearColumnLabel() => clearField(5);

  bool get isActive => $_get(5, 6, true);
  void set isActive(bool v) { $_setBool(5, 6, v); }
  bool hasIsActive() => $_has(5, 6);
  void clearIsActive() => clearField(6);

  int get seqNo => $_get(6, 10, 0);
  void set seqNo(int v) { $_setUnsignedInt32(6, 10, v); }
  bool hasSeqNo() => $_has(6, 10);
  void clearSeqNo() => clearField(10);

  bool get isParent => $_get(7, 11, false);
  void set isParent(bool v) { $_setBool(7, 11, v); }
  bool hasIsParent() => $_has(7, 11);
  void clearIsParent() => clearField(11);

  String get updateFlag => $_get(8, 50, '');
  void set updateFlag(String v) { $_setString(8, 50, v); }
  bool hasUpdateFlag() => $_has(8, 50);
  void clearUpdateFlag() => clearField(50);
}

class _ReadonlyUIQueryColumn extends UIQueryColumn with ReadonlyMessageMixin {}

const UILabelPosition$json = const {
  '1': 'UILabelPosition',
  '2': const [
    const {'1': 'LEFT', '2': 1},
    const {'1': 'RIGHT', '2': 2},
    const {'1': 'TOP', '2': 3},
    const {'1': 'BOTTOM', '2': 4},
    const {'1': 'NONE', '2': 5},
  ],
};

const UIPanelType$json = const {
  '1': 'UIPanelType',
  '2': const [
    const {'1': 'DISPLAYED', '2': 1},
    const {'1': 'IOPEN', '2': 2},
    const {'1': 'ICLOSED', '2': 3},
    const {'1': 'HIDDEN', '2': 4},
  ],
};

const UI$json = const {
  '1': 'UI',
  '2': const [
    const {'1': 'ui_id', '3': 1, '4': 1, '5': 9},
    const {'1': 'name', '3': 2, '4': 2, '5': 9},
    const {'1': 'label', '3': 3, '4': 1, '5': 9},
    const {'1': 'description', '3': 4, '4': 1, '5': 9},
    const {'1': 'tenant_id', '3': 5, '4': 1, '5': 9},
    const {'1': 'role_id', '3': 6, '4': 1, '5': 9},
    const {'1': 'user_id', '3': 7, '4': 1, '5': 9},
    const {'1': 'etag', '3': 8, '4': 1, '5': 9},
    const {'1': 'display', '3': 9, '4': 3, '5': 11, '6': '.UIInfo'},
    const {'1': 'table', '3': 10, '4': 1, '5': 11, '6': '.DTable'},
    const {'1': 'table_id', '3': 11, '4': 1, '5': 9},
    const {'1': 'table_name', '3': 12, '4': 1, '5': 9},
    const {'1': 'external_key', '3': 13, '4': 1, '5': 9},
    const {'1': 'is_can_delete', '3': 15, '4': 1, '5': 8, '7': 'true'},
    const {'1': 'is_can_insert', '3': 16, '4': 1, '5': 8, '7': 'true'},
    const {'1': 'is_read_only', '3': 17, '4': 1, '5': 8, '7': 'false'},
    const {'1': 'is_default_grid_mode', '3': 20, '4': 1, '5': 8, '7': 'true'},
    const {'1': 'is_show_indicators', '3': 21, '4': 1, '5': 8, '7': 'false'},
    const {'1': 'grid_type', '3': 22, '4': 1, '5': 9},
    const {'1': 'is_show_graph', '3': 25, '4': 1, '5': 8, '7': 'true'},
    const {'1': 'graph_type', '3': 26, '4': 1, '5': 9},
    const {'1': 'graph_what', '3': 27, '4': 1, '5': 9},
    const {'1': 'graph_by', '3': 28, '4': 1, '5': 9},
    const {'1': 'grid_column', '3': 30, '4': 3, '5': 11, '6': '.UIGridColumn'},
    const {'1': 'panel', '3': 31, '4': 3, '5': 11, '6': '.UIPanel'},
    const {'1': 'process', '3': 32, '4': 3, '5': 11, '6': '.UIProcess'},
    const {'1': 'link', '3': 33, '4': 3, '5': 11, '6': '.UILink'},
    const {'1': 'query_column', '3': 34, '4': 3, '5': 11, '6': '.UIQueryColumn'},
    const {'1': 'saved_query', '3': 35, '4': 3, '5': 11, '6': '.SavedQuery'},
    const {'1': 'is_always_query', '3': 40, '4': 1, '5': 8, '7': 'false'},
    const {'1': 'default_query', '3': 41, '4': 1, '5': 11, '6': '.SavedQuery'},
    const {'1': 'is_grid_find', '3': 44, '4': 1, '5': 8, '7': 'true'},
    const {'1': 'is_include_stats', '3': 45, '4': 1, '5': 8, '7': 'true'},
    const {'1': 'filter', '3': 50, '4': 3, '5': 11, '6': '.DFilter'},
    const {'1': 'sort', '3': 51, '4': 3, '5': 11, '6': '.DSort'},
  ],
};

const UIInfo$json = const {
  '1': 'UIInfo',
  '2': const [
    const {'1': 'ui_id', '3': 1, '4': 1, '5': 9},
    const {'1': 'ui_name', '3': 2, '4': 1, '5': 9},
    const {'1': 'label', '3': 3, '4': 1, '5': 9},
    const {'1': 'description', '3': 4, '4': 1, '5': 9},
    const {'1': 'table_name', '3': 5, '4': 1, '5': 9},
    const {'1': 'etag', '3': 9, '4': 1, '5': 9},
    const {'1': 'with_table', '3': 10, '4': 1, '5': 8, '7': 'true'},
    const {'1': 'icon_image', '3': 15, '4': 1, '5': 9},
    const {'1': 'tenant_id', '3': 16, '4': 1, '5': 9},
    const {'1': 'role_id', '3': 17, '4': 1, '5': 9},
    const {'1': 'user_id', '3': 18, '4': 1, '5': 9},
  ],
};

const UIGridColumn$json = const {
  '1': 'UIGridColumn',
  '2': const [
    const {'1': 'ui_grid_column_id', '3': 1, '4': 1, '5': 9},
    const {'1': 'column', '3': 2, '4': 1, '5': 11, '6': '.DColumn'},
    const {'1': 'column_id', '3': 3, '4': 1, '5': 9},
    const {'1': 'column_name', '3': 4, '4': 1, '5': 9},
    const {'1': 'seq_no', '3': 5, '4': 1, '5': 5},
    const {'1': 'is_active', '3': 6, '4': 1, '5': 8, '7': 'true'},
    const {'1': 'width', '3': 12, '4': 1, '5': 5},
    const {'1': 'panel_column', '3': 15, '4': 1, '5': 11, '6': '.UIPanelColumn'},
    const {'1': 'update_flag', '3': 50, '4': 1, '5': 9},
  ],
};

const UIPanel$json = const {
  '1': 'UIPanel',
  '2': const [
    const {'1': 'ui_panel_id', '3': 1, '4': 1, '5': 9},
    const {'1': 'name', '3': 2, '4': 2, '5': 9},
    const {'1': 'description', '3': 4, '4': 1, '5': 9},
    const {'1': 'help', '3': 5, '4': 1, '5': 9},
    const {'1': 'tutorial_url', '3': 6, '4': 1, '5': 9},
    const {'1': 'is_active', '3': 7, '4': 1, '5': 8, '7': 'true'},
    const {'1': 'is_expert', '3': 8, '4': 1, '5': 8, '7': 'false'},
    const {'1': 'iconClass', '3': 9, '4': 1, '5': 9},
    const {'1': 'seq_no', '3': 10, '4': 1, '5': 5},
    const {'1': 'type', '3': 11, '4': 1, '5': 14, '6': '.UIPanelType', '7': 'DISPLAYED'},
    const {'1': 'label_position', '3': 12, '4': 1, '5': 14, '6': '.UILabelPosition', '7': 'LEFT'},
    const {'1': 'field_input_width', '3': 13, '4': 1, '5': 5, '7': '8'},
    const {'1': 'display_logic', '3': 15, '4': 1, '5': 9},
    const {'1': 'panel_column_number', '3': 16, '4': 1, '5': 5, '7': '2'},
    const {'1': 'panel_column', '3': 20, '4': 3, '5': 11, '6': '.UIPanelColumn'},
    const {'1': 'update_flag', '3': 50, '4': 1, '5': 9},
  ],
};

const UIPanelColumn$json = const {
  '1': 'UIPanelColumn',
  '2': const [
    const {'1': 'ui_panel_column_id', '3': 1, '4': 1, '5': 9},
    const {'1': 'column', '3': 2, '4': 1, '5': 11, '6': '.DColumn'},
    const {'1': 'column_id', '3': 3, '4': 1, '5': 9},
    const {'1': 'column_name', '3': 4, '4': 1, '5': 9},
    const {'1': 'is_active', '3': 5, '4': 1, '5': 8, '7': 'true'},
    const {'1': 'external_key', '3': 6, '4': 1, '5': 9},
    const {'1': 'is_expert', '3': 8, '4': 1, '5': 8, '7': 'false'},
    const {'1': 'seq_no', '3': 10, '4': 1, '5': 5},
    const {'1': 'label', '3': 11, '4': 1, '5': 9},
    const {'1': 'width', '3': 12, '4': 1, '5': 5, '7': '1'},
    const {'1': 'height', '3': 13, '4': 1, '5': 5, '7': '1'},
    const {'1': 'is_new_row', '3': 20, '4': 1, '5': 8, '7': 'false'},
    const {'1': 'is_read_only', '3': 21, '4': 1, '5': 8, '7': 'false'},
    const {'1': 'is_mandatory', '3': 22, '4': 1, '5': 8},
    const {'1': 'display_logic', '3': 25, '4': 1, '5': 9},
    const {'1': 'read_only_logic', '3': 26, '4': 1, '5': 9},
    const {'1': 'mandatory_logic', '3': 27, '4': 1, '5': 9},
    const {'1': 'is_alternative_display', '3': 28, '4': 1, '5': 8, '7': 'false'},
    const {'1': 'default_value', '3': 29, '4': 1, '5': 9},
    const {'1': 'update_flag', '3': 30, '4': 1, '5': 9},
  ],
};

const UIProcess$json = const {
  '1': 'UIProcess',
  '2': const [
    const {'1': 'ui_process_id', '3': 1, '4': 1, '5': 9},
    const {'1': 'process_id', '3': 2, '4': 1, '5': 9},
    const {'1': 'name', '3': 3, '4': 2, '5': 9},
    const {'1': 'process_external_key', '3': 4, '4': 1, '5': 9},
    const {'1': 'label', '3': 5, '4': 1, '5': 9},
    const {'1': 'description', '3': 6, '4': 1, '5': 9},
    const {'1': 'help', '3': 7, '4': 1, '5': 9},
    const {'1': 'tutorial_url', '3': 8, '4': 1, '5': 9},
    const {'1': 'is_active', '3': 9, '4': 1, '5': 8, '7': 'true'},
    const {'1': 'is_expert', '3': 10, '4': 1, '5': 8, '7': 'false'},
    const {'1': 'seq_no', '3': 11, '4': 1, '5': 5},
    const {'1': 'is_instance_method', '3': 12, '4': 1, '5': 8, '7': 'true'},
    const {'1': 'is_callout', '3': 13, '4': 1, '5': 8, '7': 'false'},
    const {'1': 'is_multi_record', '3': 14, '4': 1, '5': 8, '7': 'false'},
    const {'1': 'table_name', '3': 15, '4': 1, '5': 9},
    const {'1': 'process_type_name', '3': 16, '4': 1, '5': 9},
    const {'1': 'button_style', '3': 17, '4': 1, '5': 9},
    const {'1': 'icon_image', '3': 18, '4': 1, '5': 9},
    const {'1': 'color', '3': 19, '4': 1, '5': 9},
    const {'1': 'logic', '3': 20, '4': 1, '5': 9},
    const {'1': 'web_hook_url', '3': 21, '4': 1, '5': 9},
    const {'1': 'web_link_url', '3': 22, '4': 1, '5': 9},
    const {'1': 'web_location', '3': 23, '4': 1, '5': 9},
    const {'1': 'parameter', '3': 29, '4': 3, '5': 11, '6': '.DProperty'},
    const {'1': 'update_flag', '3': 30, '4': 1, '5': 9},
  ],
};

const UILink$json = const {
  '1': 'UILink',
  '2': const [
    const {'1': 'ui_link_id', '3': 1, '4': 1, '5': 9},
    const {'1': 'ui_related_id', '3': 2, '4': 1, '5': 9},
    const {'1': 'ui_related_name', '3': 3, '4': 1, '5': 9},
    const {'1': 'is_active', '3': 4, '4': 1, '5': 8, '7': 'true'},
    const {'1': 'seq_no', '3': 5, '4': 1, '5': 5},
    const {'1': 'is_expert', '3': 8, '4': 1, '5': 8, '7': 'false'},
    const {'1': 'is_child', '3': 9, '4': 1, '5': 8},
    const {'1': 'is_primary_child', '3': 10, '4': 1, '5': 8},
    const {'1': 'is_display_records', '3': 12, '4': 1, '5': 8},
    const {'1': 'restriction_sql', '3': 13, '4': 1, '5': 9},
    const {'1': 'ui_name', '3': 20, '4': 1, '5': 9},
    const {'1': 'label', '3': 21, '4': 1, '5': 9},
    const {'1': 'description', '3': 22, '4': 1, '5': 9},
    const {'1': 'table_name', '3': 23, '4': 1, '5': 9},
    const {'1': 'etag', '3': 24, '4': 1, '5': 9},
    const {'1': 'link_column_name', '3': 25, '4': 1, '5': 9},
    const {'1': 'icon_image', '3': 26, '4': 1, '5': 9},
    const {'1': 'tenant_id', '3': 27, '4': 1, '5': 9},
    const {'1': 'role_id', '3': 28, '4': 1, '5': 9},
    const {'1': 'user_id', '3': 29, '4': 1, '5': 9},
    const {'1': 'update_flag', '3': 30, '4': 1, '5': 9},
  ],
};

const UIQueryColumn$json = const {
  '1': 'UIQueryColumn',
  '2': const [
    const {'1': 'ui_query_column_id', '3': 1, '4': 1, '5': 9},
    const {'1': 'column', '3': 2, '4': 1, '5': 11, '6': '.DColumn'},
    const {'1': 'column_id', '3': 3, '4': 1, '5': 9},
    const {'1': 'column_name', '3': 4, '4': 1, '5': 9},
    const {'1': 'column_label', '3': 5, '4': 1, '5': 9},
    const {'1': 'is_active', '3': 6, '4': 1, '5': 8, '7': 'true'},
    const {'1': 'seq_no', '3': 10, '4': 1, '5': 5},
    const {'1': 'is_parent', '3': 11, '4': 1, '5': 8, '7': 'false'},
    const {'1': 'update_flag', '3': 50, '4': 1, '5': 9},
  ],
};

