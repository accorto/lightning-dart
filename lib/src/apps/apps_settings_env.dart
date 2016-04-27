/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/**
 * Settings Environment Tab
 */
class AppsSettingsEnvironment
    extends LTabContent {

  static const String ID = "env";

  LButton _geoBtn = new LButton.neutral("geo", appsSettingsEnvironmentGeo(), idPrefix: ID);

  /// Environment
  AppsSettingsEnvironment() : super(ID, appsSettingsEnvironmentLabel()) {
    _geoBtn.onClick.listen(onGeoClick);
  }

  // recreate - refresh
  void showingNow() {
    element.children.clear();
    LTable table = new LTable(ID);
    element.classes.add(LScrollable.C_SCROLLABLE__X);
    element.append(table.element);
    /*
    Element col = table.addColElement()
      ..style.maxWidth = "100px";
    col = table.addColElement()
      ..style.maxWidth = "100px";
    col = table.addColElement()
      ..style.maxWidth = "100px";
     */

    table.addRowHdrDataList("Version", [LightningDart.VERSION, LightningDart.devTimestamp]);

    // General
    table.addRowHdrDataList("Locale/Language", [ClientEnv.localeName, ClientEnv.language]);
    DateTime now = new DateTime.now();
    table.addRowHdrDataList("Time Zone Browser", [now.timeZoneName, now.timeZoneOffset.inMinutes]);
    if (ClientEnv.timeZone == null)
      table.addRowHdrDataList("TZ -", [TzRef.alias(now.timeZoneName), null]);
    else
      table.addRowHdrDataList("TZ selected", [ClientEnv.timeZone.id, null]);

    // service
    table.addRowHdrDataList("Start/Uptime", [ClientEnv.formatDateTime(Service.startTime), Service.upTime]);
    // ClientEnv.windowNo;

    _geoBtn.label = appsSettingsEnvironmentGeo();
    table.addRowHdrDataList("Geo Enabled", [Service.addGeo,  _geoBtn.element], colSpan:1);
    AnchorElement geoLink = null;
    String geoHref = CGeo.lastPosHref;
    if (geoHref != null) {
      geoLink = new AnchorElement(href: geoHref)
        ..text = "link"
        ..target = "_bkank";
    }
    table.addRowHdrDataList("Geo Position", [CGeo.lastPosInfo, geoLink]);
    table.addRowHdrDataList("Geo Error", [CGeo.lastErrorInfo], colSpan:2);

    table.addRowHdrDataList("Server Url", [Service.serverUrl], colSpan:2);
    // LightningCtrl.router.queryParams
    table.addRowHdrDataList("Client Id/Trx", [Service.clientId, Service.trxNo]);

    Screen scr = window.screen;
    table.addRowHdrDataList("Screen", ["w=${scr.width} h=${scr.height} d=${scr.pixelDepth}"], colSpan:2);
    table.addRowHdrDataList("Window", ["w=${window.innerWidth} h=${window.innerHeight}"], colSpan:2);
    Navigator nav = window.navigator;
    table.addRowHdrDataList("Agent", [nav.userAgent], colSpan:2);
    // table.addRowHdrData("version", nav.appVersion);
    table.addRowHdrDataList("Cookie", [nav.cookieEnabled, nav.doNotTrack == null ? "" : nav.doNotTrack]);
    table.addRowHdrDataList("Platform/Vendor", [nav.platform, nav.vendor]);

    table.addRowHdrDataList("Mobile | Phone",
        [ClientEnv.isMobileUserAgent,     ClientEnv.isPhone]);
    table.addRowHdrDataList("Edge/IE | IE11",
        [ClientEnv.isIE,                  ClientEnv.isIE11]);
    table.addRowHdrDataList("Chrome",
        [ClientEnv.isChrome,              ""]);
    table.addRowHdrDataList("Icon Image | Svg Direct",
        [Settings.getAsBool(Settings.ICON_IMAGE, defaultValue: SvgUtil.createIconImage()), SvgUtil.createIconImage()]);
    table.addRowHdrDataList("Iframe",
        [ClientEnv.inIFrame, "page=${window.pageXOffset}/${window.pageYOffset} scroll=${window.scrollX}/${window.scrollY}"]);
    table.addRowHdrDataList("Test Mode",
        [ClientEnv.testMode]);


    // -- Session
    table.addRowHdrData("", "");
    if (ClientEnv.session == null) {
      table.addRowDataList([new Element.tag("strong")..text = "Not Logged In", null, null]);
    } else {
      table.addRowDataList([new Element.tag("strong")..text = "Session",
        new Element.tag("strong")..text = "Value", null]);
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
          table.addRowHdrData(fi.name, value.toString(), colSpan: 2);
        }
      }
    }
    // -- Context
    table.addRowHdrData("", "");
    if (ClientEnv.ctx.isEmpty) {
      table.addRowDataList([new Element.tag("strong")..text = "No Context", null, null]);
    } else {
      table.addRowDataList([new Element.tag("strong")..text = "Context",
      new Element.tag("strong")..text = "Value", null]);
      List<String> keys = new List.from(ClientEnv.ctx.keys);
      keys.sort((String one, String two) {
        return one.compareTo(two);
      });
      for (String key in keys) {
        var value = ClientEnv.ctx[key];
        String stringValue = value == null ? "null" : value.toString();
        table.addRowHdrData(key, stringValue, colSpan: 2);
      }
    }
  } // showingNow

  /// Get Geo Info
  void onGeoClick(MouseEvent env) {
    CGeo.get(null, retry: true);
    _geoBtn.label = "Requested - Switch Tabs to update";
  }

  static String appsSettingsEnvironmentLabel() => Intl.message("Environment", name: "appsSettingsEnvironmentLabel");
  static String appsSettingsEnvironmentGeo() => Intl.message("Update Geo Info", name: "appsSettingsEnvironmentGeo");

} // AppSettingsEnvironment
