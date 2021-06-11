import 'dart:async';

import 'package:flutter/services.dart';

class EventChannelMock {
  final MethodChannel _methodChannel;
  final log = <MethodCall>[];

  Stream? stream;
  StreamSubscription? _streamSubscription;

  EventChannelMock({
    required String channelName,
    required this.stream,
  }) : _methodChannel = MethodChannel(channelName) {
    _methodChannel.setMockMethodCallHandler(_handler);
  }

  Future _handler(MethodCall methodCall) {
    log.add(methodCall);

    switch (methodCall.method) {
      case 'listen':
        _onListen();
        break;
      case 'cancel':
        _onCancel();
        break;
      default:
        return Future.value(null);
    }

    return Future.value();
  }

  void _onListen() {
    _streamSubscription = stream!.handleError(_sendErrorEnvelope).listen(
      _sendSuccessEnvelope,
      onDone: () {
        _sendEnvelope(null);
      },
    );
  }

  void _onCancel() {
    if (_streamSubscription != null) {
      _streamSubscription!.cancel();
      stream = null;
    }
  }

  void _sendErrorEnvelope(Exception error) {
    var code = "UNKNOWN_EXCEPTION";
    String? message;
    dynamic details;

    if (error is PlatformException) {
      code = error.code;
      message = error.message;
      details = error.details;
    }

    final envelope = const StandardMethodCodec()
        .encodeErrorEnvelope(code: code, message: message, details: details);

    _sendEnvelope(envelope);
  }

  void _sendSuccessEnvelope(dynamic event) {
    final envelope = const StandardMethodCodec().encodeSuccessEnvelope(event);
    _sendEnvelope(envelope);
  }

  void _sendEnvelope(ByteData? envelope) {
    if (ServicesBinding.instance == null) {
      return;
    }

    ServicesBinding.instance!.defaultBinaryMessenger.handlePlatformMessage(
      _methodChannel.name,
      envelope,
      (_) {},
    );
  }
}
