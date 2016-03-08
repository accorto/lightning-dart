/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart.demo;

class Forms extends DemoFeature {

  Forms() : super ("forms", "Forms",
  sldsStatus: DemoFeature.SLDS_DEV_READY,
  devStatus: DemoFeature.STATUS_COMPLETE,
  hints: [],
  issues: [],
  plans: []);


  String formType = LForm.C_FORM__STACKED;
  bool formSmall = false;
  bool fieldRequired = false;
  bool fieldReadOnly = false;
  bool fieldDisabled = false;
  DRecord record = new DRecord(); // to preserve state when options change

  LComponent get content {
    LForm form = new LForm.stacked("tf")
      ..classes.add(LMargin.C_HORIZONTAL__SMALL)
      ..formType = formType; // demo select

    LInput textInput = new LInput("text1", EditorI.TYPE_TEXT)
      ..label = "Text Input"
      ..placeholder = "Text Placeholder"
      ..readOnly = fieldReadOnly // demo toggle
      ..disabled = fieldDisabled // demo toggle
      ..required = fieldRequired; // demo toggle
    form.addEditor(textInput);

    LInput pwInput = new LInput("password1", EditorI.TYPE_PASSWORD)
      ..label = "Password Input"
      ..placeholder = "Password Placeholder"
      ..help = "Well, we are not picky - anything goes"
      ..readOnly = fieldReadOnly // demo toggle
      ..disabled = fieldDisabled // demo toggle
      ..required = fieldRequired; // demo toggle
    form.addEditor(pwInput);

    LCheckbox check = new LCheckbox("check1")
      ..label = "Checkbox Example"
      ..readOnly = fieldReadOnly // demo toggle
      ..disabled = fieldDisabled // demo toggle
      ..required = fieldRequired; // demo toggle
    form.addEditor(check);

    LInput emailInput = new LInput("email1", EditorI.TYPE_EMAIL)
      ..label = "Email Input"
      ..hint = "With basic email type validation"
      ..placeholder = "Email Placeholder"
      ..readOnly = fieldReadOnly // demo toggle
      ..disabled = fieldDisabled // demo toggle
      ..required = fieldRequired; // demo toggle
    form.addEditor(emailInput);

    LSelect sel = new LSelect("sel1")
      ..label = "Select Example"
      ..listItemList = generateListItems(5)
      ..readOnly = fieldReadOnly // demo toggle
      ..disabled = fieldDisabled // demo toggle
      ..required = fieldRequired; // demo toggle
    form.addEditor(sel);

    LTextArea ta = new LTextArea("ta1")
      ..label = "Text Area"
      ..readOnly = fieldReadOnly // demo toggle
      ..disabled = fieldDisabled // demo toggle
      ..required = fieldRequired; // demo toggle
    form.addEditor(ta);
    //
    form.addResetButton();
    form.addSaveButton();
    form.small = formSmall; // demo toggle
    //
    form.setRecord(record, 0);

    return form;
  } // content

  String get source {
    return '''
    LForm form = new LForm.stacked("tf")
      ..formType = formType; // demo toggle

    LInput textInput = new LInput("text1", EditorI.TYPE_TEXT)
      ..label = "Text Input"
      ..placeholder = "Text Placeholder"
      ..readOnly = fieldReadOnly // demo toggle
      ..disabled = fieldDisabled // demo toggle
      ..required = fieldRequired; // demo toggle
    form.addEditor(textInput);

    LInput pwInput = new LInput("email1", EditorI.TYPE_PASSWORD)
      ..label = "Password Input"
      ..placeholder = "Password Placeholder"
      ..help = "Well, we are not picky - anything goes"
      ..readOnly = fieldReadOnly // demo toggle
      ..disabled = fieldDisabled // demo toggle
      ..required = fieldRequired; // demo toggle
    form.addEditor(pwInput);

    LCheckbox check = new LCheckbox("check1")
      ..label = "Checkbox Example"
      ..readOnly = fieldReadOnly // demo toggle
      ..disabled = fieldDisabled // demo toggle
      ..required = fieldRequired; // demo toggle
    form.addEditor(check);

    LInput emailInput = new LInput("email1", EditorI.TYPE_EMAIL)
      ..label = "Email Input"
      ..hint = "With basic email type validation"
      ..placeholder = "Email Placeholder"
      ..readOnly = fieldReadOnly // demo toggle
      ..disabled = fieldDisabled // demo toggle
      ..required = fieldRequired; // demo toggle
    form.addEditor(emailInput);

    LSelect sel = new LSelect("sel1")
      ..label = "Select Example"
      ..listItems = generateListItems(5)
      ..readOnly = fieldReadOnly // demo toggle
      ..disabled = fieldDisabled // demo toggle
      ..required = fieldRequired; // demo toggle
    form.addEditor(sel);

    LTextArea ta = new LTextArea("ta1")
      ..label = "Text Area"
      ..readOnly = fieldReadOnly // demo toggle
      ..disabled = fieldDisabled // demo toggle
      ..required = fieldRequired; // demo toggle
    form.addEditor(ta);
    //
    form.addResetButton();
    form.addSaveButton();
    form.small = formSmall; // demo toggle
    //
    form.setRecord(record, 0);
    ''';
  }


  EditorI optionTypeSelect() {
    LSelect select = new LSelect("oType", idPrefix: id)
      ..label = "Form Type"
      ..small = true;
    select.addOption(new OptionElement(data: "Stacked", value: LForm.C_FORM__STACKED));
    select.addOption(new OptionElement(data: "Horizontal", value: LForm.C_FORM__HORIZONTAL));
    select.addOption(new OptionElement(data: "Inline", value: LForm.C_FORM__INLINE));
    select.input.onChange.listen((Event evt){
      formType = select.value;
      optionChanged();
    });
    return select;
  }
  EditorI optionRequiredCb() {
    LCheckbox cb = new LCheckbox("oReq", idPrefix: id)
      ..label = "Field Required";
    cb.input.onClick.listen((MouseEvent evt){
      fieldRequired = cb.input.checked;
      optionChanged();
    });
    return cb;
  }
  EditorI optionReadonlyCb() {
    LCheckbox cb = new LCheckbox("oRO", idPrefix: id)
      ..label = "Field ReadOnly";
    cb.input.onClick.listen((MouseEvent evt){
      fieldReadOnly = cb.input.checked;
      optionChanged();
    });
    return cb;
  }
  EditorI optionDisabledCb() {
    LCheckbox cb = new LCheckbox("oDis", idPrefix: id)
      ..label = "Field Disabled";
    cb.input.onClick.listen((MouseEvent evt){
      fieldDisabled = cb.input.checked;
      optionChanged();
    });
    return cb;
  }
  EditorI optionSmallCb() {
    LCheckbox cb = new LCheckbox("oSmall", idPrefix: id)
      ..label = "Labels+Fields+Buttons small";
    cb.input.onClick.listen((MouseEvent evt){
      formSmall = cb.input.checked;
      optionChanged();
    });
    return cb;
  }


  List<EditorI> get options {
    List<EditorI> list = new List<EditorI>();
    list.add(optionTypeSelect());
    list.add(optionSmallCb());
    list.add(optionRequiredCb());
    list.add(optionReadonlyCb());
    list.add(optionDisabledCb());
    return list;
  }

} // Forms
