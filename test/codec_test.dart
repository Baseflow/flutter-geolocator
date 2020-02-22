import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  test('Given an instance of LocationOptions should return an instance of Map<String, dynamic>', () {
    var locationOptions = LocationOptions(
      accuracy: LocationAccuracy.best,
      distanceFilter: 10,
      forceAndroidLocationManager: true,
      timeInterval: 100,
    );
    var expectedMap = <String, dynamic> {
      'accuracy': 4,
      'distanceFilter': 10,
      'forceAndroidLocationManager': true,
      'timeInterval': 100,
    };

    var actualMap = Codec.encodeLocationOptions(locationOptions);

    expect(actualMap, expectedMap);
  });
}