import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mockito/mockito.dart';
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
      final permission = await Geolocator.checkPermission();

      expect(permission, LocationPermission.whileInUse);
    });

    test('requestPermission', () async {
      final permission = await Geolocator.requestPermission();

      expect(permission, LocationPermission.whileInUse);
    });

    test('isLocationServiceEnabled', () async {
      final isLocationServiceEnabled =
          await Geolocator.isLocationServiceEnabled();

      expect(isLocationServiceEnabled, true);
    });

    test('getLastKnownPosition', () async {
      final position = await Geolocator.getLastKnownPosition();

      expect(position, mockPosition);
    });

    test('getCurrentPosition', () async {
      final position = await Geolocator.getCurrentPosition();

      expect(position, mockPosition);
    });

    test('getPositionStream', () async {
      when(GeolocatorPlatform.instance.getPositionStream(
        desiredAccuracy: LocationAccuracy.best,
        forceAndroidLocationManager: false,
        timeInterval: 0,
        timeLimit: null,
      )).thenAnswer((_) => Stream.value(mockPosition));

      final position = await Geolocator.getPositionStream();

      expect(position, emitsInOrder([emits(mockPosition), emitsDone]));
    });

    test('getPositionStream: time interval should be set to zero if left null.',
        () async {
      await Geolocator.getPositionStream(intervalDuration: null);

      verify(GeolocatorPlatform.instance.getPositionStream(
        desiredAccuracy: LocationAccuracy.best,
        forceAndroidLocationManager: false,
        timeInterval: 0,
        timeLimit: null,
      ));
    });

    test(
        // ignore: lines_longer_than_80_chars
        'getPositionStream: time interval duration should be set to milliseconds.',
        () async {
      await Geolocator.getPositionStream(
        intervalDuration: Duration(seconds: 10),
      );

      verify(GeolocatorPlatform.instance.getPositionStream(
        desiredAccuracy: LocationAccuracy.best,
        forceAndroidLocationManager: false,
        timeInterval: 10000,
        timeLimit: null,
      ));
    });

    test('openAppSettings', () async {
      final hasOpened = await Geolocator.openAppSettings();
      expect(hasOpened, true);
    });

    test('openLocationSettings', () async {
      final hasOpened = await Geolocator.openLocationSettings();
      expect(hasOpened, true);
    });

    test('distanceBetween', () async {
      final distance = await Geolocator.distanceBetween(0, 0, 0, 0);
      expect(distance, 42);
    });

    test('bearingBetween', () async {
      final bearing = await Geolocator.bearingBetween(0, 0, 0, 0);
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
  Future<LocationPermission> checkPermission() =>
      Future.value(LocationPermission.whileInUse);

  @override
  Future<LocationPermission> requestPermission() =>
      Future.value(LocationPermission.whileInUse);

  @override
  Future<bool> isLocationServiceEnabled() => Future.value(true);

  @override
  Future<Position> getLastKnownPosition({
    bool forceAndroidLocationManager = false,
  }) =>
      Future.value(mockPosition);

  @override
  Future<Position> getCurrentPosition({
    LocationAccuracy desiredAccuracy = LocationAccuracy.best,
    bool forceAndroidLocationManager = false,
    Duration timeLimit,
  }) =>
      Future.value(mockPosition);

/*  
  @override
  Stream<Position> getPositionStream({
    LocationAccuracy desiredAccuracy = LocationAccuracy.best,
    int distanceFilter = 0,
    bool forceAndroidLocationManager = false,
    int timeInterval = 0,
    Duration timeLimit,
  }) =>
      Stream.value(mockPosition);
*/
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
