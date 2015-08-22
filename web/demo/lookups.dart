/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart.demo;

class Lookups extends DemoFeature {

  Lookups() : super("lookups", "Lookups", "");


  LComponent get content {
    LForm form = new LForm.stacked();

    LLookup l1 = new LLookup.base("l1");
    l1.listItems = generateListItems(10, iconLeft: true);
    l1.value = "item5";
    form.addEditor(l1);

    LLookup l2 = new LLookup.single("l2");
    l2.listItems = generateListItems(10, iconLeft: true);
    form.addEditor(l2);

    LLookup l3 = new LLookup.multi("l3");
    l3.listItems = generateListItems(10, iconLeft: true);
    form.addEditor(l3);

    return form;
  }

  String get source {
    return '''
    ''';
  }

}
