package com.baseflow.flutter.plugin.geolocator.tasks;

import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.location.LocationProvider;
import android.os.Bundle;

import com.baseflow.flutter.plugin.geolocator.data.GeolocationAccuracy;
import com.baseflow.flutter.plugin.geolocator.data.LocationMapper;

class GeolocatorLocationListener implements LocationListener {

    private final TaskContext mTaskContext;
    private final float mDesiredAccuracy;
    private final String mActiveProvider;
    private final boolean mStopAfterFirstLocationUpdate;
    private final LocationManager mLocationManager;

    private Location mBestLocation;

    GeolocatorLocationListener(
            TaskContext taskContext,
            LocationManager locationManager,
            GeolocationAccuracy desiredAccuracy,
            boolean stopAfterFirstLocationUpdate,
            String provider) {

        mTaskContext = taskContext;
        mDesiredAccuracy = accuracyToFloat(desiredAccuracy);
        mLocationManager = locationManager;
        mActiveProvider = provider;
        mStopAfterFirstLocationUpdate = stopAfterFirstLocationUpdate;
        mBestLocation = locationManager.getLastKnownLocation(provider);
    }

    @Override
    public synchronized void onLocationChanged(Location location) {
        if(LocationTask.isBetterLocation(location, mBestLocation) && location.getAccuracy() <= mDesiredAccuracy) {
            mBestLocation = location;
            mTaskContext.getResult().success(LocationMapper.toHashMap(location));

            if(mStopAfterFirstLocationUpdate) {
                mLocationManager.removeUpdates(this);
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
        if(provider.equals(mActiveProvider)) {
            mTaskContext.getResult().error(
                    "ERROR_UPDATING_LOCATION",
                    "The active location provider was disabled. Check if the location services are enabled in the device settings.",
                    null);
        }
    }

    private float accuracyToFloat(GeolocationAccuracy accuracy) {
        switch(accuracy) {
            case Lowest: case Low: return 500;
            case Medium: return 250;
            case High: return 100;
            case Best: return 50;
            default: return 100;
        }
    }
}