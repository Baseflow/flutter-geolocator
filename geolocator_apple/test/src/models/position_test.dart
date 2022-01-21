import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';

void main() {
  group('hashCode tests:', () {
    test('hashCode should be the same for two instances with the same values',
        () {
      // Arrange
      final firstPosition = Position(
        longitude: 0,
        latitude: 0,
        timestamp: DateTime.fromMillisecondsSinceEpoch(0),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        isMocked: false,
      );
      final secondPosition = Position(
        longitude: 0,
        latitude: 0,
        timestamp: DateTime.fromMillisecondsSinceEpoch(0),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        isMocked: false,
      );

      // Act & Assert
      expect(
        firstPosition.hashCode,
        secondPosition.hashCode,
      );
    });

    test('hashCode should not match when the longitude property is different',
        () {
      // Arrange
      final firstPosition = Position(
        longitude: 0,
        latitude: 0,
        timestamp: DateTime.fromMillisecondsSinceEpoch(0),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        isMocked: false,
      );
      final secondPosition = Position(
        longitude: 1,
        latitude: 0,
        timestamp: DateTime.fromMillisecondsSinceEpoch(0),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        isMocked: false,
      );

      // Act & Assert
      expect(
        firstPosition.hashCode != secondPosition.hashCode,
        true,
      );
    });

    test('hashCode should not match when the latitude property is different',
        () {
      // Arrange
      final firstPosition = Position(
        longitude: 0,
        latitude: 0,
        timestamp: DateTime.fromMillisecondsSinceEpoch(0),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        isMocked: false,
      );
      final secondPosition = Position(
        longitude: 0,
        latitude: 1,
        timestamp: DateTime.fromMillisecondsSinceEpoch(0),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        isMocked: false,
      );

      // Act & Assert
      expect(
        firstPosition.hashCode != secondPosition.hashCode,
        true,
      );
    });

    test('hashCode should not match when the timestamp property is different',
        () {
      // Arrange
      final firstPosition = Position(
        longitude: 0,
        latitude: 0,
        timestamp: DateTime.fromMillisecondsSinceEpoch(0),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        isMocked: false,
      );
      final secondPosition = Position(
        longitude: 0,
        latitude: 0,
        timestamp: DateTime.fromMillisecondsSinceEpoch(1),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        isMocked: false,
      );

      // Act & Assert
      expect(
        firstPosition.hashCode != secondPosition.hashCode,
        true,
      );
    });

    test('hashCode should not match when the accuracy property is different',
        () {
      // Arrange
      final firstPosition = Position(
        longitude: 0,
        latitude: 0,
        timestamp: DateTime.fromMillisecondsSinceEpoch(0),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        isMocked: false,
      );
      final secondPosition = Position(
        longitude: 0,
        latitude: 0,
        timestamp: DateTime.fromMillisecondsSinceEpoch(0),
        accuracy: 1,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        isMocked: false,
      );

      // Act & Assert
      expect(
        firstPosition.hashCode != secondPosition.hashCode,
        true,
      );
    });

    test('hashCode should not match when the altitude property is different',
        () {
      // Arrange
      final firstPosition = Position(
        longitude: 0,
        latitude: 0,
        timestamp: DateTime.fromMillisecondsSinceEpoch(0),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        isMocked: false,
      );
      final secondPosition = Position(
        longitude: 0,
        latitude: 0,
        timestamp: DateTime.fromMillisecondsSinceEpoch(0),
        accuracy: 0,
        altitude: 1,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        isMocked: false,
      );

      // Act & Assert
      expect(
        firstPosition.hashCode != secondPosition.hashCode,
        true,
      );
    });

    test('hashCode should not match when the heading property is different',
        () {
      // Arrange
      final firstPosition = Position(
        longitude: 0,
        latitude: 0,
        timestamp: DateTime.fromMillisecondsSinceEpoch(0),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        isMocked: false,
      );
      final secondPosition = Position(
        longitude: 0,
        latitude: 0,
        timestamp: DateTime.fromMillisecondsSinceEpoch(0),
        accuracy: 0,
        altitude: 0,
        heading: 1,
        speed: 0,
        speedAccuracy: 0,
        isMocked: false,
      );

      // Act & Assert
      expect(
        firstPosition.hashCode != secondPosition.hashCode,
        true,
      );
    });

    test('hashCode should not match when the speed property is different', () {
      // Arrange
      final firstPosition = Position(
        longitude: 0,
        latitude: 0,
        timestamp: DateTime.fromMillisecondsSinceEpoch(0),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        isMocked: false,
      );
      final secondPosition = Position(
        longitude: 0,
        latitude: 0,
        timestamp: DateTime.fromMillisecondsSinceEpoch(0),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 1,
        speedAccuracy: 0,
        isMocked: false,
      );

      // Act & Assert
      expect(
        firstPosition.hashCode != secondPosition.hashCode,
        true,
      );
    });

    test(
        // ignore: lines_longer_than_80_chars
        'hashCode should not match when the speedAccuracy property is different',
        () {
      // Arrange
      final firstPosition = Position(
        longitude: 0,
        latitude: 0,
        timestamp: DateTime.fromMillisecondsSinceEpoch(0),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        isMocked: false,
      );
      final secondPosition = Position(
        longitude: 0,
        latitude: 0,
        timestamp: DateTime.fromMillisecondsSinceEpoch(0),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 1,
        isMocked: false,
      );

      // Act & Assert
      expect(
        firstPosition.hashCode != secondPosition.hashCode,
        true,
      );
    });

    test(
        // ignore: lines_longer_than_80_chars
        'hashCode should not match when the speedAccuracy property is different',
        () {
      // Arrange
      final firstPosition = Position(
        longitude: 0,
        latitude: 0,
        timestamp: DateTime.fromMillisecondsSinceEpoch(0),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        isMocked: false,
      );
      final secondPosition = Position(
        longitude: 0,
        latitude: 0,
        timestamp: DateTime.fromMillisecondsSinceEpoch(0),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        isMocked: true,
      );

      // Act & Assert
      expect(
        firstPosition.hashCode != secondPosition.hashCode,
        true,
      );
    });

    test('hashCode should not match when the floor property is different', () {
      // Arrange
      final firstPosition = Position(
        longitude: 0,
        latitude: 0,
        timestamp: DateTime.fromMillisecondsSinceEpoch(0),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        floor: 0,
        speed: 0,
        speedAccuracy: 0,
        isMocked: false,
      );
      final secondPosition = Position(
        longitude: 0,
        latitude: 0,
        timestamp: DateTime.fromMillisecondsSinceEpoch(0),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        floor: 1,
        speed: 0,
        speedAccuracy: 0,
        isMocked: false,
      );

      // Act & Assert
      expect(
        firstPosition.hashCode != secondPosition.hashCode,
        true,
      );
    });
  });

  group('fromMap tests:', () {
    test(
        // ignore: lines_longer_than_80_chars
        'fromMap should throw argument error when map does not contain latitude',
        () {
      // Arrange
      final map = <String, double>{
        'longitude': 0,
      };

      // Act & Assert
      expect(() => Position.fromMap(map), throwsArgumentError);
    });

    test(
        // ignore: lines_longer_than_80_chars
        'fromMap should throw argument error when map does not contain latitude',
        () {
      // Arrange
      final map = <String, double>{
        'latitude': 0,
      };

      // Act & Assert
      expect(() => Position.fromMap(map), throwsArgumentError);
    });
  });

  group('toString tests:', () {
    test('toString should return human readable latitude and longitude', () {
      // Arrange
      final position = Position(
        longitude: 0,
        latitude: 0,
        timestamp: DateTime.fromMillisecondsSinceEpoch(0),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        isMocked: false,
      );

      // Act
      final readablePosition = position.toString();

      // Assert
      expect(
        readablePosition,
        'Latitude: ${position.latitude}, Longitude: ${position.longitude}',
      );
    });
  });
}
