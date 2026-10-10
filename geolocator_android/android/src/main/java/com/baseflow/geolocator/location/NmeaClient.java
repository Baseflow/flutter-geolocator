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
import android.os.Handler;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.Calendar;
import java.util.concurrent.Executor;

public class NmeaClient {

  public static final String NMEA_ALTITUDE_EXTRA = "geolocator_mslAltitude";
  public static final String GNSS_SATELLITE_COUNT_EXTRA = "geolocator_mslSatelliteCount";
  public static final String GNSS_SATELLITES_USED_IN_FIX_EXTRA = "geolocator_mslSatellitesUsedInFix";
  public static final String VERTICAL_SPEED_EXTRA = "geolocator_verticalSpeed";
  public static final String VERTICAL_SPEED_ACCURACY_EXTRA = "geolocator_verticalSpeedAccuracy";

  private final Context context;
  private final LocationManager locationManager;
  @Nullable private final LocationOptions locationOptions;

  @TargetApi(Build.VERSION_CODES.N)
  private OnNmeaMessageListener nmeaMessageListener;
  @TargetApi(Build.VERSION_CODES.N)
  private GnssStatus.Callback gnssCallback;

  // Written on the NMEA thread, read when a location is enriched.
  private volatile String lastNmeaMessage;
  private volatile double gnss_satellite_count;
  private volatile double gnss_satellites_used_in_fix;
  @Nullable private volatile Calendar lastNmeaMessageTime;

  // Registration runs on [registrationExecutor], off the Android main thread: the calls are
  // binder transactions that block while the system location service is slow (ANR).
  private final Executor registrationExecutor;
  @Nullable private final Handler callbackHandler;
  private final boolean nmeaSupported;
  // What the caller asked for; read by queued registration work.
  private volatile boolean active = false;
  // Whether the listeners are registered right now; only the executor writes it.
  private volatile boolean listenerAdded = false;

  public NmeaClient(@NonNull Context context, @Nullable LocationOptions locationOptions) {
    this(
        context,
        locationOptions,
        NmeaThread::post,
        NmeaThread.handler(),
        Build.VERSION.SDK_INT >= Build.VERSION_CODES.N);
  }

  NmeaClient(
      @NonNull Context context,
      @Nullable LocationOptions locationOptions,
      @NonNull Executor registrationExecutor,
      @Nullable Handler callbackHandler,
      boolean nmeaSupported) {
    this.context = context;
    this.locationOptions = locationOptions;
    this.locationManager = (LocationManager) context.getSystemService(Context.LOCATION_SERVICE);
    this.registrationExecutor = registrationExecutor;
    this.callbackHandler = callbackHandler;
    this.nmeaSupported = nmeaSupported;

    if (nmeaSupported) {
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

  /** Stops the shared NMEA thread after its queued work; call when the plugin detaches. */
  public static void releaseThread() {
    NmeaThread.quit();
  }

  /** Asks for the listeners; they are registered on the registration executor. */
  public void start() {
    if (active) {
      return;
    }
    active = true;
    registrationExecutor.execute(this::register);
  }

  /** Asks to remove the listeners; safe before the matching registration has run. */
  public void stop() {
    active = false;
    registrationExecutor.execute(this::unregister);
  }

  @SuppressLint("MissingPermission")
  private void register() {
    // A stop() queued after this start() runs next and removes what this adds; a stop()
    // that came before this ran means the caller no longer wants the listeners.
    if (!active || listenerAdded) {
      return;
    }

    if (locationOptions != null) {
      if (nmeaSupported && locationManager != null) {
        if (context.checkSelfPermission(Manifest.permission.ACCESS_FINE_LOCATION)
            == PackageManager.PERMISSION_GRANTED) {
          locationManager.addNmeaListener(nmeaMessageListener, callbackHandler);
          locationManager.registerGnssStatusCallback(gnssCallback, callbackHandler);
          listenerAdded = true;
        }
      }
    }
  }

  private void unregister() {
    if (active || !listenerAdded) {
      return;
    }
    if (locationOptions != null) {
      if (nmeaSupported && locationManager != null) {
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
