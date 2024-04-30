part of '../geolocator_ohos.dart';

/// （逆）地理编码转化
mixin GeocoderImplements {
  /// 判断（逆）地理编码服务状态。
  Future<bool> isGeocoderAvailable() async {
    return await GeolocatorOhos._methodChannel
            .invokeMethod<bool>('isGeocoderAvailable') ??
        false;
  }

  getAddressesFromLocation() async {
    return await GeolocatorOhos._methodChannel
            .invokeMethod<bool>('isGeocoderAvailable') ??
        false;
  }
}
