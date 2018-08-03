package com.baseflow.flutter.plugin.geolocator.tasks;

import android.location.Location;
import android.location.LocationManager;

import com.baseflow.flutter.plugin.geolocator.data.LocationMapper;
import com.baseflow.flutter.plugin.geolocator.data.Result;

public class LastKnownLocationTask extends LocationTask {

    public LastKnownLocationTask(TaskContext context) {
        super(context);
    }

    @Override
    protected void acquirePosition() {
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
            return;
        }

        result.success(LocationMapper.toHashMap(bestLocation));
    }

    @Override
    protected void handleError(String code, String message) {
        getTaskContext().getResult().error(
                code,
                message,
                null);
    }
}
