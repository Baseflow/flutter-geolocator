package com.baseflow.geolocator.location;

import android.location.Location;

@FunctionalInterface
public interface PositionChangedCallback {
    public void onPositionChanged(Location location);
}
