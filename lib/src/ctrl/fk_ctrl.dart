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
  static LLookup createLookup(DataColumn dataColumn, String idPrefix, bool inGrid) {
    if (dataColumn.tableColumn.hasFkReference()) {
      return new FkCtrl.from(dataColumn, idPrefix: idPrefix, inGrid: inGrid);
    }
    String columnName = dataColumn.tableColumn.name;
    if (columnName.contains(_regExpId)) {
      return new FkCtrl.from(dataColumn, idPrefix: idPrefix, inGrid: inGrid);
    }
    _log.warning("createLookup ${dataColumn.name}: NoFkReference");
    return null;
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
      icon.element.onClick.listen(onIconClick);
      // List
      List<DFK> complete = FkService.instance.getFkList(tableName, restrictionSql);
      if (complete != null) {
        fkCompleteList = complete;
        for (DFK fk in complete) {
          LLookupItem item = new LLookupItem.fromFk(fk);
          addLookupItem(item);
        }
        fkComplete = true;
      } else {
        FkService.instance.getFkListFuture(tableName, restrictionSql, null, null)
        .then((List<DFK> fks) {
          for (DFK fk in fks) {
            LLookupItem item = new LLookupItem.fromFk(fk);
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
      bool found = false;
      if (FkService.instance != null) {
        DFK fk = FkService.instance.getFk(tableName, newValue);
        if (fk != null) {
          completer.complete(fk.drv);
          found = true;
        }
        if (!found) {
          FkService.instance.getFkFuture(tableName, newValue)
          .then((DFK fk2){
            if (fk2 != null)
              completer.complete(fk2.drv);
            else
              completer.complete("!${newValue}!");
          })
          .catchError((error, stackTrace) {
            _log.warning("render ${tableName}.${name}", error, stackTrace);
            completer.completeError(error, stackTrace);
          });
        }
      } else {
        for (LLookupItem item in lookupItemList) {
          if (item.value == newValue) {
            completer.complete(item.label);
            found = true;
            break;
          }
        }
        if (!found) {
          completer.completeError("~~${newValue}~~");
          if (setValidity)
            input.setCustomValidity("${LLookup.lLookupInvalidValue()}=${newValue}");
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
          LLookupItem item = new LLookupItem.fromFk(fk);
          addLookupItem(item);
        }
      }
      _log.fine("onDependentOnChanged ${name} match count=${lookupItemList.length}");
    } else {
      value = null; // different parent
      FkService.instance.getFkListFuture(tableName, restrictionSql, dependentName, dependentValue)
      .then((List<DFK> fks) {
        for (DFK fk in fks) {
          LLookupItem item = new LLookupItem.fromFk(fk);
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
    if (readOnly)
      return;
    if (_dialog == null) {
      _dialog = FkDialog.getDialog(tableName, parents != null && parents.isNotEmpty);
    }
    _dialog.show(this);
  }
  FkDialog _dialog;


} // FkCtrl
