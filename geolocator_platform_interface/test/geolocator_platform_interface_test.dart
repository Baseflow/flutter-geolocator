// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

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
      (){
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
      'Default implementation of isLocationServiceDisabled should throw unimplemented error',
      (){
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
      (){
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
      (){
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
      (){
        // Arrange
        final geolocatorPlatform = ExtendsGeolocatorPlatform();

        // Act & Assert
        expect(
          geolocatorPlatform.getPositionStream,
          throwsUnimplementedError,
        );
    });
  });
}

class ImplementsGeolocatorPlatform implements GeolocatorPlatform {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockGeolocatorPlatform extends Mock
    // ignore: prefer_mixin
    with MockPlatformInterfaceMixin
    implements GeolocatorPlatform {}

class ExtendsGeolocatorPlatform extends GeolocatorPlatform {}