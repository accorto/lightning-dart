/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart.demo;

class DockedComposers extends DemoFeature {

  DockedComposers()
      : super("docked-composer", "Docked Composer",
      sldsStatus: DemoFeature.SLDS_DEV_READY,
      devStatus: DemoFeature.STATUS_NIY,
      hints: [],
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

