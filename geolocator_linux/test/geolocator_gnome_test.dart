import 'dart:async';

import 'package:dbus/dbus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator_linux/src/geolocator_gnome.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:gsettings/gsettings.dart';
import 'package:geoclue/geoclue.dart';

import 'geolocator_gnome_test.mocks.dart';

@GenerateMocks([GeoClueManager, GSettings])
void main() {
  test('service status stream', () async {
    final manager = MockGeoClueManager();
    final settings = MockGSettings();
    when(settings.get('enabled'))
        .thenAnswer((_) async => const DBusBoolean(true));
    final settingsChanged = StreamController<List<String>>();
    when(settings.keysChanged).thenAnswer((_) => settingsChanged.stream);

    final locator = GeolocatorGnome(manager, settings: settings);
    settingsChanged.add(['enabled']);
    await expectLater(
        locator.getServiceStatusStream(), emits(ServiceStatus.enabled));
  });

  test('location service enabled', () async {
    final manager = MockGeoClueManager();
    final settings = MockGSettings();
    when(settings.get('enabled'))
        .thenAnswer((_) async => const DBusBoolean(false));

    final locator = GeolocatorGnome(manager, settings: settings);
    expect(await locator.isLocationServiceEnabled(), isFalse);
    verify(settings.get('enabled')).called(1);
  });
}
