package com.baseflow.flutter.plugin.geolocator.tasks;

import android.location.LocationManager;
import android.os.Looper;

import com.google.android.gms.common.util.Strings;

public class StreamLocationUpdatesTask extends LocationTask {
    private GeolocatorLocationListener mLocationListener;

    public StreamLocationUpdatesTask(TaskContext context) {
        super(context);
    }

    @Override
    public void startTask() {

        LocationManager locationManager = getLocationManager();

        // Make sure we remove existing listeners before we register a new one
        if(mLocationListener != null) {
            locationManager.removeUpdates(mLocationListener);
        }

        // Try to get the best possible location provider for the requested accuracy
        String bestProvider = getBestProvider(
                locationManager,
                mLocationOptions.accuracy);

        if(Strings.isEmptyOrWhitespace(bestProvider)) {
            handleError(
            );

            return;
        }

        mLocationListener = new GeolocatorLocationListener(
                getTaskContext(),
                locationManager,
                mLocationOptions.accuracy,
                false,
                bestProvider);

        Looper looper = Looper.myLooper();
        if(looper == null) {
            looper = Looper.getMainLooper();
        }

        locationManager.requestLocationUpdates(
                bestProvider,
                0,
                mLocationOptions.distanceFilter,
                mLocationListener,
                looper);
    }


}
