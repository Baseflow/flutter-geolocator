import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';

void main() {
  test('toString: Should return the default description when message is null',
      () {
    // Arrange
    final expected =
        'Permission definitions are not found. Please make sure you have '
        'added the necessary definitions to the configuration file (e.g. '
        'the AndroidManifest.xml on Android or the Info.plist on iOS).';
    final exception = PermissionDefinitionsNotFoundException(null);

    // Act
    final actual = exception.toString();

    // Assert
    expect(actual, expected);
  });

  test('toString: Should return the default description when message is empty',
      () {
    // Arrange
    final expected =
        'Permission definitions are not found. Please make sure you have '
        'added the necessary definitions to the configuration file (e.g. '
        'the AndroidManifest.xml on Android or the Info.plist on iOS).';
    final exception = PermissionDefinitionsNotFoundException('');

    // Act
    final actual = exception.toString();

    // Assert
    expect(actual, expected);
  });

  test('toString: Should return the message as description', () {
    // Arrange
    final expected = 'Dummy error message.';
    final exception = PermissionDefinitionsNotFoundException(expected);

    // Act
    final actual = exception.toString();

    // Assert
    expect(actual, expected);
  });
}
