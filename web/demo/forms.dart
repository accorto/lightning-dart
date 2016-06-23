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
  issues: ["Radio Button readOnly/disabled rendering"],
  plans: []);


  String formType = LForm.C_FORM__STACKED;
  bool fieldRequired = false;
  bool fieldReadOnly = false;
  bool fieldDisabled = false;
  String customValidity = "";
  DRecord record = new DRecord(); // to preserve state when options change

  LComponent get content {
    LForm form = new LForm.stacked("tf")
      ..classes.add(LMargin.C_HORIZONTAL__SMALL)
      ..formType = formType; // demo select

    LInput textInput = new LInput("text1", EditorI.TYPE_TEXT)
      ..label = "Text Input"
      ..placeholder = "Text Placeholder"
      ..setCustomValidity(customValidity)
      ..readOnly = fieldReadOnly // demo toggle
      ..disabled = fieldDisabled // demo toggle
      ..required = fieldRequired; // demo toggle
    form.addEditor(textInput);

    LInput pwInput = new LInput("password1", EditorI.TYPE_PASSWORD)
      ..label = "Password Input"
      ..placeholder = "Password Placeholder"
      ..help = "Well, we are not picky - anything goes"
      ..setCustomValidity(customValidity)
      ..readOnly = fieldReadOnly // demo toggle
      ..disabled = fieldDisabled // demo toggle
      ..required = fieldRequired; // demo toggle
    form.addEditor(pwInput);

    LCheckbox check = new LCheckbox("check1")
      ..label = "Checkbox Example"
      ..setCustomValidity(customValidity)
      ..readOnly = fieldReadOnly // demo toggle
      ..disabled = fieldDisabled // demo toggle
      ..required = fieldRequired; // demo toggle
    form.addEditor(check);

    LInput emailInput = new LInput("email1", EditorI.TYPE_EMAIL)
      ..label = "Email Input with hint"
      ..hint = "With basic email type validation"
      ..placeholder = "Email Placeholder"
      ..setCustomValidity(customValidity)
      ..readOnly = fieldReadOnly // demo toggle
      ..disabled = fieldDisabled // demo toggle
      ..required = fieldRequired; // demo toggle
    form.addEditor(emailInput);

    LInput textInput2 = new LInput("text2", EditorI.TYPE_TEXT)
      ..label = "Text Input with Help and Hint"
      ..placeholder = "Text Placeholder"
      ..help = "This is the Help for the Text Input"
      ..hint = "This is the Hint for the Text Input"
      ..setCustomValidity(customValidity)
      ..readOnly = fieldReadOnly // demo toggle
      ..disabled = fieldDisabled // demo toggle
      ..required = fieldRequired; // demo toggle
    form.addEditor(textInput2);

    LCheckbox check2 = new LCheckbox("check2")
      ..label = "Checkbox Example with hint and help"
      ..help = "This is the Help for the Checkbox"
      ..hint = "This is the Hint for the Checkbox"
      ..setCustomValidity(customValidity)
      ..readOnly = fieldReadOnly // demo toggle
      ..disabled = fieldDisabled // demo toggle
      ..required = fieldRequired; // demo toggle
    form.addEditor(check2);

    LCheckbox check3 = new LCheckbox("check3", asToggle: true)
      ..label = "Checkbox Toggle Example"
      ..setCustomValidity(customValidity)
      ..readOnly = fieldReadOnly // demo toggle
      ..disabled = fieldDisabled // demo toggle
      ..required = fieldRequired; // demo toggle
    form.addEditor(check3);

    LSelect sel = new LSelect("sel1")
      ..label = "Select Example"
      ..listItemList = generateListItems(5)
      ..setCustomValidity(customValidity)
      ..readOnly = fieldReadOnly // demo toggle
      ..disabled = fieldDisabled // demo toggle
      ..required = fieldRequired; // demo toggle
    form.addEditor(sel);

    LSelect sel9 = new LSelect("sel", multiple: true)
      ..label = "Multi Select Example"
      ..listItemList = generateListItems(3)
      ..setCustomValidity(customValidity)
      ..readOnly = fieldReadOnly // demo toggle
      ..disabled = fieldDisabled // demo toggle
      ..required = fieldRequired; // demo toggle
    form.addEditor(sel9);

    LRadioGroup sel2 = new LRadioGroup("sel2")
      ..label = "Select Example with Radio's"
      ..listItemList = generateListItems(3)
      ..setCustomValidity(customValidity)
      ..readOnly = fieldReadOnly // demo toggle
      ..disabled = fieldDisabled // demo toggle
      ..required = fieldRequired; // demo toggle
    form.addEditor(sel2);

    LRadioGroup sel3 = new LRadioGroup("sel3", asButtons:true)
      ..label = "Select Example with Radio Buttons"
      ..listItemList = generateListItems(5)
      ..setCustomValidity(customValidity)
      ..readOnly = fieldReadOnly // demo toggle
      ..disabled = fieldDisabled // demo toggle
      ..required = fieldRequired; // demo toggle
    form.addEditor(sel3);

    LRadioGroup sel4 = new LRadioGroup("sel4", multiple:true)
      ..label = "Multi Select Example with Checkbox's"
      ..listItemList = generateListItems(3)
      ..setCustomValidity(customValidity)
      ..readOnly = fieldReadOnly // demo toggle
      ..disabled = fieldDisabled // demo toggle
      ..required = fieldRequired; // demo toggle
    form.addEditor(sel4);

    LRadioGroup sel5 = new LRadioGroup("sel5", multiple:true, asButtons: true)
      ..label = "Multi Select Example with Buttons"
      ..listItemList = generateListItems(5)
      ..setCustomValidity(customValidity)
      ..readOnly = fieldReadOnly // demo toggle
      ..disabled = fieldDisabled // demo toggle
      ..required = fieldRequired; // demo toggle
    form.addEditor(sel5);


    LTextArea ta = new LTextArea("ta1")
      ..label = "Text Area"
      ..setCustomValidity(customValidity)
      ..readOnly = fieldReadOnly // demo toggle
      ..disabled = fieldDisabled // demo toggle
      ..required = fieldRequired; // demo toggle
    form.addEditor(ta);
    //
    form.addResetButton();
    form.addSaveButton();
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
    //
    form.setRecord(record, 0);
    ''';
  }


  EditorI optionTypeSelect() {
    LSelect select = new LSelect("oType", idPrefix: id)
      ..label = "Form Type"
      ..maxWidth = "8rem";
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
  EditorI optionCustomValidityCb() {
    LCheckbox cb = new LCheckbox("valid", idPrefix: id)
      ..label = "Custom Validity";
    cb.input.onClick.listen((MouseEvent evt){
      customValidity = "";
      if (cb.input.checked)
        customValidity = "custom validation message";
      optionChanged();
    });
    return cb;
  }


  List<EditorI> get options {
    List<EditorI> list = new List<EditorI>();
    list.add(optionTypeSelect());
    list.add(optionRequiredCb());
    list.add(optionReadonlyCb());
    list.add(optionDisabledCb());
    list.add(optionCustomValidityCb());
    return list;
  }

} // Forms
