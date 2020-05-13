// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
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