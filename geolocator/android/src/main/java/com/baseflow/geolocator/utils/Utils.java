package com.baseflow.geolocator.utils;

import android.content.Context;
import android.content.Intent;
import android.provider.Settings;

public class Utils {
  public static boolean openAppSettings(Context context) {
    try {
      Intent settingsIntent = new Intent();
      settingsIntent.setAction(android.provider.Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
      settingsIntent.addCategory(Intent.CATEGORY_DEFAULT);
      settingsIntent.setData(android.net.Uri.parse("package:" + context.getPackageName()));
      settingsIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
      settingsIntent.addFlags(Intent.FLAG_ACTIVITY_NO_HISTORY);
      settingsIntent.addFlags(Intent.FLAG_ACTIVITY_EXCLUDE_FROM_RECENTS);

      context.startActivity(settingsIntent);

      return true;
    } catch (Exception ex) {
      return false;
    }
  }

  public static boolean openLocationSettings(Context context) {
    try {
      Intent settingsIntent = new Intent();
      settingsIntent.setAction(Settings.ACTION_LOCATION_SOURCE_SETTINGS);
      settingsIntent.addCategory(Intent.CATEGORY_DEFAULT);
      settingsIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
      settingsIntent.addFlags(Intent.FLAG_ACTIVITY_NO_HISTORY);
      settingsIntent.addFlags(Intent.FLAG_ACTIVITY_EXCLUDE_FROM_RECENTS);

      context.startActivity(settingsIntent);
      return true;
    } catch (Exception ex) {
      return false;
    }
  }
}
