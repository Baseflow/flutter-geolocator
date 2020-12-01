package com.baseflow.geolocator.nmea;

import android.annotation.SuppressLint;
import android.content.Context;
import android.location.GpsStatus;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.baseflow.geolocator.errors.ErrorCallback;
import com.baseflow.geolocator.errors.ErrorCodes;


public class GpsNmeaMessageClient implements LocationListener, GpsStatus.NmeaListener,
    NmeaMessageaClient {

  LocationManager locationManager;
  @Nullable
  private NmeaChangedCallback nmeaChangedCallback;

  @Nullable
  private ErrorCallback errorCallback;

  private boolean isListening = false;


  public GpsNmeaMessageClient(
      @NonNull Context context) {
    this.locationManager = (LocationManager) context.getSystemService(Context.LOCATION_SERVICE);
  }

  @SuppressLint("MissingPermission")
  public void startNmeaUpdates(NmeaChangedCallback nmeaChangedCallback,
      ErrorCallback errorCallback) {

    locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, 10000, 0, this);
    locationManager.addNmeaListener(this);
    this.nmeaChangedCallback = nmeaChangedCallback;
    this.errorCallback = errorCallback;
    this.isListening = true;
  }

  @SuppressLint("MissingPermission")
  @Override
  public void stopNmeaUpdates() {
    this.isListening = false;
    this.locationManager.removeUpdates(this);
  }

  @Override
  public void onLocationChanged(@NonNull Location location) {
  }

  @Override
  public void onProviderEnabled(String s) {
  }

  @SuppressLint("MissingPermission")
  @Override
  public void onProviderDisabled(String s) {
    if (s.equals(LocationManager.GPS_PROVIDER)) {
      if (isListening) {
        this.locationManager.removeUpdates(this);
      }

      if (this.errorCallback != null) {
        errorCallback.onError(ErrorCodes.locationServicesDisabled);
      }
    }
  }

  @Override
  public void onNmeaReceived(long l, String s) {
    if (this.nmeaChangedCallback != null) {
      this.nmeaChangedCallback.onNmeaMessage(s, l);
    }
  }
}
