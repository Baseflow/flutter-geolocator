import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';

void main() {
  test(
      'valueToConvert: Should return the value that should have been converted',
      () {
    // Arrange
    final expected = 5;
    final exception = InvalidPermissionException(expected);

    // Act
    final actual = exception.valueToConvert;

    // Assert
    expect(actual, expected);
  });

  test('toString: Should return a description of the exception', () {
    // Arrange
    final expected =
        'Unable to convert the value "5" into a LocationPermission.';
    final exception = InvalidPermissionException(5);

    // Act
    final actual = exception.toString();

    // Assert
    expect(actual, expected);
  });
}
