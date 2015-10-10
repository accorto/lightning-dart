/**
 * Generated Protocol Buffers code. Do not modify.
 */
library protoc.structure;

import 'package:protobuf/protobuf.dart';
import 'rr_pb.dart';

class DataType extends ProtobufEnum {
  static const DataType STRING = const DataType._(25, 'STRING');
  static const DataType ADDRESS = const DataType._(1, 'ADDRESS');
  static const DataType AMOUNT = const DataType._(2, 'AMOUNT');
  static const DataType BOOLEAN = const DataType._(3, 'BOOLEAN');
  static const DataType CODE = const DataType._(4, 'CODE');
  static const DataType COLOR = const DataType._(5, 'COLOR');
  static const DataType CURRENCY = const DataType._(6, 'CURRENCY');
  static const DataType DATA = const DataType._(7, 'DATA');
  static const DataType DATE = const DataType._(8, 'DATE');
  static const DataType DATETIME = const DataType._(9, 'DATETIME');
  static const DataType DECIMAL = const DataType._(10, 'DECIMAL');
  static const DataType DURATION = const DataType._(11, 'DURATION');
  static const DataType EMAIL = const DataType._(12, 'EMAIL');
  static const DataType FK = const DataType._(13, 'FK');
  static const DataType GEO = const DataType._(14, 'GEO');
  static const DataType IM = const DataType._(15, 'IM');
  static const DataType IMAGE = const DataType._(16, 'IMAGE');
  static const DataType INT = const DataType._(17, 'INT');
  static const DataType NUMBER = const DataType._(18, 'NUMBER');
  static const DataType PASSWORD = const DataType._(19, 'PASSWORD');
  static const DataType PHONE = const DataType._(20, 'PHONE');
  static const DataType PICK = const DataType._(21, 'PICK');
  static const DataType PICKMULTI = const DataType._(22, 'PICKMULTI');
  static const DataType QUANTITY = const DataType._(23, 'QUANTITY');
  static const DataType RATING = const DataType._(24, 'RATING');
  static const DataType TENANT = const DataType._(26, 'TENANT');
  static const DataType TEXT = const DataType._(27, 'TEXT');
  static const DataType TIME = const DataType._(28, 'TIME');
  static const DataType URL = const DataType._(29, 'URL');
  static const DataType USER = const DataType._(30, 'USER');
  static const DataType PICKAUTO = const DataType._(31, 'PICKAUTO');
  static const DataType PICKCHOICE = const DataType._(32, 'PICKCHOICE');
  static const DataType PICKMULTICHOICE = const DataType._(33, 'PICKMULTICHOICE');
  static const DataType TIMEZONE = const DataType._(34, 'TIMEZONE');
  static const DataType TAG = const DataType._(35, 'TAG');
  static const DataType DURATIONHOUR = const DataType._(36, 'DURATIONHOUR');

  static const List<DataType> values = const <DataType> [
    STRING,
    ADDRESS,
    AMOUNT,
    BOOLEAN,
    CODE,
    COLOR,
    CURRENCY,
    DATA,
    DATE,
    DATETIME,
    DECIMAL,
    DURATION,
    EMAIL,
    FK,
    GEO,
    IM,
    IMAGE,
    INT,
    NUMBER,
    PASSWORD,
    PHONE,
    PICK,
    PICKMULTI,
    QUANTITY,
    RATING,
    TENANT,
    TEXT,
    TIME,
    URL,
    USER,
    PICKAUTO,
    PICKCHOICE,
    PICKMULTICHOICE,
    TIMEZONE,
    TAG,
    DURATIONHOUR,
  ];

  static final Map<int, DataType> _byValue = ProtobufEnum.initByValue(values);
  static DataType valueOf(int value) => _byValue[value];
  static void $checkItem(DataType v) {
    if (v is !DataType) checkItemFailed(v, 'DataType');
  }

  const DataType._(int v, String n) : super(v, n);
}

class DTable extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DTable')
    ..a(1, 'tableId', PbFieldType.OS)
    ..a(2, 'name', PbFieldType.QS)
    ..a(3, 'label', PbFieldType.OS)
    ..a(4, 'description', PbFieldType.OS)
    ..a(5, 'help', PbFieldType.OS)
    ..a(6, 'tutorialUrl', PbFieldType.OS)
    ..a(7, 'color', PbFieldType.OS)
    ..a(8, 'externalKey', PbFieldType.OS)
    ..a(9, 'isActive', PbFieldType.OB, true)
    ..pp(10, 'column', PbFieldType.PM, DColumn.$checkItem, DColumn.create)
    ..a(15, 'iconImage', PbFieldType.OS)
    ..a(20, 'isReadOnly', PbFieldType.OB)
    ..a(21, 'isNewRecordServer', PbFieldType.OB)
    ..a(26, 'note', PbFieldType.OS)
    ..a(30, 'updateFlag', PbFieldType.OS)
  ;

  DTable() : super();
  DTable.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DTable.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DTable clone() => new DTable()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DTable create() => new DTable();
  static PbList<DTable> createRepeated() => new PbList<DTable>();
  static DTable getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyDTable();
    return _defaultInstance;
  }
  static DTable _defaultInstance;
  static void $checkItem(DTable v) {
    if (v is !DTable) checkItemFailed(v, 'DTable');
  }

  String get tableId => $_get(0, 1, '');
  void set tableId(String v) { $_setString(0, 1, v); }
  bool hasTableId() => $_has(0, 1);
  void clearTableId() => clearField(1);

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

  String get help => $_get(4, 5, '');
  void set help(String v) { $_setString(4, 5, v); }
  bool hasHelp() => $_has(4, 5);
  void clearHelp() => clearField(5);

  String get tutorialUrl => $_get(5, 6, '');
  void set tutorialUrl(String v) { $_setString(5, 6, v); }
  bool hasTutorialUrl() => $_has(5, 6);
  void clearTutorialUrl() => clearField(6);

  String get color => $_get(6, 7, '');
  void set color(String v) { $_setString(6, 7, v); }
  bool hasColor() => $_has(6, 7);
  void clearColor() => clearField(7);

  String get externalKey => $_get(7, 8, '');
  void set externalKey(String v) { $_setString(7, 8, v); }
  bool hasExternalKey() => $_has(7, 8);
  void clearExternalKey() => clearField(8);

  bool get isActive => $_get(8, 9, true);
  void set isActive(bool v) { $_setBool(8, 9, v); }
  bool hasIsActive() => $_has(8, 9);
  void clearIsActive() => clearField(9);

  List<DColumn> get columnList => $_get(9, 10, null);

  String get iconImage => $_get(10, 15, '');
  void set iconImage(String v) { $_setString(10, 15, v); }
  bool hasIconImage() => $_has(10, 15);
  void clearIconImage() => clearField(15);

  bool get isReadOnly => $_get(11, 20, false);
  void set isReadOnly(bool v) { $_setBool(11, 20, v); }
  bool hasIsReadOnly() => $_has(11, 20);
  void clearIsReadOnly() => clearField(20);

  bool get isNewRecordServer => $_get(12, 21, false);
  void set isNewRecordServer(bool v) { $_setBool(12, 21, v); }
  bool hasIsNewRecordServer() => $_has(12, 21);
  void clearIsNewRecordServer() => clearField(21);

  String get note => $_get(13, 26, '');
  void set note(String v) { $_setString(13, 26, v); }
  bool hasNote() => $_has(13, 26);
  void clearNote() => clearField(26);

  String get updateFlag => $_get(14, 30, '');
  void set updateFlag(String v) { $_setString(14, 30, v); }
  bool hasUpdateFlag() => $_has(14, 30);
  void clearUpdateFlag() => clearField(30);
}

class _ReadonlyDTable extends DTable with ReadonlyMessageMixin {}

class DColumn extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DColumn')
    ..a(1, 'columnId', PbFieldType.OS)
    ..a(2, 'name', PbFieldType.QS)
    ..a(3, 'label', PbFieldType.OS)
    ..a(4, 'labelSuffix', PbFieldType.OS)
    ..a(5, 'description', PbFieldType.OS)
    ..a(7, 'isActive', PbFieldType.OB, true)
    ..a(8, 'columnSql', PbFieldType.OS)
    ..a(9, 'externalKey', PbFieldType.OS)
    ..e(10, 'dataType', PbFieldType.QE, DataType.STRING, DataType.valueOf)
    ..a(11, 'columnSize', PbFieldType.O3)
    ..a(12, 'decimalDigits', PbFieldType.O3)
    ..a(20, 'isEncrypted', PbFieldType.OB)
    ..a(21, 'defaultValue', PbFieldType.OS)
    ..a(22, 'formatMask', PbFieldType.OS)
    ..a(23, 'valFrom', PbFieldType.OS)
    ..a(24, 'valTo', PbFieldType.OS)
    ..a(25, 'help', PbFieldType.OS)
    ..a(26, 'note', PbFieldType.OS)
    ..a(27, 'validationCallout', PbFieldType.OS)
    ..a(28, 'isDocumentNo', PbFieldType.OB)
    ..a(30, 'isMandatory', PbFieldType.OB)
    ..a(31, 'isReadOnly', PbFieldType.OB)
    ..a(32, 'isUpdateAlways', PbFieldType.OB)
    ..a(33, 'isTranslated', PbFieldType.OB)
    ..a(34, 'isTranslation', PbFieldType.OB)
    ..a(35, 'isCopied', PbFieldType.OB, true)
    ..a(36, 'isCalculated', PbFieldType.OB)
    ..a(38, 'processExternalKey', PbFieldType.OS)
    ..a(40, 'isPk', PbFieldType.OB)
    ..a(41, 'isParentKey', PbFieldType.OB)
    ..a(42, 'fkReference', PbFieldType.OS)
    ..a(43, 'parentColumnId', PbFieldType.OS)
    ..a(44, 'parentReference', PbFieldType.OS)
    ..a(45, 'restrictionSql', PbFieldType.OS)
    ..a(46, 'pickListId', PbFieldType.OS)
    ..a(47, 'pickListName', PbFieldType.OS)
    ..a(48, 'pickListSize', PbFieldType.O3)
    ..a(49, 'isPickListExtensible', PbFieldType.OB)
    ..a(50, 'uniqueSeqNo', PbFieldType.O3)
    ..a(51, 'displaySeqNo', PbFieldType.O3)
    ..pp(60, 'pickValue', PbFieldType.PM, DOption.$checkItem, DOption.create)
    ..a(61, 'tempExternalKey', PbFieldType.OS)
    ..a(63, 'updateFlag', PbFieldType.OS)
  ;

  DColumn() : super();
  DColumn.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DColumn.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DColumn clone() => new DColumn()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DColumn create() => new DColumn();
  static PbList<DColumn> createRepeated() => new PbList<DColumn>();
  static DColumn getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyDColumn();
    return _defaultInstance;
  }
  static DColumn _defaultInstance;
  static void $checkItem(DColumn v) {
    if (v is !DColumn) checkItemFailed(v, 'DColumn');
  }

  String get columnId => $_get(0, 1, '');
  void set columnId(String v) { $_setString(0, 1, v); }
  bool hasColumnId() => $_has(0, 1);
  void clearColumnId() => clearField(1);

  String get name => $_get(1, 2, '');
  void set name(String v) { $_setString(1, 2, v); }
  bool hasName() => $_has(1, 2);
  void clearName() => clearField(2);

  String get label => $_get(2, 3, '');
  void set label(String v) { $_setString(2, 3, v); }
  bool hasLabel() => $_has(2, 3);
  void clearLabel() => clearField(3);

  String get labelSuffix => $_get(3, 4, '');
  void set labelSuffix(String v) { $_setString(3, 4, v); }
  bool hasLabelSuffix() => $_has(3, 4);
  void clearLabelSuffix() => clearField(4);

  String get description => $_get(4, 5, '');
  void set description(String v) { $_setString(4, 5, v); }
  bool hasDescription() => $_has(4, 5);
  void clearDescription() => clearField(5);

  bool get isActive => $_get(5, 7, true);
  void set isActive(bool v) { $_setBool(5, 7, v); }
  bool hasIsActive() => $_has(5, 7);
  void clearIsActive() => clearField(7);

  String get columnSql => $_get(6, 8, '');
  void set columnSql(String v) { $_setString(6, 8, v); }
  bool hasColumnSql() => $_has(6, 8);
  void clearColumnSql() => clearField(8);

  String get externalKey => $_get(7, 9, '');
  void set externalKey(String v) { $_setString(7, 9, v); }
  bool hasExternalKey() => $_has(7, 9);
  void clearExternalKey() => clearField(9);

  DataType get dataType => $_get(8, 10, null);
  void set dataType(DataType v) { setField(10, v); }
  bool hasDataType() => $_has(8, 10);
  void clearDataType() => clearField(10);

  int get columnSize => $_get(9, 11, 0);
  void set columnSize(int v) { $_setUnsignedInt32(9, 11, v); }
  bool hasColumnSize() => $_has(9, 11);
  void clearColumnSize() => clearField(11);

  int get decimalDigits => $_get(10, 12, 0);
  void set decimalDigits(int v) { $_setUnsignedInt32(10, 12, v); }
  bool hasDecimalDigits() => $_has(10, 12);
  void clearDecimalDigits() => clearField(12);

  bool get isEncrypted => $_get(11, 20, false);
  void set isEncrypted(bool v) { $_setBool(11, 20, v); }
  bool hasIsEncrypted() => $_has(11, 20);
  void clearIsEncrypted() => clearField(20);

  String get defaultValue => $_get(12, 21, '');
  void set defaultValue(String v) { $_setString(12, 21, v); }
  bool hasDefaultValue() => $_has(12, 21);
  void clearDefaultValue() => clearField(21);

  String get formatMask => $_get(13, 22, '');
  void set formatMask(String v) { $_setString(13, 22, v); }
  bool hasFormatMask() => $_has(13, 22);
  void clearFormatMask() => clearField(22);

  String get valFrom => $_get(14, 23, '');
  void set valFrom(String v) { $_setString(14, 23, v); }
  bool hasValFrom() => $_has(14, 23);
  void clearValFrom() => clearField(23);

  String get valTo => $_get(15, 24, '');
  void set valTo(String v) { $_setString(15, 24, v); }
  bool hasValTo() => $_has(15, 24);
  void clearValTo() => clearField(24);

  String get help => $_get(16, 25, '');
  void set help(String v) { $_setString(16, 25, v); }
  bool hasHelp() => $_has(16, 25);
  void clearHelp() => clearField(25);

  String get note => $_get(17, 26, '');
  void set note(String v) { $_setString(17, 26, v); }
  bool hasNote() => $_has(17, 26);
  void clearNote() => clearField(26);

  String get validationCallout => $_get(18, 27, '');
  void set validationCallout(String v) { $_setString(18, 27, v); }
  bool hasValidationCallout() => $_has(18, 27);
  void clearValidationCallout() => clearField(27);

  bool get isDocumentNo => $_get(19, 28, false);
  void set isDocumentNo(bool v) { $_setBool(19, 28, v); }
  bool hasIsDocumentNo() => $_has(19, 28);
  void clearIsDocumentNo() => clearField(28);

  bool get isMandatory => $_get(20, 30, false);
  void set isMandatory(bool v) { $_setBool(20, 30, v); }
  bool hasIsMandatory() => $_has(20, 30);
  void clearIsMandatory() => clearField(30);

  bool get isReadOnly => $_get(21, 31, false);
  void set isReadOnly(bool v) { $_setBool(21, 31, v); }
  bool hasIsReadOnly() => $_has(21, 31);
  void clearIsReadOnly() => clearField(31);

  bool get isUpdateAlways => $_get(22, 32, false);
  void set isUpdateAlways(bool v) { $_setBool(22, 32, v); }
  bool hasIsUpdateAlways() => $_has(22, 32);
  void clearIsUpdateAlways() => clearField(32);

  bool get isTranslated => $_get(23, 33, false);
  void set isTranslated(bool v) { $_setBool(23, 33, v); }
  bool hasIsTranslated() => $_has(23, 33);
  void clearIsTranslated() => clearField(33);

  bool get isTranslation => $_get(24, 34, false);
  void set isTranslation(bool v) { $_setBool(24, 34, v); }
  bool hasIsTranslation() => $_has(24, 34);
  void clearIsTranslation() => clearField(34);

  bool get isCopied => $_get(25, 35, true);
  void set isCopied(bool v) { $_setBool(25, 35, v); }
  bool hasIsCopied() => $_has(25, 35);
  void clearIsCopied() => clearField(35);

  bool get isCalculated => $_get(26, 36, false);
  void set isCalculated(bool v) { $_setBool(26, 36, v); }
  bool hasIsCalculated() => $_has(26, 36);
  void clearIsCalculated() => clearField(36);

  String get processExternalKey => $_get(27, 38, '');
  void set processExternalKey(String v) { $_setString(27, 38, v); }
  bool hasProcessExternalKey() => $_has(27, 38);
  void clearProcessExternalKey() => clearField(38);

  bool get isPk => $_get(28, 40, false);
  void set isPk(bool v) { $_setBool(28, 40, v); }
  bool hasIsPk() => $_has(28, 40);
  void clearIsPk() => clearField(40);

  bool get isParentKey => $_get(29, 41, false);
  void set isParentKey(bool v) { $_setBool(29, 41, v); }
  bool hasIsParentKey() => $_has(29, 41);
  void clearIsParentKey() => clearField(41);

  String get fkReference => $_get(30, 42, '');
  void set fkReference(String v) { $_setString(30, 42, v); }
  bool hasFkReference() => $_has(30, 42);
  void clearFkReference() => clearField(42);

  String get parentColumnId => $_get(31, 43, '');
  void set parentColumnId(String v) { $_setString(31, 43, v); }
  bool hasParentColumnId() => $_has(31, 43);
  void clearParentColumnId() => clearField(43);

  String get parentReference => $_get(32, 44, '');
  void set parentReference(String v) { $_setString(32, 44, v); }
  bool hasParentReference() => $_has(32, 44);
  void clearParentReference() => clearField(44);

  String get restrictionSql => $_get(33, 45, '');
  void set restrictionSql(String v) { $_setString(33, 45, v); }
  bool hasRestrictionSql() => $_has(33, 45);
  void clearRestrictionSql() => clearField(45);

  String get pickListId => $_get(34, 46, '');
  void set pickListId(String v) { $_setString(34, 46, v); }
  bool hasPickListId() => $_has(34, 46);
  void clearPickListId() => clearField(46);

  String get pickListName => $_get(35, 47, '');
  void set pickListName(String v) { $_setString(35, 47, v); }
  bool hasPickListName() => $_has(35, 47);
  void clearPickListName() => clearField(47);

  int get pickListSize => $_get(36, 48, 0);
  void set pickListSize(int v) { $_setUnsignedInt32(36, 48, v); }
  bool hasPickListSize() => $_has(36, 48);
  void clearPickListSize() => clearField(48);

  bool get isPickListExtensible => $_get(37, 49, false);
  void set isPickListExtensible(bool v) { $_setBool(37, 49, v); }
  bool hasIsPickListExtensible() => $_has(37, 49);
  void clearIsPickListExtensible() => clearField(49);

  int get uniqueSeqNo => $_get(38, 50, 0);
  void set uniqueSeqNo(int v) { $_setUnsignedInt32(38, 50, v); }
  bool hasUniqueSeqNo() => $_has(38, 50);
  void clearUniqueSeqNo() => clearField(50);

  int get displaySeqNo => $_get(39, 51, 0);
  void set displaySeqNo(int v) { $_setUnsignedInt32(39, 51, v); }
  bool hasDisplaySeqNo() => $_has(39, 51);
  void clearDisplaySeqNo() => clearField(51);

  List<DOption> get pickValueList => $_get(40, 60, null);

  String get tempExternalKey => $_get(41, 61, '');
  void set tempExternalKey(String v) { $_setString(41, 61, v); }
  bool hasTempExternalKey() => $_has(41, 61);
  void clearTempExternalKey() => clearField(61);

  String get updateFlag => $_get(42, 63, '');
  void set updateFlag(String v) { $_setString(42, 63, v); }
  bool hasUpdateFlag() => $_has(42, 63);
  void clearUpdateFlag() => clearField(63);
}

class _ReadonlyDColumn extends DColumn with ReadonlyMessageMixin {}

class DOption extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DOption')
    ..a(1, 'id', PbFieldType.OS)
    ..a(2, 'value', PbFieldType.QS)
    ..a(3, 'label', PbFieldType.QS)
    ..a(4, 'description', PbFieldType.OS)
    ..a(5, 'iconImage', PbFieldType.OS)
    ..a(6, 'isSelected', PbFieldType.OB)
    ..a(7, 'isOptGroup', PbFieldType.OB)
    ..a(10, 'seqNo', PbFieldType.O3)
    ..a(11, 'isActive', PbFieldType.OB, true)
    ..a(12, 'isDefault', PbFieldType.OB)
    ..a(15, 'referenceId', PbFieldType.OS)
    ..a(16, 'cssClass', PbFieldType.OS)
    ..a(17, 'cssColor', PbFieldType.OS)
    ..pp(20, 'validation', PbFieldType.PM, DKeyValue.$checkItem, DKeyValue.create)
    ..a(30, 'updateFlag', PbFieldType.OS)
  ;

  DOption() : super();
  DOption.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DOption.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DOption clone() => new DOption()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DOption create() => new DOption();
  static PbList<DOption> createRepeated() => new PbList<DOption>();
  static DOption getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyDOption();
    return _defaultInstance;
  }
  static DOption _defaultInstance;
  static void $checkItem(DOption v) {
    if (v is !DOption) checkItemFailed(v, 'DOption');
  }

  String get id => $_get(0, 1, '');
  void set id(String v) { $_setString(0, 1, v); }
  bool hasId() => $_has(0, 1);
  void clearId() => clearField(1);

  String get value => $_get(1, 2, '');
  void set value(String v) { $_setString(1, 2, v); }
  bool hasValue() => $_has(1, 2);
  void clearValue() => clearField(2);

  String get label => $_get(2, 3, '');
  void set label(String v) { $_setString(2, 3, v); }
  bool hasLabel() => $_has(2, 3);
  void clearLabel() => clearField(3);

  String get description => $_get(3, 4, '');
  void set description(String v) { $_setString(3, 4, v); }
  bool hasDescription() => $_has(3, 4);
  void clearDescription() => clearField(4);

  String get iconImage => $_get(4, 5, '');
  void set iconImage(String v) { $_setString(4, 5, v); }
  bool hasIconImage() => $_has(4, 5);
  void clearIconImage() => clearField(5);

  bool get isSelected => $_get(5, 6, false);
  void set isSelected(bool v) { $_setBool(5, 6, v); }
  bool hasIsSelected() => $_has(5, 6);
  void clearIsSelected() => clearField(6);

  bool get isOptGroup => $_get(6, 7, false);
  void set isOptGroup(bool v) { $_setBool(6, 7, v); }
  bool hasIsOptGroup() => $_has(6, 7);
  void clearIsOptGroup() => clearField(7);

  int get seqNo => $_get(7, 10, 0);
  void set seqNo(int v) { $_setUnsignedInt32(7, 10, v); }
  bool hasSeqNo() => $_has(7, 10);
  void clearSeqNo() => clearField(10);

  bool get isActive => $_get(8, 11, true);
  void set isActive(bool v) { $_setBool(8, 11, v); }
  bool hasIsActive() => $_has(8, 11);
  void clearIsActive() => clearField(11);

  bool get isDefault => $_get(9, 12, false);
  void set isDefault(bool v) { $_setBool(9, 12, v); }
  bool hasIsDefault() => $_has(9, 12);
  void clearIsDefault() => clearField(12);

  String get referenceId => $_get(10, 15, '');
  void set referenceId(String v) { $_setString(10, 15, v); }
  bool hasReferenceId() => $_has(10, 15);
  void clearReferenceId() => clearField(15);

  String get cssClass => $_get(11, 16, '');
  void set cssClass(String v) { $_setString(11, 16, v); }
  bool hasCssClass() => $_has(11, 16);
  void clearCssClass() => clearField(16);

  String get cssColor => $_get(12, 17, '');
  void set cssColor(String v) { $_setString(12, 17, v); }
  bool hasCssColor() => $_has(12, 17);
  void clearCssColor() => clearField(17);

  List<DKeyValue> get validationList => $_get(13, 20, null);

  String get updateFlag => $_get(14, 30, '');
  void set updateFlag(String v) { $_setString(14, 30, v); }
  bool hasUpdateFlag() => $_has(14, 30);
  void clearUpdateFlag() => clearField(30);
}

class _ReadonlyDOption extends DOption with ReadonlyMessageMixin {}

class DProperty extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DProperty')
    ..a(1, 'id', PbFieldType.OS)
    ..a(2, 'name', PbFieldType.QS)
    ..a(3, 'label', PbFieldType.OS)
    ..a(4, 'description', PbFieldType.OS)
    ..a(5, 'help', PbFieldType.OS)
    ..a(6, 'seqNo', PbFieldType.O3)
    ..a(7, 'isRange', PbFieldType.OB)
    ..a(8, 'isMandatory', PbFieldType.OB, true)
    ..a(9, 'isReadOnly', PbFieldType.OB)
    ..e(10, 'dataType', PbFieldType.OE, DataType.STRING, DataType.valueOf)
    ..a(11, 'columnSize', PbFieldType.O3)
    ..a(12, 'decimalDigits', PbFieldType.O3)
    ..a(13, 'defaultValue', PbFieldType.OS)
    ..a(14, 'defaultValueTo', PbFieldType.OS)
    ..a(15, 'pickListName', PbFieldType.OS)
    ..pp(16, 'pickValue', PbFieldType.PM, DOption.$checkItem, DOption.create)
    ..a(20, 'formatMask', PbFieldType.OS)
    ..a(21, 'valFrom', PbFieldType.OS)
    ..a(22, 'valTo', PbFieldType.OS)
    ..a(23, 'fkReference', PbFieldType.OS)
    ..a(30, 'value', PbFieldType.OS)
    ..a(31, 'valueTo', PbFieldType.OS)
    ..a(32, 'isChanged', PbFieldType.OB)
    ..a(33, 'valueOriginal', PbFieldType.OS)
    ..a(34, 'isValid', PbFieldType.OB, true)
    ..a(40, 'updateFlag', PbFieldType.OS)
  ;

  DProperty() : super();
  DProperty.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DProperty.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DProperty clone() => new DProperty()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DProperty create() => new DProperty();
  static PbList<DProperty> createRepeated() => new PbList<DProperty>();
  static DProperty getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyDProperty();
    return _defaultInstance;
  }
  static DProperty _defaultInstance;
  static void $checkItem(DProperty v) {
    if (v is !DProperty) checkItemFailed(v, 'DProperty');
  }

  String get id => $_get(0, 1, '');
  void set id(String v) { $_setString(0, 1, v); }
  bool hasId() => $_has(0, 1);
  void clearId() => clearField(1);

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

  String get help => $_get(4, 5, '');
  void set help(String v) { $_setString(4, 5, v); }
  bool hasHelp() => $_has(4, 5);
  void clearHelp() => clearField(5);

  int get seqNo => $_get(5, 6, 0);
  void set seqNo(int v) { $_setUnsignedInt32(5, 6, v); }
  bool hasSeqNo() => $_has(5, 6);
  void clearSeqNo() => clearField(6);

  bool get isRange => $_get(6, 7, false);
  void set isRange(bool v) { $_setBool(6, 7, v); }
  bool hasIsRange() => $_has(6, 7);
  void clearIsRange() => clearField(7);

  bool get isMandatory => $_get(7, 8, true);
  void set isMandatory(bool v) { $_setBool(7, 8, v); }
  bool hasIsMandatory() => $_has(7, 8);
  void clearIsMandatory() => clearField(8);

  bool get isReadOnly => $_get(8, 9, false);
  void set isReadOnly(bool v) { $_setBool(8, 9, v); }
  bool hasIsReadOnly() => $_has(8, 9);
  void clearIsReadOnly() => clearField(9);

  DataType get dataType => $_get(9, 10, null);
  void set dataType(DataType v) { setField(10, v); }
  bool hasDataType() => $_has(9, 10);
  void clearDataType() => clearField(10);

  int get columnSize => $_get(10, 11, 0);
  void set columnSize(int v) { $_setUnsignedInt32(10, 11, v); }
  bool hasColumnSize() => $_has(10, 11);
  void clearColumnSize() => clearField(11);

  int get decimalDigits => $_get(11, 12, 0);
  void set decimalDigits(int v) { $_setUnsignedInt32(11, 12, v); }
  bool hasDecimalDigits() => $_has(11, 12);
  void clearDecimalDigits() => clearField(12);

  String get defaultValue => $_get(12, 13, '');
  void set defaultValue(String v) { $_setString(12, 13, v); }
  bool hasDefaultValue() => $_has(12, 13);
  void clearDefaultValue() => clearField(13);

  String get defaultValueTo => $_get(13, 14, '');
  void set defaultValueTo(String v) { $_setString(13, 14, v); }
  bool hasDefaultValueTo() => $_has(13, 14);
  void clearDefaultValueTo() => clearField(14);

  String get pickListName => $_get(14, 15, '');
  void set pickListName(String v) { $_setString(14, 15, v); }
  bool hasPickListName() => $_has(14, 15);
  void clearPickListName() => clearField(15);

  List<DOption> get pickValueList => $_get(15, 16, null);

  String get formatMask => $_get(16, 20, '');
  void set formatMask(String v) { $_setString(16, 20, v); }
  bool hasFormatMask() => $_has(16, 20);
  void clearFormatMask() => clearField(20);

  String get valFrom => $_get(17, 21, '');
  void set valFrom(String v) { $_setString(17, 21, v); }
  bool hasValFrom() => $_has(17, 21);
  void clearValFrom() => clearField(21);

  String get valTo => $_get(18, 22, '');
  void set valTo(String v) { $_setString(18, 22, v); }
  bool hasValTo() => $_has(18, 22);
  void clearValTo() => clearField(22);

  String get fkReference => $_get(19, 23, '');
  void set fkReference(String v) { $_setString(19, 23, v); }
  bool hasFkReference() => $_has(19, 23);
  void clearFkReference() => clearField(23);

  String get value => $_get(20, 30, '');
  void set value(String v) { $_setString(20, 30, v); }
  bool hasValue() => $_has(20, 30);
  void clearValue() => clearField(30);

  String get valueTo => $_get(21, 31, '');
  void set valueTo(String v) { $_setString(21, 31, v); }
  bool hasValueTo() => $_has(21, 31);
  void clearValueTo() => clearField(31);

  bool get isChanged => $_get(22, 32, false);
  void set isChanged(bool v) { $_setBool(22, 32, v); }
  bool hasIsChanged() => $_has(22, 32);
  void clearIsChanged() => clearField(32);

  String get valueOriginal => $_get(23, 33, '');
  void set valueOriginal(String v) { $_setString(23, 33, v); }
  bool hasValueOriginal() => $_has(23, 33);
  void clearValueOriginal() => clearField(33);

  bool get isValid => $_get(24, 34, true);
  void set isValid(bool v) { $_setBool(24, 34, v); }
  bool hasIsValid() => $_has(24, 34);
  void clearIsValid() => clearField(34);

  String get updateFlag => $_get(25, 40, '');
  void set updateFlag(String v) { $_setString(25, 40, v); }
  bool hasUpdateFlag() => $_has(25, 40);
  void clearUpdateFlag() => clearField(40);
}

class _ReadonlyDProperty extends DProperty with ReadonlyMessageMixin {}

class DTrxState extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DTrxState')
    ..a(1, 'id', PbFieldType.OS)
    ..a(2, 'name', PbFieldType.QS)
    ..a(3, 'tenantId', PbFieldType.OS)
    ..a(5, 'tableId', PbFieldType.OS)
    ..a(6, 'tableName', PbFieldType.OS)
    ..a(7, 'isDefault', PbFieldType.OB)
    ..a(9, 'chartUrl', PbFieldType.OS)
    ..pp(10, 'status', PbFieldType.PM, DTrxStatus.$checkItem, DTrxStatus.create)
    ..pp(11, 'action', PbFieldType.PM, DTrxAction.$checkItem, DTrxAction.create)
  ;

  DTrxState() : super();
  DTrxState.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DTrxState.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DTrxState clone() => new DTrxState()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DTrxState create() => new DTrxState();
  static PbList<DTrxState> createRepeated() => new PbList<DTrxState>();
  static DTrxState getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyDTrxState();
    return _defaultInstance;
  }
  static DTrxState _defaultInstance;
  static void $checkItem(DTrxState v) {
    if (v is !DTrxState) checkItemFailed(v, 'DTrxState');
  }

  String get id => $_get(0, 1, '');
  void set id(String v) { $_setString(0, 1, v); }
  bool hasId() => $_has(0, 1);
  void clearId() => clearField(1);

  String get name => $_get(1, 2, '');
  void set name(String v) { $_setString(1, 2, v); }
  bool hasName() => $_has(1, 2);
  void clearName() => clearField(2);

  String get tenantId => $_get(2, 3, '');
  void set tenantId(String v) { $_setString(2, 3, v); }
  bool hasTenantId() => $_has(2, 3);
  void clearTenantId() => clearField(3);

  String get tableId => $_get(3, 5, '');
  void set tableId(String v) { $_setString(3, 5, v); }
  bool hasTableId() => $_has(3, 5);
  void clearTableId() => clearField(5);

  String get tableName => $_get(4, 6, '');
  void set tableName(String v) { $_setString(4, 6, v); }
  bool hasTableName() => $_has(4, 6);
  void clearTableName() => clearField(6);

  bool get isDefault => $_get(5, 7, false);
  void set isDefault(bool v) { $_setBool(5, 7, v); }
  bool hasIsDefault() => $_has(5, 7);
  void clearIsDefault() => clearField(7);

  String get chartUrl => $_get(6, 9, '');
  void set chartUrl(String v) { $_setString(6, 9, v); }
  bool hasChartUrl() => $_has(6, 9);
  void clearChartUrl() => clearField(9);

  List<DTrxStatus> get statusList => $_get(7, 10, null);

  List<DTrxAction> get actionList => $_get(8, 11, null);
}

class _ReadonlyDTrxState extends DTrxState with ReadonlyMessageMixin {}

class DTrxStatus extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DTrxStatus')
    ..a(1, 'id', PbFieldType.OS)
    ..a(2, 'value', PbFieldType.QS)
    ..a(3, 'label', PbFieldType.QS)
    ..a(4, 'seqNo', PbFieldType.O3)
    ..a(5, 'isInitialState', PbFieldType.OB)
    ..a(6, 'isFinalState', PbFieldType.OB)
    ..a(7, 'isError', PbFieldType.OB)
    ..a(8, 'isDocRw', PbFieldType.OB)
    ..p(10, 'actionId', PbFieldType.PS)
    ..pp(11, 'action', PbFieldType.PM, DTrxAction.$checkItem, DTrxAction.create)
  ;

  DTrxStatus() : super();
  DTrxStatus.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DTrxStatus.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DTrxStatus clone() => new DTrxStatus()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DTrxStatus create() => new DTrxStatus();
  static PbList<DTrxStatus> createRepeated() => new PbList<DTrxStatus>();
  static DTrxStatus getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyDTrxStatus();
    return _defaultInstance;
  }
  static DTrxStatus _defaultInstance;
  static void $checkItem(DTrxStatus v) {
    if (v is !DTrxStatus) checkItemFailed(v, 'DTrxStatus');
  }

  String get id => $_get(0, 1, '');
  void set id(String v) { $_setString(0, 1, v); }
  bool hasId() => $_has(0, 1);
  void clearId() => clearField(1);

  String get value => $_get(1, 2, '');
  void set value(String v) { $_setString(1, 2, v); }
  bool hasValue() => $_has(1, 2);
  void clearValue() => clearField(2);

  String get label => $_get(2, 3, '');
  void set label(String v) { $_setString(2, 3, v); }
  bool hasLabel() => $_has(2, 3);
  void clearLabel() => clearField(3);

  int get seqNo => $_get(3, 4, 0);
  void set seqNo(int v) { $_setUnsignedInt32(3, 4, v); }
  bool hasSeqNo() => $_has(3, 4);
  void clearSeqNo() => clearField(4);

  bool get isInitialState => $_get(4, 5, false);
  void set isInitialState(bool v) { $_setBool(4, 5, v); }
  bool hasIsInitialState() => $_has(4, 5);
  void clearIsInitialState() => clearField(5);

  bool get isFinalState => $_get(5, 6, false);
  void set isFinalState(bool v) { $_setBool(5, 6, v); }
  bool hasIsFinalState() => $_has(5, 6);
  void clearIsFinalState() => clearField(6);

  bool get isError => $_get(6, 7, false);
  void set isError(bool v) { $_setBool(6, 7, v); }
  bool hasIsError() => $_has(6, 7);
  void clearIsError() => clearField(7);

  bool get isDocRw => $_get(7, 8, false);
  void set isDocRw(bool v) { $_setBool(7, 8, v); }
  bool hasIsDocRw() => $_has(7, 8);
  void clearIsDocRw() => clearField(8);

  List<String> get actionIdList => $_get(8, 10, null);

  List<DTrxAction> get actionList => $_get(9, 11, null);
}

class _ReadonlyDTrxStatus extends DTrxStatus with ReadonlyMessageMixin {}

class DTrxAction extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DTrxAction')
    ..a(1, 'id', PbFieldType.OS)
    ..a(2, 'value', PbFieldType.QS)
    ..a(3, 'label', PbFieldType.QS)
    ..a(4, 'seqNo', PbFieldType.O3)
    ..a(5, 'statusId', PbFieldType.OS)
  ;

  DTrxAction() : super();
  DTrxAction.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DTrxAction.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DTrxAction clone() => new DTrxAction()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DTrxAction create() => new DTrxAction();
  static PbList<DTrxAction> createRepeated() => new PbList<DTrxAction>();
  static DTrxAction getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyDTrxAction();
    return _defaultInstance;
  }
  static DTrxAction _defaultInstance;
  static void $checkItem(DTrxAction v) {
    if (v is !DTrxAction) checkItemFailed(v, 'DTrxAction');
  }

  String get id => $_get(0, 1, '');
  void set id(String v) { $_setString(0, 1, v); }
  bool hasId() => $_has(0, 1);
  void clearId() => clearField(1);

  String get value => $_get(1, 2, '');
  void set value(String v) { $_setString(1, 2, v); }
  bool hasValue() => $_has(1, 2);
  void clearValue() => clearField(2);

  String get label => $_get(2, 3, '');
  void set label(String v) { $_setString(2, 3, v); }
  bool hasLabel() => $_has(2, 3);
  void clearLabel() => clearField(3);

  int get seqNo => $_get(3, 4, 0);
  void set seqNo(int v) { $_setUnsignedInt32(3, 4, v); }
  bool hasSeqNo() => $_has(3, 4);
  void clearSeqNo() => clearField(4);

  String get statusId => $_get(4, 5, '');
  void set statusId(String v) { $_setString(4, 5, v); }
  bool hasStatusId() => $_has(4, 5);
  void clearStatusId() => clearField(5);
}

class _ReadonlyDTrxAction extends DTrxAction with ReadonlyMessageMixin {}

const DataType$json = const {
  '1': 'DataType',
  '2': const [
    const {'1': 'STRING', '2': 25},
    const {'1': 'ADDRESS', '2': 1},
    const {'1': 'AMOUNT', '2': 2},
    const {'1': 'BOOLEAN', '2': 3},
    const {'1': 'CODE', '2': 4},
    const {'1': 'COLOR', '2': 5},
    const {'1': 'CURRENCY', '2': 6},
    const {'1': 'DATA', '2': 7},
    const {'1': 'DATE', '2': 8},
    const {'1': 'DATETIME', '2': 9},
    const {'1': 'DECIMAL', '2': 10},
    const {'1': 'DURATION', '2': 11},
    const {'1': 'EMAIL', '2': 12},
    const {'1': 'FK', '2': 13},
    const {'1': 'GEO', '2': 14},
    const {'1': 'IM', '2': 15},
    const {'1': 'IMAGE', '2': 16},
    const {'1': 'INT', '2': 17},
    const {'1': 'NUMBER', '2': 18},
    const {'1': 'PASSWORD', '2': 19},
    const {'1': 'PHONE', '2': 20},
    const {'1': 'PICK', '2': 21},
    const {'1': 'PICKMULTI', '2': 22},
    const {'1': 'QUANTITY', '2': 23},
    const {'1': 'RATING', '2': 24},
    const {'1': 'TENANT', '2': 26},
    const {'1': 'TEXT', '2': 27},
    const {'1': 'TIME', '2': 28},
    const {'1': 'URL', '2': 29},
    const {'1': 'USER', '2': 30},
    const {'1': 'PICKAUTO', '2': 31},
    const {'1': 'PICKCHOICE', '2': 32},
    const {'1': 'PICKMULTICHOICE', '2': 33},
    const {'1': 'TIMEZONE', '2': 34},
    const {'1': 'TAG', '2': 35},
    const {'1': 'DURATIONHOUR', '2': 36},
  ],
};

const DTable$json = const {
  '1': 'DTable',
  '2': const [
    const {'1': 'table_id', '3': 1, '4': 1, '5': 9},
    const {'1': 'name', '3': 2, '4': 2, '5': 9},
    const {'1': 'label', '3': 3, '4': 1, '5': 9},
    const {'1': 'description', '3': 4, '4': 1, '5': 9},
    const {'1': 'help', '3': 5, '4': 1, '5': 9},
    const {'1': 'tutorial_url', '3': 6, '4': 1, '5': 9},
    const {'1': 'color', '3': 7, '4': 1, '5': 9},
    const {'1': 'external_key', '3': 8, '4': 1, '5': 9},
    const {'1': 'is_active', '3': 9, '4': 1, '5': 8, '7': 'true'},
    const {'1': 'column', '3': 10, '4': 3, '5': 11, '6': '.DColumn'},
    const {'1': 'icon_image', '3': 15, '4': 1, '5': 9},
    const {'1': 'is_read_only', '3': 20, '4': 1, '5': 8, '7': 'false'},
    const {'1': 'is_new_record_server', '3': 21, '4': 1, '5': 8, '7': 'false'},
    const {'1': 'note', '3': 26, '4': 1, '5': 9},
    const {'1': 'update_flag', '3': 30, '4': 1, '5': 9},
  ],
};

const DColumn$json = const {
  '1': 'DColumn',
  '2': const [
    const {'1': 'column_id', '3': 1, '4': 1, '5': 9},
    const {'1': 'name', '3': 2, '4': 2, '5': 9},
    const {'1': 'label', '3': 3, '4': 1, '5': 9},
    const {'1': 'label_suffix', '3': 4, '4': 1, '5': 9},
    const {'1': 'description', '3': 5, '4': 1, '5': 9},
    const {'1': 'is_active', '3': 7, '4': 1, '5': 8, '7': 'true'},
    const {'1': 'column_sql', '3': 8, '4': 1, '5': 9},
    const {'1': 'external_key', '3': 9, '4': 1, '5': 9},
    const {'1': 'data_type', '3': 10, '4': 2, '5': 14, '6': '.DataType'},
    const {'1': 'column_size', '3': 11, '4': 1, '5': 5},
    const {'1': 'decimal_digits', '3': 12, '4': 1, '5': 5, '7': '0'},
    const {'1': 'is_encrypted', '3': 20, '4': 1, '5': 8, '7': 'false'},
    const {'1': 'default_value', '3': 21, '4': 1, '5': 9},
    const {'1': 'format_mask', '3': 22, '4': 1, '5': 9},
    const {'1': 'val_from', '3': 23, '4': 1, '5': 9},
    const {'1': 'val_to', '3': 24, '4': 1, '5': 9},
    const {'1': 'help', '3': 25, '4': 1, '5': 9},
    const {'1': 'note', '3': 26, '4': 1, '5': 9},
    const {'1': 'validation_callout', '3': 27, '4': 1, '5': 9},
    const {'1': 'is_document_no', '3': 28, '4': 1, '5': 8, '7': 'false'},
    const {'1': 'is_mandatory', '3': 30, '4': 1, '5': 8, '7': 'false'},
    const {'1': 'is_read_only', '3': 31, '4': 1, '5': 8, '7': 'false'},
    const {'1': 'is_update_always', '3': 32, '4': 1, '5': 8, '7': 'false'},
    const {'1': 'is_translated', '3': 33, '4': 1, '5': 8, '7': 'false'},
    const {'1': 'is_translation', '3': 34, '4': 1, '5': 8, '7': 'false'},
    const {'1': 'is_copied', '3': 35, '4': 1, '5': 8, '7': 'true'},
    const {'1': 'is_calculated', '3': 36, '4': 1, '5': 8, '7': 'false'},
    const {'1': 'process_external_key', '3': 38, '4': 1, '5': 9},
    const {'1': 'is_pk', '3': 40, '4': 1, '5': 8, '7': 'false'},
    const {'1': 'is_parent_key', '3': 41, '4': 1, '5': 8, '7': 'false'},
    const {'1': 'fk_reference', '3': 42, '4': 1, '5': 9},
    const {'1': 'parent_column_id', '3': 43, '4': 1, '5': 9},
    const {'1': 'parent_reference', '3': 44, '4': 1, '5': 9},
    const {'1': 'restriction_sql', '3': 45, '4': 1, '5': 9},
    const {'1': 'pick_list_id', '3': 46, '4': 1, '5': 9},
    const {'1': 'pick_list_name', '3': 47, '4': 1, '5': 9},
    const {'1': 'pick_list_size', '3': 48, '4': 1, '5': 5},
    const {'1': 'is_pick_list_extensible', '3': 49, '4': 1, '5': 8},
    const {'1': 'unique_seq_no', '3': 50, '4': 1, '5': 5, '7': '0'},
    const {'1': 'display_seq_no', '3': 51, '4': 1, '5': 5, '7': '0'},
    const {'1': 'pick_value', '3': 60, '4': 3, '5': 11, '6': '.DOption'},
    const {'1': 'temp_external_key', '3': 61, '4': 1, '5': 9},
    const {'1': 'update_flag', '3': 63, '4': 1, '5': 9},
  ],
};

const DOption$json = const {
  '1': 'DOption',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9},
    const {'1': 'value', '3': 2, '4': 2, '5': 9},
    const {'1': 'label', '3': 3, '4': 2, '5': 9},
    const {'1': 'description', '3': 4, '4': 1, '5': 9},
    const {'1': 'icon_image', '3': 5, '4': 1, '5': 9},
    const {'1': 'is_selected', '3': 6, '4': 1, '5': 8, '7': 'false'},
    const {'1': 'is_opt_group', '3': 7, '4': 1, '5': 8, '7': 'false'},
    const {'1': 'seq_no', '3': 10, '4': 1, '5': 5},
    const {'1': 'is_active', '3': 11, '4': 1, '5': 8, '7': 'true'},
    const {'1': 'is_default', '3': 12, '4': 1, '5': 8, '7': 'false'},
    const {'1': 'reference_id', '3': 15, '4': 1, '5': 9},
    const {'1': 'css_class', '3': 16, '4': 1, '5': 9},
    const {'1': 'css_color', '3': 17, '4': 1, '5': 9},
    const {'1': 'validation', '3': 20, '4': 3, '5': 11, '6': '.DKeyValue'},
    const {'1': 'update_flag', '3': 30, '4': 1, '5': 9},
  ],
};

const DProperty$json = const {
  '1': 'DProperty',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9},
    const {'1': 'name', '3': 2, '4': 2, '5': 9},
    const {'1': 'label', '3': 3, '4': 1, '5': 9},
    const {'1': 'description', '3': 4, '4': 1, '5': 9},
    const {'1': 'help', '3': 5, '4': 1, '5': 9},
    const {'1': 'seq_no', '3': 6, '4': 1, '5': 5},
    const {'1': 'is_range', '3': 7, '4': 1, '5': 8, '7': 'false'},
    const {'1': 'is_mandatory', '3': 8, '4': 1, '5': 8, '7': 'true'},
    const {'1': 'is_read_only', '3': 9, '4': 1, '5': 8, '7': 'false'},
    const {'1': 'dataType', '3': 10, '4': 1, '5': 14, '6': '.DataType'},
    const {'1': 'column_size', '3': 11, '4': 1, '5': 5},
    const {'1': 'decimal_digits', '3': 12, '4': 1, '5': 5, '7': '0'},
    const {'1': 'default_value', '3': 13, '4': 1, '5': 9},
    const {'1': 'default_value_to', '3': 14, '4': 1, '5': 9},
    const {'1': 'pick_list_name', '3': 15, '4': 1, '5': 9},
    const {'1': 'pick_value', '3': 16, '4': 3, '5': 11, '6': '.DOption'},
    const {'1': 'format_mask', '3': 20, '4': 1, '5': 9},
    const {'1': 'val_from', '3': 21, '4': 1, '5': 9},
    const {'1': 'val_to', '3': 22, '4': 1, '5': 9},
    const {'1': 'fk_reference', '3': 23, '4': 1, '5': 9},
    const {'1': 'value', '3': 30, '4': 1, '5': 9},
    const {'1': 'value_to', '3': 31, '4': 1, '5': 9},
    const {'1': 'is_changed', '3': 32, '4': 1, '5': 8, '7': 'false'},
    const {'1': 'value_original', '3': 33, '4': 1, '5': 9},
    const {'1': 'is_valid', '3': 34, '4': 1, '5': 8, '7': 'true'},
    const {'1': 'update_flag', '3': 40, '4': 1, '5': 9},
  ],
};

const DTrxState$json = const {
  '1': 'DTrxState',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9},
    const {'1': 'name', '3': 2, '4': 2, '5': 9},
    const {'1': 'tenant_id', '3': 3, '4': 1, '5': 9},
    const {'1': 'table_id', '3': 5, '4': 1, '5': 9},
    const {'1': 'table_name', '3': 6, '4': 1, '5': 9},
    const {'1': 'is_default', '3': 7, '4': 1, '5': 8, '7': 'false'},
    const {'1': 'chart_url', '3': 9, '4': 1, '5': 9},
    const {'1': 'status', '3': 10, '4': 3, '5': 11, '6': '.DTrxStatus'},
    const {'1': 'action', '3': 11, '4': 3, '5': 11, '6': '.DTrxAction'},
  ],
};

const DTrxStatus$json = const {
  '1': 'DTrxStatus',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9},
    const {'1': 'value', '3': 2, '4': 2, '5': 9},
    const {'1': 'label', '3': 3, '4': 2, '5': 9},
    const {'1': 'seq_no', '3': 4, '4': 1, '5': 5},
    const {'1': 'is_initial_state', '3': 5, '4': 1, '5': 8, '7': 'false'},
    const {'1': 'is_final_state', '3': 6, '4': 1, '5': 8, '7': 'false'},
    const {'1': 'is_error', '3': 7, '4': 1, '5': 8, '7': 'false'},
    const {'1': 'is_doc_rw', '3': 8, '4': 1, '5': 8, '7': 'false'},
    const {'1': 'action_id', '3': 10, '4': 3, '5': 9},
    const {'1': 'action', '3': 11, '4': 3, '5': 11, '6': '.DTrxAction'},
  ],
};

const DTrxAction$json = const {
  '1': 'DTrxAction',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9},
    const {'1': 'value', '3': 2, '4': 2, '5': 9},
    const {'1': 'label', '3': 3, '4': 2, '5': 9},
    const {'1': 'seq_no', '3': 4, '4': 1, '5': 5},
    const {'1': 'status_id', '3': 5, '4': 1, '5': 9},
  ],
};

