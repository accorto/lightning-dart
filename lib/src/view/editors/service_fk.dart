/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Data Controller for Lookup
 */
class ServiceFk {

  /// Fk Table
  String fkReference;
  List<String> parents;

  /// value-display
  Map<String,String> valueMap = new Map<String,String>();

  ServiceFk(LLookup lookup) {
    String parent = lookup.dataColumn.tableColumn.parentReference;
    if (parent != null && parent.isEmpty) {
      parents = parent.split(",");
    }
    fkReference = lookup.dataColumn.tableColumn.fkReference;
  }


  void onDependentOnChanged(DEntry dependentEntry) {
  }

  /// get display for [value] - might be null if not cached
  String getDisplay (String value) {
    if (value == null || value.isEmpty) {
      return "";
    }
    return valueMap[value];
  }

  /// get display for [value]
  Future<String> getDisplayAsync(String value) {
    Completer<String> completer = new Completer<String>();
    if (value == null || value.isEmpty) {
      completer.complete("");
    } else {
      String display = valueMap[value];
      if (display != null) {
        completer.complete(display);
      } else {
        // TODO
      }
    }
    return completer.future;
  } // getDisplayAsync


  String toString() {
    return "ServiceFk@${fkReference} #${valueMap.length}";
  }

} // ServiceFk
