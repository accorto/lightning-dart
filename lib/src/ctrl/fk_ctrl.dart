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

  /// FK Service
  static FkService fkService;

  /// create fk lookup
  static LLookup createLookup(DataColumn dataColumn, String idPrefix, bool inGrid) {
    return new FkCtrl.from(dataColumn, idPrefix:idPrefix, inGrid:inGrid);
  }

  static final Logger _log = new Logger("FkCtrl");

  /// Fk Table
  String tableName;
  List<String> parents;
  bool fkComplete = false;

  /**
   * Fk Editor
   */
  FkCtrl.from(DataColumn dataColumn, {String idPrefix, bool inGrid:false})
      : super.from(dataColumn, idPrefix:idPrefix, inGrid:inGrid) {
    tableName = dataColumn.tableColumn.fkReference;
    String parent = dataColumn.tableColumn.parentReference;
    if (parent != null && parent.isEmpty) {
      parents = parent.split(",");
    }
    // Editor
    icon.element.onClick.listen(onIconClick);

    // Init Data
    if (fkService != null) {
      List<DFK> complete = fkService.getFkList(tableName, null);
      if (complete != null) {
        for (DFK fk in complete) {
          LLookupItem item = new LLookupItem.fromFk(fk);
          addLookupItem(item);
        }
        fkComplete = true;
      } else {
        fkService.getFkListFuture(tableName, null, null, null)
        .then((List<DFK> fks) {
          for (DFK fk in fks) {
            LLookupItem item = new LLookupItem.fromFk(fk);
            addLookupItem(item);
          }
          fkComplete = fkService.isComplete(tableName);
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
      if (fkService != null) {
        DFK fk = fkService.getFk(tableName, newValue);
        if (fk != null) {
          completer.complete(fk.drv);
          found = true;
        }
        if (!found) {
          fkService.getFkFuture(tableName, newValue)
          .then((DFK fk2){
            if (fk2 != null)
              completer.complete(fk2.drv);
            else
              completer.complete("!${newValue}!");
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
    _log.config("onDependentOnChanged ${name} ${dependentEntry.columnName}");
    // validateOptions();
    // TODO
  }

  /// On Icon Click
  void onIconClick(Event evt) {
    _log.config("onIconClick ${name}");
    // TODO
  }



} // FkCtrl
