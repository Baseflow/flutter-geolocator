package com.baseflow.geolocator.permission;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Build;
import android.util.Log;

import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import com.baseflow.geolocator.errors.ErrorCallback;
import com.baseflow.geolocator.errors.ErrorCodes;
import com.baseflow.geolocator.errors.PermissionUndefinedException;

import java.security.Permission;
import java.util.*;

@SuppressWarnings("deprecation")
public class PermissionManager
    implements io.flutter.plugin.common.PluginRegistry.RequestPermissionsResultListener {

    private PermissionManager() {}

  private static final int PERMISSION_REQUEST_CODE = 109;

  private static PermissionManager permissionManagerInstance = null;

  @Nullable private Activity activity;
  @Nullable private ErrorCallback errorCallback;
  @Nullable private PermissionResultCallback resultCallback;

  public static synchronized PermissionManager getInstance() {
      if (permissionManagerInstance == null) {
          permissionManagerInstance = new PermissionManager();
      }

      return permissionManagerInstance;
  }

  public LocationPermission checkPermissionStatus(Context context)
      throws PermissionUndefinedException {
    List<String> permissions = getLocationPermissionsFromManifest(context);

    // If target is before Android M, permission is always granted
    if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
      return LocationPermission.always;
    }

    int permissionStatus = PackageManager.PERMISSION_DENIED;

    for (String permission : permissions) {
      if (ContextCompat.checkSelfPermission(context, permission)
          == PackageManager.PERMISSION_GRANTED) {
        permissionStatus = PackageManager.PERMISSION_GRANTED;
        break;
      }
    }

    if (permissionStatus == PackageManager.PERMISSION_DENIED) {
      return LocationPermission.denied;
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

    if (activity == null) {
      errorCallback.onError(ErrorCodes.activityMissing);
      return;
    }

    // Before Android M, requesting permissions was not needed.
    if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
      resultCallback.onResult(LocationPermission.always);
      return;
    }

    final List<String> permissionsToRequest = getLocationPermissionsFromManifest(activity);

    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q
        && PermissionUtils.hasPermissionInManifest(
            activity, Manifest.permission.ACCESS_BACKGROUND_LOCATION)) {
      final LocationPermission permissionStatus = checkPermissionStatus(activity);
      if (permissionStatus == LocationPermission.whileInUse) {
        permissionsToRequest.add(Manifest.permission.ACCESS_BACKGROUND_LOCATION);
      }
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
        this.errorCallback.onError(ErrorCodes.activityMissing);
      }
      return false;
    }

    List<String> requestedPermissions;

    try {
      requestedPermissions = getLocationPermissionsFromManifest(this.activity);
    } catch (PermissionUndefinedException ex) {
      if (this.errorCallback != null) {
        this.errorCallback.onError(ErrorCodes.permissionDefinitionsNotFound);
      }

      return false;
    }

    if (grantResults.length == 0) {
      Log.i(
          "Geolocator",
          "The grantResults array is empty. This can happen when the user cancels the permission request");
      return false;
    }

    LocationPermission locationPermission = LocationPermission.denied;
    int grantedResult = PackageManager.PERMISSION_DENIED;
    boolean shouldShowRationale = false;
    boolean permissionsPartOfPermissionsResult = false;

    for (String permission : requestedPermissions) {
      int requestedPermissionIndex = indexOf(permissions, permission);
      if (requestedPermissionIndex >= 0) {
          permissionsPartOfPermissionsResult = true;
      }
      if (grantResults[requestedPermissionIndex] == PackageManager.PERMISSION_GRANTED) {
        grantedResult = PackageManager.PERMISSION_GRANTED;
      }
      if (ActivityCompat.shouldShowRequestPermissionRationale(activity, permission)) {
        shouldShowRationale = true;
      }
    }

    if(!permissionsPartOfPermissionsResult) {
        Log.w(
                "Geolocator",
                "Location permissions not part of permissions send to onRequestPermissionsResult method.");
        return false;
    }

    if (grantedResult == PackageManager.PERMISSION_GRANTED) {
        locationPermission = (android.os.Build.VERSION.SDK_INT < android.os.Build.VERSION_CODES.Q || hasBackgroundAccess(permissions, grantResults))
                ? LocationPermission.always
                : LocationPermission.whileInUse;
    } else {
      if (!shouldShowRationale) {
        locationPermission = LocationPermission.deniedForever;
      }
    }

    if (this.resultCallback != null) {
      this.resultCallback.onResult(locationPermission);
    }

    return true;
  }

  @RequiresApi(api = Build.VERSION_CODES.Q)
  private boolean hasBackgroundAccess(String[] permissions, int[] grantResults) {
    int backgroundPermissionIndex =
        indexOf(permissions, Manifest.permission.ACCESS_BACKGROUND_LOCATION);
    return backgroundPermissionIndex >= 0
        && grantResults[backgroundPermissionIndex] == PackageManager.PERMISSION_GRANTED;
  }

  private static <T> int indexOf(T[] arr, T val) {
    return Arrays.asList(arr).indexOf(val);
  }

  private static List<String> getLocationPermissionsFromManifest(Context context)
      throws PermissionUndefinedException {
    boolean fineLocationPermissionExists =
        PermissionUtils.hasPermissionInManifest(context, Manifest.permission.ACCESS_FINE_LOCATION);
    boolean coarseLocationPermissionExists =
        PermissionUtils.hasPermissionInManifest(
            context, Manifest.permission.ACCESS_COARSE_LOCATION);

    if (!fineLocationPermissionExists && !coarseLocationPermissionExists) {
      throw new PermissionUndefinedException();
    }

    List<String> permissions = new ArrayList<>();

    if (fineLocationPermissionExists) {
      permissions.add(Manifest.permission.ACCESS_FINE_LOCATION);
    }

    if (coarseLocationPermissionExists) {
      permissions.add(Manifest.permission.ACCESS_COARSE_LOCATION);
    }

    return permissions;
  }

    public boolean hasPermission(Context context) throws PermissionUndefinedException {
        LocationPermission locationPermission = this.checkPermissionStatus(context);

        return locationPermission == LocationPermission.whileInUse || locationPermission == LocationPermission.always;
    }
}
