// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator_platform_interface/geocoder_platform_interface.dart';
import 'package:geolocator_platform_interface/src/implementations/method_channel_geocoder.dart';
import 'package:mockito/mockito.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('$GeocoderPlatform', () {
    test('$MethodChannelGeocoder is the default instance', () {
      expect(GeocoderPlatform.instance, isA<MethodChannelGeocoder>());
    });

    test('Cannot be implemented with `implements`', () {
      expect(() {
        GeocoderPlatform.instance = ImplementsGeocoderPlatform();
      }, throwsNoSuchMethodError);
    });

    test('Can be extended', () {
      GeocoderPlatform.instance = ExtendsGeocoderPlatform();
    });

    test('Can be mocked with `implements`', () {
      final mock = MockGeocoderPlatform();
      GeocoderPlatform.instance = mock;
    });

    test(
      // ignore: lines_longer_than_80_chars
      'Default implementation of placemarkFromAddress should throw unimplemented error',
      (){
        // Arrange
        final geocoderPlatform = ExtendsGeocoderPlatform();

        // Act & Assert
        expect(
          () => geocoderPlatform.placemarkFromAddress('address'),
          throwsUnimplementedError,
        );
    });

    test(
      // ignore: lines_longer_than_80_chars
      'Default implementation of placemarkFromCoordinates should throw unimplemented error',
      (){
        // Arrange
        final geocoderPlatform = ExtendsGeocoderPlatform();

        // Act & Assert
        expect(
          () => geocoderPlatform.placemarkFromCoordinates(0, 0),
          throwsUnimplementedError,
        );
    });
  });
}

class ImplementsGeocoderPlatform implements GeocoderPlatform {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockGeocoderPlatform extends Mock
    // ignore: prefer_mixin
    with MockPlatformInterfaceMixin
    implements GeocoderPlatform {}

class ExtendsGeocoderPlatform extends GeocoderPlatform {}