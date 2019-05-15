package com.baseflow.geolocator.tasks;

import android.location.Location;
import android.os.Looper;

import androidx.annotation.NonNull;
import com.baseflow.geolocator.data.LocationOptions;
import com.baseflow.geolocator.data.PositionMapper;
import com.google.android.gms.location.FusedLocationProviderClient;
import com.google.android.gms.location.LocationCallback;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationResult;
import com.google.android.gms.location.LocationServices;
import com.google.android.gms.tasks.OnCompleteListener;

import java.util.Map;


class LocationUpdatesUsingLocationServicesTask extends LocationUsingLocationServicesTask {
  private final boolean mStopAfterFirstLocationUpdate;
  private final FusedLocationProviderClient mFusedLocationProviderClient;
  private final LocationCallback mLocationCallback;


  LocationUpdatesUsingLocationServicesTask(TaskContext<LocationOptions> taskContext, boolean stopAfterFirstLocationUpdate) {
    super(taskContext);

    mStopAfterFirstLocationUpdate = stopAfterFirstLocationUpdate;
    mFusedLocationProviderClient = LocationServices.getFusedLocationProviderClient(taskContext.getAndroidContext());
    mLocationCallback = new LocationCallback() {
      @Override
      public void onLocationResult(LocationResult locationResult) {
        if (locationResult == null) {
          return;
        }

        for (Location location : locationResult.getLocations()) {
          if (location != null) {
            reportLocationUpdate(location);

            if (mStopAfterFirstLocationUpdate) {
              break;
            }
          }
        }

        if (mStopAfterFirstLocationUpdate) {
          stopTask();
        }
      }
    };
  }

  @Override
  public void startTask() {
    // Make sure we remove existing callbacks before we add a new one
    mFusedLocationProviderClient
      .removeLocationUpdates(mLocationCallback)
      .addOnCompleteListener(new OnCompleteListener<Void>() {
        @Override
        public void onComplete(@NonNull com.google.android.gms.tasks.Task<Void> task) {
          Looper looper = Looper.myLooper();
          if (looper == null) {
            looper = Looper.getMainLooper();
          }

          mFusedLocationProviderClient.requestLocationUpdates(
                  createLocationRequest(),
                  mLocationCallback,
                  looper);
        }
      }
    );
  }

  @Override
  public void stopTask() {
    super.stopTask();

    mFusedLocationProviderClient.removeLocationUpdates(mLocationCallback);
  }

  private LocationRequest createLocationRequest() {
    LocationRequest locationRequest = new LocationRequest();

    locationRequest
        .setInterval(mLocationOptions.getTimeInterval())
        .setFastestInterval(mLocationOptions.getTimeInterval())
        .setSmallestDisplacement(mLocationOptions.getDistanceFilter());

    switch (mLocationOptions.getAccuracy()) {
      case LocationUpdatesUsingLocationManagerTask.GEOLOCATION_ACCURACY_LOW:
      case LocationUpdatesUsingLocationManagerTask.GEOLOCATION_ACCURACY_LOWEST:
        locationRequest.setPriority(LocationRequest.PRIORITY_LOW_POWER);
        break;
      case LocationUpdatesUsingLocationManagerTask.GEOLOCATION_ACCURACY_MEDIUM:
        locationRequest.setPriority(LocationRequest.PRIORITY_BALANCED_POWER_ACCURACY);
        break;
      case LocationUpdatesUsingLocationManagerTask.GEOLOCATION_ACCURACY_HIGH:
      case LocationUpdatesUsingLocationManagerTask.GEOLOCATION_ACCURACY_BEST:
      case LocationUpdatesUsingLocationManagerTask.GEOLOCATION_ACCURACY_BEST_FOR_NAVIGATION:
        locationRequest.setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY);
        break;
    }

    return locationRequest;
  }

  private void reportLocationUpdate(Location location) {
    Map<String, Object> locationMap = PositionMapper.toHashMap(location);

    getTaskContext().getResult().success(locationMap);
  }
}
