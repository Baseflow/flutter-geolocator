package com.baseflow.geolocator.location;

import android.app.Activity;

import com.baseflow.geolocator.errors.ErrorCallback;

public interface LocationClient {
  void isLocationServiceEnabled(LocationServiceListener listener);

  void getLastKnownPosition(
      PositionChangedCallback positionChangedCallback, ErrorCallback errorCallback);

  boolean onActivityResult(int requestCode, int resultCode);

  void startPositionUpdates(
      Activity activity,
      PositionChangedCallback positionChangedCallback,
      ErrorCallback errorCallback);

  void stopPositionUpdates();
}
