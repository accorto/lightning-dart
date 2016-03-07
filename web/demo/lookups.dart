/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart.demo;

class Lookups extends DemoFeature {

  Lookups() : super("lookups", "Lookups",
  sldsStatus: DemoFeature.SLDS_PROTOTYPE,
  devStatus: DemoFeature.STATUS_PARTIAL,
  hints: ["Same API as Select/Picklist"],
  issues: [],
  plans: []);

  bool fieldRequired = false;
  bool fieldReadOnly = false;
  bool fieldDisabled = false;
  DRecord record = new DRecord(); // to preserve state when options change

  LComponent get content {
    LForm form = new LForm.stacked("tf")
      ..classes.add(LMargin.C_HORIZONTAL__MEDIUM);

    LLookup l1 = new LLookup.base("l1")
      ..label = "Base Lookup"
      ..placeholder = "Base Lookup Placeholder"
      ..readOnly = fieldReadOnly // demo toggle
      ..disabled = fieldDisabled // demo toggle
      ..required = fieldRequired; // demo toggle
    l1.listItemList = generateListItems(10);
    form.addEditor(l1);

    form.append(new HRElement()..style.backgroundColor = "black");
    LLookup l2 = new LLookupSelect.single("l2")
      ..label = "Single Select Lookup"
      ..placeholder = "Single Select Lookup Placeholder"
      ..readOnly = fieldReadOnly // demo toggle
      ..disabled = fieldDisabled // demo toggle
      ..required = fieldRequired; // demo toggle
    l2.listItemList = generateListItems(10, iconLeft: true);
    form.addEditor(l2);

    form.append(new HRElement()..style.backgroundColor = "black");
    LLookup l3 = new LLookupSelect.multi("l3")
      ..label = "Multi Select Lookup"
      ..placeholder = "Multi Select Lookup Placeholder"
      ..readOnly = fieldReadOnly // demo toggle
      ..disabled = fieldDisabled // demo toggle
      ..required = fieldRequired; // demo toggle
    l3.listItemList = generateListItems(10, iconLeft: true);
    form.addEditor(l3);

    form.append(new HRElement()..style.backgroundColor = "black");
    LLookup l4 = new LLookupTimezone("tz")
      ..label = "Timezone"
      ..readOnly = fieldReadOnly // demo toggle
      ..disabled = fieldDisabled // demo toggle
      ..required = fieldRequired; // demo toggle
    form.addEditor(l4);

    form.setRecord(record, 0);
    return form;
  }

  String get source {
    return '''
    LForm form = new LForm.stacked("tf");

    LLookup l1 = new LLookup.base("l1")
      ..label = "Base Lookup";
    l1.listItemList = generateListItems(10);
    l1.value = "item5";
    form.addEditor(l1);

    form.append(new HRElement());
    LLookup l2 = new LLookupSelect.single("l2")
      ..label = "Single Select Lookup";
    l2.listItemList = generateListItems(10, iconLeft: true);
    form.addEditor(l2);

    form.append(new HRElement());
    LLookup l3 = new LLookupSelect.multi("l3")
      ..label = "Multi Select Lookup";
    l3.listItemList = generateListItems(10, iconLeft: true);
    form.addEditor(l3);

    form.append(new HRElement());
    LLookup l4 = new LLookupTimezone("l4")
      ..label = "Timezone";
    form.addEditor(l4);
    ''';
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

  List<EditorI> get options {
    List<EditorI> list = new List<EditorI>();
    list.add(optionRequiredCb());
    list.add(optionReadonlyCb());
    list.add(optionDisabledCb());
    return list;
  }

}
