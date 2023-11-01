package com.baseflow.geolocator.location;

import android.annotation.SuppressLint;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.os.Build;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;

public class BackgroundNotification {
    @NonNull
    private final Context context;
    @NonNull
    private final Integer notificationId;
    @NonNull
    private final String channelId;
    @NonNull
    private NotificationCompat.Builder builder;

    public BackgroundNotification(
        @NonNull Context context,
        @NonNull String channelId ,
        @NonNull Integer notificationId,
        ForegroundNotificationOptions options
    ) {
        this.context = context;
        this.notificationId = notificationId;
        this.channelId = channelId;
        builder = new NotificationCompat.Builder(context, channelId)
                .setPriority(NotificationCompat.PRIORITY_HIGH);
        updateNotification(options, false);
    }

    private int getDrawableId(String iconName, String defType) {
        return context.getResources().getIdentifier(iconName, defType, context.getPackageName());
    }

    @SuppressLint("UnspecifiedImmutableFlag")
    private PendingIntent buildBringToFrontIntent() {
        Intent intent = context.getPackageManager()
                .getLaunchIntentForPackage(context.getPackageName());

        if (intent != null) {
            intent.setPackage(null);
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_RESET_TASK_IF_NEEDED);
            int flags = PendingIntent.FLAG_UPDATE_CURRENT;
            if (Build.VERSION.SDK_INT > Build.VERSION_CODES.M) {
                flags = flags | PendingIntent.FLAG_IMMUTABLE;
            }
            return PendingIntent.getActivity(context, 0, intent, flags);
        }

        return null;
    }

    public void updateChannel(String channelName) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationManagerCompat notificationManager = NotificationManagerCompat.from(context);
            NotificationChannel channel = new NotificationChannel(
                    channelId,
                    channelName,
                    NotificationManager.IMPORTANCE_NONE
            );
            channel.setLockscreenVisibility(Notification.VISIBILITY_PRIVATE);
            notificationManager.createNotificationChannel(channel);
        }
    }

    private void updateNotification(
            ForegroundNotificationOptions options,
            boolean notify
    ) {
        int iconId = getDrawableId(options.getNotificationIcon().getName(), options.getNotificationIcon().getDefType());
        if(iconId == 0) {
            getDrawableId("ic_launcher.png", "mipmap");
        }

        builder = builder
                .setContentTitle(options.getNotificationTitle())
                .setSmallIcon(iconId)
                .setContentText(options.getNotificationText())
                .setContentIntent(buildBringToFrontIntent())
                .setOngoing(options.isSetOngoing());

        @Nullable final Integer notificationColor = options.getColor();
        if (notificationColor != null) {
            builder = builder
                .setColor(notificationColor);
        }

        if (notify) {
            NotificationManagerCompat notificationManager = NotificationManagerCompat.from(context);
            notificationManager.notify(notificationId, builder.build());
        }
    }

    public void updateOptions(ForegroundNotificationOptions options, boolean isVisible) {
        updateNotification(options, isVisible);
    }

    public Notification build() {
        return builder.build();
    }
}
