
import geoLocationManager from '@ohos.geoLocationManager';



export class GeocoderHandler{
  static isGeocoderAvailable(): boolean {
    return geoLocationManager.isGeocoderAvailable();
  }

  static getAddressesFromLocation(){
    geoLocationManager.getAddressesFromLocation();
  }
}