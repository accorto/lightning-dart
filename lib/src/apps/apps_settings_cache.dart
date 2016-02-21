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
      ..onClick.listen((Event evt){
        _showDetails = !_showDetails;
        showingNow();
      });
    _buttonDiv.append(buttonDetails.element);
  }
  bool _showDetails = false;

  /// recreate / refresh
  void showingNow() {
    element.children.clear();
    LTable table = new LTable(ID);
    element.classes.add(LScrollable.C_SCROLLABLE__X);
    element.append(table.element);
    element.append(_buttonDiv);

    _cacheUi(table);
    table.addRowHdrData("", "");
    _cacheKVM(table);
    table.addRowHdrData("", "");
    _cacheFk(table);
  } // showingNow

  /// UI
  void _cacheUi(LTable table) {
    UiService uiService = UiService.instance;
    if (uiService == null) {
      table.addRowDataList([new Element.tag("strong")..text = "No Ui Service", null, null]);
    } else {
      table.addRowDataList([new Element.tag("strong")..text = "Ui Service", null, null]);

      if (_showDetails) {
        table.addRowHdrDataList("Ui", [uiService._uiList.length, null]);
        for (UI ui in uiService._uiList) {
          table.addRowDataList([null, ui.name, ui.tableName]);
        }
        table.addRowHdrDataList("Table", [uiService._tableList.length, null]);
        for (DTable dtable in uiService._tableList) {
          table.addRowDataList([null, dtable.name, dtable.columnList.length]);
        }
      } else {
        table.addRowHdrDataList("Ui", [uiService._uiList.length, null]);
        table.addRowHdrDataList("Table", [uiService._tableList.length, null]);
      }
    }
  } // cacheUi

  /// FK
  void _cacheFk(LTable table) {
    FkService fkService = FkService.instance;
    if (fkService == null) {
      table.addRowDataList([new Element.tag("strong")..text = "No Fk Service", null, null]);
    } else {
      table.addRowDataList([new Element.tag("strong")..text = "Fk Service", null, null]);

      table.addRowHdrDataList("Active Requests", [fkService._activeRequests.length, null]);
      table.addRowHdrDataList("Pending Requests", [fkService._pendingRequests.length, null]);
      table.addRowHdrDataList("Tables", [fkService._tableFkMap.length, null]);

      if (_showDetails) {
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

        table.addRowHdrDataList("Tables", [fkService._tableFkMap.length, null]);
        fkService._tableFkMap.forEach((String name, List<DFK> list) {
          table.addRowDataList(["- ${name}", list.length,
            fkService.isComplete(name) ? "conplete" : "-"]);
          for (DFK fk in list) {
            table.addRowDataList([null, fk.urv, fk.drv]);
          }
        });
      }
    }
  } // cacheFk

  /// Key Value Maps
  void _cacheKVM(LTable table) {
    table.addRowDataList([new Element.tag("strong")..text = "Key Value Maps", null, null]);
    table.addRowHdrDataList(KeyValueMap.keyValueFill == null ? "Not Active" : "Active", [KeyValueMap.table_map.length]);

    if (_showDetails) {
      KeyValueMap.table_map.forEach((String name, KeyValueMap kvm){
        table.addRowDataList([name, kvm.length, kvm.isComplete]);
      });
    }
  } // cacheKVM


  static String appsSettingsCacheLabel() => Intl.message("Cache", name: "appsSettingsCacheLabel");

} // AppsSettingsCache
