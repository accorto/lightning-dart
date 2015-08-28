/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Form Editor
 * (LLookup extends LEditor but not with LFormElement)
 */
abstract class LEditor extends EditorI {

  /// Auto Id Numbering
  static int _autoId = 1;

  /// Get Form Element -- via with LFormElement or own
  Element get element;

  /// Showing
  bool get show => !element.classes.contains(LVisibility.C_HIDE);
  /// Show/Hide
  void set show (bool newValue) {
    if (newValue)
      element.classes.remove(LVisibility.C_HIDE);
    else
      element.classes.add(LVisibility.C_HIDE);
  }

  /// called by sub class
  String createId(String idPrefix, String name) {
    String theId = idPrefix;
    if (idPrefix == null || idPrefix.isEmpty) {
      theId = "ed-${_autoId++}";
    }
    if (name != null && name.isNotEmpty)
      theId = "${theId}-${name}";
    return theId;
  }

  /// Small Editor/Label
  void set small (bool newValue);

  /// get Data List Id
  String get listId => null;
  /// get Data List Id
  void set listId (String newValue){}
  /// Set Data List
  void set list (SelectDataList dl){}


} // LEditor
