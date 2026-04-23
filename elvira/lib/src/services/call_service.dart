import 'dart:async';
import 'package:flutter/services.dart';

class CallService {
  CallService._();
  static final instance = CallService._();

  static const _ch = MethodChannel('elvira/call');
  static const _ev = EventChannel('elvira/call/events');

  StreamSubscription? _sub;
  final _ctrl = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get events => _ctrl.stream;

  void init() {
    _sub ??= _ev.receiveBroadcastStream().listen((e) {
      if (e is Map) _ctrl.add(Map<String, dynamic>.from(e));
    });
  }

  void dispose() {
    _sub?.cancel();
    _ctrl.close();
  }

  Future<bool> isDefaultDialer() async =>
      await _ch.invokeMethod<bool>('isDefaultDialer') ?? false;

  Future<void> requestDefaultDialer() =>
      _ch.invokeMethod('requestDefaultDialer');

  Future<void> setCallerInfo(String name, String number) =>
      _ch.invokeMethod('setCallerInfo', {'name': name, 'number': number});

  Future<String?> getCurrentState() =>
      _ch.invokeMethod<String>('getCurrentState');

  Future<void> endCall() => _ch.invokeMethod('endCall');

  Future<void> setSpeaker(bool on) =>
      _ch.invokeMethod('setSpeaker', {'on': on});
}
