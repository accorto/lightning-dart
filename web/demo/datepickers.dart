/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart.demo;

class Datepickers extends DemoFeature {

  Datepickers()
  : super("datepickers", "Datepickers",
  sldsStatus: DemoFeature.SLDS_PROTOTYPE,
  devStatus: DemoFeature.STATUS_NIY,
  hints: [],
  issues: [],
  plans: []);

  LComponent get content {
    CDiv div = new CDiv();
    return div;
  }
  String get source {
    return '''
    ''';
  }

}
