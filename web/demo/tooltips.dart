/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart.demo;

class Tooltips extends DemoFeature {

  Tooltips() : super ("tooltips", "Tooltips",
  sldsStatus: DemoFeature.SLDS_PROTOTYPE,
  devStatus: DemoFeature.STATUS_COMPLETE,
  hints: ["shows on hover or stays when trigger clicked"],
  issues: [],
  plans: ["move if it does not fit on screen"]);

  LComponent get content {
    CDiv div = new CDiv();
    LTooltip pop = new LTooltip()
      ..bodyText = "Tooltip Content Test lines come here"
      ..nubbinRight = true;
    div.add(pop);

    div.appendHR();
    pop = new LTooltip();
    pop.body
      ..appendText("Another Tooltip Some text comes here ")
      ..append(new AnchorElement(href: "#")..text = "Some Link")
      ..appendText(" Additional Text");
    LButton button = new LButton.neutral("btnA", "See Above");
    pop.showAbove(button); // shows button
    div.add(pop);

    pop = new LTooltip()
      ..bodyText = "Another Below Tooltip with some info";
    button = new LButton.neutral("btnB", "See Below");
    pop.showBelow(button); // shows button
    div.add(pop);

    pop = new LTooltip()
      ..bodyText = "Another Below Tooltip with some info";
    button = new LButton.neutral("btnR", "See Right");
    pop.showRight(button); // shows button
    div.add(pop);

    pop = new LTooltip()
      ..bodyText = "Another Below Tooltip with some info";
    button = new LButton.neutral("btnL", "See Left");
    pop.showLeft(button); // shows button
    div.add(pop);

    return div;
  }


  String get source {
    return '''
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
    ''';
  }

}
