package com.baseflow.geolocator.utils;

import android.os.Handler;
import android.os.Looper;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.baseflow.geolocator.data.wrapper.ChannelResponse;

public class MainThreadDispatcher {
    private static Handler handler = new Handler(Looper.getMainLooper());

    public static void dispatch(Runnable runnable) {
        initHandlerIfNull();
        handler.post(runnable);
    }

    private static void initHandlerIfNull() {
        if (handler == null) {
            handler = new Handler(Looper.getMainLooper());
        }
    }

    public static void dispatchError(@NonNull final ChannelResponse channelResponse, @NonNull final String channelName,
                                     @NonNull final String error, @Nullable final Object details) {
        initHandlerIfNull();
        handler.post(new Runnable() {
            @Override
            public void run() {
                channelResponse.error(channelName, error, details);
            }
        });
    }

    public static void dispatchSuccess(@NonNull final ChannelResponse channelResponse, final Object result) {
        initHandlerIfNull();
        handler.post(new Runnable() {
            @Override
            public void run() {
                channelResponse.success(result);
            }
        });
    }
}
