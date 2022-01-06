//
//  AppLaunchViewController.swift
//  Sevenchats
//
//  Created by mac-00020 on 28/11/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

import Foundation
import UIKit

class AppLaunchViewController:  ParentViewController {
    
    //MARK: - IBOutlet/Object/Variable Declaration
    @IBOutlet weak var lblLaunchDescription: MIGenericLabel!
    
    @IBOutlet weak var viewMainContainer : UIView!
    @IBOutlet weak var viewSubContainer : UIView!
    
    
    //MARK: - View life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.isStatusBarHide = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    //MARK: - Memory management methods
    deinit {
        print("### deinit -> AppLaunchViewController")
    }
}

//MARK: - SetupUI
extension AppLaunchViewController {
    
    fileprivate func setupView() {
        
        self.setNavigationBar()
        
        // SpentTimeHelper.shared.stopTime()
        
        self.lblLaunchDescription.text = CAppNotAvailableAtYourLocation
        
        self.viewSubContainer.layer.cornerRadius = 8
        self.viewMainContainer.layer.cornerRadius = 8
        self.viewMainContainer.shadow(color: CRGB(r: 237, g: 236, b: 226), shadowOffset: CGSize(width: 0, height: 5), shadowRadius: 10.0, shadowOpacity: 10.0)
        
        self.addRightBarButtonItems()
        self.setUserProfilePicture( UIImage(named: "user_placeholder")!)
        
        let imgProfile = UIImageView()
        imgProfile.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        imgProfile.loadImageFromUrlWithCompletionHendler((appDelegate.loginUser?.profile_img ?? ""), true) { [weak self] (img) in
            guard let self = self else { return }
            if let _img = img {
                self.setUserProfilePicture(_img)
            }else {
                self.setUserProfilePicture( UIImage(named: "user_placeholder")!)
            }
        }
        
        AppUpdateManager.shared.checkForUpdate()
    }
    
    fileprivate func setNavigationBar() {
        /*self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font:CFontPoppins(size: 18, type: .meduim), NSAttributedString.Key.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.barTintColor = ColorAppBackgorund
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barStyle = .default
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "ic_navigation_bg"), for: .default)
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true //false*/
    }
    
    fileprivate func addRightBarButtonItems() {
        let itemLanguage = BlockBarButtonItem(image: UIImage(named: "ic_home_btn_language"), style: UIBarButtonItem.Style.plain) { [weak self] (_) in
            guard let self = self else { return }
            if let langVC = CStoryboardLRF.instantiateViewController(withIdentifier: "SelectLanguageViewController") as? SelectLanguageViewController{
                langVC.isBackButton = true
                self.navigationController?.pushViewController(langVC, animated: true)
            }
        }
        
        let itemLogout = BlockBarButtonItem(image: UIImage(named: "ic_sidemenu_normal_logout"), style: UIBarButtonItem.Style.plain) { [weak self] (_) in
            guard let self = self else { return }
            self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CMessageLogout, btnOneTitle: CBtnYes, btnOneTapped: { [weak self] (alert) in
                guard let _ = self else { return }
                MIGeneralsAPI.shared().addRemoveNotificationToken(isLogout: 1)
//                TVITokenService.shared.deleteUserBindingAPI()
//                AudioTokenService.shared.unregisterTwilioVoice()
                }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
            //appDelegate.logOut()
        }
        
        self.navigationItem.rightBarButtonItems = [itemLogout, itemLanguage]
    }
    
    fileprivate func setUserProfilePicture(_ img:UIImage) {
        
        let vwProfile = UIView()
        vwProfile.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        
        let imgProfile = UIImageView()
        imgProfile.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        vwProfile.addSubview(imgProfile)
        imgProfile.image =  img
        //imgProfile.loadImageFromUrl((appDelegate.loginUser?.profile_img ?? ""), true)
        vwProfile.roundView()
        vwProfile.clipsToBounds = true
        
        let itemProfile = BlockBarButtonItem(customView: vwProfile)
        self.navigationItem.leftBarButtonItem = itemProfile
        
        let btnProfile = UIButton()
        btnProfile.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        vwProfile.addSubview(btnProfile)
        btnProfile.touchUpInside { [weak self] (sender) in
            guard let self = self else { return }
            if let setting = CStoryboardSetting.instantiateViewController(withIdentifier: "SettingViewController") as? SettingViewController {
                setting.view.tag = 0
                self.navigationController?.pushViewController(setting, animated: true)
            }
        }
    }
}

//MARK: - IBAction / Selector
extension AppLaunchViewController {
    
    @IBAction func on(_ sender: UIButton) {
        
    }
}
