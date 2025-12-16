import Flutter
import UIKit
import Foundation
import weipl_checkout

public class WeiplCheckoutFlutterPlugin: NSObject, FlutterPlugin {
    private var callback: FlutterResult?
    private var wlCheckout: WLCheckoutViewController?
    private var response: Dictionary<String, Any>?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        
        let channel = FlutterMethodChannel(name: "weipl_checkout_flutter", binaryMessenger: registrar.messenger())
        let instance = WeiplCheckoutFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        // NotificationCenter for SDK to app response communication
        NotificationCenter.default.addObserver(instance, selector: #selector(self.wlCheckoutPaymentResponse(result:)), name: Notification.Name("wlCheckoutPaymentResponse"), object: nil)
        NotificationCenter.default.addObserver(instance, selector: #selector(self.wlCheckoutPaymentError(result:)), name: Notification.Name("wlCheckoutPaymentError"), object: nil)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.callback = result
        
        switch call.method {
            
        case "open":
            
            do {
                var jSONObject = String(data: try JSONSerialization.data(withJSONObject: call.arguments as Any, options: .prettyPrinted), encoding: String.Encoding(rawValue: NSUTF8StringEncoding))

                WLCheckout.open(requestObj: jSONObject!)
                
                DispatchQueue.main.async {
                    UIApplication.shared.delegate?.window??.rootViewController?.present(WLCheckout.self, animated: false, completion: nil)
                }
            } catch let error {
                print(error.localizedDescription)
            }
            
            break;
        case "checkInstalledUpiApp":
            
            let statusOfAPP = WLCheckout.checkInstalledUpiApp(scheme: call.arguments as! String)
            result(statusOfAPP)
            
            break;
            
        default:
            print("no method")
        }
        
    }
    
    @objc func wlCheckoutPaymentResponse(result: Notification) {
        var jsonDict : Dictionary<String, Any>?
        
        // Show status NIL in final response
        do {
            let jsonStringifiedString = result.object as! String
            let jsonStringifiedData = jsonStringifiedString.data(using: .utf8)
            jsonDict = try JSONSerialization.jsonObject(with: jsonStringifiedData!, options: []) as? [String: Any]
            
            // Check if the casting was successful
            if let retJsonDict = jsonDict {
                // Use the unwrapped dictionary directly. No `toMap` function is needed.
                let responseDict: [String: Any] = [
                    "response": retJsonDict
                ]
                self.callback!(responseDict)
            } else {
                // Handle the case where the JSON was not a dictionary
                print("JSON data could not be cast to a [String: Any] dictionary.")
            }
        } catch let error {
            response = jsonDict
            print(error.localizedDescription)
        }
    }
    
    @objc func wlCheckoutPaymentError(result: Notification) {
        var jsonDict : Dictionary<String, Any>?
        
        do {
            let jsonStringifiedString = result.object as! String
            let jsonStringifiedData = jsonStringifiedString.data(using: .utf8)
            jsonDict = try JSONSerialization.jsonObject(with: jsonStringifiedData!, options: []) as? [String: Any]
            
            // Check if the casting was successful
            if let retJsonDict = jsonDict {
                // Use the unwrapped dictionary directly. No `toMap` function is needed.
                let responseDict: [String: Any] = [
                    "status": "error",
                    "response": retJsonDict
                ]
                self.callback!(responseDict)

            } else {
                // Handle the case where the JSON was not a dictionary
                print("JSON data could not be cast to a [String: Any] dictionary.")
            }
        } catch let error {
            response = jsonDict
            print(error.localizedDescription)
        }
    }
    
    @objc func syncResponse() {
        if (self.callback != nil) {
            self.callback!(response)
            response = nil;
        }
    }
}
