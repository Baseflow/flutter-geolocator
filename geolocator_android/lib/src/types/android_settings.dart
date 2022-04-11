import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';

import 'foreground_settings.dart';

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
    this.intervalDuration,
    Duration? timeLimit,
    this.foregroundNotificationConfig,
    this.useMSLAltitude = false,
  }) : super(
            accuracy: accuracy,
            distanceFilter: distanceFilter,
            timeLimit: timeLimit);

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

  /// Set to true if altitude should be calculated as MSL (EGM2008) from NMEA message
  /// and reported as the altitude instead of using the geoidal height (WSG84). Setting
  /// this property true will help to align Android altitude to that of iOS which uses MSL.
  ///
  /// MSL Altitude is only available starting from Android N.
  final bool useMSLAltitude;

  /// The desired interval for active location updates.
  ///
  /// If this value is `null` an interval duration of 5000ms is applied.
  final Duration? intervalDuration;

  /// If this is set then the services is started as a Foreground service with a persistent notification
  /// showing the user that the service will continue running in the background.
  final ForegroundNotificationConfig? foregroundNotificationConfig;

  @override
  Map<String, dynamic> toJson() {
    return super.toJson()
      ..addAll({
        'forceLocationManager': forceLocationManager,
        'timeInterval': intervalDuration?.inMilliseconds,
        'useMSLAltitude': useMSLAltitude,
        'foregroundNotificationConfig': foregroundNotificationConfig?.toJson(),
      });
  }
}
