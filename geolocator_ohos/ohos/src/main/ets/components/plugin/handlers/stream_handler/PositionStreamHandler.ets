import { GeolocatorStreamHandler } from './GeolocatorStreamHandler';
import geoLocationManager from '@ohos.geoLocationManager';

export class PositionStreamHandler extends GeolocatorStreamHandler {
  subscribe(args: ESObject): void {
    let requestInfo: geoLocationManager.LocationRequest = {};
    if (args != null) {
      requestInfo = JSON.parse(args);
    }
    geoLocationManager.on('locationChange', requestInfo, this.locationChange.bind(this));
  }

  unsubscribe(): void {
    geoLocationManager.off('locationChange', this.locationChange.bind(this));
  }

  locationChange(location: geoLocationManager.Location): void {
    if (location != undefined) {
      this.onCallBack(JSON.stringify(location));
    }
  }
}