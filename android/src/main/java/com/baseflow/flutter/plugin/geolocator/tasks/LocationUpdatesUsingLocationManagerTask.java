package com.baseflow.flutter.plugin.geolocator.tasks;

import android.location.Criteria;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.location.LocationProvider;
import android.os.Bundle;
import android.os.Looper;

import com.baseflow.flutter.plugin.geolocator.data.GeolocationAccuracy;
import com.baseflow.flutter.plugin.geolocator.data.LocationMapper;
import com.google.android.gms.common.util.Strings;

import java.util.List;
import java.util.Map;

class LocationUpdatesUsingLocationManagerTask extends LocationUsingLocationManagerTask implements LocationListener {
    private final boolean mStopAfterFirstLocationUpdate;
    private Location mBestLocation;
    private String mActiveProvider;

    public LocationUpdatesUsingLocationManagerTask(TaskContext context, boolean stopAfterFirstLocationUpdate) {
        super(context);

        mStopAfterFirstLocationUpdate = stopAfterFirstLocationUpdate;
    }

    @Override
    public void startTask() {

        LocationManager locationManager = getLocationManager();

        // Make sure we remove existing listeners before we register a new one
        locationManager.removeUpdates(this);

        // Try to get the best possible location provider for the requested accuracy
        mActiveProvider = getBestProvider(
                locationManager,
                mLocationOptions.accuracy);

        if(Strings.isEmptyOrWhitespace(mActiveProvider)) {
            handleError();

            return;
        }

        mBestLocation = locationManager.getLastKnownLocation(mActiveProvider);

        // If we are listening to multiple location updates we can go ahead
        // and report back the last known location (if we have one).
        if(!mStopAfterFirstLocationUpdate && mBestLocation != null) {
            reportLocationUpdate(mBestLocation);
        }

        Looper looper = Looper.myLooper();
        if(looper == null) {
            looper = Looper.getMainLooper();
        }

        locationManager.requestLocationUpdates(
                mActiveProvider,
                0,
                mLocationOptions.distanceFilter,
                this,
                looper);
    }

    @Override
    public void stopTask() {
        super.stopTask();

        LocationManager locationManager = getLocationManager();
        locationManager.removeUpdates(this);
    }

    void handleError() {
        getTaskContext().getResult().error(
                "INVALID_LOCATION_SETTINGS",
                "Location settings are inadequate, check your location settings.",
                null);
    }

    String getBestProvider(LocationManager locationManager, GeolocationAccuracy accuracy) {
        Criteria criteria = new Criteria();

        criteria.setBearingRequired(false);
        criteria.setAltitudeRequired(false);
        criteria.setSpeedRequired(false);

        switch(accuracy) {
            case Lowest:
                criteria.setAccuracy(Criteria.NO_REQUIREMENT);
                criteria.setHorizontalAccuracy(Criteria.NO_REQUIREMENT);
                criteria.setPowerRequirement(Criteria.NO_REQUIREMENT);
                break;
            case Low:
                criteria.setAccuracy(Criteria.ACCURACY_COARSE);
                criteria.setHorizontalAccuracy(Criteria.ACCURACY_LOW);
                criteria.setPowerRequirement(Criteria.NO_REQUIREMENT);
                break;
            case Medium:
                criteria.setAccuracy(Criteria.ACCURACY_COARSE);
                criteria.setHorizontalAccuracy(Criteria.ACCURACY_MEDIUM);
                criteria.setPowerRequirement(Criteria.POWER_MEDIUM);
                break;
            case High:
                criteria.setAccuracy(Criteria.ACCURACY_FINE);
                criteria.setHorizontalAccuracy(Criteria.ACCURACY_HIGH);
                criteria.setPowerRequirement(Criteria.POWER_HIGH);
                break;
            case Best:
                criteria.setAccuracy(Criteria.ACCURACY_FINE);
                criteria.setHorizontalAccuracy(Criteria.ACCURACY_HIGH);
                criteria.setPowerRequirement(Criteria.POWER_HIGH);
                break;
        }

        String provider = locationManager.getBestProvider(criteria, true);

        if(Strings.isEmptyOrWhitespace(provider)) {
            List<String> providers = locationManager.getProviders(true);
            if(providers != null && providers.size() > 0)
                provider = providers.get(0);
        }

        return provider;
    }

    @Override
    public synchronized void onLocationChanged(Location location) {
        float desiredAccuracy = accuracyToFloat(mLocationOptions.accuracy);
        if(LocationUsingLocationManagerTask.isBetterLocation(location, mBestLocation) && location.getAccuracy() <= desiredAccuracy) {
            mBestLocation = location;
            reportLocationUpdate(location);

            if(mStopAfterFirstLocationUpdate) {
                this.stopTask();
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
            getTaskContext().getResult().error(
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

    private void reportLocationUpdate(Location location) {
        Map<String, Double> locationMap = LocationMapper.toHashMap(location);

        getTaskContext().getResult().success(locationMap);
    }
}
