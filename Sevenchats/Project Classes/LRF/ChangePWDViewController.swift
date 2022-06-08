//
//  ChangePWDViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 14/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : ChangePWDViewController                     *
 * Changes :                                             *
 * Modified User password                                *
 *                                                       *
 *                                                       *
 ********************************************************/

import UIKit

class ChangePWDViewController: ParentViewController {
    
    @IBOutlet var btnUpdate : UIButton!
    @IBOutlet var txtOldPWD : MIGenericTextFiled!
    @IBOutlet var txtNewPWD : MIGenericTextFiled!
    @IBOutlet var txtConfirmPWD : MIGenericTextFiled!
    var loginType:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Initialization()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- --------- Initialization
    func Initialization(){
        btnUpdate.layer.cornerRadius = 5
        self.setLanguageText()
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: #imageLiteral(resourceName: "ic_info_tint"), style: .plain, target: self, action: #selector(btnHelpInfoClicked(_:)))]
    }
    
    @objc fileprivate func btnHelpInfoClicked(_ sender : UIBarButtonItem){
        if let helpLineVC = CStoryboardHelpLine.instantiateViewController(withIdentifier: "HelpLineViewController") as? HelpLineViewController {
            helpLineVC.fromVC = "changepasswordVC"
            self.navigationController?.pushViewController(helpLineVC, animated: true)
        }
        
    }
    
    func setLanguageText() {
        self.title = CSettingChangePassword
        txtOldPWD.placeHolder = COldPassword
        txtNewPWD.placeHolder = CResetPlaceholderNewPassword
        txtConfirmPWD.placeHolder = CResetPlaceholderConfirmNewPassword
        btnUpdate.setTitle(CResetBtnUpdate, for: .normal)
    }
}
// MARK:- --------- API
extension ChangePWDViewController {
    func changePassword() {
    }
}

// MARK:- --------- Action Event
extension ChangePWDViewController{
    
    @IBAction func btnUpdateCLK(_ sender : UIButton){
        self.resignKeyboard()
        
        if (txtOldPWD.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CBlankOldPassword, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }else if (txtNewPWD.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CResetAlertNewPWDBlank, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }else if !(txtNewPWD.text?.isValidPassword ?? false) {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CRegisterPasswordMinLimit, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }else if (txtConfirmPWD.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CResetAlertConfirmPWDBlank, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }else if txtNewPWD.text != txtConfirmPWD.text{
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CResetAlertPWDConfirmPWDNotMatch, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }else{
            self.changePasswords()
           // self.changePasswordsMobielNo()
        }
    }
    
    
}

// MARK:- --------- API
extension ChangePWDViewController{
    
    func changePasswords(){

        MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: nil)
        guard let userName = appDelegate.loginUser?.email else{ return}
        
        let password = txtNewPWD.text ?? ""
        let old_password = txtOldPWD.text ?? ""
        
        if password == old_password{
            MILoader.shared.hideLoader()
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CResetOldNewPasswordMatch, btnOneTitle: CBtnOk, btnOneTapped: { (action) in
                self.dismiss(animated: true, completion: nil)
            })
        }else{
        
        let data : Data = "username=\(userName)&password=\(password)&grant_type=password&client_id=null&client_secret=null&old_password=\(old_password)".data(using: .utf8)!
        
        let url = URL(string: "\(BASEAUTH)auth/resetPassword")
        var request : URLRequest = URLRequest(url: url!)
        request.httpMethod = "PUT"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type");
        let token = CUserDefaults.value(forKey: UserDefaultDeviceToken)
        request.setValue("Bearer \(token ?? "")", forHTTPHeaderField:"Authorization")
        request.setValue(NSLocalizedString("lang", comment: ""), forHTTPHeaderField:"Accept-Language");
        request.httpBody = data
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) in
            if let error = error{
                print("somethis\(error)")
            }
            else if let response = response {
            }else if let data = data{
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            _ = JSONDecoder()
            let token_type = (String(data: responseData, encoding: .utf8))
            do {
                let dict = try self.convertStringToDictionary(text: token_type ?? "")
                guard let userMsg = dict?["message"] as? String else { return }
                DispatchQueue.main.async {
                    if userMsg ==  "This user does not exist!" {
                        self.changePasswordsMobielNo()
                    }else if userMsg == "Something went wrong!"{
                        MILoader.shared.hideLoader()
                        self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CResetOldPasswordNotMatch, btnOneTitle: CBtnOk, btnOneTapped: { (action) in
                            self.dismiss(animated: true, completion: nil)
                        })
                    }else {
                        MILoader.shared.hideLoader()
                        self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CResetPassword, btnOneTitle: CBtnOk, btnOneTapped: { (action) in
                            self.dismiss(animated: true, completion: nil)
                            MIGeneralsAPI.shared().addRemoveNotificationToken(isLogout: 1)
//                            self.navigationController?.popToRootViewController(animated: true)
                        })
                    }
                }
            } catch let error  {
                print("error trying to convert data to \(error)")
            }
        })
        task.resume()
    }
    }
    
    func changePasswordsMobielNo(){

        MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: nil)
        guard let userName = appDelegate.loginUser?.mobile else{ return}
        
        let password = txtNewPWD.text ?? ""
        let old_password = txtOldPWD.text ?? ""
        
        if password == old_password{
            
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CResetOldNewPasswordMatch, btnOneTitle: CBtnOk, btnOneTapped: { (action) in
                self.dismiss(animated: true, completion: nil)
            })
        }else{
        
        let data : Data = "username=\(userName)&password=\(password)&grant_type=password&client_id=null&client_secret=null&old_password=\(old_password)".data(using: .utf8)!
        
        let url = URL(string: "\(BASEAUTH)auth/resetPassword")
        var request : URLRequest = URLRequest(url: url!)
        request.httpMethod = "PUT"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type");
        let token = CUserDefaults.value(forKey: UserDefaultDeviceToken)
        request.setValue("Bearer \(token ?? "")", forHTTPHeaderField:"Authorization")
        request.setValue(NSLocalizedString("lang", comment: ""), forHTTPHeaderField:"Accept-Language");
        request.httpBody = data
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) in
            if let error = error{
                print("somethis\(error)")
            }
            else if let response = response {
            }else if let data = data{
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            _ = JSONDecoder()
            let token_type = (String(data: responseData, encoding: .utf8))
            do {
                let dict = try self.convertStringToDictionary(text: token_type ?? "")
                guard let userMsg = dict?["message"] as? String else { return }
                DispatchQueue.main.async {
                    if userMsg == "Something went wrong!"{
                        MILoader.shared.hideLoader()
                        self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CResetOldPasswordNotMatch, btnOneTitle: CBtnOk, btnOneTapped: { (action) in
                            self.dismiss(animated: true, completion: nil)
                        })
                    }else {
                        MILoader.shared.hideLoader()
                        self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CResetPassword, btnOneTitle: CBtnOk, btnOneTapped: { (action) in
                            self.dismiss(animated: true, completion: nil)
                            MIGeneralsAPI.shared().addRemoveNotificationToken(isLogout: 1)
                        })
                    }
                }
            } catch let error  {
                print("error trying to convert data to \(error)")
            }
        })
        task.resume()
        }
    }
    
}

extension ChangePWDViewController{
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
}
