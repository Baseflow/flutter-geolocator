package com.baseflow.geolocator.tasks;

import android.app.Activity;
import android.content.IntentSender;
import androidx.annotation.NonNull;

import com.baseflow.geolocator.GeolocatorPlugin;
import com.baseflow.geolocator.data.LocationSettingsOptions;
import com.baseflow.geolocator.data.wrapper.ChannelResponse;
import com.google.android.gms.common.api.ApiException;
import com.google.android.gms.common.api.ResolvableApiException;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationServices;
import com.google.android.gms.location.LocationSettingsRequest;
import com.google.android.gms.location.LocationSettingsResponse;
import com.google.android.gms.location.LocationSettingsStatusCodes;
import com.google.android.gms.tasks.OnCompleteListener;

public class ChangeLocationSettingsTask extends Task<LocationSettingsOptions> {

  private final ChannelResponse flutterChannelResponse = getTaskContext().getResult();

  ChangeLocationSettingsTask(TaskContext<LocationSettingsOptions> context) {
      super(context);
  }

  public ChannelResponse getFlutterChannelResponse() {
      return flutterChannelResponse;
  }

  @Override
  public void startTask() {
    LocationSettingsOptions options = getTaskContext().getOptions();

    LocationRequest locationRequest = LocationRequest.create()
            .setInterval(options.getTimeInterval())
            .setFastestInterval(options.getFastestTimeInterval())
            .setPriority(options.getPriority());

    LocationSettingsRequest.Builder builder = new LocationSettingsRequest.Builder()
            .addLocationRequest(locationRequest);

    final com.google.android.gms.tasks.Task<LocationSettingsResponse> result =
            LocationServices.getSettingsClient(getTaskContext().getAndroidContext()).checkLocationSettings(builder.build());

    result.addOnCompleteListener(new OnCompleteListener<LocationSettingsResponse>() {
      @Override
      public void onComplete(@NonNull com.google.android.gms.tasks.Task<LocationSettingsResponse> task) {
        try {
          LocationSettingsResponse response = result.getResult(ApiException.class);
          flutterChannelResponse.success(1);
          stopTask();
        } catch (ApiException exception) {
          switch (exception.getStatusCode()) {
            case LocationSettingsStatusCodes.RESOLUTION_REQUIRED:
              try {
                ResolvableApiException resolvable = (ResolvableApiException) exception;

                resolvable.startResolutionForResult(
                        (Activity) getTaskContext().getAndroidContext(),
                        GeolocatorPlugin.CHANGE_LOCATION_SETTINGS_CODE);
              } catch (IntentSender.SendIntentException e) {
                flutterChannelResponse.error(
                        "REQUEST_LOCATION_ERROR",
                        e.getMessage(),
                        null);
                stopTask();
              } catch (ClassCastException e) {
                flutterChannelResponse.error(
                        "REQUEST_LOCATION_ERROR",
                        e.getMessage(),
                        null);
                stopTask();
              }
              break;
            case LocationSettingsStatusCodes.SETTINGS_CHANGE_UNAVAILABLE:
              flutterChannelResponse.error(
                      "REQUEST_LOCATION_ERROR",
                      "SETTINGS_CHANGE_UNAVAILABLE",
                      null);
              stopTask();
              break;
          }
        }
      }
    });
  }
}
