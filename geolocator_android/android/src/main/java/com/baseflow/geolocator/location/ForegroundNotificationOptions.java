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
    private final String notificationChannelName;
    @NonNull
    private final AndroidIconResource notificationIcon;
    private final boolean enableWifiLock;
    private final boolean enableWakeLock;
    private final boolean setOngoing;
    @Nullable
    private final Integer color;
    @Nullable
    private final Integer notificationId;

    public static ForegroundNotificationOptions parseArguments(@Nullable  Map<String, Object> arguments) {
    if (arguments == null) {
      return null;
    }

    final AndroidIconResource notificationIcon = AndroidIconResource.parseArguments((Map<String, Object>)arguments.get("notificationIcon"));
    final String notificationTitle = (String) arguments.get("notificationTitle");
    final String notificationChannelName = (String) arguments.get("notificationChannelName");
    final String notificationText = (String) arguments.get("notificationText");
    final Boolean enableWifiLock = (Boolean) arguments.get("enableWifiLock");
    final Boolean enableWakeLock = (Boolean) arguments.get("enableWakeLock");
    final Boolean setOngoing = (Boolean) arguments.get("setOngoing");

    @Nullable Integer color = null;
    final Object colorObject = arguments.get("color");
    if (colorObject != null) {
        color = ((Number) colorObject).intValue();
    }

    @Nullable Integer notificationId = null;
    final Object notificationIdObject = arguments.get("notificationId");
    if (notificationIdObject != null) {
        notificationId = ((Number) notificationIdObject).intValue();
    }

    return new ForegroundNotificationOptions(
            notificationTitle,
            notificationText,
            notificationChannelName,
            notificationIcon,
            enableWifiLock,
            enableWakeLock,
            setOngoing,
            color,
            notificationId);
  }

    private ForegroundNotificationOptions(
        @NonNull String notificationTitle,
        @NonNull String notificationText,
        @NonNull String notificationChannelName,
        @NonNull AndroidIconResource notificationIcon,
        boolean enableWifiLock,
        boolean enableWakeLock,
        boolean setOngoing,
        @Nullable Integer color,
        @Nullable Integer notificationId) {
        this.notificationTitle = notificationTitle;
        this.notificationText = notificationText;
        this.notificationChannelName = notificationChannelName;
        this.notificationIcon = notificationIcon;
        this.enableWifiLock = enableWifiLock;
        this.enableWakeLock = enableWakeLock;
        this.setOngoing = setOngoing;
        this.color = color;
        this.notificationId = notificationId;
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
    public String getNotificationChannelName() {
        return notificationChannelName;
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

    @Nullable public Integer getColor() {
        return color;
    }

    @Nullable public Integer getNotificationId() {
        return notificationId;
    }
}
