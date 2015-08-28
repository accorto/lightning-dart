/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart.demo;

class Badges extends DemoFeature {

  Badges() : super("badges", "Badges",
    sldsStatus: DemoFeature.SLDS_DEV_READY,
    devStatus: DemoFeature.STATUS_COMPLETE,
    hints: ["converted to upper case"],
    issues: [],
    plans: []);

  LComponent get content {
    CDiv div = new CDiv();

    div.add(new LBadge("base badge"));
    div.add(new LBadge.def("default badge"));
    div.add(new LBadge.shade("shade badge"));
    div.add(new LBadge.inverse("inverse badge"));

    return div;
  }

  String get source {
    return '''
    CDiv div = new CDiv();
    div.add(new LBadge("base badge"));
    div.add(new LBadge.def("default badge"));
    div.add(new LBadge.shade("shade badge"));
    div.add(new LBadge.inverse("inverse badge"));
    ''';
  }

} // Badges
