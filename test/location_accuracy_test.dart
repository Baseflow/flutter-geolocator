import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  group('Given the LocationAccuracy enum with value', () {
    test('best the toString should return "LocationAccuracy.best"', () {
      final accuracy = LocationAccuracy.best;
      final expectedString = 'LocationAccuracy.best';
      final actualString = accuracy.toString();

      expect(actualString, expectedString);
    });

    test(
        'bestForNavigation the toString should return "LocationAccuracy.bestForNavigation"',
        () {
      final accuracy = LocationAccuracy.bestForNavigation;
      final expectedString = 'LocationAccuracy.bestForNavigation';
      final actualString = accuracy.toString();

      expect(actualString, expectedString);
    });

    test('high the toString should return "LocationAccuracy.high"', () {
      final accuracy = LocationAccuracy.high;
      final expectedString = 'LocationAccuracy.high';
      final actualString = accuracy.toString();

      expect(actualString, expectedString);
    });

    test('medium the toString should return "LocationAccuracy.medium"', () {
      final accuracy = LocationAccuracy.medium;
      final expectedString = 'LocationAccuracy.medium';
      final actualString = accuracy.toString();

      expect(actualString, expectedString);
    });

    test('low the toString should return "LocationAccuracy.low"', () {
      final accuracy = LocationAccuracy.low;
      final expectedString = 'LocationAccuracy.low';
      final actualString = accuracy.toString();

      expect(actualString, expectedString);
    });

    test('lowest the toString should return "LocationAccuracy.lowest"', () {
      final accuracy = LocationAccuracy.lowest;
      final expectedString = 'LocationAccuracy.lowest';
      final actualString = accuracy.toString();

      expect(actualString, expectedString);
    });
  });
}
