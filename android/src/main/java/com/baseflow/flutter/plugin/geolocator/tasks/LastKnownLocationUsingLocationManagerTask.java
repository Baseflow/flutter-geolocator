package com.baseflow.flutter.plugin.geolocator.tasks;

import android.location.Location;
import android.location.LocationManager;

import com.baseflow.flutter.plugin.geolocator.data.LocationMapper;
import com.baseflow.flutter.plugin.geolocator.data.Result;

class LastKnownLocationUsingLocationManagerTask extends LocationUsingLocationManagerTask {

    public LastKnownLocationUsingLocationManagerTask(TaskContext context) {
        super(context);
    }

    @Override
    public void startTask() {
        LocationManager locationManager = getLocationManager();

        Location bestLocation = null;

        for(String provider: locationManager.getProviders(true)) {
            Location location = locationManager.getLastKnownLocation(provider);

            if(location != null && isBetterLocation(location, bestLocation)) {
                bestLocation = location;
            }
        }

        Result result = getTaskContext().getResult();
        if(bestLocation == null) {
            result.success(null);
            stopTask();
            return;
        }

        result.success(LocationMapper.toHashMap(bestLocation));
        stopTask();
    }
}
