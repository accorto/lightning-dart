/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart.demo;

class Buttons extends DemoFeature {

  Buttons() : super("buttons", "Buttons", "");

  LComponent get content {
    CDiv div = new CDiv();

    div.add(new LButton.base("b11", "base button"));
    div.add(new LButton.base("b12", "base disabled")..disabled = true);
    div.add(new LButton.base("b13", "base small")..small = true);

    div.appendHrSmall();
    div.add(new LButton.neutral("b21", "neutral button"));
    div.add(new LButton.neutral("b22", "default disabled")..disabled = true);
    div.add(new LButton.neutral("b23", "neutral small")..small = true);
    div.add(new LButton.neutralAnchor("b24", "neutral link"));
    div.add(new LButton.neutralAnchor("b25", "disabled link")..disabled = true);
    div.add(new LButton.neutralInput("b26", "neutral input"));
    div.add(new LButton.neutralInput("b27", "disabled input")..disabled = true);

    div.appendHrSmall();
    div.add(new LButton.brand("b31", "brand button"));
    div.add(new LButton.brand("b32", "brand disabled")..disabled = true);
    div.add(new LButton.brand("b33", "brand small")..small = true);
    div.add(new LButton.brandAnchor("b21", "brand link"));

    div.appendHrSmall(); // TODO Inverse Background
    div.add(new LButton.inverse("b41", "inverse button"));
    div.add(new LButton.inverse("b42", "inverse disabled")..disabled = true);
    div.add(new LButton.inverse("b43", "inverse small")..small = true);

    div.appendHrSmall();
    div.add(new LButton.neutralIcon("b51", "neutral icon",
      new LIconUtility(LIconUtility.DOWNLOAD)));
    div.add(new LButton.neutralIcon("b52", "icon neutral",
      new LIconUtility(LIconUtility.DOWNLOAD), iconLeft: true));
    div.add(new LButtonStateful("b53"));
    div.add(new LButtonIconStateful("b53", "stateful icon",
      new LIconUtility(LIconUtility.LIKE)));

    div.append(new LButton.neutralIcon("b58", "hint icon",
      new LIconUtility(LIconUtility.DOWNLOAD)).hint()); // TODO hint container

    div.appendHrSmall();
    div.add(new LButton.iconBare("b61",
      new LIconUtility(LIconUtility.SETTINGS), "bare"));
    div.add(new LButton.iconContainer("b62",
      new LIconUtility(LIconUtility.SETTINGS), "container"));
    div.add(new LButton.iconBorder("b63",
      new LIconUtility(LIconUtility.SETTINGS), "border"));
    div.add(new LButton.iconBorderFilled("b64",
      new LIconUtility(LIconUtility.SETTINGS), "border filled"));
    div.add(new LButton.more("b65", null,
      new LIconUtility(LIconUtility.SETTINGS), "more"));
    div.add(new LButton.more("b66", "More",
      new LIconUtility(LIconUtility.SETTINGS), "more"));

    // TODO sizes

    return div;
  }

  String get source {
    return '''
    CDiv div = new CDiv();

    div.add(new LButton.base("b11", "base button"));
    div.add(new LButton.base("b12", "base disabled")..disabled = true);
    div.add(new LButton.base("b13", "base small")..small = true);

    div.addHrSmall();
    div.add(new LButton.neutral("b21", "neutral button"));
    div.add(new LButton.neutral("b22", "default disabled")..disabled = true);
    div.add(new LButton.neutral("b23", "neutral small")..small = true);
    div.add(new LButton.neutralAnchor("b24", "neutral link"));
    div.add(new LButton.neutralAnchor("b25", "disabled link")..disabled = true);
    div.add(new LButton.neutralInput("b26", "neutral input"));
    div.add(new LButton.neutralInput("b27", "disabled input")..disabled = true);

    div.addHrSmall();
    div.add(new LButton.brand("b31", "brand button"));
    div.add(new LButton.brand("b32", "brand disabled")..disabled = true);
    div.add(new LButton.brand("b33", "brand small")..small = true);
    div.add(new LButton.brandAnchor("b21", "brand link"));

    div.addHrSmall(); // TODO Inverse Background
    div.add(new LButton.inverse("b41", "inverse button"));
    div.add(new LButton.inverse("b42", "inverse disabled")..disabled = true);
    div.add(new LButton.inverse("b43", "inverse small")..small = true);

    div.addHrSmall();
    div.add(new LButton.neutralIcon("b51", "neutral icon",
      new LIconUtility("download")));
    div.add(new LButton.neutralIcon("b52", "icon neutral",
      new LIconUtility("download"), iconLeft: true));
    div.add(new LButtonStateful("b53"));
    div.add(new LButtonIconStateful("b53", "stateful icon",
      new LIconUtility("like")));

    div.append(new LButton.neutralIcon("b58", "hint icon",
      new LIconUtility("download")).hint()); // TODO hint container

    div.addHrSmall();
    div.add(new LButton.iconBare("b61",
      new LIconUtility("settings"), "bare"));
    div.add(new LButton.iconContainer("b62",
      new LIconUtility("settings"), "container"));
    div.add(new LButton.iconBorder("b63",
      new LIconUtility("settings"), "border"));
    div.add(new LButton.iconBorderFilled("b64",
      new LIconUtility("settings"), "border filled"));
    div.add(new LButton.more("b65", null,
      new LIconUtility("settings"), "more"));
    div.add(new LButton.more("b66", "More",
      new LIconUtility("settings"), "more"));

    ''';
  }

}
