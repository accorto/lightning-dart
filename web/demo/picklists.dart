/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart.demo;

class Picklists extends DemoFeature {

  Picklists() : super("picklists", "Picklists", "");

  LComponent get content {
    LForm form = new LForm.stacked();

    LPicklist pl1 = new LPicklist("pl1");
    pl1.listItems = generateListItems(10, iconLeft: true);
    form.addEditor(pl1);


    return form;
  }

}
