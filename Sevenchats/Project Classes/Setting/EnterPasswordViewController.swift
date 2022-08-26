//
//  EnterPasswordViewController.swift
//  Sevenchats
//
//  Created by nagaraju k on 01/08/22.
//  Copyright © 2022 mac-00020. All rights reserved.
//

import UIKit

class EnterPasswordViewController: ParentViewController {

    @IBOutlet weak var txtEmail: MIGenericTextFiled!
    @IBOutlet weak var txtPWD: MIGenericTextFiled!
    @IBOutlet weak var deleteBtn: MIGenericButton!
    @IBOutlet var lblTitle : UILabel!
    
    var deactivebtnIsselected:Bool?
    var accountType = 0
    var userData = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Intilization()
        // Do any additional setup after loading the view.
    }
    
    func Intilization(){
    
        self.deleteBtn.setTitle(CContinueDeleteAcc, for: .normal)
        txtEmail.text = userData
//        lblTitle.text = "text Message"
        txtPWD.txtDelegate = self
        txtPWD.placeHolder = CRegisterPlaceholderPassword
    }
    
    @IBAction func continueBtnCLK(_ sender: UIButton) {
        
        if  (txtPWD.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CRegisterAlertPasswordBlank, btnOneTitle: CBtnOk, btnOneTapped: nil)
            return
        }
        let alert = UIAlertController(title: "", message: CSELECTCHOICE, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: CMessagepermanentDelete, style: .default, handler: { (_) in
            self.deleteAccount()
        }))
        alert.addAction(UIAlertAction(title: CBtnCancel, style: .default, handler: { (_) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
       
        
    }
  }




extension EnterPasswordViewController{
    
    func deleteAccount(){
        let dict:[String:Any] = [
            "username": txtEmail.text!,
            "password": txtPWD.text!,
        ]
        APIRequest.shared().userDeleteAccount(para: dict as [String : AnyObject]) { (response, error) in
            if response != nil && error == nil {
                DispatchQueue.main.async {
                    
                    self.userAccountDeactive(accountType:"1")
                }
            }else {
              //change LanguageHear
                
                guard  let errorUserinfo = error?.userInfo["error"] as? String else {return}
                let errorMsg = errorUserinfo.stringAfter(":")
                self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: errorMsg, btnOneTitle: CBtnOk, btnOneTapped: nil)
            }
        }
        
    }
    func userAccountDeactive(accountType:String){
        let userid = appDelegate.loginUser?.user_id.description ?? ""
        let dict:[String:Any] = [
            "user_id": userid,
            "type": accountType,
        ]
        APIRequest.shared().userAccountDeactivate(para: dict as [String : AnyObject]) { (response, error) in
            if response != nil && error == nil {
                DispatchQueue.main.async {
                    appDelegate.logOut()
                    let loginViewController = CStoryboardLRF.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
                    UIApplication.shared.keyWindow?.rootViewController = loginViewController
                }
            }else {
                //change LanguageHear
                guard  let errorUserinfo = error?.userInfo["error"] as? String else {return}
                let errorMsg = errorUserinfo.stringAfter(":")
                self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageEmailExists, btnOneTitle: CBtnOk, btnOneTapped: nil)
            }
        }
    }
}

extension EnterPasswordViewController: GenericTextFieldDelegate {
    
    @objc func genericTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtPWD {
            if textField.text?.count ?? 0 > 20{
                return false
            }
            let cs = NSCharacterSet(charactersIn: PASSWORDALLOWCHAR).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            return (string == filtered)
        }
        return true
        
    }
    
    func genericTextField(_ textField: UITextField, shouldChangeCharactersInForEmpty range: NSRange, replacementString string: String) -> Bool {
        return self.genericTextField(textField, shouldChangeCharactersIn: range, replacementString: string)
    }
    
}
