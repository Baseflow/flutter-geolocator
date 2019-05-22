package com.baseflow.geolocator.tasks;

import android.location.Location;
import android.location.LocationManager;

import com.baseflow.geolocator.data.LocationOptions;
import com.baseflow.geolocator.data.PositionMapper;
import com.baseflow.geolocator.data.wrapper.ChannelResponse;

class LastKnownLocationUsingLocationManagerTask extends LocationUsingLocationManagerTask {

  LastKnownLocationUsingLocationManagerTask(TaskContext<LocationOptions> context) {
    super(context);
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
