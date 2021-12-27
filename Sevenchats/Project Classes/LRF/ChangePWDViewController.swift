//
//  ChangePWDViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 14/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class ChangePWDViewController: ParentViewController {
    
    @IBOutlet var btnUpdate : UIButton!
    @IBOutlet var txtOldPWD : MIGenericTextFiled!
    @IBOutlet var txtNewPWD : MIGenericTextFiled!
    @IBOutlet var txtConfirmPWD : MIGenericTextFiled!

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
//        APIRequest.shared().changePassword(oldPwd: txtOldPWD.text ?? "", newPwd: txtConfirmPWD.text ?? "") { (response, error) in
//            if response != nil && error == nil {
//                if let metaData = response?.value(forKey: CJsonMeta) as? [String : AnyObject] {
//                    self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: metaData.valueForString(key: CJsonMessage), btnOneTitle: CBtnOk, btnOneTapped: { (action) in
//                        self.navigationController?.popToRootViewController(animated: true)
//                    })
//                }
//            }
//        }
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
        }/*else if !(txtNewPWD.text?.isValidPassword)! || (txtNewPWD.text?.count)! < 8  || !(txtNewPWD.text?.isPasswordSpecialCharacterValid)!{
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CRegisterPasswordMinLimit, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }*/else if (txtConfirmPWD.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CResetAlertConfirmPWDBlank, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }else if txtNewPWD.text != txtConfirmPWD.text{
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CResetAlertPWDConfirmPWDNotMatch, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }else{
//            self.changePassword()
            self.changePasswords()
        }
    }
    
    
}


extension ChangePWDViewController{

func changePasswords(){

    guard let userName = appDelegate.loginUser?.email else{ return}
    
    let password = txtNewPWD.text ?? ""
    let old_password = txtOldPWD.text ?? ""
    
    let data : Data = "username=\(userName)&password=\(password)&grant_type=password&client_id=null&client_secret=null&old_password=\(old_password)".data(using: .utf8)!
    
    let url = URL(string: "http://dev.sevenchats.com:3001/auth/resetPassword")
//    let url = URL(string: "https://qa.sevenchats.com:7443/auth/resetPassword")
    var request : URLRequest = URLRequest(url: url!)
    request.httpMethod = "PUT"
    
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type");
    
    request.setValue("Bearer \("f17511300f38aef3f6d1a674c07e7292c1dc56ec")", forHTTPHeaderField:"Authorization")
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
//        DispatchQueue.main.async { [self] in // Correct
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            let decoder = JSONDecoder()
            let token_type = (String(data: responseData, encoding: .utf8))
            do {
                let dict = try self.convertStringToDictionary(text: token_type ?? "")
                guard let userMsg = dict?["message"] as? String else { return }
                DispatchQueue.main.async {
                self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: userMsg, btnOneTitle: CBtnOk, btnOneTapped: { (action) in
                    self.dismiss(animated: true, completion: nil)
                    self.navigationController?.popToRootViewController(animated: true)
                })
             }
            }catch let error  {
                print("error trying to convert data to \(error)")
            }
//        }
    })
    task.resume()
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
