package com.baseflow.flutter.plugin.geolocator.data.wrapper;

import io.flutter.plugin.common.MethodChannel;

/**
 * Instances of this class are invalidated once the wrapped {@link MethodChannel.Result}
 * instance has been used for communication.
 */
public class MethodResponse extends ChannelResponse {

    private final MethodChannel.Result result;
    private boolean responseSent;

    MethodResponse(MethodChannel.Result result) {
        this.result = result;
        responseSent = false;
    }

    @Override
    public void success(Object object) {
        synchronized (this) {
            if (!responseSent) {
                result.success(object);
                responseSent = true;
            }
        }
    }

    @Override
    public void error(String code, String message, Object details) {
        synchronized (this) {
            if (!responseSent) {
                result.error(code, message, details);
                responseSent = true;
            }
        }
    }
}
