package com.baseflow.geolocator.tasks;

import android.content.Context;
import android.location.Address;
import android.location.Geocoder;

import android.os.AsyncTask;
import com.baseflow.geolocator.data.AddressMapper;
import com.baseflow.geolocator.data.Coordinate;
import com.baseflow.geolocator.data.wrapper.ChannelResponse;
import com.baseflow.geolocator.data.ReverseGeocodingOptions;

import java.io.IOException;
import java.util.List;
import java.util.Locale;

import com.baseflow.geolocator.utils.MainThreadDispatcher;
import io.flutter.plugin.common.PluginRegistry;

class ReverseGeocodingTask extends Task<ReverseGeocodingOptions> {
  private final Context mAndroidContext;

  private Coordinate mCoordinatesToLookup;
  private Locale mLocale;

  ReverseGeocodingTask(TaskContext<ReverseGeocodingOptions> context) {
    super(context);

    PluginRegistry.Registrar registrar = context.getRegistrar();

    mAndroidContext = registrar.activity() != null ? registrar.activity() : registrar.activeContext();
    mCoordinatesToLookup = context.getOptions().getCoordinate();
    mLocale = context.getOptions().getLocale();
  }

  @Override
  public void startTask() {
    final Geocoder geocoder = (mLocale != null)
            ? new Geocoder(mAndroidContext, mLocale)
            : new Geocoder(mAndroidContext);

    final ChannelResponse channelResponse = getTaskContext().getResult();

    // let android handle the thread pool (uses shared serial executor)
    AsyncTask.execute(new Runnable() {
      @Override
      public void run() {
        try {
          List<Address> addresses = geocoder.getFromLocation(mCoordinatesToLookup.getLatitude(), mCoordinatesToLookup.getLongitude(), 1);

          if (addresses.size() > 0) {
            MainThreadDispatcher.dispatchSuccess(
                    channelResponse,
                    AddressMapper.toHashMapList(addresses));
          } else {
            MainThreadDispatcher.dispatchError(
                    channelResponse,
                    "ERROR_GEOCODING_INVALID_COORDINATES",
                    "Unable to find an address for the supplied coordinates.",
                    null);
          }

        } catch (IOException e) {
          MainThreadDispatcher.dispatchError(
                  channelResponse,
                  "ERROR_GEOCODING_COORDINATES",
                  e.getLocalizedMessage(),
                  null);
        } finally {
          stopTask();
        }
      }
    });
  }
}
