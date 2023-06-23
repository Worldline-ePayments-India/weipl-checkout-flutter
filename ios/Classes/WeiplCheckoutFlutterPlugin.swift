import Flutter
import UIKit
import Foundation
import weipl_checkout

public class WeiplCheckoutFlutterPlugin: NSObject, FlutterPlugin {
  private var callback: FlutterResult?
  private var wlCheckout: WLCheckoutViewController?
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "weipl_checkout_flutter", binaryMessenger: registrar.messenger())
    let instance = WeiplCheckoutFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    
    // preload method
    instance.wlCheckout = WLCheckoutViewController()
    instance.wlCheckout?.preloadData()

    // NotificationCenter for SDK to app response communication
    NotificationCenter.default.addObserver(instance, selector: #selector(self.wlCheckoutPaymentResponse(result:)), name: Notification.Name("wlCheckoutPaymentResponse"), object: nil)
    NotificationCenter.default.addObserver(instance, selector: #selector(self.wlCheckoutPaymentError(result:)), name: Notification.Name("wlCheckoutPaymentError"), object: nil)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        self.callback = result
        
        switch call.method {
            
        case "open":
            
            do {
                let jSONObject = String(data: try JSONSerialization.data(withJSONObject: call.arguments as Any, options: .prettyPrinted), encoding: String.Encoding(rawValue: NSUTF8StringEncoding))
                
                wlCheckout!.open(requestObj: jSONObject!)
                
                DispatchQueue.main.async {
                    UIApplication.shared.delegate?.window??.rootViewController?.present(self.wlCheckout!, animated: false, completion: nil)
                }
            } catch let error {
                print(error.localizedDescription)
            }
            
            break;
        case "checkInstalledUpiApp":

            let statusOfAPP = wlCheckout!.checkInstalledUpiApp(scheme: call.arguments as! String)
            print("Status SWIFT: \(statusOfAPP)")
            result(statusOfAPP)
            
            break;

        default:
            print("no method")
        }
        
    }
    
    @objc func wlCheckoutPaymentResponse(result: Notification) {
                
        do {
            let jsonStringifiedString = result.object as! String
            let jsonStringifiedData = jsonStringifiedString.data(using: .utf8)
            let jsonDict = try JSONSerialization.jsonObject(with: jsonStringifiedData!, options: []) as! [String: Any]
            self.callback!(jsonDict)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    @objc func wlCheckoutPaymentError(result: Notification) {
        
        do {
            let jsonStringifiedString = result.object as! String
            let jsonStringifiedData = jsonStringifiedString.data(using: .utf8)
            let jsonDict = try JSONSerialization.jsonObject(with: jsonStringifiedData!, options: []) as! [String: Any]
            self.callback!(jsonDict)
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
