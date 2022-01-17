/// Represent the possible location permissions.
enum LocationPermission {
  /// Permission to access the device's location is denied, the App should try
  /// to request permission using the `Geolocator.requestPermission()` method.
  denied,

  /// Permission to access the device's location is permenantly denied. When
  /// requestiong permissions the permission dialog will not been shown until
  /// the user updates the permission in the App settings.
  deniedForever,

  /// Permission to access the device's location is allowed only while
  /// the App is in use.
  whileInUse,

  /// Permission to access the device's location is allowed even when the
  /// App is running in the background.
  always,

  /// Permission status is cannot be determined. This permission is only
  /// returned by the `Geolocator.checkPermission()` method on the web platform
  /// for browsers that do not implement the Permission API (see https://developer.mozilla.org/en-US/docs/Web/API/Permissions_API).
  unableToDetermine
}
