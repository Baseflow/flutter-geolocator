package com.baseflow.geolocator;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.IBinder;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.baseflow.geolocator.location.GeolocationManager;
import com.baseflow.geolocator.location.LocationAccuracyManager;
import com.baseflow.geolocator.permission.PermissionManager;

import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;

/** GeolocatorPlugin */
public class GeolocatorPlugin implements FlutterPlugin, ActivityAware {

  private static final String TAG = "FlutterGeolocator";
  private final PermissionManager permissionManager;
  private final GeolocationManager geolocationManager;
  private final LocationAccuracyManager locationAccuracyManager;

  @Nullable private GeolocatorLocationService foregroundLocationService;

  @Nullable private MethodCallHandlerImpl methodCallHandler;

  @Nullable private StreamHandlerImpl streamHandler;
  private final ServiceConnection serviceConnection =
      new ServiceConnection() {

        @Override
        public void onServiceConnected(ComponentName name, IBinder service) {
          Log.d(TAG, "Geolocator foreground service connected");
          if (service instanceof GeolocatorLocationService.LocalBinder) {
            initialize(((GeolocatorLocationService.LocalBinder) service).getLocationService());
          }
        }

        @Override
        public void onServiceDisconnected(ComponentName name) {
          Log.d(TAG, "Geolocator foreground service disconnected");
          if (foregroundLocationService != null) {
            foregroundLocationService.setActivity(null);
            foregroundLocationService = null;
          }
        }
      };
  @Nullable private LocationServiceHandlerImpl locationServiceHandler;

  @Nullable private ActivityPluginBinding pluginBinding;

  public GeolocatorPlugin() {
    permissionManager = PermissionManager.getInstance();
    geolocationManager = GeolocationManager.getInstance();
    locationAccuracyManager = LocationAccuracyManager.getInstance();
  }

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    methodCallHandler =
        new MethodCallHandlerImpl(
            this.permissionManager, this.geolocationManager, this.locationAccuracyManager);
    methodCallHandler.startListening(
        flutterPluginBinding.getApplicationContext(), flutterPluginBinding.getBinaryMessenger());
    streamHandler = new StreamHandlerImpl(this.permissionManager, this.geolocationManager);
    streamHandler.startListening(
        flutterPluginBinding.getApplicationContext(), flutterPluginBinding.getBinaryMessenger());

    locationServiceHandler = new LocationServiceHandlerImpl();
    locationServiceHandler.setContext(flutterPluginBinding.getApplicationContext());
    locationServiceHandler.startListening(
        flutterPluginBinding.getApplicationContext(), flutterPluginBinding.getBinaryMessenger());

    bindForegroundService(flutterPluginBinding.getApplicationContext());
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    unbindForegroundService(binding.getApplicationContext());
    dispose();
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    Log.d(TAG, "Attaching Geolocator to activity");
    this.pluginBinding = binding;
    registerListeners();
    if (methodCallHandler != null) {
      methodCallHandler.setActivity(binding.getActivity());
    }
    if (streamHandler != null) {
      streamHandler.setActivity(binding.getActivity());
    }
    if (foregroundLocationService != null) {
      foregroundLocationService.setActivity(pluginBinding.getActivity());
    }
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity();
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    onAttachedToActivity(binding);
  }

  @Override
  public void onDetachedFromActivity() {
    Log.d(TAG, "Detaching Geolocator from activity");
    deregisterListeners();
    if (methodCallHandler != null) {
      methodCallHandler.setActivity(null);
    }
    if (streamHandler != null) {
      streamHandler.setActivity(null);
    }
    if (foregroundLocationService != null) {
      foregroundLocationService.setActivity(null);
    }
    if (pluginBinding != null) {
      pluginBinding = null;
    }
  }

  private void registerListeners() {
    if (pluginBinding != null) {
      pluginBinding.addActivityResultListener(this.geolocationManager);
      pluginBinding.addRequestPermissionsResultListener(this.permissionManager);
    }
  }

  private void deregisterListeners() {
    if (pluginBinding != null) {
      pluginBinding.removeActivityResultListener(this.geolocationManager);
      pluginBinding.removeRequestPermissionsResultListener(this.permissionManager);
    }
  }

  private void bindForegroundService(Context context) {
    context.bindService(
        new Intent(context, GeolocatorLocationService.class),
        serviceConnection,
        Context.BIND_AUTO_CREATE);
  }

  private void unbindForegroundService(Context context) {
    if (foregroundLocationService != null) {
      foregroundLocationService.flutterEngineDisconnected();
    }
    context.unbindService(serviceConnection);
  }

  private void initialize(GeolocatorLocationService service) {
    Log.d(TAG, "Initializing Geolocator services");
    foregroundLocationService = service;
    foregroundLocationService.setGeolocationManager(geolocationManager);
    foregroundLocationService.flutterEngineConnected();

    if (streamHandler != null) {
      streamHandler.setForegroundLocationService(service);
    }
  }

  private void dispose() {
    Log.d(TAG, "Disposing Geolocator services");
    if (methodCallHandler != null) {
      methodCallHandler.stopListening();
      methodCallHandler.setActivity(null);
      methodCallHandler = null;
    }
    if (streamHandler != null) {
      streamHandler.stopListening();
      streamHandler.setForegroundLocationService(null);
      streamHandler = null;
    }
    if (locationServiceHandler != null) {
      locationServiceHandler.setContext(null);
      locationServiceHandler.stopListening();
      locationServiceHandler = null;
    }
    if (foregroundLocationService != null) {
      foregroundLocationService.setActivity(null);
    }
  }
}
