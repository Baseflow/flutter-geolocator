package com.baseflow.flutter.plugin.geolocator.tasks;

import android.app.Activity;
import android.location.Address;
import android.location.Geocoder;

import com.baseflow.flutter.plugin.geolocator.data.AddressMapper;
import com.baseflow.flutter.plugin.geolocator.data.Coordinate;
import com.baseflow.flutter.plugin.geolocator.data.Result;

import java.io.IOException;
import java.util.List;
import java.util.Map;

class ReverseGeocodingTask extends Task {
    private final Activity mActivity;

    private Coordinate mCoordinatesToLookup;

    public ReverseGeocodingTask(TaskContext context) {
        super(context);

        mActivity = context.getRegistrar().activity();
        mCoordinatesToLookup = parseCoordinates(context.getArguments());
    }

    private static Coordinate parseCoordinates(Object arguments) {
        if(arguments == null) return null;

        @SuppressWarnings("unchecked")
        Map<String, Double> coordinates = (Map<String, Double>)arguments;

        return new Coordinate(
                coordinates.get("latitude"),
                coordinates.get("longitude"));
    }

    @Override
    public void startTask() {
        Geocoder geocoder = new Geocoder(mActivity);
        Result result = getTaskContext().getResult();

        try {
            List<Address> addresses = geocoder.getFromLocation(mCoordinatesToLookup.latitude, mCoordinatesToLookup.longitude, 1);

            if(addresses.size() > 0) {
                result.success(AddressMapper.toHashMapList(addresses));
            } else {
                result.error(
                        "ERROR_GEOCODING_INVALID_COORDINATES",
                        "Unable to find an address for the supplied coordinates.",
                        null);
            }

        } catch (IOException e) {
            result.error(
                    "ERROR_GEOCODING_COORDINATES",
                    e.getLocalizedMessage(),
                    null);
        } finally {
            stopTask();
        }
    }
}
