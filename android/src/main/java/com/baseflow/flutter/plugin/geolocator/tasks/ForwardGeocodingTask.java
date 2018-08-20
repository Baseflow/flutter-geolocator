package com.baseflow.flutter.plugin.geolocator.tasks;

import android.app.Activity;
import android.location.Address;
import android.location.Geocoder;

import com.baseflow.flutter.plugin.geolocator.data.AddressMapper;
import com.baseflow.flutter.plugin.geolocator.data.Result;

import java.io.IOException;
import java.util.List;

class ForwardGeocodingTask extends Task {
    private final Activity mActivity;

    private String mAddressToLookup;

    public ForwardGeocodingTask(TaskContext context) {
        super(context);

        mActivity = context.getRegistrar().activity();
        mAddressToLookup = parseAddress(context.getArguments());
    }

    private static String parseAddress(Object arguments) {
        if(arguments == null) return null;

        return (String) arguments;
    }

    @Override
    public void startTask() {
        Geocoder geocoder = new Geocoder(mActivity);
        Result result = getTaskContext().getResult();

        try {
            List<Address> addresses = geocoder.getFromLocationName(mAddressToLookup, 1);

            if(addresses.size() > 0) {
                result.success(AddressMapper.toHashMapList(addresses));
            } else {
                result.error(
                        "ERROR_GEOCODNG_ADDRESSNOTFOUND",
                        "Unable to find coordinates matching the supplied address.",
                        null);
            }

        } catch (IOException e) {
            result.error(
                    "ERROR_GEOCODING_ADDRESS",
                    e.getLocalizedMessage(),
                    null);
        } finally {
            stopTask();
        }
    }
}
