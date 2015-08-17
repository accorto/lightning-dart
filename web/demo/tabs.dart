/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart.demo;

class Tabs extends DemoFeature {

  Tabs() : super ("tabs", "Tabs", "Tab Panel Navigation, Labels are convered to upper case");

  LComponent get content {

    LTab tab = new LTab(scoped: option1);
    DivElement c1 = tab.addTab("One");
    c1.text = "One Content";
    DivElement c2 = tab.addTab("Two");
    c2.text = "Two Content";
    DivElement c3 = tab.addTab("Three");
    c3.text = "Three Content";

    return tab;
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
    ''';
  }


  bool option1 = false;

  DivElement option1Cb() {
    LCheckbox cb = new LCheckbox("option1", idPrefix: id)
      ..label = "Option 1: Scoped";
    cb.input.onClick.listen((MouseEvent evt){
      option1 = cb.input.checked;
      optionChanged();
    });
    return cb.formElement;
  }

  List<DivElement> get options {
    List<DivElement> list = new List<DivElement>();
    list.add(option1Cb());
    return list;
  }
}
