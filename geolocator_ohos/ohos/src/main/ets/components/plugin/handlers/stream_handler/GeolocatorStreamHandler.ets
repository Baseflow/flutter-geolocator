import { EventSink, StreamHandler } from '@ohos/flutter_ohos/src/main/ets/plugin/common/EventChannel';


export class GeolocatorStreamHandler implements StreamHandler {
  onCancel(args: ESObject): void {
    this.events = null;
    this.unsubscribe();
  }

  private events: EventSink | null = null;
  // private connection: connection.NetConnection | null = null;

  onListen(args: ESObject, events: EventSink) {
    this.events = events;
    this.subscribe(args);
  }

  subscribe(args: ESObject): void {

  }

  unsubscribe(): void {
    this.events =null;
  }

  onCallBack(data: ESObject): void {
    this.events?.success(data);
  }
}