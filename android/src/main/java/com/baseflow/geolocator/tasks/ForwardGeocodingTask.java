package com.baseflow.geolocator.tasks;

import android.content.Context;
import android.location.Address;
import android.location.Geocoder;

import android.os.AsyncTask;
import com.baseflow.geolocator.data.AddressMapper;
import com.baseflow.geolocator.data.ForwardGeocodingOptions;
import com.baseflow.geolocator.data.wrapper.ChannelResponse;

import java.io.IOException;
import java.util.List;

import com.baseflow.geolocator.utils.MainThreadDispatcher;
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
    final ForwardGeocodingOptions options = getTaskContext().getOptions();

    final Geocoder geocoder = (options.getLocale() != null)
        ? new Geocoder(mContext, options.getLocale())
        : new Geocoder(mContext);

    final ChannelResponse channelResponse = getTaskContext().getResult();

    // let android handle the thread pool (uses shared serial executor)
    execute(options, geocoder, channelResponse);
  }

  private void execute(final ForwardGeocodingOptions options, final Geocoder geocoder, final ChannelResponse channelResponse) {
    AsyncTask.execute(new Runnable() {
      @Override
      public void run() {
        try {
          List<Address> addresses;
          if (shouldCallWithBoundingBox(options)) {
            addresses = geocoder.getFromLocationName(
                    options.getAddressToLookup(),
                    options.getMaxResults(),
                    options.getLowerLeftLatitude(),
                    options.getLowerLeftLongitude(),
                    options.getUpperRightLatitude(),
                    options.getUpperRightLongitude());
          } else {
            addresses = geocoder.getFromLocationName(options.getAddressToLookup(), options.getMaxResults());
          }
          if (addresses.size() > 0) {
            MainThreadDispatcher.dispatchSuccess(
                    channelResponse,
                    AddressMapper.toHashMapList(addresses));
          } else {
            MainThreadDispatcher.dispatchError(
                    channelResponse,
                    "ERROR_GEOCODNG_ADDRESSNOTFOUND",
                    "Unable to find coordinates matching the supplied address.",
                    null);
          }

        } catch (IOException e) {
          MainThreadDispatcher.dispatchError(
                  channelResponse,
                  "ERROR_GEOCODING_ADDRESS",
                  e.getLocalizedMessage(),
                  null);
        } finally {
          stopTask();
        }
      }
    });
  }

  private boolean shouldCallWithBoundingBox(ForwardGeocodingOptions options) {
    return options.getLowerLeftLatitude() != null && options.getLowerLeftLongitude() != null
            && options.getUpperRightLatitude() != null && options.getUpperRightLongitude() != null;
  }
}
