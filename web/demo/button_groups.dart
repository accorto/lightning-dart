/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart.demo;

class ButtonGroups extends DemoFeature {

  ButtonGroups() : super("button-groups", "Button Groups", "You define the size, the remainder goes into a dropdown list");

  LComponent get content {
    CDiv div = new CDiv();

    LButtonGroup bg = new LButtonGroup();
    bg.add(new LButton.neutral("refresh", "Refresh"));
    bg.add(new LButton.neutral("edit", "Edit"));
    bg.add(new LButton.neutral("delete", "Delete"));
    bg.add(new LButton.neutral("save", "Save"));
    div.add(bg);

    div.appendHrSmall();
    bg = new LButtonGroup();
    bg.add(new LButton.neutral("refresh", "Refresh"));
    bg.add(new LButton.neutral("edit", "Edit"));
    bg.add(new LButton.neutral("delete", "Delete"));
    bg.add(new LButton.neutral("save", "Save"));
    bg.layout(2); // show just two
    div.add(bg);

    div.appendHrSmall();
    bg = new LButtonGroup();
    bg.add(new LButton.neutralIcon("refresh", "Refresh", new LIconUtility(LIconUtility.REFRESH), iconLeft:true));
    bg.add(new LButton.neutralIcon("edit", "Edit", new LIconUtility(LIconUtility.EDIT), iconLeft:true));
    bg.add(new LButton.neutralIcon("delete", "Delete", new LIconUtility(LIconUtility.DELETE), iconLeft:true));
    bg.add(new LButton.neutralIcon("save", "Save", new LIconUtility(LIconAction.CHECK), iconLeft:true));
    bg.layout(2); // show just two
    bg.layout(0); // show all
    div.add(bg);

    div.appendHrSmall();
    bg = new LButtonGroup();
    bg.add(new LButton.neutralIcon("refresh", "Refresh", new LIconUtility(LIconUtility.REFRESH), iconLeft:true));
    bg.add(new LButton.neutralIcon("edit", "Edit", new LIconUtility(LIconUtility.EDIT), iconLeft:true));
    bg.add(new LButton.neutralIcon("delete", "Delete", new LIconUtility(LIconUtility.DELETE), iconLeft:true));
    bg.add(new LButton.neutralIcon("save", "Save", new LIconUtility(LIconAction.CHECK), iconLeft:true));
    bg.layout(2); // show just two
    div.add(bg);

    return div;
  }

  String get source {
    return '''
    ''';
  }

}
