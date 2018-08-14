package com.baseflow.flutter.plugin.geolocator.tasks;

import android.location.LocationManager;
import android.os.Looper;
import com.google.android.gms.common.util.Strings;

public class CurrentLocationTask extends LocationTask {
    private GeolocatorLocationListener mLocationListener;

    public CurrentLocationTask(TaskContext context) {
        super(context);
    }

    @Override
    protected void acquirePosition() {

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
                    "INVALID_LOCATION_SETTINGS",
                    "Location settings are inadequate, check your location settings.");

            return;
        }

        mLocationListener = new GeolocatorLocationListener(
                getTaskContext(),
                locationManager,
                mLocationOptions.accuracy,
                true,
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

    @Override
    protected void handleError(String code, String message) {
        getTaskContext().getResult().error(
                code,
                message,
                null);
    }

    @Override
    public void stopTask() {
        super.stopTask();

        LocationManager locationManager = getLocationManager();
        if(mLocationListener != null) {
            locationManager.removeUpdates(mLocationListener);
        }
    }
}
