package com.baseflow.geolocator.location;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.baseflow.geolocator.errors.ErrorCallback;
import com.baseflow.geolocator.errors.ErrorCodes;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GoogleApiAvailability;

import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

public class GeolocationManager
    implements io.flutter.plugin.common.PluginRegistry.ActivityResultListener {
  private static final String TAG = "GeolocationManager";

  private static GeolocationManager geolocationManagerInstance = null;

  private final List<LocationClient> locationClients;

  private GeolocationManager() {
    this.locationClients = new CopyOnWriteArrayList<>();
  }

  public static synchronized GeolocationManager getInstance() {
      if (geolocationManagerInstance == null) {
          geolocationManagerInstance = new GeolocationManager();
      }

      return geolocationManagerInstance;
  }

  public void getLastKnownPosition(
      Context context,
      boolean forceLocationManager,
      PositionChangedCallback positionChangedCallback,
      ErrorCallback errorCallback) {

    LocationClient locationClient = createLocationClient(context, forceLocationManager, null);
    locationClient.getLastKnownPosition(positionChangedCallback, errorCallback);
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
      @NonNull LocationClient locationClient,
      @Nullable Activity activity,
      @NonNull PositionChangedCallback positionChangedCallback,
      @NonNull ErrorCallback errorCallback) {

    this.locationClients.add(locationClient);
    locationClient.startPositionUpdates(activity, positionChangedCallback, errorCallback);
  }

  public boolean updateLocationOptions(LocationOptions options) {
      int numClientsUpdated = 0;
      for (LocationClient client : locationClients) {
        client.updateLocationOptions(options);
        numClientsUpdated += 1;
      }
      Log.d(TAG, String.format("Updated LocationOptions for %d LocationClient(s).", numClientsUpdated));
      return numClientsUpdated > 0;
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
    try {
      GoogleApiAvailability googleApiAvailability = GoogleApiAvailability.getInstance();
      int resultCode = googleApiAvailability.isGooglePlayServicesAvailable(context);
      return resultCode == ConnectionResult.SUCCESS;
    }
    // If the Google API class is not available conclude that the play services
    // are unavailable. This might happen when the GMS package has been excluded by
    // the app developer due to its proprietary license.
    catch(NoClassDefFoundError e) {
      return false;
    }
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
