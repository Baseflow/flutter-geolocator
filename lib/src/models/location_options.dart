library location_options;

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:geolocator/src/models/location_accuracy.dart';
import 'package:geolocator/src/models/serializers.dart';

part 'location_options.g.dart';

abstract class LocationOptions
    implements Built<LocationOptions, LocationOptionsBuilder> {
  factory LocationOptions([void updates(LocationOptionsBuilder b)]) =>
      _$LocationOptions((LocationOptionsBuilder b) {
        b
          ..accuracy = LocationAccuracy.best
          ..distanceFilter = 0
          ..forceAndroidLocationManager = false
          ..timeInterval = 0
          ..update(updates);
      });

  factory LocationOptions.fromJson(Map<String, dynamic> json) =>
      serializers.deserializeWith(serializer, json);

  factory LocationOptions.fromValues({
    LocationAccuracy accuracy = LocationAccuracy.best,
    int distanceFilter = 0,
    bool forceAndroidLocationManager = false,
    int timeInterval = 0,
  }) {
    return LocationOptions((LocationOptionsBuilder b) {
      b
        ..accuracy = accuracy
        ..distanceFilter = distanceFilter
        ..forceAndroidLocationManager = forceAndroidLocationManager
        ..timeInterval = timeInterval;
    });
  }

  LocationOptions._();

  /// Defines the desired accuracy that should be used to determine the location
  /// data.
  ///
  /// The default value for this field is [LocationAccuracy.best].
  LocationAccuracy get accuracy;

  /// The minimum distance (measured in meters) a device must move horizontally
  /// before an update event is generated.
  ///
  /// Supply 0 when you want to be notified of all movements. The default is 0.
  int get distanceFilter;

  /// Uses [FusedLocationProviderClient] by default and falls back to
  /// [LocationManager] when set to true.
  ///
  /// On platforms other then Android this parameter is ignored.
  bool get forceAndroidLocationManager;

  /// The desired interval for active location updates, in milliseconds
  /// (Android only).
  ///
  /// On iOS this value is ignored since position updates based on time
  /// intervals are not supported.
  int get timeInterval;

  static final LocationOptions defaultOptions = LocationOptions();

  @memoized
  Map<String, dynamic> get json => serializers.serializeWith(serializer, this);

  static Serializer<LocationOptions> get serializer =>
      _$locationOptionsSerializer;
}
