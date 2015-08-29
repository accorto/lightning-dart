/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Form Field Set of Compound Form
 */
class LFormFieldSet extends LComponent {

  final FieldSetElement element = new FieldSetElement()
    ..classes.add(LForm.C_FORM__COMPOUND);

  final LegendElement _legend = new LegendElement()
    ..classes.addAll([LForm.C_FORM_ELEMENT__LABEL, LForm.C_FORM_ELEMENT__LABEL__TOP]);

  final DivElement _control = new DivElement()
    ..classes.add(LForm.C_FORM_ELEMENT__CONTROL);


  final List<LFormFieldSetGroup> _groups = new List<LFormFieldSetGroup>();

  LFormFieldSet() {
    element.append(_legend);
    element.append(_control);

  }

  String get label => _legend.text;
  void set Label (String newValue) {
    _legend.text = newValue;
  }


  /// create and add group
  LFormFieldSetGroup addGroup() {
    LFormFieldSetGroup grp = new LFormFieldSetGroup();
    element.append(grp.element);
    _groups.add(grp);
    return grp;
  }

  /// Form Layout Vertical
  bool get vertical => element.classes.contains(LForm.C_FORM__COMPOUND);
  /// Form Layout Vertical
  void set vertical (bool newValue) {
    if (newValue) {
      element.classes.add(LForm.C_FORM__COMPOUND);
      element.classes.remove(LForm.C_FORM__COMPOUND__HORIZONTAL);
    } else {
      element.classes.remove(LForm.C_FORM__COMPOUND);
      element.classes.add(LForm.C_FORM__COMPOUND__HORIZONTAL);
    }
  }
  /// Form Layout Horizontal
  bool get horizontal => element.classes.contains(LForm.C_FORM__COMPOUND__HORIZONTAL);
  /// Form Layout Horizontal
  void set horizontal (bool newValue) {
    vertical = !newValue;
  }

} // LFormFieldSet


/**
 *
 */
class LFormFieldSetGroup {

  final DivElement element = new DivElement()
    ..classes.add(LForm.C_FORM_ELEMENT__GROUP);

  final List<LFormFieldSetGroupRow> _rows = new List<LFormFieldSetGroupRow>();

  LFormFieldSetGroup() {

  } // LFormFieldSetGroup

  /// create and add row
  LFormFieldSetGroupRow addRow() {
    LFormFieldSetGroupRow row = new LFormFieldSetGroupRow(1);
    element.append(row.element);
    _rows.add(row);
    return row;
  }

} // LFormFieldSetGroup



class LFormFieldSetGroupRow {

  final DivElement element = new DivElement()
    ..classes.add(LForm.C_FORM_ELEMENT__ROW);

  final int fieldCount;

  LFormFieldSetGroupRow(int this.fieldCount) {

  }

  void addEditor(InputElement input, String label, {int width:1}) {
    LabelElement labelElement = new LabelElement()
      ..classes.add(LForm.C_FORM_ELEMENT__CONTROL)
      ..classes.add("slds-size--${width}-of-${fieldCount}");
    Element small = new Element.tag("small")
      ..classes.add(LForm.C_FORM_ELEMENT__HELPER)
      ..text = label;
    labelElement.append(small);
    labelElement.append(input);
    // TODO input-label link
    element.append(labelElement);
  }

} // LFormFieldSetGroupRow
