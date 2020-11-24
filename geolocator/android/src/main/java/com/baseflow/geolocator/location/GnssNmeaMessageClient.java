package com.baseflow.geolocator.location;

import android.annotation.SuppressLint;
import android.content.Context;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.location.OnNmeaMessageListener;
import android.os.Bundle;
import android.os.Looper;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.baseflow.geolocator.errors.ErrorCallback;
import com.baseflow.geolocator.errors.ErrorCodes;


@SuppressLint("NewApi")
public class GnssNmeaMessageClient implements OnNmeaMessageListener, LocationListener,
    NmeaMessageaClient {

  private final LocationManager locationManager;
  @Nullable
  private NmeaChangedCallback nmeaChangedCallback;

  @Nullable
  private ErrorCallback errorCallback;

  private boolean isListening = false;


  public GnssNmeaMessageClient(
      @NonNull Context context) {
    this.locationManager = (LocationManager) context.getSystemService(Context.LOCATION_SERVICE);
  }

  public void startNmeaUpdates(NmeaChangedCallback nmeaChangedCallback,
      ErrorCallback errorCallback) {

    this.locationManager.addNmeaListener(this, null);
    this.locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, 5000, 0, this,
        Looper.getMainLooper());
    this.nmeaChangedCallback = nmeaChangedCallback;
    this.errorCallback = errorCallback;
    this.isListening = true;
  }

  @Override
  public void stopNmeaUpdates() {
    this.isListening = false;
    this.locationManager.removeUpdates(this);
  }


  @Override
  public void onNmeaMessage(String s, long l) {

    if (this.nmeaChangedCallback != null) {
      this.nmeaChangedCallback.onNmeaMessage(s, l);
    }
  }


  @Override
  public void onLocationChanged(@NonNull Location location) {
  }

  @Override
  public void onStatusChanged(String s, int i, Bundle bundle) {

  }


  @Override
  public void onProviderEnabled(String s) {

  }

  @Override
  public void onProviderDisabled(String s) {
    if (s.equals(locationManager.GPS_PROVIDER)) {
      if (isListening) {
        this.locationManager.removeUpdates(this);
      }

      if (this.errorCallback != null) {
        errorCallback.onError(ErrorCodes.locationServicesDisabled);
      }

    }
  }
}
