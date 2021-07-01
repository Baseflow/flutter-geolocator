import '../enums/enums.dart';

/// Represents different options to configure the quality and frequency
/// of location updates.
class LocationOptions {
  /// Initializes a new [LocationOptions] instance with default values.
  ///
  /// The following default values are used:
  /// - accuracy: best
  /// - defaultIosAccuracyAuthorization: false
  /// - distanceFilter: 0
  /// - forceAndroidLocationManager: false
  /// - timeInterval: 0
  const LocationOptions(
      {this.accuracy = LocationAccuracy.best,
      this.defaultIosAccuracyAuthorization = false,
      this.distanceFilter = 0,
      this.forceAndroidLocationManager = false,
      this.timeInterval = 0});

  /// Defines the desired accuracy that should be used to determine the
  /// location data.
  ///
  /// The default value for this field is [LocationAccuracy.best].
  final LocationAccuracy accuracy;

  /// Forces the Geolocator plugin to use the default Accuracy Authorization
  /// (iOS only).
  ///
  /// On iOS 13 or below, the default value will always be Precise Accuracy. On
  /// iOS 14+ the default value is Reduced Accuracy, but the value can change
  /// based on the choice of the user.
  final bool defaultIosAccuracyAuthorization;

  /// The minimum distance (measured in meters) a device must move
  /// horizontally before an update event is generated.
  ///
  /// Supply 0 when you want to be notified of all movements. The default is 0.
  final int distanceFilter;

  /// Forces the Geolocator plugin to use the legacy LocationManager instead of
  /// the FusedLocationProviderClient (Android only).
  ///
  /// Internally the Geolocator will check if Google Play Services are installed
  /// on the device. If they are not installed the Geolocator plugin will
  /// automatically switch to the LocationManager implementation. However if you
  /// want to force the Geolocator plugin to use the LocationManager
  /// implementation even when the Google Play Services are installed you could
  /// set this property to true.
  final bool forceAndroidLocationManager;

  /// The desired interval for active location updates, in milliseconds
  /// (Android only).
  ///
  /// On iOS this value is ignored since position updates based on time
  /// intervals are not supported.
  final int timeInterval;

  /// Serializes the [LocationOptions] to a map message.
  Map<String, dynamic> toJson() => <String, dynamic>{
        'accuracy': accuracy.index,
        'defaultIosAccuracyAuthorization': defaultIosAccuracyAuthorization,
        'distanceFilter': distanceFilter,
        'forceAndroidLocationManager': forceAndroidLocationManager,
        'timeInterval': timeInterval
      };
}
