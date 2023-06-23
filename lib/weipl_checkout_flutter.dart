import 'dart:collection';

import 'package:flutter/services.dart';
import 'package:eventify/eventify.dart';

class WeiplCheckoutFlutter {
  static const MethodChannel _channel = MethodChannel('weipl_checkout_flutter');

  // Event name
  static const wlResponse = 'WL_RESPONSE';

  // EventEmitter instance used for communication
  late EventEmitter _eventEmitter;

  WeiplCheckoutFlutter() {
    _eventEmitter = EventEmitter();
  }

  // Returns bollean for passed UPI app scheme for iOS
  Future<bool> checkInstalledUpiApp(String scheme) async {
    bool response = await _channel.invokeMethod('checkInstalledUpiApp', scheme);
    return response;
  }

  // Returns UPI Installed apps list for Android
  Future<List> upiIntentAppsList() async {
    List response = await _channel.invokeMethod('upiIntentAppsList');
    return response;
  }

  // Opens WL checkout SDK
  void open(Map<String, dynamic> options) async {
    var response = await _channel.invokeMethod('open', options);
    _handleResult(response);
    clear();
  }

  // Handles checkout response from platform
  void _handleResult(Map<dynamic, dynamic> response) {
    Map<dynamic, dynamic>? data = response;
    var payload = HashMap.from(data);

    _eventEmitter.emit(wlResponse, null, payload);
  }

  // Registers event listeners for payment events
  void on(String event, Function handler) {
    EventCallback cb;
    cb = (event, cont) {
      handler(event.eventData);
    };
    _eventEmitter.on(event, null, cb);
  }

  // Clears all event listeners
  void clear() {
    _eventEmitter.clear();
  }
}
