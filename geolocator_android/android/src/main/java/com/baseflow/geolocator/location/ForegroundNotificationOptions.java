package com.baseflow.geolocator.location;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.Map;

@SuppressWarnings({"ConstantConditions", "unchecked"})
public class ForegroundNotificationOptions {

    @NonNull
    private final String notificationTitle;
    @NonNull
    private final String notificationText;
    @NonNull
    private final AndroidIconResource notificationIcon;
    private final boolean enableWifiLock;
    private final boolean enableWakeLock;
    private final boolean setOngoing;
    private final int color;


    public static ForegroundNotificationOptions parseArguments(@Nullable  Map<String, Object> arguments) {
    if (arguments == null) {
      return null;
    }

    final AndroidIconResource notificationIcon = AndroidIconResource.parseArguments((Map<String, Object>)arguments.get("notificationIcon"));
    final String notificationTitle = (String) arguments.get("notificationTitle");
    final String notificationText = (String) arguments.get("notificationText");
    final Boolean enableWifiLock = (Boolean) arguments.get("enableWifiLock");
    final Boolean enableWakeLock = (Boolean) arguments.get("enableWakeLock");
    final Boolean setOngoing = (Boolean) arguments.get("setOngoing");
    final int color = ((Number) arguments.get("color")).intValue();

    return new ForegroundNotificationOptions(
            notificationTitle,
            notificationText,
            notificationIcon,
            enableWifiLock,
            enableWakeLock,
            setOngoing,
            color);
  }

    private ForegroundNotificationOptions(
        @NonNull String notificationTitle,
        @NonNull String notificationText,
        @NonNull AndroidIconResource notificationIcon,
        boolean enableWifiLock,
        boolean enableWakeLock,
        boolean setOngoing,
        int color) {
        this.notificationTitle = notificationTitle;
        this.notificationText = notificationText;
        this.notificationIcon = notificationIcon;
        this.enableWifiLock = enableWifiLock;
        this.enableWakeLock = enableWakeLock;
        this.setOngoing = setOngoing;
        this.color = color;
    }

    @NonNull
    public String getNotificationTitle() {
        return notificationTitle;
    }

    @NonNull
    public String getNotificationText() {
        return notificationText;
    }

    @NonNull
    public AndroidIconResource getNotificationIcon() {
        return notificationIcon;
    }

    public boolean isEnableWifiLock() {
        return enableWifiLock;
    }

    public boolean isEnableWakeLock() {
        return enableWakeLock;
    }

    public boolean isSetOngoing() {
        return setOngoing;
    }

    public int getColor() {
        return color;
    }
}
