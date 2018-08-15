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

  /// The feature is disabled (or not available) on the device.
  disabled,

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
      case PermissionStatus.disabled:
        return GeolocationStatus.disabled;
      case PermissionStatus.granted:
        return GeolocationStatus.granted;
      case PermissionStatus.restricted:
        return GeolocationStatus.restricted;
      default:
        return GeolocationStatus.unknown;
    }
  }

  static PermissionGroup toPermissionGroup(
      GeolocationPermission geolocationPermission) {
    switch (geolocationPermission) {
      case GeolocationPermission.locationAlways:
        return PermissionGroup.locationAlways;
      case GeolocationPermission.locationWhenInUse:
        return PermissionGroup.locationWhenInUse;
      default:
        return PermissionGroup.location;
    }
  }
}
