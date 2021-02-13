import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';

void main() {
  test('LocationPermission should contain 4 options', () {
    final values = LocationPermission.values;

    expect(values.length, 4);
  });

  test('LocationPermission enum should have items in correct index', () {
    final values = LocationPermission.values;

    expect(values[0], LocationPermission.denied);
    expect(values[1], LocationPermission.deniedForever);
    expect(values[2], LocationPermission.whileInUse);
    expect(values[3], LocationPermission.always);
  });
}
