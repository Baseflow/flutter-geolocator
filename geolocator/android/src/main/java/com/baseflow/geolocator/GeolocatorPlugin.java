package com.baseflow.geolocator;

import android.app.Activity;
import android.content.Context;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.baseflow.geolocator.location.GeolocationManager;
import com.baseflow.geolocator.nmea.NmeaMessageManager;
import com.baseflow.geolocator.permission.PermissionManager;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** GeolocatorPlugin */
public class GeolocatorPlugin implements FlutterPlugin, ActivityAware {

  private static final String TAG = "GeocodingPlugin";
  private final PermissionManager permissionManager;
  private final GeolocationManager geolocationManager;
  private final NmeaMessageManager nmeaMessageManager;

  @Nullable private MethodCallHandlerImpl methodCallHandler;

  @Nullable
  private PositionStreamHandlerImpl positionStreamHandler;

  @Nullable
  private NmeaStreamHandlerImpl nmeaStreamHandler;

  @Nullable
  private Registrar pluginRegistrar;

  @Nullable
  private ActivityPluginBinding pluginBinding;

  public GeolocatorPlugin() {
    this.permissionManager = new PermissionManager();
    this.nmeaMessageManager = new NmeaMessageManager(permissionManager);
    this.geolocationManager = new GeolocationManager(permissionManager);
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
  public static void registerWith(Registrar registrar) {
    GeolocatorPlugin geolocatorPlugin = new GeolocatorPlugin();
    geolocatorPlugin.pluginRegistrar = registrar;
    geolocatorPlugin.configureListeners(registrar.context(), registrar.messenger());
    geolocatorPlugin.setActivity(registrar.activity());
  }

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    configureListeners(flutterPluginBinding.getApplicationContext(), flutterPluginBinding.getBinaryMessenger());
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    if (methodCallHandler != null) {
      methodCallHandler.stopListening();
      methodCallHandler = null;
    }

    if (positionStreamHandler != null) {
      positionStreamHandler.stopListening();
      positionStreamHandler = null;
    }

    if (nmeaStreamHandler != null) {
      nmeaStreamHandler.stopListening();
      nmeaStreamHandler = null;
    }
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    this.pluginBinding = binding;
    setActivity(binding.getActivity());
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
    setActivity(null);
  }


  void configureListeners(Context applicationContext, BinaryMessenger messenger) {
    methodCallHandler =
        new MethodCallHandlerImpl(permissionManager, geolocationManager);
    methodCallHandler.startListening(applicationContext, messenger);

    positionStreamHandler = new PositionStreamHandlerImpl(geolocationManager);
    positionStreamHandler.startListening(applicationContext, messenger);

    nmeaStreamHandler = new NmeaStreamHandlerImpl(nmeaMessageManager);
    nmeaStreamHandler.startListening(applicationContext, messenger);
  }

  void setActivity(@Nullable Activity activity) {
    if (methodCallHandler != null) {
      methodCallHandler.setActivity(activity);
    }
    if (positionStreamHandler != null) {
      positionStreamHandler.setActivity(activity);
    }
    if (nmeaStreamHandler != null) {
      nmeaStreamHandler.setActivity(activity);
    }

    if (activity != null) {
      registerListeners();
    } else {
      deregisterListeners();
    }
  }

  private void registerListeners() {
    if (this.pluginRegistrar != null) {
      this.pluginRegistrar.addActivityResultListener(this.geolocationManager);
      this.pluginRegistrar.addRequestPermissionsResultListener(this.permissionManager);
    } else if (pluginBinding != null) {
      this.pluginBinding.addActivityResultListener(this.geolocationManager);
      this.pluginBinding.addRequestPermissionsResultListener(this.permissionManager);
    }
  }

  private void deregisterListeners() {
    if (this.pluginBinding != null) {
      this.pluginBinding.removeActivityResultListener(this.geolocationManager);
      this.pluginBinding.removeRequestPermissionsResultListener(this.permissionManager);
    }
  }
}
