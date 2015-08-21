/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart.demo;

class Pills extends DemoFeature {

  Pills() : super ("pills", "Pills", "");

  LComponent get content {
    CDiv div = new CDiv();

    div.add(new LPill.base("Pill Base", "pb", null,
        (MouseEvent e){print("Pill Base clicked");},
        (MouseEvent e){print("Pill Base Remove clicked");}));
    div.add(new LPill.unlink("Pill Unlink", "pu"));
    div.add(new LPill.icon("Pill Icon", "pi", null,
        (MouseEvent e){print("Pill Icon clicked");},
        new LIconStandard(LIconStandard.ACCOUNT),
        (MouseEvent e){print("Pill Icon Renove clicked");}));
    div.add(new LPill.image("Pill Image", "pic", null,
        (MouseEvent e){print("Pill Image clicked");},
        new LImage.srcXSmall("avatar1.jpg", "pic"),
        (MouseEvent e){print("Pill Image Remove clicked");}));

    return div;
  }

  String get source {
    return '''
    CDiv div = new CDiv();

    div.add(new LPill.base("Pill Base", "pb", null,
        (MouseEvent e){print("Pill Base clicked");},
        (MouseEvent e){print("Pill Base Remove clicked");}));
    div.add(new LPill.unlink("Pill Unlink", "pu"));
    div.add(new LPill.icon("Pill Icon", "pi", null,
        (MouseEvent e){print("Pill Icon clicked");},
        new LIconStandard(LIconStandard.ACCOUNT),
        (MouseEvent e){print("Pill Icon Renove clicked");}));
    div.add(new LPill.image("Pill Image", "pic", null,
        (MouseEvent e){print("Pill Image clicked");},
        new LImage.srcXSmall("avatar1.jpg", "pic"),
        (MouseEvent e){print("Pill Image Remove clicked");}));
    ''';
  }

}
