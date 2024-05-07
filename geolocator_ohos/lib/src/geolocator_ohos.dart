import 'dart:async';

import 'package:flutter/services.dart';
import 'package:geolocator_ohos/geolocator_ohos.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
part 'geocoder/geocoder.dart';
part 'gnss_fence/gnss_fence_status.dart';
part 'location/location.dart';
part 'common/common.dart';

/// An implementation of [GeolocatorPlatform] that uses method channels.
class GeolocatorOhos extends LocationImplements
    with GeocoderMixin, GnssFenceStatusMixin, CommonMixin {
  /// The method channel used to interact with the native platform.
  static const _methodChannel =
      MethodChannel('flutter.baseflow.com/geolocator_ohos');

  /// Obtained approximate location with an accuracy of 5 kilometers.
  /// 获取到模糊位置，精确度为5公里。
  /// See also: https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/device/location/location-guidelines.md#%E7%94%B3%E8%AF%B7%E4%BD%8D%E7%BD%AE%E6%9D%83%E9%99%90%E5%BC%80%E5%8F%91%E6%8C%87%E5%AF%BC
  static const approximatelyPermission = <String>[
    'ohos.permission.APPROXIMATELY_LOCATION',
  ];

  /// Obtained precise location with accuracy at the meter level.
  /// 获取到精准位置，精准度在米级别。
  /// See also: https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/device/location/location-guidelines.md#%E7%94%B3%E8%AF%B7%E4%BD%8D%E7%BD%AE%E6%9D%83%E9%99%90%E5%BC%80%E5%8F%91%E6%8C%87%E5%AF%BC
  static const accuracyPermissions = <String>[
    'ohos.permission.LOCATION',
    'ohos.permission.APPROXIMATELY_LOCATION',
  ];

  /// Allow background running.
  /// When the user clicks on the popup to grant foreground location permission, the application informs the user through popups, prompts, or other means to go to the settings interface to grant background location permission.
  /// The user should select "Allow all the time" for the application to access location information permission in the settings interface, completing the manual granting process.
  /// 允许后台运行
  /// 当用户点击弹窗授予前台位置权限后，应用通过弹窗、提示窗等形式告知用户前往设置界面授予后台位置权限。
  /// 用户在设置界面中的选择“始终允许”应用访问位置信息权限，完成手动授予。
  /// See also: https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/device/location/location-guidelines.md#%E7%94%B3%E8%AF%B7%E4%BD%8D%E7%BD%AE%E6%9D%83%E9%99%90%E5%BC%80%E5%8F%91%E6%8C%87%E5%AF%BC
  static const inBackgroundPermission = <String>[
    'ohos.permission.LOCATION_IN_BACKGROUND',
  ];

  /// Registers this class as the default instance of [GeolocatorPlatform].
  static void registerWith() {
    GeolocatorPlatform.instance = GeolocatorOhos();
  }
}
