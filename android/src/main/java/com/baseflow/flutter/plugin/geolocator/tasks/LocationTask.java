package com.baseflow.flutter.plugin.geolocator.tasks;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageManager;
import android.location.Criteria;
import android.location.Location;
import android.location.LocationManager;
import android.support.v4.app.ActivityCompat;

import com.baseflow.flutter.plugin.geolocator.Codec;
import com.baseflow.flutter.plugin.geolocator.data.GeolocationAccuracy;
import com.baseflow.flutter.plugin.geolocator.data.LocationOptions;
import com.google.android.gms.common.util.Strings;

import java.util.List;

import io.flutter.plugin.common.PluginRegistry;

abstract class LocationTask extends Task {
    private static final int REQUEST_PERMISSIONS_REQUEST_CODE = 34;
    private static final long TWO_MINUTES = 120000;

    private final Activity mActivity;
    final LocationOptions mLocationOptions;

    LocationTask(TaskContext context) {
        super(context);

        PluginRegistry.Registrar registrar = context.getRegistrar();

        mActivity = registrar.activity();

        PluginRegistry.RequestPermissionsResultListener permissionsResultListener = createPermissionsResultListener();
        registrar.addRequestPermissionsResultListener(permissionsResultListener);

        mLocationOptions = Codec.decodeLocationOptions(context.getArguments());
    }

    protected abstract void acquirePosition();
    protected abstract void handleError(String code, String message);

    @Override
    public void startTask() {
        if(!hasPermissions()) {
            requestPermissions();
        } else {
            acquirePosition();
        }
    }

    LocationManager getLocationManager() {
        Context context = mActivity.getApplicationContext();
        return (LocationManager) context.getSystemService(Activity.LOCATION_SERVICE);
    }

    String getBestProvider(LocationManager locationManager, GeolocationAccuracy accuracy) {
        Criteria criteria = new Criteria();

        criteria.setBearingRequired(false);
        criteria.setAltitudeRequired(false);
        criteria.setSpeedRequired(false);

        switch(accuracy) {
            case Lowest:
                criteria.setAccuracy(Criteria.NO_REQUIREMENT);
                criteria.setHorizontalAccuracy(Criteria.NO_REQUIREMENT);
                criteria.setPowerRequirement(Criteria.NO_REQUIREMENT);
                break;
            case Low:
                criteria.setAccuracy(Criteria.ACCURACY_COARSE);
                criteria.setHorizontalAccuracy(Criteria.ACCURACY_LOW);
                criteria.setPowerRequirement(Criteria.NO_REQUIREMENT);
                break;
            case Medium:
                criteria.setAccuracy(Criteria.ACCURACY_COARSE);
                criteria.setHorizontalAccuracy(Criteria.ACCURACY_MEDIUM);
                criteria.setPowerRequirement(Criteria.POWER_MEDIUM);
                break;
            case High:
                criteria.setAccuracy(Criteria.ACCURACY_FINE);
                criteria.setHorizontalAccuracy(Criteria.ACCURACY_HIGH);
                criteria.setPowerRequirement(Criteria.POWER_HIGH);
                break;
            case Best:
                criteria.setAccuracy(Criteria.ACCURACY_FINE);
                criteria.setHorizontalAccuracy(Criteria.ACCURACY_HIGH);
                criteria.setPowerRequirement(Criteria.POWER_HIGH);
                break;
        }

        String provider = locationManager.getBestProvider(criteria, true);

        if(Strings.isEmptyOrWhitespace(provider)) {
            List<String> providers = locationManager.getProviders(true);
            if(providers != null && providers.size() > 0)
                provider = providers.get(0);
        }

        return provider;
    }

    private PluginRegistry.RequestPermissionsResultListener createPermissionsResultListener() {
        return new PluginRegistry.RequestPermissionsResultListener() {
            @Override
            public boolean onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
                if (requestCode == REQUEST_PERMISSIONS_REQUEST_CODE && permissions.length == 1
                        && permissions[0].equals(Manifest.permission.ACCESS_FINE_LOCATION)) {
                    if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                        acquirePosition();
                    } else {
                        if (!shouldShowRequestPermissionRationale()) {
                            handleError(
                                    "PERMISSION_DENIED_NEVER_ASK",
                                    "Access to location data denied. To allow access to location services enable them in the device settings.");
                        } else {
                            handleError(
                                    "PERMISSION_DENIED",
                                    "Access to location data denied");
                        }
                    }

                    return true;
                }

                return false;
            }
        };
    }

    private boolean hasPermissions() {
        int permissionState = ActivityCompat.checkSelfPermission(
                mActivity,
                Manifest.permission.ACCESS_FINE_LOCATION);

        return permissionState == PackageManager.PERMISSION_GRANTED;
    }

    private void requestPermissions() {
        ActivityCompat.requestPermissions(
                mActivity,
                new String[] { Manifest.permission.ACCESS_FINE_LOCATION },
                REQUEST_PERMISSIONS_REQUEST_CODE);
    }

    private boolean shouldShowRequestPermissionRationale() {
        return ActivityCompat.shouldShowRequestPermissionRationale(
                mActivity,
                Manifest.permission.ACCESS_FINE_LOCATION);
    }

    public static boolean isBetterLocation(Location location, Location bestLocation) {
        if (bestLocation == null)
            return true;

        Long timeDelta = location.getTime() - bestLocation.getTime();

        boolean isSignificantlyNewer = timeDelta > TWO_MINUTES;
        boolean isSignificantlyOlder = timeDelta < -TWO_MINUTES;
        boolean isNewer = timeDelta > 0;

        if (isSignificantlyNewer)
            return true;

        if (isSignificantlyOlder)
            return false;

        float accuracyDelta = (int)(location.getAccuracy() - bestLocation.getAccuracy());
        boolean isLessAccurate = accuracyDelta > 0;
        boolean isMoreAccurate = accuracyDelta < 0;
        boolean isSignificantlyLessAccurate = accuracyDelta > 200;

        boolean isFromSameProvider = false;
        if(location.getProvider() != null) {
            isFromSameProvider = location.getProvider().equals(bestLocation.getProvider());
        }

        if (isMoreAccurate)
            return true;

        if (isNewer && !isLessAccurate)
            return true;

        //noinspection RedundantIfStatement
        if (isNewer && !isSignificantlyLessAccurate && isFromSameProvider)
            return true;

        return false;
    }
}
