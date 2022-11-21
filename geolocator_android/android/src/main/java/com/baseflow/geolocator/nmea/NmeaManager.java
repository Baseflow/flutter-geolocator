package com.baseflow.geolocator.nmea;

import android.app.Activity;
import android.content.Context;
import android.os.Build.VERSION_CODES;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;

import com.baseflow.geolocator.errors.ErrorCallback;
import com.baseflow.geolocator.errors.ErrorCodes;
import com.baseflow.geolocator.location.LocationServiceListener;
import com.baseflow.geolocator.permission.PermissionManager;

public class NmeaManager {

  public NmeaManager() {}

  public void isLocationServiceEnabled(
          @Nullable Context context, LocationServiceListener listener) {
    if (context == null) {
      listener.onLocationServiceError(ErrorCodes.locationServicesDisabled);
    }

    NmeaClient nmeaClient = createNmeaClient(context);
    nmeaClient.isLocationServiceEnabled(listener);
  }

  public void startNmeaUpdates(
      @NonNull NmeaClient client,
      @Nullable Activity activity,
      @NonNull NmeaChangedCallback nmeaChangedCallback,
      @NonNull ErrorCallback errorCallback) {

    client.startNmeaUpdates(activity, nmeaChangedCallback, errorCallback);
  }

  public void stopNmeaUpdates(NmeaClient client) {
    client.stopNmeaUpdates();
  }

  @RequiresApi(api = VERSION_CODES.N)
  public NmeaClient createNmeaClient(
          Context context) {
    return new GnssNmeaClient(context);
  }

}