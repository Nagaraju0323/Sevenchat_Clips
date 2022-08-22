//
//  PassWordViewController.swift
//  Sevenchats
//
//  Created by nagaraju k on 31/07/22.
//  Copyright © 2022 mac-00020. All rights reserved.
//

import UIKit

class PassWordViewController: ParentViewController {

    
    @IBOutlet weak var txtPWD : MIGenericTextFiledNew!
    @IBOutlet weak var txtConfirmPWD : MIGenericTextFiledNew!
    @IBOutlet weak var btnNext :UIButton!
    
    var profileImgUrlupdate = ""
    var userEmail = String()
    var userMobile = String()
    var isEmail_Mobile:Bool?
    var isverify_Success:Bool?
    var dictSingupdatas = [String : Any]()
    var dict = [String : AnyObject]()
    var isEmailVerify : Bool = false
    var dictSinup : [String : Any]? = [:]
   
    override func viewDidLoad() {
        super.viewDidLoad()

        intilization()
        print("consoleput\(dictSingupdatas)")
        // Do any additional setup after loading the view.
    }
    
    func intilization(){
        self.title = CRegisterTitle
        //txtPWD.txtDelegate = self
      //  txtConfirmPWD.txtDelegate = self
        txtPWD.placeHolder = CRegisterPlaceholderPassword
        txtConfirmPWD.placeHolder = CRegisterPlaceholderConfirmPassword
        
        txtPWD.layer.borderWidth = 1
        txtPWD.layer.cornerRadius = 5
        txtConfirmPWD.layer.borderWidth = 1
        txtConfirmPWD.layer.cornerRadius = 5
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
    }

    @objc func methodOfReceivedNotification(notification: Notification) {
        
        self.Singup()
        
        
    }
    
    
    //MARK:- Next Button Action

    @IBAction func btnNextCLK(_ sender : UIButton){
        
      /*  if  (txtPWD.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CRegisterAlertPasswordBlank, btnOneTitle: CBtnOk, btnOneTapped: nil)
            return
        }
        if !(txtPWD.text?.isValidPassword ?? false) {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CRegisterPasswordMinLimit, btnOneTitle: CBtnOk, btnOneTapped: nil)
            return
        }
        if (txtConfirmPWD.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CRegisterAlertConfirmPasswordBlank, btnOneTitle: CBtnOk, btnOneTapped: nil)
            return
        }
        if txtPWD.text != txtConfirmPWD.text{
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CRegisterAlertPasswordConfirmPasswordNotMatch, btnOneTitle: CBtnOk, btnOneTapped: nil)
            return
        }*/
        PopupController
            .create(self)
            .customize(
                [
                    .animation(.slideUp),
                    .scrollable(false),
                    .backgroundStyle(.blackFilter(alpha: 0.7))
                ]
            )
            .didShowHandler { _ in
                print("showed popup!")
            }
            .didCloseHandler { _ in
                print("closed popup!")
                self.Singup()
            }
            .show(DemoPopupViewController1.instance())
       
       
       
//        DemoPopupViewController1.isselectedHandler = { isselected in
//                   print("isselected\(isselected)")
//               }
    }
    
    
 
}


extension PassWordViewController: GenericTextFieldDelegateNew {
    
    @objc func genericTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtPWD || textField == txtConfirmPWD{
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

//MARK:- API Cals
extension PassWordViewController{
    func Singup(){
        
//        print("ismobile\(isEmail_Mobile)")
        if isEmail_Mobile == true {
            print("::::::::this is calling is isEamail")
            verifyEmail()
        }else {
            print("::::::::this is calling is Mobile")
            verifyMobile()
        }
        
        
        
    func verifyEmail() {
        let api  = CAPITagverifyEmailOTP
        APIRequest.shared().verifyEmail(api: api,email :userEmail, verifyCode: userEmail) { (response, error) in
            if response != nil && error == nil{
                let encryptPassword = EncryptDecrypt.shared().encryptDecryptModel(userResultStr: self.txtPWD.text ?? "")
                
                self.dictSingupdatas["password"] = encryptPassword
                
                if let objVerify = CStoryboardLRF.instantiateViewController(withIdentifier: "VerifyEmailMobileViewController") as? VerifyEmailMobileViewController{
                    objVerify.userEmail = self.userEmail
                    objVerify.passwordStr = self.txtPWD.text ?? ""
                    objVerify.isEmail_Mobile = true
                    objVerify.dictSingupdatas = self.dictSingupdatas ?? [:]
                    objVerify.userMobile = ""
                    objVerify.isEmailVerify = true
                    objVerify.profileImgUrlupdate = self.profileImgUrlupdate
                    self.navigationController?.pushViewController(objVerify, animated: true)
                }
            }else {
                guard  let errorUserinfo = error?.userInfo["error"] as? String else {return}
                let errorMsg = errorUserinfo.stringAfter(":")
                //                self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: errorMsg, btnOneTitle: CBtnOk, btnOneTapped: nil)
                self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageEmailExists, btnOneTitle: CBtnOk, btnOneTapped: nil)
            }
        }
    }
    
    
    func verifyMobile() {
        let api = CAPITagVerifyMobile
        APIRequest.shared().verifyMobile(api : api, email :userMobile , mobile: userMobile) { [self] (response, error) in
            if response != nil && error == nil{
                let encryptPassword = EncryptDecrypt.shared().encryptDecryptModel(userResultStr: self.txtPWD.text ?? "")
                
                self.dictSingupdatas["password"] = encryptPassword
               // self.dictSingupdatas["password"] = self.txtPWD.text ?? ""
                
                if let objVerify = CStoryboardLRF.instantiateViewController(withIdentifier: "VerifyEmailMobileViewController") as? VerifyEmailMobileViewController{
                    objVerify.userEmail = ""
                    objVerify.isEmail_Mobile = false
                    objVerify.dictSingupdatas = self.dictSingupdatas ?? [:]
                    objVerify.userMobile = self.userMobile
                    objVerify.passwordStr = self.txtPWD.text ?? ""
                    objVerify.isEmailVerify = false
                    objVerify.profileImgUrlupdate = self.profileImgUrlupdate
                    self.navigationController?.pushViewController(objVerify, animated: true)
                }
                
                if let responseData = response?.value(forKey: CJsonData) as? [String : AnyObject] {
                    _ = responseData.valueForInt(key: "step") ?? 0
                }
            }else {
                
                guard  let errorUserinfo = error?.userInfo["error"] as? String else {return}
                let errorMsg = errorUserinfo.stringAfter(":")
                //                self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: errorMsg, btnOneTitle: CBtnOk, btnOneTapped: nil)
                
                self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessagePhNoExists, btnOneTitle: CBtnOk, btnOneTapped: nil)
            }
        }
    }
    
    }
    
    
    
    
    
    
    
    
    
    
//   func Singup(){
//
//       dictSinup = ["password":self.txtPWD.text ?? ""]
//
//        if isEmail_Mobile == true{
//            if let objVerify = CStoryboardLRF.instantiateViewController(withIdentifier: "VerifyEmailMobileViewController") as? VerifyEmailMobileViewController{
//                objVerify.userEmail = userEmail.lowercased()
//                objVerify.passwordStr = self.txtPWD.text ?? ""
//                objVerify.isEmail_Mobile = true
//                objVerify.dictSingupdatas = dictSinup ?? [:]
//                objVerify.userMobile = userMobile
//                objVerify.isEmailVerify = true
//                objVerify.profileImgUrlupdate = self.profileImgUrlupdate
//                self.navigationController?.pushViewController(objVerify, animated: true)
//            }
//        }else {
//
//
//            if let objVerify = CStoryboardLRF.instantiateViewController(withIdentifier: "VerifyEmailMobileViewController") as? VerifyEmailMobileViewController{
//                objVerify.userEmail = userEmail.lowercased()
//                objVerify.isEmail_Mobile = false
//                objVerify.dictSingupdatas = self.dictSinup ?? [:]
//                objVerify.userMobile = userMobile
//                objVerify.passwordStr = self.txtPWD.text ?? ""
//                objVerify.isEmailVerify = false
//                objVerify.profileImgUrlupdate = self.profileImgUrlupdate
//                self.navigationController?.pushViewController(objVerify, animated: true)
//            }
//
//        }
//    }
}
