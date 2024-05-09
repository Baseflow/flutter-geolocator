import { BinaryMessenger, TaskQueue } from '@ohos/flutter_ohos/src/main/ets/plugin/common/BinaryMessenger';
import EventChannel from '@ohos/flutter_ohos/src/main/ets/plugin/common/EventChannel';
import MethodCodec from '@ohos/flutter_ohos/src/main/ets/plugin/common/MethodCodec';
import { GeolocatorStreamHandler } from './handlers/stream_handler/GeolocatorStreamHandler';


export class GeolocatorEventChannel extends EventChannel {
  constructor(messenger: BinaryMessenger, name: string, handler: GeolocatorStreamHandler, codec?: MethodCodec, taskQueue?: TaskQueue) {
    super(messenger, name, codec, taskQueue);
    this.handler = handler;
    this.setStreamHandler(this.handler);
  }

  private handler: GeolocatorStreamHandler | null = null;

  onDetachedFromEngine(): void {
    this.setStreamHandler(null);
    if (this.handler != null) {
      this.handler.unsubscribe();
      this.handler = null;
    }
  }
}