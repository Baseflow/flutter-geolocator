import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
import 'package:geolocator_web/geolocator_web.dart';
import 'package:geolocator_web/src/geolocation_manager.dart';
import 'package:geolocator_web/src/permissions_manager.dart';
import 'package:mockito/mockito.dart';

List<Position> get mockPositions => List.of(() sync* {
      for (var i = 0; i < 5; i++) {
        yield Position(
            latitude: 52.2669748 + i * 0.00005,
            longitude: 6.8240281,
            timestamp: DateTime.fromMillisecondsSinceEpoch(
              500,
              isUtc: true,
            ),
            altitude: 3000.0,
            accuracy: 0.0,
            heading: 0.0,
            speed: 0.0,
            speedAccuracy: 0.0);
      }
    }());

void main() {

  test('isLocationServiceEnabled returns true', () async {
    final mockGeolocationManager = MockGeolocationManager();
    final mockPermissionManager = MockPermissionManager();
    final geolocatorPlugin =
    GeolocatorPlugin.private(mockGeolocationManager, mockPermissionManager);

    final isLocationServiceEnabled =
    await geolocatorPlugin.isLocationServiceEnabled();

    expect(isLocationServiceEnabled, true);
  });

  test('enableHighAccuracy returns the correct value depending on given accuracy in getPositionStream method', () async {
    final mockGeolocationManager = MockGeolocationManager();
    final mockPermissionManager = MockPermissionManager();
    final geolocatorPlugin =
    GeolocatorPlugin.private(mockGeolocationManager, mockPermissionManager);

    geolocatorPlugin.getPositionStream(desiredAccuracy: LocationAccuracy.medium);
    expect(mockGeolocationManager.enableHighAccuracy, false);

    geolocatorPlugin.getPositionStream(desiredAccuracy: LocationAccuracy.high);
    expect(mockGeolocationManager.enableHighAccuracy, true);
  });

  test('enableHighAccuracy returns the correct value depending on given accuracy in getCurrentPosition method', () async {
    final mockGeolocationManager = MockGeolocationManager();
    final mockPermissionManager = MockPermissionManager();
    final geolocatorPlugin =
    GeolocatorPlugin.private(mockGeolocationManager, mockPermissionManager);

    geolocatorPlugin.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
    expect(mockGeolocationManager.enableHighAccuracy, false);

    geolocatorPlugin.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    expect(mockGeolocationManager.enableHighAccuracy, true);
  });

  group('Permission methods',(){
    test('checkPermission throws exception when permissionsSupported is false', () {
      final mockGeolocationManager = MockGeolocationManager();
      final mockPermissionManager = MockPermissionManager();
      final geolocatorPlugin = GeolocatorPlugin.private(
          mockGeolocationManager, mockPermissionManager);

      when(mockPermissionManager.permissionsSupported).thenReturn(false);

      expect(geolocatorPlugin.checkPermission, throwsA(isA<PlatformException>()));
    });

    test('checkPermission returns the correct LocationPermission', () async {
      final mockGeolocationManager = MockGeolocationManager();
      final mockPermissionManager = MockPermissionManager();
      final geolocatorPlugin = GeolocatorPlugin.private(
          mockGeolocationManager, mockPermissionManager);

      when(mockPermissionManager.permissionsSupported).thenReturn(true);

      await geolocatorPlugin.checkPermission();

      verify(mockPermissionManager.query({'name': 'geolocation'})).called(1);
    });

    test('requestPermission throws exception when LocationServices is disabled', (){
      final mockGeolocationManager = MockGeolocationManager();
      final mockPermissionManager = MockPermissionManager();
      final geolocatorPlugin = GeolocatorPlugin.private(
          mockGeolocationManager, mockPermissionManager);

      mockGeolocationManager.setLocationServiceStatus(false);

      expect(geolocatorPlugin.requestPermission, throwsA(isA<PlatformException>()));
    });

    test('requestPermission returns LocationPermission.whileInUse', () async {
      final mockGeolocationManager = MockGeolocationManager();
      final mockPermissionManager = MockPermissionManager();
      final geolocatorPlugin = GeolocatorPlugin.private(
          mockGeolocationManager, mockPermissionManager);

      final result = await geolocatorPlugin.requestPermission();

      expect(result, LocationPermission.whileInUse);
    });
  });

  group('getCurrentPosition method', () {
    test('getCurrentPosition should return a valid position', () async {
      final mockGeolocationManager = MockGeolocationManager();
      final mockPermissionManager = MockPermissionManager();
      final geolocatorPlugin = GeolocatorPlugin.private(
          mockGeolocationManager, mockPermissionManager);

      mockGeolocationManager.setLocationServiceStatus(true);

      final position = await geolocatorPlugin.getCurrentPosition();
      expect(position, mockPositions.first);
    });

    test('getCurrentPosition throws exception when LocationServices is disabled',
        () {
      final mockGeolocationManager = MockGeolocationManager();
      final mockPermissionManager = MockPermissionManager();
      final geolocatorPlugin = GeolocatorPlugin.private(
          mockGeolocationManager, mockPermissionManager);

      mockGeolocationManager.setLocationServiceStatus(false);

      expect(geolocatorPlugin.getCurrentPosition,
          throwsA(isA<LocationServiceDisabledException>()));
    });
  });
  
  group('getPositionStream method', (){
    test('getPositionStream should return all mocked positions', () {
      final mockGeolocationManager = MockGeolocationManager();
      final mockPermissionManager = MockPermissionManager();
      final geolocatorPlugin = GeolocatorPlugin.private(
          mockGeolocationManager, mockPermissionManager);

      final positionsStream = geolocatorPlugin.getPositionStream();

      expect(positionsStream, emitsInOrder(mockPositions));
    });

    test('getPositionStream should filter out mocked positions', () {
      final mockGeolocationManager = MockGeolocationManager();
      final mockPermissionManager = MockPermissionManager();
      final geolocatorPlugin =
      GeolocatorPlugin.private(mockGeolocationManager, mockPermissionManager);

      var mockPositionsForFilter = List.of(() sync* {
        for (var i = 0; i < 3; i++) {
          yield Position(
              latitude: 52.2669748 + i * 0.00005,
              longitude: 6.8240281,
              timestamp: DateTime.fromMillisecondsSinceEpoch(
                500,
                isUtc: true,
              ),
              altitude: 3000.0,
              accuracy: 0.0,
              heading: 0.0,
              speed: 0.0,
              speedAccuracy: 0.0);
        }
      }());

      final positionsStream =
      geolocatorPlugin.getPositionStream(distanceFilter: 7);

      expect(positionsStream, emitsInOrder(mockPositionsForFilter));
    });

    test('getPositionStream throws error when LocationServices is disabled', () {
      final mockGeolocationManager = MockGeolocationManager();
      final mockPermissionManager = MockPermissionManager();
      final geolocatorPlugin =
      GeolocatorPlugin.private(mockGeolocationManager, mockPermissionManager);

      mockGeolocationManager.setLocationServiceStatus(false);

      expect(geolocatorPlugin.getPositionStream,
          throwsA(isA<LocationServiceDisabledException>()));
    });
  });
  
  group('Unsupported exceptions', () {
    test('getLastKnownPosition throws unsupported exception', () async {
      final mockGeolocationManager = MockGeolocationManager();
      final mockPermissionManager = MockPermissionManager();
      final geolocatorPlugin = GeolocatorPlugin.private(
          mockGeolocationManager, mockPermissionManager);

      expect(geolocatorPlugin.getLastKnownPosition,
          throwsA(isA<PlatformException>()));
    });

    test('openAppSettings throws unsupported exception', () async {
      final mockGeolocationManager = MockGeolocationManager();
      final mockPermissionManager = MockPermissionManager();
      final geolocatorPlugin = GeolocatorPlugin.private(
          mockGeolocationManager, mockPermissionManager);

      expect(
          geolocatorPlugin.openAppSettings, throwsA(isA<PlatformException>()));
    });

    test('openLocationSettings throws unsupported exception', () async {
      final mockGeolocationManager = MockGeolocationManager();
      final mockPermissionManager = MockPermissionManager();
      final geolocatorPlugin = GeolocatorPlugin.private(
          mockGeolocationManager, mockPermissionManager);

      expect(geolocatorPlugin.openLocationSettings,
          throwsA(isA<PlatformException>()));
    });
  });
}


class MockGeolocationManager implements GeolocationManager {
  bool _locationServicesEnabled = true;
  bool? enableHighAccuracy;

  @override
  Future<Position> getCurrentPosition(
      {bool? enableHighAccuracy, Duration? timeout}) {
    this.enableHighAccuracy = enableHighAccuracy;
    if (!_locationServicesEnabled) {
      throw LocationServiceDisabledException();
    }

    return Future.value(mockPositions.first);
  }

  @override
  Stream<Position> watchPosition(
      {bool? enableHighAccuracy, Duration? timeout}) {
    this.enableHighAccuracy = enableHighAccuracy;
    return Stream.fromIterable(mockPositions);
  }

  @override
  bool get locationServicesEnabled => _locationServicesEnabled;

  void setLocationServiceStatus(bool enabled) {
    _locationServicesEnabled = enabled;
  }
}

class MockPermissionManager extends Mock implements PermissionsManager {}