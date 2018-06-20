import 'package:geolocator/models/position.dart';
import 'package:test/test.dart';

void main() {
  group('Test converting `fromMap`', () {
    test(
        'Should return a valid position instance when only mandatory fields are supplied',
        () {
      var mockMap = <String, double>{
        'latitude': 0.0,
        'longitude': 0.0,
      };

      expect(Position.fromMap(mockMap), isInstanceOf<Position>());
    });

    test('Should throw ArgumentError when `latitude` is missing', () {
      var mockMap = <String, double>{
        'longitude': 0.0,
      };

      expect(() => Position.fromMap(mockMap),
          throwsA(new isInstanceOf<ArgumentError>()));
    });

    test('Should throw ArgumentError when `longitude` is missing', () {
      var mockMap = <String, double>{
        'latitude': 0.0,
      };

      expect(() => Position.fromMap(mockMap),
          throwsA(new isInstanceOf<ArgumentError>()));
    });

    test('Optional fields should be set to 0.0', () {
      var mockMap = <String, double>{
        'latitude': 54.0,
        'longitude': 5.0,
      };

      var position = Position.fromMap(mockMap);

      expect(position.altitude, 0.0);
      expect(position.accuracy, 0.0);
      expect(position.heading, 0.0);
      expect(position.speed, 0.0);
      expect(position.speedAccuracy, 0.0);
    });
  });
}
