package com.baseflow.geolocator.location;

public enum LocationAccuracyStatus {
  /// A approximate location will be returned (Approximate location).
  reduced,

  /// The precise location of the device will be returned.
  precise,

  /// When an 'unknown' status is returned, Location Permission is not yet requested or denied
  // (forever).
  unknown,
}
