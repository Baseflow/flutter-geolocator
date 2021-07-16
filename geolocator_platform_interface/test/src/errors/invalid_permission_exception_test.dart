import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';

void main() {
  test(
      'valueToConvert: Should return the value that should have been converted',
      () {
    // Arrange
    const expected = 5;
    const exception = InvalidPermissionException(expected);

    // Act
    final actual = exception.valueToConvert;

    // Assert
    expect(actual, expected);
  });

  test('toString: Should return a description of the exception', () {
    // Arrange
    const expected =
        'Unable to convert the value "5" into a LocationPermission.';
    const exception = InvalidPermissionException(5);

    // Act
    final actual = exception.toString();

    // Assert
    expect(actual, expected);
  });
}
