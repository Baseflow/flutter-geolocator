package com.baseflow.geolocator.permission;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.Build;
import android.util.Log;

import androidx.annotation.RequiresApi;
import androidx.core.app.ActivityCompat;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class PermissionUtils {

    public static boolean hasPermissionInManifest(Context context, String permission) {
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

    static void updatePermissionShouldShowStatus(final Activity activity, String permission) {
        if (activity == null) {
            return;
        }

        PermissionUtils.setRequestedPermission(activity, permission);
    }

    static boolean isNeverAskAgainSelected(final Activity activity, final String name) {
        if (activity == null || Build.VERSION.SDK_INT < Build.VERSION_CODES.M ) {
            return false;
        }

        return PermissionUtils.neverAskAgainSelected(activity, name);
    }

    @RequiresApi(api = Build.VERSION_CODES.M)
    static boolean neverAskAgainSelected(final Activity activity, final String permission) {
        final boolean hasRequestedPermissionBefore = getRequestedPermissionBefore(activity, permission);
        final boolean shouldShowRequestPermissionRationale = ActivityCompat.shouldShowRequestPermissionRationale(activity, permission);
        return hasRequestedPermissionBefore && !shouldShowRequestPermissionRationale;
    }

    static void setRequestedPermission(final Context context, final String permission) {
        SharedPreferences prefs = context.getSharedPreferences("GEOLOCATOR_PERMISSIONS_REQUESTED", Context.MODE_PRIVATE);
        prefs.edit()
                .putBoolean(permission, true)
                .apply();
    }

    static boolean getRequestedPermissionBefore(final Context context, final String permission) {
        SharedPreferences prefs = context.getSharedPreferences("GEOLOCATOR_PERMISSIONS_REQUESTED", Context.MODE_PRIVATE);
        return prefs.getBoolean(permission, false);
    }
}
