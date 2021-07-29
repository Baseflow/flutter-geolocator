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
}
