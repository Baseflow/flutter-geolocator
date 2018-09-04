package com.baseflow.flutter.plugin.geolocator.tasks;

import android.content.Context;
import android.location.Address;
import android.location.Geocoder;

import com.baseflow.flutter.plugin.geolocator.data.AddressMapper;
import com.baseflow.flutter.plugin.geolocator.data.Coordinate;
import com.baseflow.flutter.plugin.geolocator.data.Result;
import com.baseflow.flutter.plugin.geolocator.utils.LocaleConverter;

import java.io.IOException;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import io.flutter.plugin.common.PluginRegistry;

class ReverseGeocodingTask extends Task {
    private static final String LOCALE_DELIMITER = "_";

    private final Context mContext;

    private Coordinate mCoordinatesToLookup;
    private Locale mLocale;

    public ReverseGeocodingTask(TaskContext context) {
        super(context);

        PluginRegistry.Registrar registrar = context.getRegistrar();

        mContext = registrar.activity() != null ? registrar.activity() : registrar.activeContext();

        parseArguments(context.getArguments());
    }

    private void parseArguments(Object arguments) {
        @SuppressWarnings("unchecked")
        Map<String, Object> argumentMap = (Map<String, Object>)arguments;

        mCoordinatesToLookup = new Coordinate(
                (double)argumentMap.get("latitude"),
                (double)argumentMap.get("longitude"));

        if (argumentMap.containsKey("localeIdentifier")) {
            mLocale = LocaleConverter.fromLanguageTag((String)argumentMap.get("localeIdentifier"));
        }
    }

    @Override
    public void startTask() {
        Geocoder geocoder = (mLocale != null)
                ? new Geocoder(mContext, mLocale)
                : new Geocoder(mContext);

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
