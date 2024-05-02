package com.baseflow.geolocator.location;

import android.Manifest;
import android.content.Context;
import android.content.pm.PackageManager;

import androidx.core.content.ContextCompat;

import com.baseflow.geolocator.errors.ErrorCallback;
import com.baseflow.geolocator.errors.ErrorCodes;

public class LocationAccuracyManager {

    private LocationAccuracyManager() {}

  private static LocationAccuracyManager locationAccuracyManagerInstance = null;

  public static synchronized LocationAccuracyManager getInstance() {
    if (locationAccuracyManagerInstance == null) {
      locationAccuracyManagerInstance = new LocationAccuracyManager();
    }

    return locationAccuracyManagerInstance;
  }

  public LocationAccuracyStatus getLocationAccuracy(Context context, ErrorCallback errorCallback) {
    if (ContextCompat.checkSelfPermission(context, Manifest.permission.ACCESS_FINE_LOCATION)
        == PackageManager.PERMISSION_GRANTED) {
      return LocationAccuracyStatus.precise;
    } else if (ContextCompat.checkSelfPermission(
            context, Manifest.permission.ACCESS_COARSE_LOCATION)
        == PackageManager.PERMISSION_GRANTED) {
      return LocationAccuracyStatus.reduced;
    } else {
      errorCallback.onError(ErrorCodes.permissionDenied);
      return null;
    }
  }
}
