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

  /// Get Form Element
  DivElement get formElement;

  /// Get Label as small element
  Element get labelSmall;
  /// Get Label as label element
  LabelElement get label;
  /// Get Input Element
  Element get input;


  /// get Id
  String get id;
  /// get Name
  String get name;
  /// get Type
  String get type;

  /// Label Text
  String get labelText => _labelText;
  /// Label Text
  void set labelText (String newValue) {
    _labelText = newValue;
  }
  String _labelText;


  bool get required;
  void set required (bool newValue);

}
