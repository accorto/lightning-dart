/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Form Editor
 */
abstract class LEditor {

  static const String C_INPUT = "slds-input";

  static const String C_INPUT__BARE = "slds-input--bare";

  static const String C_INPUT__ICON = "slds-input__icon";
  static const String C_INPUT_HAS_ICON = "slds-input-has-icon";
  static const String C_INPUT_HAS_ICON__LEFT = "slds-input-has-icon--left";
  static const String C_INPUT_HAS_ICON__RIGHT = "slds-input-has-icon--right";


  /// Auto Id Numbering
  static int _autoId = 1;

  /// Get Form Element
  DivElement get formElement;

  /// Get Label as small element
  Element get labelSmall;
  /// Get Label as label element
  LabelElement get labelElement;
  /// Get Input Element
  Element get input;


  /// get Id
  String get id;
  /// get Name
  String get name;
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

  /// get Type
  String get type;

  /// Label Text
  String get label => _label;
  /// Label Text
  void set label (String newValue) {
    _label = newValue;
  }
  String _label;

  /// required
  bool get required;
  /// required
  void set required (bool newValue);

  /// get Data List Id
  String get listId => null;
  /// get Data List Id
  void set listId (String newValue){}
  /// Set Data List
  void set list (SelectDataList dl){}


} // LEditor
