// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// @dart = 2.8

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('debugInstrumentAction', () {
    DebugPrintCallback originalDebugPrintCallback;
    StringBuffer printBuffer;

    setUp(() {
      debugInstrumentationEnabled = true;
      printBuffer = StringBuffer();
      originalDebugPrintCallback = debugPrint;
      debugPrint = (String message, { int wrapWidth }) {
        printBuffer.writeln(message);
      };
    });

    tearDown(() {
      debugInstrumentationEnabled = false;
      debugPrint = originalDebugPrintCallback;
    });

    test('works with non-failing actions', () async {
      final int result = await debugInstrumentAction<int>('no-op', () async {
        debugPrint('action()');
        return 1;
      });
      expect(result, 1);
      expect(
        printBuffer.toString(),
        matches(RegExp('^action\\(\\)\nAction "no-op" took .+\$', multiLine: true)),
      );
    });

    test('returns failing future if action throws', () async {
      try {
        await debugInstrumentAction<void>('throws', () async {
          await Future<void>.delayed(Duration.zero);
          throw 'Error';
        });
        fail('Error expected but not thrown');
      } on String catch (error) {
        expect(error, 'Error');
        expect(printBuffer.toString(), matches(r'^Action "throws" took .+'));
      }
    });
  });
}
