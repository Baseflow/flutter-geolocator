package com.baseflow.geolocator.location;

import android.annotation.SuppressLint;
import android.annotation.TargetApi;
import android.content.Context;
import android.location.Location;
import android.location.LocationManager;
import android.location.OnNmeaMessageListener;
import android.os.Build;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

public class NmeaClient {

  public static final String NMEA_MESSAGE_EXTRA = "geolocator_nmeaMessage";
  public static final String NMEA_ALTITUDE_EXTRA = "geolocator_mslAltitude";

  @NonNull private final Context context;
  @Nullable private final LocationManager locationManager;

  @TargetApi(Build.VERSION_CODES.N)
  @NonNull private OnNmeaMessageListener nmeaMessageListener;

  @Nullable private NMEACallback callback;
  @Nullable private String lastNmeaMessage;
  private boolean listenerAdded = false;

  public NmeaClient(@NonNull Context context) {
    this.context = context;
    this.locationManager = (LocationManager) context.getSystemService(Context.LOCATION_SERVICE);

    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
      nmeaMessageListener =
          (message, timestamp) -> {
            if (message.startsWith("$")) {
              lastNmeaMessage = message;
            }
            if(callback != null) {
                callback.onMessage(message);
            }
          };
    }
  }

  @SuppressLint("MissingPermission")
  public void start() {
    if (listenerAdded) {
      return;
    }
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N && locationManager != null) {
      locationManager.addNmeaListener(nmeaMessageListener, null);
      listenerAdded = true;
    }
  }

  public void setCallback(NMEACallback callback) {
      if(this.callback != null) {
          throw new IllegalArgumentException("A callback has already been registered");
      }
      this.callback = callback;
  }

  public void stop() {
    if (!listenerAdded) {
      return;
    }

    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N && locationManager != null) {
      locationManager.removeNmeaListener(nmeaMessageListener);
      listenerAdded = false;
    }
  }

  public void enrichExtrasWithNmea(@Nullable Location location) {

    if (location == null) {
      return;
    }

    if (lastNmeaMessage != null && listenerAdded) {

      String[] tokens = lastNmeaMessage.split(",");
      String type = tokens[0];

      // Parse altitude above sea level, Detailed description of NMEA string here
      // http://aprs.gids.nl/nmea/#gga
      if (type.startsWith("$GPGGA") && tokens.length > 9) {
        if (!tokens[9].isEmpty()) {
          double mslAltitude = Double.parseDouble(tokens[9]);
          location.getExtras().putDouble(NMEA_ALTITUDE_EXTRA, mslAltitude);
        }
      }
    }
  }
}
