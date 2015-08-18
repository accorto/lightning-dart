/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of biz_base_dart;

/**
 * Callback of [editor] with [newValue] - might be [temporary] (keyUp)
 * (usually DataRecord.onEditorChange)
 */
typedef void EditorChange(EditorI editor, String newValue, bool temporary);

/**
 * Editor Interface
 */
abstract class EditorI {

  static final Logger _log = new Logger("EditorI");


  /// Input type button
  static const String TYPE_TEXT = "text";
  /// Input type button
  static const String TYPE_BUTTON = "button";
  /// Input type reset button
  static const String TYPE_RESET = "reset";
  /// Input type submit button
  static const String TYPE_SUBMIT = "submit";
  /// Input type checkbox
  static const String TYPE_CHECKBOX = "checkbox";
  /// Input type email
  static const String TYPE_EMAIL = "email";
  /// Input type radio
  static const String TYPE_RADIO = "radio";
  /// Input type hidden
  static const String TYPE_HIDDEN = "hidden";
  /// Input type number (int)
  static const String TYPE_NUMBER = "number";
  /// Input type decimal (*)
  static const String TYPE_DECIMAL = "decimal";
  /// Select Editor Type
  static const String TYPE_SELECT = "select";
  /// Select Auto Editor Type
  static const String TYPE_SELECTAUTO = "selectauto";
  /// Select List Editor Type
  static const String TYPE_SELECTCHOICE = "selectchoice";
  /// Text Area
  static const String TYPE_TEXTAREA = "textarea";
  /// Select timezone Editor Type
  static const String TYPE_TIMEZONE = "timezone";
  /// Input type button
  static const String TYPE_TEL = "tel";
  /// Input type button
  static const String TYPE_URL = "url";
  /// Input type button
  static const String TYPE_SEARCH = "search";
  /// Input Number Range
  static const String TYPE_RANGE = "range";
  /// Input Date
  static const String TYPE_DATE = "date"; // not in: IE, FF, S
  /// Input Date Time
  static const String TYPE_DATETIME = "datetime-local"; // not in: IE, FF, S
  /// Input Time
  static const String TYPE_TIME = "time"; // not in: IE, FF, S
  /// Input Week
  static const String TYPE_WEEK = "week"; // not in: IE, FF, S
  /// Input Month
  static const String TYPE_MONTH = "month";
  /// Input password
  static const String TYPE_PASSWORD = "password";
  /// Input color
  static const String TYPE_COLOR = "color"; // not IE, S, iOS
  /// Input File
  static const String TYPE_FILE = "file";
  /// Input Image Button
  static const String TYPE_IMAGE = "image";
  /// Input type address/geo
  static const String TYPE_ADDRESS = "address"; // biz
  /// Input type duration
  static const String TYPE_DURATION = "duration"; // biz
  /// Input type fk
  static const String TYPE_FK = "fk"; // biz
  /// Input type code
  static const String TYPE_CODE = "code";
  /// Input type tag
  static const String TYPE_TAG = "tag";

  /// button types
  static final List<String> TYPES_BUTTON = [TYPE_BUTTON, TYPE_RESET, TYPE_SUBMIT, TYPE_IMAGE];
  /// No Label List
  static final List<String> TYPES_NOLABEL = [TYPE_CHECKBOX, TYPE_BUTTON, TYPE_RADIO, TYPE_RESET, TYPE_SUBMIT, TYPE_IMAGE];

  /// is the type a button (reset|submit|..)
  static bool isButton(String type) {
    return TYPES_BUTTON.contains(type);
  }
  /// is the type a checkbox / radio
  static bool isCheckbox(String type) {
    return type == TYPE_CHECKBOX || type == TYPE_RADIO;
  }
  /// is the type a date/time
  static bool isDate(String type) {
    return type == TYPE_DATE || type == TYPE_DATETIME || type == TYPE_TIME || type == TYPE_MONTH || type == TYPE_WEEK;
  }
  static bool isNumber(String type) {
    return type == TYPE_NUMBER || type == TYPE_DECIMAL;
  }
  /// class label mandatory
  static const C_LABEL_MANDATORY = "label-mandatory";


  /**
   * String Value
   */
  String get value;
  /// Set String Value
  void set value(String newValue);

  /// Value is empty
  bool get isEmpty {
    String v = value;
    return v == null || v.isEmpty;
  }
  /// Value is not empty
  bool get isNotEmpty {
    String v = value;
    return v != null && v.isNotEmpty;
  }

  /// return true if [newValue] is null, empty or nullValue
  bool _isEmpty(String newValue) => DataUtil.isEmpty(newValue);
  /// return true if [newValue] is null, empty or nullValue
  bool _isNotEmpty(String newValue) => DataUtil.isNotEmpty(newValue);

  /// Replace context in value
  String contextReplace(String newValue) {
    if (_isNotEmpty(newValue)) {
      return DataContext.contextReplace(data, newValue,
        nullResultOk: true, emptyResultOk: true, columnName: name);
    }
    return newValue;
  }


  /**
   * Original Value (creates als default value)
   */
  String get valueOriginal => _valueOriginal;
  /// Set Original value
  void set valueOriginal (String newValue) {
    if (_isEmpty(newValue)) {
      _valueOriginal = "";
      defaultValue = "";
    } else {
      _valueOriginal = newValue;
      defaultValue = render(newValue, true); // variables;
    }
  }
  String _valueOriginal;

  /**
   * Default Value (set also by [valueOriginal]
   */
  String get defaultValue;
  /// Set Default value
  void set defaultValue (String newValue);

  /// Is the value changed from original
  bool get changed {
    String v = value;
    if (v == null)
      v = "";
    String o = _valueOriginal == null ? "" : _valueOriginal;
    if (v != o) {
      if (type == TYPE_COLOR) {
        return o.isNotEmpty; // defaults to #000000
      }
      // if (v != o)
      //  print("EditorI ${name} changed original=${o} value=${v}");
    }
    return v != o;
  } // isChanged

  /// Sync changed indicator
  void changedSync() {
    // Change (form-control background)
    //if (showChange && changed)
    //  element.classes.add(Bootstrap.C_CHANGED); // on form-control
    //else
    //  element.classes.remove(Bootstrap.C_CHANGED);
    debugTitle();
  }
  /**
   * Rendered Value (different from value)
   */
  String get valueDisplay => value;
  /// is the rendered [valueDisplay] different from the [value]
  bool get valueRendered => false;

  /**
   * Render [newValue] for display
   */
  String render(String newValue, bool setValidity) {
    if (_isEmpty(newValue))
      return "";
    return contextReplace(newValue);
  }

  /// The Editor (Column) Name
  String get name;
  /// The Editor Id
  String get id;
  /// Input Type or select, textarea
  String get type;

  /// update Id (with row number)
  void updateId(String idPrefix);

  /// editor is in cell editor mode
  bool inGrid = false;

  bool get readOnly;
  void set readOnly (bool newValue);

  bool get disabled;
  void set disabled (bool newValue);

  bool get required;
  void set required (bool newValue);

  bool get displayed;
  void set displayed (bool newValue);

  bool get autofocus;
  void set autofocus (bool newValue);

  int get maxlength => 60;
  void set maxlength (int newValue) {}

  String get placeholder => "";
  void set placeholder (String newValue) {}

  String get title;
  void set title (String newValue);

  bool get spellcheck;
  void set spellcheck (bool newValue);

  String get pattern => "";
  void set pattern (String newValue) {}
  String get patternText => pattern;
  void set patternText (String newValue) {}

  /// The actual Element
  Element get element;

  /**
   * Set Column (info for specific editors)
   */
  void set column (DColumn newValue){
    _column = newValue;
    if (newValue.hasParentReference()) {
      _addDependentOn(EditorIDependent.getParentColumnName(newValue.parentReference));
    }
    if (newValue.hasRestrictionSql()) {
      String sql = newValue.restrictionSql;
      for (Match m in DataContext._RECORD.allMatches(sql)) {
        // _log.info("${m.input} start=${m.start} end=${m.end} groups=${m.groupCount}");
        String varName = m.input.substring(m.start+7, m.end);
        _addDependentOn(varName);
      }
    }
  }
  DColumn get column => _column;
  DColumn _column;

  /// Editor has columns it is dependent on
  bool get hasDependentOn => _dependentOns != null;
  /// Add Dependent On Column Name
  void _addDependentOn(String columnName) {
    if (columnName != null && columnName.isNotEmpty) {
      if (_dependentOns == null)
        _dependentOns = new List<EditorIDependent>();
      bool found = false;
      for (EditorIDependent dep in _dependentOns) {
        if (dep.columnName == columnName) {
          found = true;
          break;
        }
      }
      if (!found) {
        _dependentOns.add(new EditorIDependent(columnName));
        _log.config("addDependentOn ${name}: ${columnName}");
      }
    }
  }
  List<EditorIDependent> _dependentOns;

  /// a dependent on column value has changed
  bool get dependentOnChanged {
    if (_dependentOns != null) {
      bool change = false;
      for (EditorIDependent dep in _dependentOns) {
        if (dep.isCurrentValueChanged(data)) {
          _log.config("dependentOnChanged ${name}: ${dep.columnName}=${dep.currentValue} from=${dep.lastValue}");
          change = true;
        }
      }
      return change;
    }
    return false;
  } // dependentOnChanged

  /// get restriction sql with dependent based on data info or null
  String getRestrictionSql() {
    if (_column != null && _column.hasRestrictionSql()) {
      String sql = _column.restrictionSql;
      if (_dependentOns != null && data != null) {
        return DataContext.contextReplace(data, sql, columnName: name); // not null/empty
      }
      return sql;
    }
    return null;
  }

  /**
   * Context - might be null (set in display)
   */
  DataRecord data;
  /// Get/Create Data Entry (might be null)
  DEntry get entry {
    if (data != null) {
      if (_column == null) {
        return data.getEntry(null, name, true);
      } else {
        return data.getEntry(column.columnId, column.name, true);
      }
    }
    return null;
  }
  // update data record value - does not trigger changes
  void updateData(String newValue) {
    DEntry theEntry = entry;
    if (theEntry != null) {
      if (theEntry.value != newValue) {
        data.setEntryValue(theEntry, newValue); // updates changed, etc.
        if (valueRendered)
          theEntry.valueDisplay = render(newValue, false);
        //_log.fine("updateData ${name}=${theEntry.value} - ${theEntry.valueDisplay}");
      }
    }
    debugTitle();
  } // updateData


  /**
   *  onChange Callback (e.g. onInputChange calls editorChange)
   *  -> DataRecord.onEditorChange
   *   -> DataList.onRecordChange
   *  => dataMgrList - FormPanel.recordChanged
   *   -> FormPanelForm.recordChanged
   *    -> display -> editor data/value required/readOnly/displayed
   */
  EditorChange editorChange;
  /// onKeyUp Callback
  EditorChange editorKeyUp;

  /// show entry success icon
  bool showSuccess = true;
  /// show entry change highlight
  bool showChange = true;

  /// show feedback icons
  bool get showIcons => _showIcons;
  /// show feedback icons
  void set showIcons(bool newValue) {
    _showIcons = newValue;
  }
  bool _showIcons = true;

  /// get Label
  String get label;
  /// set label
  void set label(String newValue);

  /// Validation state from Input
  ValidityState get validationState;
  /// Validation Message from Input
  String get validationMsg;
  /// Validation Status text (displayed)
  String statusText;
  /// Validation Status (icon)
  String statusType;

  /**
   * Reset
   */
  void doReset() {
    // form reset sets default value
    if (_valueOriginal != null && _valueOriginal.isNotEmpty) {
      value = _valueOriginal;
    } else if (defaultValue.isNotEmpty) {
        value = defaultValue;
    } else {
      value = "";
    }
    doValidate();
  } // doReset

  /**
   * Validate Status
   */
  bool doValidate() {
    statusText = "";
    //statusType = Icon0.C_STATUS_NONE;
    if (readOnly || disabled) {
      updateStatus();
      return true;
    }
    if (isCheckbox(type) || isButton(type)) {
      return true;
    }
    String v = value;
    if (v == null)
      v = "";
    bool valid = true;
    //
    ValidityState state = validationState;
    if (state == null) {
      if (required && (v == null || v.isEmpty)) {
        valid = false;
        statusText = editorValidateRequired();
      }
    } else {
      valid = state.valid;
      statusText = validationMsg;
      if (state.patternMismatch) {
        statusText += " ${patternText}";
      }
    }

    //statusType = Icon0.C_STATUS_SUCCESS;

    // MaxLength
    int m = maxlength;
    if (maxlength > 0 && v.length > m) {
      valid = false;
      statusText = "${editorValidateTooLong()}: ${v.length} > ${m}";
    }

    // set status type
    //if (valid) {
    //  if (isEmpty) // no checkmark on empty
    //     statusType = Icon0.C_STATUS_NONE;
    //} else {
    //  statusType = Icon0.C_STATUS_WARNING;
    //}

    doValidateCustom();
    updateStatus();
    return valid;
  } // doValidate

  /// For subclasses to overwrite [statusType] (Icon) and [statusText]
  void doValidateCustom() {
  }

  /**
   * Display Form Group Status [statusType]  Icon0.C_STATUS_OK, C_STATUS_WARNING, C_STATUS_ERROR,
   *   C_STATUS_REQUIRED, C_STATUS_NONE
   * returns true if status displayed
   */
  bool updateStatus() {
//    String statusType0 = statusType;
//    if (!showSuccess && statusType == Icon0.C_STATUS_SUCCESS)
//      statusType0 = Icon0.C_STATUS_NONE;
    bool statusDisplayed = false;
//    if (formGroup != null) {
//      formGroup.statusType = statusType0; // color + icon
//      formGroup.statusText = statusText;
//      statusDisplayed = true;
//    }
//    if (gridCell is GridCellData) {
//      gridCell.statusType = statusType0; // color + icon
//      gridCell.statusText = statusText;
//      statusDisplayed = true;
//    }
    changedSync();
    return statusDisplayed;
  } // updateStatus

  /// set debugging info in title
  void debugTitle() {
    StringBuffer sb = new StringBuffer();
    sb.write(name);
    sb.write("=");
    if (value == null || value.length < 60) {
      sb.write(value);
    } else {
      sb.write(value.substring(0, 60));
      sb.write("...");
      sb.write(value.length);
    }
    sb.write(readOnly ? " ro" : " rw");
    sb.write(required ? " req" : " opt");
    sb.write(" ");
    sb.write(type);
    if (changed) {
      sb.write(" orig=");
      if (valueOriginal == null || valueOriginal.length < 60) {
        sb.write(valueOriginal);
      } else {
        sb.write(valueOriginal.substring(0, 60));
        sb.write("...");
        sb.write(valueOriginal.length);
      }
    }
    title = sb.toString();
  } // debugTitle


  static String editorValidateRequired() => Intl.message("Please provide a value", name: "editorValidateRequired");
  static String editorValidateTooLong() => Intl.message("Value too long", name: "editorValidateTooLong");

} // EditorI

/**
 * Dependent Info
 */
class EditorIDependent {

  /// get Column name from Reference (TableName.ColumnName)
  static String getParentColumnName(String parentReference) {
    String parentColumnName = parentReference;
    int index = parentColumnName.indexOf(".");
    if (index != -1)
      parentColumnName = parentColumnName.substring(index+1);
    return parentColumnName;
  }

  /// Column Name
  final String columnName;
  String lastValue;
  String currentValue;

  /// Dependent Info
  EditorIDependent(String this.columnName) {
  }

  /// is the current value changed
  bool isCurrentValueChanged(DataRecord data) {
    lastValue = currentValue;
    currentValue = data.getValue(name: columnName);
    return currentValueChanged;
  }

  /// is the current value changed
  bool get currentValueChanged {
    if (lastValue == currentValue)
      return false;
    if (lastValue == null || lastValue.isEmpty)
      return !(currentValue == null || currentValue.isEmpty);
    return true;
  }

  @override
  String toString() {
    return "${columnName}=${currentValue} ($lastValue)";
  }

} // EditorIDependent
