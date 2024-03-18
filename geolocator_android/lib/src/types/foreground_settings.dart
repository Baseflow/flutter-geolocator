import 'dart:ui';

/// Uniquely identifies an Android resource.
class AndroidResource {
  /// The name of the desired resource.
  final String name;

  /// Optional default resource type to find, if "type/" is not included in the name.
  ///
  /// Can be null to require an explicit type.
  final String defType;

  /// Uniquely identifies an Android resource.
  const AndroidResource({
    required this.name,
    this.defType = 'drawable',
  });

  /// Returns a JSON representation of this class.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'defType': defType,
    };
  }
}

/// Configuration for the foreground notification. When this is provided the location service will run as a foreground service.
class ForegroundNotificationConfig {
  /// The title used for the foreground service notification.
 

  /// The body used for the foreground service notification.


  /// The resource name of the icon to be used for the foreground notification.
 

  /// When enabled, a WifiLock is acquired when background execution is started.
  /// This allows the application to keep the Wi-Fi radio awake, even when the
  /// user has not used the device in a while (e.g. for background network
  /// communications).
  ///
  /// Wifi lock permissions should be obtained first by using a permissions library.
  final bool enableWifiLock;

  /// When enabled, a Wakelock is acquired when background execution is
  /// started.
  ///
  /// If this is false then the system can still sleep and all location
  /// events will be received at once when the system wakes up again.
  ///
  /// Wake lock permissions should be obtained first by using a permissions
  /// library.
  final bool enableWakeLock;

  /// When enabled, the displayed notification is persistent and
  /// the user cannot dismiss it
  final bool setOngoing;

  /// Accent color (an ARGB integer like the constants in Color) to be applied
  /// by the standard Style templates when presenting this notification.
  ///
  /// The current template design constructs a colorful header image by
  /// overlaying the icon image (stenciled in white) atop a field of this color.
  /// Alpha components are ignored.
  ///
  /// If this color is null, a system default color is used.
  final Color? color;

  /// Creates an Android specific configuration for the [FlutterBackground] plugin.
  ///

  /// notification.
  /// [notificationIcon] must be a drawable resource.
  /// E. g. if the icon with name "background_icon" is in the "drawable"
  /// resource folder, it should be of value
  /// `AndroidResource(name: 'background_icon', defType: 'drawable').
  /// [enableWifiLock] indicates wether or not a WifiLock is acquired, when the
  /// background execution is started. This allows the application to keep the
  /// Wi-Fi radio awake, even when the user has not used the device in a while.
  /// [enableWakeLock] indicates wether or not a Wakelock is acquired, when the
  /// background execution is started. If this is false then the system can
  /// still sleep and all location events will be received at once when the
  /// system wakes up again.
  /// [setOngoing] indicates wether or not the displayed notification is
  /// persistent and the user cannot dismiss it.
  /// [color] is the accent color that is applied to the [notificationIcon].
  const ForegroundNotificationConfig({
    this.enableWifiLock = false,
    this.enableWakeLock = false,
    this.setOngoing = false,
    this.color,
  });

  /// Returns a JSON representation of this class.
  Map<String, dynamic> toJson() {
    return {
      'enableWakeLock': enableWakeLock,
      'enableWifiLock': enableWifiLock,
      'setOngoing': setOngoing,
      'color': color?.value,
    };
  }
}
