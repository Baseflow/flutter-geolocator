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
import androidx.core.content.ContextCompat;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class PermissionUtils {

  public static boolean hasPermissionInManifest(Context context, String permission) {
    try {
      PackageInfo info =
          context
              .getPackageManager()
              .getPackageInfo(context.getPackageName(), PackageManager.GET_PERMISSIONS);
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

  static boolean isNeverAskAgainSelected(final Activity activity, final String name) {
    if (activity == null || Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
      return false;
    }

    return PermissionUtils.neverAskAgainSelected(activity, name);
  }

  @RequiresApi(api = Build.VERSION_CODES.M)
  static boolean neverAskAgainSelected(final Activity activity, final String permission) {
    final boolean permissionDeniedForever = getPermissionDeniedForever(activity, permission);
    final boolean shouldShowRequestPermissionRationale =
        ActivityCompat.shouldShowRequestPermissionRationale(activity, permission);
    final boolean isDeniedForever = permissionDeniedForever && !shouldShowRequestPermissionRationale;

    if (permissionDeniedForever != isDeniedForever) {
      setPermissionDeniedForever(activity, permission, false);
    }

    return isDeniedForever;
  }

  static void setRequestedPermission(
      final Activity activity, final String permission, final int grantResult) {
    // Only save permissions when they are denied
    if (grantResult != PackageManager.PERMISSION_DENIED) {
      return;
    }

    final boolean shouldShowRequestPermissionRationale =
        ActivityCompat.shouldShowRequestPermissionRationale(activity, permission);
    final boolean isDeniedForever = !shouldShowRequestPermissionRationale;

    setPermissionDeniedForever(activity, permission, isDeniedForever);
  }

  static boolean getPermissionDeniedForever(final Context context, final String permission) {
    SharedPreferences prefs =
        context.getSharedPreferences("GEOLOCATOR_PERMISSIONS_DENIED_FOREVER", Context.MODE_PRIVATE);
    return prefs.getBoolean(permission, false);
  }

  private static void setPermissionDeniedForever(
      final Activity activity, final String permission, final boolean isDeniedForever) {
    SharedPreferences prefs =
        activity.getSharedPreferences("GEOLOCATOR_PERMISSIONS_DENIED_FOREVER", Context.MODE_PRIVATE);
    prefs.edit().putBoolean(permission, isDeniedForever).apply();
  }
}
