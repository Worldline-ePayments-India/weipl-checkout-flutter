import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:weipl_checkout_flutter/weipl_checkout_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  WeiplCheckoutFlutter wlCheckoutFlutter = WeiplCheckoutFlutter();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Payment action
              ElevatedButton(
                  onPressed: () {
                    String deviceID = ""; // initialize variable

                    if (Platform.isAndroid) {
                      deviceID =
                          "AndroidSH2"; // Android-specific deviceId, supported options are "AndroidSH1" & "AndroidSH2"
                    } else if (Platform.isIOS) {
                      deviceID =
                          "iOSSH2"; // iOS-specific deviceId, supported options are "iOSSH1" & "iOSSH2"
                    }

                    var reqJson = {
                      "features": {
                        "enableAbortResponse": true,
                        "enableExpressPay": true,
                        "enableInstrumentDeRegistration": true,
                        "enableMerTxnDetails": true
                      },
                      "consumerData": {
                        "deviceId": deviceID,
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
                              "#FFFFFF", //provide merchant's suitable color code
                          "BUTTON_COLOR_CODE_1":
                              "#2d8c8c", //merchant"s button background color code
                          "BUTTON_COLOR_CODE_2":
                              "#FFFFFF" //provide merchant's suitable color code for button text
                        }
                      }
                    };

                    wlCheckoutFlutter.on(
                        WeiplCheckoutFlutter.wlResponse, handleResponse);
                    wlCheckoutFlutter.open(reqJson);
                  },
                  child: const Text("Proceed")),

              // UPI action
              ElevatedButton(
                  onPressed: () async {
                    if (Platform.isIOS) {
                      // iOS code
                      bool status = await wlCheckoutFlutter.checkInstalledUpiApp(
                          "gpay://upi/"); //UPI Schemes :- "phonepe://upi/" OR "gpay://upi/" OR "paytm://".
                      showAlertDialog(context, "WL SDK Response", "$status");
                    } else if (Platform.isAndroid) {
                      // android code
                      Map response =
                          await wlCheckoutFlutter.upiIntentAppsList();
                      showAlertDialog(context, "WL SDK Response", "$response");
                    } else {
                      showAlertDialog(context, "WL SDK Response",
                          "Feature is not available for selected platform.");
                    }
                  },
                  child: const Text("check Installed Upi App")),
            ],
          ),
        ),
      ),
    );
  }

  void handleResponse(Map<dynamic, dynamic> response) {
    showAlertDialog(context, "WL SDK Response", "$response");
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    // set up the buttons
    Widget continueButton = ElevatedButton(
      child: const Text("Okay"),
      onPressed: () {
        Navigator.pop(context, false);
      },
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.only(left: 25, right: 25),
          title: Center(child: Text(title)),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          content: SizedBox(
            height: 400,
            width: 300,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  Text(message),
                ],
              ),
            ),
          ),
          actions: [
            continueButton,
          ],
        );
      },
    );
  }
}
