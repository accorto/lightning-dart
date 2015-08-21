/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Form Editor
 */
abstract class LEditor extends EditorI {

  static const String C_INPUT = "slds-input";

  static const String C_INPUT__BARE = "slds-input--bare";

  static const String C_INPUT__ICON = "slds-input__icon";
  static const String C_INPUT_HAS_ICON = "slds-input-has-icon";
  static const String C_INPUT_HAS_ICON__LEFT = "slds-input-has-icon--left";
  static const String C_INPUT_HAS_ICON__RIGHT = "slds-input-has-icon--right";


  /// Auto Id Numbering
  static int _autoId = 1;

  /// Get Form Element
  DivElement get element;

  /// Get Label as small element
  Element get labelSmall;
  /// Get Label as label element
  LabelElement get labelElement;
  /// Get Input/Select/.. Element
  Element get input;


  bool get show => !element.classes.contains(LVisibility.C_HIDE);
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


  /// get Data List Id
  String get listId => null;
  /// get Data List Id
  void set listId (String newValue){}
  /// Set Data List
  void set list (SelectDataList dl){}


} // LEditor
