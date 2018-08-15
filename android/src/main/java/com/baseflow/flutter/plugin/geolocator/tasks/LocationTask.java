package com.baseflow.flutter.plugin.geolocator.tasks;

import android.app.Activity;
import android.content.Context;
import android.location.Criteria;
import android.location.Location;
import android.location.LocationManager;

import com.baseflow.flutter.plugin.geolocator.Codec;
import com.baseflow.flutter.plugin.geolocator.data.GeolocationAccuracy;
import com.baseflow.flutter.plugin.geolocator.data.LocationOptions;
import com.google.android.gms.common.util.Strings;

import java.util.List;

import io.flutter.plugin.common.PluginRegistry;

abstract class LocationTask extends Task {
    private static final long TWO_MINUTES = 120000;

    private final Activity mActivity;
    final LocationOptions mLocationOptions;

    LocationTask(TaskContext context) {
        super(context);

        PluginRegistry.Registrar registrar = context.getRegistrar();

        mActivity = registrar.activity();

        mLocationOptions = Codec.decodeLocationOptions(context.getArguments());
    }

    void handleError() {
        getTaskContext().getResult().error(
                "INVALID_LOCATION_SETTINGS",
                "Location settings are inadequate, check your location settings.",
                null);
    }

    public abstract void startTask();

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
