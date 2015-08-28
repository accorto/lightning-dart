/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart.demo;

class GridSystem extends DemoFeature {

  GridSystem()
  : super("grid-system", "Grid System",
  sldsStatus: DemoFeature.SLDS_DEV_READY,
  devStatus: DemoFeature.STATUS_COMPLETE,
  hints: ["Used all over the place - see SLDS site for demo"],
  issues: [],
  plans: []);

  LComponent get content {
    return null;
  }
  String get source {
    return '''
    ''';
  }

}
