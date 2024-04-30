part of '../geolocator_ohos.dart';

/// （逆）地理编码转化
mixin GeocoderMixin {
  /// Obtain current location switch status.
  /// 判断地理编码与逆地理编码服务状态。
  /// See also: https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-location-kit/js-apis-geoLocationManager.md#geolocationmanagerisgeocoderavailable
  Future<bool> isGeocoderAvailable() async {
    return await GeolocatorOhos._methodChannel
            .invokeMethod<bool>('isGeocoderAvailable') ??
        false;
  }
  /// Obtain address info from location.
  /// 调用逆地理编码服务，将坐标转换为地理描述。
  /// See also: https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-location-kit/js-apis-geoLocationManager.md#geolocationmanagergetaddressesfromlocation
  Future<List<GeoAddress>> getAddressesFromLocation(
      ReverseGeoCodeRequest request) async {
    List<dynamic> list = await GeolocatorOhos._methodChannel
            .invokeMethod<List<dynamic>>(
                'getAddressesFromLocation', request.toString()) ??
        [];

    return list.map((e) => GeoAddress.fromString(e.toString())).toList();
  }
  
  /// Obtain latitude and longitude info from location address.
  /// 调用地理编码服务，将地理描述转换为具体坐标
  /// https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-location-kit/js-apis-geoLocationManager.md#geolocationmanagergetaddressesfromlocationname
  Future<List<GeoAddress>> getAddressesFromLocationName(
      GeoCodeRequest request) async {
    List<dynamic> list = await GeolocatorOhos._methodChannel
            .invokeMethod<List<dynamic>>(
                'getAddressesFromLocationName', request.toString()) ??
        [];

    return list.map((e) => GeoAddress.fromString(e.toString())).toList();
  }
}
