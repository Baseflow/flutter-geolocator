import geoLocationManager from '@ohos.geoLocationManager';


export class GeocoderHandler {
  static isGeocoderAvailable(): boolean {
    return geoLocationManager.isGeocoderAvailable();
  }

  static getAddressesFromLocation(args: ESObject): Promise<Array<geoLocationManager.GeoAddress>> {
    let request: geoLocationManager.ReverseGeoCodeRequest = JSON.parse(args);
    return geoLocationManager.getAddressesFromLocation(request);
  }

  static getAddressesFromLocationName(args: ESObject): Promise<Array<geoLocationManager.GeoAddress>> {
    let request: geoLocationManager.GeoCodeRequest = JSON.parse(args);
    return geoLocationManager.getAddressesFromLocationName(request);
  }
}