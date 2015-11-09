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
    return new FkCtrl.from(dataColumn, idPrefix:idPrefix, inGrid:inGrid);
  }

  static final Logger _log = new Logger("FkCtrl");

  /// Fk Table
  String tableName;
  String restrictionSql = null;
  List<String> parents;

  List<DFK> fkCompleteList;
  bool fkComplete = false;
  String lastDependentInfo;

  /**
   * Fk Editor
   */
  FkCtrl.from(DataColumn dataColumn, {String idPrefix, bool inGrid:false})
      : super.from(dataColumn, idPrefix:idPrefix, inGrid:inGrid) {
    tableName = dataColumn.tableColumn.fkReference;
    if (dataColumn.tableColumn.hasRestrictionSql()) {
      restrictionSql = dataColumn.tableColumn.restrictionSql;
    }
    String parent = dataColumn.tableColumn.parentReference;
    if (parent != null && parent.isEmpty) {
      parents = parent.split(",");
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
        if (!found && setValidity) {
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
    String dependentInfo = "${dependentName}=${dependentValue}";
    if (dependentInfo == lastDependentInfo) {
      _log.config("onDependentOnChanged ${name} ${dependentInfo} (same)");
      return;
    }
    _log.config("onDependentOnChanged ${name} ${dependentInfo}");
    lastDependentInfo = dependentInfo;
    String lastValue = value;
    clearOptions();

    if (dependentValue == null || dependentValue.isEmpty) {
      value = null;
    } else if (fkCompleteList != null) {
      for (DFK fk in fkCompleteList) {
        String rv = DataRecord.getColumnValueFk(fk, dependentValue);
        if (rv != null && rv == dependentValue) { // parent match
          LLookupItem item = new LLookupItem.fromFk(fk);
          addLookupItem(item);
        }
        _log.config("onDependentOnChanged ${name} match count=${lookupItemList.length}");
      }
      value = lastValue;
    } else {
      value = null; // different parent
      FkService.instance.getFkListFuture(tableName, restrictionSql, dependentName, dependentValue)
      .then((List<DFK> fks) {
        for (DFK fk in fks) {
          LLookupItem item = new LLookupItem.fromFk(fk);
          addLookupItem(item);
        }
        _log.config("onDependentOnChanged ${name} query count=${lookupItemList.length}");
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
      _dialog = FkDialog.getDialog(tableName);
    }
    _dialog.show(this);
  }
  FkDialog _dialog;


} // FkCtrl
