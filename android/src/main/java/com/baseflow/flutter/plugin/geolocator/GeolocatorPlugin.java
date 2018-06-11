package com.baseflow.flutter.plugin.geolocator;

import android.Manifest;
import android.content.IntentSender;
import android.content.pm.PackageManager;
import android.location.Location;
import android.os.Looper;
import android.support.annotation.NonNull;
import android.support.v4.app.ActivityCompat;
import android.util.Log;

import com.google.android.gms.common.api.ApiException;
import com.google.android.gms.common.api.ResolvableApiException;
import com.google.android.gms.location.FusedLocationProviderClient;
import com.google.android.gms.location.LocationCallback;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationResult;
import com.google.android.gms.location.LocationServices;
import com.google.android.gms.location.LocationSettingsRequest;
import com.google.android.gms.location.LocationSettingsResponse;
import com.google.android.gms.location.LocationSettingsStatusCodes;
import com.google.android.gms.location.SettingsClient;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import java.util.Map;

/**
 * GeolocatorPlugin
 */
public class GeolocatorPlugin implements MethodCallHandler, EventChannel.StreamHandler {

  private static final String LOG_TAG = "baseflow.com/geolocator";
  private static final String METHOD_CHANNEL_NAME = "flutter.baseflow.com/geolocator/methods";
  private static final String EVENT_CHANNEL_NAME = "flutter.baseflow.com/geolocator/events";
  private static final int REQUEST_PERMISSIONS_REQUEST_CODE = 34;
  private static final int REQUEST_CHECK_SETTINGS = 0x1;
  private static final long DEFAULT_REFRESH_INTERVAL_IN_MILLISECONDS = 1000;

  private final Registrar mRegistrar;
  private final FusedLocationProviderClient mFusedLocationClient;
  private final SettingsClient mSettingsClient;
  private LocationRequest mLocationRequest;
  private final LocationSettingsRequest mLocationSettingsRequest;
  private LocationCallback mLocationCallback;
  private PluginRegistry.RequestPermissionsResultListener mPermissionsResultListener;
  private EventChannel.EventSink mEventSink;
  private Result mResult;

  private GeolocatorPlugin(PluginRegistry.Registrar registrar){
    this.mRegistrar = registrar;

    mFusedLocationClient = LocationServices.getFusedLocationProviderClient(mRegistrar.activity());
    mSettingsClient = LocationServices.getSettingsClient(mRegistrar.activity());

    createLocationCallback();
    createLocationRequest();
    createPermissionsResultListener();

    LocationSettingsRequest.Builder builder = new LocationSettingsRequest.Builder();
    builder.addLocationRequest(mLocationRequest);
    mLocationSettingsRequest = builder.build();

    registrar.addRequestPermissionsResultListener(mPermissionsResultListener);
  }

  /**
   * Plugin registration.
   */
  public static void registerWith(Registrar registrar) {
    GeolocatorPlugin geolocatorPlugin = new GeolocatorPlugin(registrar);

    final MethodChannel methodChannel = new MethodChannel(registrar.messenger(), METHOD_CHANNEL_NAME);
    final EventChannel eventChannel = new EventChannel(registrar.messenger(), EVENT_CHANNEL_NAME);
    methodChannel.setMethodCallHandler(geolocatorPlugin);
    eventChannel.setStreamHandler(geolocatorPlugin);
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("getPosition")) {
      mResult = result;

      if (!hasPermissions()) {
        requestPermissions();
      } else {
        acquirePosition();
      }
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onListen(Object o, EventChannel.EventSink eventSink) {
    mEventSink = eventSink;

    // Make sure all permissions are available,
    // if not request for permissions and return.
    if(!hasPermissions())
    {
      requestPermissions();
      return;
    }

    mSettingsClient.checkLocationSettings(mLocationSettingsRequest)
            .addOnSuccessListener(mRegistrar.activity(), new OnSuccessListener<LocationSettingsResponse>() {
              @Override
              public void onSuccess(LocationSettingsResponse locationSettingsResponse) {
                mFusedLocationClient.requestLocationUpdates(mLocationRequest, mLocationCallback,
                        Looper.myLooper());
              }
            }).addOnFailureListener(mRegistrar.activity(), new OnFailureListener() {
      @Override
      public void onFailure(@NonNull Exception e) {
        int statusCode = ((ApiException) e).getStatusCode();
        switch (statusCode) {
          case LocationSettingsStatusCodes.RESOLUTION_REQUIRED:
            try {
              // Show the dialog by calling startResolutionForResult(), and check the
              // result in onActivityResult().
              ResolvableApiException rae = (ResolvableApiException) e;
              rae.startResolutionForResult(mRegistrar.activity(), REQUEST_CHECK_SETTINGS);
            } catch (IntentSender.SendIntentException sie) {
              Log.i(LOG_TAG, "PendingIntent unable to execute request.");
            }
            break;
          case LocationSettingsStatusCodes.SETTINGS_CHANGE_UNAVAILABLE:
            String errorMessage = "Location settings are inadequate, and cannot be "
                    + "fixed here. Fix in Settings.";
            Log.e(LOG_TAG, errorMessage);
        }
      }
    });
  }

  @Override
  public void onCancel(Object arguments) {
    mFusedLocationClient.removeLocationUpdates(mLocationCallback);
    mEventSink = null;
  }

  private void createLocationCallback() {
    mLocationCallback = new LocationCallback()
    {
      @Override
      public void onLocationResult(LocationResult locationResult)
      {
        super.onLocationResult(locationResult);

        Location location = locationResult.getLastLocation();

        if(mEventSink != null && location != null) {
          mEventSink.success(LocationMapper.toHashMap(location));
        }
      }
    };
  }

  private void createLocationRequest() {
    mLocationRequest = new LocationRequest();

    mLocationRequest.setInterval(DEFAULT_REFRESH_INTERVAL_IN_MILLISECONDS);
    mLocationRequest.setFastestInterval(DEFAULT_REFRESH_INTERVAL_IN_MILLISECONDS / 2);
    mLocationRequest.setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY);
  }

  private void createPermissionsResultListener() {
    mPermissionsResultListener = new PluginRegistry.RequestPermissionsResultListener() {
      @Override
      public boolean onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        if (requestCode == REQUEST_PERMISSIONS_REQUEST_CODE && permissions.length == 1 && permissions[0].equals(Manifest.permission.ACCESS_FINE_LOCATION)) {
          if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
            acquirePosition();
          } else {
            if (!shouldShowRequestPermissionRationale()) {
              if (mResult != null) {
                mResult.error("PERMISSION_DENIED_NEVER_ASK", "Access to location data denied. To allow access to location services enable them in the device settings.", null);
                mResult = null;
              } else if (mEventSink != null) {
                mEventSink.error("PERMISSION_DENIED_NEVER_ASK", "Access to location data denied. To allow access to location services enable them in the device settings.", null);
                mEventSink = null;
              }
            } else {
              if (mResult != null) {
                mResult.error("PERMISSION_DENIED", "Access to location data denied", null);
                mResult = null;
              } else if (mEventSink != null) {
                mEventSink.error("PERMISSION_DENIED", "Access to location data denied", null);
                mEventSink = null;
              }
            }
          }

          return true;
        }

        return false;
      }
    };
  }

  private boolean hasPermissions() {
    int permissionState = ActivityCompat.checkSelfPermission(mRegistrar.activity(), Manifest.permission.ACCESS_FINE_LOCATION);
    return permissionState == PackageManager.PERMISSION_GRANTED;
  }

  private void requestPermissions() {
    ActivityCompat.requestPermissions(mRegistrar.activity(), new String[]{Manifest.permission.ACCESS_FINE_LOCATION},
            REQUEST_PERMISSIONS_REQUEST_CODE);
  }

  private boolean shouldShowRequestPermissionRationale() {
    return ActivityCompat.shouldShowRequestPermissionRationale(mRegistrar.activity(), Manifest.permission.ACCESS_FINE_LOCATION);
  }

  private void acquirePosition() {
    mFusedLocationClient.getLastLocation().addOnSuccessListener(new OnSuccessListener<Location>() {
      @Override
      public void onSuccess(Location location) {
        if (location != null) {
          Map<String, Double> position = LocationMapper.toHashMap(location);

          if (mResult != null) {
            mResult.success(position);
            mResult = null;
          }
        } else {
          if (mResult != null) {
            mResult.error("ERROR", "Failed to get location.", null);
          }
          // Do not send error on events otherwise it will produce an error
        }
      }
    });
  }
}
