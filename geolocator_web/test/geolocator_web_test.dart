import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
import 'package:geolocator_web/geolocator_web.dart';
import 'package:geolocator_web/src/geolocation_manager.dart';
import 'package:geolocator_web/src/permissions_manager.dart';

Position get mockPosition =>
    Position(
        longitude: 6.8240281,
        latitude: 52.2669748,
        timestamp: DateTime.fromMillisecondsSinceEpoch(500, isUtc: true),
        accuracy: 0.0,
        altitude: 3000.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0);

void main() {
  //group request permissions
  group('Geolocation', () {
    test('getCurrentPosition should return a valid position', () async {
      final mockGeolocationManager = MockGeolocationManager();
      final mockPermissionManager = MockPermissionManager();
      final geolocatorPlugin = GeolocatorPlugin.private(
          mockGeolocationManager, mockPermissionManager);

      mockGeolocationManager.setLocationServiceStatus(true);

      final position = await geolocatorPlugin.getCurrentPosition();
      expect(position, mockPosition);
    });

    test('getCurrentPosition throws error when LocationServices is disabled',
            () {
          final mockGeolocationManager = MockGeolocationManager();
          final mockPermissionManager = MockPermissionManager();
          final geolocatorPlugin = GeolocatorPlugin.private(
              mockGeolocationManager, mockPermissionManager);

          mockGeolocationManager.setLocationServiceStatus(false);

          expect(geolocatorPlugin.getCurrentPosition,
              throwsA(isA<LocationServiceDisabledException>()));
        });

    test('isLocationServiceEnabled returns true', () async {
      final mockGeolocationManager = MockGeolocationManager();
      final mockPermissionManager = MockPermissionManager();
      final geolocatorPlugin = GeolocatorPlugin.private(
          mockGeolocationManager, mockPermissionManager);

      final isLocationServiceEnabled =
      await geolocatorPlugin.isLocationServiceEnabled();

      expect(isLocationServiceEnabled, true);
    });

    test('getPositionStream', () async {
      final mockGeolocationManager = MockGeolocationManager();
      final mockPermissionManager = MockPermissionManager();
      final geolocatorPlugin = GeolocatorPlugin.private(
          mockGeolocationManager, mockPermissionManager);

      when(geolocatorPlugin.getPositionStream(
        desiredAccuracy: LocationAccuracy.best,
        forceAndroidLocationManager: false,
        timeInterval: 0,
        timeLimit: null,
      )).thenAnswer((_) => Stream.value(mockPosition));

      final position = await geolocatorPlugin.getPositionStream();

      expect(position, emitsInOrder([emits(mockPosition), emitsDone]));
    });

    // test('getPositionStream', () async {
    //   final mockGeolocationManager = MockGeolocationManager();
    //   final mockPermissionManager = MockPermissionManager();
    //   final geolocatorPlugin = GeolocatorPlugin.private(
    //       mockGeolocationManager, mockPermissionManager);
    //
    //   final mockPositions = List.of(() sync* {
    //     for(var i = 0; i < 5; i++){
    //       yield Position(
    //           latitude: 52.561270 + i * 0.004,
    //           longitude: 5.639382,
    //           timestamp: DateTime.fromMillisecondsSinceEpoch(
    //             500,
    //             isUtc: true,
    //           ),
    //           altitude: 3000.0,
    //           accuracy: 0.0,
    //           heading: 0.0,
    //           speed: 0.0,
    //           speedAccuracy: 0.0);
    //     }
    //   }());
    //
    //   when(geolocatorPlugin.getPositionStream(
    //     desiredAccuracy: LocationAccuracy.best,
    //     forceAndroidLocationManager: false,
    //     timeInterval: 0,
    //     timeLimit: null,
    //   )).thenAnswer((_) {
    //     return Stream.fromIterable(
    //     ...mockPositions
    //     );
    //   });
    //   final position = await geolocatorPlugin.getPositionStream();
    //   expect(
    //       position,
    //       emitsInOrder([
    //         emits(mockPosition),
    //         emitsDone
    //       ]));
    // });
  });

  group('throw unsupported exception', () {
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

      expect(geolocatorPlugin.openAppSettings,
          throwsA(isA<PlatformException>()));
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

  @override
  Future<Position> getCurrentPosition(
      {bool? enableHighAccuracy, Duration? timeout}) {
    if (!_locationServicesEnabled) {
      throw LocationServiceDisabledException();
    }
    return Future.value(mockPosition);
  }

  @override
  Stream<Position> watchPosition(
      {bool? enableHighAccuracy, Duration? timeout}) {
    // TODO: implement watchPosition
    throw UnimplementedError();
  }

  @override
  bool get locationServicesEnabled => _locationServicesEnabled;

  void setLocationServiceStatus(bool enabled) {
    _locationServicesEnabled = enabled;
  }
}


class MockPermissionManager implements PermissionsManager {
  bool _permissionsSupported = false;
  static const _permissionQuery = {'name': 'geolocation'};

  @override
  Future<LocationPermission> query(Map permission) async {
    return Future.value(query(permission));
  }

  @override
  bool get permissionsSupported => _permissionsSupported;

  void setPermissionsSupported(bool enabled) {
    _permissionsSupported = enabled;
  }
}
