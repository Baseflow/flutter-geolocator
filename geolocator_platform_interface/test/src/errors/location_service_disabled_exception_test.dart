import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';

void main() {
  test('toString: Should return a description of the exception', () {
    // Arrange
    const expected = 'The location service on the device is disabled.';
    const exception = LocationServiceDisabledException();

    // Act
    final actual = exception.toString();

    // Assert
    expect(actual, expected);
  });
}
