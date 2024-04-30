
import 'dart:convert';

/// Configuring parameters in reverse geocode requests.
/// 逆地理编码请求参数。
/// See also: https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-location-kit/js-apis-geoLocationManager.md#reversegeocoderequest
class ReverseGeoCodeRequest {
  /// Indicates the language area information.
  /// 指定位置描述信息的语言，“zh”代表中文，“en”代表英文。默认值从设置中的“语言和地区”获取。
  final String? locale;

  /// Latitude for reverse geocoding query.
  /// 表示纬度信息，正值表示北纬，负值表示南纬。取值范围为-90到90。
  final double latitude;

  /// Longitude for reverse geocoding query.
  /// 表示经度信息，正值表示东经，负值表示西经。取值范围为-180到180。
  final double longitude;

  /// Indicates the maximum number of addresses returned by reverse geocoding query.
  /// 指定返回位置信息的最大个数。取值范围为大于等于0，推荐该值小于10。默认值是1。
  final int? maxItems;

  ReverseGeoCodeRequest({
    this.locale,
    required this.latitude,
    required this.longitude,
    this.maxItems,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'latitude': latitude,
      'longitude': longitude,
      if (locale != null) 'locale': locale,
      if (maxItems != null) 'maxItems': maxItems,
    };
  }

  @override
  String toString() {
    return jsonEncode(toMap());
  }
}
