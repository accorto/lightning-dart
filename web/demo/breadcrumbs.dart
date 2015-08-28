/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart.demo;

class Breadcrumbs extends DemoFeature {

  Breadcrumbs() : super ("breadcrumbs", "Breadcrumbs",
    sldsStatus: DemoFeature.SLDS_DEV_READY,
    devStatus: DemoFeature.STATUS_COMPLETE,
    hints: ["converted to upper case"],
    issues: ["css: some scaling/line break issues"],
    plans: []);

  LComponent get content {
    CDiv div = new CDiv();

    LBreadcrumb b1 = new LBreadcrumb();
    b1.setLinkText("Parent Entity A", null, 0);
    b1.setLinkText("Parent Record A", null, 1);
    b1.setLinkText("Child Entity B", null, 2);
    b1.setLinkText("Child Record B", null, 3);
    div.add(b1);

    div.appendHrSmall();
    LBreadcrumb b2 = new LBreadcrumb();
    b2.setLinkText("Parent Entity A", null, 0);
    b2.setLinkText("Parent Record A", null, 1);
    b2.setLinkText("Child Entity B", null, 2);
    b2.setLinkText("Child Record B", null, 3);
    b2.setLinkText("Parent Entity X", null, 0); // remove all kids
    div.add(b2);

    return div;
  }

  String get source {
    return '''
    CDiv div = new CDiv();
    LBreadcrumb b1 = new LBreadcrumb();
    b1.setLinkText("Parent Entity A", null, 0);
    b1.setLinkText("Parent Record A", null, 1);
    b1.setLinkText("Child Entity B", null, 2);
    b1.setLinkText("Child Record B", null, 3);
    div.add(b1);

    div.addHrSmall();
    LBreadcrumb b2 = new LBreadcrumb();
    b2.setLinkText("Parent Entity A", null, 0);
    b2.setLinkText("Parent Record A", null, 1);
    b2.setLinkText("Child Entity B", null, 2);
    b2.setLinkText("Child Record B", null, 3);
    b2.setLinkText("Parent Entity X", null, 0); // remove all kids
    div.add(b2);
    ''';
  }

}
