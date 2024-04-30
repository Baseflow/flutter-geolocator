part of '../geolocator_ohos.dart';

/// 通用的
mixin CommonMixin {
  /// Obtain the current country code.
  /// 查询当前的国家码
  /// See also: https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-location-kit/js-apis-geoLocationManager.md#geolocationmanagergetcountrycode
  Future<CountryCode?> getCountryCode() async {
    dynamic countryCode =
        await GeolocatorOhos._methodChannel.invokeMethod<dynamic>(
      'getCountryCode',
    );
    if (countryCode == null) {
      return null;
    }

    return CountryCode.fromString(countryCode.toString());
  }
}
