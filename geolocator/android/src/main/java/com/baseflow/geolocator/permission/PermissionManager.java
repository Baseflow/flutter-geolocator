package com.baseflow.geolocator.permission;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.Build;

import androidx.annotation.Nullable;
import androidx.core.content.ContextCompat;

import com.baseflow.geolocator.errors.ErrorCallback;
import com.baseflow.geolocator.errors.PermissionUndefinedException;

import java.util.Map;

import io.flutter.plugin.common.PluginRegistry;

public class PermissionManager {
    @FunctionalInterface
    public interface ActivityRegistry {
        void addListener(PluginRegistry.ActivityResultListener handler);
    }

    @FunctionalInterface
    public interface PermissionRegistry {
        void addListener(PluginRegistry.RequestPermissionsResultListener handler);
    }

    @FunctionalInterface
    public interface PermissionsSuccessCallback {
        void onSuccess(LocationPermission permissionStatus);
    }

    @FunctionalInterface
    public interface ShouldShowRequestPermissionRationaleSuccessCallback {
        void onSuccess(boolean shouldShowRequestPermissionRationale);
    }

    public LocationPermission checkPermissionStatus(
            Context context,
            Activity activity) throws PermissionUndefinedException {
        return determinePermissionStatus(
                context,
                activity);
    }

    private LocationPermission determinePermissionStatus(
            Context context,
            @Nullable Activity activity) throws PermissionUndefinedException {

        boolean wantsFineLocation = hasPermission(context, Manifest.permission.ACCESS_FINE_LOCATION);
        boolean wantsCoarseLocation = hasPermission(context, Manifest.permission.ACCESS_COARSE_LOCATION);

        if(!wantsCoarseLocation && !wantsFineLocation){
            throw new PermissionUndefinedException();
        }
        String permission = wantsFineLocation ? Manifest.permission.ACCESS_FINE_LOCATION : Manifest.permission.ACCESS_COARSE_LOCATION;
        boolean wantsBackgroundLocation = hasPermission(context, Manifest.permission.ACCESS_BACKGROUND_LOCATION);

        final boolean targetsMOrHigher = context.getApplicationInfo().targetSdkVersion >= Build.VERSION_CODES.M;
        final boolean targetsQOrHigher = context.getApplicationInfo().targetSdkVersion >= Build.VERSION_CODES.Q;


        // If target is not M, permission is always granted
        if(!targetsMOrHigher){
            return LocationPermission.always;
        }

        final int permissionStatus = ContextCompat.checkSelfPermission(context, permission);
        if (permissionStatus == PackageManager.PERMISSION_DENIED) {
            if (PermissionUtils.isNeverAskAgainSelected(activity, permission)) {
                return LocationPermission.deniedForever;
            } else {
                return LocationPermission.denied;
            }
        }

        if(!targetsQOrHigher){
            return LocationPermission.always;
        }
        if(!wantsBackgroundLocation){
            return LocationPermission.whileInUse;
        }

        String backgroundPermission = Manifest.permission.ACCESS_BACKGROUND_LOCATION;
        final int permissionStatusBackground = ContextCompat.checkSelfPermission(context, backgroundPermission);
        if(permissionStatusBackground == PackageManager.PERMISSION_DENIED){
            if (PermissionUtils.isNeverAskAgainSelected(activity, backgroundPermission)) {
                return LocationPermission.whileInUseForever;
            } else {
                return LocationPermission.whileInUse;
            }
        }
        return LocationPermission.always;
    }

    public boolean hasPermission(Context context, String permission) {
        try {
            PackageInfo info = context.getPackageManager().getPackageInfo(context.getPackageName(), PackageManager.GET_PERMISSIONS);
            if (info.requestedPermissions != null) {
                for (String p : info.requestedPermissions) {
                    if (p.equals(permission)) {
                        return true;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
