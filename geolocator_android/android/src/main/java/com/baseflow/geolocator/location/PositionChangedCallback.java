package com.baseflow.geolocator.location;

import android.location.Location;

@FunctionalInterface
public interface PositionChangedCallback {
  void onPositionChanged(Location location);
}
