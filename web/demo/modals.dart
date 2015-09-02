/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart.demo;

class Modals extends DemoFeature {

  Modals()
  : super("modals", "Modals",
  sldsStatus: DemoFeature.SLDS_PROTOTYPE,
  devStatus: DemoFeature.STATUS_COMPLETE,
  hints: ["you can add html elements instead of simple text"],
  issues: [],
  plans: []);


  LComponent get content {
    CDiv div = new CDiv();
    LModal modal = new LModal("m")
      ..setHeader("The Modal", tagLine: "You can drag me!")
      ..addContentText("Some Text to add - you can also add any components or elements")
      ..addFooterButtons();
    LButton trigger = new LButton.neutral("x", "Click to show Modal");
    trigger.onClick.listen((MouseEvent evt){
      modal.showInComponent(div);
    });
    div.add(trigger);
    return div;
  }

  String get source {
    return '''
    CDiv div = new CDiv();
    LModal modal = new LModal("m")
      ..setHeader("The Modal", tagLine: "You can drag me!")
      ..addContentText("Some Text to add - you can also add any components or elements")
      ..addFooterButtons();
    LButton trigger = new LButton.neutral("x", "Click to show Modal");
    trigger.onClick.listen((MouseEvent evt){
      modal.showInComponent(div);
    });
    div.add(trigger);
    ''';
  }

}
