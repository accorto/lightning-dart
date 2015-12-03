/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/**
 * Apps Settings
 */
class AppsSettings
    extends AppsPage {

  static const String ID = "setting";

  DivElement get element => _tab.element;

  LTab _tab = new LTab(idPrefix: ID);
  AppSettingsTab _tabSettings = new AppSettingsTab();
  AppSettingsEnvironment _tabEnvironment = new AppSettingsEnvironment();
  AppSettingsMessages _tabMessages = new AppSettingsMessages();


  /// Settings
  AppsSettings() : super (ID, ID,
      new LIconUtility(LIconUtility.SETUP),
      appsSettingsLabel(), appsSettingsLabel()) {

    _tab.addTabContent(_tabSettings);
    _tab.addTabContent(_tabMessages);
    _tab.addTabContent(_tabEnvironment);
  } // AppsSettings

  /// refresh tabs
  void showingNow() {
    if (_tabSettings.active)
      _tabSettings.showingNow();
    if (_tabMessages.active)
      _tabMessages.showingNow();
    if (_tabEnvironment.active)
      _tabEnvironment.showingNow();
  }


  /// Translate
  static String appsSettingsLabel() => Intl.message("Settings", name: "appsSettingsLabel");

} // AppsSettings


/**
 * Environment Tab
 */
class AppSettingsEnvironment extends LTabContent {

  static const String ID = "env";

  LButton _geoBtn = new LButton.neutral("geo", appsStatusEnvironmentGeo(), idPrefix: ID);

  /// Environment
  AppSettingsEnvironment() : super(ID, appsStatusEnvironmentLabel()) {
    _geoBtn.onClick.listen(onGeoClick);
  }

  // recreate
  void showingNow() {
    element.children.clear();
    LTable table = new LTable(ID);
    element.classes.add(LScrollable.C_SCROLLABLE__X);
    element.append(table.element);

    // General
    table.addRowHdrData("Locale", ClientEnv.localeName);
    table.addRowHdrData("Language", ClientEnv.language);
    DateTime now = new DateTime.now();
    table.addRowHdrData("Time Zone Browser", now.timeZoneName);
    table.addRowHdrData("Time Zone Offset (min)", now.timeZoneOffset.inMinutes);
    if (ClientEnv.timeZone == null)
      table.addRowHdrData("TZ -", TzRef.alias(now.timeZoneName));
    else
      table.addRowHdrData("TZ selected", ClientEnv.timeZone.id);

    // service
    table.addRowHdrData("Start", ClientEnv.formatDateTime(Service.startTime));
    table.addRowHdrData("Uptime", Service.upTime);

    table.addRowHdrData("Geo Enabled", Service.addGeo);
    table.addRowHdrData("Geo Position", CGeo.lastPosInfo);
    table.addRowHdrData("Geo Error", CGeo.lastErrorInfo);
    _geoBtn.label = appsStatusEnvironmentGeo();
    table.addRowHdrData("Geo Request", _geoBtn.element);

    table.addRowHdrData("Server Url", Service.serverUrl);
    // LightningCtrl.router.queryParams
    table.addRowHdrData("Client Id", Service.clientId);
    table.addRowHdrData("Client Trx", Service.trxNo);

    table.addRowHdrData("Dev Mode", Service.devMode);
    table.addRowHdrData("Version ${LightningDart.VERSION}", LightningDart.devTimestamp);

    Screen scr = window.screen;
    table.addRowHdrData("screen", "w=${scr.width} h=${scr.height} d=${scr.pixelDepth}");
    table.addRowHdrData("window", "w=${window.innerWidth} h=${window.innerHeight}");
    Navigator nav = window.navigator;
    table.addRowHdrData("agent", nav.userAgent);
    // table.addRowHdrData("version", nav.appVersion);
    table.addRowHdrData("cookie", "${nav.cookieEnabled} ${nav.doNotTrack == null ? "" : nav.doNotTrack}");
    table.addRowHdrData("platform", nav.platform);

    // Session
    table.addRowHdrData("", "");
    if (ClientEnv.session == null) {
      table.addRowDataList([new Element.tag("strong")..text = "Not Logged In", ""]);
    } else {
      table.addRowDataList([new Element.tag("strong")..text = "Session",
        new Element.tag("strong")..text = "Value"]);
      List<FieldInfo> fiList = new List<FieldInfo>.from(ClientEnv.session.info_.fieldInfo.values);
      fiList.sort((FieldInfo one, FieldInfo two){
        return one.name.compareTo(two.name);
      });
      for (FieldInfo fi in fiList) {
        if (fi.name == "context")
          continue;
        var value = ClientEnv.session.getFieldOrNull(fi.tagNumber);
        if (value != null) {
          if (ClientEnv.sessionConfidential.contains(fi.name))
            value = "-#${value.toString().length}-";
          table.addRowHdrData(fi.name, value.toString());
        }
      }
    }
    // Context
    table.addRowHdrData("", "");
    if (ClientEnv.ctx.isEmpty) {
      table.addRowDataList([new Element.tag("strong")..text = "No Context", ""]);
    } else {
      table.addRowDataList([new Element.tag("strong")..text = "Context",
        new Element.tag("strong")..text = "Value"]);
      List<String> keys = new List.from(ClientEnv.ctx.keys);
      keys.sort((String one, String two) {
        return one.compareTo(two);
      });
      for (String key in keys) {
        var value = ClientEnv.ctx[key];
        String stringValue = value == null ? "null" : value.toString();
        table.addRowHdrData(key, stringValue);
      }
    }
  } // showingNow

  /// Get Geo Info
  void onGeoClick(MouseEvent env) {
    CGeo.get(null, retry: true);
    _geoBtn.label = "Requested - Switch Tabs to update";
  }

  static String appsStatusEnvironmentLabel() => Intl.message("Environment", name: "appsStatusEnvironmentLabel");
  static String appsStatusEnvironmentGeo() => Intl.message("Update Geo Info", name: "appsStatusEnvironmentGeo");

} // AppSettingsEnvironment


/**
 * Messages Tab
 */
class AppSettingsMessages extends LTabContent {

  static const String ID = "msg";

  LButton _clearBtn = new LButton.neutral("clear", "clear", idPrefix: ID);

  /// Messages
  AppSettingsMessages() : super(ID, appsStatusMessagesLabel()) {
    _clearBtn.classes.add(LMargin.C_HORIZONTAL__LARGE);
    _clearBtn.onClick.listen(onClearClick);
  }

  /// Recreate
  void showingNow() {
    element.children.clear();
    LTable table = new LTable(ID);
    element.classes.add(LScrollable.C_SCROLLABLE__X);
    element.append(table.element);
    // data
    for (StatusMessage sm in PageSimple.statusMessages.reversed) {
      LIcon icon = sm.icon;
      if (icon == null) {
        icon = LNotification.createDefaultIcon(sm.color, setIconColor:true);
      } else {
        icon.classes.add(LIcon.C_ICON_TEXT_DEFAULT);
      }
      icon.classes.add(LIcon.C_ICON__X_SMALL);
      table.addRowDataList([icon.element, sm.message, sm.detail, sm.dataDetail]);
    }
    // clear button
    if (PageSimple.statusMessages.isEmpty) {
      _clearBtn.label = appsStatusMessagesNone();
    } else {
      _clearBtn.label = "${appsStatusMessagesClear()} (${PageSimple.statusMessages.length})";
    }
    element.append(_clearBtn.element);
  } // showingNow

  /// on Clear clicked
  void onClearClick(MouseEvent evt) {
    PageSimple.statusMessages.clear();
    showingNow();
  }

  static String appsStatusMessagesLabel() => Intl.message("Messages", name: "appsStatusMessagesLabel");
  static String appsStatusMessagesClear() => Intl.message("Clear Messages", name: "appsStatusMessagesClear");
  static String appsStatusMessagesNone() => Intl.message("No Messages", name: "appsStatusMessagesNone");

} // AppSettingsMessages
