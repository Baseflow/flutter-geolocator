package com.baseflow.geolocator;

import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.baseflow.geolocator.permission.PermissionManager;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * GeolocatorPlugin
 */
public class GeolocatorPlugin implements FlutterPlugin, ActivityAware {

    private static final String TAG = "GeocodingPlugin";
    private final PermissionManager permissionManager;

    @Nullable
    private MethodCallHandlerImpl methodCallHandler;

    @Nullable
    private Registrar pluginRegistrar;

    @Nullable
    private ActivityPluginBinding activityPluginBinding;

    public GeolocatorPlugin() {
        this.permissionManager = new PermissionManager();
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
        geolocatorPlugin.registerListeners();

        MethodCallHandlerImpl handler = new MethodCallHandlerImpl(geolocatorPlugin.permissionManager);
        handler.startListening(registrar.context(), registrar.messenger());
        handler.setActivity(registrar.activity());
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        methodCallHandler = new MethodCallHandlerImpl(this.permissionManager);
        methodCallHandler.startListening(
                flutterPluginBinding.getApplicationContext(),
                flutterPluginBinding.getBinaryMessenger());
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        if (methodCallHandler == null) {
            Log.wtf(TAG, "Already detached from the engine.");
            return;
        }

        methodCallHandler.stopListening();
        methodCallHandler = null;
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        if (methodCallHandler == null) {
            Log.wtf(TAG, "Not attached to engine while attaching to activity");
            return;
        }
        this.activityPluginBinding = binding;

        registerListeners();
        methodCallHandler.setActivity(binding.getActivity());
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
        if (methodCallHandler == null) {
            Log.wtf(TAG, "Not attached to engine while detaching from activity");
            return;
        }

        methodCallHandler.setActivity(null);
        deregisterListeners();
    }

    private void registerListeners() {
        if (this.pluginRegistrar != null) {
            this.pluginRegistrar.addRequestPermissionsResultListener(this.permissionManager);
        } else if (activityPluginBinding != null) {
            this.activityPluginBinding.addRequestPermissionsResultListener(this.permissionManager);
        }
    }

    private void deregisterListeners() {
        if (this.activityPluginBinding != null) {
            this.activityPluginBinding.removeRequestPermissionsResultListener(this.permissionManager);
        }
    }
}
