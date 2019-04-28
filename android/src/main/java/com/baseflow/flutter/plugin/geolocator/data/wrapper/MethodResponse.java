package com.baseflow.flutter.plugin.geolocator.data.wrapper;

import io.flutter.plugin.common.MethodChannel;

/**
 * Instances of this class are invalidated once the wrapped {@link MethodChannel.Result}
 * instance has been used for communication.
 */
public class MethodResponse extends ChannelResponse {

    private MethodChannel.Result result;

    MethodResponse(MethodChannel.Result result) {
        this.result = result;
    }

    @Override
    public void success(Object object) {
        synchronized (this) {
            if (result != null) {
                result.success(object);
                result = null;
            }
        }
    }

    @Override
    public void error(String code, String message, Object details) {
        synchronized (this) {
            if (result != null) {
                result.error(code, message, details);
                result = null;
            }
        }
    }
}
