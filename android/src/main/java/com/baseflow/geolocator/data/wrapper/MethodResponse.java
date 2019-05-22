package com.baseflow.geolocator.data.wrapper;

import io.flutter.plugin.common.MethodChannel;

/**
 * Instances of this class are invalidated once the wrapped {@link MethodChannel.Result}
 * instance has been used for communication.
 */
public class MethodResponse extends ChannelResponse {

    private MethodChannel.Result mResult;

    MethodResponse(MethodChannel.Result result) {
        this.mResult = result;
    }

    @Override
    public void success(Object object) {
        synchronized (this) {
            if (mResult != null) {
                mResult.success(object);
                mResult = null;
            }
        }
    }

    @Override
    public void error(String code, String message, Object details) {
        synchronized (this) {
            if (mResult != null) {
                mResult.error(code, message, details);
                mResult = null;
            }
        }
    }
}