/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart.demo;

class Popovers extends DemoFeature {

  Popovers() : super ("popovers", "Popovers", "");

  LComponent get content {
    CDiv div = new CDiv();
    LPopover pop = new LPopover("Popover Heading", "Popover Content Test lines come here")
      ..nubbinRight = true;
    div.add(pop);

    div.appendHR();
    pop = new LPopover("Another Popover", null)
      ..nubbinTop = true;
    pop.body
      ..appendText("Some text comes here ")
      ..append(new AnchorElement(href: "#")..text = "Some Link")
      ..appendText(" Additional Text");
    div.add(pop);

    return div;
  }


  String get source {
    return '''
    CDiv div = new CDiv();
    LPopover pop = new LPopover("Popover Heading", "Popover Content Test lines come here")
      ..nubbinRight = true;
    div.add(pop);

    div.appendHR();
    pop = new LPopover("Another Popover", null)
      ..nubbinTop = true;
    pop.body
      ..appendText("Some text comes here ")
      ..append(new AnchorElement(href: "#")..text = "Some Link")
      ..appendText(" Additional Text");
    div.add(pop);
    ''';
  }
}
