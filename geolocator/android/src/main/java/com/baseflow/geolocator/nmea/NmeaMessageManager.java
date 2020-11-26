package com.baseflow.geolocator.nmea;


import android.app.Activity;
import android.content.Context;
import android.os.Build.VERSION_CODES;
import androidx.annotation.NonNull;
import com.baseflow.geolocator.errors.ErrorCallback;
import com.baseflow.geolocator.permission.PermissionManager;

public class NmeaMessageManager {

  @NonNull
  private final PermissionManager permissionManager;


  public NmeaMessageManager(@NonNull PermissionManager permissionManager) {
    this.permissionManager = permissionManager;
  }


  public void startNmeaUpdates(Context context, Activity activity, NmeaMessageaClient client,
      NmeaChangedCallback nmeaChangedCallback, ErrorCallback errorCallback) {

    permissionManager.handlePermissions(
        context,
        activity,
        () -> client.startNmeaUpdates(nmeaChangedCallback, errorCallback),
        errorCallback);
  }

  public void stopNmeaUpdates(NmeaMessageaClient client) {
    client.stopNmeaUpdates();
  }

  public NmeaMessageaClient createNmeaClient(Context context) {
    return android.os.Build.VERSION.SDK_INT >= VERSION_CODES.N ? new GnssNmeaMessageClient(context)
        : new GpsNmeaMessageClient(context);
  }

}
