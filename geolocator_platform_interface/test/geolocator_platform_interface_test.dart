// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// TODO(mvanbeusekom): Remove once Mockito is migrated to null safety.
// @dart = 2.9
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
import 'package:geolocator_platform_interface/src/implementations/method_channel_geolocator.dart';
import 'package:mockito/mockito.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('$GeolocatorPlatform', () {
    test('$MethodChannelGeolocator is the default instance', () {
      expect(GeolocatorPlatform.instance, isA<MethodChannelGeolocator>());
    });

    test('Cannot be implemented with `implements`', () {
      expect(() {
        GeolocatorPlatform.instance = ImplementsGeolocatorPlatform();
      }, throwsNoSuchMethodError);
    });

    test('Can be extended', () {
      GeolocatorPlatform.instance = ExtendsGeolocatorPlatform();
    });

    test('Can be mocked with `implements`', () {
      final mock = MockGeolocatorPlatform();
      GeolocatorPlatform.instance = mock;
    });

    test(
        // ignore: lines_longer_than_80_chars
        'Default implementation of checkPermission should throw unimplemented error',
        () {
      // Arrange
      final geolocatorPlatform = ExtendsGeolocatorPlatform();

      // Act & Assert
      expect(
        geolocatorPlatform.checkPermission,
        throwsUnimplementedError,
      );
    });

    test(
        // ignore: lines_longer_than_80_chars
        'Default implementation of requestPermission should throw unimplemented error',
        () {
      // Arrange
      final geolocatorPlatform = ExtendsGeolocatorPlatform();

      // Act & Assert
      expect(
        geolocatorPlatform.requestPermission,
        throwsUnimplementedError,
      );
    });

    test(
        // ignore: lines_longer_than_80_chars
        'Default implementation of isLocationServiceDisabled should throw unimplemented error',
        () {
      // Arrange
      final geolocatorPlatform = ExtendsGeolocatorPlatform();

      // Act & Assert
      expect(
        geolocatorPlatform.isLocationServiceEnabled,
        throwsUnimplementedError,
      );
    });

    test(
        // ignore: lines_longer_than_80_chars
        'Default implementation of getCurrentPosition should throw unimplemented error',
        () {
      // Arrange
      final geolocatorPlatform = ExtendsGeolocatorPlatform();

      // Act & Assert
      expect(
        geolocatorPlatform.getCurrentPosition,
        throwsUnimplementedError,
      );
    });

    test(
        // ignore: lines_longer_than_80_chars
        'Default implementation of getLastKnownPosition should throw unimplemented error',
        () {
      // Arrange
      final geolocatorPlatform = ExtendsGeolocatorPlatform();

      // Act & Assert
      expect(
        geolocatorPlatform.getLastKnownPosition,
        throwsUnimplementedError,
      );
    });

    test(
        // ignore: lines_longer_than_80_chars
        'Default implementation of getPositionStream should throw unimplemented error',
        () {
      // Arrange
      final geolocatorPlatform = ExtendsGeolocatorPlatform();

      // Act & Assert
      expect(
        geolocatorPlatform.getPositionStream,
        throwsUnimplementedError,
      );
    });

    test(
        // ignore: lines_longer_than_80_chars
        'Default implementation of openAppSettings should throw unimplemented error',
        () {
      // Arrange
      final geolocatorPlatform = ExtendsGeolocatorPlatform();

      // Act & Assert
      expect(
        geolocatorPlatform.openAppSettings(),
        throwsUnimplementedError,
      );
    });

    test(
        // ignore: lines_longer_than_80_chars
        'Default implementation of openLocationSettings should throw unimplemented error',
        () {
      // Arrange
      final geolocatorPlatform = ExtendsGeolocatorPlatform();

      // Act & Assert
      expect(
        geolocatorPlatform.openLocationSettings(),
        throwsUnimplementedError,
      );
    });
  });

  group('distanceBetween: When requesting the distance between points', () {
    test('the distance should be zero between the same points', () {
      final latitude = 52.561270;
      final longitude = 5.639382;
      final geolocatorPlatform = ExtendsGeolocatorPlatform();

      final distance = geolocatorPlatform.distanceBetween(
          latitude, longitude, latitude, longitude);

      expect(distance, 0.0);
    });

    test('the distance should always be non negative', () {
      final startLatitude = 52.561270;
      final startLongitude = 5.639382;
      final endLatitude = 52.157296;
      final endLongitude = 5.3851278;
      final geolocatorPlatform = ExtendsGeolocatorPlatform();

      final firstDistance = geolocatorPlatform.distanceBetween(
          startLatitude, startLongitude, endLatitude, endLongitude);

      final reversedDistance = geolocatorPlatform.distanceBetween(
          endLatitude, endLongitude, startLatitude, startLongitude);

      expect(firstDistance, isNonNegative);
      expect(reversedDistance, isNonNegative);
    });

    test('the distance should be in range', () {
      final startLatitude = 52.1058731;
      final startLongitude = 5.9076873;
      final endLatitude = 52.157296;
      final endLongitude = 5.3851278;
      final expectedDistance = 36164.15150480236;
      final geolocatorPlatform = ExtendsGeolocatorPlatform();

      final distance = geolocatorPlatform.distanceBetween(
          startLatitude, startLongitude, endLatitude, endLongitude);

      expect(
        distance,
        expectedDistance,
      );
    });
  });

  group('bearingBetween: When requesting the bearing between points', () {
    test('the same points the bearing should be 0', () async {
      final latitude = 56.0;
      final longitude = 5.6;
      final geolocatorPlatform = ExtendsGeolocatorPlatform();

      final bearing = geolocatorPlatform.bearingBetween(
        latitude,
        longitude,
        latitude,
        longitude,
      );

      expect(bearing, 0.0);
    });

    test('the North pole to the Sounth pole bearing should be 180', () async {
      final startLatitude = 90.0;
      final startLongitude = 0.0;
      final endLatitude = -90.0;
      final endLongitude = 0.0;
      final geolocatorPlatform = ExtendsGeolocatorPlatform();

      final bearing = geolocatorPlatform.bearingBetween(
        startLatitude,
        startLongitude,
        endLatitude,
        endLongitude,
      );

      expect(bearing, 180.0);
    });

    test('the South pole to the North pole bearing should be 0', () async {
      final startLatitude = -90.0;
      final startLongitude = 0.0;
      final endLatitude = 90.0;
      final endLongitude = 0.0;
      final geolocatorPlatform = ExtendsGeolocatorPlatform();

      final bearing = geolocatorPlatform.bearingBetween(
        startLatitude,
        startLongitude,
        endLatitude,
        endLongitude,
      );

      expect(bearing, 0.0);
    });

    test('the West to the East bearing should be 90', () async {
      final startLatitude = 0.0;
      final startLongitude = 180.0;
      final endLatitude = 0.0;
      final endLongitude = -180.0;
      final geolocatorPlatform = ExtendsGeolocatorPlatform();

      final bearing = geolocatorPlatform.bearingBetween(
        startLatitude,
        startLongitude,
        endLatitude,
        endLongitude,
      );

      expect(bearing, 90.0);
    });

    test('the East to the West bearing should be -90', () async {
      final startLatitude = 0.0;
      final startLongitude = -180.0;
      final endLatitude = 0.0;
      final endLongitude = 180.0;
      final geolocatorPlatform = ExtendsGeolocatorPlatform();

      final bearing = geolocatorPlatform.bearingBetween(
        startLatitude,
        startLongitude,
        endLatitude,
        endLongitude,
      );

      expect(bearing, -90.0);
    });
  });
}

class ImplementsGeolocatorPlatform implements GeolocatorPlatform {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockGeolocatorPlatform extends Mock
    with
        // ignore: prefer_mixin
        MockPlatformInterfaceMixin
    implements
        GeolocatorPlatform {}

class ExtendsGeolocatorPlatform extends GeolocatorPlatform {}
