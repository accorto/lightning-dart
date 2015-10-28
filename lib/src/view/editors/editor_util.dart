/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

typedef LLookup CreateLookup(DataColumn dataColumn, String idPrefix, bool inGrid);


/**
 * Editor Utilities
 */
class EditorUtil {


  static CreateLookup createLookupCall = createLookup;

  /**
   * Create Editor from column
   */
  static LEditor createfromColumn(String name, DataColumn dataColumn, bool inGrid,
      {String idPrefix, DataRecord data, DEntry entry, bool isAlternativeDisplay:false}) {
    LEditor editor = null;
    if (dataColumn != null) {
      name = dataColumn.name;
      DataType dataType = dataColumn.tableColumn.dataType;

      if (dataType == DataType.STRING)
        editor = new LInput.from(dataColumn, EditorI.TYPE_TEXT, idPrefix:idPrefix, inGrid:inGrid);
      else if (dataType == DataType.ADDRESS)
        ;
      else if (dataType == DataType.AMOUNT)
        editor = new LInputNumber.from(dataColumn, EditorI.TYPE_NUMBER, idPrefix:idPrefix, inGrid:inGrid);
      else if (dataType == DataType.BOOLEAN) {
        if (isAlternativeDisplay)
          editor = new LSelect.from(dataColumn, idPrefix:idPrefix, inGrid:inGrid);
        else
          editor = new LCheckbox.from(dataColumn, idPrefix:idPrefix, inGrid:inGrid);
      } else if (dataType == DataType.CODE);
      else if (dataType == DataType.COLOR);
      else if (dataType == DataType.CURRENCY)
        editor = new LInputNumber.from(dataColumn, EditorI.TYPE_NUMBER, idPrefix:idPrefix, inGrid:inGrid);
      else if (dataType == DataType.DATA);
      else if (dataType == DataType.DATE)
        editor = new LInputDate.from(dataColumn, EditorI.TYPE_DATE, idPrefix:idPrefix, inGrid:inGrid);
      else if (dataType == DataType.DATETIME)
        editor = new LInputDate.from(dataColumn, EditorI.TYPE_DATETIME, idPrefix:idPrefix, inGrid:inGrid);
      else if (dataType == DataType.DECIMAL)
        editor = new LInputNumber.from(dataColumn, EditorI.TYPE_NUMBER, idPrefix:idPrefix, inGrid:inGrid);
      else if (dataType == DataType.DURATION)
        editor = new LInputDuration.from(dataColumn, EditorI.TYPE_DURATION, idPrefix:idPrefix, inGrid:inGrid);
      else if (dataType == DataType.DURATIONHOUR)
        editor = new LInputDuration.from(dataColumn, EditorI.TYPE_DURATIONHOUR, idPrefix:idPrefix, inGrid:inGrid);
      else if (dataType == DataType.EMAIL)
        editor = new LInput.from(dataColumn, EditorI.TYPE_EMAIL, idPrefix:idPrefix, inGrid:inGrid);
      else if (dataType == DataType.FK)
        editor = createLookupCall(dataColumn, idPrefix, inGrid);
      else if (dataType == DataType.GEO);
      else if (dataType == DataType.IM);
      else if (dataType == DataType.IMAGE) {
        editor = new LInputFile.from(dataColumn, idPrefix:idPrefix, inGrid:inGrid);
      }
      else if (dataType == DataType.INT)
        editor = new LInputNumber.from(dataColumn, EditorI.TYPE_NUMBER, idPrefix:idPrefix, inGrid:inGrid);
      else if (dataType == DataType.NUMBER)
        editor = new LInputNumber.from(dataColumn, EditorI.TYPE_NUMBER, idPrefix:idPrefix, inGrid:inGrid);
      else if (dataType == DataType.PASSWORD)
        editor = new LInput.from(dataColumn, EditorI.TYPE_PASSWORD, idPrefix:idPrefix, inGrid:inGrid);
      else if (dataType == DataType.PHONE)
        editor = new LInput.from(dataColumn, EditorI.TYPE_TEL, idPrefix:idPrefix, inGrid:inGrid);
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
      else if (dataType == DataType.QUANTITY)
        editor = new LInputNumber.from(dataColumn, EditorI.TYPE_NUMBER, idPrefix:idPrefix, inGrid:inGrid);
      else if (dataType == DataType.RATING);
      else if (dataType == DataType.TAG);
      else if (dataType == DataType.TENANT)
        editor = createLookupCall(dataColumn, idPrefix, inGrid);
      else if (dataType == DataType.TEXT)
        editor = new LTextArea.from(dataColumn, idPrefix:idPrefix, inGrid:inGrid);
      else if (dataType == DataType.TIME)
        editor = new LInputDate.from(dataColumn, EditorI.TYPE_TIME, idPrefix:idPrefix, inGrid:inGrid);
      else if (dataType == DataType.TIMEZONE);
      else if (dataType == DataType.URL)
        editor = new LInput.from(dataColumn, EditorI.TYPE_URL, idPrefix:idPrefix, inGrid:inGrid);
      else if (dataType == DataType.USER)
        editor = createLookupCall(dataColumn, idPrefix, inGrid);

      // fallback
      if (editor == null)
        editor = new LInput.from(dataColumn, DataTypeUtil.getEditorType(dataType), idPrefix:idPrefix, inGrid:inGrid);
    } // dataColumn

    // editor fallback (no dataColumn) - text
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

  /// create lookup
  static LLookup createLookup(DataColumn dataColumn, String idPrefix, bool inGrid) {
    return new LLookup.from(dataColumn, idPrefix:idPrefix, inGrid:inGrid);
  }

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
  static Future<String> render (DataColumn dataColumn, String value) {
    if (dataColumn == null || value == null || value.isEmpty) {
      Completer<String> completer = new Completer<String>();
      completer.complete(value);
      return completer.future;
    }
    DataType dt = dataColumn.tableColumn.dataType;
    String key = dt.toString();
    if (dt == DataType.FK)
      key = "${dataColumn.table.name}.${dataColumn.name}";
    LEditor editor = _dataTypeEditorMap[key];
    if (editor == null) {
      editor = createfromColumn(dataColumn.name, dataColumn, true);
      _dataTypeEditorMap[key] = editor;
    }
    return editor.render(value, false);
  }
  static Map<String,LEditor> _dataTypeEditorMap = new Map<String,LEditor>();


} // EditorUtil
