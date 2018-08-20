package com.baseflow.flutter.plugin.geolocator.tasks;

import android.location.Location;
import android.os.Looper;
import android.support.annotation.NonNull;

import com.baseflow.flutter.plugin.geolocator.data.LocationMapper;
import com.google.android.gms.location.FusedLocationProviderClient;
import com.google.android.gms.location.LocationCallback;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationResult;
import com.google.android.gms.location.LocationServices;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;

import java.util.Map;


class LocationUpdatesUsingLocationServicesTask extends LocationUsingLocationServicesTask {
    private final boolean mStopAfterFirstLocationUpdate;
    private final FusedLocationProviderClient mFusedLocationProviderClient;
    private final LocationCallback mLocationCallback;


    public LocationUpdatesUsingLocationServicesTask(TaskContext taskContext, boolean stopAfterFirstLocationUpdate) {

        super(taskContext);

        mStopAfterFirstLocationUpdate = stopAfterFirstLocationUpdate;
        mFusedLocationProviderClient = LocationServices.getFusedLocationProviderClient(taskContext.getAndroidContext());
        mLocationCallback = new LocationCallback() {
            @Override
            public void onLocationResult(LocationResult locationResult) {
                if (locationResult == null) {
                    return;
                }

                for (Location location : locationResult.getLocations()) {
                    if(location != null) {
                        reportLocationUpdate(location);

                        if (mStopAfterFirstLocationUpdate) {
                            break;
                        }
                    }
                }

                if (mStopAfterFirstLocationUpdate) {
                    stopTask();
                }
            };
        };
    }

    @Override
    public void startTask() {
        // Make sure we remove existing callbacks before we add a new one
        mFusedLocationProviderClient
                .removeLocationUpdates(mLocationCallback)
                .addOnCompleteListener(new OnCompleteListener<Void>() {
                    @Override
                    public void onComplete(@NonNull Task<Void> task) {
                        Looper looper = Looper.myLooper();
                        if(looper == null) {
                            looper = Looper.getMainLooper();
                        }

                        mFusedLocationProviderClient.requestLocationUpdates(
                                createLocationRequest(),
                                mLocationCallback,
                                looper);
                    }
                });
    }

    @Override
    public void stopTask() {
        super.stopTask();

        mFusedLocationProviderClient.removeLocationUpdates(mLocationCallback);
    }

    private LocationRequest createLocationRequest() {
        LocationRequest locationRequest = new LocationRequest();

        float distanceFilter = mLocationOptions.distanceFilter > 0
                ? mLocationOptions.distanceFilter
                : 1;

        locationRequest
                .setInterval(0)
                .setFastestInterval(0)
                .setSmallestDisplacement(distanceFilter);

        switch(mLocationOptions.accuracy) {
            case Low: case Lowest:
                locationRequest.setPriority(LocationRequest.PRIORITY_LOW_POWER);
                break;
            case Medium:
                locationRequest.setPriority(LocationRequest.PRIORITY_BALANCED_POWER_ACCURACY);
                break;
            case High: case Best:
                locationRequest.setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY);
        }

        return locationRequest;
    }

    private void reportLocationUpdate(Location location) {
        Map<String, Double> locationMap = LocationMapper.toHashMap(location);

        getTaskContext().getResult().success(locationMap);
    }
}
