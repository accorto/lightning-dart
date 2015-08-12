/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Form with FormElements
 */
class LForm {

  static const String C_FORM__HORIZONTAL = "slds-form--horizontal";
  static const String C_FORM__STACKED = "slds-form--stacked";
  static const String C_FORM__INLINE = "slds-form--inline";
  
  static const String C_FORM_ELEMENT = "slds-form-element";
  static const String C_FORM_ELEMENT__LABEL = "slds-form-element__label";
  static const String C_FORM_ELEMENT__CONTROL = "slds-form-element__control";

  static const String C_HAS_ERROR = "slds-has-error";
  static const String C_IS_REQUIRED = "slds-is-required";

  static const String C_FORM_ELEMENT__HELP = "slds-form-element__help";


  /// Form Element
  final Element element;
  /// List of Editors
  final List<LEditor> editors = new List<LEditor>();

  /// Form
  LForm(Element this.element, String type) {
    element.classes.add(type);
  }

  LForm.horizontal() : this(new FormElement(), C_FORM__HORIZONTAL);
  LForm.stacked() : this(new FormElement(), C_FORM__STACKED);
  LForm.inline() : this(new FormElement(), C_FORM__INLINE);


  void add (LEditor editor) {
    editors.add(editor);
    element.append(editor.formElement);
  }

}
