package com.baseflow.geolocator.permission;

import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.Build;

public class PermissionUtils {
  public static boolean hasPermissionInManifest(Context context, String permission) {
    try {
      PackageInfo info = getPackageInfo(context);
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

  @SuppressWarnings("deprecation")
  private static PackageInfo getPackageInfo(Context context) throws PackageManager.NameNotFoundException {
    final PackageManager packageManager = context.getPackageManager();
    final String packageName = context.getPackageName();

    if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) {
      return packageManager.getPackageInfo(packageName, PackageManager.GET_PERMISSIONS);
    }
    
    return packageManager.getPackageInfo(packageName,
        PackageManager.PackageInfoFlags.of(PackageManager.GET_PERMISSIONS));
  }
}
