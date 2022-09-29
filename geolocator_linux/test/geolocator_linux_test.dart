import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator_linux/geolocator_linux.dart';
import 'package:geolocator_linux/src/geolocator_gnome.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:geoclue/geoclue.dart';

import 'geolocator_linux_test.mocks.dart';

@GenerateMocks([GeoClueClient, GeoClueManager])
void main() {
  test('registerWith', () async {
    // final client = MockGeoClueClient();
    // when(client.location).thenReturn(dummyLocation);

    // final manager = MockGeoClueManager();
    // when(manager.getClient()).thenAnswer((_) async => client);

    final manager = MockGeoClueManager();
    final Map<String, String> environment = {};
    // final locator = GeolocatorLinux(manager);
    // environment['XDG_CURRENT_DESKTOP'] = 'ubuntu:GNOME';
    // environment['XDG_CURRENT_DESKTOP'] = 'ubuntu:unity';
    // environment['XDG_CURRENT_DESKTOP'] = 'ubuntu:KDE';

    // environment['GNOME_SHELL_SESSION_MODE'] = 'ubuntu';
    // environment['GNOME_SHELL_SESSION_MODE'] = '';
    await GeolocatorLinux.registerWith(manager, environment);
    expect(GeolocatorPlatform.instance, isA<GeolocatorLinux>());

    environment['XDG_CURRENT_DESKTOP'] = 'ubuntu:unity';
    await GeolocatorLinux.registerWith(manager, environment);
    expect(GeolocatorPlatform.instance, isA<GeolocatorLinux>());

    environment['XDG_CURRENT_DESKTOP'] = 'ubuntu:GNOME';
    await GeolocatorLinux.registerWith(manager, environment);
    expect(GeolocatorPlatform.instance, isA<GeolocatorGnome>());

    environment['XDG_CURRENT_DESKTOP'] = 'ubuntu:unity';
    environment['GNOME_SHELL_SESSION_MODE'] = 'ubuntu';
    await GeolocatorLinux.registerWith(manager, environment);
    expect(GeolocatorPlatform.instance, isA<GeolocatorGnome>());
  });

  test('current position', () async {
    final client = MockGeoClueClient();
    when(client.location).thenReturn(dummyLocation);

    final manager = MockGeoClueManager();
    when(manager.getClient()).thenAnswer((_) async => client);

    final locator = GeolocatorLinux(manager);
    expect(await locator.getCurrentPosition(), equals(dummyPosition));
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
