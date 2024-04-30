import 'dart:convert';

import 'package:geolocator_ohos/src/utils.dart';

/// Country code structure.
/// 国家码信息，包含国家码字符串和国家码的来源信息。
/// See also: https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-location-kit/js-apis-geoLocationManager.md#countrycode
class CountryCode {
  /// Country code character string.
  /// 表示国家码字符串。
  final String country;

  /// Country code source.
  /// 表示国家码信息来源。
  final CountryCodeType type;

  CountryCode({required this.country, required this.type});

  factory CountryCode.fromString(String json) {
    return CountryCode._fromMap(jsonDecode(json));
  }

  factory CountryCode._fromMap(Map<String, dynamic> map) {
    return CountryCode(
      country: asT<String>(map['country'])!,
      type: CountryCodeType.values[asT<int>(map['type'])! - 1],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'country': country,
      'type': type.toString(),
    };
  }

  @override
  String toString() {
    return jsonEncode(toMap());
  }
}

/// Enum for country code type.
/// 国家码来源类型。
/// See also: https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-location-kit/js-apis-geoLocationManager.md#countrycodetype
enum CountryCodeType {
  /// Country code obtained from the locale setting.
  /// 从全球化模块的语言配置信息中获取到的国家码。
  countryCodeFromLocale,

  /// Country code obtained from the SIM information.
  /// 从SIM卡中获取到的国家码。
  countryCodeFromSim,

  /// Query the country code information from the reverse geocoding result.
  /// 基于用户的位置信息，通过逆地理编码查询到的国家码。
  countryCodeFromLocation,

  /// Obtain the country code from the cell registration information.
  /// 从蜂窝网络注册信息中获取到的国家码。
  countryCodeFromNetwork
}
