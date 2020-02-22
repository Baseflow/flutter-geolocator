import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  group('Given the GeolocatorPermission enum with value', () {
    test('location the toString should return "GeolocationPermission.location"', () {
      final permission = GeolocationPermission.location;
      final expectedString = 'GeolocationPermission.location';
      final actualString = permission.toString();

      expect(actualString, expectedString);
    });

    test('locationAlways the toString should return "GeolocationPermission.locationAlways"', () {
      final permission = GeolocationPermission.locationAlways;
      final expectedString = 'GeolocationPermission.locationAlways';
      final actualString = permission.toString();

      expect(actualString, expectedString);
    });

    test('locationWhenInUse the toString should return "GeolocationPermission.locationWhenInUse"',
        () {
      final permission = GeolocationPermission.locationWhenInUse;
      final expectedString = 'GeolocationPermission.locationWhenInUse';
      final actualString = permission.toString();

      expect(actualString, expectedString);
    });
  });

  group('Given the GeolocatorStatus enum with value', () {
    test('denied the toString should return "GeolocationStatus.denied"', () {
      final status = GeolocationStatus.denied;
      final expectedString = 'GeolocationStatus.denied';
      final actualString = status.toString();

      expect(actualString, expectedString);
    });

    test('disabled the toString should return "GeolocationStatus.diabled"', () {
      final status = GeolocationStatus.disabled;
      final expectedString = 'GeolocationStatus.disabled';
      final actualString = status.toString();

      expect(actualString, expectedString);
    });

    test('granted the toString should return "GeolocationStatus.granted"', () {
      final status = GeolocationStatus.granted;
      final expectedString = 'GeolocationStatus.granted';
      final actualString = status.toString();

      expect(actualString, expectedString);
    });

    test('restricted the toString should return "GeolocationStatus.restricted"', () {
      final status = GeolocationStatus.restricted;
      final expectedString = 'GeolocationStatus.restricted';
      final actualString = status.toString();

      expect(actualString, expectedString);
    });

    test('unknown the toString should return "GeolocationStatus.unknown"', () {
      final status = GeolocationStatus.unknown;
      final expectedString = 'GeolocationStatus.unknown';
      final actualString = status.toString();

      expect(actualString, expectedString);
    });
  });
}
