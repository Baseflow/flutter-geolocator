package com.baseflow.geolocator.location;

import android.annotation.SuppressLint;
import android.content.Context;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.location.OnNmeaMessageListener;
import android.os.Build.VERSION_CODES;
import android.os.Bundle;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import com.baseflow.geolocator.errors.ErrorCallback;


@RequiresApi(api = VERSION_CODES.N)
public class GnssNmeaMessageClient implements OnNmeaMessageListener, LocationListener, NmeaMessageaClient {

 private final LocationManager locationManager;
  @Nullable
  private NmeaChangedCallback nmeaChangedCallback;
  @Nullable
  private ErrorCallback errorCallback;


  public GnssNmeaMessageClient(
      @NonNull Context context) {
    this.locationManager = (LocationManager) context.getSystemService(Context.LOCATION_SERVICE);
    this.locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, 10000, 10000f, this);
    this.locationManager.addNmeaListener(this, null);
    System.out.println("gnss nmea client initialized");
  }

  public void startNmeaUpdates(NmeaChangedCallback nmeaChangedCallback,
      ErrorCallback errorCallback) {

    this.nmeaChangedCallback = nmeaChangedCallback;
    this.errorCallback = errorCallback;
  }


  @Override
  public void onNmeaMessage(String s, long l) {
    System.out.println("got nmea message");

    if (this.nmeaChangedCallback != null){
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

  }
}
