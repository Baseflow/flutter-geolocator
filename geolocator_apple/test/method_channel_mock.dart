import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

class MethodChannelMock {
  final Duration delay;
  final MethodChannel methodChannel;
  final String method;
  final dynamic result;
  final log = <MethodCall>[];

  MethodChannelMock({
    required String channelName,
    required this.method,
    this.delay = Duration.zero,
    this.result,
  }) : methodChannel = MethodChannel(channelName) {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(methodChannel, _handler);
  }

  Future _handler(MethodCall methodCall) async {
    log.add(methodCall);

    if (methodCall.method != method) {
      throw MissingPluginException('No implementation found for method '
          '$method on channel ${methodChannel.name}');
    }

    return Future.delayed(delay, () {
      if (result is Exception) {
        throw result;
      }

      return Future.value(result);
    });
  }
}
