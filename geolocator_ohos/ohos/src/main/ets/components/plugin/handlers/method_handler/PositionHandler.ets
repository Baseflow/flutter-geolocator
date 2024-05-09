import geoLocationManager from '@ohos.geoLocationManager';


export class PositionHandler {
  static isLocationServiceEnabled(): boolean {
    return geoLocationManager.isLocationEnabled();
  }

  static async getCurrentPosition(args: ESObject): Promise<geoLocationManager.Location | undefined> {

    try {
      if (args != null) {
        let request: geoLocationManager.CurrentLocationRequest = JSON.parse(args);
        return geoLocationManager.getCurrentLocation(request);
      }
      return geoLocationManager.getCurrentLocation();
    }
    catch (e) {
      return undefined;
    }
  }

  static async getLastLocation(): Promise<geoLocationManager.Location> {
    return geoLocationManager.getLastLocation();
  }
}