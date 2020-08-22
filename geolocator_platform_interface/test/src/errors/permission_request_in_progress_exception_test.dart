import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';

void main() {
  test('toString: Should return the default description when message is null',
      () {
    // Arrange
    final expected =
        'A request for location permissions is already running, please '
        'wait for it to complete before doing another request.';
    final exception = PermissionRequestInProgressException(null);

    // Act
    final actual = exception.toString();

    // Assert
    expect(actual, expected);
  });

  test('toString: Should return the default description when message is empty',
      () {
    // Arrange
    final expected =
        'A request for location permissions is already running, please '
        'wait for it to complete before doing another request.';
    final exception = PermissionRequestInProgressException('');

    // Act
    final actual = exception.toString();

    // Assert
    expect(actual, expected);
  });

  test('toString: Should return the message as description', () {
    // Arrange
    final expected = 'Dummy error message.';
    final exception = PermissionRequestInProgressException(expected);

    // Act
    final actual = exception.toString();

    // Assert
    expect(actual, expected);
  });
}
