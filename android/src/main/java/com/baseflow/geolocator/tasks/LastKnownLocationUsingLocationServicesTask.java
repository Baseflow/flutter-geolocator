package com.baseflow.geolocator.tasks;

import com.baseflow.geolocator.data.LocationOptions;
import com.baseflow.geolocator.data.PositionMapper;
import com.google.android.gms.location.FusedLocationProviderClient;
import com.google.android.gms.location.LocationServices;

import java.util.Map;

class LastKnownLocationUsingLocationServicesTask extends LocationUsingLocationServicesTask {
  private final FusedLocationProviderClient mFusedLocationProviderClient;

  LastKnownLocationUsingLocationServicesTask(TaskContext<LocationOptions> taskContext) {
    super(taskContext);

    mFusedLocationProviderClient = LocationServices.getFusedLocationProviderClient(taskContext.getAndroidContext());
  }

  @Override
  public void startTask() {
    mFusedLocationProviderClient.getLastLocation()
        .addOnSuccessListener(location -> {
          Map<String, Object> locationMap = location != null
              ? PositionMapper.toHashMap(location)
              : null;

          getTaskContext().getResult().success(locationMap);

          stopTask();
        })
        .addOnFailureListener(e -> {
          getTaskContext().getResult().error(
              e.getMessage(),
              e.getLocalizedMessage(),
              null);

          stopTask();
        });
  }
}
