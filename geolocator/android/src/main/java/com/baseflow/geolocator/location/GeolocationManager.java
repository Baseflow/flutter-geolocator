package com.baseflow.geolocator.location;

import android.content.Context;
import androidx.annotation.NonNull;
import com.baseflow.geolocator.errors.ErrorCallback;
import com.baseflow.geolocator.errors.ErrorCodes;
import com.baseflow.geolocator.errors.PermissionUndefinedException;
import com.baseflow.geolocator.permission.LocationPermission;
import com.baseflow.geolocator.permission.PermissionManager;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GoogleApiAvailability;

public class GeolocationManager {
    @NonNull
    private final PermissionManager permissionManager;

    private volatile LocationClient locationClient;
    private PositionChangedCallback positionChangedCallback;
    private ErrorCallback errorCallback;

    public GeolocationManager(@NonNull PermissionManager permissionManager) {
        this.permissionManager = permissionManager;
    }

    public void getLastKnownPosition(
            Context context,
            PositionChangedCallback positionChangedCallback,
            ErrorCallback errorCallback) {
        if (!hasPermissions(context, errorCallback)) {
            return;
        }

        LocationClient locationClient = getLocationClient(context);
        locationClient.getLastKnownPosition(positionChangedCallback, errorCallback);
    }

    public void startPositionUpdates(
            Context context,
            LocationOptions options,
            PositionChangedCallback positionChangedCallback,
            ErrorCallback errorCallback) {
        if (!hasPermissions(context, errorCallback)) {
            return;
        }

        LocationClient locationClient = getLocationClient(context);
        locationClient.startPositionUpdates(options, positionChangedCallback, errorCallback);
    }

    public void stopPositionUpdates(Context context) {
        LocationClient locationClient = getLocationClient(context);
        locationClient.stopPositionUpdates();
    }

    private LocationClient getLocationClient(Context context) {
        if (locationClient == null) {
            synchronized (GeolocationManager.class) {
                if (locationClient == null) {
                    locationClient = isGooglePlayServicesAvailable(context)
                            ? new FusedLocationClient(context)
                            : new LocationManagerClient(context);
                }
            }
        }

        return locationClient;
    }

    private boolean isGooglePlayServicesAvailable(Context context){
        GoogleApiAvailability googleApiAvailability = GoogleApiAvailability.getInstance();
        int resultCode = googleApiAvailability.isGooglePlayServicesAvailable(context);
        return resultCode == ConnectionResult.SUCCESS;
    }

    private boolean hasPermissions(Context context, ErrorCallback errorCallback) {
        try {
            LocationPermission permissionStatus = permissionManager.checkPermissionStatus(context, null);

            if (permissionStatus == LocationPermission.denied || permissionStatus == LocationPermission.deniedForever) {
                errorCallback.onError(ErrorCodes.permissionDenied);
                return false;
            }
        } catch (PermissionUndefinedException ex) {
            errorCallback.onError(ErrorCodes.permissionDefinitionsNotFound);
            return false;
        }

        return true;
    }
}
