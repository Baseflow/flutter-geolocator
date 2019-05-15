package com.baseflow.geolocator.data.wrapper;

import io.flutter.plugin.common.EventChannel;

public class EventResponse extends ChannelResponse {

    private final EventChannel.EventSink mSink;

    EventResponse(EventChannel.EventSink sink) {
        this.mSink = sink;
    }

    @Override
    public void success(Object object) {
        mSink.success(object);
    }

    @Override
    public void error(String code, String message, Object details) {
        mSink.error(code, message, details);
    }
}