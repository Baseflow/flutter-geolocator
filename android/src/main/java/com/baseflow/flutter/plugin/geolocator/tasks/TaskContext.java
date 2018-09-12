package com.baseflow.flutter.plugin.geolocator.tasks;

import android.content.Context;

import com.baseflow.flutter.plugin.geolocator.OnCompletionListener;
import com.baseflow.flutter.plugin.geolocator.data.Result;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

final class TaskContext<TOptions> {
    private final TOptions mOptions;
    private final OnCompletionListener mCompletionListener;
    private final PluginRegistry.Registrar mRegistrar;
    private final Result mResult;


    private TaskContext(
            PluginRegistry.Registrar registrar,
            Result result,
            TOptions options,
            OnCompletionListener completionListener) {
        mRegistrar = registrar;
        mResult = result;
        mOptions = options;
        mCompletionListener = completionListener;
    }

    public TOptions getOptions() {
        return mOptions;
    }

    public OnCompletionListener getCompletionListener() {
        return mCompletionListener;
    }

    public PluginRegistry.Registrar getRegistrar() {
        return mRegistrar;
    }

    public Context getAndroidContext() { return mRegistrar.activity() != null ? mRegistrar.activity() : mRegistrar.activeContext(); }

    public Result getResult() {
        return mResult;
    }

    public static <TOptions> TaskContext<TOptions> buildForMethodResult(
            PluginRegistry.Registrar registrar,
            MethodChannel.Result methodResult,
            TOptions options,
            OnCompletionListener completionListener) {
        Result result = new Result(methodResult);

        return new TaskContext(
                registrar,
                result,
                options,
                completionListener);
    }

    public static <TOptions> TaskContext<TOptions> buildForEventSink(
            PluginRegistry.Registrar registrar,
            EventChannel.EventSink eventSink,
            TOptions options,
            OnCompletionListener completionListener) {
        Result result = new Result(eventSink);

        return new TaskContext(
                registrar,
                result,
                options,
                completionListener);
    }
}
