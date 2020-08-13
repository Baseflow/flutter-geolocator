package com.baseflow.geolocator.location;

import android.annotation.SuppressLint;
import android.content.Context;
import android.location.Location;
import android.os.Looper;
import android.util.Log;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.baseflow.geolocator.errors.ErrorCallback;
import com.google.android.gms.location.*;

import static com.baseflow.geolocator.location.LocationAccuracy.*;

class FusedLocationClient implements LocationClient {
    private final Context context;
    private final LocationCallback locationCallback;
    private final FusedLocationProviderClient fusedLocationProviderClient;

    @Nullable
    private ErrorCallback errorCallback;
    @Nullable
    private PositionChangedCallback positionChangedCallback;

    public FusedLocationClient(@NonNull Context context) {
        this.context = context;
        this.fusedLocationProviderClient = LocationServices.getFusedLocationProviderClient(context);

        locationCallback = new LocationCallback() {
            @Override
            public void onLocationResult(LocationResult locationResult) {
                if (locationResult == null || positionChangedCallback == null) {
                    return;
                }

                Location location = locationResult.getLastLocation();
                positionChangedCallback.onPositionChanged(location);
            }
        };
    }

    @SuppressLint("MissingPermission")
    @Override
    public void getLastKnownPosition(
            PositionChangedCallback positionChangedCallback,
            ErrorCallback errorCallback) {

        fusedLocationProviderClient.getLastLocation()
                .addOnSuccessListener(positionChangedCallback::onPositionChanged)
                .addOnFailureListener(e -> Log.d("Geolocator", "Error trying to get last the last known GPS location"));
    }

    @SuppressLint("MissingPermission")
    public void startPositionUpdates(
            LocationOptions options,
            PositionChangedCallback positionChangedCallback,
            ErrorCallback errorCallback) {

        this.positionChangedCallback = positionChangedCallback;
        this.errorCallback = errorCallback;

        // Create the location request to start receiving updates
        LocationRequest locationRequest = new LocationRequest();
        locationRequest.setPriority(toPriority(options.getAccuracy()));
        locationRequest.setInterval(options.getTimeInterval());
        locationRequest.setFastestInterval(options.getTimeInterval() / 2);
        locationRequest.setSmallestDisplacement(options.getDistanceFilter());

        fusedLocationProviderClient.requestLocationUpdates(
                locationRequest,
                locationCallback,
                Looper.getMainLooper());

    }

    public void stopPositionUpdates() {
        fusedLocationProviderClient.removeLocationUpdates(locationCallback);
    }

    private static int toPriority(LocationAccuracy locationAccuracy) {
        switch (locationAccuracy) {
            case lowest:
                return LocationRequest.PRIORITY_NO_POWER;
            case low:
                return LocationRequest.PRIORITY_LOW_POWER;
            case medium:
                return LocationRequest.PRIORITY_BALANCED_POWER_ACCURACY;
            default:
                return LocationRequest.PRIORITY_HIGH_ACCURACY;
        }
    }
}
