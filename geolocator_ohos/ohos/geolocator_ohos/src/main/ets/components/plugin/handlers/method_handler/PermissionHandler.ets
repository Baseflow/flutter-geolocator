import { Permissions, abilityAccessCtrl, PermissionRequestResult } from '@kit.AbilityKit';
import GeolocatorOhosPlugin from '../../GeolocatorOhosPlugin';

export class PermissionHandler {
  static async checkPermission(permissions: Array<Permissions> = ['ohos.permission.APPROXIMATELY_LOCATION']): Promise<number> {
    let atManager = abilityAccessCtrl.createAtManager();

    for (let index = 0; index < permissions.length; index++) {
      const element = permissions[index];
      let grantStatus: abilityAccessCtrl.GrantStatus = await atManager.checkAccessToken(GeolocatorOhosPlugin.context!
        .applicationInfo
        .accessTokenId, element,);
      if (grantStatus == abilityAccessCtrl.GrantStatus.PERMISSION_DENIED) {
        return 0;
      }
    }
    if (permissions.includes('ohos.permission.LOCATION_IN_BACKGROUND')) {
      return 3;
    }
    return 2;
  }

  static async requestPermission(permissions: Array<Permissions> = ['ohos.permission.APPROXIMATELY_LOCATION']): Promise<number> {
    if (permissions.length == 0) {
      // result.error('101', 'permissions is empty', 'make sure you pass the permissions');
      return 0;
    }

    if (permissions.includes('ohos.permission.LOCATION_IN_BACKGROUND')) {
      let atManager = abilityAccessCtrl.createAtManager();
      // 检查有没有后台运行权限
      let grantStatus: abilityAccessCtrl.GrantStatus = await atManager.checkAccessToken(GeolocatorOhosPlugin.context!
        .applicationInfo
        .accessTokenId, 'ohos.permission.KEEP_BACKGROUND_RUNNING',);
      if (grantStatus == abilityAccessCtrl.GrantStatus.PERMISSION_DENIED) {
        return -1;
      }
    }

    let atManager = abilityAccessCtrl.createAtManager();
    /// ohos
    /// The user denied access to the requested feature, permission needs to be
    /// asked first.
    /// denied(-1),

    /// The user granted access to the requested feature.
    /// granted(0),

    /// Invalid request.
    /// invalid(2)
    let data: PermissionRequestResult = await atManager.requestPermissionsFromUser(GeolocatorOhosPlugin.uiContext!, permissions,);
    let grantStatus: Array<number> = data.authResults;
    let length: number = grantStatus.length;
    for (let i = 0; i < length; i++) {
      // The value 0 indicates that a permission is granted, and the value -1 indicates not.
      // 0
      // -1
      // 2
      if (grantStatus[i] != 0) {
        return 0;
      }
    }
    if (permissions.includes('ohos.permission.LOCATION_IN_BACKGROUND')) {
      return 3;
    }
    return 2;
  }

  static async getLocationAccuracy(): Promise<number> {
    let atManager = abilityAccessCtrl.createAtManager();


    let grantStatus: abilityAccessCtrl.GrantStatus = await atManager.checkAccessToken(GeolocatorOhosPlugin.context!
      .applicationInfo
      .accessTokenId, "ohos.permission.LOCATION",);
    if (grantStatus == abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
      return 1;
    }

    grantStatus = await atManager.checkAccessToken(GeolocatorOhosPlugin.context!
      .applicationInfo
      .accessTokenId, "ohos.permission.APPROXIMATELY_LOCATION",);
    if (grantStatus == abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
      return 0;
    }

    return 2;

  }
}