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
  private final Context mContext;
  private final ChannelResponse mChannelResponse;

  private TaskContext(
      Context context,
      ChannelResponse channelResponse,
      TOptions options,
      OnCompletionListener completionListener) {
    mContext = context;
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

  Context getAndroidContext() {
    return mContext;
  }

  ChannelResponse getResult() {
    return mChannelResponse;
  }

  static <TOptions> TaskContext<TOptions> buildForMethodResult(
      Context context,
      MethodChannel.Result methodResult,
      TOptions options,
      OnCompletionListener completionListener) {
    ChannelResponse channelResponse = ChannelResponse.wrap(methodResult);

    return new TaskContext<>(
        context,
        channelResponse,
        options,
        completionListener);
  }

  static <TOptions> TaskContext<TOptions> buildForEventSink(
      Context context,
      EventChannel.EventSink eventSink,
      TOptions options,
      OnCompletionListener completionListener) {
    ChannelResponse channelResponse = ChannelResponse.wrap(eventSink);

    return new TaskContext<>(
        context,
        channelResponse,
        options,
        completionListener);
  }
}
