/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart.demo;

class Modals extends DemoFeature {

  Modals()
  : super("modals", "Modals",
  sldsStatus: DemoFeature.SLDS_DEV_READY,
  devStatus: DemoFeature.STATUS_COMPLETE,
  hints: ["you can add html elements instead of simple text",
    "you can drag modals (grap header)",
    "Notifications display above Modals"],
  issues: [],
  plans: []);


  LComponent get content {
    CDiv div = new CDiv()
      ..classes.add(LMargin.C_HORIZONTAL__MEDIUM);
    LModal modal = new LModal("m", touch: optionTouch)
      ..setHeader("The Modal", tagLine: "You can drag me!",
          icon: new LIconStandard(LIconStandard.CAMPAIGN))
      ..addContentText("Notifications have higher z-index than Modals. Some Text to add - you can also add any components or elements")
      ..addFooterButtons();
    LButton trigger = new LButton.neutral("x", "Click to show Modal");
    trigger.onClick.listen((MouseEvent evt){
      modal.showInComponent(div);
    });
    div.add(trigger);

    // nested
    LModal modal2 = new LModal("m2", touch: optionTouch)
      ..helpHref = "https://support.accorto.com"
      ..setHeader("The Second Modal", tagLine: "You can drag me!",
          icon: new LIconUtility(LIconUtility.ADDUSER))
      ..addContentText("Some Text to add - you can also add any components or elements. There is a small and large modal.")
      ..addContentText("Buttons can be derived from AppsActions")
      ..addFooterButtons();
    LButton trigger2 = new LButton.neutral("x2", "Second Modal")
      ..classes.add(LMargin.C_TOP__MEDIUM);
    trigger2.onClick.listen((MouseEvent evt){
      modal2.showInComponent(div);
    });
    modal.add(trigger2);
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

  bool optionTouch = false;

  EditorI optionTouchCb() {
    LCheckbox cb = new LCheckbox("oTouch", idPrefix: id)
      ..label = "Touch";
    cb.input.onClick.listen((MouseEvent evt){
      optionTouch = cb.input.checked;
      optionChanged();
    });
    return cb;
  }

  List<EditorI> get options {
    List<EditorI> list = new List<EditorI>();
    list.add(optionTouchCb());
    return list;
  }

}
