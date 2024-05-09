import { GeolocatorStreamHandler } from './GeolocatorStreamHandler';
import geoLocationManager from '@ohos.geoLocationManager';

export class ServiceStatusStreamHandler extends GeolocatorStreamHandler {
  subscribe(args: ESObject): void {
    this.locationEnabledChange(geoLocationManager.isLocationEnabled());
    geoLocationManager.on('locationEnabledChange', this.locationEnabledChange.bind(this))
  }

  unsubscribe(): void {
    geoLocationManager.off('locationEnabledChange', this.locationEnabledChange.bind(this));
  }

  locationEnabledChange(enable: boolean): void {
    if (enable != undefined) {
      this.onCallBack(enable ? 1 : 0);
    }
  }
}