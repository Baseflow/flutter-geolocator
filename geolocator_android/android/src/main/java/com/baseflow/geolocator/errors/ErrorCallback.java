package com.baseflow.geolocator.errors;

@FunctionalInterface
public interface ErrorCallback {
  void onError(ErrorCodes errorCode);
}
