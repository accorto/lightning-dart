/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

class LSelect extends LEditorStd {

  final SelectElement input = new SelectElement();

  LSelect(String name) {
    input.name = name;
  }

  String get id => input.id;
  void set id (String newValue) {
    input.id = newValue;
    if (_label != null)
      _label.htmlFor = newValue;
  }

  String get name => input.name;
  String get type => input.type;

  bool get required => input.required;
  void set required (bool newValue) {
    super.required = newValue;
    input.required = newValue;
  }


} // LSelect
