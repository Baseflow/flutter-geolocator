import 'dart:convert';


/// Configuring parameters in geocode requests.
/// 地理编码请求参数。
/// See also: https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-location-kit/js-apis-geoLocationManager.md#geocoderequest
class GeoCodeRequest {
  /// Indicates the language area information.
  /// 表示位置描述信息的语言，“zh”代表中文，“en”代表英文。默认值从设置中的“语言和地区”获取。
  final String? locale;

  /// Address information.
  /// 表示位置信息描述，如“上海市浦东新区xx路xx号”。
  final String description;

  /// Indicates the maximum number of geocode query results.
  /// 表示返回位置信息的最大个数。取值范围为大于等于0，推荐该值小于10。默认值是1。
  final int? maxItems;

  /// Indicates the minimum latitude for geocoding query results.
  /// 表示最小纬度信息，与下面三个参数一起，表示一个经纬度范围。取值范围为-90到90。
  final double? minLatitude;

  /// Indicates the minimum longitude for geocoding query results.
  /// 表示最小经度信息。取值范围为-180到180。
  final double? minLongitude;

  /// Indicates the maximum latitude for geocoding query results.
  /// 表示最大纬度信息。取值范围为-90到90。
  final double? maxLatitude;

  /// Indicates the maximum longitude for geocoding query results.
  /// 表示最大经度信息。取值范围为-180到180
  final double? maxLongitude;

  GeoCodeRequest({
    required this.description,
    this.locale,
    this.maxItems,
    this.minLatitude,
    this.minLongitude,
    this.maxLatitude,
    this.maxLongitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      if (locale != null) 'locale': locale,
      if (maxItems != null) 'maxItems': maxItems,
      if (minLatitude != null) 'minLatitude': minLatitude,
      if (minLongitude != null) 'minLongitude': minLongitude,
      if (maxLatitude != null) 'maxLatitude': maxLatitude,
      if (maxLongitude != null) 'maxLongitude': maxLongitude,
    };
  }

  @override
  String toString() {
    return jsonEncode(toMap());
  }
}

