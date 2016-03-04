/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_model;

/**
 * FK Functionality
 */
class FkRecord {

  /**
   * Get value as String for [columnName] or null if not found
   */
  static String getColumnValue(DFK fk, String columnName) {
    if (columnName != null && fk != null && fk.entryList.isNotEmpty) {
      for (DEntry entry in fk.entryList) {
        if (columnName == entry.columnName) {
          return DataRecord.getEntryValue(entry);
        }
      }
    }
    return null;
  } // columnValue

  /**
   * Has the FK a column with value matches [columnValue]
   */
  static bool matchExactColumnValue(DFK fk, String columnName, String columnValue) {
    String cmp = getColumnValue(fk, columnName);
    return cmp != null && cmp == columnValue;
  } // matchExactColumnValue


  /**
   * Has the FK a column with value no value or [columnValue]
   */
  static bool matchNullColumnValue(DFK fk, String columnName, String columnValue) {
    String cmp = getColumnValue(fk, columnName);
    if (cmp == null)
      cmp = "";
    if (columnValue == null)
      columnValue = "";
    return cmp == columnValue;
  } // matchNullColumnValue



  //final DFK fk;
  //FkRecord(DFK this.fk) {
  //}

} // FkRecord
