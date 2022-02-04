import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';

void main() {
  test('LocationPermission should contain 4 options', () {
    const values = LocationPermission.values;

    expect(values.length, 5);
  });

  test('LocationPermission enum should have items in correct index', () {
    const values = LocationPermission.values;

    expect(values[0], LocationPermission.denied);
    expect(values[1], LocationPermission.deniedForever);
    expect(values[2], LocationPermission.whileInUse);
    expect(values[3], LocationPermission.always);
    expect(values[4], LocationPermission.unableToDetermine);
  });
}
