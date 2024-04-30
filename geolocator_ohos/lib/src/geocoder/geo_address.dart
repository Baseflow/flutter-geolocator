import 'dart:convert';

import 'package:geolocator_ohos/src/utils.dart';

/// Data struct describes geographic locations.
/// 地理编码地址信息。
/// See also: https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-location-kit/js-apis-geoLocationManager.md#geoaddress
class GeoAddress {
  /// Indicates latitude information.
  /// 表示纬度信息，正值表示北纬，负值表示南纬。取值范围为-90到90。
  final double? latitude;

  /// Indicates longitude information.
  /// 表示经度信息，正值表示东经，负值表是西经。取值范围为-180到180。
  final double? longitude;

  /// Indicates language used for the location description.
  /// 表示位置描述信息的语言，“zh”代表中文，“en”代表英文。
  final String? locale;

  /// Indicates landmark of the location.
  /// 表示地区信息。
  final String? placeName;

  /// Indicates country code.
  /// 表示国家码信息。
  final String? countryCode;

  /// Indicates country name.
  /// 表示国家信息。
  final String? countryName;

  /// Indicates administrative region name.
  /// 表示国家以下的一级行政区，一般是省/州。
  final String? administrativeArea;

  /// Indicates sub-administrative region name.
  /// 表示国家以下的二级行政区，一般是市。
  final String? subAdministrativeArea;

  /// Indicates locality information.
  /// 表示城市信息，一般是市。
  final String? locality;

  /// Indicates sub-locality information.
  /// 表示子城市信息，一般是区/县。
  final String? subLocality;

  /// Indicates road name.
  /// 表示路名信息。
  final String? roadName;

  /// Indicates auxiliary road information.
  /// 表示子路名信息。
  final String? subRoadName;

  /// Indicates house information.
  /// 表示门牌号信息
  final String? premises;

  /// Indicates postal code.
  /// 表示邮政编码信息。
  final String? postalCode;

  /// Indicates phone number.
  /// 表示联系方式信息。
  final String? phoneNumber;

  /// Indicates website URL.
  /// 表示位置信息附件的网址信息。
  final String? addressUrl;

  /// Indicates additional information.
  /// 表示附加的描述信息。目前包含城市编码cityCode（Array下标为0）和区划编码adminCode（Array下标为1），例如["025","320114001"]。
  final List<String>? descriptions;

  /// Indicates the amount of additional descriptive information.
  /// 	表示附加的描述信息数量。取值范围为大于等于0，推荐该值小于10。
  final int? descriptionsSize;

  GeoAddress({
    this.latitude,
    this.longitude,
    this.locale,
    this.placeName,
    this.countryCode,
    this.countryName,
    this.administrativeArea,
    this.subAdministrativeArea,
    this.locality,
    this.subLocality,
    this.roadName,
    this.subRoadName,
    this.premises,
    this.postalCode,
    this.phoneNumber,
    this.addressUrl,
    this.descriptions,
    this.descriptionsSize,
  });

  factory GeoAddress.fromString(String json) {
    return GeoAddress._fromMap(jsonDecode(json));
  }

  /// Converts the supplied [Map] to an instance of the [GeoAddress] class.
  factory GeoAddress._fromMap(Map<String, dynamic> map) {
    return GeoAddress(
      latitude: asT<double>(map['latitude']),
      longitude: asT<double>(map['longitude']),
      locale: asT<String>(map['locale']),
      placeName: asT<String>(map['placeName']),
      countryCode: asT<String>(map['countryCode']),
      countryName: asT<String>(map['countryName']),
      administrativeArea: asT<String>(map['administrativeArea']),
      subAdministrativeArea: asT<String>(map['subAdministrativeArea']),
      locality: asT<String>(map['locality']),
      subLocality: asT<String>(map['subLocality']),
      roadName: asT<String>(map['roadName']),
      subRoadName: asT<String>(map['subRoadName']),
      premises: asT<String>(map['premises']),
      postalCode: asT<String>(map['postalCode']),
      phoneNumber: asT<String>(map['phoneNumber']),
      addressUrl: asT<String>(map['addressUrl']),
      descriptions: asT<List<String>>(map['descriptions']),
      descriptionsSize: asT<int>(map['descriptionsSize']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (locale != null) 'locale': locale,
      if (placeName != null) 'placeName': placeName,
      if (countryCode != null) 'countryCode': countryCode,
      if (countryName != null) 'countryName': countryName,
      if (administrativeArea != null) 'administrativeArea': administrativeArea,
      if (subAdministrativeArea != null)
        'subAdministrativeArea': subAdministrativeArea,
      if (locality != null) 'locality': locality,
      if (subLocality != null) 'subLocality': subLocality,
      if (roadName != null) 'roadName': roadName,
      if (subRoadName != null) 'subRoadName': subRoadName,
      if (premises != null) 'premises': premises,
      if (postalCode != null) 'postalCode': postalCode,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (addressUrl != null) 'addressUrl': addressUrl,
      if (descriptions != null) 'descriptions': descriptions,
      if (descriptionsSize != null) 'descriptionsSize': descriptionsSize,
    };
  }

  @override
  String toString() {
    return jsonEncode(toMap());
  }
}
