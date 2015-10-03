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

import '../web/demo.dart';

/**
 * Execute test:
 *  pub run test -p dartium -p cartium -p content-shell
 *
 * or
 * - pub global run test_runner
 * - run_tests
 *
 */
void main() {
  group('LightningDart Components', () {
    PageSimple  page;
    DemoPage demoPage;

    setUp(() async {
      await LightningDart.init();
      page = LightningDart.createPageSimple();
      demoPage = new DemoPage("demo", new LIconUtility(LIconUtility.DESKTOP), "Demo");
      page.add(demoPage);
    });

    test('First Test', () {
      expect(page, isNotNull);
      expect(demoPage, isNotNull);
      expect(demoPage.element.children.length, equals(31));
    });
  });
}
