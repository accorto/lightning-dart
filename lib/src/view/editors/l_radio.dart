/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;


/**
 * Form Radio
 */
class LRadio {
  // TODO radio extends LEditor

  /// Radio Form Element
  final FieldSetElement element = new FieldSetElement()
    ..classes.add(LForm.C_FORM_ELEMENT);

  final LegendElement _legend = new LegendElement()
    ..classes.addAll([LForm.C_FORM_ELEMENT__LABEL]);//, LForm.C_FORM_ELEMENT__LABEL__TOP]);

  final DivElement _control = new DivElement()
    ..classes.add(LForm.C_FORM_ELEMENT__CONTROL);


  LFormFieldSet() {
    element.append(_legend);
    element.append(_control);
  }



} // LRadio


/**
 * Radio Option
 */
class LRadioOption {

  LabelElement element = new LabelElement()
    ..classes.add(LForm.C_RADIO);

  InputElement _input = new InputElement(type: "radio");
  SpanElement _faux = new SpanElement()
    ..classes.add(LForm.C_RADIO__FAUX);
  SpanElement _label = new SpanElement()
    ..classes.add(LForm.C_FORM_ELEMENT__LABEL);

  /**
   * Radio Option
   */
  LRadioOption(String name, String idPrefix, String value, String label) {
    element.append(_input);
    element.append(_faux);
    element.append(_label);
    //
    _input.name = name;
    String id = "${idPrefix}-${name}-${value}";
    _input.id = id;
    element.htmlFor = id;
    _label.text = label;
  } // LRadioOption

} // LRadioOption
