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

public class NmeaMessageManager {

  public NmeaMessageManager() {}

  public void isLocationServiceEnabled(
          @Nullable Context context, LocationServiceListener listener) {
    if (context == null) {
      listener.onLocationServiceError(ErrorCodes.locationServicesDisabled);
    }

    NmeaMessageaClient nmeaMessageaClient = createNmeaClient(context);
    nmeaMessageaClient.isLocationServiceEnabled(listener);
  }

  public void startNmeaUpdates(
      @NonNull NmeaMessageaClient client,
      @Nullable Activity activity,
      @NonNull NmeaChangedCallback nmeaChangedCallback,
      @NonNull ErrorCallback errorCallback) {

    client.startNmeaUpdates(activity, nmeaChangedCallback, errorCallback);
  }

  public void stopNmeaUpdates(NmeaMessageaClient client) {
    client.stopNmeaUpdates();
  }

  @RequiresApi(api = VERSION_CODES.N)
  public NmeaMessageaClient createNmeaClient(
          Context context) {
    return new GnssNmeaMessageClient(context);
  }

}