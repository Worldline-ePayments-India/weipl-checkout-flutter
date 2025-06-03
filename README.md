# Flutter plugin for Worldline ePayments India Mobile SDKs

This is official Flutter plugin to integrate Worldline ePayments India Checkout.

[![pub package](https://img.shields.io/pub/v/weipl_checkout_flutter.svg)](https://pub.dartlang.org/packages/weipl_checkout_flutter)

## Getting Started

The following documentation is only focused on the wrapper around our native Android and iOS SDKs. 

## Installation

This plugin is available on Pub: [https://pub.dev/packages/weipl_checkout_flutter](https://pub.dev/packages/weipl_checkout_flutter)

Add this to `dependencies` in your app's `pubspec.yaml`

```yaml
weipl_checkout_flutter: ^1.2.0
```

**Note for Android**: Make sure that the minimum API level for your app is 21 or higher.

**Note for iOS**: Make sure that the minimum deployment target for your app is iOS 12.0 or higher.

Run `flutter packages get` in the root directory of your app.

## Usage

Sample code to integrate can be found in [example/lib/main.dart](example/lib/main.dart).

#### Import package

```dart
import 'package:weipl_checkout_flutter/weipl_checkout_flutter.dart';
```

#### Create Flutter Plugin instance

```dart
WeiplCheckoutFlutter wlCheckoutFlutter = WeiplCheckoutFlutter();
```

#### Attach event listeners

The plugin uses event-based communication, and emits events when payment fails or succeeds.

The event names are exposed via the constants `wlResponse` from plugin class.

Use the `on(String event, Function handler)` method on the `WeiplCheckoutFlutter` instance to attach event listeners.

```dart

wlCheckoutFlutter.on(WeiplCheckoutFlutter.wlResponse, handleResponse);
```

The handlers would be defined somewhere as

```dart

void handleResponse(Map<dynamic, dynamic> response) {
  // Do something when payment succeeds
}

```

#### Setup options

```dart
var options = {
  "features": {
    "enableAbortResponse": true,
    "enableExpressPay": true,
    "enableInstrumentDeRegistration": true,
    "enableMerTxnDetails": true,
  },
  "consumerData": {
    "deviceId": "iOSSH2",   //supported values "ANDROIDSH1" or "ANDROIDSH2" for Android, supported values "iOSSH1" or "iOSSH2" for iOS and supported values
    "token":
        "a7356fb644fa98999a45d62361c80a574ff24f96b59669381593edbb97ef4feb0ea427d19e79b8d4ef5d82d38bb0eae890615b5054c702695deef11ec771b751",
    "paymentMode": "all",
    "merchantLogoUrl":
        "https://www.paynimo.com/CompanyDocs/company-logo-vertical.png", //provided merchant logo will be displayed
    "merchantId": "L3348",
    "currency": "INR",
    "consumerId": "c964634",
    "consumerMobileNo": "9876543210",
    "consumerEmailId": "test@test.com",
    "txnId":
        "1684835158539", //Unique merchant transaction ID
    "items": [
      {"itemId": "first", "amount": "10", "comAmt": "0"}
    ],
    "customStyle": {
      "PRIMARY_COLOR_CODE":
          "#45beaa", //merchant primary color code
      "SECONDARY_COLOR_CODE":
          "#FFFFFF", //provide merchant"s suitable color code
      "BUTTON_COLOR_CODE_1":
          "#2d8c8c", //merchant"s button background color code
      "BUTTON_COLOR_CODE_2":
          "#FFFFFF" //provide merchant"s suitable color code for button text
    }
  }
};
```
Change the **options** accordingly from complete **[Flutter](https://www.paynimo.com/paynimocheckout/docs/?device=flutter&nav=params#online)** integration guide.


#### Open Checkout

```dart
wlCheckoutFlutter.open(options);
```

### Response Handling

Please refer detailed response handling & HASH match logic explaination for **[Flutter](https://www.paynimo.com/paynimocheckout/docs/?device=flutter&nav=response#online)**.

**Note:** HASH Match logic should always be performed on server side only.