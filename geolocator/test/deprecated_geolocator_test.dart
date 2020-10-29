import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

Position get mockPosition => Position(
    latitude: 52.561270,
    longitude: 5.639382,
    timestamp: DateTime.fromMillisecondsSinceEpoch(
      500,
      isUtc: true,
    ),
    altitude: 3000.0,
    accuracy: 0.0,
    heading: 0.0,
    speed: 0.0,
    speedAccuracy: 0.0);

void main() {
  group('Geolocator', () {
    setUp(() {
      GeolocatorPlatform.instance = MockGeolocatorPlatform();
    });

    test('checkPermission', () async {
      //ignore: deprecated_member_use_from_same_package
      final permission = await geolocator.checkPermission();

      expect(permission, geolocator.LocationPermission.whileInUse);
    });

    test('requestPermission', () async {
      //ignore: deprecated_member_use_from_same_package
      final permission = await geolocator.requestPermission();

      expect(permission, geolocator.LocationPermission.whileInUse);
    });

    test('isLocationServiceEnabled', () async {
      final isLocationServiceEnabled =
          //ignore: deprecated_member_use_from_same_package
          await geolocator.isLocationServiceEnabled();

      expect(isLocationServiceEnabled, true);
    });

    test('getLastKnownPosition', () async {
      //ignore: deprecated_member_use_from_same_package
      final position = await geolocator.getLastKnownPosition();

      expect(position, mockPosition);
    });

    test('getCurrentPosition', () async {
      //ignore: deprecated_member_use_from_same_package
      final position = await geolocator.getCurrentPosition();

      expect(position, mockPosition);
    });

    test('getPositionStream', () async {
      //ignore: deprecated_member_use_from_same_package
      final position = await geolocator.getPositionStream();

      expect(position, emitsInOrder([emits(mockPosition), emitsDone]));
    });

    test('openAppSettings', () async {
      //ignore: deprecated_member_use_from_same_package
      final hasOpened = await geolocator.openAppSettings();
      expect(hasOpened, true);
    });

    test('openLocationSettings', () async {
      //ignore: deprecated_member_use_from_same_package
      final hasOpened = await geolocator.openLocationSettings();
      expect(hasOpened, true);
    });

    test('distanceBetween', () async {
      //ignore: deprecated_member_use_from_same_package
      final distance = await geolocator.distanceBetween(0, 0, 0, 0);
      expect(distance, 42);
    });

    test('bearingBetween', () async {
      //ignore: deprecated_member_use_from_same_package
      final bearing = await geolocator.bearingBetween(0, 0, 0, 0);
      expect(bearing, 42);
    });
  });
}

class MockGeolocatorPlatform extends Mock
    with
        // ignore: prefer_mixin
        MockPlatformInterfaceMixin
    implements
        GeolocatorPlatform {
  @override
  Future<geolocator.LocationPermission> checkPermission() =>
      Future.value(geolocator.LocationPermission.whileInUse);

  @override
  Future<geolocator.LocationPermission> requestPermission() =>
      Future.value(geolocator.LocationPermission.whileInUse);

  @override
  Future<bool> isLocationServiceEnabled() => Future.value(true);

  @override
  Future<geolocator.Position> getLastKnownPosition({
    bool forceAndroidLocationManager = false,
  }) =>
      Future.value(mockPosition);

  @override
  Future<geolocator.Position> getCurrentPosition({
    geolocator.LocationAccuracy desiredAccuracy = LocationAccuracy.best,
    bool forceAndroidLocationManager = false,
    Duration timeLimit,
  }) =>
      Future.value(mockPosition);

  @override
  Stream<geolocator.Position> getPositionStream({
    geolocator.LocationAccuracy desiredAccuracy = LocationAccuracy.best,
    int distanceFilter = 0,
    bool forceAndroidLocationManager = false,
    int timeInterval = 0,
    Duration timeLimit,
  }) =>
      Stream.value(mockPosition);

  @override
  Future<bool> openAppSettings() => Future.value(true);

  @override
  Future<bool> openLocationSettings() => Future.value(true);

  @override
  double distanceBetween(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) =>
      42;

  @override
  double bearingBetween(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) =>
      42;
}
