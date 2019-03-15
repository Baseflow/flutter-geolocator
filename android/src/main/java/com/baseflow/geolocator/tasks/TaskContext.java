package com.baseflow.geolocator.tasks;

import android.content.Context;

import com.baseflow.geolocator.OnCompletionListener;
import com.baseflow.geolocator.data.Result;

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

  TOptions getOptions() {
    return mOptions;
  }

  OnCompletionListener getCompletionListener() {
    return mCompletionListener;
  }

  PluginRegistry.Registrar getRegistrar() {
    return mRegistrar;
  }

  Context getAndroidContext() {
    return mRegistrar.activity() != null ? mRegistrar.activity() : mRegistrar.activeContext();
  }

  Result getResult() {
    return mResult;
  }

  static <TOptions> TaskContext<TOptions> buildForMethodResult(
      PluginRegistry.Registrar registrar,
      MethodChannel.Result methodResult,
      TOptions options,
      OnCompletionListener completionListener) {
    return new TaskContext<>(
        registrar,
        new Result(methodResult),
        options,
        completionListener);
  }

  static <TOptions> TaskContext<TOptions> buildForEventSink(
      PluginRegistry.Registrar registrar,
      EventChannel.EventSink eventSink,
      TOptions options,
      OnCompletionListener completionListener) {
    return new TaskContext<>(
        registrar,
        new Result(eventSink),
        options,
        completionListener);
  }
}
