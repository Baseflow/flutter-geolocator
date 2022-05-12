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
  }) : super(
            accuracy: accuracy,
            distanceFilter: distanceFilter,
            timeLimit: timeLimit);

  /// Forces the Geolocator plugin to use the legacy LocationManager instead of
  /// the FusedLocationProviderClient (Android only).
  ///
  /// Internally the Geolocator will check if Google Play Services are installed
  /// on the device and not excluded as a dependency. If they are not installed
  /// or excluded as a dependency the Geolocator plugin will automatically
  /// switch to the LocationManager implementation. However if you want to force
  /// the Geolocator plugin to use the LocationManager implementation even when
  /// the Google Play Services are installed you could set this property to
  /// true.
  ///
  /// To exclude Google mobile services from your app (for example because you
  /// want to publish your app to the F-Droid app store) you can add the
  /// following code to your `android/app/build.gradle` file:
  /// ```gradle
  /// configurations.implementation {
  ///   exclude group: 'com.google.android.gms'
  /// }
  /// ```
  final bool forceLocationManager;

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
        'foregroundNotificationConfig': foregroundNotificationConfig?.toJson(),
      });
  }
}
