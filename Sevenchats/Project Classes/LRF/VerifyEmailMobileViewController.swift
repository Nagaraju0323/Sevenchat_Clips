//
//  VerifyEmailMobileViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 08/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : VerifyEmailMobileViewController             *
 * Changes :                                             *
 * verify OTP with Auth Server once user Enter valid OTP *
 * Registration is completed                             *
 *                                                       *
 ********************************************************/

import UIKit

class VerifyEmailMobileViewController: ParentViewController {
    
    @IBOutlet var btnSubmit : UIButton!
    @IBOutlet var btnResend : UIButton!
    @IBOutlet var txtVerificationCode : MIGenericTextFiled!
    @IBOutlet var lblNote : UILabel!
    
    var isEmailVerify : Bool = false
    var dict = [String : AnyObject]()
    var dictSingupdatas = [String : Any]()
    var otpCode = ""
    var userEmail = String()
    var userMobile = String()
    var isFromEditProfile = false
    var isEmail_Mobile:Bool?
    var isverify_Success:Bool?
    var apiStatusCode = 0
    var url:URL?
    var passwordStr = ""
    var profileImgUrlupdate = "" 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Initialization()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- --------- Initialization
    func Initialization(){
        
        txtVerificationCode.text = otpCode
        GCDMainThread.async {
            self.txtVerificationCode.updatePlaceholderFrame(true)
        }
        btnSubmit.layer.cornerRadius = 5
        self.setLanguageText()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_back"), style: .plain, target: self, action: #selector(btnVerifyBackCLK(_:)))
        GCDMainThread.async {
            self.txtVerificationCode.txtDelegate = self
        }
    }
    
    func setLanguageText() {
        
        if isEmailVerify {
            self.title = CVerifyEmailTitle
            self.lblNote.text = "\(CVerifyEmailVerificationInfoText) (\(dict.valueForString(key: CEmail)))"
        } else {
            self.title = CVerifyMobileTitle
            self.lblNote.text = "\(CVerifyMobileVerificationInfoText) (\(dict.valueForString(key: CMobile)))"
        }
        
        txtVerificationCode.placeHolder = CRegisterPlaceholderVerificationCode
        btnSubmit.setTitle(CForgotBtnSubmit, for: .normal)
        btnResend.setTitle(CForgotBtnResendCode, for: .normal)
    }
}

// MARK:- --------- API
extension VerifyEmailMobileViewController {
    
    func verifyEmail() {
        let api  = CAPITagverifyEmailOTP
        APIRequest.shared().verifyEmail(api: api,email : userEmail, verifyCode: txtVerificationCode.text!) { (response, error) in
            if response != nil && error == nil{
                if let responseData = response?.value(forKey: CJsonData) as? [String : AnyObject] {
                    _ = responseData.valueForInt(key: "step") ?? 2
                }
            }else {
                guard  let errorUserinfo = error?.userInfo["error"] as? String else {return}
                let errorMsg = errorUserinfo.stringAfter(":")
                self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: errorMsg, btnOneTitle: CBtnOk, btnOneTapped: nil)
            }
        }
    }
    
    func verifyMobile() {
        let api = isFromEditProfile ? CAPITagVerifyEditMobile :  CAPITagVerifyMobile
        APIRequest.shared().verifyMobile(api : api, email : userEmail, mobile: userMobile) { (response, error) in
            if response != nil && error == nil{
                if #available(iOS 12.0, *) {
                    self.txtVerificationCode.textContentType = .oneTimeCode
                } else {
                    
                }
                if let responseData = response?.value(forKey: CJsonData) as? [String : AnyObject] {
                    _ = responseData.valueForInt(key: "step") ?? 0
                    if !self.isFromEditProfile {
                        if let metaData = response?.value(forKey: CJsonMeta) as? [String : AnyObject] {
                            self.apiStatusCode = metaData.valueForInt(key: CJsonStatus) ?? 0
                        }
                    }
                }
            }
        }
    }
    
    func resendCode() {
        
        let api = isFromEditProfile ? CAPITagResendEditVerification :  CAPITagResendVerification
        var body : [String:Any] = [:]
        if isEmailVerify{
            body[CEmail_or_Mobile] = dict.valueForString(key: CEmail)
            body[CType] = CEmailType
        }else{
            body[CEmail_or_Mobile] = dict.valueForString(key: CMobile)
            body[CType] = CMobileType
            if isFromEditProfile{
                body["country_id"] = dict.valueForInt(key: CCountry_id) ?? 0
            }
        }
    }
    
    func redirectOnSuccess( step : Int){
        if let profileVC = self.getViewControllerFromNavigation(MyProfileViewController.self){
            profileVC.tblUser.reloadData()
        }
        if step == 1 {
            if let objVerify = CStoryboardLRF.instantiateViewController(withIdentifier: "VerifyEmailMobileViewController") as? VerifyEmailMobileViewController{
                objVerify.isFromEditProfile = self.isFromEditProfile
                objVerify.isEmailVerify = true
                objVerify.apiStatusCode = self.apiStatusCode
                objVerify.dict = self.dict
                objVerify.otpCode = ""
                self.navigationController?.pushViewController(objVerify, animated: true)
            }
        } else if step == 2{
            if let objVerify = CStoryboardLRF.instantiateViewController(withIdentifier: "VerifyEmailMobileViewController") as? VerifyEmailMobileViewController{
                objVerify.isFromEditProfile = self.isFromEditProfile
                objVerify.isEmailVerify = false
                objVerify.apiStatusCode = self.apiStatusCode
                objVerify.dict = self.dict
                objVerify.otpCode = ""
                self.navigationController?.pushViewController(objVerify, animated: true)
            }
        } else {
            
            if self.isFromEditProfile {
                
                let isAppLaunchHere = CUserDefaults.value(forKey: UserDefaultIsAppLaunchHere) as? Bool ?? true
                if self.apiStatusCode == CStatusTwelve && isAppLaunchHere {
                    CUserDefaults.set(false, forKey: UserDefaultIsAppLaunchHere)
                    CUserDefaults.synchronize()
                    appDelegate.initHomeViewController()
                } else if self.apiStatusCode == CStatusZero && !isAppLaunchHere {
                    CUserDefaults.set(true, forKey: UserDefaultIsAppLaunchHere)
                    CUserDefaults.synchronize()
                    appDelegate.initHomeViewController()
                } else if self.isFromEditProfile{
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }else {
                if self.apiStatusCode == CStatusTwelve {
                    CUserDefaults.set(false, forKey: UserDefaultIsAppLaunchHere)
                    CUserDefaults.synchronize()
                    appDelegate.initHomeViewController()
                }else if let inviteContancVC = CStoryboardLRF.instantiateViewController(withIdentifier: "InviteAndConnectViewController") as? InviteAndConnectViewController{
                    
                    inviteContancVC.isFromSideMenu = false
                    self.navigationController?.pushViewController(inviteContancVC, animated: true)
                }
            }
            
        }
    }
    
    func UserDetailsfeath(userEmailId:String,accessToken:String) {
        
        let dict:[String:Any] = [
            CEmail_Mobile : userEmailId,
        ]
        
        APIRequest.shared().userDetails(para: dict as [String : AnyObject]) { (response, error) in
            if response != nil && error == nil {
                DispatchQueue.main.async {
                    let name = (appDelegate.loginUser?.first_name ?? "") + " " + (appDelegate.loginUser?.last_name ?? "")
                    guard let image = appDelegate.loginUser?.profile_img else { return }
                    MIGeneralsAPI.shared().addRewardsPoints(CRegisterprofile,message:"Register_profile",type:CRegisterprofile,title:"Register profile",name:name,icon:image)
                    
                    self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CRegisterSuccess, btnOneTitle: CBtnOk, btnOneTapped: { (action) in
                        self.dismiss(animated: true, completion: nil)
                        self.isverify_Success = true
                        self.navigationController?.popToRootViewController(animated: true)
                    })
                }
            }
        }
    }
}

// MARK:- --------- Action Event
extension VerifyEmailMobileViewController{
    @objc fileprivate func btnVerifyBackCLK(_ sender : UIBarButtonItem) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func btnSubmitCLK(_ sender : UIButton){
        
        self.resignKeyboard()
        
        if (txtVerificationCode.text?.isBlank)!{
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CForgotAlertVerficationCodeIncorrect, btnOneTitle: CBtnOk, btnOneTapped: nil)
        } else if (txtVerificationCode.text?.count)! < 6{
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CForgotAlertVerficationCodeIncorrect, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }else {
            self.redirectOnSuccessAfter(otp:txtVerificationCode.text ?? "")
        }
    }
    
    @IBAction func btnResendCodeCLK(_ sender : UIButton){
        if isEmail_Mobile == true {
            self.verifyEmail()
        }else {
            self.verifyMobile()
        }
    }
}

//MARK:- --------- textfield delegate
extension VerifyEmailMobileViewController: GenericTextFieldDelegate {
    
    func genericTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentCharacterCount = txtVerificationCode.text?.count ?? 0
        if range.length + range.location > currentCharacterCount {
            return false
        }
        let newLength = currentCharacterCount + string.count - range.length
        return newLength <= 6
    }
}

extension VerifyEmailMobileViewController{
    
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

// MARK:- --------- API Auth
extension VerifyEmailMobileViewController{
    
    func singupRegisterUser(param:[String:Any]){
        APIRequest.shared().signUpUser(dict: param as [String : AnyObject]) { (response, error) in
            if response != nil && error == nil {
                let msgError = response?["error"] as? String
                let errorMsg = msgError?.stringAfter(":")
                if errorMsg == " User Mobile Number is Exists" ||  errorMsg == " User email Exists"{
                    CTopMostViewController.presentAlertViewWithOneButton(alertTitle: "", alertMessage: errorMsg, btnOneTitle: CBtnOk, btnOneTapped: nil)
                } else {
                    let dict = response?.value(forKey: CJsonData) as! [String : AnyObject]
                    self.uploadUserProfile(userID: dict.valueForInt(key: CUserId)!, signUpResponse: response, imageEmpty:false)
                    self.registerUserEmail(username:self.userEmail,password:self.passwordStr)
                    self.registerUserMobile(username:self.userMobile,password:self.passwordStr)
                }
            }
        }
    }
    
    func registerUserEmail(username:String,password:String){
        let data : Data = "username=\(username)&password=\(password)&grant_type=password&client_id=null&client_secret=null".data(using: .utf8)!
        let url = URL(string: "\(BASEAUTH)auth/register")
        var request : URLRequest = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type");
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
            let decoder = JSONDecoder()
            let token_type = (String(data: responseData, encoding: .utf8))
            do {
                let dict = try self.convertStringToDictionary(text: token_type ?? "")
                guard let userMsg = dict?["message"] as? String else { return }
                DispatchQueue.main.async {
                    MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
                    self.UserDetailsfeath(userEmailId:self.userEmail,accessToken:"")
                    MIGeneralsAPI.shared().fetchAllGeneralDataFromServer()
                }
            } catch let error  {
                print("error trying to convert data to \(error)")
            }
        })
        task.resume()
    }
    
    func registerUserMobile(username:String,password:String){
        let data : Data = "username=\(username)&password=\(password)&grant_type=password&client_id=null&client_secret=null".data(using: .utf8)!
        let url = URL(string: "\(BASEAUTH)auth/register")
        var request : URLRequest = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type");
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
            let decoder = JSONDecoder()
            let token_type = (String(data: responseData, encoding: .utf8))
            do {
                let dict = try self.convertStringToDictionary(text: token_type ?? "")
                guard let userMsg = dict?["message"] as? String else { return }
                DispatchQueue.main.async {
                }
            } catch let error  {
                print("error trying to convert data to \(error)")
            }
        })
        task.resume()
    }
    
    
    func uploadUserProfile(userID : Int, signUpResponse : AnyObject?,imageEmpty:Bool) {
        if imageEmpty == true{
            print("image empty convert text to image")
        }else {
            let dict : [String : Any] =  [
                "user_id":userID,
                "profile_image":profileImgUrlupdate
            ]
            APIRequest.shared().uploadUserProfile(userID: userID, para:dict,profileImgName:profileImgUrlupdate) { (response, error) in
                if response != nil && error == nil {
                }
            }
        }
    }
    
    func redirectOnSuccessAfter(otp:String){
        
        if isEmail_Mobile == true {
            self.url = URL(string: "\(BASEURLOTP)auth/verifyEmailOTP?email=\(userEmail)&otp=\(otp)")
        }else {
            self.url = URL(string:"\(BASEURLOTP)auth/verifyMobileOTP?mobile=\(userMobile)&otp=\(otp)")
        }
        var request : URLRequest = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type");
        request.setValue(NSLocalizedString("lang", comment: ""), forHTTPHeaderField:"Accept-Language");
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
            let decoder = JSONDecoder()
            let token_type = (String(data: responseData, encoding: .utf8))
            do {
                let dict = try self.convertStringToDictionary(text: token_type ?? "")
                guard let userMsg = dict?["message"] as? String else { return }
                if userMsg == "invalid_otp"{
                    self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: userMsg, btnOneTitle: CBtnOk, btnOneTapped: { (action) in
                        self.dismiss(animated: true, completion: nil)
                    })
                }else {
                    DispatchQueue.main.async (execute: { () -> Void in
                        self.singupRegisterUser(param:self.dictSingupdatas)
                    })
                }
            }catch let error  {
                print("error trying to convert data to \(error)")
            }
        })
        task.resume()
    }
}
