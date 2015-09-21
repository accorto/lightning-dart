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


/**
 * Execute test:
 * - pub global run test_runner
 * - run_tests
 *
 */
void main() {
  group('A group of tests', () {
    Object awesome;

    setUp(() {
      awesome = new Object();
    });

    test('First Test', () {
      expect(awesome.toString(), isNotEmpty);
    });
  });
}
