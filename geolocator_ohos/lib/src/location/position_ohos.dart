import 'dart:convert';

import 'package:geolocator_ohos/src/utils.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';

/// Location information.
/// 位置信息。
/// 参考链接：https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-location-kit/js-apis-geoLocationManager.md#location
class PositionOhos extends Position {
  const PositionOhos({
    required super.longitude,
    required super.latitude,
    required super.timestamp,
    required super.accuracy,
    required super.altitude,
    required super.speed,
    this.direction = 0.0,
    this.timeSinceBoot = 0,
    this.additions,
    this.additionSize,
  }) : super(
          altitudeAccuracy: 0.0,
          heading: 0.0,
          headingAccuracy: 0.0,
          speedAccuracy: 0.0,
          floor: 0,
          isMocked: false,
        );

  /// 表示航向信息。单位是“度”，取值范围为0到360。
  /// Indicates the direction information in degrees, with a value range from 0 to 360.
  final double direction;

  /// 表示位置时间戳，开机时间格式。
  /// Indicates the location timestamp in the format of boot time.
  final int timeSinceBoot;

  /// 附加信息。
  /// Additional information.
  final List<String>? additions;

  /// 附加信息数量。取值范围为大于等于0。
  /// Number of additional information. The value range is greater than or equal to 0.
  final int? additionSize;

  /// Converts the supplied [String] to an instance of the [PositionOhos] class.
  factory PositionOhos.fromString(String message) {
    return PositionOhos._fromMap(jsonDecode(message));
  }

  /// Converts the supplied [Map] to an instance of the [PositionOhos] class.
  factory PositionOhos._fromMap(dynamic message) {
    final Map<dynamic, dynamic> positionMap = message;

    if (!positionMap.containsKey('latitude')) {
      throw ArgumentError.value(positionMap, 'positionMap',
          'The supplied map doesn\'t contain the mandatory key `latitude`.');
    }

    if (!positionMap.containsKey('longitude')) {
      throw ArgumentError.value(positionMap, 'positionMap',
          'The supplied map doesn\'t contain the mandatory key `longitude`.');
    }

    final timestamp = positionMap['timeStamp'] != null
        ? DateTime.fromMillisecondsSinceEpoch(positionMap['timeStamp'].toInt(),
            isUtc: true)
        : null;

    return PositionOhos(
      latitude: asT<double>(positionMap['latitude']) ?? 0.0,
      longitude: asT<double>(positionMap['longitude']) ?? 0.0,
      timestamp: timestamp,
      altitude: asT<double>(positionMap['altitude']) ?? 0.0,
      accuracy: asT<double>(positionMap['accuracy']) ?? 0.0,
      speed: asT<double>(positionMap['speed']) ?? 0.0,
      direction: asT<double>(positionMap['direction']) ?? 0.0,
      timeSinceBoot: asT<int>(positionMap['timeSinceBoot']) ?? 0,
      additions: asT<List<String>>(positionMap['additions']) ?? <String>[],
      additionSize: asT<int>(positionMap['additionSize']) ?? 0,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'longitude': longitude,
      'latitude': latitude,
      'timestamp': timestamp?.millisecondsSinceEpoch,
      'accuracy': accuracy,
      'altitude': altitude,
      'speed': speed,
      'direction': direction,
      'timeSinceBoot': timeSinceBoot,
      'additions': additions,
      'additionSize': additionSize,
    };
  }
}

