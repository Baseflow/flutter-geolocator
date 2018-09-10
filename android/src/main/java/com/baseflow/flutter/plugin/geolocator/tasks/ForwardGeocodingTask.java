package com.baseflow.flutter.plugin.geolocator.tasks;

import android.content.Context;
import android.location.Address;
import android.location.Geocoder;

import com.baseflow.flutter.plugin.geolocator.data.AddressMapper;
import com.baseflow.flutter.plugin.geolocator.data.Result;
import com.baseflow.flutter.plugin.geolocator.utils.LocaleConverter;

import java.io.IOException;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import io.flutter.plugin.common.PluginRegistry;

class ForwardGeocodingTask extends Task {
    private final Context mContext;

    private String mAddressToLookup;
    private Locale mLocale;

    ForwardGeocodingTask(TaskContext context) {
        super(context);

        PluginRegistry.Registrar registrar = context.getRegistrar();

        mContext = registrar.activity() != null ? registrar.activity() : registrar.activeContext();
        parseArguments(context.getArguments());
    }

    private void parseArguments(Object arguments) {
        @SuppressWarnings("unchecked")
        Map<String, String> argumentMap = (Map<String, String>)arguments;

        mAddressToLookup = argumentMap.get("address");

        if (argumentMap.containsKey("localeIdentifier")) {
            mLocale = LocaleConverter.fromLanguageTag(argumentMap.get("localeIdentifier"));
        }
    }

    @Override
    public void startTask() {
        Geocoder geocoder = (mLocale != null)
                ? new Geocoder(mContext, mLocale)
                : new Geocoder(mContext);

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
