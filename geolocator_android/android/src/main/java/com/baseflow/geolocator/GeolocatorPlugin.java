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

  @SuppressWarnings("deprecation")
  @Nullable
  private io.flutter.plugin.common.PluginRegistry.Registrar pluginRegistrar;

  @Nullable private ActivityPluginBinding pluginBinding;

  public GeolocatorPlugin() {
    permissionManager = new PermissionManager();
    geolocationManager = new GeolocationManager();
    locationAccuracyManager = new LocationAccuracyManager();
  }

  // This static function is optional and equivalent to onAttachedToEngine. It supports the old
  // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
  // plugin registration via this function while apps migrate to use the new Android APIs
  // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
  //
  // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
  // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
  // depending on the user's project. onAttachedToEngine or registerWith must both be defined
  // in the same class.
  @SuppressWarnings("deprecation")
  public static void registerWith(io.flutter.plugin.common.PluginRegistry.Registrar registrar) {
    GeolocatorPlugin geolocatorPlugin = new GeolocatorPlugin();
    geolocatorPlugin.pluginRegistrar = registrar;
    geolocatorPlugin.registerListeners();

    MethodCallHandlerImpl methodCallHandler =
        new MethodCallHandlerImpl(
            geolocatorPlugin.permissionManager,
            geolocatorPlugin.geolocationManager,
            geolocatorPlugin.locationAccuracyManager);
    methodCallHandler.startListening(registrar.context(), registrar.messenger());
    methodCallHandler.setActivity(registrar.activity());

    StreamHandlerImpl streamHandler = new StreamHandlerImpl(geolocatorPlugin.permissionManager);
    streamHandler.startListening(registrar.context(), registrar.messenger());

    LocationServiceHandlerImpl locationServiceHandler = new LocationServiceHandlerImpl();
    locationServiceHandler.startListening(registrar.context(), registrar.messenger());
    locationServiceHandler.setContext(registrar.activeContext());
    geolocatorPlugin.bindForegroundService(registrar.activeContext());
  }

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    methodCallHandler =
        new MethodCallHandlerImpl(
            this.permissionManager, this.geolocationManager, this.locationAccuracyManager);
    methodCallHandler.startListening(
        flutterPluginBinding.getApplicationContext(), flutterPluginBinding.getBinaryMessenger());
    streamHandler = new StreamHandlerImpl(this.permissionManager);
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
    if (pluginRegistrar != null) {
      pluginRegistrar.addActivityResultListener(this.geolocationManager);
      pluginRegistrar.addRequestPermissionsResultListener(this.permissionManager);
    } else if (pluginBinding != null) {
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
