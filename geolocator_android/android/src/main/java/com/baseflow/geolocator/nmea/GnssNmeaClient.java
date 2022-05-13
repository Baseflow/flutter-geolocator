package com.baseflow.geolocator.nmea;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.location.OnNmeaListener;
import android.os.Looper;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.baseflow.geolocator.errors.ErrorCallback;
import com.baseflow.geolocator.errors.ErrorCodes;
import com.baseflow.geolocator.location.LocationServiceListener;


@SuppressLint("NewApi")
public class GnssNmeaClient implements OnNmeaListener, LocationListener,
        NmeaClient {

  public Context context;
  private final LocationManager locationManager;
  @Nullable
  private NmeaChangedCallback nmeaChangedCallback;

  @Nullable
  private ErrorCallback errorCallback;

  private boolean isListening = false;


  public GnssNmeaClient(
          @NonNull Context context) {
    this.locationManager = (LocationManager) context.getSystemService(Context.LOCATION_SERVICE);
    this.context = context;
  }

  @Override
  public void isLocationServiceEnabled(LocationServiceListener listener) {
    if (locationManager == null) {
      listener.onLocationServiceResult(false);
      return;
    }

    listener.onLocationServiceResult(checkLocationService(context));
  }

  @SuppressLint("MissingPermission")
  public void startNmeaUpdates(
      Activity activity,
      NmeaChangedCallback nmeaChangedCallback,
      ErrorCallback errorCallback) {

    if (!checkLocationService(context)) {
      errorCallback.onError(ErrorCodes.locationServicesDisabled);
      return;
    }

    long timeInterval = 10000;
    float distanceFilter = 0;

    this.nmeaChangedCallback = nmeaChangedCallback;
    this.errorCallback = errorCallback;

    this.isListening = true;
    this.locationManager.addNmeaListener(this, null);
    this.locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, timeInterval, distanceFilter, this,
        Looper.getMainLooper());
  }

  @SuppressLint("MissingPermission")
  @Override
  public void stopNmeaUpdates() {
    this.isListening = false;
    this.locationManager.removeUpdates(this);
  }


  @Override
  public void onNmeaMessage(String message, long timestamp) {
    if (this.nmeaChangedCallback != null) {
      this.nmeaChangedCallback.onNmeaMessage(message, timestamp);
    }
  }


  @Override
  public void onLocationChanged(@NonNull Location location) {
  }


  @Override
  public void onProviderEnabled(String s) {
  }

  @SuppressLint("MissingPermission")
  @Override
  public void onProviderDisabled(String provider) {
    if (provider.equals(LocationManager.GPS_PROVIDER)) {
      if (isListening) {
        this.locationManager.removeUpdates(this);
      }

      if (this.errorCallback != null) {
        errorCallback.onError(ErrorCodes.locationServicesDisabled);
      }
    }
  }
}