package com.baseflow.geolocator.location;

import androidx.annotation.Nullable;

import java.util.Map;

@SuppressWarnings({"ConstantConditions", "unchecked"})
public class ForegroundNotificationOptions {

    private final NotificationImportance notificationImportance;
    private final String notificationTitle;
    private final String notificationText;
    private final AndroidIconResource notificationIcon;
    private final boolean enableWifiLock;
    private final boolean enableWakeLock;


    public static ForegroundNotificationOptions parseArguments(@Nullable  Map<String, Object> arguments) {
    if (arguments == null) {
      return null;
    }

    final NotificationImportance notificationImportance = NotificationImportance.values()[(Integer) arguments.get("notificationImportance")];
    final AndroidIconResource notificationIcon = AndroidIconResource.parseArguments((Map<String, Object>)arguments.get("notificationIcon"));
    final String notificationTitle = (String) arguments.get("notificationTitle");
    final String notificationText = (String) arguments.get("notificationText");
    final Boolean enableWifiLock = (Boolean) arguments.get("enableWifiLock");
    final Boolean enableWakeLock = (Boolean) arguments.get("enableWakeLock");

    return new ForegroundNotificationOptions(notificationImportance,
            notificationTitle,
            notificationText,
            notificationIcon,
            enableWifiLock,
            enableWakeLock);
  }

    private ForegroundNotificationOptions(NotificationImportance notificationImportance, String notificationTitle, String notificationText, AndroidIconResource notificationIcon, boolean enableWifiLock, boolean enableWakeLock) {
        this.notificationImportance = notificationImportance;
        this.notificationTitle = notificationTitle;
        this.notificationText = notificationText;
        this.notificationIcon = notificationIcon;
        this.enableWifiLock = enableWifiLock;
        this.enableWakeLock = enableWakeLock;
    }
    public NotificationImportance getNotificationImportance() {
        return notificationImportance;
    }

    public String getNotificationTitle() {
        return notificationTitle;
    }

    public String getNotificationText() {
        return notificationText;
    }

    public AndroidIconResource getNotificationIcon() {
        return notificationIcon;
    }

    public boolean isEnableWifiLock() {
        return enableWifiLock;
    }

    public boolean isEnableWakeLock() {
        return enableWakeLock;
    }

}
