/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart.demo;

class Icons extends DemoFeature {


  Icons() : super("icons", "Icons", "Usually used in buttons");

  LComponent get content {
    CDiv div = new CDiv();

    // div.add(new LIconSpan());

    return div;
  }

  String get source {
    return '''
    CDiv div = new CDiv();

    ''';
  }
}
