/// Represent the possible location permissions.
enum LocationPermission {
  /// Permission to access the device's location is denied, but you should
  /// request permission. 
  /// 
  /// On iOS this is the initial status indicting the App has not requested 
  /// permission yet.
  /// On Android this is also the initial status, however the user can still
  /// choose to deny permissions for now, meaning the App can still request
  /// for permission anohter time.
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
  always
}
