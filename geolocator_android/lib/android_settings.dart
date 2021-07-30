import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';

/// Represents different Android specific settings with which you can set a value
/// other then the default value of the setting.
class AndroidSettings extends LocationSettings {
  /// Initializes a new [AndroidSpecificSettings] instance with default values.
  ///
  /// The following default values are used:
  /// - forceLocationManager: false
  AndroidSettings({
    this.forceLocationManager = false,
    LocationAccuracy accuracy = LocationAccuracy.best,
    int distanceFilter = 0,
    Duration? intervalDuration,
  }) : super(
            accuracy: accuracy,
            distanceFilter: distanceFilter,
            intervalDuration: intervalDuration);

  /// Forces the Geolocator plugin to use the legacy LocationManager instead of
  /// the FusedLocationProviderClient (Android only).
  ///
  /// Internally the Geolocator will check if Google Play Services are installed
  /// on the device. If they are not installed the Geolocator plugin will
  /// automatically switch to the LocationManager implementation. However if you
  /// want to force the Geolocator plugin to use the LocationManager
  /// implementation even when the Google Play Services are installed you could
  /// set this property to true.
  final bool forceLocationManager;

  @override
  Map<String, dynamic> toJson() {
    return super.toJson()
      ..addAll({
        'forceLocationManager': forceLocationManager,
      });
  }
}
