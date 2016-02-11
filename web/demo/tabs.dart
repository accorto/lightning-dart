/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart.demo;

class Tabs extends DemoFeature {

  Tabs() : super ("tabs", "Tabs",
  sldsStatus: DemoFeature.SLDS_PROTOTYPE,
  devStatus: DemoFeature.STATUS_COMPLETE,
  hints: ["(Sales) Path has same API as Select"],
  issues: [],
  plans: ["overflow"]);

  LComponent get content {

    CDiv div = new CDiv();

    LTab tab = new LTab(scoped: option1)
      ..classes.add(LMargin.C_HORIZONTAL__MEDIUM);
    DivElement c1 = tab.addTab("One");
    c1.text = "One Content";
    DivElement c2 = tab.addTab("Two");
    c2.text = "Two Content";
    DivElement c3 = tab.addTab("Three");
    c3.text = "Three Content";
    div.add(tab);

    div.appendHR();
    List<DOption> options = new List<DOption>();
    options.add(OptionUtil.option("contact", "Contacted"));
    options.add(OptionUtil.option("open", "Open"));
    options.add(OptionUtil.option("unqualified", "Unqualified", isDefault: true));
    options.add(OptionUtil.option("nurturing", "Nurturing"));
    options.add(OptionUtil.option("closed", "Closed"));
    // Quick + easy
    LPath path = new LPath("path")
      ..label = "Sales Path";
    path.dOptionList = options;
    //path.element.classes.add(LMargin.C_HORIZONTAL__LARGE);
    //div.append(path.element);
    div.append(new DivElement()
      ..classes.add(LMargin.C_HORIZONTAL__LARGE)
      ..style.width = "300px"
      ..append(path.element));

    //
    div.appendHR();
    DColumn column = new DColumn()
      ..name = "path"
      ..label = "Sales Path"
      ..dataType = DataType.PICK
      ..pickValueList.addAll(options);
    DTable table = new DTable()
      ..name = "test"
      ..columnList.add(column);
    DataColumn dataColumn = new DataColumn(table,column,null,null);
    LEditor pathEditor = EditorUtil.createFromColumn("path", dataColumn, false, isAlternativeDisplay: true);
    LForm form = new LForm.stacked("form-path");
    FormSection formSection = new FormSection(1);
    form.setSection(formSection);
    form.addEditor(pathEditor);
    div.add(form);

    return div;
  }

  String get source {
    return '''
    LTab tab = new LTab(scoped: option1);
    DivElement c1 = tab.addTab("One");
    c1.text = "One Content";
    DivElement c2 = tab.addTab("Two");
    c2.text = "Two Content";
    DivElement c3 = tab.addTab("Three");
    c3.text = "Three Content";

    LPath path = new LPath("path")
      ..label = "Sales Path";
    List<DOption> options = new List<DOption>();
    options.add(OptionUtil.option("contact", "Contacted"));
    options.add(OptionUtil.option("open", "Open"));
    options.add(OptionUtil.option("unqualified", "Unqualified", isDefault: true));
    options.add(OptionUtil.option("nurturing", "Nurturing"));
    options.add(OptionUtil.option("closed", "Closed"));
    path.dOptionList = options;

    ''';
  }


  bool option1 = false;

  EditorI option1Cb() {
    LCheckbox cb = new LCheckbox("option1", idPrefix: id)
      ..label = "Option: Scoped";
    cb.input.onClick.listen((MouseEvent evt){
      option1 = cb.input.checked;
      optionChanged();
    });
    return cb;
  }

  List<EditorI> get options {
    List<EditorI> list = new List<EditorI>();
    list.add(option1Cb());
    return list;
  }
}
