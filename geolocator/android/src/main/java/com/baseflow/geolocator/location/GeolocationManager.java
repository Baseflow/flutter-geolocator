package com.baseflow.geolocator.location;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.location.LocationManager;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.baseflow.geolocator.errors.ErrorCallback;
import com.baseflow.geolocator.errors.ErrorCodes;
import com.baseflow.geolocator.errors.PermissionUndefinedException;
import com.baseflow.geolocator.permission.LocationPermission;
import com.baseflow.geolocator.permission.PermissionManager;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GoogleApiAvailability;
import com.google.android.gms.location.LocationServices;
import com.google.android.gms.location.LocationSettingsRequest;
import com.google.android.gms.location.LocationSettingsResponse;
import com.google.android.gms.location.LocationSettingsStates;
import com.google.android.gms.tasks.OnSuccessListener;

import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

import io.flutter.plugin.common.PluginRegistry;

public class GeolocationManager implements PluginRegistry.ActivityResultListener {
    @NonNull
    private final PermissionManager permissionManager;
    @Nullable
    private LocationClient locationClient;

    public GeolocationManager(@NonNull PermissionManager permissionManager) {
        this.permissionManager = permissionManager;
    }

    public void getLastKnownPosition(
            Context context,
            Activity activity,
            boolean forceLocationManager,
            PositionChangedCallback positionChangedCallback,
            ErrorCallback errorCallback) {

        handlePermissions(
                context,
                activity,
                () -> {
                    LocationClient locationClient = createLocationClient(context, forceLocationManager);
                    locationClient.getLastKnownPosition(positionChangedCallback, errorCallback);
                },
                errorCallback);
    }

    public boolean isLocationServiceEnabled(@Nullable Context context) {
        if (context == null) {
            return false;
        }
        boolean gps_enabled;
        boolean network_enabled;

        if (isGooglePlayServicesAvailable(context)) {
            ThreadPoolExecutor executor = new ThreadPoolExecutor(
                    1,
                    1,
                    1000,
                    TimeUnit.MILLISECONDS,
                    new LinkedBlockingQueue<>());

            final LocationSettingsStates[] ls = new LocationSettingsStates[1];

            LocationServices.getSettingsClient(context).checkLocationSettings(new LocationSettingsRequest.Builder().build())
                    .addOnSuccessListener(executor, (OnSuccessListener<LocationSettingsResponse>) o -> {
                        System.out.println("Checking gps location usable in thread " + o.getLocationSettingsStates().isGpsUsable());
                        ls[0] = o.getLocationSettingsStates();
                    });

            try {
                // This await has to be replaced by something that stops waiting when the Task
                // is done executing.
                executor.awaitTermination(100, TimeUnit.MILLISECONDS);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }

            if (ls[0] == null) return false;
            return ls[0].isGpsUsable() || ls[0].isNetworkLocationUsable();

        } else {

            LocationManager locationManager = (LocationManager) context.getSystemService(Context.LOCATION_SERVICE);

            if (locationManager == null) {
                return false;
            }

            gps_enabled = locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER);
            network_enabled = locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER);

            return gps_enabled || network_enabled;
        }
    }

    public void startPositionUpdates(
            Context context,
            Activity activity,
            LocationOptions options,
            PositionChangedCallback positionChangedCallback,
            ErrorCallback errorCallback) {

        handlePermissions(
                context,
                activity,
                () -> {
                    LocationClient locationClient = createLocationClient(context, options.isForceAndroidLocationManager());
                    locationClient.startPositionUpdates(activity, options, positionChangedCallback, errorCallback);
                },
                errorCallback);
    }

    public void stopPositionUpdates() {
        if (this.locationClient != null) {
            this.locationClient.stopPositionUpdates();
        }
    }

    private LocationClient createLocationClient(Context context, boolean forceLocationManagerClient) {
        if (forceLocationManagerClient) {
            this.locationClient = new LocationManagerClient(context);
            return this.locationClient;
        }

        this.locationClient = isGooglePlayServicesAvailable(context)
                ? new FusedLocationClient(context)
                : new LocationManagerClient(context);

        return this.locationClient;
    }

    private boolean isGooglePlayServicesAvailable(Context context) {
        GoogleApiAvailability googleApiAvailability = GoogleApiAvailability.getInstance();
        int resultCode = googleApiAvailability.isGooglePlayServicesAvailable(context);
        return resultCode == ConnectionResult.SUCCESS;
    }

    private void handlePermissions(Context context, @Nullable Activity activity, Runnable hasPermissionCallback, ErrorCallback errorCallback) {
        try {
            LocationPermission permissionStatus = permissionManager.checkPermissionStatus(context, activity);

            if (permissionStatus == LocationPermission.deniedForever) {
                errorCallback.onError(ErrorCodes.permissionDenied);
                return;
            }

            if (permissionStatus == LocationPermission.whileInUse || permissionStatus == LocationPermission.always) {
                hasPermissionCallback.run();
                return;
            }

            if (permissionStatus == LocationPermission.denied && activity != null) {
                permissionManager.requestPermission(
                        activity,
                        (permission) -> {
                            if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
                                hasPermissionCallback.run();
                            } else {
                                errorCallback.onError(ErrorCodes.permissionDenied);
                            }
                        },
                        errorCallback);
            } else {
                errorCallback.onError(ErrorCodes.permissionDenied);
            }
        } catch (PermissionUndefinedException ex) {
            errorCallback.onError(ErrorCodes.permissionDefinitionsNotFound);
        }
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        if (locationClient == null) {
            return false;
        }

        return locationClient.onActivityResult(requestCode, resultCode);
    }
}
