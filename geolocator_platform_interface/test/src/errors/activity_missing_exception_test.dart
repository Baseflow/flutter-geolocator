import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';

void main() {
  test('toString: Should return the default description when message is null',
      () {
    // Arrange
    final expected =
        'Activity is missing. This might happen when running a certain '
        'function from the background that requires a UI element (e.g. '
        'requesting permissions or enabling the location services).';
    final exception = ActivityMissingException(null);

    // Act
    final actual = exception.toString();

    // Assert
    expect(actual, expected);
  });

  test('toString: Should return the default description when message is empty',
      () {
    // Arrange
    final expected =
        'Activity is missing. This might happen when running a certain '
        'function from the background that requires a UI element (e.g. '
        'requesting permissions or enabling the location services).';
    final exception = ActivityMissingException('');

    // Act
    final actual = exception.toString();

    // Assert
    expect(actual, expected);
  });

  test('toString: Should return the message as description', () {
    // Arrange
    final expected = 'Dummy error message.';
    final exception = ActivityMissingException(expected);

    // Act
    final actual = exception.toString();

    // Assert
    expect(actual, expected);
  });
}
