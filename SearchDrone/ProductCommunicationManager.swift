import UIKit
import DJISDK

let ProductCommunicationManagerStateDidChange = "ProductCommunicationManagerStateDidChange"

class ProductCommunicationManager: NSObject, DJISDKManagerDelegate, DJIFlightControllerDelegate {
    func didUpdateDatabaseDownloadProgress(_ progress: Progress) {
        NSLog("Download database : \(progress.completedUnitCount), \(progress.totalUnitCount)")
    }
    
    open weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
    open var connectedProduct: DJIBaseProduct!
    
    var registered = false
    var connected = false
    
    open func connectToProduct() {
        NSLog("Connecting to product...")
        let startedResult = DJISDKManager.startConnectionToProduct()
        
        if startedResult {
            NSLog("Connecting to product started successfully!")
        } else {
            NSLog("Connecting to product failed to start!")
        }
    }
    
    func registerWithProduct() {
        let appKey = Bundle.main.object(forInfoDictionaryKey: SDK_APP_KEY_INFO_PLIST_KEY) as? String

        guard appKey != nil && appKey!.isEmpty == false else {
            NSLog("Please enter your app key in the info.plist")
            return
        }
        
        DJISDKManager.registerApp(with: self)
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            NSLog("Registering Product with registration ID: \(appKey)")
//            DJISDKManager.registerApp(with: self)
//        }
    }
    
    //MARK: - DJISDKManagerDelegate
    func appRegisteredWithError(_ error: Error?) {
        if error != nil {
            NSLog("Error Registrating App: \(String(describing: error))")
        } else {
            self.registered = true
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: ProductCommunicationManagerStateDidChange)))
            NSLog("Registration Succeeded")
            self.connectToProduct()
        }
    }
    
    func productConnected(_ product: DJIBaseProduct?) {
        if product != nil {
            self.connected = true
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: ProductCommunicationManagerStateDidChange)))
            NSLog("Connection to new product succeeded!")
            self.connectedProduct = product
        
        }
    }
    
    func productDisconnected() {
        self.connected = false
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: ProductCommunicationManagerStateDidChange)))
        NSLog("Disconnected from product!");
    }
    
}
