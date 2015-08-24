/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart.demo;

class Tooltips extends DemoFeature {

  Tooltips() : super ("tooltips", "Tooltips", "");

  LComponent get content {
    CDiv div = new CDiv();
    LTooltip pop = new LTooltip("Tooltip Content Test lines come here")
      ..nubbinRight = true;
    div.add(pop);

    div.appendHR();
    pop = new LTooltip(null)
      ..nubbinTop = true;
    pop.body
      ..appendText("Another Tooltip Some text comes here ")
      ..append(new AnchorElement(href: "#")..text = "Some Link")
      ..appendText(" Additional Text");
    div.add(pop);

    return div;
  }


  String get source {
    return '''
    ''';
  }
}
