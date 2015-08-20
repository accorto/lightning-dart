/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart.demo;

class Dropdowns extends DemoFeature {

  Dropdowns() : super("dropdowns", "Dropdowns", null);

  LComponent get content {
    CDiv div = new CDiv();

    div.appendText("Hover:");
    LDropdown dd = new LDropdown.settings("dd1")
      ..left = true;
    dd.dropdown.addItem(new LDropdownItem(label: "Menu Item One"));
    dd.dropdown.addItem(new LDropdownItem(label: "Menu Item Two"));
    dd.dropdown.addItem(new LDropdownItem(label: "Menu Item Three"));
    dd.dropdown.addItem(new LDropdownItem(label: "Menu Item Four")..divider = true);
    div.add(dd);

    dd = new LDropdown.settings("dd2");
    dd.headingLabel = "List View Controls";
    dd.dropdown.nubbinTop = true;
    dd.dropdown.addItem(new LDropdownItem(label: "Rename...")..disabled = true);
    dd.dropdown.addItem(new LDropdownItem(label: "Share...")..disabled = true);
    dd.dropdown.addItem(new LDropdownItem(label: "Save As..."));
    dd.dropdown.addItem(new LDropdownItem(label: "Discard Changes to List"));
    div.add(dd);

    dd = new LDropdown.selectIcon("dd3");
    dd.headingLabel = "Display As";
    dd.dropdown.addItem(new LDropdownItem(label: "Table", value: "table",
      icon: new LIconUtility(LIconUtility.TABLE)));
    dd.dropdown.addItem(new LDropdownItem(label: "Cards", value: "cards",
      icon: new LIconUtility(LIconUtility.KANBAN)));
    dd.dropdown.addItem(new LDropdownItem(label: "Compact List", value: "compact",
      icon: new LIconUtility(LIconUtility.SIDE_LIST)));
    dd.value = "table"; // toggles also selectMode
    div.add(dd);

    // TODO Search after Lookup!
    // Action Overflow - see ButtonGroup
    // Search Overflow

    return div;
  }


  String get source {
    return '''
    ''';
  }

}
