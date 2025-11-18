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
    super.accuracy,
    super.distanceFilter,
    this.intervalDuration,
    super.timeLimit,
    this.foregroundNotificationConfig,
    this.useMSLAltitude = false,
  });

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
  ///
  /// Note: Using this foreground notification does not run your service in the background, it just
  /// increases the priority of your activity making it less likely for Android to kill the activity
  /// when switching between apps. It does not prevent Android from killing the activity. If you want to
  /// receive background location updates even if the activity is destroyed you need to use a third party
  /// background service package that will start a new Flutter Engine that is not tied to your main activity.
  final ForegroundNotificationConfig? foregroundNotificationConfig;

  /// Set to true if altitude should be calculated as MSL (EGM2008) from NMEA messages
  /// and reported as the altitude instead of using the geoidal height (WSG84). Setting
  /// this property true will help to align Android altitude to that of iOS which uses MSL.
  ///
  /// If the NMEA message is empty then the altitude reported will still be the standard WSG84
  /// altitude from the GPS receiver.
  ///
  /// MSL Altitude is only available starting from Android N and not all devices support
  /// NMEA message returning $GPGGA sequences.
  ///
  /// This property only works with position stream updates and has no effect when getting the
  /// current position or last known position.
  ///
  /// Defaults to false
  final bool useMSLAltitude;

  @override
  Map<String, dynamic> toJson() {
    return super.toJson()
      ..addAll({
        'forceLocationManager': forceLocationManager,
        'timeInterval': intervalDuration?.inMilliseconds,
        'foregroundNotificationConfig': foregroundNotificationConfig?.toJson(),
        'useMSLAltitude': useMSLAltitude,
      });
  }
}
