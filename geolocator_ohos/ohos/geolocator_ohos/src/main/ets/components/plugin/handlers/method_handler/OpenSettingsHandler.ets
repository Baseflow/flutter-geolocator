import { MethodResult } from '@ohos/flutter_ohos';
import GeolocatorOhosPlugin from '../../GeolocatorOhosPlugin';
import { Want } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';


export class OpenSettingsHandler {
  static openAppSettings(result: MethodResult,){
    OpenSettingsHandler.openSettings(result,'application_info_entry');
  }
  static openLocationSettings(result: MethodResult,){
    OpenSettingsHandler.openSettings(result,'location_manager_settings');
  }
  private static openSettings(result: MethodResult, uri: string) {
    if (GeolocatorOhosPlugin.context == null || GeolocatorOhosPlugin.uiContext == null) {
      result.error('100', 'context and uiContext are null', 'They should not be null');
      return;
    }
    let applicationInfo = GeolocatorOhosPlugin.context!.applicationInfo;
    let wantInfo: Want = {
      bundleName: 'com.huawei.hmos.settings',
      abilityName: 'com.huawei.hmos.settings.MainAbility',
      uri: uri,
      parameters: {
        pushParams: applicationInfo.name,
      }
    }
    GeolocatorOhosPlugin.uiContext!.startAbility(wantInfo).then(() => {
      result.success(true);
    }).catch((err: BusinessError) => {
      console.error(`openAppSettings failed, code is ${err.code}, message is ${err.message}`);
      result.error(err.code.toString(), 'openAppSettings failed', err.message);
    })
  }
}