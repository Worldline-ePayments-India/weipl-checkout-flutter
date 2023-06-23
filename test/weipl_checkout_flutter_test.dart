import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weipl_checkout_flutter/weipl_checkout_flutter.dart';

import 'dart:io' show Platform;

class MockWeiplCheckoutFlutterPlatform {

  Future<String?> open() => Future.value('open');
}

void main() {
  void handleResponse(Map<dynamic, dynamic> response) {
    if (kDebugMode) {
      print('$response');
    }
  }

  test('open', () async {

    String deviceID = ""; // initiaze varibale

    if (Platform.isAndroid) {
      deviceID = "AndroidSH2"; // Android-specific deviceId, supported options are "AndroidSH1" & "AndroidSH2"
    } else if (Platform.isIOS) {
      deviceID = "iOSSH2"; // iOS-specific deviceId, supported options are "iOSSH1" & "iOSSH2"
    }

    WeiplCheckoutFlutter wlCheckoutFlutter = WeiplCheckoutFlutter();

    var reqJson = {
      "features": {
        "enableAbortResponse": true,
        "enableExpressPay": true,
        "enableInstrumentDeRegistration": true,
        "enableMerTxnDetails": true
      },
      "consumerData": {
        "deviceId": deviceID, //possible values "WEBSH1" or "WEBSH2"
        "token":
            "00c3e800c59041ff335594bfc316cb50b555de5ee684e7ec92de282cb113dcd37e97aea35872f499bafed027349a4907bb32c517236be623a3bff767a105abf9",
        "paymentMode": "all",
        "merchantLogoUrl":
            "https://www.paynimo.com/CompanyDocs/company-logo-vertical.png", //provided merchant logo will be displayed
        "merchantId": "L3348",
        "currency": "INR",
        "consumerId": "c964634",
        "consumerMobileNo": "9876543210",
        "consumerEmailId": "test@test.com",
        "txnId": "168439345342342452280", //Unique merchant transaction ID
        "items": [
          {"itemId": "first", "amount": "10", "comAmt": "0"}
        ],
        "customStyle": {
          "PRIMARY_COLOR_CODE": "#45beaa", //merchant primary color code
          "SECONDARY_COLOR_CODE":
              "#FFFFFF", //provide merchant"s suitable color code
          "BUTTON_COLOR_CODE_1":
              "#2d8c8c", //merchant"s button background color code
          "BUTTON_COLOR_CODE_2":
              "#FFFFFF" //provide merchant"s suitable color code for button text
        }
      }
    };

    wlCheckoutFlutter.on(WeiplCheckoutFlutter.wlResponse, handleResponse);
    wlCheckoutFlutter.open(reqJson);
  });
}
