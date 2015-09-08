/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/// Record Saved returning error
typedef String RecordSaved(DRecord record);

/// Record Deleted returning error
typedef String RecordDeleted(DRecord record);

/// Record Deleted returning error
typedef String RecordsDeleted(List<DRecord> records);

/**
 * Form Interface
 */
abstract class FormI {

  /// Set and display Data Record
  void setRecord (DRecord record, int rowNo);

  /// editor/record change - manage dependencies
  void onRecordChange(DRecord record, DEntry columnChanged, int rowNo);

  /// Callback when save
  RecordSaved recordSaved;
  /// Callback when delete
  RecordDeleted recordDeleted;

} // FormI
