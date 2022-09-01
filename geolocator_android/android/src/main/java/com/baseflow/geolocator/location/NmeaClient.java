package com.baseflow.geolocator.location;

import android.annotation.SuppressLint;
import android.annotation.TargetApi;
import android.content.Context;
import android.location.Location;
import android.location.LocationManager;
import android.location.OnNmeaMessageListener;
import android.os.Build;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.Calendar;

public class NmeaClient {

  public static final String NMEA_ALTITUDE_EXTRA = "geolocator_mslAltitude";

  private final Context context;
  private final LocationManager locationManager;
  @Nullable private final LocationOptions locationOptions;

  @TargetApi(Build.VERSION_CODES.N)
  private OnNmeaMessageListener nmeaMessageListener;

  private String lastNmeaMessage;
  @Nullable private Calendar lastNmeaMessageTime;
  private boolean listenerAdded = false;

  public NmeaClient(@NonNull Context context, @Nullable LocationOptions locationOptions) {
    this.context = context;
    this.locationOptions = locationOptions;
    this.locationManager = (LocationManager) context.getSystemService(Context.LOCATION_SERVICE);

    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
      nmeaMessageListener =
          (message, timestamp) -> {
            if (message.startsWith("$GPGGA")) {
              lastNmeaMessage = message;
              lastNmeaMessageTime = Calendar.getInstance();
            }
          };
    }
  }

  @SuppressLint("MissingPermission")
  public void start() {
    if (listenerAdded) {
      return;
    }

    if (locationOptions != null && locationOptions.isUseMSLAltitude()) {
      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N && locationManager != null) {
        locationManager.addNmeaListener(nmeaMessageListener, null);
        listenerAdded = true;
      }
    }
  }

  public void stop() {
    if (locationOptions != null && locationOptions.isUseMSLAltitude()) {
      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N && locationManager != null) {
        locationManager.removeNmeaListener(nmeaMessageListener);
        listenerAdded = false;
      }
    }
  }

  public void enrichExtrasWithNmea(@Nullable Location location) {

    if (location == null) {
      return;
    }

    if (lastNmeaMessage != null && locationOptions != null && listenerAdded) {

      Calendar expiryDate = Calendar.getInstance();
      expiryDate.add(Calendar.SECOND, -5);
      if (lastNmeaMessageTime != null && lastNmeaMessageTime.before(expiryDate)) {
        // do not use MSL for old altitude values
        return;
      }

      if (locationOptions.isUseMSLAltitude()) {
        String[] tokens = lastNmeaMessage.split(",");
        String type = tokens[0];

        // Parse altitude above sea level, Detailed description of NMEA string here
        // http://aprs.gids.nl/nmea/#gga
        if (type.startsWith("$GPGGA") && tokens.length > 9) {
          if (!tokens[9].isEmpty()) {
            double mslAltitude = Double.parseDouble(tokens[9]);
            if (location.getExtras() == null) {
              location.setExtras(Bundle.EMPTY);
            }
            location.getExtras().putDouble(NMEA_ALTITUDE_EXTRA, mslAltitude);
          }
        }
      }
    }
  }
}
