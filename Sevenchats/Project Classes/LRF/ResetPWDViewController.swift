//
//  ResetPWDViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 08/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : ResetPWDViewController                      *
 * Changes :                                             *
 * User can reset password                               *
 *                                                       *
 ********************************************************/

import UIKit

class ResetPWDViewController: ParentViewController {

    @IBOutlet var btnUpdate : UIButton!
    @IBOutlet var txtOTP : MIGenericTextFiled!
    @IBOutlet var txtNewPWD : MIGenericTextFiled!
    @IBOutlet var txtConfirmPWD : MIGenericTextFiled!
    
    var isEnterEmail : Bool?
    var strEmailMobile : String?
    
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
        txtOTP.txtDelegate = self

    }
    
    func setLanguageText() {
        self.title = CResetTitle
        txtOTP.placeHolder = CResetPlaceholderOTP
        txtNewPWD.placeHolder = CResetPlaceholderNewPassword
        txtConfirmPWD.placeHolder = CResetPlaceholderConfirmNewPassword
        btnUpdate.setTitle(CResetBtnUpdate, for: .normal)
    }
}

// MARK:- -------- UITextFieldDelegate
extension ResetPWDViewController: GenericTextFieldDelegate {
   
    @objc func genericTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtOTP{
            let currentCharacterCount = txtOTP.text?.count ?? 0
            if range.length + range.location > currentCharacterCount {
                return false
            }
            let newLength = currentCharacterCount + string.count - range.length
            return newLength <= 6
        }
        
        if textField == txtNewPWD || textField == txtConfirmPWD{
            if textField.text?.count ?? 0 > 20{
                return false
            }
            let cs = NSCharacterSet(charactersIn: PASSWORDALLOWCHAR).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            return (string == filtered)
        }
        return true
    }
    
}

// MARK:- --------- Action Event
extension ResetPWDViewController{
    
    @IBAction func btnUpdateCLK(_ sender : UIButton){
        self.resignKeyboard()
        
        if (txtOTP.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CResetAlertVerificationCodeBlank, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }else if (txtNewPWD.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CResetAlertNewPWDBlank, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }else if !(txtNewPWD.text?.isValidPassword ?? false) {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CResetAlertMinLimit, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }else if (txtConfirmPWD.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CResetAlertConfirmPWDBlank, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }else if txtNewPWD.text != txtConfirmPWD.text{
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CResetAlertPWDConfirmPWDNotMatch, btnOneTitle: CBtnOk, btnOneTapped: nil)
        } else{
            self.resetPassword()
        }
    }
}

// MARK:- --------- API
extension ResetPWDViewController{
    
    func resetPassword () {

    }
}
