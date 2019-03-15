package com.baseflow.geolocator.data;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;

public class Result {
  private final MethodChannel.Result mMethodResult;
  private final EventChannel.EventSink mEventResult;

  public Result(MethodChannel.Result methodResult) {
    mEventResult = null;
    mMethodResult = methodResult;
  }

  public Result(EventChannel.EventSink eventResult) {
    mEventResult = eventResult;
    mMethodResult = null;
  }

  public void success(Object o) {
    if (mMethodResult != null) {
      mMethodResult.success(o);
    } else {
      assert mEventResult != null;
      mEventResult.success(o);
    }
  }

  public void error(String code, String message, Object details) {
    if (mMethodResult != null) {
      mMethodResult.error(code, message, details);
    } else {
      assert mEventResult != null;
      mEventResult.error(code, message, details);
    }
  }
}
