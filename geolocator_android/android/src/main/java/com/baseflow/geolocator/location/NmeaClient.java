package com.baseflow.geolocator.location;

import android.Manifest;
import android.annotation.SuppressLint;
import android.annotation.TargetApi;
import android.content.Context;
import android.content.pm.PackageManager;
import android.location.GnssStatus;
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
  public static final String GNSS_SATELLITE_COUNT_EXTRA = "geolocator_mslSatelliteCount";
  public static final String GNSS_SATELLITES_USED_IN_FIX_EXTRA = "geolocator_mslSatellitesUsedInFix";

  private final Context context;
  private final LocationManager locationManager;
  @Nullable private final LocationOptions locationOptions;

  @TargetApi(Build.VERSION_CODES.N)
  private OnNmeaMessageListener nmeaMessageListener;
  @TargetApi(Build.VERSION_CODES.N)
  private GnssStatus.Callback gnssCallback;

  private String lastNmeaMessage;
  private double gnss_satellite_count;
  private double gnss_satellites_used_in_fix;
  @Nullable private Calendar lastNmeaMessageTime;
  private boolean listenerAdded = false;

  public NmeaClient(@NonNull Context context, @Nullable LocationOptions locationOptions) {
    this.context = context;
    this.locationOptions = locationOptions;
    this.locationManager = (LocationManager) context.getSystemService(Context.LOCATION_SERVICE);

    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
      nmeaMessageListener =
          (message, timestamp) -> {
            if (message.trim().matches("^\\$..GGA.*$")) {
              lastNmeaMessage = message;
              lastNmeaMessageTime = Calendar.getInstance();
            }
          };

        gnssCallback = new GnssStatus.Callback() {
            @Override
            public void onSatelliteStatusChanged(@NonNull GnssStatus status) {
                gnss_satellite_count = status.getSatelliteCount();
                gnss_satellites_used_in_fix = 0;
                for (int i = 0; i < gnss_satellite_count; ++i) {
                    if (status.usedInFix(i)) {
                        ++gnss_satellites_used_in_fix;
                    }
                }
            }
        };
    }
  }

  @SuppressLint("MissingPermission")
  public void start() {
    if (listenerAdded) {
      return;
    }

    if (locationOptions != null) {
      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N && locationManager != null) {
        if (context.checkSelfPermission(Manifest.permission.ACCESS_FINE_LOCATION)
            == PackageManager.PERMISSION_GRANTED) {
          locationManager.addNmeaListener(nmeaMessageListener, null);
          locationManager.registerGnssStatusCallback(gnssCallback, null);
          listenerAdded = true;
        }
      }
    }
  }

  public void stop() {
    if (locationOptions != null) {
      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N && locationManager != null) {
        locationManager.removeNmeaListener(nmeaMessageListener);
        locationManager.unregisterGnssStatusCallback(gnssCallback);
        listenerAdded = false;
      }
    }
  }

  public void enrichExtrasWithNmea(@Nullable Location location) {

    if (location == null) {
      return;
    }

    if (location.getExtras() == null) {
      location.setExtras(Bundle.EMPTY);
    }
    location.getExtras().putDouble(GNSS_SATELLITE_COUNT_EXTRA, gnss_satellite_count);
    location.getExtras().putDouble(GNSS_SATELLITES_USED_IN_FIX_EXTRA, gnss_satellites_used_in_fix);

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
        if (lastNmeaMessage.trim().matches("^\\$..GGA.*$") && tokens.length > 9) {
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
