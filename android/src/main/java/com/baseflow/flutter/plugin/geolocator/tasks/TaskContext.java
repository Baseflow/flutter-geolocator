package com.baseflow.flutter.plugin.geolocator.tasks;

import android.content.Context;

import com.baseflow.flutter.plugin.geolocator.OnCompletionListener;
import com.baseflow.flutter.plugin.geolocator.data.Result;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

final class TaskContext {
    private final Object mArguments;
    private final OnCompletionListener mCompletionListener;
    private final PluginRegistry.Registrar mRegistrar;
    private final Result mResult;


    private TaskContext(
            PluginRegistry.Registrar registrar,
            Result result,
            Object arguments,
            OnCompletionListener completionListener) {
        mRegistrar = registrar;
        mResult = result;
        mArguments = arguments;
        mCompletionListener = completionListener;
    }

    public Object getArguments() {
        return mArguments;
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

    public static TaskContext buildFromMethodResult(
            PluginRegistry.Registrar registrar,
            MethodChannel.Result methodResult,
            Object arguments,
            OnCompletionListener completionListener) {
        Result result = new Result(methodResult);

        return new TaskContext(
                registrar,
                result,
                arguments,
                completionListener);
    }

    public static TaskContext buildFromEventSink(
            PluginRegistry.Registrar registrar,
            EventChannel.EventSink eventSink,
            Object arguments,
            OnCompletionListener completionListener) {
        Result result = new Result(eventSink);

        return new TaskContext(
                registrar,
                result,
                arguments,
                completionListener);
    }
}
