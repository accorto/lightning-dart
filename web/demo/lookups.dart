/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart.demo;

class Lookups extends DemoFeature {

  Lookups() : super("lookups", "Lookups", "");


  LComponent get content {
    CDiv div = new CDiv();

    LLookup l1 = new LLookup.base("l1");
    l1.listItems = generateListItems(10);
    div.add(l1);

    return div;
  }

  String get source {
    return '''
    ''';
  }

}
