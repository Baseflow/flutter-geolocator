package com.baseflow.geolocator.location;

import android.annotation.SuppressLint;
import android.content.Context;
import android.location.GpsStatus;
import android.location.GpsStatus.Listener;
import android.location.GpsStatus.NmeaListener;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.location.OnNmeaMessageListener;
import android.os.Bundle;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.baseflow.geolocator.errors.ErrorCallback;

@SuppressLint("NewApi")
public class GpsNmeaMessageClient implements LocationListener, GpsStatus.NmeaListener,
    GpsStatus.Listener, NmeaMessageaClient {

  LocationManager locationManager;
  @Nullable
  private NmeaChangedCallback nmeaChangedCallback;
  @Nullable
  private ErrorCallback errorCallback;


  public GpsNmeaMessageClient(
      @NonNull Context context) {
    this.locationManager = (LocationManager) context.getSystemService(Context.LOCATION_SERVICE);
    locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, 10000, 10000f, this);
    locationManager.addNmeaListener(this);
    locationManager.addGpsStatusListener(this);
    System.out.println("gps nmea client initialized");
  }

  public void startNmeaUpdates(NmeaChangedCallback nmeaChangedCallback,
      ErrorCallback errorCallback) {

    this.nmeaChangedCallback = nmeaChangedCallback;
    this.errorCallback = errorCallback;
  }

  @Override
  public void onLocationChanged(@NonNull Location location) {
    System.out.println("Location changed");
  }

  @Override
  public void onProviderEnabled(String s) {
    System.out.println("on provider enabled");
  }

  @Override
  public void onProviderDisabled(String s) {
    System.out.println("provider disabled");
  }

  @Override
  public void onNmeaReceived(long l, String s) {
    System.out.println("nmaerecieved");
    if (this.nmeaChangedCallback != null) {
      this.nmeaChangedCallback.onNmeaMessage(s, l);
    }
  }

  @Override
  public void onGpsStatusChanged(int i) {
    System.out.println("gps status changed");
  }
}
