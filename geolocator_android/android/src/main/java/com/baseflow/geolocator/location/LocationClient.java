package com.baseflow.geolocator.location;

import android.app.Activity;

import android.content.Context;
import android.location.LocationManager;
import com.baseflow.geolocator.errors.ErrorCallback;

public interface LocationClient {
  void isLocationServiceEnabled(LocationServiceListener listener);

  void getLastKnownPosition(
      PositionChangedCallback positionChangedCallback, ErrorCallback errorCallback);

  boolean onActivityResult(int requestCode, int resultCode);

  void startPositionUpdates(
      Activity activity,
      PositionChangedCallback positionChangedCallback,
      ErrorCallback errorCallback);

  void stopPositionUpdates();
  
  default boolean checkLocationService(Context context){
    LocationManager locationManager = (LocationManager) context.getSystemService(Context.LOCATION_SERVICE);
    boolean gps_enabled = locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER);
    boolean network_enabled = locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER);
    return gps_enabled || network_enabled;
  }
}
