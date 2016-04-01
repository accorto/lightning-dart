/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart.demo;

class Menus extends DemoFeature {

  Menus() : super("menus", "Menus/Pick",
  sldsStatus: DemoFeature.SLDS_DEV_READY,
  devStatus: DemoFeature.STATUS_COMPLETE,
  hints: ["same api as select, lookup and dropdown"],
  issues: [],
  plans: ["Picklist Multi Select"]);

  bool openOnClickOnly = false;

  LComponent get content {
    CDiv div = new CDiv();

    // Dropdowns
    CDiv divDD = new CDiv()
      ..classes.add(LMargin.C_HORIZONTAL__MEDIUM);
    divDD.appendText("Dropdown: ");
    div.add(divDD);

    LDropdown dd = new LDropdown.action(idPrefix: "dd0")
      ..left = true
      ..openOnClickOnly = openOnClickOnly;
    dd.dropdown.addDropdownItem(LDropdownItem.create(label: "Menu Item One"));
    dd.dropdown.addDropdownItem(LDropdownItem.create(label: "Action Two"));
    dd.dropdown.addDropdownItem(LDropdownItem.create(label: "Action Three"));
    dd.dropdown.addDropdownItem(LDropdownItem.create(label: "Action Four")..divider = true);
    divDD.add(dd);

    dd = new LDropdown.settings(idPrefix: "dd1")
      ..left = true
      ..openOnClickOnly = openOnClickOnly;
    dd.dropdown.addDropdownItem(LDropdownItem.create(label: "Menu Item One"));
    dd.dropdown.addDropdownItem(LDropdownItem.create(label: "Setting Two"));
    dd.dropdown.addDropdownItem(LDropdownItem.create(label: "Setting Three"));
    dd.dropdown.addDropdownItem(LDropdownItem.create(label: "Setting Four")..divider = true);
    divDD.add(dd);

    dd = new LDropdown.settings(idPrefix: "dd2")
      ..openOnClickOnly = openOnClickOnly;
    dd.headingLabel = "List View Controls";
    dd.dropdown.nubbinTop = true;
    dd.dropdown.addDropdownItem(LDropdownItem.create(label: "Rename...")..disabled = true);
    dd.dropdown.addDropdownItem(LDropdownItem.create(label: "Share...")..disabled = true);
    dd.dropdown.addDropdownItem(LDropdownItem.create(label: "Save As..."));
    dd.dropdown.addDropdownItem(LDropdownItem.create(label: "Discard Changes to List"));
    divDD.add(dd);

    dd = new LDropdown.selectIcon(idPrefix: "dd3")
      ..openOnClickOnly = openOnClickOnly;
    dd.headingLabel = "Display As";
    dd.dropdown.addDropdownItem(LDropdownItem.create(
        label: "Table", value: "table", icon: new LIconUtility(LIconUtility.TABLE)));
    dd.dropdown.addDropdownItem(LDropdownItem.create(
        label: "Cards", value: "cards", icon: new LIconUtility(LIconUtility.KANBAN)));
    dd.dropdown.addDropdownItem(LDropdownItem.create(
        label: "Compact List", value: "compact", icon: new LIconUtility(LIconUtility.SIDE_LIST)));
    dd.value = "table"; // toggles also selectMode
    divDD.add(dd);


    // Pick List
    div.appendHR();
    LForm form = new LForm.stacked("tf")
      ..classes.add(LMargin.C_HORIZONTAL__MEDIUM);
    LPicklist pl1 = new LPicklist("pl1");
    pl1.label = "Picklist 1";
    pl1.listItemList = generateListItems(10, iconLeft: true);
    form.addEditor(pl1);
    pl1.value = "item5";

    div.add(form);
    div.appendHR();

    List<DOption> options = new List<DOption>()
      ..add(new DOption()..value = "o1" ..label = "Option 1" ..iconImage = "utility|bucket")
      ..add(new DOption()..value = "o2" ..label = "Option 2" ..isSelected = true ..iconImage = "utility|crossfilter")
      ..add(new DOption()..value = "o3" ..label = "Option 3" ..isSelected = true ..iconImage = "utility|frozen");
    LPicklistMulti multi = new LPicklistMulti()
      ..classes.add(LMargin.C_HORIZONTAL__MEDIUM)
      ..label = "Choices"
      ..options = options;

    div.add(multi);

    return div;
  }

  String get source {
    return '''
    CDiv divDD = new CDiv()
      ..classes.add(LMargin.C_HORIZONTAL__MEDIUM);
    divDD.appendText("Dropdown: ");
    div.add(divDD);

    LDropdown dd = new LDropdown.action(idPrefix: "dd0")
      ..left = true
      ..openOnClickOnly = openOnClickOnly;
    dd.dropdown.addDropdownItem(LDropdownItem.create(label: "Menu Item One"));
    dd.dropdown.addDropdownItem(LDropdownItem.create(label: "Action Two"));
    dd.dropdown.addDropdownItem(LDropdownItem.create(label: "Action Three"));
    dd.dropdown.addDropdownItem(LDropdownItem.create(label: "Action Four")..divider = true);
    divDD.add(dd);

    dd = new LDropdown.settings(idPrefix: "dd1")
      ..left = true
      ..openOnClickOnly = openOnClickOnly;
    dd.dropdown.addDropdownItem(LDropdownItem.create(label: "Menu Item One"));
    dd.dropdown.addDropdownItem(LDropdownItem.create(label: "Setting Two"));
    dd.dropdown.addDropdownItem(LDropdownItem.create(label: "Setting Three"));
    dd.dropdown.addDropdownItem(LDropdownItem.create(label: "Setting Four")..divider = true);
    divDD.add(dd);

    dd = new LDropdown.settings(idPrefix: "dd2")
      ..openOnClickOnly = openOnClickOnly;
    dd.headingLabel = "List View Controls";
    dd.dropdown.nubbinTop = true;
    dd.dropdown.addDropdownItem(LDropdownItem.create(label: "Rename...")..disabled = true);
    dd.dropdown.addDropdownItem(LDropdownItem.create(label: "Share...")..disabled = true);
    dd.dropdown.addDropdownItem(LDropdownItem.create(label: "Save As..."));
    dd.dropdown.addDropdownItem(LDropdownItem.create(label: "Discard Changes to List"));
    divDD.add(dd);

    dd = new LDropdown.selectIcon(idPrefix: "dd3")
      ..openOnClickOnly = openOnClickOnly;
    dd.headingLabel = "Display As";
    dd.dropdown.addDropdownItem(LDropdownItem.create(
        label: "Table", value: "table", icon: new LIconUtility(LIconUtility.TABLE)));
    dd.dropdown.addDropdownItem(LDropdownItem.create(
        label: "Cards", value: "cards", icon: new LIconUtility(LIconUtility.KANBAN)));
    dd.dropdown.addDropdownItem(LDropdownItem.create(
        label: "Compact List", value: "compact", icon: new LIconUtility(LIconUtility.SIDE_LIST)));
    dd.value = "table"; // toggles also selectMode
    divDD.add(dd);

    // Pick List
    div.appendHR();
    LForm form = new LForm.stacked("tf")
      ..classes.add(LMargin.C_HORIZONTAL__MEDIUM);
    LPicklist pl1 = new LPicklist("pl1");
    pl1.label = "Picklist 1";
    pl1.listItemList = generateListItems(10, iconLeft: true);
    form.addEditor(pl1);
    pl1.value = "item5";
    div.add(form);
    div.appendHR();

    List<DOption> options = new List<DOption>()
      ..add(new DOption()..value = "o1" ..label = "Option 1" ..iconImage = "utility|bucket")
      ..add(new DOption()..value = "o2" ..label = "Option 2" ..isSelected = true ..iconImage = "utility|crossfilter")
      ..add(new DOption()..value = "o3" ..label = "Option 3" ..isSelected = true ..iconImage = "utility|frozen");
    LPicklistMulti multi = new LPicklistMulti()
      ..classes.add(LMargin.C_HORIZONTAL__MEDIUM)
      ..label = "Choices"
      ..options = options;
    div.add(multi);




    ''';
  }

  EditorI optionOpenOnClickOnly() {
    LCheckbox cb = new LCheckbox("co", idPrefix: id)
      ..label = "Dropdown open on click only";
    cb.input.onClick.listen((MouseEvent evt){
      openOnClickOnly = cb.input.checked;
      optionChanged();
    });
    return cb;
  }

  List<EditorI> get options {
    return [optionOpenOnClickOnly()];
  }

}
