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

  final LIcon _icon = new LIconUtility(LIconUtility.OVERFLOW);

  /// Multi FK Lookup
  FkMulti.from(DataColumn dataColumn,
      {String idPrefix, bool inGrid: false, bool withClearValue: false})
      : super.from (dataColumn, EditorI.TYPE_FK, idPrefix: idPrefix, inGrid: inGrid, withClearValue: withClearValue) {
    if (inGrid) {
      input.classes.remove(LInput.C_W160);
      input.classes.add(LInput.C_W200);
    }
    input.readOnly = true;
    input.style.background = "transparent";
    input.style.cursor = "pointer";
    input.onClick.listen(onInputClick);
    _icon.element.onClick.listen(onInputClick);
  } // FkMulti

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
    for (int i = 0; i < _entryList.length; i++) {
      DEntry ee = _entryList[i];
      String dd = "";
      String vv = DataRecord.getEntryValue(ee);
      if (vv != null && vv.isNotEmpty) {
        hasValue = true;
        if (ee.hasValueDisplay()) {
          dd = ee.valueDisplay;
        } else {
          // sync lookup
          DFK fk = FkService.instance.getFk(getFkTableName(i), vv);
          if (fk == null) {
            dd = KeyValueMap.keyNotFound(vv);
          } else {
            dd = fk.drv;
            ee.valueDisplay = dd;
          }
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
      return completer.future;
    }
    String cmp = null;
    if (_entryList.isNotEmpty)
      cmp = DataRecord.getEntryValue(_entryList.first);
    if (cmp != newValue) {
      return renderColumn(new DEntry()..value = newValue, _columnList.first);
    }

    List<Future<String>> futureList = new List<Future<String>>();
    for (int i = 0; i < _entryList.length; i++) {
      futureList.add(renderColumn(_entryList[i], _columnList[i]));
    }
    Future.wait(futureList)
    .then((List<String> responseList){
      String display = null;
      for (String dd in responseList) {
        if (display == null)
          display = dd;
        else
          display += LUtil.DOT_SPACE + dd;
      }
      completer.complete(display);
    });

    return completer.future;
  } // render

  /// render column
  Future<String> renderColumn(DEntry newEntry, DColumn column) {
    String newValue = DataRecord.getEntryValue(newEntry);
    Completer<String> completer = new Completer<String>();
    if (DataUtil.isEmpty(newValue)) {
      completer.complete("");
      return completer.future;
    }
    String fkTableName = column.fkReference;
    if (fkTableName == null || fkTableName.isEmpty)
      fkTableName = column.name;

    DFK fk = FkService.instance.getFk(fkTableName, newValue);
    if (fk != null) {
      completer.complete(fk.drv);
      newEntry.valueDisplay = fk.drv;
    } else {
      FkService.instance.getFkFuture(fkTableName, newValue)
      .then((DFK fk2) {
        if (fk2 != null) {
          completer.complete(fk2.drv);
          String cmp = DataRecord.getEntryValue(newEntry);
          if (cmp == fk2.id) { // might have changed
            newEntry.valueDisplay = fk2.drv;
          }
        } else {
          completer.complete(KeyValueMap.keyNotFoundOnServer(newValue));
        }
      })
      .catchError((error, stackTrace) {
        _log.warning("renderColumn ${name} table=${fkTableName} value=${newValue}", error, stackTrace);
        completer.completeError(error, stackTrace);
      });
    }
    return completer.future;
  } // renderColumn

  /// Get Entry at Level
  DEntry getEntryAtLevel(int level) {
    if (_entryList.isEmpty || level < 0 || level >= _entryList.length) {
      return null;
    }
    return _entryList[level];
  }

  String getFkTableName(int level) {
    if (_columnList.isEmpty || level < 0 || level >= _columnList.length) {
      return null;
    }
    DColumn col = _columnList[level];
    if (col.hasFkReference())
      return col.fkReference;
    return col.name; //
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
    _dialog.show(this); // calls setValues
  }
  FkMultiDialog _dialog;

  /// Set Values
  void setValues(List<String> valueList) {
    for (int i = 0; i < _entryList.length; i++) {
      DEntry entry = _entryList[i];
      String newValue = valueList[i];
      DataRecord.setEntryValue(entry, newValue);
    }
    String newValue = valueList.first;
    render(newValue, false)
    .then((String display){
      _valueDisplay = display;
      input.value = _valueDisplay;
    });
    if (editorChange != null) {
      editorChange(name, newValue, entry, null);
    }
  } // setValues

} // FkMulti
