/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

/**
 * Testing Lightning Dart.
 *
 */
library lightning.test;

@TestOn("dartium")

import 'package:test/test.dart';
import 'package:lightning/lightning.dart';
import 'package:intl/intl.dart';

import '../web/demo.dart';
import '../web/exampleWorkspace.dart';

/**
 * Execute test:
 *  pub run test -p content-shell
 *  pub run test -p dartium -p safari -p chrome
 *
 * or eventually (fails at this point)
 * - pub global run test_runner
 * - run_tests
 *
 * https://travis-ci.org/accorto/lightning-dart
 */
void main() {

  // Components
  group('LightningDart Components', () {
    PageSimple  page;
    DemoPage demoPage;

    setUp(() async {
      await LightningDart.init();
      page = LightningDart.createPageSimple();
      demoPage = new DemoPage("demo", new LIconUtility(LIconUtility.DESKTOP), "Demo", null);
      page.add(demoPage);
    });

    test('Components Test', () {
      expect(page, isNotNull);
      expect(demoPage, isNotNull);
      expect(demoPage.element.children.length, equals(34), reason: "demo component count");
    });
  }); // Components

  // Workspace
  group('LightningWorkspace', () {
    PageSimple page;
    ObjectCtrl ctrl;

    setUp(() async {
      await LightningDart.init(); // client env
      WorkspaceData wbData = new WorkspaceData();
      ctrl = new ObjectCtrl(wbData);
      page = LightningDart.createPageSimple();
      page.element.classes.add(LGrid.C_WRAP);
      page.add(ctrl);
    }); // setUp

    test('Children Test', () {
      expect(page, isNotNull);
      expect(ctrl, isNotNull);
      expect(ctrl.element.children.length, equals(2));
    });
  }); // Workspace

  // Select/Lookups
  group('SelectInterface', () {
    List<DOption> options = new List<DOption>();
    setUp((){
      options.add(new DOption()..value="v1" ..label="d1");
      options.add(new DOption()..value="v2" ..label="d2");
      options.add(new DOption()..value="v3" ..label="d3");
      options.add(new DOption()..value="v4" ..label="d4");
    }); // setUp

    test('Select', (){
      LSelect select = new LSelect("test")
        ..required = true;
      select.dOptionList = options;
      expect(select.value, equals("v1"));
      expect(select.valueDisplay, equals("d1"));
      select.value = "v3";
      expect(select.value, equals("v3"));
      expect(select.valueDisplay, equals("d3"));
    });

    test('Lookup', (){
      LLookup select = new LLookup("test")
        ..required = true;
      select.dOptionList = options;
      expect(select.value, equals("v1"));
      expect(select.valueDisplay, equals("d1"));
      select.value = "v3";
      expect(select.value, equals("v3"));
      expect(select.valueDisplay, equals("d3"));
    });

    test('Picklist', (){
      LPicklist select = new LPicklist("test")
        ..required = true;
      select.dOptionList = options;
      expect(select.value, equals("v1"));
      expect(select.valueDisplay, equals("d1"));
      select.value = "v3";
      expect(select.value, equals("v3"));
      expect(select.valueDisplay, equals("d3"));
    });

  }); // SelectLookup


  group('DateTime', () {

    test('convert', (){
      DateTime now = new DateTime.now(); // local
      if (now.timeZoneName != "PST") {
        return; // cannot switch/set local timezone
      }
      expect(now.timeZoneName, equals("PST"),
          reason: "${now.toIso8601String()} ${now.timeZoneName} offset=${now.timeZoneOffset}");

      DateTime dtUtc = new DateTime.utc(2016, 3, 12, 9, 0, 0);
      expect(dtUtc.millisecondsSinceEpoch, equals(1457773200000),
          reason: "utc ${dtUtc.toIso8601String()} ${dtUtc.timeZoneName} offset=${dtUtc.timeZoneOffset}");

      DateTime dtLocal = new DateTime(2016, 3, 12, 9, 0, 0);
      expect(dtLocal.millisecondsSinceEpoch, equals(1457802000000),
          reason: "local ${dtLocal.toIso8601String()} ${dtLocal.timeZoneName} offset=${dtLocal.timeZoneOffset}");

      Duration diff = dtUtc.difference(dtLocal);
      expect(new Duration(hours: -8), equals(diff), reason: "diff std", verbose: true);


      DateTime dtUtc2 = new DateTime.utc(2016, 3, 13, 9, 0, 0);
      expect(dtUtc2.millisecondsSinceEpoch, equals(1457859600000),
          reason: "utc2 ${dtUtc2.toIso8601String()} ${dtUtc2.timeZoneName} offset=${dtUtc2.timeZoneOffset}");

      DateTime dtLocal2 = new DateTime(2016, 3, 13, 9, 0, 0);
      expect(dtLocal2.millisecondsSinceEpoch, equals(1457884800000),
          reason: "local2 ${dtLocal2.toIso8601String()} ${dtLocal2.timeZoneName} offset=${dtLocal2.timeZoneOffset}");

      Duration diff2 = dtUtc2.difference(dtLocal2);
      expect(diff2, equals(new Duration(hours: -7)), reason: "diff day", verbose: true);

      Duration diffUtc = dtUtc.difference(dtUtc2);
      expect(diffUtc, equals(new Duration(hours: -24)), reason: "diff utc", verbose: true);

      Duration diffLocal = dtLocal.difference(dtLocal2);
      expect(diffLocal, equals(new Duration(hours: -23)), reason: "diff local", verbose: true);


      DateTime midnight = new DateTime.utc(1970,1,1,0,0,0);
      expect(midnight.millisecondsSinceEpoch, equals(0), reason: "midnight");
      DateFormat usFormat = new DateFormat("h:mm a");
      expect(usFormat.format(midnight), equals("12:00 AM"), reason: "midnight US");

      DateTime noon = new DateTime.utc(1970,1,1,12,0,0);
      expect(noon.millisecondsSinceEpoch, equals(12*60*60*1000));
      expect(usFormat.format(noon), equals("12:00 PM"), reason: "noon US");

    });

  }); // DateTime


} // main
