package com.baseflow.geolocator.location;

import com.baseflow.geolocator.errors.ErrorCodes;

import io.flutter.plugin.common.MethodChannel;

public interface LocationServiceListener {
  void onLocationServiceResult(boolean isEnabled);

  void onLocationServiceError(ErrorCodes errorCode);
}
