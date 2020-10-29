package com.baseflow.geolocator.permission;

public enum LocationPermission {
  /// Permission to access the device's location is denied by the user.
  denied,
  /// Permission to access the device's location is denied for ever. The
  /// permission dialog will not been shown again until the user updates
  /// the permission in the App settings.
  deniedForever,
  /// Permission to access the device's location is allowed only while
  /// the App is in use.
  whileInUse,
  /// Permission to access the device's location is allowed even when the
  /// App is running in the background.
  always;

  public int toInt() {
    switch (this) {
      case denied:
        return 0;
      case deniedForever:
        return 1;
      case whileInUse:
        return 2;
      case always:
        return 3;
      default:
        throw new IndexOutOfBoundsException();
    }
  }
}
