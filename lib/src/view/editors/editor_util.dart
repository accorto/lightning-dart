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
  static LEditor createfromColumn(String name, DColumn column, DataRecord data, bool inGrid, String idPrefix) {
    LEditor editor = null;
    if (column != null) {
      name = column.name;
      DataType dataType = column.dataType;

      if (dataType == DataType.STRING)
        editor = new LInput.from(column, EditorI.TYPE_TEXT, idPrefix:idPrefix, inGrid:inGrid);
      else if (dataType == DataType.ADDRESS)
        ;
      else if (dataType == DataType.AMOUNT)
        ;
      else if (dataType == DataType.BOOLEAN)
        editor = new LCheckbox.from(column, idPrefix:idPrefix, inGrid:inGrid);
      else if (dataType == DataType.CODE);
      else if (dataType == DataType.COLOR);
      else if (dataType == DataType.CURRENCY);
      else if (dataType == DataType.DATA);
      else if (dataType == DataType.DATE)
        editor = new LInputDate.from(column, EditorI.TYPE_DATE, idPrefix:idPrefix, inGrid:inGrid);
      else if (dataType == DataType.DATETIME)
        editor = new LInputDate.from(column, EditorI.TYPE_DATETIME, idPrefix:idPrefix, inGrid:inGrid);
      else if (dataType == DataType.DECIMAL);
      else if (dataType == DataType.DURATION)
        editor = new LInputDuration.from(column, idPrefix:idPrefix, inGrid:inGrid);
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
        editor = new LSelect.from(column, multiple:false, idPrefix:idPrefix, inGrid:inGrid);
      else if (dataType == DataType.PICKAUTO);
      else if (dataType == DataType.PICKCHOICE) {
        if (inGrid)
          editor = new LSelect.from(column, idPrefix:idPrefix, inGrid:inGrid);
      }
      else if (dataType == DataType.PICKMULTI)
        editor = new LSelect.from(column, multiple:true, idPrefix:idPrefix, inGrid:inGrid);
      else if (dataType == DataType.PICKMULTICHOICE) {
        if (inGrid)
          editor = new LSelect.from(column, multiple:false, idPrefix:idPrefix, inGrid:inGrid);
      }
      else if (dataType == DataType.QUANTITY);
      else if (dataType == DataType.RATING);
      else if (dataType == DataType.TAG);
      else if (dataType == DataType.TENANT);
      else if (dataType == DataType.TEXT)
        editor = new LTextArea.from(column, idPrefix:idPrefix, inGrid:inGrid);
      else if (dataType == DataType.TIME)
        editor = new LInputDate.from(column, EditorI.TYPE_TIME, idPrefix:idPrefix, inGrid:inGrid);
      else if (dataType == DataType.TIMEZONE);
      else if (dataType == DataType.URL);
      else if (dataType == DataType.USER);

      // fallback
      if (editor == null)
        editor = new LInput.from(column, DataTypeUtil.getEditorType(dataType), idPrefix:idPrefix, inGrid:inGrid);
    } // column

    // editor fallback - text
    if (editor == null) {
      editor = new LInput(name, EditorI.TYPE_TEXT, idPrefix:idPrefix, inGrid:inGrid);
      if (column != null) {
        editor.column = column;
      }
    }

    // data link
    if (data != null) {
      editor.editorChange = data.onEditorChange;
      editor.data = data;
      editor.entry = data.getEntry(editor.id, editor.name, true);
    }
    return editor;
  } // create


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


} // EditorUtil
