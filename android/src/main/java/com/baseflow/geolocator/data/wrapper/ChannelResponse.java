package com.baseflow.geolocator.data.wrapper;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;

/**
 * Wraps event- and method channel communication into a shared interface.
 */
public abstract class ChannelResponse {

    public static ChannelResponse wrap(Object responder) {
        if (responder instanceof EventChannel.EventSink) {
            return new EventResponse((EventChannel.EventSink) responder);
        } else if (responder instanceof MethodChannel.Result) {
            return new MethodResponse((MethodChannel.Result) responder);
        } else {
            throw new IllegalArgumentException();
        }
    }

    public abstract void success(Object object);

    public abstract void error(String code, String message, Object details);
}