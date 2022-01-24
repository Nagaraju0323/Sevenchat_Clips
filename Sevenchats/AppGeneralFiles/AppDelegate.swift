//
//  AppDelegate.swift
//  Social Media
//
//  Created by mac-0005 on 06/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import LGSideMenuController
import GoogleSignIn
import FBSDKLoginKit
import GooglePlaces
import GoogleMaps
import Alamofire
import UserNotifications
import FirebaseInstanceID
import Firebase
import StoreKit
import Lightbox
import PushKit
import CallKit
import FirebaseMessaging
import StompClientLib



typealias UpdateNotificationCountInSideMenu = (() -> ())

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var notificationPayload : [AnyHashable : Any]?
    var sideMenuController = LGSideMenuController()
    var loginUser : TblUser?
    var langugaeText : TblLanguageText?
    var viewAdvertise: AdvertiseView!
    var updateNotificationCount : UpdateNotificationCountInSideMenu!
    var voipRegistry : PKPushRegistry!
    let window = UIWindow(frame: UIScreen.main.bounds)
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool  {
        
        let path = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)
        print("Document Directory : \(path.first ?? "URL Not found")")
        
        //setupNavigationBar()
        FirebaseApp.configure()

        //Fabric.with([Crashlytics.self])
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //...Configure for Google Place Picker
        GMSPlacesClient.provideAPIKey(CGooglePlacePickerKey)
        GMSServices.provideAPIKey(CGoogleAPIKey)
        
        //TWTRTwitter.sharedInstance().start(withConsumerKey: CTwitterConsumerKey, consumerSecret: CTwitterConsumerSecret)
        
        LightBoxControllerHelper.ConfigureLightBox()
        
        //...Configure for Google SignIn
        let dict = ["UserAgent" : "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36"]
        CUserDefaults.register(defaults: dict)
        GIDSignIn.sharedInstance()?.clientID = CGoogleClientID

        self.window.backgroundColor = CRGB(r: 138, g: 181, b: 139)
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = false
        
        self.initiateApplicationRoot(launchOptions: launchOptions)
        
        //...Load Common api
        MIGeneralsAPI.shared().fetchAllGeneralDataFromServer()
        
        //...Configure for Location Manager
        MILocationManager.shared().initializeLocationManager()
        
        //...Configure for Internet checker..
        self.internetGoesToOfflineOnline()
        
        //...SocketConncectionEstblish
        ChatSocketIo.shared().SocketInitilized()
//        SocketIOManager.SocketConnection()
      
        //...Regiter remote push notification.
        FirebasePushNotification.shared().registerForPushNotifications()
        //  self.registerRemoteNotification(application)

        self.voipRegistration()
        
//        TwilioVideoSDK.setLogLevel(.debug)
        
        Messaging.messaging().delegate = self
        
//        socketClient.openSocketWithURLRequest(request:ChatSocketUrl! , delegate: self)
        
        let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound]) {
            granted,error in
            if granted {
              print("we have permission")
            } else {
              print("Permisison denied")
            }
          }
        center.delegate = self

        return true
    }
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if ApplicationDelegate.shared.application(app, open: url, options: options) {
            return ApplicationDelegate.shared.application(app, open: url, options: options)
            
        } else if (GIDSignIn.sharedInstance()?.handle(url))! {
            return true
        }/* else if TWTRTwitter.sharedInstance().application(app, open: url, options: options){
            return TWTRTwitter.sharedInstance().application(app, open: url, options: options)
        }*/ else {
            let isAppLaunchHere = CUserDefaults.value(forKey: UserDefaultIsAppLaunchHere) as? Bool ?? true
            if !isAppLaunchHere {
                return false
            }
            if appDelegate.loginUser?.user_id != nil {
                
                let url = url.absoluteString
                let arrUrl = url.components(separatedBy: "/")
                
                if url.contains("share") {
                    //...DeepLinking redirection for post
                    if arrUrl.count > 4 {
                        let postID = arrUrl[3]
                        let postType = arrUrl.last
                        FirebasePushNotification.shared().deeplinkingRedirection((postID).toInt ?? 0, (postType)?.toInt ?? 0)
                    }
                } else if url.contains("group-info") {
                    //...DeepLinking redirection for Group Link
                    
                    if (arrUrl.count > 0) {
                        let groupID = arrUrl.last
                        
                        //...Join Group API
//                        APIRequest.shared().joinGroup(group_id: (groupID)?.toInt, completion: { (response, error) in
//                            
//                            if response != nil && error == nil {
//                                
//                                if let data = response![CJsonData] as? [String:Any] {
//                                    
//                                    if data.valueForInt(key: "group_type") == CGroupTypePrivate {
//                                        //...Redirect on Group List screen
//                                        FirebasePushNotification.shared().moveOnGroupListScreen(groupType: data.valueForInt(key: "group_type") ?? 0)
//                                    } else {
//                                        //...Redirect On Group Chat Detail screen
//                                        FirebasePushNotification.shared().moveOnGroupChatScreen([CGroupId :(groupID)?.toInt as AnyObject])
//                                    }
//                                }
//                            }
//                        })
                    }
                } else if url.contains("profile") {
                    //...Deeplinking redirection for Profile
                    
                    if (arrUrl.count > 1) {
                        let userID = arrUrl.last
                        self.moveOnProfileScreen(userID, appDelegate.getTopMostViewController())
                    }
                } else if url.contains(find: "product") {
                    let productId = arrUrl.last?.toInt ?? 0
                    self.moveOnProductDetailScreen(productId)
                }
            }
        }
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
//        SocketIOManager.shared().disConnectSocket()
//        MIMQTT.shared().objMQTTClient?.disconnect()
        // SpentTimeHelper.shared.stopTime()
       
 
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
      
//        MIMQTT.shared().objMQTTClient?.disconnect()
        SocketIOManager.shared().disConnectSocket()
        
//        ChatSocketIo.shared().stompClientDidDisconnect(client:)
        // SpentTimeHelper.shared.stopTime()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Refresh profile data....
        //
        if appDelegate.loginUser?.user_id != nil {
            MIGeneralsAPI.shared().laodLoginUserDetail()
            MIGeneralsAPI.shared().getAdvertisementList()
            ChatSocketIo.shared().SocketInitilized()

        }
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        ChatSocketIo.shared().SocketInitilized()
        SocketIOManager.shared().establishConnection()
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("UIBackgroundFetchResult...")
    }
    private func voipRegistration() {
        let mainQueue = DispatchQueue.main
        voipRegistry  = PKPushRegistry(queue: mainQueue)
        voipRegistry.delegate = self
        voipRegistry.desiredPushTypes = [PKPushType.voIP]
    }
}

// MARK:- ------- PushNotification
// MARK:-

extension AppDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let apnsToken = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        
        CUserDefaults.setValue(apnsToken, forKey: UserDefaultAPNsPNotificationToken)
        CUserDefaults.synchronize()
        print("APNs token: \(apnsToken)")
        //...Get FCM Token
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            } else if let result = result {
                CUserDefaults.setValue(result.token, forKey: UserDefaultNotificationToken)
                CUserDefaults.synchronize()
                print("FCM token: \(result.token)")
            }
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
//        let center = UNUserNotificationCenter.current()
        
//        center.delegate = self
//                let options: UNAuthorizationOptions = [.alert, .sound, .badge]
//        center.requestAuthorization(options: options) {
//                    (didAllow, error) in
//                    if !didAllow {
//                        print("User has declined notifications")
//                    }
//                }
        
        //appDelegate.notificationPayload = userInfo
        //self.actionOnPushNotification(userInfo, isComingFromQuit: false)
        /*guard let idToDelete = userInfo["del-id"] as? String else {
            completionHandler(.noData)
            return
        }

        let center = UNUserNotificationCenter.current()
        center.getDeliveredNotifications(completionHandler: { requests in
            print("getDeliveredNotifications : \(requests.count)")
            for request in requests {
                print(request)
            }
        })
        print("idToDelete : \(idToDelete)")
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [idToDelete])
        */
        print("didReceiveRemoteNotification ====== \(userInfo)")
        
        if let pushPayload = userInfo as? [String : Any]{
            
//            if let _ = pushPayload["identity"] as? String {
//                VoIPNotificationHandler.shared().actionOnPushNotification(notification: pushPayload)
//            }
        }
        completionHandler(UIBackgroundFetchResult.newData)
    }
}

// MARK:- ------- MessagingDelegate
// MARK:-
extension AppDelegate : MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        if let deviceToken = Messaging.messaging().apnsToken {
            let apnsToken = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
            
            CUserDefaults.setValue(apnsToken, forKey: UserDefaultAPNsPNotificationToken)
            CUserDefaults.synchronize()
            print("device Token: \(apnsToken)")
        }
        
        print("didReceiveRegistrationToken : \(fcmToken)")
        CUserDefaults.setValue(fcmToken, forKey: UserDefaultNotificationToken)
        CUserDefaults.synchronize()
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
}

// MARK:- ------- Application Flow
// MARK:-
extension AppDelegate {
    
    func setupNavigationBar() {
        
        let navigationBar = UINavigationBar.appearance()
        navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationBar.titleTextAttributes = [NSAttributedString.Key.font:CFontPoppins(size: 18, type: .meduim), NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationBar.barTintColor = ColorAppBackgorund
        navigationBar.tintColor = .white
        navigationBar.barStyle = .default
        
        navigationBar.setBackgroundImage(UIImage(named: "ic_navigation_bg"), for: .default)
        //navigationBar.setValue(true, forKey: "hidesShadow")
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true //false
        
        var imgBack = UIImage()
        if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
            /*if IS_iOS10 {
             imgBack = UIImage(named: "ic_back_reverse")!
             }else {
             imgBack = UIImage(named: "ic_back")!
             }*/
            imgBack = UIImage(named: "ic_back")!
        }else{
            imgBack = UIImage(named: "ic_back")!
        }
        
        navigationBar.backIndicatorTransitionMaskImage = imgBack
        navigationBar.backIndicatorImage = imgBack
    }
    
    func hideSidemenu() {
        
        if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
            sideMenuController.hideRightViewAnimated()
        }else {
            sideMenuController.hideLeftViewAnimated()
        }
    }
    
    func showSidemenu() {
        //...Update Notification count in sidemenu for Chat, Group and Notification
        if appDelegate.updateNotificationCount != nil {
            appDelegate.updateNotificationCount()
        }
        
        if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
            sideMenuController.showRightView(animated: true, completionHandler: nil)
        } else {
            sideMenuController.showLeftView(animated: true, completionHandler: nil)
        }
    }
    
    func initSidemenuViewController() {
        let rootVC = UINavigationController.init(rootViewController: CStoryboardHome.instantiateViewController(withIdentifier: "HomeViewController"))
        
        sideMenuController.rootViewController?.removeFromParent()
        sideMenuController.rootViewController = nil
        
        sideMenuController.rightViewController?.removeFromParent()
        sideMenuController.rightViewController = nil
        
        sideMenuController.leftViewController?.removeFromParent()
        sideMenuController.leftViewController = nil
        
        sideMenuController.rootViewController = rootVC
        sideMenuController.rootViewLayerShadowColor = ColorAppTheme
        sideMenuController.rootViewLayerShadowRadius = 20.0
        sideMenuController.isLeftViewSwipeGestureDisabled = true
        sideMenuController.isRightViewSwipeGestureDisabled = true
        if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
            // For Right side
            if let rootSideVC = CStoryboardHome.instantiateViewController(withIdentifier: "SideMenuViewController") as? SideMenuViewController {
                sideMenuController.rightViewController = rootSideVC
                sideMenuController.rightViewBackgroundColor = UIColor.white
                sideMenuController.rightViewWidth = 250.0;
                sideMenuController.rightViewPresentationStyle = .scaleFromBig
            }
          
        } else {
            // For Left side
            if let rootSideVC = CStoryboardHome.instantiateViewController(withIdentifier: "SideMenuViewController") as? SideMenuViewController {
                sideMenuController.leftViewController = rootSideVC
                sideMenuController.leftViewBackgroundColor = UIColor.white
                sideMenuController.leftViewWidth = 250.0;
                sideMenuController.leftViewPresentationStyle = .scaleFromBig
            }
        }
        self.window.rootViewController = sideMenuController
        if appDelegate.notificationPayload != nil {
            _ = FirebasePushNotification.shared().redirectToScreen(appDelegate.notificationPayload!)
        }
    }
    
    func initiateApplicationRoot(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        
        window.makeKeyAndVisible()
        
        let langID = CUserDefaults.value(forKey: UserDefaultSelectedLangID) as? Int ?? 0
        let arrLang = TblLanguage.fetch(predicate: NSPredicate(format: "%K == %d", CLang_id, langID), orderBy: CName, ascending: true)
        if let lang = arrLang?.firstObject as? TblLanguage{
            if let langCode = lang.lang_code {
                DateFormatter.shared().locale = Locale(identifier: langCode)
            }
            let orientation = lang.orientation ? 1 : 0
            if orientation == CLTR {
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
                UISearchBar.appearance().semanticContentAttribute = .forceLeftToRight
                UITextView.appearance().semanticContentAttribute = .forceLeftToRight
                UITextField.appearance().semanticContentAttribute = .forceLeftToRight
                UILabel.appearance().semanticContentAttribute = .forceLeftToRight
            } else {
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
                UISearchBar.appearance().semanticContentAttribute = .forceRightToLeft
                UITextView.appearance().semanticContentAttribute = .forceRightToLeft
                UITextField.appearance().semanticContentAttribute = .forceRightToLeft
                UILabel.appearance().semanticContentAttribute = .forceRightToLeft
            }
        }
        
        if CUserDefaults.value(forKey: UserDefaultDeviceToken) != nil && CUserDefaults.object(forKey: UserDefaultUserID) != nil {
            
            loginUser = TblUser.findOrCreate(dictionary: [CUserId : CUserDefaults.object(forKey: UserDefaultUserID) as Any]) as? TblUser
//            langugaeText = TblLanguageText.findOrCreate(dictionary: [CLang_id : CUserDefaults.object(forKey: UserDefaultSelectedLangID) as Any]) as? TblLanguageText

          langugaeText = TblLanguageText.findOrCreate(dictionary: [CLang_code : CUserDefaults.object(forKey: UserDefaultSelectedLangCode) as Any]) as? TblLanguageText

            ChatSocketIo.shared().SocketInitilized()
            MIGeneralsAPI.shared().getAdvertisementList()
          
            let remoteNotif = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? [String: Any]
            if remoteNotif != nil {
                appDelegate.notificationPayload = remoteNotif
                /*if let aps = remoteNotif!["aps"] as? [String : Any] {
                 //FirebasePushNotification.shared().actionOnPushNotification(aps, isComingFromQuit: true)
                }*/
            }
            if (loginUser?.mobile?.isEmpty ?? true)  && (loginUser?.email?.isEmpty ?? true) {
                let userId = CUserDefaults.object(forKey: UserDefaultUserID) as? Int ?? 0
                
                APIRequest.shared().userDetailNew(userID: userId.toString, apiKeyCall: "users/id/") { (_, _) in}
            }
            self.initHomeViewController()
            
        } else {
            
            if CUserDefaults.value(forKey: UserDefaultSelectedLangID) != nil {
//                langugaeText = TblLanguageText.findOrCreate(dictionary: [CLang_id : CUserDefaults.object(forKey: UserDefaultSelectedLangID) as Any]) as? TblLanguageText
                
                
                langugaeText = TblLanguageText.findOrCreate(dictionary: [CLang_code : CUserDefaults.object(forKey: UserDefaultSelectedLangCode) as Any]) as? TblLanguageText
                

                // If user already viewed the onboarding screen then move user to the login screen.
                if CUserDefaults.value(forKey: UserDefaultViewedOnboarding) != nil {
                    self.initLoginViewController()
                } else {
                    // If user not viewed the onboarding screen then move user to the onboarding screen.
                    self.initOnboardingViewController()
                }
            } else {
                self.initLanguageViewController()
            }
        }
    }
    
    func initLanguageViewController() {
        let rootVC = UINavigationController.init(rootViewController: CStoryboardLRF.instantiateViewController(withIdentifier: "SelectLanguageViewController"))
        self.setWindowRootViewController(rootVC: rootVC, animated: false, completion: nil)
    }
    
    func initLoginViewController() {
        let rootVC = UINavigationController.init(rootViewController: CStoryboardLRF.instantiateViewController(withIdentifier: "LoginViewController"))
        self.setWindowRootViewController(rootVC: rootVC, animated: true, completion: nil)
    }
    
    func initOnboardingViewController() {
        let rootVC = UINavigationController.init(rootViewController: CStoryboardLRF.instantiateViewController(withIdentifier: "OnboardingViewController"))
        self.setWindowRootViewController(rootVC: rootVC, animated: true, completion: nil)
    }
    
    func initHomeViewController() {
        
        
        let isAppLaunchHere = CUserDefaults.value(forKey: UserDefaultIsAppLaunchHere) as? Bool ?? true
        if isAppLaunchHere{
            let rootVC = UINavigationController.init(rootViewController: CStoryboardHome.instantiateViewController(withIdentifier: "HomeViewController"))
            self.setWindowRootViewController(rootVC: rootVC, animated: true, completion: nil)
            self.initSidemenuViewController()
        } else {
            let rootVC = UINavigationController.init(rootViewController: CStoryboardHome.instantiateViewController(withIdentifier: "AppLaunchViewController"))
            //self.setWindowRootViewController(rootVC: rootVC, animated: true, completion: nil)
            sideMenuController.rootViewController = rootVC
            sideMenuController.rootViewLayerShadowColor = ColorAppTheme
            sideMenuController.rootViewLayerShadowRadius = 20.0
            sideMenuController.isLeftViewSwipeGestureDisabled = true
            sideMenuController.isRightViewSwipeGestureDisabled = true
            appDelegate.sideMenuController = sideMenuController
            self.window.rootViewController = sideMenuController
        }
    }
    
    
    func setWindowRootViewController(rootVC:UIViewController?, animated:Bool, completion: ((Bool) -> Void)?) {
        
        guard rootVC != nil else {
            return
        }
        
        self.window.rootViewController = rootVC
        
        /*UIView.transition(with: self.window, duration: animated ? 0.6 : 0.0, options: .transitionCrossDissolve, animations: {
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            self.window.rootViewController = rootVC
            UIView.setAnimationsEnabled(oldState)
        }) { (finished) in
            if let handler = completion {
                handler(true)
            }
        }*/
    }
}

// MARK:- ---------- Profile Screen
// MARK:-
extension AppDelegate {
    
    func moveOnProfileScreen(_ userID : String?, _ viewController : UIViewController?) {
        
//        print("::::::::\(self.usersotherID)")
        DispatchQueue.main.async {
            
            if (userID ?? "").isEmpty{ return }
            
            if Int64(userID!) == appDelegate.loginUser?.user_id {
                let myProfileVC = CStoryboardProfile.instantiateViewController(withIdentifier: "MyProfileViewController")
                myProfileVC.view.tag = 107
                viewController?.navigationController?.pushViewController(myProfileVC, animated: true)
            }else {
                if let otherProfileVC = CStoryboardProfile.instantiateViewController(withIdentifier: "OtherUserProfileViewController") as? OtherUserProfileViewController {
                    otherProfileVC.useremail = userID
//                    otherProfileVC.userIDNew = userID
                    viewController?.navigationController?.pushViewController(otherProfileVC, animated: true)
                }
            }
        }
    }
    
    func moveOnProfileScreenNew(_ userID : String?,_ userEmail : String?, _ viewController : UIViewController?) {
           
           DispatchQueue.main.async {
               
               if (userID ?? "").isEmpty && (userEmail ?? "").isEmpty { return }
               
               if Int64(userID!) == appDelegate.loginUser?.user_id || userEmail == appDelegate.loginUser?.email {
                   let myProfileVC = CStoryboardProfile.instantiateViewController(withIdentifier: "MyProfileViewController")
                   myProfileVC.view.tag = 107
                   viewController?.navigationController?.pushViewController(myProfileVC, animated: true)
               }else {
                   if let otherProfileVC = CStoryboardProfile.instantiateViewController(withIdentifier: "OtherUserProfileViewController") as? OtherUserProfileViewController {
                       otherProfileVC.isSelected = true
                       otherProfileVC.useremail = userEmail
                       otherProfileVC.userIDNew = userID
                       viewController?.navigationController?.pushViewController(otherProfileVC, animated: true)
                   }
               }
           }
       }
}

// MARK:- ---------- General Method
// MARK:-
extension AppDelegate {
    
    func getTopMostViewController() -> UIViewController {
        let viewcontroller = CTopMostViewController
        if viewcontroller.isKind(of: LGSideMenuController.classForCoder()) {
            if let sideVC = viewcontroller as? LGSideMenuController {
                if (sideVC.rootViewController?.isKind(of: UINavigationController.classForCoder()))!{
                    if let navVC = sideVC.rootViewController as? UINavigationController {
                        return navVC.viewControllers.last!
                    }
                }
            }
        }else if viewcontroller.isKind(of: UINavigationController.classForCoder()) {
            if let navVC = viewcontroller as? UINavigationController {
                return navVC.viewControllers.last!
            }
        }
        return viewcontroller
    }
    
    func internetGoesToOfflineOnline() {
        
        // If Internet Connection appear to offline.......
        let noInternetView = NoInternetView.viewFromXib as? NoInternetView
        noInternetView?.frame = CGRect(x: 0, y: 0, width: CScreenWidth, height: CScreenHeight)
        
        let net = NetworkReachabilityManager()
        net?.startListening()
        
        net?.listener = { [weak self] status in
            guard let _ = self else { return }
            if (net?.isReachable)! {
                print("NETWORK REACHABLE")
                noInternetView?.removeFromSuperview()
             
                ChatSocketIo.shared().SocketInitilized()
                
//                if MIMQTT.shared().objMQTTClient != nil {
//                    _ = MIMQTT.shared().objMQTTClient?.connect()
//                }
            }else {
                print("NETWORK UNREACHABLE")
                noInternetView?.removeFromSuperview()
                appDelegate.window.addSubview(noInternetView!)
            }
        }
    }
    
    func logOut() {
        
        //....Facebook Logout
        if (AccessToken.current != nil) {
            LoginManager().logOut()
        }
        DispatchQueue.main.async {
            
            // SpentTimeHelper.shared.stopTime()
            
            GIDSignIn.sharedInstance().signOut()
            
            CUserDefaults.set(false, forKey: UserDefaultNotificationCountBadge)
            appDelegate.loginUser = nil
            TblUser.deleteAllObjects()
            TblChatUserList.deleteAllObjects()
            TblChatGroupList.deleteAllObjects()
            TblMessages.deleteAllObjects()
            TblTotalFriends.deleteAllObjects()
            CoreData.saveContext()
            CUserDefaults.removeObject(forKey: UserDefaultUserID)
            CUserDefaults.removeObject(forKey: UserDefaultDeviceToken)
            CUserDefaults.synchronize()
            
            appDelegate.initLoginViewController()
            appDelegate.hideSidemenu()
            
            // Disconnect MQTT
            
//            MIMQTT.shared().objMQTTClient?.disconnect()
            ChatSocketIo.shared().disconnectSocket()
        }
    }
    
    fileprivate func moveOnProductDetailScreen(_ productID: Int) {
        appDelegate.sideMenuController.rootViewController = UINavigationController.init(rootViewController: CStoryboardProduct.instantiateViewController(withIdentifier: "StoreListVC"))
        appDelegate.hideSidemenu()
        
        if let productDetailVC = CStoryboardProduct.instantiateViewController(withIdentifier: "ProductDetailVC") as? ProductDetailVC {
            
            let topVC = appDelegate.getTopMostViewController()
            productDetailVC.productId = productID
            topVC.navigationController?.pushViewController(productDetailVC, animated: true)
        }
    }
}

//MARK: -  Like Manage
extension AppDelegate {
    
    func getLikeString(like:Int) -> String {
        
        var strLikeCount = ""
        var totalLikeCount = like
        if totalLikeCount < 0{
            totalLikeCount = 0
        }
        if totalLikeCount > 99{
            strLikeCount = "\(totalLikeCount)+ \(CNavLikes)"
        }
        strLikeCount = "\(totalLikeCount) \(CNavLikes)"
        if totalLikeCount == 1{
            strLikeCount = "\(totalLikeCount) \(CLike)"
        }
        return strLikeCount
    }
    
    func getCommentCountString(comment:Int) -> String{
        var strCommentCount = "\(comment) \(CNavComments)"
        if comment == 1{
            strCommentCount = "\(comment) \(CComment)"
        }
        return strCommentCount
    }
}

// MARK:-
// MARK:- ------- PushKit Delegate Methods
extension AppDelegate : PKPushRegistryDelegate {
    // MARK: PKPushRegistryDelegate
    
    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
        
        NSLog("credentials.token: \(credentials.token.description)")
        if type == PKPushType.voIP {
            /*let tokenData = credentials.token
            guard let voipPushToken = String(data: tokenData, encoding: .utf8) else {
                return
            }
            print("voipPushToken :\(voipPushToken)")
            CUserDefaults.setValue(voipPushToken, forKey: UserDefaultVoIPNotificationToken)
            */
            let deviceToken = credentials.token.map { String(format: "%02x", $0) }.joined()
            print("pushRegistry -> deviceToken :\(deviceToken)")
            CUserDefaults.setValue(deviceToken, forKey: UserDefaultVoIPNotificationToken)
            
            CUserDefaults.synchronize()
            CUserDefaults.setValue(credentials.token, forKey: CachedDeviceToken)
            
//            AudioTokenService.shared.callGetAudioTokenAPI(identity: myAudioIdentity, isForRegister: true)
//            TVITokenService.shared.bindVoIPToken()
        }
        
        
        /*let deviceToken = credentials.token.map { String(format: "%02x", $0) }.joined()
        print("pushRegistry -> deviceToken :\(deviceToken)")
        NSLog("credentials.token: \(credentials.token.description)")
        
        CUserDefaults.setValue(credentials.token, forKey: CachedDeviceToken)
        CUserDefaults.setValue(deviceToken, forKey: UserDefaultVoIPNotificationToken)
        CUserDefaults.synchronize()*/
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        print("pushRegistry:didInvalidatePushTokenForType:")
//        if (type == .voIP) {
//            AudioTokenService.shared.unregisterTwilioVoice()
//        }
    }
    
    /**
     * Try using the `pushRegistry:didReceiveIncomingPushWithPayload:forType:withCompletionHandler:` method if
     * your application is targeting iOS 11. According to the docs, this delegate method is deprecated by Apple.
     */
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType) {
        print("pushRegistry:didReceiveIncomingPushWithPayload:forType:")
//        voipPushHandle(payload:payload, type: type)
    }
    
    /**
     * This delegate method is available on iOS 11 and above. Call the completion handler once the
     * notification payload is passed to the `Twilio`Voice.handleNotification()` method.
     */
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        
        print("pushRegistry:didReceiveIncomingPushWith:")
//        voipPushHandle(payload:payload, type: type)
    }
    
    func pushToIncomingCallVC(payload: PKPushPayload) {
         print("pushToIncomingCallVC")
    }

}


extension UIApplication {
 /// Run a block in background after app resigns activity
  public func runInBackground(_ closure: @escaping () -> Void, expirationHandler: (() -> Void)? = nil) {
      DispatchQueue.main.async {
       let taskID: UIBackgroundTaskIdentifier
       if let expirationHandler = expirationHandler {
           taskID = self.beginBackgroundTask(expirationHandler: expirationHandler)
       } else {
           taskID = self.beginBackgroundTask(expirationHandler: { })
       }
       closure()
       self.endBackgroundTask(taskID)
   }
 }

 }
