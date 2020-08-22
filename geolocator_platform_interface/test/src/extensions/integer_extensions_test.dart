import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
import 'package:geolocator_platform_interface/src/enums/enums.dart';
import 'package:geolocator_platform_interface/src/extensions/extensions.dart';

void main() {
  test('toLocationPermission: Should return denied when 0 is supplied', () {
    // Arrange
    final expected = LocationPermission.denied;

    // Act
    final actual = 0.toLocationPermission();

    // Assert
    expect(actual, expected);
  });

  test('toLocationPermission: Should return deniedForever when 1 is supplied',
      () {
    // Arrange
    final expected = LocationPermission.deniedForever;

    // Act
    final actual = 1.toLocationPermission();

    // Assert
    expect(actual, expected);
  });

  test('toLocationPermission: Should return whileInUse when 2 is supplied', () {
    // Arrange
    final expected = LocationPermission.whileInUse;

    // Act
    final actual = 2.toLocationPermission();

    // Assert
    expect(actual, expected);
  });

  test('toLocationPermission: Should return always when 4 is supplied', () {
    // Arrange
    final expected = LocationPermission.always;

    // Act
    final actual = 3.toLocationPermission();

    // Assert
    expect(actual, expected);
  });

  test(
      // ignore: lines_longer_than_80_chars
      'toLocationPermission: Should throw an InvalidPermissionException when an illegal value is supplied',
      () {
    // Act & Assert
    expect(
        () => 4.toLocationPermission(),
        throwsA(
          isA<InvalidPermissionException>().having(
            (e) => e.valueToConvert,
            'Value should match the value trying to convert.',
            4,
          ),
        ));
  });
}
