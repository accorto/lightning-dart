/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart.demo;

class Themes extends DemoFeature {

  Themes() : super("themes", "Utility - Themes", sldsPath: "utilities/themes",
  sldsStatus: DemoFeature.SLDS_DEV_READY,
  devStatus: DemoFeature.STATUS_COMPLETE,
  hints: ["themes are available in all LComponents"],
  issues: [],
  plans: []);


  LComponent get content {
    CDiv div = new CDiv()
      ..classes.add(LMargin.C_HORIZONTAL__MEDIUM);
    div.add(new LBox()..text = "Regular Box");
    div.add(new LBox()..small = true ..text = "Small Box");
    div.add(new LBox()..xsmall = true ..text = "X Small Box");

    div.add(new LBox()..text = "Default Theme" ..themeDefault());
    div.add(new LBox()..text = "Shade Theme" ..themeShade());
    div.add(new LBox()..text = "Inverse Theme" ..themeInverse());
    div.add(new LBox()..text = "Alt Inverse Theme" ..themeAltInverse());
    div.add(new LBox()..text = "Success Theme" ..themeSuccess());
    div.add(new LBox()..text = "Warning Theme" ..themeWarning());
    div.add(new LBox()..text = "Error Theme" ..themeError());
    div.add(new LBox()..text = "Offline Theme" ..themeOffline());
    div.add(new LBox()..text = "Default Theme with Texture" ..themeDefault() ..themeTexture());
    div.add(new LBox()..text = "Shade Theme with Texture" ..themeShade() ..themeTexture());

    return div;
  }
  String get source {
    return '''
    CDiv div = new CDiv();
    div.add(new LBox()..text = "Regular Box");
    div.add(new LBox()..small = true ..text = "Small Box");
    div.add(new LBox()..xsmall = true ..text = "X Small Box");

    div.add(new LBox()..text = "Default Theme" ..themeDefault());
    div.add(new LBox()..text = "Shade Theme" ..themeShade());
    div.add(new LBox()..text = "Inverse Theme" ..themeInverse());
    div.add(new LBox()..text = "Alt Inverse Theme" ..themeAltInverse());
    div.add(new LBox()..text = "Success Theme" ..themeSuccess());
    div.add(new LBox()..text = "Warning Theme" ..themeWarning());
    div.add(new LBox()..text = "Error Theme" ..themeError());
    div.add(new LBox()..text = "Offline Theme" ..themeOffline());
    div.add(new LBox()..text = "Default Theme with Texture" ..themeDefault() ..themeTexture());
    div.add(new LBox()..text = "Shade Theme with Texture" ..themeShade() ..themeTexture());
    ''';
  }

}
