package com.baseflow.geolocator.tasks;

import android.location.Criteria;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.location.LocationProvider;
import android.os.Bundle;
import android.os.Looper;

import com.baseflow.geolocator.data.LocationOptions;
import com.baseflow.geolocator.data.PositionMapper;
import com.google.android.gms.common.util.Strings;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.util.List;
import java.util.Map;

import androidx.annotation.IntDef;

public class LocationUpdatesUsingLocationManagerTask extends LocationUsingLocationManagerTask implements LocationListener {
  private final boolean mStopAfterFirstLocationUpdate;
  private Location mBestLocation;
  private String mActiveProvider;

  final static int GEOLOCATION_ACCURACY_LOWEST = 0;
  final static int GEOLOCATION_ACCURACY_LOW = 1;
  final static int GEOLOCATION_ACCURACY_MEDIUM = 2;
  final static int GEOLOCATION_ACCURACY_HIGH = 3;
  final static int GEOLOCATION_ACCURACY_BEST = 4;
  final static int GEOLOCATION_ACCURACY_BEST_FOR_NAVIGATION = 5;

  @Retention(RetentionPolicy.SOURCE)
  @IntDef({
      GEOLOCATION_ACCURACY_LOWEST,
      GEOLOCATION_ACCURACY_LOW,
      GEOLOCATION_ACCURACY_MEDIUM,
      GEOLOCATION_ACCURACY_HIGH,
      GEOLOCATION_ACCURACY_BEST,
      GEOLOCATION_ACCURACY_BEST_FOR_NAVIGATION,
  })
  public @interface GeolocationAccuracy {
  }


  LocationUpdatesUsingLocationManagerTask(TaskContext<LocationOptions> context, boolean stopAfterFirstLocationUpdate) {
    super(context);

    mStopAfterFirstLocationUpdate = stopAfterFirstLocationUpdate;
  }

  @Override
  public void startTask() {

    LocationManager locationManager = getLocationManager();

    // Make sure we remove existing listeners before we register a new one
    locationManager.removeUpdates(this);

    // Try to get the best possible location provider for the requested accuracy
    mActiveProvider = getBestProvider(locationManager, mLocationOptions.getAccuracy());

    if (Strings.isEmptyOrWhitespace(mActiveProvider)) {
      handleError();

      return;
    }

    mBestLocation = locationManager.getLastKnownLocation(mActiveProvider);

    // If we are listening to multiple location updates we can go ahead
    // and report back the last known location (if we have one).
    if (mStopAfterFirstLocationUpdate && mBestLocation != null) {
      reportLocationUpdate(mBestLocation);
      return;
    }

    Looper looper = Looper.myLooper();
    if (looper == null) {
      looper = Looper.getMainLooper();
    }

    locationManager.requestLocationUpdates(
        mActiveProvider,
        mLocationOptions.getTimeInterval(),
        mLocationOptions.getDistanceFilter(),
        this,
        looper);
  }

  @Override
  public void stopTask() {
    super.stopTask();

    LocationManager locationManager = getLocationManager();
    locationManager.removeUpdates(this);
  }

  private void handleError() {
    getTaskContext().getResult().error(
        "INVALID_LOCATION_SETTINGS",
        "Location settings are inadequate, check your location settings.",
        null);
  }

  private String getBestProvider(LocationManager locationManager, @GeolocationAccuracy int accuracy) {
    Criteria criteria = new Criteria();

    criteria.setBearingRequired(false);
    criteria.setAltitudeRequired(false);
    criteria.setSpeedRequired(false);

    switch (accuracy) {
      case GEOLOCATION_ACCURACY_LOWEST:
        criteria.setAccuracy(Criteria.NO_REQUIREMENT);
        criteria.setHorizontalAccuracy(Criteria.NO_REQUIREMENT);
        criteria.setPowerRequirement(Criteria.NO_REQUIREMENT);
        break;
      case GEOLOCATION_ACCURACY_LOW:
        criteria.setAccuracy(Criteria.ACCURACY_COARSE);
        criteria.setHorizontalAccuracy(Criteria.ACCURACY_LOW);
        criteria.setPowerRequirement(Criteria.NO_REQUIREMENT);
        break;
      case GEOLOCATION_ACCURACY_MEDIUM:
        criteria.setAccuracy(Criteria.ACCURACY_COARSE);
        criteria.setHorizontalAccuracy(Criteria.ACCURACY_MEDIUM);
        criteria.setPowerRequirement(Criteria.POWER_MEDIUM);
        break;
      case GEOLOCATION_ACCURACY_HIGH:
      case GEOLOCATION_ACCURACY_BEST:
      case GEOLOCATION_ACCURACY_BEST_FOR_NAVIGATION:
        criteria.setAccuracy(Criteria.ACCURACY_FINE);
        criteria.setHorizontalAccuracy(Criteria.ACCURACY_HIGH);
        criteria.setPowerRequirement(Criteria.POWER_HIGH);
        break;
    }

    String provider = locationManager.getBestProvider(criteria, true);

    if (Strings.isEmptyOrWhitespace(provider)) {
      List<String> providers = locationManager.getProviders(true);
      if (providers != null && providers.size() > 0)
        provider = providers.get(0);
    }

    return provider;
  }

  @Override
  public synchronized void onLocationChanged(Location location) {
    float desiredAccuracy = accuracyToFloat(mLocationOptions.getAccuracy());
    if (LocationUsingLocationManagerTask.isBetterLocation(location, mBestLocation) && location.getAccuracy() <= desiredAccuracy) {
      mBestLocation = location;
      reportLocationUpdate(location);

      if (mStopAfterFirstLocationUpdate) {
        this.stopTask();
      }
    }
  }

  @Override
  public void onStatusChanged(String provider, int status, Bundle bundle) {
    if (status == LocationProvider.AVAILABLE) {
      onProviderEnabled(provider);
    } else if (status == LocationProvider.OUT_OF_SERVICE) {
      onProviderDisabled(provider);
    }

  }

  @Override
  public void onProviderEnabled(String provider) {

  }

  @Override
  public void onProviderDisabled(String provider) {
    if (provider.equals(mActiveProvider)) {
      getTaskContext().getResult().error(
          "ERROR_UPDATING_LOCATION",
          "The active location provider was disabled. Check if the location services are enabled in the device settings.",
          null);
    }
  }

  private float accuracyToFloat(@GeolocationAccuracy int accuracy) {
    switch (accuracy) {
      case GEOLOCATION_ACCURACY_LOWEST:
      case GEOLOCATION_ACCURACY_LOW:
        return 500;
      case GEOLOCATION_ACCURACY_MEDIUM:
        return 250;
      case GEOLOCATION_ACCURACY_BEST:
      case GEOLOCATION_ACCURACY_BEST_FOR_NAVIGATION:
        return 50;
      default:
        return 100;
    }
  }

  private void reportLocationUpdate(Location location) {
    Map<String, Object> locationMap = PositionMapper.toHashMap(location);

    getTaskContext().getResult().success(locationMap);
  }
}
