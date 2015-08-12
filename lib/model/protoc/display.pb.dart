///
//  Generated code. Do not modify.
///
library display;

import 'package:protobuf/protobuf.dart';
import 'structure.pb.dart';
import 'data.pb.dart';

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

  const UIPanelType._(int v, String n) : super(v, n);
}

class UI extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('UI')
    ..a(1, 'uiId', GeneratedMessage.OS)
    ..a(2, 'name', GeneratedMessage.QS)
    ..a(3, 'label', GeneratedMessage.OS)
    ..a(4, 'description', GeneratedMessage.OS)
    ..a(5, 'tenantId', GeneratedMessage.OS)
    ..a(6, 'roleId', GeneratedMessage.OS)
    ..a(7, 'userId', GeneratedMessage.OS)
    ..a(8, 'etag', GeneratedMessage.OS)
    ..m(9, 'display', UIInfo.create, UIInfo.createRepeated)
    ..a(10, 'table', GeneratedMessage.OM, DTable.create, DTable.create)
    ..a(11, 'tableId', GeneratedMessage.OS)
    ..a(12, 'tableName', GeneratedMessage.OS)
    ..a(13, 'externalKey', GeneratedMessage.OS)
    ..a(15, 'isCanDelete', GeneratedMessage.OB, true)
    ..a(16, 'isCanInsert', GeneratedMessage.OB, true)
    ..a(17, 'isReadOnly', GeneratedMessage.OB)
    ..a(20, 'isDefaultGridMode', GeneratedMessage.OB, true)
    ..a(21, 'isShowIndicators', GeneratedMessage.OB)
    ..a(22, 'gridType', GeneratedMessage.OS)
    ..a(25, 'isShowGraph', GeneratedMessage.OB, true)
    ..a(26, 'graphType', GeneratedMessage.OS)
    ..a(27, 'graphWhat', GeneratedMessage.OS)
    ..a(28, 'graphBy', GeneratedMessage.OS)
    ..m(30, 'gridColumn', UIGridColumn.create, UIGridColumn.createRepeated)
    ..m(31, 'panel', UIPanel.create, UIPanel.createRepeated)
    ..m(32, 'process', UIProcess.create, UIProcess.createRepeated)
    ..m(33, 'link', UILink.create, UILink.createRepeated)
    ..m(34, 'queryColumn', UIQueryColumn.create, UIQueryColumn.createRepeated)
    ..m(35, 'savedQuery', SavedQuery.create, SavedQuery.createRepeated)
    ..a(40, 'isAlwaysQuery', GeneratedMessage.OB)
    ..a(41, 'defaultQuery', GeneratedMessage.OM, SavedQuery.create, SavedQuery.create)
    ..a(44, 'isGridFind', GeneratedMessage.OB, true)
    ..a(45, 'isIncludeStats', GeneratedMessage.OB, true)
    ..m(50, 'filter', DFilter.create, DFilter.createRepeated)
    ..m(51, 'sort', DSort.create, DSort.createRepeated)
  ;

  UI() : super();
  UI.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  UI.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  UI clone() => new UI()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static UI create() => new UI();
  static PbList<UI> createRepeated() => new PbList<UI>();

  String get uiId => getField(1);
  void set uiId(String v) { setField(1, v); }
  bool hasUiId() => hasField(1);
  void clearUiId() => clearField(1);

  String get name => getField(2);
  void set name(String v) { setField(2, v); }
  bool hasName() => hasField(2);
  void clearName() => clearField(2);

  String get label => getField(3);
  void set label(String v) { setField(3, v); }
  bool hasLabel() => hasField(3);
  void clearLabel() => clearField(3);

  String get description => getField(4);
  void set description(String v) { setField(4, v); }
  bool hasDescription() => hasField(4);
  void clearDescription() => clearField(4);

  String get tenantId => getField(5);
  void set tenantId(String v) { setField(5, v); }
  bool hasTenantId() => hasField(5);
  void clearTenantId() => clearField(5);

  String get roleId => getField(6);
  void set roleId(String v) { setField(6, v); }
  bool hasRoleId() => hasField(6);
  void clearRoleId() => clearField(6);

  String get userId => getField(7);
  void set userId(String v) { setField(7, v); }
  bool hasUserId() => hasField(7);
  void clearUserId() => clearField(7);

  String get etag => getField(8);
  void set etag(String v) { setField(8, v); }
  bool hasEtag() => hasField(8);
  void clearEtag() => clearField(8);

  List<UIInfo> get displayList => getField(9);

  DTable get table => getField(10);
  void set table(DTable v) { setField(10, v); }
  bool hasTable() => hasField(10);
  void clearTable() => clearField(10);

  String get tableId => getField(11);
  void set tableId(String v) { setField(11, v); }
  bool hasTableId() => hasField(11);
  void clearTableId() => clearField(11);

  String get tableName => getField(12);
  void set tableName(String v) { setField(12, v); }
  bool hasTableName() => hasField(12);
  void clearTableName() => clearField(12);

  String get externalKey => getField(13);
  void set externalKey(String v) { setField(13, v); }
  bool hasExternalKey() => hasField(13);
  void clearExternalKey() => clearField(13);

  bool get isCanDelete => getField(15);
  void set isCanDelete(bool v) { setField(15, v); }
  bool hasIsCanDelete() => hasField(15);
  void clearIsCanDelete() => clearField(15);

  bool get isCanInsert => getField(16);
  void set isCanInsert(bool v) { setField(16, v); }
  bool hasIsCanInsert() => hasField(16);
  void clearIsCanInsert() => clearField(16);

  bool get isReadOnly => getField(17);
  void set isReadOnly(bool v) { setField(17, v); }
  bool hasIsReadOnly() => hasField(17);
  void clearIsReadOnly() => clearField(17);

  bool get isDefaultGridMode => getField(20);
  void set isDefaultGridMode(bool v) { setField(20, v); }
  bool hasIsDefaultGridMode() => hasField(20);
  void clearIsDefaultGridMode() => clearField(20);

  bool get isShowIndicators => getField(21);
  void set isShowIndicators(bool v) { setField(21, v); }
  bool hasIsShowIndicators() => hasField(21);
  void clearIsShowIndicators() => clearField(21);

  String get gridType => getField(22);
  void set gridType(String v) { setField(22, v); }
  bool hasGridType() => hasField(22);
  void clearGridType() => clearField(22);

  bool get isShowGraph => getField(25);
  void set isShowGraph(bool v) { setField(25, v); }
  bool hasIsShowGraph() => hasField(25);
  void clearIsShowGraph() => clearField(25);

  String get graphType => getField(26);
  void set graphType(String v) { setField(26, v); }
  bool hasGraphType() => hasField(26);
  void clearGraphType() => clearField(26);

  String get graphWhat => getField(27);
  void set graphWhat(String v) { setField(27, v); }
  bool hasGraphWhat() => hasField(27);
  void clearGraphWhat() => clearField(27);

  String get graphBy => getField(28);
  void set graphBy(String v) { setField(28, v); }
  bool hasGraphBy() => hasField(28);
  void clearGraphBy() => clearField(28);

  List<UIGridColumn> get gridColumnList => getField(30);

  List<UIPanel> get panelList => getField(31);

  List<UIProcess> get processList => getField(32);

  List<UILink> get linkList => getField(33);

  List<UIQueryColumn> get queryColumnList => getField(34);

  List<SavedQuery> get savedQueryList => getField(35);

  bool get isAlwaysQuery => getField(40);
  void set isAlwaysQuery(bool v) { setField(40, v); }
  bool hasIsAlwaysQuery() => hasField(40);
  void clearIsAlwaysQuery() => clearField(40);

  SavedQuery get defaultQuery => getField(41);
  void set defaultQuery(SavedQuery v) { setField(41, v); }
  bool hasDefaultQuery() => hasField(41);
  void clearDefaultQuery() => clearField(41);

  bool get isGridFind => getField(44);
  void set isGridFind(bool v) { setField(44, v); }
  bool hasIsGridFind() => hasField(44);
  void clearIsGridFind() => clearField(44);

  bool get isIncludeStats => getField(45);
  void set isIncludeStats(bool v) { setField(45, v); }
  bool hasIsIncludeStats() => hasField(45);
  void clearIsIncludeStats() => clearField(45);

  List<DFilter> get filterList => getField(50);

  List<DSort> get sortList => getField(51);
}

class UIInfo extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('UIInfo')
    ..a(1, 'uiId', GeneratedMessage.OS)
    ..a(2, 'uiName', GeneratedMessage.OS)
    ..a(3, 'label', GeneratedMessage.OS)
    ..a(4, 'description', GeneratedMessage.OS)
    ..a(5, 'tableName', GeneratedMessage.OS)
    ..a(9, 'etag', GeneratedMessage.OS)
    ..a(10, 'withTable', GeneratedMessage.OB, true)
    ..a(15, 'iconImage', GeneratedMessage.OS)
    ..a(16, 'tenantId', GeneratedMessage.OS)
    ..a(17, 'roleId', GeneratedMessage.OS)
    ..a(18, 'userId', GeneratedMessage.OS)
    ..hasRequiredFields = false
  ;

  UIInfo() : super();
  UIInfo.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  UIInfo.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  UIInfo clone() => new UIInfo()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static UIInfo create() => new UIInfo();
  static PbList<UIInfo> createRepeated() => new PbList<UIInfo>();

  String get uiId => getField(1);
  void set uiId(String v) { setField(1, v); }
  bool hasUiId() => hasField(1);
  void clearUiId() => clearField(1);

  String get uiName => getField(2);
  void set uiName(String v) { setField(2, v); }
  bool hasUiName() => hasField(2);
  void clearUiName() => clearField(2);

  String get label => getField(3);
  void set label(String v) { setField(3, v); }
  bool hasLabel() => hasField(3);
  void clearLabel() => clearField(3);

  String get description => getField(4);
  void set description(String v) { setField(4, v); }
  bool hasDescription() => hasField(4);
  void clearDescription() => clearField(4);

  String get tableName => getField(5);
  void set tableName(String v) { setField(5, v); }
  bool hasTableName() => hasField(5);
  void clearTableName() => clearField(5);

  String get etag => getField(9);
  void set etag(String v) { setField(9, v); }
  bool hasEtag() => hasField(9);
  void clearEtag() => clearField(9);

  bool get withTable => getField(10);
  void set withTable(bool v) { setField(10, v); }
  bool hasWithTable() => hasField(10);
  void clearWithTable() => clearField(10);

  String get iconImage => getField(15);
  void set iconImage(String v) { setField(15, v); }
  bool hasIconImage() => hasField(15);
  void clearIconImage() => clearField(15);

  String get tenantId => getField(16);
  void set tenantId(String v) { setField(16, v); }
  bool hasTenantId() => hasField(16);
  void clearTenantId() => clearField(16);

  String get roleId => getField(17);
  void set roleId(String v) { setField(17, v); }
  bool hasRoleId() => hasField(17);
  void clearRoleId() => clearField(17);

  String get userId => getField(18);
  void set userId(String v) { setField(18, v); }
  bool hasUserId() => hasField(18);
  void clearUserId() => clearField(18);
}

class UIGridColumn extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('UIGridColumn')
    ..a(1, 'uiGridColumnId', GeneratedMessage.OS)
    ..a(2, 'column', GeneratedMessage.OM, DColumn.create, DColumn.create)
    ..a(3, 'columnId', GeneratedMessage.OS)
    ..a(4, 'columnName', GeneratedMessage.OS)
    ..a(5, 'seqNo', GeneratedMessage.O3)
    ..a(6, 'isActive', GeneratedMessage.OB, true)
    ..a(12, 'width', GeneratedMessage.O3)
    ..a(15, 'panelColumn', GeneratedMessage.OM, UIPanelColumn.create, UIPanelColumn.create)
    ..a(50, 'updateFlag', GeneratedMessage.OS)
  ;

  UIGridColumn() : super();
  UIGridColumn.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  UIGridColumn.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  UIGridColumn clone() => new UIGridColumn()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static UIGridColumn create() => new UIGridColumn();
  static PbList<UIGridColumn> createRepeated() => new PbList<UIGridColumn>();

  String get uiGridColumnId => getField(1);
  void set uiGridColumnId(String v) { setField(1, v); }
  bool hasUiGridColumnId() => hasField(1);
  void clearUiGridColumnId() => clearField(1);

  DColumn get column => getField(2);
  void set column(DColumn v) { setField(2, v); }
  bool hasColumn() => hasField(2);
  void clearColumn() => clearField(2);

  String get columnId => getField(3);
  void set columnId(String v) { setField(3, v); }
  bool hasColumnId() => hasField(3);
  void clearColumnId() => clearField(3);

  String get columnName => getField(4);
  void set columnName(String v) { setField(4, v); }
  bool hasColumnName() => hasField(4);
  void clearColumnName() => clearField(4);

  int get seqNo => getField(5);
  void set seqNo(int v) { setField(5, v); }
  bool hasSeqNo() => hasField(5);
  void clearSeqNo() => clearField(5);

  bool get isActive => getField(6);
  void set isActive(bool v) { setField(6, v); }
  bool hasIsActive() => hasField(6);
  void clearIsActive() => clearField(6);

  int get width => getField(12);
  void set width(int v) { setField(12, v); }
  bool hasWidth() => hasField(12);
  void clearWidth() => clearField(12);

  UIPanelColumn get panelColumn => getField(15);
  void set panelColumn(UIPanelColumn v) { setField(15, v); }
  bool hasPanelColumn() => hasField(15);
  void clearPanelColumn() => clearField(15);

  String get updateFlag => getField(50);
  void set updateFlag(String v) { setField(50, v); }
  bool hasUpdateFlag() => hasField(50);
  void clearUpdateFlag() => clearField(50);
}

class UIPanel extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('UIPanel')
    ..a(1, 'uiPanelId', GeneratedMessage.OS)
    ..a(2, 'name', GeneratedMessage.QS)
    ..a(4, 'description', GeneratedMessage.OS)
    ..a(5, 'help', GeneratedMessage.OS)
    ..a(6, 'tutorialUrl', GeneratedMessage.OS)
    ..a(7, 'isActive', GeneratedMessage.OB, true)
    ..a(8, 'isExpert', GeneratedMessage.OB)
    ..a(9, 'iconClass', GeneratedMessage.OS)
    ..a(10, 'seqNo', GeneratedMessage.O3)
    ..e(11, 'type', GeneratedMessage.OE, UIPanelType.DISPLAYED, (var v) => UIPanelType.valueOf(v))
    ..e(12, 'labelPosition', GeneratedMessage.OE, UILabelPosition.LEFT, (var v) => UILabelPosition.valueOf(v))
    ..a(13, 'fieldInputWidth', GeneratedMessage.O3, 8)
    ..a(15, 'displayLogic', GeneratedMessage.OS)
    ..a(16, 'panelColumnNumber', GeneratedMessage.O3, 2)
    ..m(20, 'panelColumn', UIPanelColumn.create, UIPanelColumn.createRepeated)
    ..a(50, 'updateFlag', GeneratedMessage.OS)
  ;

  UIPanel() : super();
  UIPanel.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  UIPanel.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  UIPanel clone() => new UIPanel()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static UIPanel create() => new UIPanel();
  static PbList<UIPanel> createRepeated() => new PbList<UIPanel>();

  String get uiPanelId => getField(1);
  void set uiPanelId(String v) { setField(1, v); }
  bool hasUiPanelId() => hasField(1);
  void clearUiPanelId() => clearField(1);

  String get name => getField(2);
  void set name(String v) { setField(2, v); }
  bool hasName() => hasField(2);
  void clearName() => clearField(2);

  String get description => getField(4);
  void set description(String v) { setField(4, v); }
  bool hasDescription() => hasField(4);
  void clearDescription() => clearField(4);

  String get help => getField(5);
  void set help(String v) { setField(5, v); }
  bool hasHelp() => hasField(5);
  void clearHelp() => clearField(5);

  String get tutorialUrl => getField(6);
  void set tutorialUrl(String v) { setField(6, v); }
  bool hasTutorialUrl() => hasField(6);
  void clearTutorialUrl() => clearField(6);

  bool get isActive => getField(7);
  void set isActive(bool v) { setField(7, v); }
  bool hasIsActive() => hasField(7);
  void clearIsActive() => clearField(7);

  bool get isExpert => getField(8);
  void set isExpert(bool v) { setField(8, v); }
  bool hasIsExpert() => hasField(8);
  void clearIsExpert() => clearField(8);

  String get iconClass => getField(9);
  void set iconClass(String v) { setField(9, v); }
  bool hasIconClass() => hasField(9);
  void clearIconClass() => clearField(9);

  int get seqNo => getField(10);
  void set seqNo(int v) { setField(10, v); }
  bool hasSeqNo() => hasField(10);
  void clearSeqNo() => clearField(10);

  UIPanelType get type => getField(11);
  void set type(UIPanelType v) { setField(11, v); }
  bool hasType() => hasField(11);
  void clearType() => clearField(11);

  UILabelPosition get labelPosition => getField(12);
  void set labelPosition(UILabelPosition v) { setField(12, v); }
  bool hasLabelPosition() => hasField(12);
  void clearLabelPosition() => clearField(12);

  int get fieldInputWidth => getField(13);
  void set fieldInputWidth(int v) { setField(13, v); }
  bool hasFieldInputWidth() => hasField(13);
  void clearFieldInputWidth() => clearField(13);

  String get displayLogic => getField(15);
  void set displayLogic(String v) { setField(15, v); }
  bool hasDisplayLogic() => hasField(15);
  void clearDisplayLogic() => clearField(15);

  int get panelColumnNumber => getField(16);
  void set panelColumnNumber(int v) { setField(16, v); }
  bool hasPanelColumnNumber() => hasField(16);
  void clearPanelColumnNumber() => clearField(16);

  List<UIPanelColumn> get panelColumnList => getField(20);

  String get updateFlag => getField(50);
  void set updateFlag(String v) { setField(50, v); }
  bool hasUpdateFlag() => hasField(50);
  void clearUpdateFlag() => clearField(50);
}

class UIPanelColumn extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('UIPanelColumn')
    ..a(1, 'uiPanelColumnId', GeneratedMessage.OS)
    ..a(2, 'column', GeneratedMessage.OM, DColumn.create, DColumn.create)
    ..a(3, 'columnId', GeneratedMessage.OS)
    ..a(4, 'columnName', GeneratedMessage.OS)
    ..a(5, 'isActive', GeneratedMessage.OB, true)
    ..a(6, 'externalKey', GeneratedMessage.OS)
    ..a(8, 'isExpert', GeneratedMessage.OB)
    ..a(10, 'seqNo', GeneratedMessage.O3)
    ..a(11, 'label', GeneratedMessage.OS)
    ..a(12, 'width', GeneratedMessage.O3, 1)
    ..a(13, 'height', GeneratedMessage.O3, 1)
    ..a(20, 'isNewRow', GeneratedMessage.OB)
    ..a(21, 'isReadOnly', GeneratedMessage.OB)
    ..a(22, 'isMandatory', GeneratedMessage.OB)
    ..a(25, 'displayLogic', GeneratedMessage.OS)
    ..a(26, 'readOnlyLogic', GeneratedMessage.OS)
    ..a(27, 'mandatoryLogic', GeneratedMessage.OS)
    ..a(28, 'isAlternativeDisplay', GeneratedMessage.OB)
    ..a(29, 'defaultValue', GeneratedMessage.OS)
    ..a(30, 'updateFlag', GeneratedMessage.OS)
  ;

  UIPanelColumn() : super();
  UIPanelColumn.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  UIPanelColumn.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  UIPanelColumn clone() => new UIPanelColumn()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static UIPanelColumn create() => new UIPanelColumn();
  static PbList<UIPanelColumn> createRepeated() => new PbList<UIPanelColumn>();

  String get uiPanelColumnId => getField(1);
  void set uiPanelColumnId(String v) { setField(1, v); }
  bool hasUiPanelColumnId() => hasField(1);
  void clearUiPanelColumnId() => clearField(1);

  DColumn get column => getField(2);
  void set column(DColumn v) { setField(2, v); }
  bool hasColumn() => hasField(2);
  void clearColumn() => clearField(2);

  String get columnId => getField(3);
  void set columnId(String v) { setField(3, v); }
  bool hasColumnId() => hasField(3);
  void clearColumnId() => clearField(3);

  String get columnName => getField(4);
  void set columnName(String v) { setField(4, v); }
  bool hasColumnName() => hasField(4);
  void clearColumnName() => clearField(4);

  bool get isActive => getField(5);
  void set isActive(bool v) { setField(5, v); }
  bool hasIsActive() => hasField(5);
  void clearIsActive() => clearField(5);

  String get externalKey => getField(6);
  void set externalKey(String v) { setField(6, v); }
  bool hasExternalKey() => hasField(6);
  void clearExternalKey() => clearField(6);

  bool get isExpert => getField(8);
  void set isExpert(bool v) { setField(8, v); }
  bool hasIsExpert() => hasField(8);
  void clearIsExpert() => clearField(8);

  int get seqNo => getField(10);
  void set seqNo(int v) { setField(10, v); }
  bool hasSeqNo() => hasField(10);
  void clearSeqNo() => clearField(10);

  String get label => getField(11);
  void set label(String v) { setField(11, v); }
  bool hasLabel() => hasField(11);
  void clearLabel() => clearField(11);

  int get width => getField(12);
  void set width(int v) { setField(12, v); }
  bool hasWidth() => hasField(12);
  void clearWidth() => clearField(12);

  int get height => getField(13);
  void set height(int v) { setField(13, v); }
  bool hasHeight() => hasField(13);
  void clearHeight() => clearField(13);

  bool get isNewRow => getField(20);
  void set isNewRow(bool v) { setField(20, v); }
  bool hasIsNewRow() => hasField(20);
  void clearIsNewRow() => clearField(20);

  bool get isReadOnly => getField(21);
  void set isReadOnly(bool v) { setField(21, v); }
  bool hasIsReadOnly() => hasField(21);
  void clearIsReadOnly() => clearField(21);

  bool get isMandatory => getField(22);
  void set isMandatory(bool v) { setField(22, v); }
  bool hasIsMandatory() => hasField(22);
  void clearIsMandatory() => clearField(22);

  String get displayLogic => getField(25);
  void set displayLogic(String v) { setField(25, v); }
  bool hasDisplayLogic() => hasField(25);
  void clearDisplayLogic() => clearField(25);

  String get readOnlyLogic => getField(26);
  void set readOnlyLogic(String v) { setField(26, v); }
  bool hasReadOnlyLogic() => hasField(26);
  void clearReadOnlyLogic() => clearField(26);

  String get mandatoryLogic => getField(27);
  void set mandatoryLogic(String v) { setField(27, v); }
  bool hasMandatoryLogic() => hasField(27);
  void clearMandatoryLogic() => clearField(27);

  bool get isAlternativeDisplay => getField(28);
  void set isAlternativeDisplay(bool v) { setField(28, v); }
  bool hasIsAlternativeDisplay() => hasField(28);
  void clearIsAlternativeDisplay() => clearField(28);

  String get defaultValue => getField(29);
  void set defaultValue(String v) { setField(29, v); }
  bool hasDefaultValue() => hasField(29);
  void clearDefaultValue() => clearField(29);

  String get updateFlag => getField(30);
  void set updateFlag(String v) { setField(30, v); }
  bool hasUpdateFlag() => hasField(30);
  void clearUpdateFlag() => clearField(30);
}

class UIProcess extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('UIProcess')
    ..a(1, 'uiProcessId', GeneratedMessage.OS)
    ..a(2, 'processId', GeneratedMessage.OS)
    ..a(3, 'name', GeneratedMessage.QS)
    ..a(4, 'processExternalKey', GeneratedMessage.OS)
    ..a(5, 'label', GeneratedMessage.OS)
    ..a(6, 'description', GeneratedMessage.OS)
    ..a(7, 'help', GeneratedMessage.OS)
    ..a(8, 'tutorialUrl', GeneratedMessage.OS)
    ..a(9, 'isActive', GeneratedMessage.OB, true)
    ..a(10, 'isExpert', GeneratedMessage.OB)
    ..a(11, 'seqNo', GeneratedMessage.O3)
    ..a(12, 'isInstanceMethod', GeneratedMessage.OB, true)
    ..a(13, 'isCallout', GeneratedMessage.OB)
    ..a(14, 'isMultiRecord', GeneratedMessage.OB)
    ..a(15, 'tableName', GeneratedMessage.OS)
    ..a(16, 'processTypeName', GeneratedMessage.OS)
    ..a(17, 'buttonStyle', GeneratedMessage.OS)
    ..a(18, 'iconImage', GeneratedMessage.OS)
    ..a(19, 'color', GeneratedMessage.OS)
    ..a(20, 'logic', GeneratedMessage.OS)
    ..a(21, 'webHookUrl', GeneratedMessage.OS)
    ..a(22, 'webLinkUrl', GeneratedMessage.OS)
    ..a(23, 'webLocation', GeneratedMessage.OS)
    ..m(29, 'parameter', DProperty.create, DProperty.createRepeated)
    ..a(30, 'updateFlag', GeneratedMessage.OS)
  ;

  UIProcess() : super();
  UIProcess.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  UIProcess.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  UIProcess clone() => new UIProcess()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static UIProcess create() => new UIProcess();
  static PbList<UIProcess> createRepeated() => new PbList<UIProcess>();

  String get uiProcessId => getField(1);
  void set uiProcessId(String v) { setField(1, v); }
  bool hasUiProcessId() => hasField(1);
  void clearUiProcessId() => clearField(1);

  String get processId => getField(2);
  void set processId(String v) { setField(2, v); }
  bool hasProcessId() => hasField(2);
  void clearProcessId() => clearField(2);

  String get name => getField(3);
  void set name(String v) { setField(3, v); }
  bool hasName() => hasField(3);
  void clearName() => clearField(3);

  String get processExternalKey => getField(4);
  void set processExternalKey(String v) { setField(4, v); }
  bool hasProcessExternalKey() => hasField(4);
  void clearProcessExternalKey() => clearField(4);

  String get label => getField(5);
  void set label(String v) { setField(5, v); }
  bool hasLabel() => hasField(5);
  void clearLabel() => clearField(5);

  String get description => getField(6);
  void set description(String v) { setField(6, v); }
  bool hasDescription() => hasField(6);
  void clearDescription() => clearField(6);

  String get help => getField(7);
  void set help(String v) { setField(7, v); }
  bool hasHelp() => hasField(7);
  void clearHelp() => clearField(7);

  String get tutorialUrl => getField(8);
  void set tutorialUrl(String v) { setField(8, v); }
  bool hasTutorialUrl() => hasField(8);
  void clearTutorialUrl() => clearField(8);

  bool get isActive => getField(9);
  void set isActive(bool v) { setField(9, v); }
  bool hasIsActive() => hasField(9);
  void clearIsActive() => clearField(9);

  bool get isExpert => getField(10);
  void set isExpert(bool v) { setField(10, v); }
  bool hasIsExpert() => hasField(10);
  void clearIsExpert() => clearField(10);

  int get seqNo => getField(11);
  void set seqNo(int v) { setField(11, v); }
  bool hasSeqNo() => hasField(11);
  void clearSeqNo() => clearField(11);

  bool get isInstanceMethod => getField(12);
  void set isInstanceMethod(bool v) { setField(12, v); }
  bool hasIsInstanceMethod() => hasField(12);
  void clearIsInstanceMethod() => clearField(12);

  bool get isCallout => getField(13);
  void set isCallout(bool v) { setField(13, v); }
  bool hasIsCallout() => hasField(13);
  void clearIsCallout() => clearField(13);

  bool get isMultiRecord => getField(14);
  void set isMultiRecord(bool v) { setField(14, v); }
  bool hasIsMultiRecord() => hasField(14);
  void clearIsMultiRecord() => clearField(14);

  String get tableName => getField(15);
  void set tableName(String v) { setField(15, v); }
  bool hasTableName() => hasField(15);
  void clearTableName() => clearField(15);

  String get processTypeName => getField(16);
  void set processTypeName(String v) { setField(16, v); }
  bool hasProcessTypeName() => hasField(16);
  void clearProcessTypeName() => clearField(16);

  String get buttonStyle => getField(17);
  void set buttonStyle(String v) { setField(17, v); }
  bool hasButtonStyle() => hasField(17);
  void clearButtonStyle() => clearField(17);

  String get iconImage => getField(18);
  void set iconImage(String v) { setField(18, v); }
  bool hasIconImage() => hasField(18);
  void clearIconImage() => clearField(18);

  String get color => getField(19);
  void set color(String v) { setField(19, v); }
  bool hasColor() => hasField(19);
  void clearColor() => clearField(19);

  String get logic => getField(20);
  void set logic(String v) { setField(20, v); }
  bool hasLogic() => hasField(20);
  void clearLogic() => clearField(20);

  String get webHookUrl => getField(21);
  void set webHookUrl(String v) { setField(21, v); }
  bool hasWebHookUrl() => hasField(21);
  void clearWebHookUrl() => clearField(21);

  String get webLinkUrl => getField(22);
  void set webLinkUrl(String v) { setField(22, v); }
  bool hasWebLinkUrl() => hasField(22);
  void clearWebLinkUrl() => clearField(22);

  String get webLocation => getField(23);
  void set webLocation(String v) { setField(23, v); }
  bool hasWebLocation() => hasField(23);
  void clearWebLocation() => clearField(23);

  List<DProperty> get parameterList => getField(29);

  String get updateFlag => getField(30);
  void set updateFlag(String v) { setField(30, v); }
  bool hasUpdateFlag() => hasField(30);
  void clearUpdateFlag() => clearField(30);
}

class UILink extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('UILink')
    ..a(1, 'uiLinkId', GeneratedMessage.OS)
    ..a(2, 'uiRelatedId', GeneratedMessage.OS)
    ..a(3, 'uiRelatedName', GeneratedMessage.OS)
    ..a(4, 'isActive', GeneratedMessage.OB, true)
    ..a(5, 'seqNo', GeneratedMessage.O3)
    ..a(8, 'isExpert', GeneratedMessage.OB)
    ..a(9, 'isChild', GeneratedMessage.OB)
    ..a(10, 'isPrimaryChild', GeneratedMessage.OB)
    ..a(12, 'isDisplayRecords', GeneratedMessage.OB)
    ..a(13, 'restrictionSql', GeneratedMessage.OS)
    ..a(20, 'uiName', GeneratedMessage.OS)
    ..a(21, 'label', GeneratedMessage.OS)
    ..a(22, 'description', GeneratedMessage.OS)
    ..a(23, 'tableName', GeneratedMessage.OS)
    ..a(24, 'etag', GeneratedMessage.OS)
    ..a(25, 'linkColumnName', GeneratedMessage.OS)
    ..a(26, 'iconImage', GeneratedMessage.OS)
    ..a(27, 'tenantId', GeneratedMessage.OS)
    ..a(28, 'roleId', GeneratedMessage.OS)
    ..a(29, 'userId', GeneratedMessage.OS)
    ..a(30, 'updateFlag', GeneratedMessage.OS)
    ..hasRequiredFields = false
  ;

  UILink() : super();
  UILink.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  UILink.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  UILink clone() => new UILink()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static UILink create() => new UILink();
  static PbList<UILink> createRepeated() => new PbList<UILink>();

  String get uiLinkId => getField(1);
  void set uiLinkId(String v) { setField(1, v); }
  bool hasUiLinkId() => hasField(1);
  void clearUiLinkId() => clearField(1);

  String get uiRelatedId => getField(2);
  void set uiRelatedId(String v) { setField(2, v); }
  bool hasUiRelatedId() => hasField(2);
  void clearUiRelatedId() => clearField(2);

  String get uiRelatedName => getField(3);
  void set uiRelatedName(String v) { setField(3, v); }
  bool hasUiRelatedName() => hasField(3);
  void clearUiRelatedName() => clearField(3);

  bool get isActive => getField(4);
  void set isActive(bool v) { setField(4, v); }
  bool hasIsActive() => hasField(4);
  void clearIsActive() => clearField(4);

  int get seqNo => getField(5);
  void set seqNo(int v) { setField(5, v); }
  bool hasSeqNo() => hasField(5);
  void clearSeqNo() => clearField(5);

  bool get isExpert => getField(8);
  void set isExpert(bool v) { setField(8, v); }
  bool hasIsExpert() => hasField(8);
  void clearIsExpert() => clearField(8);

  bool get isChild => getField(9);
  void set isChild(bool v) { setField(9, v); }
  bool hasIsChild() => hasField(9);
  void clearIsChild() => clearField(9);

  bool get isPrimaryChild => getField(10);
  void set isPrimaryChild(bool v) { setField(10, v); }
  bool hasIsPrimaryChild() => hasField(10);
  void clearIsPrimaryChild() => clearField(10);

  bool get isDisplayRecords => getField(12);
  void set isDisplayRecords(bool v) { setField(12, v); }
  bool hasIsDisplayRecords() => hasField(12);
  void clearIsDisplayRecords() => clearField(12);

  String get restrictionSql => getField(13);
  void set restrictionSql(String v) { setField(13, v); }
  bool hasRestrictionSql() => hasField(13);
  void clearRestrictionSql() => clearField(13);

  String get uiName => getField(20);
  void set uiName(String v) { setField(20, v); }
  bool hasUiName() => hasField(20);
  void clearUiName() => clearField(20);

  String get label => getField(21);
  void set label(String v) { setField(21, v); }
  bool hasLabel() => hasField(21);
  void clearLabel() => clearField(21);

  String get description => getField(22);
  void set description(String v) { setField(22, v); }
  bool hasDescription() => hasField(22);
  void clearDescription() => clearField(22);

  String get tableName => getField(23);
  void set tableName(String v) { setField(23, v); }
  bool hasTableName() => hasField(23);
  void clearTableName() => clearField(23);

  String get etag => getField(24);
  void set etag(String v) { setField(24, v); }
  bool hasEtag() => hasField(24);
  void clearEtag() => clearField(24);

  String get linkColumnName => getField(25);
  void set linkColumnName(String v) { setField(25, v); }
  bool hasLinkColumnName() => hasField(25);
  void clearLinkColumnName() => clearField(25);

  String get iconImage => getField(26);
  void set iconImage(String v) { setField(26, v); }
  bool hasIconImage() => hasField(26);
  void clearIconImage() => clearField(26);

  String get tenantId => getField(27);
  void set tenantId(String v) { setField(27, v); }
  bool hasTenantId() => hasField(27);
  void clearTenantId() => clearField(27);

  String get roleId => getField(28);
  void set roleId(String v) { setField(28, v); }
  bool hasRoleId() => hasField(28);
  void clearRoleId() => clearField(28);

  String get userId => getField(29);
  void set userId(String v) { setField(29, v); }
  bool hasUserId() => hasField(29);
  void clearUserId() => clearField(29);

  String get updateFlag => getField(30);
  void set updateFlag(String v) { setField(30, v); }
  bool hasUpdateFlag() => hasField(30);
  void clearUpdateFlag() => clearField(30);
}

class UIQueryColumn extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('UIQueryColumn')
    ..a(1, 'uiQueryColumnId', GeneratedMessage.OS)
    ..a(2, 'column', GeneratedMessage.OM, DColumn.create, DColumn.create)
    ..a(3, 'columnId', GeneratedMessage.OS)
    ..a(4, 'columnName', GeneratedMessage.OS)
    ..a(6, 'isActive', GeneratedMessage.OB, true)
    ..a(10, 'seqNo', GeneratedMessage.O3)
    ..a(11, 'isParent', GeneratedMessage.OB)
    ..a(50, 'updateFlag', GeneratedMessage.OS)
  ;

  UIQueryColumn() : super();
  UIQueryColumn.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  UIQueryColumn.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  UIQueryColumn clone() => new UIQueryColumn()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static UIQueryColumn create() => new UIQueryColumn();
  static PbList<UIQueryColumn> createRepeated() => new PbList<UIQueryColumn>();

  String get uiQueryColumnId => getField(1);
  void set uiQueryColumnId(String v) { setField(1, v); }
  bool hasUiQueryColumnId() => hasField(1);
  void clearUiQueryColumnId() => clearField(1);

  DColumn get column => getField(2);
  void set column(DColumn v) { setField(2, v); }
  bool hasColumn() => hasField(2);
  void clearColumn() => clearField(2);

  String get columnId => getField(3);
  void set columnId(String v) { setField(3, v); }
  bool hasColumnId() => hasField(3);
  void clearColumnId() => clearField(3);

  String get columnName => getField(4);
  void set columnName(String v) { setField(4, v); }
  bool hasColumnName() => hasField(4);
  void clearColumnName() => clearField(4);

  bool get isActive => getField(6);
  void set isActive(bool v) { setField(6, v); }
  bool hasIsActive() => hasField(6);
  void clearIsActive() => clearField(6);

  int get seqNo => getField(10);
  void set seqNo(int v) { setField(10, v); }
  bool hasSeqNo() => hasField(10);
  void clearSeqNo() => clearField(10);

  bool get isParent => getField(11);
  void set isParent(bool v) { setField(11, v); }
  bool hasIsParent() => hasField(11);
  void clearIsParent() => clearField(11);

  String get updateFlag => getField(50);
  void set updateFlag(String v) { setField(50, v); }
  bool hasUpdateFlag() => hasField(50);
  void clearUpdateFlag() => clearField(50);
}

