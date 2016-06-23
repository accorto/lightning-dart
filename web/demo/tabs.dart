/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart.demo;

class Tabs extends DemoFeature {

  Tabs() : super ("tabs", "Tabs",
  sldsStatus: DemoFeature.SLDS_DEV_READY,
  devStatus: DemoFeature.STATUS_COMPLETE,
  hints: [],
  issues: [],
  plans: ["overflow"]);

  LComponent get content {

    CDiv div = new CDiv();

    LTab tab = new LTab(scoped: option1);
    DivElement c1 = tab.addTab("One");
    c1.text = "One Content";
    DivElement c2 = tab.addTab("Two");
    c2.text = "Two Content";
    DivElement c3 = tab.addTab("Three");
    c3.text = "Three Content";
    div.add(tab);

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
