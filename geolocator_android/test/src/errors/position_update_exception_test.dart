import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';

void main() {
  test('toString: Should return the default description when message is null',
      () {
    // Arrange
    const expected =
        'Something went wrong while listening for position updates.';
    const exception = PositionUpdateException(null);

    // Act
    final actual = exception.toString();

    // Assert
    expect(actual, expected);
  });

  test('toString: Should return the default description when message is empty',
      () {
    // Arrange
    const expected =
        'Something went wrong while listening for position updates.';
    const exception = PositionUpdateException('');

    // Act
    final actual = exception.toString();

    // Assert
    expect(actual, expected);
  });

  test('toString: Should return the message as description', () {
    // Arrange
    const expected = 'Dummy error message.';
    const exception = PositionUpdateException(expected);

    // Act
    final actual = exception.toString();

    // Assert
    expect(actual, expected);
  });
}
