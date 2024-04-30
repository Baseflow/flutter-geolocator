import 'dart:convert';

import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';

/// Current location information request parameters.
/// 表示当前位置信息请求参数。
/// 参考链接：https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-location-kit/js-apis-geoLocationManager.md#currentlocationrequest
class CurrentLocationSettingsOhos extends LocationSettings {
  const CurrentLocationSettingsOhos({
    this.priority,
    this.scenario,
    this.maxAccuracy,
    this.timeoutMs,
  });

  /// Indicates priority information. When the scenario is UNSET, the priority parameter takes effect; otherwise, the priority parameter does not take effect.
  /// When both scenario and priority are UNSET, location requests cannot be initiated.
  /// See the definition of LocationRequestPriority for the value range.
  /// 表示优先级信息。当场景取值为UNSET时，优先级参数生效；否则，优先级参数不生效。
  /// 当场景和优先级均取值为UNSET时，无法发起定位请求。
  /// 请参阅LocationRequestPriority的定义获取取值范围。
  final LocationRequestPriority? priority;

  /// Indicates scenario information. When the scenario is UNSET, the priority parameter takes effect; otherwise, the priority parameter does not take effect.
  /// When both scenario and priority are UNSET, location requests cannot be initiated.
  /// See the definition of LocationRequestScenario for the value range.
  /// 表示场景信息。当场景取值为UNSET时，优先级参数生效；否则，优先级参数不生效。
  /// 当场景和优先级均取值为UNSET时，无法发起定位请求。
  /// 请参阅LocationRequestScenario的定义获取取值范围。
  final LocationRequestScenario? scenario;

  /// Indicates accuracy information, in meters.
  /// Only effective in accurate location function scenarios (when both ohos.permission.APPROXIMATELY_LOCATION and ohos.permission.LOCATION permissions are granted), and meaningless in fuzzy location function scenarios (when only ohos.permission.APPROXIMATELY_LOCATION permission is granted).
  /// The default value is 0, and the value range is greater than or equal to 0.
  /// When the scenario is NAVIGATION/TRAJECTORY_TRACKING/CAR_HAILING or the priority is ACCURACY, it is recommended to set maxAccuracy to a value greater than 10.
  /// When the scenario is DAILY_LIFE_SERVICE/NO_POWER or the priority is LOW_POWER/FIRST_FIX, it is recommended to set maxAccuracy to a value greater than 100.
  /// 表示精度信息，单位是米。
  /// 仅在精确位置功能场景（同时授予了ohos.permission.APPROXIMATELY_LOCATION和ohos.permission.LOCATION 权限）下有效，模糊位置功能生效场景（仅授予了ohos.permission.APPROXIMATELY_LOCATION 权限）下该字段无意义。
  /// 默认值为0，取值范围为大于等于0。
  /// 当场景为NAVIGATION/TRAJECTORY_TRACKING/CAR_HAILING或者优先级为ACCURACY时，建议将maxAccuracy设置为大于10的值。
  /// 当场景为DAILY_LIFE_SERVICE/NO_POWER或者优先级为LOW_POWER/FIRST_FIX时，建议将maxAccuracy设置为大于100的值。
  final int? maxAccuracy;

  /// Indicates the timeout duration, in milliseconds, with a minimum value of 1000 milliseconds. The value range is greater than or equal to 1000.
  /// 表示超时时间，单位是毫秒，最小为1000毫秒。取值范围为大于等于1000。
  final int? timeoutMs;

  Map<String, dynamic> toMap() {
    return {
      if (priority != null) 'priority': priority?.toInt(),
      if (scenario != null) 'scenario': scenario?.toInt(),
      if (maxAccuracy != null) 'maxAccuracy': maxAccuracy,
      if (timeoutMs != null) 'timeoutMs': timeoutMs,
    };
  }

  @override
  String toString() {
    return jsonEncode(toMap());
  }
}


/// Location information request parameters.
/// 表示位置信息请求参数。
/// 参考链接：https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-location-kit/js-apis-geoLocationManager.md#locationrequest
class LocationSettingsOhos extends LocationSettings {
  const LocationSettingsOhos({
    this.priority,
    this.scenario,
    this.timeInterval,
    this.distanceInterval,
    this.maxAccuracy,
  });

  /// Indicates priority information.
  /// 表示优先级信息。
  final LocationRequestPriority? priority;

  /// Indicates scenario information.
  /// 表示场景信息
  final LocationRequestScenario? scenario;

  /// Indicates the time interval for reporting location information, in seconds. The default value is 1, and the value range is greater than or equal to 0. When it is 0, there is no limit on the reporting time interval for location.
  /// 表示上报位置信息的时间间隔，单位是秒。默认值为1，取值范围为大于等于0。等于0时对位置上报时间间隔无限制。
  final int? timeInterval;

  /// Indicates the distance interval for reporting location information, in meters. The default value is 0, and the value range is greater than or equal to 0. When it is 0, there is no limit on the reporting distance interval for location.
  /// 表示上报位置信息的距离间隔。单位是米，默认值为0，取值范围为大于等于0。等于0时对位置上报距离间隔无限制。
  final int? distanceInterval;

  /// Indicates accuracy information, in meters.
  /// Only effective in accurate location function scenarios (when both ohos.permission.APPROXIMATELY_LOCATION and ohos.permission.LOCATION permissions are granted), and meaningless in fuzzy location function scenarios (when only ohos.permission.APPROXIMATELY_LOCATION permission is granted).
  /// The default value is 0, and the value range is greater than or equal to 0.
  /// When the scenario is NAVIGATION/TRAJECTORY_TRACKING/CAR_HAILING or the priority is ACCURACY, it is recommended to set maxAccuracy to a value greater than 10.
  /// When the scenario is DAILY_LIFE_SERVICE/NO_POWER or the priority is LOW_POWER/FIRST_FIX, it is recommended to set maxAccuracy to a value greater than 100.
  /// 表示精度信息，单位是米。
  /// 仅在精确位置功能场景（同时授予了ohos.permission.APPROXIMATELY_LOCATION和ohos.permission.LOCATION 权限）下有效，模糊位置功能生效场景（仅授予了ohos.permission.APPROXIMATELY_LOCATION 权限）下该字段无意义。
  /// 默认值为0，取值范围为大于等于0。
  /// 当scenario为NAVIGATION/TRAJECTORY_TRACKING/CAR_HAILING或者priority为ACCURACY时建议设置maxAccuracy为大于10的值。
  /// 当scenario为DAILY_LIFE_SERVICE/NO_POWER或者priority为LOW_POWER/FIRST_FIX时建议设置maxAccuracy为大于100的值。
  final int? maxAccuracy;

  Map<String, dynamic> toMap() {
    return {
      if (priority != null) 'priority': priority?.toInt(),
      if (scenario != null) 'scenario': scenario?.toInt(),
      if (timeInterval != null) 'timeInterval': timeInterval,
      if (distanceInterval != null) 'distanceInterval': distanceInterval,
      if (maxAccuracy != null) 'maxAccuracy': maxAccuracy,
    };
  }

  @override
  String toString() {
    return jsonEncode(toMap());
  }
}

/// The type of location information priority in a location request.
/// 位置请求中位置信息优先级类型。
/// See also: https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-location-kit/js-apis-geoLocationManager.md#locationrequestpriority
enum LocationRequestPriority {
  /// 0x200
  /// Indicates unset priority, indicating that LocationRequestPriority is invalid.
  /// 表示未设置优先级，表示LocationRequestPriority无效。
  unset,

  /// Indicates accuracy priority.
  /// 表示精度优先。
  accuracy,

  /// Indicates low power priority.
  /// 表示低功耗优先。
  lowPower,

  /// Indicates fast location acquisition priority. If an application wants to quickly obtain a location, it can set the priority to this field.
  /// 表示快速获取位置优先，如果应用希望快速拿到一个位置，可以将优先级设置为该字段。
  firstFix,
}

/// The type of location scenario in a location request.
/// 位置请求中定位场景类型。
/// See also: https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-location-kit/js-apis-geoLocationManager.md#locationrequestscenario
enum LocationRequestScenario {
  /// 0x300
  /// Indicates unset scenario information.
  /// Indicates that the LocationRequestScenario field is invalid.
  /// 表示未设置场景信息。
  /// 表示LocationRequestScenario字段无效
  unset,

  /// Indicates navigation scenario.
  /// 表示导航场景。
  navigation,

  /// Indicates trajectory tracking scenario.
  /// 表示运动轨迹记录场景。
  trajectoryTracking,

  /// Indicates car hailing scenario.
  /// 表示打车场景。
  carHailing,

  /// Indicates daily life service usage scenario.
  /// 表示日常服务使用场景。
  dailyLifeService,

  /// Indicates no power consumption scenario. In this scenario, location will not be actively triggered. Location will only be returned to the current application when another application triggers location.
  /// 表示无功耗功场景，这种场景下不会主动触发定位，会在其他应用定位时，才给当前应用返回位置。
  noPower,
}

extension _LocationRequestPriority on LocationRequestPriority {
  int toInt() => 0x200 + index;
}

extension _LocationRequestScenario on LocationRequestScenario {
  int toInt() => 0x300 + index;
}
