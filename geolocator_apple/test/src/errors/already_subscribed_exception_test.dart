import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';

void main() {
  test('toString: Should return a description of the exception', () {
    // Arrange
    const expected = 'The App is already listening to a stream of position '
        'updates. It is not possible to listen to more then one stream at the '
        'same time.';
    const exception = AlreadySubscribedException();

    // Act
    final actual = exception.toString();

    // Assert
    expect(actual, expected);
  });
}
