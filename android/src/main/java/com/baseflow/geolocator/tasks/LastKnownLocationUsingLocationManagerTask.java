package com.baseflow.geolocator.tasks;

import android.location.Location;
import android.location.LocationManager;

import androidx.annotation.NonNull;
import com.baseflow.geolocator.data.LocationOptions;
import com.baseflow.geolocator.data.PositionMapper;
import com.baseflow.geolocator.data.wrapper.ChannelResponse;
import java.util.UUID;

class LastKnownLocationUsingLocationManagerTask extends LocationUsingLocationManagerTask {

  LastKnownLocationUsingLocationManagerTask(@NonNull UUID taskID, TaskContext<LocationOptions> context) {
    super(taskID, context);
  }

  @Override
  public void startTask() {
    LocationManager locationManager = getLocationManager();

    Location bestLocation = null;

    for (String provider : locationManager.getProviders(true)) {
      Location location = locationManager.getLastKnownLocation(provider);

      if (location != null && isBetterLocation(location, bestLocation)) {
        bestLocation = location;
      }
    }

    ChannelResponse channelResponse = getTaskContext().getResult();
    if (bestLocation == null) {
      channelResponse.success(null);
      stopTask();
      return;
    }

    channelResponse.success(PositionMapper.toHashMap(bestLocation));
    stopTask();
  }
}
