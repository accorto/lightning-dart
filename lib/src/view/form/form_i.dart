/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/// Record Saved
typedef void RecordSaved(DRecord record);

/**
 * Form Interface
 */
abstract class FormI {

  /// Set and display Data Record
  void setRecord (DRecord record, int rowNo);

  /// editor/record change - manage dependencies
  void onRecordChange(DRecord record, DEntry columnChanged, int rowNo);

  /// Callback when save
  RecordSaved onRecordSaved;

} // FormI
