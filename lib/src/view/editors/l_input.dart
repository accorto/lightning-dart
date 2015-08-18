/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Input Editor
 */
class LInput extends LEditorStd {

  /// Input Element
  final InputElement input = new InputElement();

  /**
   * Input Editor
   */
  LInput(String name, String type, {String idPrefix}) {
    input.name = name;
    input.id = createId(idPrefix, name);
    input.type = type;
  }

  String get id => input.id;
  void set id (String newValue) {
    input.id = newValue;
    if (_labelElement != null)
      _labelElement.htmlFor = newValue;
  }

  String get name => input.name;
  String get type => input.type;

  bool get required => input.required;
  void set required (bool newValue) {
    super.required = newValue;
    input.required = newValue;
  }

  /// get Data List Id
  String get listId => input.attributes["list"];
  /// get Data List Id
  void set listId (String newValue) {
    input.attributes["list"] = newValue;
  }
  /// Set Data List
  void set list (SelectDataList dl) {
    input.attributes["list"] = dl.id;
  }

} // LInput
