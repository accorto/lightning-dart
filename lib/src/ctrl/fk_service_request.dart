/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;


/**
 * Fk Request Info
 */
class FkServiceRequest {

  String tableName;
  String id;
  //
  String restrictionSql;
  String parentColumnName;
  String parentValue;
  //
  Completer<DFK> completer;
  Completer<List<DFK>> completerList;
  // active trx
  int trxNo;

  /// equals
  bool operator ==(o) =>  o is FkServiceRequest && compareString == o.compareString;
  /// hash code
  int get hashCode => compareString.hashCode;

  /// Compare String
  String get compareString {
    if (_compare == null) {
      _compare = tableName;
      if (id != null && id.isNotEmpty)
        _compare += "_i=${id}";
      if (restrictionSql != null && restrictionSql.isNotEmpty)
        _compare += "_s=${restrictionSql}";
      if (parentValue != null && parentColumnName.isNotEmpty)
        _compare += "_${parentColumnName}=${parentValue}";
    }
    return _compare;
  }
  String _compare;

  @override
  String toString() {
    String msg = compareString;
    if (trxNo != null)
      return msg;
    return "trx=${trxNo}_${msg}";
  }
} // ServiceFkRequest
