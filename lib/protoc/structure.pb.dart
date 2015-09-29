///
//  Generated code. Do not modify.
///
library structure;

import 'package:protobuf/protobuf.dart';
import 'rr.pb.dart';

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
  ];

  static final Map<int, DataType> _byValue = ProtobufEnum.initByValue(values);
  static DataType valueOf(int value) => _byValue[value];

  const DataType._(int v, String n) : super(v, n);
}

class DTable extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DTable')
    ..a(1, 'tableId', GeneratedMessage.OS)
    ..a(2, 'name', GeneratedMessage.QS)
    ..a(3, 'label', GeneratedMessage.OS)
    ..a(4, 'description', GeneratedMessage.OS)
    ..a(5, 'help', GeneratedMessage.OS)
    ..a(6, 'tutorialUrl', GeneratedMessage.OS)
    ..a(7, 'color', GeneratedMessage.OS)
    ..a(8, 'externalKey', GeneratedMessage.OS)
    ..a(9, 'isActive', GeneratedMessage.OB, true)
    ..m(10, 'column', DColumn.create, DColumn.createRepeated)
    ..a(15, 'iconImage', GeneratedMessage.OS)
    ..a(20, 'isReadOnly', GeneratedMessage.OB)
    ..a(21, 'isNewRecordServer', GeneratedMessage.OB)
    ..a(26, 'note', GeneratedMessage.OS)
    ..a(30, 'updateFlag', GeneratedMessage.OS)
  ;

  DTable() : super();
  DTable.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DTable.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DTable clone() => new DTable()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DTable create() => new DTable();
  static PbList<DTable> createRepeated() => new PbList<DTable>();

  String get tableId => getField(1);
  void set tableId(String v) { setField(1, v); }
  bool hasTableId() => hasField(1);
  void clearTableId() => clearField(1);

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

  String get help => getField(5);
  void set help(String v) { setField(5, v); }
  bool hasHelp() => hasField(5);
  void clearHelp() => clearField(5);

  String get tutorialUrl => getField(6);
  void set tutorialUrl(String v) { setField(6, v); }
  bool hasTutorialUrl() => hasField(6);
  void clearTutorialUrl() => clearField(6);

  String get color => getField(7);
  void set color(String v) { setField(7, v); }
  bool hasColor() => hasField(7);
  void clearColor() => clearField(7);

  String get externalKey => getField(8);
  void set externalKey(String v) { setField(8, v); }
  bool hasExternalKey() => hasField(8);
  void clearExternalKey() => clearField(8);

  bool get isActive => getField(9);
  void set isActive(bool v) { setField(9, v); }
  bool hasIsActive() => hasField(9);
  void clearIsActive() => clearField(9);

  List<DColumn> get columnList => getField(10);

  String get iconImage => getField(15);
  void set iconImage(String v) { setField(15, v); }
  bool hasIconImage() => hasField(15);
  void clearIconImage() => clearField(15);

  bool get isReadOnly => getField(20);
  void set isReadOnly(bool v) { setField(20, v); }
  bool hasIsReadOnly() => hasField(20);
  void clearIsReadOnly() => clearField(20);

  bool get isNewRecordServer => getField(21);
  void set isNewRecordServer(bool v) { setField(21, v); }
  bool hasIsNewRecordServer() => hasField(21);
  void clearIsNewRecordServer() => clearField(21);

  String get note => getField(26);
  void set note(String v) { setField(26, v); }
  bool hasNote() => hasField(26);
  void clearNote() => clearField(26);

  String get updateFlag => getField(30);
  void set updateFlag(String v) { setField(30, v); }
  bool hasUpdateFlag() => hasField(30);
  void clearUpdateFlag() => clearField(30);
}

class DColumn extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DColumn')
    ..a(1, 'columnId', GeneratedMessage.OS)
    ..a(2, 'name', GeneratedMessage.QS)
    ..a(3, 'label', GeneratedMessage.OS)
    ..a(4, 'labelSuffix', GeneratedMessage.OS)
    ..a(5, 'description', GeneratedMessage.OS)
    ..a(7, 'isActive', GeneratedMessage.OB, true)
    ..a(8, 'columnSql', GeneratedMessage.OS)
    ..a(9, 'externalKey', GeneratedMessage.OS)
    ..e(10, 'dataType', GeneratedMessage.QE, DataType.STRING, (var v) => DataType.valueOf(v))
    ..a(11, 'columnSize', GeneratedMessage.O3)
    ..a(12, 'decimalDigits', GeneratedMessage.O3)
    ..a(20, 'isEncrypted', GeneratedMessage.OB)
    ..a(21, 'defaultValue', GeneratedMessage.OS)
    ..a(22, 'formatMask', GeneratedMessage.OS)
    ..a(23, 'valFrom', GeneratedMessage.OS)
    ..a(24, 'valTo', GeneratedMessage.OS)
    ..a(25, 'help', GeneratedMessage.OS)
    ..a(26, 'note', GeneratedMessage.OS)
    ..a(27, 'validationCallout', GeneratedMessage.OS)
    ..a(28, 'isDocumentNo', GeneratedMessage.OB)
    ..a(30, 'isMandatory', GeneratedMessage.OB)
    ..a(31, 'isReadOnly', GeneratedMessage.OB)
    ..a(32, 'isUpdateAlways', GeneratedMessage.OB)
    ..a(33, 'isTranslated', GeneratedMessage.OB)
    ..a(34, 'isTranslation', GeneratedMessage.OB)
    ..a(35, 'isCopied', GeneratedMessage.OB, true)
    ..a(36, 'isCalculated', GeneratedMessage.OB)
    ..a(38, 'processExternalKey', GeneratedMessage.OS)
    ..a(40, 'isPk', GeneratedMessage.OB)
    ..a(41, 'isParentKey', GeneratedMessage.OB)
    ..a(42, 'fkReference', GeneratedMessage.OS)
    ..a(43, 'parentColumnId', GeneratedMessage.OS)
    ..a(44, 'parentReference', GeneratedMessage.OS)
    ..a(45, 'restrictionSql', GeneratedMessage.OS)
    ..a(46, 'pickListId', GeneratedMessage.OS)
    ..a(47, 'pickListName', GeneratedMessage.OS)
    ..a(48, 'pickListSize', GeneratedMessage.O3)
    ..a(49, 'isPickListExtensible', GeneratedMessage.OB)
    ..a(50, 'uniqueSeqNo', GeneratedMessage.O3)
    ..a(51, 'displaySeqNo', GeneratedMessage.O3)
    ..m(60, 'pickValue', DOption.create, DOption.createRepeated)
    ..a(61, 'tempExternalKey', GeneratedMessage.OS)
    ..a(63, 'updateFlag', GeneratedMessage.OS)
  ;

  DColumn() : super();
  DColumn.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DColumn.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DColumn clone() => new DColumn()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DColumn create() => new DColumn();
  static PbList<DColumn> createRepeated() => new PbList<DColumn>();

  String get columnId => getField(1);
  void set columnId(String v) { setField(1, v); }
  bool hasColumnId() => hasField(1);
  void clearColumnId() => clearField(1);

  String get name => getField(2);
  void set name(String v) { setField(2, v); }
  bool hasName() => hasField(2);
  void clearName() => clearField(2);

  String get label => getField(3);
  void set label(String v) { setField(3, v); }
  bool hasLabel() => hasField(3);
  void clearLabel() => clearField(3);

  String get labelSuffix => getField(4);
  void set labelSuffix(String v) { setField(4, v); }
  bool hasLabelSuffix() => hasField(4);
  void clearLabelSuffix() => clearField(4);

  String get description => getField(5);
  void set description(String v) { setField(5, v); }
  bool hasDescription() => hasField(5);
  void clearDescription() => clearField(5);

  bool get isActive => getField(7);
  void set isActive(bool v) { setField(7, v); }
  bool hasIsActive() => hasField(7);
  void clearIsActive() => clearField(7);

  String get columnSql => getField(8);
  void set columnSql(String v) { setField(8, v); }
  bool hasColumnSql() => hasField(8);
  void clearColumnSql() => clearField(8);

  String get externalKey => getField(9);
  void set externalKey(String v) { setField(9, v); }
  bool hasExternalKey() => hasField(9);
  void clearExternalKey() => clearField(9);

  DataType get dataType => getField(10);
  void set dataType(DataType v) { setField(10, v); }
  bool hasDataType() => hasField(10);
  void clearDataType() => clearField(10);

  int get columnSize => getField(11);
  void set columnSize(int v) { setField(11, v); }
  bool hasColumnSize() => hasField(11);
  void clearColumnSize() => clearField(11);

  int get decimalDigits => getField(12);
  void set decimalDigits(int v) { setField(12, v); }
  bool hasDecimalDigits() => hasField(12);
  void clearDecimalDigits() => clearField(12);

  bool get isEncrypted => getField(20);
  void set isEncrypted(bool v) { setField(20, v); }
  bool hasIsEncrypted() => hasField(20);
  void clearIsEncrypted() => clearField(20);

  String get defaultValue => getField(21);
  void set defaultValue(String v) { setField(21, v); }
  bool hasDefaultValue() => hasField(21);
  void clearDefaultValue() => clearField(21);

  String get formatMask => getField(22);
  void set formatMask(String v) { setField(22, v); }
  bool hasFormatMask() => hasField(22);
  void clearFormatMask() => clearField(22);

  String get valFrom => getField(23);
  void set valFrom(String v) { setField(23, v); }
  bool hasValFrom() => hasField(23);
  void clearValFrom() => clearField(23);

  String get valTo => getField(24);
  void set valTo(String v) { setField(24, v); }
  bool hasValTo() => hasField(24);
  void clearValTo() => clearField(24);

  String get help => getField(25);
  void set help(String v) { setField(25, v); }
  bool hasHelp() => hasField(25);
  void clearHelp() => clearField(25);

  String get note => getField(26);
  void set note(String v) { setField(26, v); }
  bool hasNote() => hasField(26);
  void clearNote() => clearField(26);

  String get validationCallout => getField(27);
  void set validationCallout(String v) { setField(27, v); }
  bool hasValidationCallout() => hasField(27);
  void clearValidationCallout() => clearField(27);

  bool get isDocumentNo => getField(28);
  void set isDocumentNo(bool v) { setField(28, v); }
  bool hasIsDocumentNo() => hasField(28);
  void clearIsDocumentNo() => clearField(28);

  bool get isMandatory => getField(30);
  void set isMandatory(bool v) { setField(30, v); }
  bool hasIsMandatory() => hasField(30);
  void clearIsMandatory() => clearField(30);

  bool get isReadOnly => getField(31);
  void set isReadOnly(bool v) { setField(31, v); }
  bool hasIsReadOnly() => hasField(31);
  void clearIsReadOnly() => clearField(31);

  bool get isUpdateAlways => getField(32);
  void set isUpdateAlways(bool v) { setField(32, v); }
  bool hasIsUpdateAlways() => hasField(32);
  void clearIsUpdateAlways() => clearField(32);

  bool get isTranslated => getField(33);
  void set isTranslated(bool v) { setField(33, v); }
  bool hasIsTranslated() => hasField(33);
  void clearIsTranslated() => clearField(33);

  bool get isTranslation => getField(34);
  void set isTranslation(bool v) { setField(34, v); }
  bool hasIsTranslation() => hasField(34);
  void clearIsTranslation() => clearField(34);

  bool get isCopied => getField(35);
  void set isCopied(bool v) { setField(35, v); }
  bool hasIsCopied() => hasField(35);
  void clearIsCopied() => clearField(35);

  bool get isCalculated => getField(36);
  void set isCalculated(bool v) { setField(36, v); }
  bool hasIsCalculated() => hasField(36);
  void clearIsCalculated() => clearField(36);

  String get processExternalKey => getField(38);
  void set processExternalKey(String v) { setField(38, v); }
  bool hasProcessExternalKey() => hasField(38);
  void clearProcessExternalKey() => clearField(38);

  bool get isPk => getField(40);
  void set isPk(bool v) { setField(40, v); }
  bool hasIsPk() => hasField(40);
  void clearIsPk() => clearField(40);

  bool get isParentKey => getField(41);
  void set isParentKey(bool v) { setField(41, v); }
  bool hasIsParentKey() => hasField(41);
  void clearIsParentKey() => clearField(41);

  String get fkReference => getField(42);
  void set fkReference(String v) { setField(42, v); }
  bool hasFkReference() => hasField(42);
  void clearFkReference() => clearField(42);

  String get parentColumnId => getField(43);
  void set parentColumnId(String v) { setField(43, v); }
  bool hasParentColumnId() => hasField(43);
  void clearParentColumnId() => clearField(43);

  String get parentReference => getField(44);
  void set parentReference(String v) { setField(44, v); }
  bool hasParentReference() => hasField(44);
  void clearParentReference() => clearField(44);

  String get restrictionSql => getField(45);
  void set restrictionSql(String v) { setField(45, v); }
  bool hasRestrictionSql() => hasField(45);
  void clearRestrictionSql() => clearField(45);

  String get pickListId => getField(46);
  void set pickListId(String v) { setField(46, v); }
  bool hasPickListId() => hasField(46);
  void clearPickListId() => clearField(46);

  String get pickListName => getField(47);
  void set pickListName(String v) { setField(47, v); }
  bool hasPickListName() => hasField(47);
  void clearPickListName() => clearField(47);

  int get pickListSize => getField(48);
  void set pickListSize(int v) { setField(48, v); }
  bool hasPickListSize() => hasField(48);
  void clearPickListSize() => clearField(48);

  bool get isPickListExtensible => getField(49);
  void set isPickListExtensible(bool v) { setField(49, v); }
  bool hasIsPickListExtensible() => hasField(49);
  void clearIsPickListExtensible() => clearField(49);

  int get uniqueSeqNo => getField(50);
  void set uniqueSeqNo(int v) { setField(50, v); }
  bool hasUniqueSeqNo() => hasField(50);
  void clearUniqueSeqNo() => clearField(50);

  int get displaySeqNo => getField(51);
  void set displaySeqNo(int v) { setField(51, v); }
  bool hasDisplaySeqNo() => hasField(51);
  void clearDisplaySeqNo() => clearField(51);

  List<DOption> get pickValueList => getField(60);

  String get tempExternalKey => getField(61);
  void set tempExternalKey(String v) { setField(61, v); }
  bool hasTempExternalKey() => hasField(61);
  void clearTempExternalKey() => clearField(61);

  String get updateFlag => getField(63);
  void set updateFlag(String v) { setField(63, v); }
  bool hasUpdateFlag() => hasField(63);
  void clearUpdateFlag() => clearField(63);
}

class DOption extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DOption')
    ..a(1, 'id', GeneratedMessage.OS)
    ..a(2, 'value', GeneratedMessage.QS)
    ..a(3, 'label', GeneratedMessage.QS)
    ..a(4, 'description', GeneratedMessage.OS)
    ..a(5, 'iconImage', GeneratedMessage.OS)
    ..a(6, 'isSelected', GeneratedMessage.OB)
    ..a(7, 'isOptGroup', GeneratedMessage.OB)
    ..a(10, 'seqNo', GeneratedMessage.O3)
    ..a(11, 'isActive', GeneratedMessage.OB, true)
    ..a(12, 'isDefault', GeneratedMessage.OB)
    ..a(15, 'referenceId', GeneratedMessage.OS)
    ..a(16, 'cssClass', GeneratedMessage.OS)
    ..a(17, 'cssColor', GeneratedMessage.OS)
    ..m(20, 'validation', DKeyValue.create, DKeyValue.createRepeated)
    ..a(30, 'updateFlag', GeneratedMessage.OS)
  ;

  DOption() : super();
  DOption.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DOption.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DOption clone() => new DOption()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DOption create() => new DOption();
  static PbList<DOption> createRepeated() => new PbList<DOption>();

  String get id => getField(1);
  void set id(String v) { setField(1, v); }
  bool hasId() => hasField(1);
  void clearId() => clearField(1);

  String get value => getField(2);
  void set value(String v) { setField(2, v); }
  bool hasValue() => hasField(2);
  void clearValue() => clearField(2);

  String get label => getField(3);
  void set label(String v) { setField(3, v); }
  bool hasLabel() => hasField(3);
  void clearLabel() => clearField(3);

  String get description => getField(4);
  void set description(String v) { setField(4, v); }
  bool hasDescription() => hasField(4);
  void clearDescription() => clearField(4);

  String get iconImage => getField(5);
  void set iconImage(String v) { setField(5, v); }
  bool hasIconImage() => hasField(5);
  void clearIconImage() => clearField(5);

  bool get isSelected => getField(6);
  void set isSelected(bool v) { setField(6, v); }
  bool hasIsSelected() => hasField(6);
  void clearIsSelected() => clearField(6);

  bool get isOptGroup => getField(7);
  void set isOptGroup(bool v) { setField(7, v); }
  bool hasIsOptGroup() => hasField(7);
  void clearIsOptGroup() => clearField(7);

  int get seqNo => getField(10);
  void set seqNo(int v) { setField(10, v); }
  bool hasSeqNo() => hasField(10);
  void clearSeqNo() => clearField(10);

  bool get isActive => getField(11);
  void set isActive(bool v) { setField(11, v); }
  bool hasIsActive() => hasField(11);
  void clearIsActive() => clearField(11);

  bool get isDefault => getField(12);
  void set isDefault(bool v) { setField(12, v); }
  bool hasIsDefault() => hasField(12);
  void clearIsDefault() => clearField(12);

  String get referenceId => getField(15);
  void set referenceId(String v) { setField(15, v); }
  bool hasReferenceId() => hasField(15);
  void clearReferenceId() => clearField(15);

  String get cssClass => getField(16);
  void set cssClass(String v) { setField(16, v); }
  bool hasCssClass() => hasField(16);
  void clearCssClass() => clearField(16);

  String get cssColor => getField(17);
  void set cssColor(String v) { setField(17, v); }
  bool hasCssColor() => hasField(17);
  void clearCssColor() => clearField(17);

  List<DKeyValue> get validationList => getField(20);

  String get updateFlag => getField(30);
  void set updateFlag(String v) { setField(30, v); }
  bool hasUpdateFlag() => hasField(30);
  void clearUpdateFlag() => clearField(30);
}

class DProperty extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DProperty')
    ..a(1, 'id', GeneratedMessage.OS)
    ..a(2, 'name', GeneratedMessage.QS)
    ..a(3, 'label', GeneratedMessage.OS)
    ..a(4, 'description', GeneratedMessage.OS)
    ..a(5, 'help', GeneratedMessage.OS)
    ..a(6, 'seqNo', GeneratedMessage.O3)
    ..a(7, 'isRange', GeneratedMessage.OB)
    ..a(8, 'isMandatory', GeneratedMessage.OB, true)
    ..a(9, 'isReadOnly', GeneratedMessage.OB)
    ..e(10, 'dataType', GeneratedMessage.OE, DataType.STRING, (var v) => DataType.valueOf(v))
    ..a(11, 'columnSize', GeneratedMessage.O3)
    ..a(12, 'decimalDigits', GeneratedMessage.O3)
    ..a(13, 'defaultValue', GeneratedMessage.OS)
    ..a(14, 'defaultValueTo', GeneratedMessage.OS)
    ..a(15, 'pickListName', GeneratedMessage.OS)
    ..m(16, 'pickValue', DOption.create, DOption.createRepeated)
    ..a(20, 'formatMask', GeneratedMessage.OS)
    ..a(21, 'valFrom', GeneratedMessage.OS)
    ..a(22, 'valTo', GeneratedMessage.OS)
    ..a(23, 'fkReference', GeneratedMessage.OS)
    ..a(30, 'value', GeneratedMessage.OS)
    ..a(31, 'valueTo', GeneratedMessage.OS)
    ..a(32, 'isChanged', GeneratedMessage.OB)
    ..a(33, 'valueOriginal', GeneratedMessage.OS)
    ..a(34, 'isValid', GeneratedMessage.OB, true)
    ..a(40, 'updateFlag', GeneratedMessage.OS)
  ;

  DProperty() : super();
  DProperty.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DProperty.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DProperty clone() => new DProperty()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DProperty create() => new DProperty();
  static PbList<DProperty> createRepeated() => new PbList<DProperty>();

  String get id => getField(1);
  void set id(String v) { setField(1, v); }
  bool hasId() => hasField(1);
  void clearId() => clearField(1);

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

  String get help => getField(5);
  void set help(String v) { setField(5, v); }
  bool hasHelp() => hasField(5);
  void clearHelp() => clearField(5);

  int get seqNo => getField(6);
  void set seqNo(int v) { setField(6, v); }
  bool hasSeqNo() => hasField(6);
  void clearSeqNo() => clearField(6);

  bool get isRange => getField(7);
  void set isRange(bool v) { setField(7, v); }
  bool hasIsRange() => hasField(7);
  void clearIsRange() => clearField(7);

  bool get isMandatory => getField(8);
  void set isMandatory(bool v) { setField(8, v); }
  bool hasIsMandatory() => hasField(8);
  void clearIsMandatory() => clearField(8);

  bool get isReadOnly => getField(9);
  void set isReadOnly(bool v) { setField(9, v); }
  bool hasIsReadOnly() => hasField(9);
  void clearIsReadOnly() => clearField(9);

  DataType get dataType => getField(10);
  void set dataType(DataType v) { setField(10, v); }
  bool hasDataType() => hasField(10);
  void clearDataType() => clearField(10);

  int get columnSize => getField(11);
  void set columnSize(int v) { setField(11, v); }
  bool hasColumnSize() => hasField(11);
  void clearColumnSize() => clearField(11);

  int get decimalDigits => getField(12);
  void set decimalDigits(int v) { setField(12, v); }
  bool hasDecimalDigits() => hasField(12);
  void clearDecimalDigits() => clearField(12);

  String get defaultValue => getField(13);
  void set defaultValue(String v) { setField(13, v); }
  bool hasDefaultValue() => hasField(13);
  void clearDefaultValue() => clearField(13);

  String get defaultValueTo => getField(14);
  void set defaultValueTo(String v) { setField(14, v); }
  bool hasDefaultValueTo() => hasField(14);
  void clearDefaultValueTo() => clearField(14);

  String get pickListName => getField(15);
  void set pickListName(String v) { setField(15, v); }
  bool hasPickListName() => hasField(15);
  void clearPickListName() => clearField(15);

  List<DOption> get pickValueList => getField(16);

  String get formatMask => getField(20);
  void set formatMask(String v) { setField(20, v); }
  bool hasFormatMask() => hasField(20);
  void clearFormatMask() => clearField(20);

  String get valFrom => getField(21);
  void set valFrom(String v) { setField(21, v); }
  bool hasValFrom() => hasField(21);
  void clearValFrom() => clearField(21);

  String get valTo => getField(22);
  void set valTo(String v) { setField(22, v); }
  bool hasValTo() => hasField(22);
  void clearValTo() => clearField(22);

  String get fkReference => getField(23);
  void set fkReference(String v) { setField(23, v); }
  bool hasFkReference() => hasField(23);
  void clearFkReference() => clearField(23);

  String get value => getField(30);
  void set value(String v) { setField(30, v); }
  bool hasValue() => hasField(30);
  void clearValue() => clearField(30);

  String get valueTo => getField(31);
  void set valueTo(String v) { setField(31, v); }
  bool hasValueTo() => hasField(31);
  void clearValueTo() => clearField(31);

  bool get isChanged => getField(32);
  void set isChanged(bool v) { setField(32, v); }
  bool hasIsChanged() => hasField(32);
  void clearIsChanged() => clearField(32);

  String get valueOriginal => getField(33);
  void set valueOriginal(String v) { setField(33, v); }
  bool hasValueOriginal() => hasField(33);
  void clearValueOriginal() => clearField(33);

  bool get isValid => getField(34);
  void set isValid(bool v) { setField(34, v); }
  bool hasIsValid() => hasField(34);
  void clearIsValid() => clearField(34);

  String get updateFlag => getField(40);
  void set updateFlag(String v) { setField(40, v); }
  bool hasUpdateFlag() => hasField(40);
  void clearUpdateFlag() => clearField(40);
}

class DTrxState extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DTrxState')
    ..a(1, 'id', GeneratedMessage.OS)
    ..a(2, 'name', GeneratedMessage.QS)
    ..a(3, 'tenantId', GeneratedMessage.OS)
    ..a(5, 'tableId', GeneratedMessage.OS)
    ..a(6, 'tableName', GeneratedMessage.OS)
    ..a(7, 'isDefault', GeneratedMessage.OB)
    ..a(9, 'chartUrl', GeneratedMessage.OS)
    ..m(10, 'status', DTrxStatus.create, DTrxStatus.createRepeated)
    ..m(11, 'action', DTrxAction.create, DTrxAction.createRepeated)
  ;

  DTrxState() : super();
  DTrxState.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DTrxState.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DTrxState clone() => new DTrxState()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DTrxState create() => new DTrxState();
  static PbList<DTrxState> createRepeated() => new PbList<DTrxState>();

  String get id => getField(1);
  void set id(String v) { setField(1, v); }
  bool hasId() => hasField(1);
  void clearId() => clearField(1);

  String get name => getField(2);
  void set name(String v) { setField(2, v); }
  bool hasName() => hasField(2);
  void clearName() => clearField(2);

  String get tenantId => getField(3);
  void set tenantId(String v) { setField(3, v); }
  bool hasTenantId() => hasField(3);
  void clearTenantId() => clearField(3);

  String get tableId => getField(5);
  void set tableId(String v) { setField(5, v); }
  bool hasTableId() => hasField(5);
  void clearTableId() => clearField(5);

  String get tableName => getField(6);
  void set tableName(String v) { setField(6, v); }
  bool hasTableName() => hasField(6);
  void clearTableName() => clearField(6);

  bool get isDefault => getField(7);
  void set isDefault(bool v) { setField(7, v); }
  bool hasIsDefault() => hasField(7);
  void clearIsDefault() => clearField(7);

  String get chartUrl => getField(9);
  void set chartUrl(String v) { setField(9, v); }
  bool hasChartUrl() => hasField(9);
  void clearChartUrl() => clearField(9);

  List<DTrxStatus> get statusList => getField(10);

  List<DTrxAction> get actionList => getField(11);
}

class DTrxStatus extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DTrxStatus')
    ..a(1, 'id', GeneratedMessage.OS)
    ..a(2, 'value', GeneratedMessage.QS)
    ..a(3, 'label', GeneratedMessage.QS)
    ..a(4, 'seqNo', GeneratedMessage.O3)
    ..a(5, 'isInitialState', GeneratedMessage.OB)
    ..a(6, 'isFinalState', GeneratedMessage.OB)
    ..a(7, 'isError', GeneratedMessage.OB)
    ..a(8, 'isDocRw', GeneratedMessage.OB)
    ..p(10, 'actionId', GeneratedMessage.PS)
    ..m(11, 'action', DTrxAction.create, DTrxAction.createRepeated)
  ;

  DTrxStatus() : super();
  DTrxStatus.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DTrxStatus.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DTrxStatus clone() => new DTrxStatus()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DTrxStatus create() => new DTrxStatus();
  static PbList<DTrxStatus> createRepeated() => new PbList<DTrxStatus>();

  String get id => getField(1);
  void set id(String v) { setField(1, v); }
  bool hasId() => hasField(1);
  void clearId() => clearField(1);

  String get value => getField(2);
  void set value(String v) { setField(2, v); }
  bool hasValue() => hasField(2);
  void clearValue() => clearField(2);

  String get label => getField(3);
  void set label(String v) { setField(3, v); }
  bool hasLabel() => hasField(3);
  void clearLabel() => clearField(3);

  int get seqNo => getField(4);
  void set seqNo(int v) { setField(4, v); }
  bool hasSeqNo() => hasField(4);
  void clearSeqNo() => clearField(4);

  bool get isInitialState => getField(5);
  void set isInitialState(bool v) { setField(5, v); }
  bool hasIsInitialState() => hasField(5);
  void clearIsInitialState() => clearField(5);

  bool get isFinalState => getField(6);
  void set isFinalState(bool v) { setField(6, v); }
  bool hasIsFinalState() => hasField(6);
  void clearIsFinalState() => clearField(6);

  bool get isError => getField(7);
  void set isError(bool v) { setField(7, v); }
  bool hasIsError() => hasField(7);
  void clearIsError() => clearField(7);

  bool get isDocRw => getField(8);
  void set isDocRw(bool v) { setField(8, v); }
  bool hasIsDocRw() => hasField(8);
  void clearIsDocRw() => clearField(8);

  List<String> get actionIdList => getField(10);

  List<DTrxAction> get actionList => getField(11);
}

class DTrxAction extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DTrxAction')
    ..a(1, 'id', GeneratedMessage.OS)
    ..a(2, 'value', GeneratedMessage.QS)
    ..a(3, 'label', GeneratedMessage.QS)
    ..a(4, 'seqNo', GeneratedMessage.O3)
    ..a(5, 'statusId', GeneratedMessage.OS)
  ;

  DTrxAction() : super();
  DTrxAction.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DTrxAction.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DTrxAction clone() => new DTrxAction()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DTrxAction create() => new DTrxAction();
  static PbList<DTrxAction> createRepeated() => new PbList<DTrxAction>();

  String get id => getField(1);
  void set id(String v) { setField(1, v); }
  bool hasId() => hasField(1);
  void clearId() => clearField(1);

  String get value => getField(2);
  void set value(String v) { setField(2, v); }
  bool hasValue() => hasField(2);
  void clearValue() => clearField(2);

  String get label => getField(3);
  void set label(String v) { setField(3, v); }
  bool hasLabel() => hasField(3);
  void clearLabel() => clearField(3);

  int get seqNo => getField(4);
  void set seqNo(int v) { setField(4, v); }
  bool hasSeqNo() => hasField(4);
  void clearSeqNo() => clearField(4);

  String get statusId => getField(5);
  void set statusId(String v) { setField(5, v); }
  bool hasStatusId() => hasField(5);
  void clearStatusId() => clearField(5);
}

