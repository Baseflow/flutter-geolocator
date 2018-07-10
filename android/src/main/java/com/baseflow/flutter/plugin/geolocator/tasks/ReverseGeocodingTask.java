package com.baseflow.flutter.plugin.geolocator.tasks;

import android.app.Activity;
import android.location.Address;
import android.location.Geocoder;

import com.baseflow.flutter.plugin.geolocator.data.AddressMapper;
import com.baseflow.flutter.plugin.geolocator.data.Coordinates;
import com.baseflow.flutter.plugin.geolocator.data.Result;

import java.io.IOException;
import java.util.List;
import java.util.Map;

public class ReverseGeocodingTask extends Task {
    private final Activity mActivity;

    private Coordinates mCoordinatesToLookup;

    public ReverseGeocodingTask(TaskContext context) {
        super(context);

        mActivity = context.getRegistrar().activity();
        mCoordinatesToLookup = parseCoordinates(context.getArguments());
    }

    private static Coordinates parseCoordinates(Object arguments) {
        if(arguments == null) return null;

        try {
            Map<String, Double> coordinates = (Map<String, Double>)arguments;

            return new Coordinates(
                    coordinates.get("latitude"),
                    coordinates.get("longitude"));

        } catch(Exception ex) {
            return null;
        }
    }

    @Override
    public void startTask() {
        Geocoder geocoder = new Geocoder(mActivity);
        Result result = getTaskContext().getResult();

        try {
            List<Address> addresses = geocoder.getFromLocation(mCoordinatesToLookup.getLatitude(), mCoordinatesToLookup.getLongitude(), 1);

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
        }

        stopTask();
    }
}
