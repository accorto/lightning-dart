/**
 * Generated Protocol Buffers code. Do not modify.
 */
library protoc.graph;

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart';

class GraphType extends ProtobufEnum {
  static const GraphType PIE = const GraphType._(1, 'PIE');
  static const GraphType BAR = const GraphType._(2, 'BAR');

  static const List<GraphType> values = const <GraphType> [
    PIE,
    BAR,
  ];

  static final Map<int, GraphType> _byValue = ProtobufEnum.initByValue(values);
  static GraphType valueOf(int value) => _byValue[value];
  static void $checkItem(GraphType v) {
    if (v is !GraphType) checkItemFailed(v, 'GraphType');
  }

  const GraphType._(int v, String n) : super(v, n);
}

class GraphDataType extends ProtobufEnum {
  static const GraphDataType G_STRING = const GraphDataType._(1, 'G_STRING');
  static const GraphDataType G_NUMBER = const GraphDataType._(2, 'G_NUMBER');
  static const GraphDataType G_BOOLEAN = const GraphDataType._(3, 'G_BOOLEAN');
  static const GraphDataType G_DATE = const GraphDataType._(4, 'G_DATE');
  static const GraphDataType G_DATETIME = const GraphDataType._(5, 'G_DATETIME');
  static const GraphDataType G_TIMEOFDAY = const GraphDataType._(6, 'G_TIMEOFDAY');

  static const List<GraphDataType> values = const <GraphDataType> [
    G_STRING,
    G_NUMBER,
    G_BOOLEAN,
    G_DATE,
    G_DATETIME,
    G_TIMEOFDAY,
  ];

  static final Map<int, GraphDataType> _byValue = ProtobufEnum.initByValue(values);
  static GraphDataType valueOf(int value) => _byValue[value];
  static void $checkItem(GraphDataType v) {
    if (v is !GraphDataType) checkItemFailed(v, 'GraphDataType');
  }

  const GraphDataType._(int v, String n) : super(v, n);
}

class GraphData extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('GraphData')
    ..a(5, 'tableName', PbFieldType.QS)
    ..a(6, 'columnGroup', PbFieldType.QS)
    ..a(7, 'columnType', PbFieldType.QS)
    ..a(8, 'columnWhat', PbFieldType.OS)
    ..e(9, 'graphType', PbFieldType.OE, GraphType.PIE, GraphType.valueOf)
    ..pp(10, 'column', PbFieldType.PM, GraphColumn.$checkItem, GraphColumn.create)
    ..pp(11, 'row', PbFieldType.PM, GraphRow.$checkItem, GraphRow.create)
  ;

  GraphData() : super();
  GraphData.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  GraphData.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  GraphData clone() => new GraphData()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static GraphData create() => new GraphData();
  static PbList<GraphData> createRepeated() => new PbList<GraphData>();
  static GraphData getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyGraphData();
    return _defaultInstance;
  }
  static GraphData _defaultInstance;
  static void $checkItem(GraphData v) {
    if (v is !GraphData) checkItemFailed(v, 'GraphData');
  }

  String get tableName => $_get(0, 5, '');
  void set tableName(String v) { $_setString(0, 5, v); }
  bool hasTableName() => $_has(0, 5);
  void clearTableName() => clearField(5);

  String get columnGroup => $_get(1, 6, '');
  void set columnGroup(String v) { $_setString(1, 6, v); }
  bool hasColumnGroup() => $_has(1, 6);
  void clearColumnGroup() => clearField(6);

  String get columnType => $_get(2, 7, '');
  void set columnType(String v) { $_setString(2, 7, v); }
  bool hasColumnType() => $_has(2, 7);
  void clearColumnType() => clearField(7);

  String get columnWhat => $_get(3, 8, '');
  void set columnWhat(String v) { $_setString(3, 8, v); }
  bool hasColumnWhat() => $_has(3, 8);
  void clearColumnWhat() => clearField(8);

  GraphType get graphType => $_get(4, 9, null);
  void set graphType(GraphType v) { setField(9, v); }
  bool hasGraphType() => $_has(4, 9);
  void clearGraphType() => clearField(9);

  List<GraphColumn> get columnList => $_get(5, 10, null);

  List<GraphRow> get rowList => $_get(6, 11, null);
}

class _ReadonlyGraphData extends GraphData with ReadonlyMessageMixin {}

class GraphColumn extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('GraphColumn')
    ..e(1, 'type', PbFieldType.QE, GraphDataType.G_STRING, GraphDataType.valueOf)
    ..a(2, 'label', PbFieldType.QS)
    ..a(3, 'id', PbFieldType.OS)
  ;

  GraphColumn() : super();
  GraphColumn.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  GraphColumn.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  GraphColumn clone() => new GraphColumn()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static GraphColumn create() => new GraphColumn();
  static PbList<GraphColumn> createRepeated() => new PbList<GraphColumn>();
  static GraphColumn getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyGraphColumn();
    return _defaultInstance;
  }
  static GraphColumn _defaultInstance;
  static void $checkItem(GraphColumn v) {
    if (v is !GraphColumn) checkItemFailed(v, 'GraphColumn');
  }

  GraphDataType get type => $_get(0, 1, null);
  void set type(GraphDataType v) { setField(1, v); }
  bool hasType() => $_has(0, 1);
  void clearType() => clearField(1);

  String get label => $_get(1, 2, '');
  void set label(String v) { $_setString(1, 2, v); }
  bool hasLabel() => $_has(1, 2);
  void clearLabel() => clearField(2);

  String get id => $_get(2, 3, '');
  void set id(String v) { $_setString(2, 3, v); }
  bool hasId() => $_has(2, 3);
  void clearId() => clearField(3);
}

class _ReadonlyGraphColumn extends GraphColumn with ReadonlyMessageMixin {}

class GraphRow extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('GraphRow')
    ..a(1, 'label', PbFieldType.QS)
    ..a(2, 'labelValue', PbFieldType.O6, Int64.ZERO)
    ..a(3, 'id', PbFieldType.OS)
    ..p(5, 'value', PbFieldType.PD)
  ;

  GraphRow() : super();
  GraphRow.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  GraphRow.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  GraphRow clone() => new GraphRow()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static GraphRow create() => new GraphRow();
  static PbList<GraphRow> createRepeated() => new PbList<GraphRow>();
  static GraphRow getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyGraphRow();
    return _defaultInstance;
  }
  static GraphRow _defaultInstance;
  static void $checkItem(GraphRow v) {
    if (v is !GraphRow) checkItemFailed(v, 'GraphRow');
  }

  String get label => $_get(0, 1, '');
  void set label(String v) { $_setString(0, 1, v); }
  bool hasLabel() => $_has(0, 1);
  void clearLabel() => clearField(1);

  Int64 get labelValue => $_get(1, 2, null);
  void set labelValue(Int64 v) { $_setInt64(1, 2, v); }
  bool hasLabelValue() => $_has(1, 2);
  void clearLabelValue() => clearField(2);

  String get id => $_get(2, 3, '');
  void set id(String v) { $_setString(2, 3, v); }
  bool hasId() => $_has(2, 3);
  void clearId() => clearField(3);

  List<double> get valueList => $_get(3, 5, null);
}

class _ReadonlyGraphRow extends GraphRow with ReadonlyMessageMixin {}

const GraphType$json = const {
  '1': 'GraphType',
  '2': const [
    const {'1': 'PIE', '2': 1},
    const {'1': 'BAR', '2': 2},
  ],
};

const GraphDataType$json = const {
  '1': 'GraphDataType',
  '2': const [
    const {'1': 'G_STRING', '2': 1},
    const {'1': 'G_NUMBER', '2': 2},
    const {'1': 'G_BOOLEAN', '2': 3},
    const {'1': 'G_DATE', '2': 4},
    const {'1': 'G_DATETIME', '2': 5},
    const {'1': 'G_TIMEOFDAY', '2': 6},
  ],
};

const GraphData$json = const {
  '1': 'GraphData',
  '2': const [
    const {'1': 'table_name', '3': 5, '4': 2, '5': 9},
    const {'1': 'column_group', '3': 6, '4': 2, '5': 9},
    const {'1': 'column_type', '3': 7, '4': 2, '5': 9},
    const {'1': 'column_what', '3': 8, '4': 1, '5': 9},
    const {'1': 'graph_type', '3': 9, '4': 1, '5': 14, '6': '.GraphType'},
    const {'1': 'column', '3': 10, '4': 3, '5': 11, '6': '.GraphColumn'},
    const {'1': 'row', '3': 11, '4': 3, '5': 11, '6': '.GraphRow'},
  ],
};

const GraphColumn$json = const {
  '1': 'GraphColumn',
  '2': const [
    const {'1': 'type', '3': 1, '4': 2, '5': 14, '6': '.GraphDataType'},
    const {'1': 'label', '3': 2, '4': 2, '5': 9},
    const {'1': 'id', '3': 3, '4': 1, '5': 9},
  ],
};

const GraphRow$json = const {
  '1': 'GraphRow',
  '2': const [
    const {'1': 'label', '3': 1, '4': 2, '5': 9},
    const {'1': 'label_value', '3': 2, '4': 1, '5': 3},
    const {'1': 'id', '3': 3, '4': 1, '5': 9},
    const {'1': 'value', '3': 5, '4': 3, '5': 1},
  ],
};

