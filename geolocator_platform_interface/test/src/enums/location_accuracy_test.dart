import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';

void main() {
  test('LocationAccuracy should contain 6 options', () {
    final values = LocationAccuracy.values;

    expect(values.length, 6);
  });

  test("LocationAccuracy enum should have items in correct index", () {
    final values = LocationAccuracy.values;

    expect(values[0], LocationAccuracy.lowest);
    expect(values[1], LocationAccuracy.low);
    expect(values[2], LocationAccuracy.medium);
    expect(values[3], LocationAccuracy.high);
    expect(values[4], LocationAccuracy.best);
    expect(values[5], LocationAccuracy.bestForNavigation);
  });
}
