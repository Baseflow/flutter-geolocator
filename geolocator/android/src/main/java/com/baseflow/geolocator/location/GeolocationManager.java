package com.baseflow.geolocator.location;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.baseflow.geolocator.errors.ErrorCallback;
import com.baseflow.geolocator.errors.ErrorCodes;
import com.baseflow.geolocator.permission.PermissionManager;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GoogleApiAvailability;
import io.flutter.plugin.common.PluginRegistry.ActivityResultListener;
import java.util.ArrayList;
import java.util.List;

public class GeolocationManager implements ActivityResultListener {

  @NonNull
  private final PermissionManager permissionManager;
  private final List<LocationClient> locationClients;


  public GeolocationManager(@NonNull PermissionManager permissionManager) {
    this.permissionManager = permissionManager;
    this.locationClients = new ArrayList<>();
  }

  public void getLastKnownPosition(
      Context context,
      Activity activity,
      boolean forceLocationManager,
      PositionChangedCallback positionChangedCallback,
      ErrorCallback errorCallback) {

    permissionManager.handlePermissions(
        context,
        activity,
        () -> {
          LocationClient locationClient = createLocationClient(context, forceLocationManager, null);
          locationClient.getLastKnownPosition(positionChangedCallback, errorCallback);
        },
        errorCallback);
  }

  public void isLocationServiceEnabled(
      @Nullable Context context, LocationServiceListener listener) {
    if (context == null) {
      listener.onLocationServiceError(ErrorCodes.locationServicesDisabled);
    }

    LocationClient locationClient = createLocationClient(context, false, null);
    locationClient.isLocationServiceEnabled(listener);
  }

  public void startPositionUpdates(
      Context context,
      Activity activity,
      LocationClient locationClient,
      PositionChangedCallback positionChangedCallback,
      ErrorCallback errorCallback) {

    this.locationClients.add(locationClient);

    permissionManager.handlePermissions(
        context,
        activity,
        () -> locationClient.startPositionUpdates(activity, positionChangedCallback, errorCallback),
        errorCallback);
  }

  public void stopPositionUpdates(@NonNull LocationClient locationClient) {
    locationClients.remove(locationClient);
    locationClient.stopPositionUpdates();
  }

  public LocationClient createLocationClient(
      Context context,
      boolean forceAndroidLocationManager,
      @Nullable LocationOptions locationOptions) {
    if (forceAndroidLocationManager) {
      return new LocationManagerClient(context, locationOptions);
    }

    return isGooglePlayServicesAvailable(context)
        ? new FusedLocationClient(context, locationOptions)
        : new LocationManagerClient(context, locationOptions);
  }

  private boolean isGooglePlayServicesAvailable(Context context) {
    GoogleApiAvailability googleApiAvailability = GoogleApiAvailability.getInstance();
    int resultCode = googleApiAvailability.isGooglePlayServicesAvailable(context);
    return resultCode == ConnectionResult.SUCCESS;
  }

  @Override
  public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
    for (LocationClient client : this.locationClients) {
      if (client.onActivityResult(requestCode, resultCode)) {
        return true;
      }
    }

    return false;
  }
}
