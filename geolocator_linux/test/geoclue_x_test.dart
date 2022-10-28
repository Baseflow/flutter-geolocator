import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
import 'package:geoclue/geoclue.dart';
import 'package:geolocator_linux/src/geoclue_x.dart';

void main() {
  test('GeoClueLocationAccuracyStatus extension', () async {
    expect(GeoClueAccuracyLevel.none.toStatus(),
        equals(LocationAccuracyStatus.unknown));
    expect(GeoClueAccuracyLevel.exact.toStatus(),
        equals(LocationAccuracyStatus.precise));
    expect(GeoClueAccuracyLevel.city.toStatus(),
        equals(LocationAccuracyStatus.reduced));
  });

  test('GeoCluePosition extension', () async {
    expect(dummyLocation.toPosition(), equals(dummyPosition));
    expect(dummyLocationNull.toPosition(), equals(dummyPositionNull));
  });

  test('GeoClueLocationAccuracy extension', () async {
    expect(LocationAccuracy.reduced.toGeoClueAccuracyLevel(),
        equals(GeoClueAccuracyLevel.country));
    expect(LocationAccuracy.lowest.toGeoClueAccuracyLevel(),
        equals(GeoClueAccuracyLevel.country));
    expect(LocationAccuracy.low.toGeoClueAccuracyLevel(),
        equals(GeoClueAccuracyLevel.city));
    expect(LocationAccuracy.medium.toGeoClueAccuracyLevel(),
        equals(GeoClueAccuracyLevel.neighborhood));
    expect(LocationAccuracy.high.toGeoClueAccuracyLevel(),
        equals(GeoClueAccuracyLevel.street));
    expect(LocationAccuracy.best.toGeoClueAccuracyLevel(),
        equals(GeoClueAccuracyLevel.exact));
    expect(LocationAccuracy.bestForNavigation.toGeoClueAccuracyLevel(),
        equals(GeoClueAccuracyLevel.exact));
  });
}

final dummyLocation = GeoClueLocation(
  accuracy: 1,
  altitude: 2,
  heading: 3,
  latitude: 4,
  longitude: 5,
  speed: 6,
  timestamp: DateTime(2022),
);

final dummyPosition = Position(
  accuracy: 1,
  altitude: 2,
  heading: 3,
  latitude: 4,
  longitude: 5,
  speed: 6,
  speedAccuracy: 0,
  timestamp: DateTime(2022),
);

final dummyLocationNull = GeoClueLocation(
  accuracy: 1,
  latitude: 4,
  longitude: 5,
  timestamp: DateTime(2022),
);

final dummyPositionNull = Position(
  accuracy: 1,
  altitude: 0,
  heading: 0,
  latitude: 4,
  longitude: 5,
  speed: 0,
  speedAccuracy: 0,
  timestamp: DateTime(2022),
);
