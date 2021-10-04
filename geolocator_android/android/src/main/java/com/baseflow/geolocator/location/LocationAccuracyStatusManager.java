package com.baseflow.geolocator.location;

import android.Manifest;
import android.content.Context;
import android.content.pm.PackageManager;

import androidx.core.content.ContextCompat;

public class LocationAccuracyStatusManager {

  public LocationAccuracyStatus getLocationAccuracy(Context context) {
    if (ContextCompat.checkSelfPermission(context, Manifest.permission.ACCESS_FINE_LOCATION)
        == PackageManager.PERMISSION_GRANTED) {
      return LocationAccuracyStatus.precise;
    } else if (ContextCompat.checkSelfPermission(
            context, Manifest.permission.ACCESS_COARSE_LOCATION)
        == PackageManager.PERMISSION_GRANTED) {
      return LocationAccuracyStatus.reduced;
    } else {
      return LocationAccuracyStatus.unknown;
    }
  }
}
