//
//  AppUpdateManager.swift
//  Sevenchats
//
//  Created by mac-00020 on 13/03/20.
//  Copyright © 2020 mac-00020. All rights reserved.
//

import Foundation
import StoreKit

class MDLAppUpdate {
    
    var appVersion : String!
    var isForceUpdate : Int!
    
    init(fromDictionary dictionary: [String:Any]){
        //appVersion = "2.5"
        appVersion = dictionary["app_version"] as? String ?? ""
        isForceUpdate = dictionary["is_force_update"] as? Int ?? 0
    }
}

class AppUpdateManager : NSObject {
    
    static let shared  = AppUpdateManager()
    fileprivate var appUpdate : MDLAppUpdate?
    var isUpdateLater = false
    
    func checkForUpdate() {
//        guard self.appUpdate == nil else {
//            self.isNewUpdate()
//            return
//        }
//        APIRequest.shared().forceUpdate { (response, error) in
//            guard let _response = response as? [String : Any] else { return }
//            guard let data = _response["data"] as? [String : Any] else { return }
//            guard let ios = data["ios"] as? [String : Any] else { return }
//            self.appUpdate = MDLAppUpdate(fromDictionary: ios)
//            self.isNewUpdate()
//        }
    }
    
    private func isNewUpdate() {
        guard let currentVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else { return }
        guard currentVersion != self.appUpdate?.appVersion else { return }
        print("Current Version : \(currentVersion)")
        switch self.appUpdate?.isForceUpdate {
        case 1:
            self.forceUpdateAlert()
            break
        case 2:
            self.normalUpdateAlert()
            break
        default:
            break
        }
    }
    
    func forceUpdateAlert() {
        CTopMostViewController.presentAlertViewWithOneButton(alertTitle: nil, alertMessage: CForceUpdateText, btnOneTitle: CResetBtnUpdate) { (_) in
            self.openStoreVC()
        }
    }
    
    func normalUpdateAlert() {
        if self.isUpdateLater { return }
        CTopMostViewController.presentAlertViewWithTwoButtons(alertTitle: nil, alertMessage: CForceUpdateText, btnOneTitle: CLater, btnOneTapped: { (_) in
            self.isUpdateLater = true
        }, btnTwoTitle: CResetBtnUpdate) { (_) in
            self.openStoreVC()
        }
    }
    
    func openStoreVC() {
        
        let storeViewController = SKStoreProductViewController()
        storeViewController.delegate = self
        // 1460122350 - Sevenchats
        // 310633997 - WhatsApp
        storeViewController.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier:NSNumber(value: 1460122350)]) { (result, error) in
            if(error != nil) {
                print("Error occurred while loading the product: \(error.debugDescription)")
            } else {
                CTopMostViewController.present(storeViewController, animated: true, completion: nil)
            }
        }
    }
}

extension AppUpdateManager: SKStoreProductViewControllerDelegate {
    
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        
        viewController.dismiss(animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                if self.appUpdate?.isForceUpdate == 1 {
                    self.isNewUpdate()
                }
            }
        }
    }
}
