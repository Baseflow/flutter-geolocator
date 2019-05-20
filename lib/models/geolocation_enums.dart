part of geolocator;

enum GeolocationPermission {
  /// Android: Fine and Coarse Location
  /// iOS: CoreLocation (Always and WhenInUse)
  location,

  /// Android: Fine and Coarse Location
  /// iOS: CoreLocation - Always
  locationAlways,

  /// Android: Fine and Coarse Location
  /// iOS: CoreLocation - WhenInUse
  locationWhenInUse,
}

enum GeolocationStatus {
  /// Permission to access the requested feature is denied by the user.
  denied,

  /// Permission to access the requested feature is granted by the user.
  granted,

  /// The user granted restricted access to the requested feature (only on iOS).
  restricted,

  /// Permission is in an unknown state
  unknown
}

class _GeolocationStatusConverter {
  static GeolocationStatus fromPermissionStatus(
      PermissionStatus permissionStatus) {
    switch (permissionStatus) {
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

  static LocationPermissionLevel toPermissionLevel(
      GeolocationPermission geolocationPermission) {
    switch (geolocationPermission) {
      case GeolocationPermission.locationAlways:
        return LocationPermissionLevel.locationAlways;
      case GeolocationPermission.locationWhenInUse:
        return LocationPermissionLevel.locationWhenInUse;
      default:
        return LocationPermissionLevel.location;
    }
  }
}