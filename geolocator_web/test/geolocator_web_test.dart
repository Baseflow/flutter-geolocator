import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator_web/geolocator_web.dart';
import 'package:geolocator_web/src/geolocation_manager.dart';
import 'package:geolocator_web/src/permissions_manager.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'geolocator_web_test.mocks.dart';

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
            altitudeAccuracy: 0.0,
            accuracy: 0.0,
            heading: 0.0,
            headingAccuracy: 0.0,
            speed: 0.0,
            speedAccuracy: 0.0);
      }
    }());

@GenerateNiceMocks([
  MockSpec<GeolocationManager>(),
  MockSpec<PermissionsManager>(),
])
void main() {
  late MockGeolocationManager mockGeolocationManager;
  late MockPermissionsManager mockPermissionsManager;
  late GeolocatorPlugin geolocatorPlugin;

  setUp(() {
    mockGeolocationManager = MockGeolocationManager();
    mockPermissionsManager = MockPermissionsManager();
    geolocatorPlugin = GeolocatorPlugin.private(
        mockGeolocationManager, mockPermissionsManager);

    when(mockGeolocationManager.getCurrentPosition(
            enableHighAccuracy: anyNamed('enableHighAccuracy'),
            timeout: anyNamed('timeout')))
        .thenAnswer((_) async => mockPositions.first);
    when(mockGeolocationManager.watchPosition(
            enableHighAccuracy: anyNamed('enableHighAccuracy'),
            timeout: anyNamed('timeout')))
        .thenAnswer((_) => Stream.fromIterable(mockPositions));
  });

  group('Permission methods', () {
    test('checkPermission returns the correct LocationPermission', () async {
      when(mockPermissionsManager.permissionsSupported).thenReturn(true);

      await geolocatorPlugin.checkPermission();

      verify(mockPermissionsManager.query({'name': 'geolocation'})).called(1);
    });

    test('requestPermission returns LocationPermission.whileInUse', () async {
      final result = await geolocatorPlugin.requestPermission();

      expect(result, LocationPermission.whileInUse);
    });
  });

  group('getCurrentPosition method', () {
    test('getCurrentPosition should return a valid position', () async {
      final position = await geolocatorPlugin.getCurrentPosition(
          locationSettings: const LocationSettings());
      expect(position, mockPositions.first);
    });
  });

  group('getPositionStream method', () {
    test('getPositionStream should return all mocked positions', () {
      final positionsStream = geolocatorPlugin.getPositionStream(
          locationSettings: const LocationSettings());

      expect(positionsStream, emitsInOrder(mockPositions));
    });

    test('getPositionStream should filter out mocked positions', () {
      final mockPositionsForFilter = List.of(() sync* {
        for (var i = 0; i < 3; i++) {
          yield Position(
              latitude: 52.2669748 + i * 0.00005,
              longitude: 6.8240281,
              timestamp: DateTime.fromMillisecondsSinceEpoch(
                500,
                isUtc: true,
              ),
              altitude: 3000.0,
              altitudeAccuracy: 0.0,
              accuracy: 0.0,
              heading: 0.0,
              headingAccuracy: 0.0,
              speed: 0.0,
              speedAccuracy: 0.0);
        }
      }());

      final positionsStream = geolocatorPlugin.getPositionStream(
        locationSettings: const LocationSettings(
          distanceFilter: 7,
        ),
      );

      expect(positionsStream, emitsInOrder(mockPositionsForFilter));
    });
  });

  group('Unsupported exceptions', () {
    test('getLastKnownPosition throws unsupported exception', () async {
      expect(geolocatorPlugin.getLastKnownPosition,
          throwsA(isA<UnsupportedError>()));
    });

    test('openAppSettings throws unsupported exception', () async {
      expect(
          geolocatorPlugin.openAppSettings, throwsA(isA<UnsupportedError>()));
    });

    test('openLocationSettings throws unsupported exception', () async {
      expect(geolocatorPlugin.openLocationSettings,
          throwsA(isA<UnsupportedError>()));
    });

    test('getServiceStatusStream throws unsupported exception', () async {
      expect(geolocatorPlugin.getServiceStatusStream,
          throwsA(isA<UnsupportedError>()));
    });
  });
}
