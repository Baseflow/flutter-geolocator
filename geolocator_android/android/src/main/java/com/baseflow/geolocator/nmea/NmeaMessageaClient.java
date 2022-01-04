package com.baseflow.geolocator.nmea;

import com.baseflow.geolocator.errors.ErrorCallback;

public interface NmeaMessageaClient {

  void startNmeaUpdates(NmeaChangedCallback nmeaChangedCallback,
                        ErrorCallback errorCallback);

  void stopNmeaUpdates();
}