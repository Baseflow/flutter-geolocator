package com.baseflow.geolocator.tasks;

import android.content.Context;

import com.baseflow.geolocator.OnCompletionListener;
import com.baseflow.geolocator.data.wrapper.ChannelResponse;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

final class TaskContext<TOptions> {
  private final TOptions mOptions;
  private final OnCompletionListener mCompletionListener;
  private final PluginRegistry.Registrar mRegistrar;
  private final ChannelResponse mChannelResponse;


  private TaskContext(
      PluginRegistry.Registrar registrar,
      ChannelResponse channelResponse,
      TOptions options,
      OnCompletionListener completionListener) {
    mRegistrar = registrar;
    mChannelResponse = channelResponse;
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
    return mRegistrar.context();
  }

  ChannelResponse getResult() {
    return mChannelResponse;
  }

  static <TOptions> TaskContext<TOptions> buildForMethodResult(
      PluginRegistry.Registrar registrar,
      MethodChannel.Result methodResult,
      TOptions options,
      OnCompletionListener completionListener) {
    ChannelResponse channelResponse = ChannelResponse.wrap(methodResult);

    return new TaskContext<>(
        registrar,
        channelResponse,
        options,
        completionListener);
  }

  static <TOptions> TaskContext<TOptions> buildForEventSink(
      PluginRegistry.Registrar registrar,
      EventChannel.EventSink eventSink,
      TOptions options,
      OnCompletionListener completionListener) {
    ChannelResponse channelResponse = ChannelResponse.wrap(eventSink);

    return new TaskContext<>(
        registrar,
        channelResponse,
        options,
        completionListener);
  }
}
