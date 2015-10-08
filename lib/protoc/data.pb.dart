/**
 * Generated Protocol Buffers code. Do not modify.
 */
library protoc.data;

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart';
import 'structure.pb.dart';

class DOP extends ProtobufEnum {
  static const DOP EQ = const DOP._(1, 'EQ');
  static const DOP NE = const DOP._(2, 'NE');
  static const DOP GE = const DOP._(3, 'GE');
  static const DOP GT = const DOP._(4, 'GT');
  static const DOP LE = const DOP._(5, 'LE');
  static const DOP LT = const DOP._(6, 'LT');
  static const DOP ISNULL = const DOP._(7, 'ISNULL');
  static const DOP NOTNULL = const DOP._(8, 'NOTNULL');
  static const DOP LIKE = const DOP._(9, 'LIKE');
  static const DOP NOTLIKE = const DOP._(10, 'NOTLIKE');
  static const DOP IN = const DOP._(11, 'IN');
  static const DOP NOTIN = const DOP._(12, 'NOTIN');
  static const DOP BETWEEN = const DOP._(13, 'BETWEEN');
  static const DOP URV = const DOP._(15, 'URV');
  static const DOP SQL = const DOP._(16, 'SQL');
  static const DOP D_DAY = const DOP._(20, 'D_DAY');
  static const DOP D_WEEK = const DOP._(21, 'D_WEEK');
  static const DOP D_MONTH = const DOP._(22, 'D_MONTH');
  static const DOP D_QUARTER = const DOP._(23, 'D_QUARTER');
  static const DOP D_YEAR = const DOP._(24, 'D_YEAR');
  static const DOP D_LAST = const DOP._(30, 'D_LAST');
  static const DOP D_THIS = const DOP._(31, 'D_THIS');
  static const DOP D_NEXT = const DOP._(32, 'D_NEXT');

  static const List<DOP> values = const <DOP> [
    EQ,
    NE,
    GE,
    GT,
    LE,
    LT,
    ISNULL,
    NOTNULL,
    LIKE,
    NOTLIKE,
    IN,
    NOTIN,
    BETWEEN,
    URV,
    SQL,
    D_DAY,
    D_WEEK,
    D_MONTH,
    D_QUARTER,
    D_YEAR,
    D_LAST,
    D_THIS,
    D_NEXT,
  ];

  static final Map<int, DOP> _byValue = ProtobufEnum.initByValue(values);
  static DOP valueOf(int value) => _byValue[value];
  static void $checkItem(DOP v) {
    if (v is !DOP) checkItemFailed(v, 'DOP');
  }

  const DOP._(int v, String n) : super(v, n);
}

class DRecord extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DRecord')
    ..a(1, 'recordId', PbFieldType.OS)
    ..a(2, 'tableId', PbFieldType.OS)
    ..a(3, 'tableName', PbFieldType.OS)
    ..a(4, 'urv', PbFieldType.OS)
    ..a(5, 'urvRest', PbFieldType.OS)
    ..a(6, 'drv', PbFieldType.OS)
    ..a(7, 'revision', PbFieldType.OS)
    ..a(8, 'who', PbFieldType.OS)
    ..a(9, 'query', PbFieldType.OS)
    ..a(10, 'etag', PbFieldType.OS)
    ..a(11, 'svrMsg', PbFieldType.OS)
    ..a(12, 'isChanged', PbFieldType.OB)
    ..a(13, 'isReadOnly', PbFieldType.OB)
    ..a(16, 'isReadOnlyCalc', PbFieldType.OB)
    ..a(17, 'isMandatoryCalc', PbFieldType.OB)
    ..a(18, 'isSelected', PbFieldType.OB)
    ..a(19, 'isMatchFind', PbFieldType.OB)
    ..pp(20, 'entry', PbFieldType.PM, DEntry.$checkItem, DEntry.create)
    ..a(21, 'parent', PbFieldType.OM, DRecord.getDefault, DRecord.create)
    ..a(22, 'isGroupBy', PbFieldType.OB)
    ..pp(23, 'stat', PbFieldType.PM, DStatistics.$checkItem, DStatistics.create)
    ..hasRequiredFields = false
  ;

  DRecord() : super();
  DRecord.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DRecord.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DRecord clone() => new DRecord()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DRecord create() => new DRecord();
  static PbList<DRecord> createRepeated() => new PbList<DRecord>();
  static DRecord getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyDRecord();
    return _defaultInstance;
  }
  static DRecord _defaultInstance;
  static void $checkItem(DRecord v) {
    if (v is !DRecord) checkItemFailed(v, 'DRecord');
  }

  String get recordId => $_get(0, 1, '');
  void set recordId(String v) { $_setString(0, 1, v); }
  bool hasRecordId() => $_has(0, 1);
  void clearRecordId() => clearField(1);

  String get tableId => $_get(1, 2, '');
  void set tableId(String v) { $_setString(1, 2, v); }
  bool hasTableId() => $_has(1, 2);
  void clearTableId() => clearField(2);

  String get tableName => $_get(2, 3, '');
  void set tableName(String v) { $_setString(2, 3, v); }
  bool hasTableName() => $_has(2, 3);
  void clearTableName() => clearField(3);

  String get urv => $_get(3, 4, '');
  void set urv(String v) { $_setString(3, 4, v); }
  bool hasUrv() => $_has(3, 4);
  void clearUrv() => clearField(4);

  String get urvRest => $_get(4, 5, '');
  void set urvRest(String v) { $_setString(4, 5, v); }
  bool hasUrvRest() => $_has(4, 5);
  void clearUrvRest() => clearField(5);

  String get drv => $_get(5, 6, '');
  void set drv(String v) { $_setString(5, 6, v); }
  bool hasDrv() => $_has(5, 6);
  void clearDrv() => clearField(6);

  String get revision => $_get(6, 7, '');
  void set revision(String v) { $_setString(6, 7, v); }
  bool hasRevision() => $_has(6, 7);
  void clearRevision() => clearField(7);

  String get who => $_get(7, 8, '');
  void set who(String v) { $_setString(7, 8, v); }
  bool hasWho() => $_has(7, 8);
  void clearWho() => clearField(8);

  String get query => $_get(8, 9, '');
  void set query(String v) { $_setString(8, 9, v); }
  bool hasQuery() => $_has(8, 9);
  void clearQuery() => clearField(9);

  String get etag => $_get(9, 10, '');
  void set etag(String v) { $_setString(9, 10, v); }
  bool hasEtag() => $_has(9, 10);
  void clearEtag() => clearField(10);

  String get svrMsg => $_get(10, 11, '');
  void set svrMsg(String v) { $_setString(10, 11, v); }
  bool hasSvrMsg() => $_has(10, 11);
  void clearSvrMsg() => clearField(11);

  bool get isChanged => $_get(11, 12, false);
  void set isChanged(bool v) { $_setBool(11, 12, v); }
  bool hasIsChanged() => $_has(11, 12);
  void clearIsChanged() => clearField(12);

  bool get isReadOnly => $_get(12, 13, false);
  void set isReadOnly(bool v) { $_setBool(12, 13, v); }
  bool hasIsReadOnly() => $_has(12, 13);
  void clearIsReadOnly() => clearField(13);

  bool get isReadOnlyCalc => $_get(13, 16, false);
  void set isReadOnlyCalc(bool v) { $_setBool(13, 16, v); }
  bool hasIsReadOnlyCalc() => $_has(13, 16);
  void clearIsReadOnlyCalc() => clearField(16);

  bool get isMandatoryCalc => $_get(14, 17, false);
  void set isMandatoryCalc(bool v) { $_setBool(14, 17, v); }
  bool hasIsMandatoryCalc() => $_has(14, 17);
  void clearIsMandatoryCalc() => clearField(17);

  bool get isSelected => $_get(15, 18, false);
  void set isSelected(bool v) { $_setBool(15, 18, v); }
  bool hasIsSelected() => $_has(15, 18);
  void clearIsSelected() => clearField(18);

  bool get isMatchFind => $_get(16, 19, false);
  void set isMatchFind(bool v) { $_setBool(16, 19, v); }
  bool hasIsMatchFind() => $_has(16, 19);
  void clearIsMatchFind() => clearField(19);

  List<DEntry> get entryList => $_get(17, 20, null);

  DRecord get parent => $_get(18, 21, null);
  void set parent(DRecord v) { setField(21, v); }
  bool hasParent() => $_has(18, 21);
  void clearParent() => clearField(21);

  bool get isGroupBy => $_get(19, 22, false);
  void set isGroupBy(bool v) { $_setBool(19, 22, v); }
  bool hasIsGroupBy() => $_has(19, 22);
  void clearIsGroupBy() => clearField(22);

  List<DStatistics> get statList => $_get(20, 23, null);
}

class _ReadonlyDRecord extends DRecord with ReadonlyMessageMixin {}

class DEntry extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DEntry')
    ..a(1, 'columnId', PbFieldType.OS)
    ..a(2, 'columnName', PbFieldType.OS)
    ..a(3, 'value', PbFieldType.OS)
    ..a(4, 'isChanged', PbFieldType.OB)
    ..a(5, 'valueOriginal', PbFieldType.OS)
    ..a(6, 'valueDisplay', PbFieldType.OS)
    ..hasRequiredFields = false
  ;

  DEntry() : super();
  DEntry.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DEntry.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DEntry clone() => new DEntry()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DEntry create() => new DEntry();
  static PbList<DEntry> createRepeated() => new PbList<DEntry>();
  static DEntry getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyDEntry();
    return _defaultInstance;
  }
  static DEntry _defaultInstance;
  static void $checkItem(DEntry v) {
    if (v is !DEntry) checkItemFailed(v, 'DEntry');
  }

  String get columnId => $_get(0, 1, '');
  void set columnId(String v) { $_setString(0, 1, v); }
  bool hasColumnId() => $_has(0, 1);
  void clearColumnId() => clearField(1);

  String get columnName => $_get(1, 2, '');
  void set columnName(String v) { $_setString(1, 2, v); }
  bool hasColumnName() => $_has(1, 2);
  void clearColumnName() => clearField(2);

  String get value => $_get(2, 3, '');
  void set value(String v) { $_setString(2, 3, v); }
  bool hasValue() => $_has(2, 3);
  void clearValue() => clearField(3);

  bool get isChanged => $_get(3, 4, false);
  void set isChanged(bool v) { $_setBool(3, 4, v); }
  bool hasIsChanged() => $_has(3, 4);
  void clearIsChanged() => clearField(4);

  String get valueOriginal => $_get(4, 5, '');
  void set valueOriginal(String v) { $_setString(4, 5, v); }
  bool hasValueOriginal() => $_has(4, 5);
  void clearValueOriginal() => clearField(5);

  String get valueDisplay => $_get(5, 6, '');
  void set valueDisplay(String v) { $_setString(5, 6, v); }
  bool hasValueDisplay() => $_has(5, 6);
  void clearValueDisplay() => clearField(6);
}

class _ReadonlyDEntry extends DEntry with ReadonlyMessageMixin {}

class DStatistics extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DStatistics')
    ..a(1, 'columnId', PbFieldType.OS)
    ..a(2, 'columnName', PbFieldType.OS)
    ..a(3, 'isLocal', PbFieldType.OB)
    ..a(5, 'countTotal', PbFieldType.O3)
    ..a(6, 'countNotNull', PbFieldType.O3)
    ..a(10, 'minValue', PbFieldType.OD)
    ..a(11, 'maxValue', PbFieldType.OD)
    ..a(15, 'sumValue', PbFieldType.OD)
    ..a(16, 'avgValue', PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  DStatistics() : super();
  DStatistics.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DStatistics.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DStatistics clone() => new DStatistics()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DStatistics create() => new DStatistics();
  static PbList<DStatistics> createRepeated() => new PbList<DStatistics>();
  static DStatistics getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyDStatistics();
    return _defaultInstance;
  }
  static DStatistics _defaultInstance;
  static void $checkItem(DStatistics v) {
    if (v is !DStatistics) checkItemFailed(v, 'DStatistics');
  }

  String get columnId => $_get(0, 1, '');
  void set columnId(String v) { $_setString(0, 1, v); }
  bool hasColumnId() => $_has(0, 1);
  void clearColumnId() => clearField(1);

  String get columnName => $_get(1, 2, '');
  void set columnName(String v) { $_setString(1, 2, v); }
  bool hasColumnName() => $_has(1, 2);
  void clearColumnName() => clearField(2);

  bool get isLocal => $_get(2, 3, false);
  void set isLocal(bool v) { $_setBool(2, 3, v); }
  bool hasIsLocal() => $_has(2, 3);
  void clearIsLocal() => clearField(3);

  int get countTotal => $_get(3, 5, 0);
  void set countTotal(int v) { $_setUnsignedInt32(3, 5, v); }
  bool hasCountTotal() => $_has(3, 5);
  void clearCountTotal() => clearField(5);

  int get countNotNull => $_get(4, 6, 0);
  void set countNotNull(int v) { $_setUnsignedInt32(4, 6, v); }
  bool hasCountNotNull() => $_has(4, 6);
  void clearCountNotNull() => clearField(6);

  double get minValue => $_get(5, 10, null);
  void set minValue(double v) { $_setDouble(5, 10, v); }
  bool hasMinValue() => $_has(5, 10);
  void clearMinValue() => clearField(10);

  double get maxValue => $_get(6, 11, null);
  void set maxValue(double v) { $_setDouble(6, 11, v); }
  bool hasMaxValue() => $_has(6, 11);
  void clearMaxValue() => clearField(11);

  double get sumValue => $_get(7, 15, null);
  void set sumValue(double v) { $_setDouble(7, 15, v); }
  bool hasSumValue() => $_has(7, 15);
  void clearSumValue() => clearField(15);

  double get avgValue => $_get(8, 16, null);
  void set avgValue(double v) { $_setDouble(8, 16, v); }
  bool hasAvgValue() => $_has(8, 16);
  void clearAvgValue() => clearField(16);
}

class _ReadonlyDStatistics extends DStatistics with ReadonlyMessageMixin {}

class DFilter extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DFilter')
    ..a(1, 'columnName', PbFieldType.QS)
    ..e(2, 'operation', PbFieldType.QE, DOP.EQ, DOP.valueOf)
    ..e(3, 'operationDate', PbFieldType.OE, DOP.EQ, DOP.valueOf)
    ..e(4, 'dataType', PbFieldType.OE, DataType.STRING, DataType.valueOf)
    ..a(5, 'filterValue', PbFieldType.OS)
    ..a(6, 'filterValueTo', PbFieldType.OS)
    ..p(7, 'filterIn', PbFieldType.PS)
    ..a(10, 'isReadOnly', PbFieldType.OB)
    ..a(11, 'filterDirectQuery', PbFieldType.OS)
  ;

  DFilter() : super();
  DFilter.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DFilter.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DFilter clone() => new DFilter()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DFilter create() => new DFilter();
  static PbList<DFilter> createRepeated() => new PbList<DFilter>();
  static DFilter getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyDFilter();
    return _defaultInstance;
  }
  static DFilter _defaultInstance;
  static void $checkItem(DFilter v) {
    if (v is !DFilter) checkItemFailed(v, 'DFilter');
  }

  String get columnName => $_get(0, 1, '');
  void set columnName(String v) { $_setString(0, 1, v); }
  bool hasColumnName() => $_has(0, 1);
  void clearColumnName() => clearField(1);

  DOP get operation => $_get(1, 2, null);
  void set operation(DOP v) { setField(2, v); }
  bool hasOperation() => $_has(1, 2);
  void clearOperation() => clearField(2);

  DOP get operationDate => $_get(2, 3, null);
  void set operationDate(DOP v) { setField(3, v); }
  bool hasOperationDate() => $_has(2, 3);
  void clearOperationDate() => clearField(3);

  DataType get dataType => $_get(3, 4, null);
  void set dataType(DataType v) { setField(4, v); }
  bool hasDataType() => $_has(3, 4);
  void clearDataType() => clearField(4);

  String get filterValue => $_get(4, 5, '');
  void set filterValue(String v) { $_setString(4, 5, v); }
  bool hasFilterValue() => $_has(4, 5);
  void clearFilterValue() => clearField(5);

  String get filterValueTo => $_get(5, 6, '');
  void set filterValueTo(String v) { $_setString(5, 6, v); }
  bool hasFilterValueTo() => $_has(5, 6);
  void clearFilterValueTo() => clearField(6);

  List<String> get filterInList => $_get(6, 7, null);

  bool get isReadOnly => $_get(7, 10, false);
  void set isReadOnly(bool v) { $_setBool(7, 10, v); }
  bool hasIsReadOnly() => $_has(7, 10);
  void clearIsReadOnly() => clearField(10);

  String get filterDirectQuery => $_get(8, 11, '');
  void set filterDirectQuery(String v) { $_setString(8, 11, v); }
  bool hasFilterDirectQuery() => $_has(8, 11);
  void clearFilterDirectQuery() => clearField(11);
}

class _ReadonlyDFilter extends DFilter with ReadonlyMessageMixin {}

class DSort extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DSort')
    ..a(1, 'columnName', PbFieldType.QS)
    ..a(2, 'isAscending', PbFieldType.OB, true)
    ..a(3, 'isGroupBy', PbFieldType.OB)
  ;

  DSort() : super();
  DSort.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DSort.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DSort clone() => new DSort()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DSort create() => new DSort();
  static PbList<DSort> createRepeated() => new PbList<DSort>();
  static DSort getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyDSort();
    return _defaultInstance;
  }
  static DSort _defaultInstance;
  static void $checkItem(DSort v) {
    if (v is !DSort) checkItemFailed(v, 'DSort');
  }

  String get columnName => $_get(0, 1, '');
  void set columnName(String v) { $_setString(0, 1, v); }
  bool hasColumnName() => $_has(0, 1);
  void clearColumnName() => clearField(1);

  bool get isAscending => $_get(1, 2, true);
  void set isAscending(bool v) { $_setBool(1, 2, v); }
  bool hasIsAscending() => $_has(1, 2);
  void clearIsAscending() => clearField(2);

  bool get isGroupBy => $_get(2, 3, false);
  void set isGroupBy(bool v) { $_setBool(2, 3, v); }
  bool hasIsGroupBy() => $_has(2, 3);
  void clearIsGroupBy() => clearField(3);
}

class _ReadonlyDSort extends DSort with ReadonlyMessageMixin {}

class DFK extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DFK')
    ..a(1, 'id', PbFieldType.QS)
    ..a(2, 'drv', PbFieldType.OS)
    ..a(3, 'urv', PbFieldType.OS)
    ..a(4, 'tableName', PbFieldType.OS)
  ;

  DFK() : super();
  DFK.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DFK.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DFK clone() => new DFK()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DFK create() => new DFK();
  static PbList<DFK> createRepeated() => new PbList<DFK>();
  static DFK getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyDFK();
    return _defaultInstance;
  }
  static DFK _defaultInstance;
  static void $checkItem(DFK v) {
    if (v is !DFK) checkItemFailed(v, 'DFK');
  }

  String get id => $_get(0, 1, '');
  void set id(String v) { $_setString(0, 1, v); }
  bool hasId() => $_has(0, 1);
  void clearId() => clearField(1);

  String get drv => $_get(1, 2, '');
  void set drv(String v) { $_setString(1, 2, v); }
  bool hasDrv() => $_has(1, 2);
  void clearDrv() => clearField(2);

  String get urv => $_get(2, 3, '');
  void set urv(String v) { $_setString(2, 3, v); }
  bool hasUrv() => $_has(2, 3);
  void clearUrv() => clearField(3);

  String get tableName => $_get(3, 4, '');
  void set tableName(String v) { $_setString(3, 4, v); }
  bool hasTableName() => $_has(3, 4);
  void clearTableName() => clearField(4);
}

class _ReadonlyDFK extends DFK with ReadonlyMessageMixin {}

class SavedQuery extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('SavedQuery')
    ..a(1, 'savedQueryId', PbFieldType.OS)
    ..a(2, 'name', PbFieldType.QS)
    ..a(3, 'description', PbFieldType.OS)
    ..a(4, 'tableName', PbFieldType.QS)
    ..a(5, 'userId', PbFieldType.OS)
    ..a(6, 'isDefault', PbFieldType.OB)
    ..a(9, 'sqlWhere', PbFieldType.OS)
    ..pp(10, 'filter', PbFieldType.PM, DFilter.$checkItem, DFilter.create)
    ..a(11, 'filterLogic', PbFieldType.OS)
    ..pp(13, 'sort', PbFieldType.PM, DSort.$checkItem, DSort.create)
  ;

  SavedQuery() : super();
  SavedQuery.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  SavedQuery.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  SavedQuery clone() => new SavedQuery()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static SavedQuery create() => new SavedQuery();
  static PbList<SavedQuery> createRepeated() => new PbList<SavedQuery>();
  static SavedQuery getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlySavedQuery();
    return _defaultInstance;
  }
  static SavedQuery _defaultInstance;
  static void $checkItem(SavedQuery v) {
    if (v is !SavedQuery) checkItemFailed(v, 'SavedQuery');
  }

  String get savedQueryId => $_get(0, 1, '');
  void set savedQueryId(String v) { $_setString(0, 1, v); }
  bool hasSavedQueryId() => $_has(0, 1);
  void clearSavedQueryId() => clearField(1);

  String get name => $_get(1, 2, '');
  void set name(String v) { $_setString(1, 2, v); }
  bool hasName() => $_has(1, 2);
  void clearName() => clearField(2);

  String get description => $_get(2, 3, '');
  void set description(String v) { $_setString(2, 3, v); }
  bool hasDescription() => $_has(2, 3);
  void clearDescription() => clearField(3);

  String get tableName => $_get(3, 4, '');
  void set tableName(String v) { $_setString(3, 4, v); }
  bool hasTableName() => $_has(3, 4);
  void clearTableName() => clearField(4);

  String get userId => $_get(4, 5, '');
  void set userId(String v) { $_setString(4, 5, v); }
  bool hasUserId() => $_has(4, 5);
  void clearUserId() => clearField(5);

  bool get isDefault => $_get(5, 6, false);
  void set isDefault(bool v) { $_setBool(5, 6, v); }
  bool hasIsDefault() => $_has(5, 6);
  void clearIsDefault() => clearField(6);

  String get sqlWhere => $_get(6, 9, '');
  void set sqlWhere(String v) { $_setString(6, 9, v); }
  bool hasSqlWhere() => $_has(6, 9);
  void clearSqlWhere() => clearField(9);

  List<DFilter> get filterList => $_get(7, 10, null);

  String get filterLogic => $_get(8, 11, '');
  void set filterLogic(String v) { $_setString(8, 11, v); }
  bool hasFilterLogic() => $_has(8, 11);
  void clearFilterLogic() => clearField(11);

  List<DSort> get sortList => $_get(9, 13, null);
}

class _ReadonlySavedQuery extends SavedQuery with ReadonlyMessageMixin {}

class Recent extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('Recent')
    ..a(1, 'userRecentId', PbFieldType.OS)
    ..a(2, 'userId', PbFieldType.OS)
    ..a(3, 'isActive', PbFieldType.OB, true)
    ..a(4, 'recentTime', PbFieldType.O6, Int64.ZERO)
    ..a(5, 'recordId', PbFieldType.OS)
    ..a(6, 'action', PbFieldType.QS)
    ..a(7, 'label', PbFieldType.OS)
    ..a(8, 'recentType', PbFieldType.OS)
    ..a(9, 'recentTypeLabel', PbFieldType.OS)
    ..a(10, 'iconImage', PbFieldType.OS)
    ..a(11, 'isWriteAccess', PbFieldType.OB)
  ;

  Recent() : super();
  Recent.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Recent.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Recent clone() => new Recent()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static Recent create() => new Recent();
  static PbList<Recent> createRepeated() => new PbList<Recent>();
  static Recent getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyRecent();
    return _defaultInstance;
  }
  static Recent _defaultInstance;
  static void $checkItem(Recent v) {
    if (v is !Recent) checkItemFailed(v, 'Recent');
  }

  String get userRecentId => $_get(0, 1, '');
  void set userRecentId(String v) { $_setString(0, 1, v); }
  bool hasUserRecentId() => $_has(0, 1);
  void clearUserRecentId() => clearField(1);

  String get userId => $_get(1, 2, '');
  void set userId(String v) { $_setString(1, 2, v); }
  bool hasUserId() => $_has(1, 2);
  void clearUserId() => clearField(2);

  bool get isActive => $_get(2, 3, true);
  void set isActive(bool v) { $_setBool(2, 3, v); }
  bool hasIsActive() => $_has(2, 3);
  void clearIsActive() => clearField(3);

  Int64 get recentTime => $_get(3, 4, null);
  void set recentTime(Int64 v) { $_setInt64(3, 4, v); }
  bool hasRecentTime() => $_has(3, 4);
  void clearRecentTime() => clearField(4);

  String get recordId => $_get(4, 5, '');
  void set recordId(String v) { $_setString(4, 5, v); }
  bool hasRecordId() => $_has(4, 5);
  void clearRecordId() => clearField(5);

  String get action => $_get(5, 6, '');
  void set action(String v) { $_setString(5, 6, v); }
  bool hasAction() => $_has(5, 6);
  void clearAction() => clearField(6);

  String get label => $_get(6, 7, '');
  void set label(String v) { $_setString(6, 7, v); }
  bool hasLabel() => $_has(6, 7);
  void clearLabel() => clearField(7);

  String get recentType => $_get(7, 8, '');
  void set recentType(String v) { $_setString(7, 8, v); }
  bool hasRecentType() => $_has(7, 8);
  void clearRecentType() => clearField(8);

  String get recentTypeLabel => $_get(8, 9, '');
  void set recentTypeLabel(String v) { $_setString(8, 9, v); }
  bool hasRecentTypeLabel() => $_has(8, 9);
  void clearRecentTypeLabel() => clearField(9);

  String get iconImage => $_get(9, 10, '');
  void set iconImage(String v) { $_setString(9, 10, v); }
  bool hasIconImage() => $_has(9, 10);
  void clearIconImage() => clearField(10);

  bool get isWriteAccess => $_get(10, 11, false);
  void set isWriteAccess(bool v) { $_setBool(10, 11, v); }
  bool hasIsWriteAccess() => $_has(10, 11);
  void clearIsWriteAccess() => clearField(11);
}

class _ReadonlyRecent extends Recent with ReadonlyMessageMixin {}

const DOP$json = const {
  '1': 'DOP',
  '2': const [
    const {'1': 'EQ', '2': 1},
    const {'1': 'NE', '2': 2},
    const {'1': 'GE', '2': 3},
    const {'1': 'GT', '2': 4},
    const {'1': 'LE', '2': 5},
    const {'1': 'LT', '2': 6},
    const {'1': 'ISNULL', '2': 7},
    const {'1': 'NOTNULL', '2': 8},
    const {'1': 'LIKE', '2': 9},
    const {'1': 'NOTLIKE', '2': 10},
    const {'1': 'IN', '2': 11},
    const {'1': 'NOTIN', '2': 12},
    const {'1': 'BETWEEN', '2': 13},
    const {'1': 'URV', '2': 15},
    const {'1': 'SQL', '2': 16},
    const {'1': 'D_DAY', '2': 20},
    const {'1': 'D_WEEK', '2': 21},
    const {'1': 'D_MONTH', '2': 22},
    const {'1': 'D_QUARTER', '2': 23},
    const {'1': 'D_YEAR', '2': 24},
    const {'1': 'D_LAST', '2': 30},
    const {'1': 'D_THIS', '2': 31},
    const {'1': 'D_NEXT', '2': 32},
  ],
};

const DRecord$json = const {
  '1': 'DRecord',
  '2': const [
    const {'1': 'record_id', '3': 1, '4': 1, '5': 9},
    const {'1': 'table_id', '3': 2, '4': 1, '5': 9},
    const {'1': 'table_name', '3': 3, '4': 1, '5': 9},
    const {'1': 'urv', '3': 4, '4': 1, '5': 9},
    const {'1': 'urv_rest', '3': 5, '4': 1, '5': 9},
    const {'1': 'drv', '3': 6, '4': 1, '5': 9},
    const {'1': 'revision', '3': 7, '4': 1, '5': 9},
    const {'1': 'who', '3': 8, '4': 1, '5': 9},
    const {'1': 'query', '3': 9, '4': 1, '5': 9},
    const {'1': 'etag', '3': 10, '4': 1, '5': 9},
    const {'1': 'svr_msg', '3': 11, '4': 1, '5': 9},
    const {'1': 'is_changed', '3': 12, '4': 1, '5': 8, '7': 'false'},
    const {'1': 'is_read_only', '3': 13, '4': 1, '5': 8, '7': 'false'},
    const {'1': 'is_read_only_calc', '3': 16, '4': 1, '5': 8},
    const {'1': 'is_mandatory_calc', '3': 17, '4': 1, '5': 8},
    const {'1': 'is_selected', '3': 18, '4': 1, '5': 8},
    const {'1': 'is_match_find', '3': 19, '4': 1, '5': 8},
    const {'1': 'entry', '3': 20, '4': 3, '5': 11, '6': '.DEntry'},
    const {'1': 'parent', '3': 21, '4': 1, '5': 11, '6': '.DRecord'},
    const {'1': 'is_group_by', '3': 22, '4': 1, '5': 8, '7': 'false'},
    const {'1': 'stat', '3': 23, '4': 3, '5': 11, '6': '.DStatistics'},
  ],
};

const DEntry$json = const {
  '1': 'DEntry',
  '2': const [
    const {'1': 'column_id', '3': 1, '4': 1, '5': 9},
    const {'1': 'column_name', '3': 2, '4': 1, '5': 9},
    const {'1': 'value', '3': 3, '4': 1, '5': 9},
    const {'1': 'is_changed', '3': 4, '4': 1, '5': 8, '7': 'false'},
    const {'1': 'value_original', '3': 5, '4': 1, '5': 9},
    const {'1': 'value_display', '3': 6, '4': 1, '5': 9},
  ],
};

const DStatistics$json = const {
  '1': 'DStatistics',
  '2': const [
    const {'1': 'column_id', '3': 1, '4': 1, '5': 9},
    const {'1': 'column_name', '3': 2, '4': 1, '5': 9},
    const {'1': 'is_local', '3': 3, '4': 1, '5': 8},
    const {'1': 'count_total', '3': 5, '4': 1, '5': 5},
    const {'1': 'count_not_null', '3': 6, '4': 1, '5': 5},
    const {'1': 'min_value', '3': 10, '4': 1, '5': 1},
    const {'1': 'max_value', '3': 11, '4': 1, '5': 1},
    const {'1': 'sum_value', '3': 15, '4': 1, '5': 1},
    const {'1': 'avg_value', '3': 16, '4': 1, '5': 1},
  ],
};

const DFilter$json = const {
  '1': 'DFilter',
  '2': const [
    const {'1': 'column_name', '3': 1, '4': 2, '5': 9},
    const {'1': 'operation', '3': 2, '4': 2, '5': 14, '6': '.DOP', '7': 'EQ'},
    const {'1': 'operation_date', '3': 3, '4': 1, '5': 14, '6': '.DOP'},
    const {'1': 'data_type', '3': 4, '4': 1, '5': 14, '6': '.DataType'},
    const {'1': 'filter_value', '3': 5, '4': 1, '5': 9},
    const {'1': 'filter_value_to', '3': 6, '4': 1, '5': 9},
    const {'1': 'filter_in', '3': 7, '4': 3, '5': 9},
    const {'1': 'is_read_only', '3': 10, '4': 1, '5': 8, '7': 'false'},
    const {'1': 'filter_direct_query', '3': 11, '4': 1, '5': 9},
  ],
};

const DSort$json = const {
  '1': 'DSort',
  '2': const [
    const {'1': 'column_name', '3': 1, '4': 2, '5': 9},
    const {'1': 'is_ascending', '3': 2, '4': 1, '5': 8, '7': 'true'},
    const {'1': 'is_group_by', '3': 3, '4': 1, '5': 8, '7': 'false'},
  ],
};

const DFK$json = const {
  '1': 'DFK',
  '2': const [
    const {'1': 'id', '3': 1, '4': 2, '5': 9},
    const {'1': 'drv', '3': 2, '4': 1, '5': 9},
    const {'1': 'urv', '3': 3, '4': 1, '5': 9},
    const {'1': 'table_name', '3': 4, '4': 1, '5': 9},
  ],
};

const SavedQuery$json = const {
  '1': 'SavedQuery',
  '2': const [
    const {'1': 'saved_query_id', '3': 1, '4': 1, '5': 9},
    const {'1': 'name', '3': 2, '4': 2, '5': 9},
    const {'1': 'description', '3': 3, '4': 1, '5': 9},
    const {'1': 'table_name', '3': 4, '4': 2, '5': 9},
    const {'1': 'user_id', '3': 5, '4': 1, '5': 9},
    const {'1': 'is_default', '3': 6, '4': 1, '5': 8, '7': 'false'},
    const {'1': 'sql_where', '3': 9, '4': 1, '5': 9},
    const {'1': 'filter', '3': 10, '4': 3, '5': 11, '6': '.DFilter'},
    const {'1': 'filter_logic', '3': 11, '4': 1, '5': 9},
    const {'1': 'sort', '3': 13, '4': 3, '5': 11, '6': '.DSort'},
  ],
};

const Recent$json = const {
  '1': 'Recent',
  '2': const [
    const {'1': 'user_recent_id', '3': 1, '4': 1, '5': 9},
    const {'1': 'user_id', '3': 2, '4': 1, '5': 9},
    const {'1': 'is_active', '3': 3, '4': 1, '5': 8, '7': 'true'},
    const {'1': 'recent_time', '3': 4, '4': 1, '5': 3},
    const {'1': 'record_id', '3': 5, '4': 1, '5': 9},
    const {'1': 'action', '3': 6, '4': 2, '5': 9},
    const {'1': 'label', '3': 7, '4': 1, '5': 9},
    const {'1': 'recent_type', '3': 8, '4': 1, '5': 9},
    const {'1': 'recent_type_label', '3': 9, '4': 1, '5': 9},
    const {'1': 'icon_image', '3': 10, '4': 1, '5': 9},
    const {'1': 'is_write_access', '3': 11, '4': 1, '5': 8, '7': 'false'},
  ],
};

