package com.baseflow.geolocator;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.baseflow.geolocator.location.GeolocationManager;
import com.baseflow.geolocator.nmea.NmeaMessageManager;
import com.baseflow.geolocator.location.LocationAccuracyManager;
import com.baseflow.geolocator.permission.PermissionManager;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;

/** GeolocatorPlugin */
public class GeolocatorPlugin implements FlutterPlugin, ActivityAware {

  private static final String TAG = "GeocodingPlugin";
  private final PermissionManager permissionManager;
  private final GeolocationManager geolocationManager;
  private final LocationAccuracyManager locationAccuracyManager;
  private final NmeaMessageManager nmeaMessageManager;

  @Nullable private MethodCallHandlerImpl methodCallHandler;

  @Nullable private StreamHandlerImpl streamHandler;

  @Nullable private LocationServiceHandlerImpl locationServiceHandler;

  @Nullable private NmeaStreamHandlerImpl nmeaStreamHandler;

  @SuppressWarnings("deprecation")
  @Nullable
  private io.flutter.plugin.common.PluginRegistry.Registrar pluginRegistrar;

  @Nullable private ActivityPluginBinding pluginBinding;

  public GeolocatorPlugin() {
    this.permissionManager = new PermissionManager();
    this.geolocationManager = new GeolocationManager();
    this.locationAccuracyManager = new LocationAccuracyManager();
    this.nmeaMessageManager = new NmeaMessageManager();
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
            geolocatorPlugin.locationAccuracyManager,
            geolocatorPlugin.nmeaMessageManager);
    methodCallHandler.startListening(registrar.context(), registrar.messenger());
    methodCallHandler.setActivity(registrar.activity());

    StreamHandlerImpl streamHandler = new StreamHandlerImpl(geolocatorPlugin.geolocationManager, geolocatorPlugin.permissionManager);
    streamHandler.startListening(registrar.context(), registrar.messenger());
    streamHandler.setActivity(registrar.activity());

    LocationServiceHandlerImpl locationServiceHandler = new LocationServiceHandlerImpl();
    locationServiceHandler.startListening(registrar.context(), registrar.messenger());
    locationServiceHandler.setActivity(registrar.activity());
  }

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    methodCallHandler =
        new MethodCallHandlerImpl(
            this.permissionManager,
            this.geolocationManager,
            this.locationAccuracyManager,
            this.nmeaMessageManager);
    methodCallHandler.startListening(
        flutterPluginBinding.getApplicationContext(), flutterPluginBinding.getBinaryMessenger());
    streamHandler = new StreamHandlerImpl(this.geolocationManager, this.permissionManager);
    streamHandler.startListening(
        flutterPluginBinding.getApplicationContext(), flutterPluginBinding.getBinaryMessenger());
    locationServiceHandler = new LocationServiceHandlerImpl();
    locationServiceHandler.startListening(
        flutterPluginBinding.getApplicationContext(), flutterPluginBinding.getBinaryMessenger());
    nmeaStreamHandler = new NmeaStreamHandlerImpl(nmeaMessageManager);
    nmeaStreamHandler.startListening(
        flutterPluginBinding.getApplicationContext(),
        flutterPluginBinding.getBinaryMessenger());
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    if (methodCallHandler != null) {
      methodCallHandler.stopListening();
      methodCallHandler = null;
    }

    if (streamHandler != null) {
      streamHandler.stopListening();
      streamHandler = null;
    }

    if (locationServiceHandler != null) {
      locationServiceHandler.stopListening();
      locationServiceHandler = null;
    }

    if (nmeaStreamHandler != null) {
      nmeaStreamHandler.stopListening();
      nmeaStreamHandler = null;
    }
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    if (methodCallHandler != null) {
      methodCallHandler.setActivity(binding.getActivity());
    }
    if (streamHandler != null) {
      streamHandler.setActivity(binding.getActivity());
    }

    if (locationServiceHandler != null) {
      locationServiceHandler.setActivity(binding.getActivity());
    }

    if (nmeaStreamHandler != null) {
      nmeaStreamHandler.setActivity(binding.getActivity());
    }

    this.pluginBinding = binding;
    registerListeners();
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
    if (methodCallHandler != null) {
      methodCallHandler.setActivity(null);
    }
    if (streamHandler != null) {
      streamHandler.setActivity(null);
    }
    if (locationServiceHandler != null) {
      streamHandler.setActivity(null);
    }
    if (nmeaStreamHandler != null) {
      nmeaStreamHandler.setActivity(null);
    }

    deregisterListeners();
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
