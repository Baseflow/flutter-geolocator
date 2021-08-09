package com.baseflow.geolocator.nmea;


@FunctionalInterface
public interface NmeaChangedCallback {

  void onNmeaMessage(String message, long timeStamp);
}
