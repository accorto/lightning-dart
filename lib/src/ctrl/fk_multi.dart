/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/**
 * Multi FK Lookup
 * - use AlternativeUI for Primary Column
 */
class FkMulti
    extends LInput {

  static final Logger _log = new Logger("FkMulti");

  final LIcon _icon = new LIconUtility(LIconUtility.JUSTIFY_TEXT);

  /// Multi FK Lookup
  FkMulti(String name,
      {String idPrefix, bool inGrid: false, bool withClearValue: false})
      : super (name, EditorI.TYPE_FK, idPrefix: idPrefix, inGrid: inGrid, withClearValue: withClearValue) {
    _init();
  } // FkMulti

  /// Multi FK Lookup
  FkMulti.from(DataColumn dataColumn,
      {String idPrefix, bool inGrid: false, bool withClearValue: false})
      : super.from (dataColumn, EditorI.TYPE_FK, idPrefix: idPrefix, inGrid: inGrid, withClearValue: withClearValue) {
    _init();
  } // FkMulti

  void _init() {
    input.readOnly = true;
    input.style.background = "transparent";
    input.style.cursor = "pointer";
    input.onClick.listen(onInputClick);
    _icon.element.onClick.listen(onInputClick);
  }

  /// Search Icon
  LIcon getIconRight() => _icon;

  bool get readOnly => _readOnly;
  void set readOnly(bool newValue) {
    _readOnly = newValue;
  }
  bool _readOnly = false;

  /// set Data column
  void set dataColumn (DataColumn newValue) {
    super.dataColumn = newValue;
    _initMulti();
  }
  void _initMulti() {
    _columnList = new List<DColumn>();

    DTable table = dataColumn.table;
    String columnName = dataColumn.name;
    for (DColumn col in table.columnList) {
      if (col.hasParentReference() && col.parentReference.contains(columnName)) {
        _columnList.add(col);
      }
    }
    // sort
    _columnList.sort((DColumn one, DColumn two) {
      String nameOne = one.name;
      String refOne = one.parentReference;
      String nameTwo = two.name;
      String refTwo = two.parentReference;
      if (refTwo.contains(nameOne))
        return -1; // before
      if (refOne.contains(nameTwo))
        return 1;
      return 0;
    });
    _columnList.insert(0, dataColumn.tableColumn);
    String info = "initMulti ";
    for (DColumn col in _columnList) {
      info += " - " + col.name;
    }
    _log.fine(info);
  } // setDataColumn
  List<DColumn> _columnList;


  String get value => _value;
  void set value(String newValue) {
    _value = newValue;
  }
  String _value;

  String get valueDisplay => _valueDisplay;
  bool get isValueDisplay => true;


  /// Set Entry value
  void set entry (DEntry newValue) {
    if (_columnList == null) {
      _initMulti();
    }
    _entryList.clear();
    for (DColumn col in _columnList) {
      _entryList.add(data.getEntry(col.columnId, col.name, true));
    }
    _valueDisplay = _renderSync();
    input.value = _valueDisplay;
    super.entry = newValue; // calls value+valueDisplay
  } // setEntry
  final List<DEntry> _entryList = new List<DEntry>();
  String _valueDisplay;

  /// render Sync
  String _renderSync() {
    if (_entryList.isEmpty)
      return "";
    String display = null;
    bool hasValue = false;
    for (DEntry ee in _entryList) {
      String dd = "";
      String vv = DataRecord.getEntryValue(ee);
      if (vv != null && vv.isNotEmpty) {
        hasValue = true;
        if (ee.hasValueDisplay()) {
          dd = ee.valueDisplay;
        } else {
          // TODO lookup
          dd = KeyValueMap.keyNotFound(vv);
        }
      }
      if (display == null) {
        display = dd;
      } else {
        display += LUtil.DOT_SPACE + dd;
      }
    }
    if (hasValue)
      return display;
    return "";
  } // renderSync

  /// render sync
  Future<String> render(String newValue, bool setValidity) {
    Completer<String> completer = new Completer<String>();
    if (DataUtil.isEmpty(newValue)) {
      completer.complete("");
    } else {
      String cmp = null;
      if (_entryList.isEmpty)
        cmp = DataRecord.getEntryValue(_entryList.first);
      if (cmp == newValue) {
        // render one..three
      } else {
        // render newValue only
      }
      completer.complete(contextReplace(newValue));
    }
    return completer.future;
  } // render

  /// Get Entry at Level
  DEntry getEntryAtLevel(int level) {
    if (_entryList.isEmpty || level < 0 || level >= _entryList.length) {
      return null;
    }
    return _entryList[level];
  }

  /// Get Value at Level
  String getValueAtLevel(int level) {
    return DataRecord.getEntryValue(getEntryAtLevel(level));
  }

  /// open dialog
  void onInputClick(MouseEvent evt) {
    _log.config("onInputClick");
    if (_readOnly || disabled) {
      return;
    }
    if (_dialog == null) {
      _dialog = new FkMultiDialog(name, _columnList);
    }
    _dialog.show(this);
  }
  FkMultiDialog _dialog;


} // FkMulti
