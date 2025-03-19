@TestOn('browser')
library;

import 'dart:async';
import 'dart:js_interop';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
import 'package:geolocator_web/src/utils.dart';
import 'package:web/web.dart' as web;

@JSExport()
class MockGeolocationPositionError {
  final int code;
  final String message;

  MockGeolocationPositionError({required this.code, required this.message});
}

typedef GeolocationPosition = web.GeolocationPosition;

void main() {
  test('toLocationPermission returns the correct LocationPermission', () {
    expect(toLocationPermission('granted'), LocationPermission.whileInUse);
    expect(toLocationPermission('prompt'), LocationPermission.denied);
    expect(toLocationPermission('denied'), LocationPermission.deniedForever);
    expect(() => toLocationPermission(''), throwsA(isA<ArgumentError>()));
  });

  test('convertPositionError returns the correct exception', () {
    web.GeolocationPositionError createError(int code) {
      return createJSInteropWrapper<MockGeolocationPositionError>(
              MockGeolocationPositionError(code: code, message: 'message'))
          as web.GeolocationPositionError;
    }

    expect(
        convertPositionError(createError(1)), isA<PermissionDeniedException>());

    expect(
        convertPositionError(createError(2)), isA<PositionUpdateException>());

    expect(convertPositionError(createError(3)), isA<TimeoutException>());

    expect(convertPositionError(createError(4)), isA<PlatformException>());
  });
}
