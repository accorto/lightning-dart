/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/**
 * Fk Editor
 */
class FkCtrl
    extends LLookup {

  /// create fk lookup
  static LEditor createLookup(DataColumn dataColumn, bool inGrid,
        String idPrefix, bool isAlternativeDisplay, bool isFilter) {

    if (dataColumn.tableColumn.hasFkReference()) {
      if (isAlternativeDisplay)
        return new FkMulti.from(dataColumn, idPrefix: idPrefix, inGrid: inGrid);
      return new FkCtrl.from(dataColumn, idPrefix: idPrefix, inGrid: inGrid);
    }
    String columnName = dataColumn.tableColumn.name;
    if (columnName.contains(_regExpId)) {
      if (isAlternativeDisplay)
        return new FkMulti.from(dataColumn, idPrefix: idPrefix, inGrid: inGrid);
      return new FkCtrl.from(dataColumn, idPrefix: idPrefix, inGrid: inGrid);
    }
    //_log.warning("createLookup ${dataColumn.name}: NoFkReference");
    return new LLookup.from(dataColumn, idPrefix: idPrefix, inGrid: inGrid);
  }

  static final Logger _log = new Logger("FkCtrl");

  /// ends with _ID
  static final RegExp _regExpId = new RegExp(r'_ID$');
  /// starts with Parent
  static final RegExp _regExpParent = new RegExp(r'^Parent');

  /// Fk Table
  String tableName;
  String restrictionSql = null;
  List<String> parents;
  List<String> parentValues;

  List<DFK> fkCompleteList;
  bool fkComplete = false;
  String dependentInfo;

  /**
   * Fk Editor
   */
  FkCtrl.from(DataColumn dataColumn, {String idPrefix, bool inGrid:false})
      : super.from(dataColumn, idPrefix:idPrefix, inGrid:inGrid) {
    if (inGrid) {
      input.classes.remove(LInput.C_W160);
      input.classes.add(LInput.C_W180);
    }
    if (dataColumn.tableColumn.hasFkReference()) {
      tableName = dataColumn.tableColumn.fkReference;
    } else {
      String columnName = dataColumn.tableColumn.name;
      columnName = columnName.replaceAll(_regExpId, "");
      tableName = columnName.replaceAll(_regExpParent, "");
      dataColumn.tableColumn.fkReference = tableName; // speed up
    }
    if (dataColumn.tableColumn.hasRestrictionSql()) {
      restrictionSql = dataColumn.tableColumn.restrictionSql;
    }
    String parent = dataColumn.tableColumn.parentReference;
    if (parent != null && parent.isNotEmpty) {
      parents = parent.split(",");
      parentValues = new List<String>.filled(parents.length, null);
    }

    // Init Data
    if (FkService.instance != null) {
      // Editor
      getIconRight().element.onClick.listen(onIconClick);
      // List
      List<DFK> complete = FkService.instance.getFkList(tableName, restrictionSql);
      if (complete != null) {
        fkCompleteList = complete;
        for (DFK fk in complete) {
          LLookupItem item = new LLookupItem.fromFk(fk, tableName);
          addLookupItem(item);
        }
        fkComplete = true;
      } else {
        FkService.instance.getFkListFuture(tableName, restrictionSql, null, null)
        .then((List<DFK> fks) {
          for (DFK fk in fks) {
            LLookupItem item = new LLookupItem.fromFk(fk, tableName);
            addLookupItem(item);
          }
          fkComplete = FkService.instance.isComplete(tableName);
          if (fkComplete)
            fkCompleteList = fks;
        })
        .catchError((error, stackTrace){
          _log.warning("from ${tableName}.${name}", error, stackTrace);
        });
      }
    }
  } // FkCtrl


  /// render [newValue]
  @override
  Future<String> render(String newValue, bool setValidity) {
    Completer<String> completer = new Completer<String>();
    if (setValidity) {
      input.setCustomValidity("");
    }
    if (newValue == null || newValue.isEmpty) {
      completer.complete("");
    } else {
      if (FkService.instance != null) {
        DFK fk = FkService.instance.getFk(tableName, newValue);
        if (fk != null) { // in cache
          completer.complete(fk.drv);
        } else { // get
          FkService.instance.getFkFuture(tableName, newValue)
          .then((DFK fk2) {
            if (fk2 != null) {
              completer.complete(fk2.drv);
              if (entry != null) {
                String cmp = DataRecord.getEntryValue(entry);
                if (cmp == fk2.id) { // might have changed
                  entry.valueDisplay = fk2.drv;
                }
              }
            } else {
              completer.complete(KeyValueMap.keyNotFoundOnServer(newValue));
            }
          })
          .catchError((error, stackTrace) {
            _log.warning("render ${tableName}.${name}", error, stackTrace);
            completer.completeError(error, stackTrace);
          });
        }
      } else { // no fkService
        String dvalue = null;
        for (LLookupItem item in lookupItemList) {
          if (item.value == newValue) {
            dvalue = item.label;
            break;
          }
        }
        if (dvalue == null || dvalue.isEmpty) {
          completer.completeError("~~${newValue}~~");
          if (setValidity)
            input.setCustomValidity("${LLookup.lLookupInvalidValue()}=${newValue}");
        } else {
          completer.complete(dvalue);
        }
      } // no fkService
    } // not empty
    return completer.future;
  } // render

  /// Dependent On Changed
  void onDependentOnChanged(DEntry dependentEntry) {
    super.onDependentOnChanged(dependentEntry);
    String dependentName = dependentEntry.columnName;
    String dependentValue = DataRecord.getEntryValue(dependentEntry);
    String dependentInfoTemp = null;
    for (int i = 0; i < parents.length; i++) {
      if (parents[i] == dependentName) {
        parentValues[i] = dependentValue;
      }
      if (dependentInfoTemp == null) {
        dependentInfoTemp = "${parents[i]}=${parentValues[i]}";
      } else {
        dependentInfoTemp += "|${parents[i]}=${parentValues[i]}";
      }
    }
    if (dependentInfoTemp == dependentInfo) {
      _log.config("onDependentOnChanged ${name}: ${dependentInfoTemp} (same)");
      return;
    }
    _log.config("onDependentOnChanged ${name}: ${dependentInfoTemp}");
    dependentInfo = dependentInfoTemp;

    // reset
    clearOptions();
    value = null;
    editorChange(name, null, null, null);

    if (dependentValue == null || dependentValue.isEmpty) {
      return;
    }
    if (fkCompleteList != null) {
      for (DFK fk in fkCompleteList) {
        String rv = DataRecord.getColumnValueFk(fk, dependentName);
        if (rv != null && rv == dependentValue) { // parent match
          LLookupItem item = new LLookupItem.fromFk(fk, tableName);
          addLookupItem(item);
        }
      }
      _log.fine("onDependentOnChanged ${name} match count=${lookupItemList.length}");
    } else {
      value = null; // different parent
      FkService.instance.getFkListFuture(tableName, restrictionSql, dependentName, dependentValue)
      .then((List<DFK> fks) {
        for (DFK fk in fks) {
          LLookupItem item = new LLookupItem.fromFk(fk, tableName);
          addLookupItem(item);
        }
        _log.fine("onDependentOnChanged ${name} query count=${lookupItemList.length}");
      })
      .catchError((error, stackTrace){
        _log.warning("from ${tableName}.${name}", error, stackTrace);
      });
    }
    // ?? validateOptions(); ??
  } // onDependentOnChanged

  /// On Icon Click
  void onIconClick(Event evt) {
    _log.config("onIconClick ${name}");
    evt.preventDefault();
    evt.stopPropagation();
    showDropdown = false;
    if (readOnly || disabled) {
      return;
    }
    if (_dialog == null) {
      _dialog = FkDialog.getDialog(tableName, parents != null && parents.isNotEmpty);
    }
    _dialog.show(this); // sets value and calls onInputChange(null)
  }
  FkDialog _dialog;


} // FkCtrl
