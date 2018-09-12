package com.baseflow.flutter.plugin.geolocator.tasks;

import android.content.Context;
import android.location.Address;
import android.location.Geocoder;

import com.baseflow.flutter.plugin.geolocator.data.AddressMapper;
import com.baseflow.flutter.plugin.geolocator.data.ForwardGeocodingOptions;
import com.baseflow.flutter.plugin.geolocator.data.Result;
import com.baseflow.flutter.plugin.geolocator.utils.LocaleConverter;

import java.io.IOException;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import io.flutter.plugin.common.PluginRegistry;

class ForwardGeocodingTask extends Task<ForwardGeocodingOptions> {
    private final Context mContext;

    ForwardGeocodingTask(TaskContext<ForwardGeocodingOptions> context) {
        super(context);

        PluginRegistry.Registrar registrar = context.getRegistrar();

        mContext = registrar.activity() != null ? registrar.activity() : registrar.activeContext();
    }

    @Override
    public void startTask() {
        ForwardGeocodingOptions options = getTaskContext().getOptions();

        Geocoder geocoder = (options.getLocale() != null)
                ? new Geocoder(mContext, options.getLocale())
                : new Geocoder(mContext);

        Result result = getTaskContext().getResult();

        try {
            List<Address> addresses = geocoder.getFromLocationName(options.getAddressToLookup(), 1);

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
