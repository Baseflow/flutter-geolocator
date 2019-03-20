package com.baseflow.flutter.plugin.geolocator.tasks;

import android.location.Location;
import android.location.LocationManager;
import android.os.Build;

import com.baseflow.flutter.plugin.geolocator.data.PositionMapper;
import com.baseflow.flutter.plugin.geolocator.data.Result;

import androidx.annotation.RequiresApi;

class LastKnownLocationUsingLocationManagerTask extends LocationUsingLocationManagerTask {

    LastKnownLocationUsingLocationManagerTask(TaskContext context) {
        super(context);
    }

    @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR2)
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

        result.success(PositionMapper.toHashMap(bestLocation));
        stopTask();
    }
}
