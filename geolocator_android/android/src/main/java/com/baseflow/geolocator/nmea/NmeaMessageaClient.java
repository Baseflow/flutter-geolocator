package com.baseflow.geolocator.nmea;

import android.app.Activity;

import android.content.Context;
import android.location.LocationManager;
import com.baseflow.geolocator.errors.ErrorCallback;
import com.baseflow.geolocator.location.LocationServiceListener;

public interface NmeaMessageaClient {
  void isLocationServiceEnabled(LocationServiceListener listener);

  void startNmeaUpdates(Activity activity, NmeaChangedCallback nmeaChangedCallback,
                        ErrorCallback errorCallback);

  void stopNmeaUpdates();

  default boolean checkLocationService(Context context){
    LocationManager locationManager = (LocationManager) context.getSystemService(Context.LOCATION_SERVICE);
    boolean gps_enabled = locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER);
    boolean network_enabled = locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER);
    return gps_enabled || network_enabled;
  }
}