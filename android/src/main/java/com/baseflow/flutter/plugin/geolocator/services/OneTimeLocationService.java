package com.baseflow.flutter.plugin.geolocator.services;

import android.location.Location;
import android.location.LocationManager;

import java.util.UUID;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class OneTimeLocationService extends LocationService {
    private final MethodChannel.Result mResult;

    public OneTimeLocationService(UUID taskID, MethodChannel.Result result, PluginRegistry.Registrar registrar)
    {
        super(taskID, registrar);

        mResult = result;
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

        if(bestLocation == null) {
            handleError("ERROR", "Failed to get location");
            return;
        }

        mResult.success(LocationMapper.toHashMap(bestLocation));
    }

    @Override
    protected void handleError(String code, String message) {
        mResult.error(
                code,
                message,
                null);
    }
}
