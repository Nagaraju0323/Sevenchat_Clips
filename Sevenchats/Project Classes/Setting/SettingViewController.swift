//
//  SettingViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 09/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : SettingViewController                       *
 * Changes :                                             *
 *                                                       *
 ********************************************************/


import UIKit

class SettingViewController: ParentViewController {

    @IBOutlet weak var tblSettings : UITableView!
    fileprivate var arrSettings = [String]()
    let CVersion = "Version :"
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.isStatusBarHide = false
        self.Initialization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- ----------- Initialization
    func Initialization(){
        self.title = CNavSettings
        
        // For Normal Login....
        if appDelegate.loginUser?.account_type == 0 {
            arrSettings = [CSettingEditprofile,CSettingProfilePreference,CSettingChangePassword,CSettingLanguageSetting,CSettingFeedback,CSettingAboutus,CSettingTermsAndConditions,CSettingPrivacyPolicy]
            
        } else {
            arrSettings = [CSettingEditprofile,CSettingProfilePreference,CSettingLanguageSetting,CSettingFeedback,CSettingAboutus,CSettingTermsAndConditions,CSettingPrivacyPolicy]
        }
        let isAppLaunchHere = CUserDefaults.value(forKey: UserDefaultIsAppLaunchHere) as? Bool ?? true
        if !isAppLaunchHere {
            arrSettings.remove(at: 1)
        }
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
        arrSettings.append("\(CVersion) \(appVersion)")
        
        GCDMainThread.async {
            self.tblSettings.reloadData()
        }
    }
}

// MARK:- --------- Change Notification Status
extension SettingViewController {
    
    @objc func switchChanged(sender: UISwitch) {
        
        let point = sender.convert(sender.bounds.origin, to: tblSettings)
        let indexPath = tblSettings.indexPathForRow(at: point)
        
        if arrSettings[(indexPath?.row)!] == CSettingEmailNotification {
            //...Email Notification
            if sender.isOn {
                self.changeNotificationStatus(email: 1, push: (appDelegate.loginUser?.push_notify)! ? 1 : 0)
            } else {
                self.changeNotificationStatus(email: 0, push: (appDelegate.loginUser?.push_notify)! ? 1 : 0)
            }
            
        } else {
           //...Push Notification
            if sender.isOn {
                self.changeNotificationStatus(email: (appDelegate.loginUser?.email_notify)! ? 1 : 0, push: 1)

            } else {
                self.changeNotificationStatus(email: (appDelegate.loginUser?.email_notify)! ? 1 : 0, push: 0)
            }
        }
    }
    
}


// MARK:- --------- UITableView Datasources/Delegate
extension SettingViewController : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSettings.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTblCell", for: indexPath) as? SettingsTblCell {
            cell.lblTSettingText.text = arrSettings[indexPath.row]
            if Localization.sharedInstance.applicationFlowWithLanguageRTL(){
                cell.lblTSettingText.textAlignment = .right
            }else{
                cell.lblTSettingText.textAlignment = .left
            }
            if arrSettings[indexPath.row].hasPrefix(CVersion){
                cell.btnSwitch.isHidden = true
                cell.imgArrow.isHidden = true
                cell.lblTSettingText.textAlignment = .center
            }else if arrSettings[indexPath.row] == CSettingPushNotification || arrSettings[indexPath.row] == CSettingEmailNotification {
                cell.btnSwitch.isHidden = false
                cell.imgArrow.isHidden = true
                
                if arrSettings[indexPath.row] == CSettingPushNotification {
                    cell.btnSwitch.isOn = (appDelegate.loginUser?.push_notify ?? false)
                } else{
                    cell.btnSwitch.isOn = (appDelegate.loginUser?.email_notify  ?? false)
                }
                
            }else{
                cell.btnSwitch.isHidden = true
                cell.imgArrow.isHidden = false
            }
            
            cell.btnSwitch.addTarget(self, action: #selector(switchChanged), for: .valueChanged)

            return cell
        }
        
        return tableView.tableViewDummyCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let strSettingType = arrSettings[indexPath.row]
        
        switch strSettingType {
        case CSettingEditprofile:
            if let editProfileVC = CStoryboardProfile.instantiateViewController(withIdentifier: "EditProfileViewController") as? EditProfileViewController{
                self.navigationController?.pushViewController(editProfileVC, animated: true)
            }
            break
            
        case CSettingProfilePreference:
            let profilePreferenceVC : ProfilePreferenceViewController = CStoryboardSetting.instantiateViewController(withIdentifier: "ProfilePreferenceViewController") as! ProfilePreferenceViewController
            self.navigationController?.pushViewController(profilePreferenceVC, animated: true)
            break
            
        case CSettingChangePassword:
            let changePWDVC : ChangePWDViewController = CStoryboardLRF.instantiateViewController(withIdentifier: "ChangePWDViewController") as! ChangePWDViewController
            self.navigationController?.pushViewController(changePWDVC, animated: true)
            break
            
        case CSettingLanguageSetting:
            if let langVC = CStoryboardLRF.instantiateViewController(withIdentifier: "SelectLanguageViewController") as? SelectLanguageViewController{
                langVC.isBackButton = true
                self.navigationController?.pushViewController(langVC, animated: true)
            }
            break
            
        case CSettingFeedback:
            
            if let langVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "FeedbackViewController") as? FeedbackViewController {
                self.navigationController?.pushViewController(langVC, animated: true)
            }
            break
            
        case CSettingRestorePurchased:
            self.restorePurchase()
            break
            
        case CSettingAboutus:
            
            let cmsVC : AboutUsViewController = CStoryboardGeneral.instantiateViewController(withIdentifier: "AboutUsViewController") as! AboutUsViewController
            cmsVC.cmsType = .aboutUS
            self.navigationController?.pushViewController(cmsVC, animated: true)
            break
            
        case CSettingTermsAndConditions:
            let cmsVC : AboutUsViewController = CStoryboardGeneral.instantiateViewController(withIdentifier: "AboutUsViewController") as! AboutUsViewController
            cmsVC.cmsType = .termsAndConditions
            self.navigationController?.pushViewController(cmsVC, animated: true)

            break
            
        case CSettingPrivacyPolicy:
            let cmsVC : AboutUsViewController = CStoryboardGeneral.instantiateViewController(withIdentifier: "AboutUsViewController") as! AboutUsViewController
            cmsVC.cmsType = .privacyPolicy
            self.navigationController?.pushViewController(cmsVC, animated: true)
            break
            
        case CSettingContactUs:
            self.openMailComposer(email: "Sevenchats@gmail.com", body: nil)
            break
            
            
            
        default:
            break
        }
        
    }
}

// MARK:- --------- API
extension SettingViewController {
    
    func changeNotificationStatus(email : Int, push : Int) {
        
//        APIRequest.shared().changeNotificationStatus(email_status: email, push_status: push) { [weak self] (response, error) in
//            guard let _ = self else { return }
//            if response != nil && error == nil{
//            }
//        }
    }
}
// MARK:- --------- Cancel Subscription
extension SettingViewController {
    
    func restorePurchase() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        RageProducts.store.restorePurchases({ [weak self] (transactionState, product) in
            guard let self = self else { return }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if transactionState != nil{
                MILoader.shared.hideLoader()
                RageProducts.store.manageIAPState(self.viewController!,transactionState!, product)
            }
        })
    }
}

