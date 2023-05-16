import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:geoclue/geoclue.dart';
import 'package:geolocator_linux/geolocator_linux.dart';
import 'package:geolocator_linux/src/geolocator_gnome.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'geolocator_linux_test.mocks.dart';

@GenerateMocks([GeoClueClient, GeoClueManager])
void main() {
  setUpAll(
    () => PackageInfo.setMockInitialValues(
      appName: 'mockAppName',
      packageName: 'mockPackageName',
      version: 'mockVersion',
      buildNumber: 'mockBuildNumber',
      buildSignature: 'mockBuildSignature',
    ),
  );

  test('registerWith', () async {
    await GeolocatorLinux.registerWith(
        geoClueManager: MockGeoClueManager(),
        platformEnvironment: <String, String>{});
    expect(GeolocatorPlatform.instance, isA<GeolocatorLinux>());

    await GeolocatorLinux.registerWith(
        geoClueManager: MockGeoClueManager(),
        platformEnvironment: {'XDG_CURRENT_DESKTOP': 'ubuntu:unity'});
    expect(GeolocatorPlatform.instance, isA<GeolocatorLinux>());

    await GeolocatorLinux.registerWith(
        geoClueManager: MockGeoClueManager(),
        platformEnvironment: {'XDG_CURRENT_DESKTOP': 'ubuntu:GNOME'});
    expect(GeolocatorPlatform.instance, isA<GeolocatorGnome>());

    await GeolocatorLinux.registerWith(
        geoClueManager: MockGeoClueManager(),
        platformEnvironment: {
          'XDG_CURRENT_DESKTOP': 'ubuntu:KDE',
          'GNOME_SHELL_SESSION_MODE': 'ubuntu'
        });
    expect(GeolocatorPlatform.instance, isA<GeolocatorGnome>());
  });

  test('current position', () async {
    final client = MockGeoClueClient();
    when(client.location).thenReturn(dummyLocation);

    final manager = MockGeoClueManager();
    when(manager.getClient()).thenAnswer((_) async => client);

    final locator = GeolocatorLinux(manager);
    expect(await locator.getCurrentPosition(), equals(dummyPosition));

    LocationSettings locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 0,
        timeLimit: Duration(seconds: 10));
    expect(await locator.getCurrentPosition(locationSettings: locationSettings),
        equals(dummyPosition));
  });

  test('get last known position', () async {
    final client = MockGeoClueClient();
    when(client.location).thenReturn(dummyLocation);

    final manager = MockGeoClueManager();
    when(manager.getClient()).thenAnswer((_) async => client);

    final locator = GeolocatorLinux(manager);
    expect(await locator.getLastKnownPosition(), equals(dummyPosition));
  });

  test('location accuracy', () async {
    final manager = MockGeoClueManager();
    final locator = GeolocatorLinux(manager);

    when(manager.availableAccuracyLevel).thenReturn(GeoClueAccuracyLevel.none);
    expect(await locator.getLocationAccuracy(),
        equals(LocationAccuracyStatus.unknown));

    when(manager.availableAccuracyLevel).thenReturn(GeoClueAccuracyLevel.city);
    expect(await locator.getLocationAccuracy(),
        equals(LocationAccuracyStatus.reduced));

    when(manager.availableAccuracyLevel).thenReturn(GeoClueAccuracyLevel.exact);
    expect(await locator.getLocationAccuracy(),
        equals(LocationAccuracyStatus.precise));
  });

  test('position stream', () async {
    final locationUpdated = StreamController<GeoClueLocation>();

    final client = MockGeoClueClient();
    when(client.locationUpdated).thenAnswer((_) => locationUpdated.stream);

    final manager = MockGeoClueManager();
    when(manager.getClient()).thenAnswer((_) async => client);

    final locator = GeolocatorLinux(manager);
    locationUpdated.add(dummyLocation);
    await expectLater(locator.getPositionStream(), emits(dummyPosition));
  });

  test('position stream with location settings', () async {
    final locationUpdated = StreamController<GeoClueLocation>();

    final client = MockGeoClueClient();
    when(client.locationUpdated).thenAnswer((_) => locationUpdated.stream);

    final manager = MockGeoClueManager();
    when(manager.getClient()).thenAnswer((_) async => client);

    final locator = GeolocatorLinux(manager);
    locationUpdated.add(dummyLocation);

    LocationSettings locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 0,
        timeLimit: Duration(seconds: 10));

    await expectLater(
        locator.getPositionStream(locationSettings: locationSettings),
        emits(dummyPosition));
  });

  test('is location service enabled', () async {
    final manager = MockGeoClueManager();

    final locator = GeolocatorLinux(manager);
    await expectLater(await locator.isLocationServiceEnabled(), true);
  });

  test('check permission', () async {
    final manager = MockGeoClueManager();

    final locator = GeolocatorLinux(manager);
    await expectLater(
        await locator.checkPermission(), LocationPermission.unableToDetermine);
  });
}

final dummyLocation = GeoClueLocation(
  accuracy: 1,
  altitude: 2,
  heading: 3,
  latitude: 4,
  longitude: 5,
  speed: 6,
  timestamp: DateTime(2022),
);

final dummyPosition = Position(
  accuracy: 1,
  altitude: 2,
  heading: 3,
  latitude: 4,
  longitude: 5,
  speed: 6,
  speedAccuracy: 0,
  timestamp: DateTime(2022),
);
