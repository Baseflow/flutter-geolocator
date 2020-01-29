part of geolocator;

/// Represents all possible permission values used by the [Geolocation] plugin.
class GeolocationPermission {
  const GeolocationPermission._(this.value);

  /// The current permission value.
  final int value;

  /// Android: Fine and Coarse Location
  /// iOS: CoreLocation (Always and WhenInUse)
  static const GeolocationPermission location = GeolocationPermission._(0);

  /// Android: Fine and Coarse Location
  /// iOS: CoreLocation - Always
  static const GeolocationPermission locationAlways =
      GeolocationPermission._(1);

  /// Android: Fine and Coarse Location
  /// iOS: CoreLocation - WhenInUse
  static const GeolocationPermission locationWhenInUse =
      GeolocationPermission._(2);

  /// List with all possible permission values
  static const List<GeolocationPermission> values = <GeolocationPermission>[
    location,
    locationAlways,
    locationWhenInUse,
  ];

  static const List<String> _names = <String>[
    'location',
    'locationAlways',
    'locationWhenInUse',
  ];

  @override
  String toString() => 'GeolocationPermission.${_names[value]}';
}

/// Represents all possible permission states.
class GeolocationStatus {
  const GeolocationStatus._(this.value);

  /// The current permission status.
  final int value;

  /// Permission to access the requested feature is denied by the user.
  static const GeolocationStatus denied = GeolocationStatus._(0);

  /// The feature is disabled (or not available) on the device.
  static const GeolocationStatus disabled = GeolocationStatus._(1);

  /// Permission to access the requested feature is granted by the user.
  static const GeolocationStatus granted = GeolocationStatus._(2);

  /// The user granted restricted access to the requested feature (only on iOS).
  static const GeolocationStatus restricted = GeolocationStatus._(3);

  /// Permission is in an unknown state
  static const GeolocationStatus unknown = GeolocationStatus._(4);

  /// A list containing all possible permission states.
  static const List<GeolocationStatus> values = <GeolocationStatus>[
    denied,
    disabled,
    granted,
    restricted,
    unknown,
  ];

  static const List<String> _names = <String>[
    'denied',
    'disabled',
    'granted',
    'restricted',
    'unknown',
  ];

  @override
  String toString() => 'GeolocationStatus.${_names[value]}';
}

/// Translates the [PermissionStatus] object to a [GeolocationStatus] object.
GeolocationStatus fromPermissionStatus(PermissionStatus status) {
  switch (status) {
    case PermissionStatus.denied:
      return GeolocationStatus.denied;
    case PermissionStatus.granted:
      return GeolocationStatus.granted;
    case PermissionStatus.restricted:
      return GeolocationStatus.restricted;
    default:
      return GeolocationStatus.unknown;
  }
}

/// Translates a [GeolocationPermission] object to a [LocationPermissionLevel] object.
LocationPermissionLevel toPermissionLevel(GeolocationPermission permission) {
  switch (permission) {
    case GeolocationPermission.locationAlways:
      return LocationPermissionLevel.locationAlways;
    case GeolocationPermission.locationWhenInUse:
      return LocationPermissionLevel.locationWhenInUse;
    default:
      return LocationPermissionLevel.location;
  }
}
