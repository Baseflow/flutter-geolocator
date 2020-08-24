package com.baseflow.geolocator.location;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.content.IntentSender;
import android.location.Location;
import android.location.LocationManager;
import android.os.Looper;
import android.util.Log;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.baseflow.geolocator.errors.ErrorCallback;
import com.baseflow.geolocator.errors.ErrorCodes;
import com.google.android.gms.common.api.ApiException;
import com.google.android.gms.common.api.ResolvableApiException;
import com.google.android.gms.location.*;

class FusedLocationClient implements LocationClient {
    private static final int REQUEST_CHECK_SETTINGS = 0x1;
    private final Context context;
    private final LocationCallback locationCallback;
    private final FusedLocationProviderClient fusedLocationProviderClient;

    @Nullable
    private Activity activity;
    @Nullable
    private LocationOptions locationOptions;
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
                    Log.e("Geolocator", "LocationCallback was called with empty locationResult or no positionChangedCallback was registered.");
                    fusedLocationProviderClient.removeLocationUpdates(locationCallback);
                    if (errorCallback != null) {
                        errorCallback.onError(ErrorCodes.errorWhileAcquiringPosition);
                    }
                    return;
                }

                Location location = locationResult.getLastLocation();
                positionChangedCallback.onPositionChanged(location);
            }
        };
    }

    @Override
    public boolean isLocationServiceEnabled() {
        LocationManager locationManager = (LocationManager) context.getSystemService(Context.LOCATION_SERVICE);

        if (locationManager == null) {
            return false;
        }

        boolean gps_enabled = locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER);
        boolean network_enabled = locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER);

        return gps_enabled || network_enabled;
    }

    @SuppressLint("MissingPermission")
    @Override
    public void getLastKnownPosition(
            PositionChangedCallback positionChangedCallback,
            ErrorCallback errorCallback) {

        fusedLocationProviderClient.getLastLocation()
                .addOnSuccessListener(positionChangedCallback::onPositionChanged)
                .addOnFailureListener(e -> {
                    Log.e("Geolocator", "Error trying to get last the last known GPS location");
                    if (errorCallback != null) {
                        errorCallback.onError(ErrorCodes.errorWhileAcquiringPosition);
                    }
                });
    }

    public boolean onActivityResult(int requestCode, int resultCode) {
        if (requestCode == REQUEST_CHECK_SETTINGS) {
            if (resultCode == Activity.RESULT_OK) {
                if (this.locationOptions == null || this.positionChangedCallback == null || this.errorCallback == null) {
                    return false;
                }

                startPositionUpdates(
                        this.activity,
                        this.locationOptions,
                        this.positionChangedCallback,
                        this.errorCallback);

                return true;
            } else {
                if (errorCallback != null) {
                    errorCallback.onError(ErrorCodes.locationServicesDisabled);
                }
            }
        }

        return false;
    }

    @SuppressLint("MissingPermission")
    public void startPositionUpdates(
            @Nullable Activity activity,
            @NonNull LocationOptions options,
            @NonNull PositionChangedCallback positionChangedCallback,
            @NonNull ErrorCallback errorCallback) {

        this.activity = activity;
        this.locationOptions = options;
        this.positionChangedCallback = positionChangedCallback;
        this.errorCallback = errorCallback;

        LocationRequest locationRequest = buildLocationRequest(options);
        LocationSettingsRequest settingsRequest = buildLocationSettingsRequest(locationRequest);

        SettingsClient settingsClient = LocationServices.getSettingsClient(context);
        settingsClient.checkLocationSettings(settingsRequest)
                .addOnSuccessListener(locationSettingsResponse -> fusedLocationProviderClient.requestLocationUpdates(
                        locationRequest,
                        locationCallback,
                        Looper.getMainLooper()))
                .addOnFailureListener(e -> {
                    if (e instanceof ResolvableApiException) {
                        // When we don't have an activity return an error code explaining the
                        // location services are not enabled
                        if (activity == null) {
                            errorCallback.onError(ErrorCodes.locationServicesDisabled);
                            return;
                        }

                        ResolvableApiException rae = (ResolvableApiException) e;
                        int statusCode = rae.getStatusCode();
                        if (statusCode == LocationSettingsStatusCodes.RESOLUTION_REQUIRED) {
                            try {
                                // Show the dialog by calling startResolutionForResult(), and check the
                                // result in onActivityResult().
                                rae.startResolutionForResult(activity, REQUEST_CHECK_SETTINGS);
                            } catch (IntentSender.SendIntentException sie) {
                                errorCallback.onError(ErrorCodes.locationServicesDisabled);
                            }
                        } else {
                            errorCallback.onError(ErrorCodes.locationServicesDisabled);
                        }
                    } else {
                        ApiException ae = (ApiException) e;
                        int statusCode = ae.getStatusCode();
                        if (statusCode == LocationSettingsStatusCodes.SETTINGS_CHANGE_UNAVAILABLE) {
                            fusedLocationProviderClient.requestLocationUpdates(
                                    locationRequest,
                                    locationCallback,
                                    Looper.getMainLooper());
                        } else {
                            // This should not happen according to Android documentation but it has been
                            // observed on some phones.
                            errorCallback.onError(ErrorCodes.locationServicesDisabled);
                        }
                    }
                });
    }

    public void stopPositionUpdates() {
        fusedLocationProviderClient.removeLocationUpdates(locationCallback);
    }

    private static LocationRequest buildLocationRequest(LocationOptions options) {
        LocationRequest locationRequest = new LocationRequest();
        locationRequest.setPriority(toPriority(options.getAccuracy()));
        locationRequest.setInterval(options.getTimeInterval());
        locationRequest.setFastestInterval(options.getTimeInterval() / 2);
        locationRequest.setSmallestDisplacement(options.getDistanceFilter());

        return locationRequest;
    }

    private static LocationSettingsRequest buildLocationSettingsRequest(LocationRequest locationRequest) {
        LocationSettingsRequest.Builder builder = new LocationSettingsRequest.Builder();
        builder.addLocationRequest(locationRequest);

        return builder.build();
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
