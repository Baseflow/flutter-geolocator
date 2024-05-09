import {
  FlutterPlugin,
  FlutterPluginBinding
} from '@ohos/flutter_ohos/src/main/ets/embedding/engine/plugins/FlutterPlugin';
import MethodChannel, {
  MethodCallHandler,
  MethodResult
} from '@ohos/flutter_ohos/src/main/ets/plugin/common/MethodChannel';
import MethodCall from '@ohos/flutter_ohos/src/main/ets/plugin/common/MethodCall';
import { BusinessError } from '@ohos.base';
import EventChannel, { StreamHandler, EventSink } from '@ohos/flutter_ohos/src/main/ets/plugin/common/EventChannel';
import { GeolocatorEventChannel } from './GeolocatorEventChannel';
import { PositionStreamHandler } from './handlers/stream_handler/PositionStreamHandler';
import { ServiceStatusStreamHandler } from './handlers/stream_handler/ServiceStatusStreamHandler';
import { common, Permissions, Want } from '@kit.AbilityKit';
import AbilityAware from '@ohos/flutter_ohos/src/main/ets/embedding/engine/plugins/ability/AbilityAware';
import {
  AbilityPluginBinding
} from '@ohos/flutter_ohos/src/main/ets/embedding/engine/plugins/ability/AbilityPluginBinding';
import { PermissionHandler } from './handlers/method_handler/PermissionHandler';
import { geoLocationManager } from '@kit.LocationKit';
import { PositionHandler } from './handlers/method_handler/PositionHandler';
import { GeocoderHandler } from './handlers/method_handler/GeocoderHandler';
import { OpenSettingsHandler } from './handlers/method_handler/OpenSettingsHandler';


/** GeolocatorOhosPlugin **/
export default class GeolocatorOhosPlugin implements FlutterPlugin, MethodCallHandler, AbilityAware {
  private channel: MethodChannel | null = null;
  private positionEventChannel: GeolocatorEventChannel | null = null;
  private serviceStatusEventChannel: GeolocatorEventChannel | null = null;
  private static _context: Context | null = null;
  private static _uiContext: common.UIAbilityContext | null = null;

  static get uiContext(): common.UIAbilityContext | null {
    return GeolocatorOhosPlugin._uiContext;
  }

  static get context(): common.Context | null {
    return GeolocatorOhosPlugin._context;
  }

  get uiContext(): common.UIAbilityContext | null {
    return GeolocatorOhosPlugin._uiContext;
  }

  get context(): common.Context | null {
    return GeolocatorOhosPlugin._context;
  }

  constructor() {
  }

  onAttachedToAbility(binding: AbilityPluginBinding): void {
    GeolocatorOhosPlugin._uiContext = binding.getAbility().context;
  }

  onDetachedFromAbility(): void {
    GeolocatorOhosPlugin._uiContext = null;
  }

  getUniqueClassName(): string {
    return "GeolocatorOhosPlugin"
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    GeolocatorOhosPlugin._context = binding.getApplicationContext();
    this.channel = new MethodChannel(binding.getBinaryMessenger(), "flutter.baseflow.com/geolocator_ohos");
    this.channel.setMethodCallHandler(this)
    this.positionEventChannel = new GeolocatorEventChannel(binding.getBinaryMessenger(), 'flutter.baseflow.com/geolocator_updates_ohos', new PositionStreamHandler());
    this.serviceStatusEventChannel = new GeolocatorEventChannel(binding.getBinaryMessenger(), 'flutter.baseflow.com/geolocator_service_updates_ohos', new ServiceStatusStreamHandler());
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    GeolocatorOhosPlugin._context = null;
    if (this.channel != null) {
      this.channel.setMethodCallHandler(null)
    }
    if (this.positionEventChannel != null) {
      this.positionEventChannel.onDetachedFromEngine();
      this.positionEventChannel = null;
    }
    if (this.serviceStatusEventChannel != null) {
      this.serviceStatusEventChannel.onDetachedFromEngine();
      this.serviceStatusEventChannel = null;
    }
  }

  async onMethodCall(call: MethodCall, result: MethodResult): Promise<void> {

    switch (call.method) {
      case "checkPermission": {
        let ohosPermissions: Array<Permissions> = call.args;
        result.success(await PermissionHandler.checkPermission(ohosPermissions));
      }
        break;
      case "requestPermission": {
        let ohosPermissions: Array<Permissions> = call.args;
        result.success(await PermissionHandler.requestPermission(ohosPermissions));
      }
        break;
      case "getLocationAccuracy":
        result.success(await PermissionHandler.getLocationAccuracy());
        break;
      case "isLocationServiceEnabled":
        result.success(PositionHandler.isLocationServiceEnabled());
        break;
      case "getCurrentPosition": {
        let location = await PositionHandler.getCurrentPosition(call.args);
        if (location != undefined) {
          result.success(JSON.stringify(location));
        }
        else {
          result.error('', '', '');
        }
      }
        break;
      case "getLastKnownPosition":
        result.success(JSON.stringify(await PositionHandler.getLastLocation()));
        break;
      case "openAppSettings":
        OpenSettingsHandler.openAppSettings(result);
        break;
      case "openLocationSettings":
        OpenSettingsHandler.openLocationSettings(result);
        break;
      case "isGeocoderAvailable":
        result.success(GeocoderHandler.isGeocoderAvailable());
        break;
      case "getAddressesFromLocation": {
        let list = await GeocoderHandler.getAddressesFromLocation(call.args);
        result.success(list.map<String>(e => JSON.stringify(e)));
      }
        break;
      case "getAddressesFromLocationName": {
        let list = await GeocoderHandler.getAddressesFromLocationName(call.args);
        result.success(list.map<String>(e => JSON.stringify(e)));
      }
        break;
      case "getCountryCode":
        let countryCode = await geoLocationManager.getCountryCode();
        result.success(JSON.stringify(countryCode));
        break;
      default:
        result.notImplemented()
        break;
    }
  }
}

