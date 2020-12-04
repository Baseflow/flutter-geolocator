import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator_platform_interface/src/errors/location_not_available.dart';

void main() {
  test('toString: Should return a description of the exception', () {
    // Arrange
    final expected =
        'Geolocator could not get a location fix. Maybe the location settings '
        'are not correct in relation to the desired accuracy?';
    final exception = LocationNotAvailableException();

    // Act
    final actual = exception.toString();

    // Assert
    expect(actual, expected);
  });
}
