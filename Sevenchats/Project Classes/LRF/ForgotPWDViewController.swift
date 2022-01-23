
//
//  ForgotPWDViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 08/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : ForgotPWDViewController                     *
 * Changes :                                             *
 * for got pass word Redirect to Web page                *
 *                                                       *
 ********************************************************/


import UIKit

class ForgotPWDViewController: ParentViewController {
    
    @IBOutlet var txtEmailMobile : MIGenericTextFiled!
    @IBOutlet var txtCountryCode : MIGenericTextFiled!
    @IBOutlet var btnSubmit : UIButton!
    @IBOutlet var lblInformation : UILabel!
    @IBOutlet var cnTxtEmailLeading : NSLayoutConstraint!

    var country_id = 356 //India

    override func viewDidLoad() {
        super.viewDidLoad()
        self.Initialization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- --------- Initialization
    
    func Initialization(){
        btnSubmit.layer.cornerRadius = 5
        self.setLanguageText()
        self.setAttributedString()
        txtCountryCode.text = "--"
        self.loadCountryList()
        txtEmailMobile.txtDelegate = self
        GCDMainThread.async {
            self.txtCountryCode.updatePlaceholderFrame(true)
        }
    }
    
    func setAttributedString() {
      
        let attrs = [NSAttributedString.Key.font : CFontPoppins(size: lblInformation.font.pointSize, type: .light),
                     NSAttributedString.Key.foregroundColor: CRGB(r: 128, g: 128, b: 128)]
        let attrs1 = [NSAttributedString.Key.font : CFontPoppins(size: lblInformation.font.pointSize, type: .meduim),
                      NSAttributedString.Key.foregroundColor: CRGB(r: 128, g: 128, b: 128)]
        
        let attributedString = NSMutableAttributedString(string: "\(CForgotResetText1) ", attributes:attrs)
        let normalString = NSMutableAttributedString(string: CForgotResetMobileEmail, attributes:attrs1)
        let attributedString2 = NSMutableAttributedString(string: " \(CForgotResetText2)", attributes:attrs)
        attributedString.append(normalString)
        attributedString.append(attributedString2)
        lblInformation.attributedText = attributedString
    }
    
    func setLanguageText() {
       
        self.title = CForgotTitle
        txtEmailMobile.placeHolder = CForgotPlaceholderEmailMobile
        txtCountryCode.placeHolder = CRegisterPlaceholderCode
        btnSubmit.setTitle(CForgotBtnSubmit, for: .normal)
    }
    
    func loadCountryList(){

        let arrCountryList = TblCountry.fetch(predicate: NSPredicate(format:"country_code = %@", "+91"))
        
        if (arrCountryList?.count ?? 0) > 0{
            self.txtCountryCode.text = ((arrCountryList![0] as! TblCountry).country_code)
            self.country_id = Int(((arrCountryList![0] as! TblCountry).country_id))
        }
        let arrCountry = TblCountry.fetch(predicate: nil, orderBy: CCountryName, ascending: true)
        let arrCountryCode = arrCountry?.value(forKeyPath: "countryname_code") as? [Any]
        
        if (arrCountryCode?.count)! > 0 {
            
            txtCountryCode.setPickerData(arrPickerData: arrCountryCode!, selectedPickerDataHandler: { (select, index, component) in
                
                let dict = arrCountry![index] as AnyObject
                self.txtCountryCode.text = dict.value(forKey: CCountrycode) as? String
                self.country_id = dict.value(forKey: CCountry_id) as! Int

            }, defaultPlaceholder: "")
        }
    }

}

// MARK:- -------------Social Action
extension ForgotPWDViewController:GenericTextFieldDelegate{
    func genericTextFieldClearText(_ textField: UITextField){
        if textField == txtEmailMobile{
            cnTxtEmailLeading.constant = 20
            txtCountryCode.isHidden = true
            self.view.layoutIfNeeded()
            GCDMainThread.async {
                self.txtEmailMobile.updateBottomLineAndPlaceholderFrame()
            }
        }
    }
    func genericTextFieldDidChange(_ textField : UITextField){
        if textField == txtEmailMobile{
            
            if (txtEmailMobile.text?.isValidPhoneNo)! && !(txtEmailMobile.text?.isBlank)!{
                cnTxtEmailLeading.constant = txtCountryCode.bounds.width + 30
                txtCountryCode.isHidden = false
            }else{
                cnTxtEmailLeading.constant = 20
                txtCountryCode.isHidden = true
            }
            self.view.layoutIfNeeded()
            
            GCDMainThread.async {
                self.txtEmailMobile.updateBottomLineAndPlaceholderFrame()
            }
            
        }
    }
    
    func genericTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        guard let text = textField.text,
            let textRange = Range(range, in: text) else{
                return true
        }
        let updatedText = text.replacingCharacters(in: textRange,with: string)
        if string.isBlank{
            if updatedText.isValidPhoneNo && !updatedText.isEmpty{
                cnTxtEmailLeading.constant = txtCountryCode.bounds.width + 30
                txtCountryCode.isHidden = false
            }else{
                cnTxtEmailLeading.constant = 20
                txtCountryCode.isHidden = true
            }
            self.view.layoutIfNeeded()
            
            GCDMainThread.async {
                self.txtEmailMobile.updateBottomLineAndPlaceholderFrame()
            }
            return true
        }
        if textField == txtEmailMobile{
           if updatedText.isValidPhoneNo && !updatedText.isBlank{
                if textField.text?.count ?? 0 >= 15{
                    return false
                }
                cnTxtEmailLeading.constant = txtCountryCode.bounds.width + 30
                txtCountryCode.isHidden = false
            }else{
                cnTxtEmailLeading.constant = 20
                txtCountryCode.isHidden = true
            }
            self.view.layoutIfNeeded()
            
            GCDMainThread.async {
                self.txtEmailMobile.updateBottomLineAndPlaceholderFrame()
            }
        }
        return true
    }
    
    func genericTextField(_ textField: UITextField, shouldChangeCharactersInForEmpty range: NSRange, replacementString string: String) -> Bool {
        return self.genericTextField(textField, shouldChangeCharactersIn: range, replacementString: string)
    }
}

// MARK:- --------- Action Event
extension ForgotPWDViewController{
    
    @IBAction func btnSubmitCLK(_ sender : UIButton){
        self.resignKeyboard()
        
        if (txtEmailMobile.text?.isBlank)!{
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CForgotAlertEmailMobileBlank, btnOneTitle: CBtnOk, btnOneTapped: nil)
            return
        }else{
            if txtEmailMobile.text?.range(of:"@") != nil || txtEmailMobile.text?.rangeOfCharacter(from: CharacterSet.letters) != nil  {
                if !(txtEmailMobile.text?.isValidEmail)! {
                    self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CForgotAlertValidEmail, btnOneTitle: CBtnOk, btnOneTapped: nil)
                    return
                }
            }else{
                if !(txtEmailMobile.text?.isValidPhoneNo)! || ((txtEmailMobile.text?.count)! > 10 || (txtEmailMobile.text?.count)! < 6) {
                    self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CForgotAlertValidMobileNumber, btnOneTitle: CBtnOk, btnOneTapped: nil)
                    return
                }
            }
        }
        
        self.forgotPassword()
    }
}


// MARK:- --------- API
extension ForgotPWDViewController {
    
    func forgotPassword() {

    }
}
