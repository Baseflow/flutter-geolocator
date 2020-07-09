/// Represent the possible location permissions.
enum LocationPermission {
  /// Permission to access the device's location is denied by the user.
  denied,
  /// Android only: Permission to access the device's location is denied
  /// for ever. The permission dialog will not been shown again until the 
  /// user updates the permission in the App settings.
  deniedForever,
  /// Permission to access the device's location is allowed only while
  /// the App is in use.
  whileInUse,
  /// Permission to access the device's location is allowed even when the 
  /// App is running in the background.
  always
}