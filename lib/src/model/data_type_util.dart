/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_model;

/**
 * Data Type Functionality + Mapping
 */
class DataTypeUtil {

  static final Logger _log = new Logger("DataTypeUtil");

  /// Data Type FK
  static bool isFk(DataType dt) {
    return dt == DataType.FK || dt == DataType.USER || dt == DataType.TENANT;
  }
  /// Data Type underlying String (including pick)
  static bool isString(DataType dt) {
    return dt == DataType.STRING || dt == DataType.TEXT || dt == DataType.EMAIL
        || dt == DataType.IM || dt == DataType.PHONE
        || dt == DataType.PICK || dt == DataType.PICKAUTO || dt == DataType.PICKCHOICE
        || dt == DataType.PICKMULTI || dt == DataType.PICKMULTICHOICE
        || dt == DataType.TAG || dt == DataType.TIMEZONE
        || dt == DataType.URL;
  }
  /// Data Type underlying String
  static bool isStringStrict(DataType dt) {
    return dt == DataType.STRING || dt == DataType.TEXT || dt == DataType.EMAIL
        || dt == DataType.IM || dt == DataType.PHONE
        || dt == DataType.TAG
        || dt == DataType.URL;
  }
  /// Data Type Number
  static bool isNumber(DataType dt) {
    return (dt == DataType.INT) || (dt == DataType.NUMBER) || (dt == DataType.AMOUNT)
        || (dt == DataType.CURRENCY) || (dt == DataType.QUANTITY)
        || (dt == DataType.DECIMAL) || (dt == DataType.RATING);
  }
  /// Data Type Duration
  static bool isDuration(DataType dt) {
    return (dt == DataType.DURATION) || (dt == DataType.DURATIONHOUR);
  }
  /// Data Type Number
  static bool isInt(DataType dt) {
    return (dt == DataType.INT) || (dt == DataType.RATING);
  }
  /// Data Type Date
  static bool isDate(DataType dt) {
    return (dt == DataType.DATE) || (dt == DataType.DATETIME) || (dt == DataType.TIME);
  }
  /// Data Type Pick
  static bool isPick(DataType dt) {
    return dt == DataType.PICK || dt == DataType.PICKAUTO || dt == DataType.PICKCHOICE
        || dt == DataType.PICKMULTI || dt == DataType.PICKMULTICHOICE;
  }

  /// Data Type Alignment
  static bool isRightAligned(DataType dt) {
    return isNumber(dt) || isDuration(dt);
  }
  /// Data Type Alignment
  static bool isCenterAligned(DataType dt) {
    return dt == DataType.BOOLEAN;
  }
  /// Data Type w/o Editor
  static bool isNoEditor(DataType dt) {
    return dt == DataType.DATA;
  }

  /// is display rendered for data type
  static bool isDisplayRendered(DataType dt) {
    return isFk(dt) || isDate(dt) || isPick(dt) || isNumber(dt);
  }

  /// Default Editor width or 0
  static int getEditorWidth(DataType dt) {
    if (dt == DataType.DATE)
      return 170;
    if (dt == DataType.DATETIME)
      return 240;
    if (dt == DataType.TIME)
      return 135;
    if (dt == DataType.TIMEZONE)
      return 280;
    return 0;
  } // getEditorWidth



  /**
   * Get DataType from html input [editorType]
   * returns STRING if not found
   */
  static DataType getDataTypeFromEditorType(String editorType) {
    _init();
    for (DataTypeUtil dtu in _dataTypes) {
      if (editorType == dtu.editorType)
        return dtu.dataType;
    }
    return DataType.STRING;
  } // getDataTypeFromEditorType

  /**
   * Find Data Type for Column in Table
   */
  static DataType getDataType(DTable table, String columnId, String columnName) {
    if (table != null) {
      for (DColumn col in table.columnList) {
        if ((columnId != null && columnId == col.columnId)
            || (columnName != null && columnName == col.name))
          return col.dataType;
      }
    }
    return null;
  } // getDataType

  /**
   * Get Editor Type from [dataType]
   * returns TYPE_TEXT if not found
   */
  static String getEditorType(DataType dataType) {
    _init();
    for (DataTypeUtil dtu in _dataTypes) {
      if (dataType == dtu.dataType)
        return dtu.editorType;
    }
    return EditorI.TYPE_TEXT;
  } // getDataTypeFromEditorType


  /// Table Column from [property]
  static DColumn toColumn(DProperty property, bool rangeTo) {
    // property.isRange;
    // property.seqNo;

    DColumn tableColumn = new DColumn();
    if (property.hasId())
      tableColumn.columnId = property.id;
    if (property.hasName()) {
      tableColumn.name = property.name;
      if (rangeTo)
        tableColumn.name = property.name + "To";
    }
    if (property.hasLabel())
      tableColumn.label = property.label;
    if (property.hasDescription())
      tableColumn.description = property.description;
    if (property.hasHelp())
      tableColumn.help = property.help;

    if (property.hasIsMandatory())
      tableColumn.isMandatory = property.isMandatory;
    if (property.hasIsReadOnly())
      tableColumn.isReadOnly = property.isReadOnly;

    if (property.hasDataType())
      tableColumn.dataType = property.dataType;
    if (property.hasColumnSize())
      tableColumn.columnSize = property.columnSize;
    if (property.hasDecimalDigits())
      tableColumn.decimalDigits = property.decimalDigits;
    if (property.hasDefaultValue())
      tableColumn.defaultValue = property.defaultValue;
    if (rangeTo && property.hasDefaultValueTo())
      tableColumn.defaultValue = property.defaultValueTo;

    if (property.hasPickListName())
      tableColumn.pickListName = property.pickListName;
    for (DOption option in property.pickValueList) {
      tableColumn.pickValueList.add(option);
    }
    if (property.hasFormatMask())
      tableColumn.formatMask = property.formatMask;
    if (property.hasValFrom())
      tableColumn.valFrom = property.valFrom;
    if (property.hasValTo())
      tableColumn.valTo = property.valTo;
    //
    return tableColumn;
  } // toColumn

  /**
   * Get (first) Data Type Info for [dataType]
   */
  static DataTypeUtil getDataTypeUtil(DataType dataType, bool inGrid) {
    _init();
    DataType dt = dataType;
    if (inGrid) {
        if (dataType == DataType.PICKCHOICE)
          dt = DataType.PICK;
        else if (dataType == DataType.PICKMULTICHOICE)
          dt = DataType.PICKMULTI;
    }
    for (DataTypeUtil dtu in _dataTypes) {
      if (dt == dtu.dataType)
        return dtu;
    }
    return null;
  } // getDataTypeUtil


  /// initialize
  static void _init() {
    if (_dataTypes != null)
      return;
    _dataTypes = new List<DataTypeUtil>();
    _STRING =      new DataTypeUtil(DataType.STRING,    EditorI.TYPE_TEXT,      "");
    _dataTypes.add(_STRING);
    _dataTypes.add(new DataTypeUtil(DataType.ADDRESS,   EditorI.TYPE_ADDRESS,   ""));
    _dataTypes.add(new DataTypeUtil(DataType.AMOUNT,    EditorI.TYPE_DECIMAL,   ""));
    _dataTypes.add(new DataTypeUtil(DataType.BOOLEAN,   EditorI.TYPE_CHECKBOX,  ""));
    _dataTypes.add(new DataTypeUtil(DataType.CODE,      EditorI.TYPE_CODE,      ""));
    _dataTypes.add(new DataTypeUtil(DataType.COLOR,     EditorI.TYPE_COLOR,     ""));
    _dataTypes.add(new DataTypeUtil(DataType.CURRENCY,  EditorI.TYPE_DECIMAL,   ""));
    _dataTypes.add(new DataTypeUtil(DataType.DATA,      EditorI.TYPE_FILE,      ""));
    _dataTypes.add(new DataTypeUtil(DataType.DATE,      EditorI.TYPE_DATE,      ""));
    _dataTypes.add(new DataTypeUtil(DataType.DATETIME,  EditorI.TYPE_DATETIME,  ""));
    _dataTypes.add(new DataTypeUtil(DataType.DECIMAL,   EditorI.TYPE_DECIMAL,   ""));
    _dataTypes.add(new DataTypeUtil(DataType.DURATION,  EditorI.TYPE_DURATION,  ""));
    _dataTypes.add(new DataTypeUtil(DataType.EMAIL,     EditorI.TYPE_EMAIL,     ""));
    _dataTypes.add(new DataTypeUtil(DataType.FK,        EditorI.TYPE_FK,        ""));
    _dataTypes.add(new DataTypeUtil(DataType.GEO,       EditorI.TYPE_ADDRESS,   ""));
    _dataTypes.add(new DataTypeUtil(DataType.IM,        EditorI.TYPE_EMAIL,     ""));
    _dataTypes.add(new DataTypeUtil(DataType.IMAGE,     EditorI.TYPE_FILE,      ""));
    _dataTypes.add(new DataTypeUtil(DataType.INT,       EditorI.TYPE_NUMBER,    ""));
    _dataTypes.add(new DataTypeUtil(DataType.NUMBER,    EditorI.TYPE_DECIMAL,   ""));
    _dataTypes.add(new DataTypeUtil(DataType.PASSWORD,  EditorI.TYPE_PASSWORD,  ""));
    _dataTypes.add(new DataTypeUtil(DataType.PHONE,     EditorI.TYPE_TEL,       ""));
    _dataTypes.add(new DataTypeUtil(DataType.PICK,      EditorI.TYPE_SELECT,    ""));
    _dataTypes.add(new DataTypeUtil(DataType.PICKAUTO,  EditorI.TYPE_SELECTAUTO, ""));
    _dataTypes.add(new DataTypeUtil(DataType.PICKCHOICE, EditorI.TYPE_SELECTCHOICE, ""));
    _dataTypes.add(new DataTypeUtil(DataType.PICKMULTI, EditorI.TYPE_SELECT,    ""));
    _dataTypes.add(new DataTypeUtil(DataType.PICKMULTICHOICE, EditorI.TYPE_SELECTCHOICE, ""));
    _dataTypes.add(new DataTypeUtil(DataType.QUANTITY,  EditorI.TYPE_DECIMAL,   ""));
    _dataTypes.add(new DataTypeUtil(DataType.RATING,    EditorI.TYPE_RANGE,     ""));
    _dataTypes.add(new DataTypeUtil(DataType.TAG,       EditorI.TYPE_TAG,       ""));
    _dataTypes.add(new DataTypeUtil(DataType.TENANT,    EditorI.TYPE_FK,        ""));
    _dataTypes.add(new DataTypeUtil(DataType.TEXT,      EditorI.TYPE_TEXTAREA,  ""));
    _dataTypes.add(new DataTypeUtil(DataType.TIME,      EditorI.TYPE_TIME,      ""));
    _dataTypes.add(new DataTypeUtil(DataType.TIMEZONE,  EditorI.TYPE_TIMEZONE,  ""));
    _dataTypes.add(new DataTypeUtil(DataType.URL,       EditorI.TYPE_URL,       ""));
    _dataTypes.add(new DataTypeUtil(DataType.USER,      EditorI.TYPE_FK,        ""));
  } // init
  static List<DataTypeUtil> _dataTypes;
  static DataTypeUtil _STRING;


  /// Biz Data Type
  final DataType dataType;
  /// Html type +
  final String editorType;
  /// Icon
  final String iconClass;
  /// Data Type Util
  DataTypeUtil(DataType this.dataType, String this.editorType, String this.iconClass);

} // DataTypeUtil
