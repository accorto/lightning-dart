/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

library lightning_dart.test;

//import 'package:lightning_dart/lightning_dart.dart';
import 'package:test/test.dart';

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
