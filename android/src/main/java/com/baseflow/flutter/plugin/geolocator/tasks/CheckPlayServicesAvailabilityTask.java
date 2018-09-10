package com.baseflow.flutter.plugin.geolocator.tasks;

import android.content.Context;

import com.baseflow.flutter.plugin.geolocator.Codec;
import com.baseflow.flutter.plugin.geolocator.data.PlayServicesAvailability;
import com.baseflow.flutter.plugin.geolocator.data.Result;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GoogleApiAvailability;

import io.flutter.plugin.common.PluginRegistry;

class CheckPlayServicesAvailabilityTask extends Task {
    private final Context mContext;

    CheckPlayServicesAvailabilityTask(TaskContext taskContext) {
        super(taskContext);

        PluginRegistry.Registrar registry = taskContext.getRegistrar();
        mContext = registry.activity() != null ? registry.activity() : registry.activeContext();
    }

    @Override
    public void startTask() {
        Result result = getTaskContext().getResult();

        try {
            GoogleApiAvailability googleApiAvailability = GoogleApiAvailability.getInstance();

            int connectionResult = googleApiAvailability.isGooglePlayServicesAvailable(mContext);
            PlayServicesAvailability availability = toPlayServiceAvailability(connectionResult);

            result.success(Codec.encodePlayServicesAvailability(availability));
        } catch (Exception ex) {
            result.error(
                ex.getMessage(),
                ex.getLocalizedMessage(),
                null
            );
        } finally {
            stopTask();
        }
    }

    private static PlayServicesAvailability toPlayServiceAvailability(int connectionResult) {
        PlayServicesAvailability availability;

        switch(connectionResult) {
            case ConnectionResult.SUCCESS:
                availability = PlayServicesAvailability.SUCCESS;
                break;
            case ConnectionResult.SERVICE_MISSING:
                availability = PlayServicesAvailability.SERVICE_MISSING;
                break;
            case ConnectionResult.SERVICE_UPDATING:
                availability = PlayServicesAvailability.SERVICE_UPDATING;
                break;
            case ConnectionResult.SERVICE_VERSION_UPDATE_REQUIRED:
                availability = PlayServicesAvailability.SERVICE_VERSION_UPDATE_REQUIRED;
                break;
            case ConnectionResult.SERVICE_DISABLED:
                availability = PlayServicesAvailability.SERVICE_DISABLED;
                break;
            case ConnectionResult.SERVICE_INVALID:
                availability = PlayServicesAvailability.SERVICE_INVALID;
                break;
            default:
                availability = PlayServicesAvailability.UNKNOWN;
                break;
        }

        return availability;
    }
}
