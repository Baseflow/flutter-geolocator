package com.baseflow.flutter.plugin.geolocator.services;

import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.os.Looper;

import com.baseflow.flutter.plugin.geolocator.GeolocationAccuracy;
import com.google.android.gms.common.util.Strings;

import java.util.UUID;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.PluginRegistry;

public class StreamLocationService extends LocationService {
    private final EventChannel.EventSink mEventSink;

    private StreamLocationListener mLocationListener;

    public StreamLocationService(UUID taskID,
                                 EventChannel.EventSink eventSink,
                                 PluginRegistry.Registrar registrar)
    {
        super(taskID, registrar);

        mEventSink = eventSink;
    }

    @Override
    protected void acquirePosition() {

        LocationManager locationManager = getLocationManager();

        // Make sure we remove existing listeners before we register a new one
        if(mLocationListener != null) {
            locationManager.removeUpdates(mLocationListener);
        }

        // Try to get the best possible location provider for the requested accuracy
        String bestProvider = getBestProvider(locationManager, mAccuracy);

        if(Strings.isEmptyOrWhitespace(bestProvider)) {
            handleError(
                    "INVALID_LOCATION_SETTINGS",
                    "Location settings are inadequate, check your location settings.");

            return;
        }

        mLocationListener = new StreamLocationListener(
                locationManager,
                mAccuracy,
                bestProvider);

        Looper looper = Looper.myLooper();
        if(looper == null) {
            looper = Looper.getMainLooper();
        }

        locationManager.requestLocationUpdates(
                bestProvider,
                0,
                0,
                mLocationListener,
                looper);
    }

    @Override
    public void stopTracking() {
        LocationManager locationManager = getLocationManager();
        locationManager.removeUpdates(mLocationListener);

        super.stopTracking();
    }

    @Override
    protected void handleError(String code, String message) {
        mEventSink.error(
                code,
                message,
                null);
    }

    class StreamLocationListener implements LocationListener {

        float mDesiredAccuracy;
        String mActiveProvider;
        Location mBestLocation;

        StreamLocationListener(
                LocationManager locationManager,
                GeolocationAccuracy desiredAccuracy,
                String provider) {

            mDesiredAccuracy = accuracyToFloat(desiredAccuracy);
            mActiveProvider = provider;
            mBestLocation = locationManager.getLastKnownLocation(provider);
        }

        @Override
        public synchronized void onLocationChanged(Location location) {
            if(isBetterLocation(location, mBestLocation) && location.getAccuracy() <= mDesiredAccuracy) {
                mBestLocation = location;
                mEventSink.success(LocationMapper.toHashMap(location));
                return;
            }
        }

        @Override
        public void onStatusChanged(String s, int i, Bundle bundle) {

        }

        @Override
        public void onProviderEnabled(String s) {

        }

        @Override
        public void onProviderDisabled(String s) {

        }

        float accuracyToFloat(GeolocationAccuracy accuracy) {
            switch(accuracy) {
                case Lowest: case Low: return 500;
                case Medium: return 250;
                case High: return 100;
                case Best: return 50;
                default: return 100;
            }
        }
    }
}
