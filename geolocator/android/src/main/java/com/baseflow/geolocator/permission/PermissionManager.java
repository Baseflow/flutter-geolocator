package com.baseflow.geolocator.permission;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Build;
import android.util.Log;

import androidx.annotation.Nullable;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import com.baseflow.geolocator.errors.ErrorCallback;
import com.baseflow.geolocator.errors.ErrorCodes;
import com.baseflow.geolocator.errors.PermissionUndefinedException;

import java.util.*;

@SuppressWarnings("deprecation")
public class PermissionManager
    implements io.flutter.plugin.common.PluginRegistry.RequestPermissionsResultListener {

  private static final int PERMISSION_REQUEST_CODE = 109;

  @Nullable private Activity activity;
  @Nullable private ErrorCallback errorCallback;
  @Nullable private PermissionResultCallback resultCallback;

  public LocationPermission checkPermissionStatus(Context context, Activity activity)
      throws PermissionUndefinedException {
    String permission = determineFineOrCoarse(context);

    // If target is before Android M, permission is always granted
    if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
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

    if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) {
      return LocationPermission.always;
    }

    boolean wantsBackgroundLocation =
        PermissionUtils.hasPermissionInManifest(
            context, Manifest.permission.ACCESS_BACKGROUND_LOCATION);
    if (!wantsBackgroundLocation) {
      return LocationPermission.whileInUse;
    }

    final int permissionStatusBackground =
        ContextCompat.checkSelfPermission(context, Manifest.permission.ACCESS_BACKGROUND_LOCATION);
    if (permissionStatusBackground == PackageManager.PERMISSION_GRANTED) {
      return LocationPermission.always;
    }

    return LocationPermission.whileInUse;
  }

  public void requestPermission(
      Activity activity, PermissionResultCallback resultCallback, ErrorCallback errorCallback)
      throws PermissionUndefinedException {
    final ArrayList<String> permissionsToRequest = new ArrayList<>();

    // Before Android M, requesting permissions was not needed.
    if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
      resultCallback.onResult(LocationPermission.always);
      return;
    }

    String permission = determineFineOrCoarse(activity);
    permissionsToRequest.add(permission);

    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q
        && PermissionUtils.hasPermissionInManifest(
            activity, Manifest.permission.ACCESS_BACKGROUND_LOCATION)) {
      permissionsToRequest.add(Manifest.permission.ACCESS_BACKGROUND_LOCATION);
    }

    this.errorCallback = errorCallback;
    this.resultCallback = resultCallback;
    this.activity = activity;

    ActivityCompat.requestPermissions(
        activity, permissionsToRequest.toArray(new String[0]), PERMISSION_REQUEST_CODE);
  }

  @Override
  public boolean onRequestPermissionsResult(
      int requestCode, String[] permissions, int[] grantResults) {
    if (requestCode != PERMISSION_REQUEST_CODE) {
      return false;
    }

    if (this.activity == null) {
      Log.e("Geolocator", "Trying to process permission result without an valid Activity instance");
      if (this.errorCallback != null) {
        this.errorCallback.onError(ErrorCodes.activityNotSupplied);
      }
      return false;
    }

    String requestedPermission;

    try {
      requestedPermission = determineFineOrCoarse(this.activity);
    } catch (PermissionUndefinedException ex) {
      if (this.errorCallback != null) {
        this.errorCallback.onError(ErrorCodes.permissionDefinitionsNotFound);
      }

      return false;
    }

    LocationPermission permission = LocationPermission.denied;

    int requestedPermissionIndex = indexOf(permissions, requestedPermission);

    if (requestedPermissionIndex < 0) {
      Log.w(
          "Geolocator",
          "Location permissions not part of permissions send to onRequestPermissionsResult method.");
      return false;
    }

    if (grantResults.length == 0) {
      Log.i(
          "Geolocator",
          "The grantResults array is empty. This can happen when the user cancels the permission request");
      return false;
    }

    if (grantResults[requestedPermissionIndex] == PackageManager.PERMISSION_GRANTED) {
      if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.Q) {
        int backgroundPermissionIndex =
            indexOf(permissions, Manifest.permission.ACCESS_BACKGROUND_LOCATION);
        if (backgroundPermissionIndex >= 0
            && grantResults[backgroundPermissionIndex] == PackageManager.PERMISSION_GRANTED) {
          permission = LocationPermission.always;
        } else {
          permission = LocationPermission.whileInUse;
        }
      } else {
        permission = LocationPermission.always;
      }
    } else {
      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M
          && !activity.shouldShowRequestPermissionRationale(requestedPermission)) {
        permission = LocationPermission.deniedForever;
      }
    }

    for (int i = 0; i < permissions.length; i++) {
      final String perm = permissions[i];
      final int grantResult = grantResults[i];

      PermissionUtils.setRequestedPermission(activity, perm, grantResult);
    }

    if (this.resultCallback != null) {
      this.resultCallback.onResult(permission);
    }

    return true;
  }

  private static <T> int indexOf(T[] arr, T val) {
    return Arrays.asList(arr).indexOf(val);
  }

  private static String determineFineOrCoarse(Context context) throws PermissionUndefinedException {
    boolean wantsFineLocation =
        PermissionUtils.hasPermissionInManifest(context, Manifest.permission.ACCESS_FINE_LOCATION);
    boolean wantsCoarseLocation =
        PermissionUtils.hasPermissionInManifest(
            context, Manifest.permission.ACCESS_COARSE_LOCATION);

    if (!wantsCoarseLocation && !wantsFineLocation) {
      throw new PermissionUndefinedException();
    }

    return wantsFineLocation
        ? Manifest.permission.ACCESS_FINE_LOCATION
        : Manifest.permission.ACCESS_COARSE_LOCATION;
  }
}
