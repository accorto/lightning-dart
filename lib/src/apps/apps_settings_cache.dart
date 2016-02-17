/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/**
 * Settings Cache Tab
 */
class AppsSettingsCache
    extends LTabContent {

  static const String ID = "cache";

  DivElement _buttonDiv = new DivElement()
    ..classes.add(LMargin.C_AROUND__LARGE);

  /// Cache
  AppsSettingsCache() : super(ID, appsSettingsCacheLabel()) {
    LButton buttonDetails = new LButton.neutralIcon("details", "Details",
        new LIconUtility(LIconUtility.CASES), iconLeft:true, idPrefix:ID)
      ..onClick.listen(onClickDetails);
    _buttonDiv.append(buttonDetails.element);
  }

  /// recreate / refresh
  void showingNow() {
    element.children.clear();
    LTable table = new LTable(ID);
    element.classes.add(LScrollable.C_SCROLLABLE__X);
    element.append(table.element);
    element.append(_buttonDiv);

    // Fk
    FkService fkService = FkService.instance;
    if (fkService == null) {
      table.addRowDataList([new Element.tag("strong")..text = "No FkService", null, null]);
    } else {
      table.addRowDataList([new Element.tag("strong")..text = "FkService", null, null]);

      table.addRowHdrDataList("Active Requests", [fkService._activeRequests.length, null]);
      table.addRowHdrDataList("Pending Requests", [fkService._pendingRequests.length, null]);
      table.addRowHdrDataList("Complete Tables", [fkService._tableComplete.length, null]);
      table.addRowHdrDataList("Entries", [fkService._map.length, null]);
    }
    //table.addRowHdrData("", "");
  } // showingNow

  /// Details
  void onClickDetails(Event evt) {
    showingNow();
    FkService fkService = FkService.instance;
    if (fkService == null)
      return;

    LTable table = new LTable("cacheDetail");
    element.classes.add(LScrollable.C_SCROLLABLE__X);
    element.append(table.element);

    table.addRowHdrDataList("Active Requests", [fkService._activeRequests.length, null]);
    for (FkServiceRequest req in fkService._activeRequests) {
      String info = null;
      if (req.completer != null) {
        info = "fk";
      }
      if (req.completerList != null) {
        if (info == null)
          info = "fkList";
        else
          info += "+List";
      }
      table.addRowDataList([req.trxNo, req.compareString, info]);
    }

    table.addRowHdrDataList("Pending Requests", [fkService._pendingRequests.length, null]);
    for (FkServiceRequest req in fkService._activeRequests) {
      table.addRowDataList([req.trxNo, req.compareString, null]);
    }

    table.addRowHdrDataList("Complete Tables", [fkService._tableComplete.length, null]);
    fkService._tableComplete.forEach((String name, List<DFK> list) {
      table.addRowDataList(["- ${name}", list.length, null]);
      for (DFK fk in list) {
        table.addRowDataList([null, fk.urv, fk.drv]);
      }
    });

  } // onClickDetails


  static String appsSettingsCacheLabel() => Intl.message("Cache", name: "appsSettingsCacheLabel");

} // AppsSettingsCache
