/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart.demo;

class Spinners extends DemoFeature {

  Spinners() : super ("spinners", "Spinners",
  sldsStatus: DemoFeature.SLDS_PROTOTYPE,
  devStatus: DemoFeature.STATUS_COMPLETE,
  hints: ["Use Standalone or set busy or loading in any component"],
  issues: [],
  plans: []);

  LComponent get content {
    CDiv div = new CDiv()
      ..classes.add(LMargin.C_HORIZONTAL__MEDIUM);

    LButton btn1 = new LButton.neutral("bbusy", "Click me: Busy for 10 seconds");
    btn1.onClick.listen((MouseEvent evt){
      div.busy = true;
      new Timer(new Duration(seconds: 10), (){
        div.busy = false;
      });
    });
    div.add(btn1);

    LButton btn2 = new LButton.neutral("bload", "Click me: Loading for 10 seconds");
    btn2.onClick.listen((MouseEvent evt){
      div.loading = true;
      new Timer(new Duration(seconds: 10), (){
        div.loading = false;
      });
    });
    div.add(btn2);

    return div;
  }

  String get source {
    return '''
    CDiv div = new CDiv();

    LButton btn1 = new LButton.neutral("bbusy", "Click me: Busy for 10 seconds");
    btn1.onClick.listen((MouseEvent evt){
      div.busy = true;
      new Timer(new Duration(seconds: 10), (){
        div.busy = false;
      });
    });
    div.add(btn1);

    LButton btn2 = new LButton.neutral("bload", "Click me: Loading for 10 seconds");
    btn2.onClick.listen((MouseEvent evt){
      div.loading = true;
      new Timer(new Duration(seconds: 10), (){
        div.loading = false;
      });
    });
    div.add(btn2);
    ''';
  }


}
