package com.baseflow.geolocator.location;

import com.baseflow.geolocator.errors.ErrorCodes;

import io.flutter.plugin.common.MethodChannel;

public class FlutterLocationServiceListener implements LocationServiceListener {
  private MethodChannel.Result result;

  public FlutterLocationServiceListener(MethodChannel.Result result) {
    this.result = result;
  }

  @Override
  public void onLocationServiceResult(boolean isEnabled) {
    result.success(isEnabled);
  }

  @Override
  public void onLocationServiceError(ErrorCodes errorCode) {
    result.error(errorCode.toString(), errorCode.toDescription(), null);
  }
}
