/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Editor Utilities
 */
class EditorUtil {

  /**
   * Create Editor from column
   */
  static LEditor createfromColumn(String name, DataColumn dataColumn, bool inGrid,
      {String idPrefix, DataRecord data, DEntry entry}) {
    LEditor editor = null;
    if (dataColumn != null) {
      name = dataColumn.name;
      DataType dataType = dataColumn.tableColumn.dataType;

      if (dataType == DataType.STRING)
        editor = new LInput.from(dataColumn, EditorI.TYPE_TEXT, idPrefix:idPrefix, inGrid:inGrid);
      else if (dataType == DataType.ADDRESS)
        ;
      else if (dataType == DataType.AMOUNT)
        ;
      else if (dataType == DataType.BOOLEAN)
        editor = new LCheckbox.from(dataColumn, idPrefix:idPrefix, inGrid:inGrid);
      else if (dataType == DataType.CODE);
      else if (dataType == DataType.COLOR);
      else if (dataType == DataType.CURRENCY);
      else if (dataType == DataType.DATA);
      else if (dataType == DataType.DATE)
        editor = new LInputDate.from(dataColumn, EditorI.TYPE_DATE, idPrefix:idPrefix, inGrid:inGrid);
      else if (dataType == DataType.DATETIME)
        editor = new LInputDate.from(dataColumn, EditorI.TYPE_DATETIME, idPrefix:idPrefix, inGrid:inGrid);
      else if (dataType == DataType.DECIMAL);
      else if (dataType == DataType.DURATION)
        editor = new LInputDuration.from(dataColumn, EditorI.TYPE_DURATION, idPrefix:idPrefix, inGrid:inGrid);
      else if (dataType == DataType.DURATIONHOUR)
        editor = new LInputDuration.from(dataColumn, EditorI.TYPE_DURATIONHOUR, idPrefix:idPrefix, inGrid:inGrid);
      else if (dataType == DataType.EMAIL);
      else if (dataType == DataType.FK);
      else if (dataType == DataType.GEO);
      else if (dataType == DataType.IM);
      else if (dataType == DataType.IMAGE);
      else if (dataType == DataType.INT);
      else if (dataType == DataType.NUMBER);
      else if (dataType == DataType.PASSWORD);
      else if (dataType == DataType.PHONE);
      else if (dataType == DataType.PICK)
        editor = new LSelect.from(dataColumn, multiple:false, idPrefix:idPrefix, inGrid:inGrid);
      else if (dataType == DataType.PICKAUTO);
      else if (dataType == DataType.PICKCHOICE) {
        if (inGrid)
          editor = new LSelect.from(dataColumn, idPrefix:idPrefix, inGrid:inGrid);
      }
      else if (dataType == DataType.PICKMULTI)
        editor = new LSelect.from(dataColumn, multiple:true, idPrefix:idPrefix, inGrid:inGrid);
      else if (dataType == DataType.PICKMULTICHOICE) {
        if (inGrid)
          editor = new LSelect.from(dataColumn, multiple:false, idPrefix:idPrefix, inGrid:inGrid);
      }
      else if (dataType == DataType.QUANTITY);
      else if (dataType == DataType.RATING);
      else if (dataType == DataType.TAG);
      else if (dataType == DataType.TENANT);
      else if (dataType == DataType.TEXT)
        editor = new LTextArea.from(dataColumn, idPrefix:idPrefix, inGrid:inGrid);
      else if (dataType == DataType.TIME)
        editor = new LInputDate.from(dataColumn, EditorI.TYPE_TIME, idPrefix:idPrefix, inGrid:inGrid);
      else if (dataType == DataType.TIMEZONE);
      else if (dataType == DataType.URL);
      else if (dataType == DataType.USER);

      // fallback
      if (editor == null)
        editor = new LInput.from(dataColumn, DataTypeUtil.getEditorType(dataType), idPrefix:idPrefix, inGrid:inGrid);
    } // column

    // editor fallback - text
    if (editor == null) {
      editor = new LInput(name, EditorI.TYPE_TEXT, idPrefix:idPrefix, inGrid:inGrid);
      if (dataColumn != null) {
        editor.dataColumn = dataColumn;
      }
    }

    // data link
    if (data != null) {
      editor.editorChange = data.onEditorChange;
      editor.data = data;
      editor.entry = entry == null ? data.getEntry(null, editor.name, true) : entry;
    }
    return editor;
  } // createFromColumn

  /**
   * Create Editor of html input [type] with [name]
   * (see also DataTypeUtil.createEditor)
   */
  static LEditor create(String name,
      {String idPrefix,
      String type : EditorI.TYPE_TEXT,
      bool multiple: false,
      bool inGrid: false}) {

    if (type == EditorI.TYPE_CHECKBOX)
      return new LCheckbox(name, idPrefix:idPrefix, inGrid:inGrid);

    if (type == EditorI.TYPE_SELECT)
      return new LSelect(name, idPrefix: idPrefix, multiple:multiple, inGrid:inGrid);
//    if (type == EditorI.TYPE_SELECTAUTO)
//      return new EditorSelectAuto(name, idPrefix: idPrefix, inGrid: inGrid);
//    if (type == EditorI.TYPE_SELECTCHOICE)
//      return new EditorSelectChoice(name, idPrefix: idPrefix, multiple: multiple, inGrid: inGrid);
//    if (type == EditorI.TYPE_TAG)
//      return new EditorTag(name, idPrefix: idPrefix, inGrid: inGrid);

    if (type == EditorI.TYPE_TEXTAREA)
      return new LTextArea(name, idPrefix:idPrefix, inGrid:inGrid);
//    if (type == EditorI.TYPE_TIMEZONE)
//      return new EditorTimezone(name, idPrefix: idPrefix, inGrid: inGrid);

//    if (type == EditorI.TYPE_FILE)
//      return new EditorFile(name, idPrefix: idPrefix, inGrid: inGrid);

    if (EditorI.isDate(type))
      return new LInputDate(name, type:type, idPrefix:idPrefix, inGrid:inGrid);

//    if (type == EditorI.TYPE_RANGE)
//      return new EditorRange(name, idPrefix: idPrefix, inGrid: inGrid);
//    if (EditorI.isNumber(type))
//      return new EditorNumber(name, idPrefix: idPrefix, type: type, inGrid: inGrid);

//    if (type == EditorI.TYPE_ADDRESS)
//      return new EditorAddress(name, idPrefix: idPrefix, type: type, inGrid: inGrid);

    if (type == EditorI.TYPE_DURATION)
      return new LInputDuration(name, idPrefix:idPrefix, inGrid:inGrid);

//    if (type == EditorI.TYPE_FK)
//      return new EditorFk(name, idPrefix: idPrefix, type: type, inGrid: inGrid);

//    if (type == EditorI.TYPE_CODE)
//      return new EditorCode(name, idPrefix: idPrefix, inGrid: inGrid);

//    if (type == EditorI.TYPE_URL)
//      return new EditorUrl(name, idPrefix: idPrefix, inGrid: inGrid);

    if (type == EditorI.TYPE_SEARCH)
      return new LInputSearch(name, idPrefix:idPrefix, inGrid:inGrid);

    return new LInput(name, type, idPrefix:idPrefix, inGrid:inGrid);
  } // create


  /// Create from Data Type
  static LEditor createFromDataType(DataType dataType,
      {String columnName:"internal", tableName:"internal", bool inGrid:true, String idPrefix,
      DataRecord data, DEntry entry}) {
    DColumn column = new DColumn()
      ..name = columnName
      ..dataType = dataType;
    DTable table = new DTable()
      ..name = tableName
      ..columnList.add(column);
    DataColumn dataColumn = new DataColumn(table, column, null, null);
    return createfromColumn(columnName, dataColumn, inGrid, idPrefix:idPrefix, data:data, entry:entry);
  }

  /// Render Value
  static String render (DataType dataType, String value) {
    if (dataType == null)
      return value;
    LEditor editor = _dataTypeEditorMap[dataType];
    if (editor == null) {
      editor = createFromDataType(dataType);
      _dataTypeEditorMap[dataType] = editor;
    }
    return editor.render(value, false);
  }
  static Map<DataType,LEditor> _dataTypeEditorMap = new Map<DataType,LEditor>();


} // EditorUtil
