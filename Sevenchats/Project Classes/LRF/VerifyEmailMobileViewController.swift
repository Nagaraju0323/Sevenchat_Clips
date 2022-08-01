//
//  VerifyEmailMobileViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 08/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
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
    var emailverify:Bool?
    var mobileverify:Bool?
    var userToken:String?
    var profileImg = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Initialization()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- --------- Initialization
    func Initialization(){
        
        
        profileImg = profileImgUrlupdate
        
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
        
        MIGeneralsAPI.shared().fetchAllGeneralDataFromServerMaster()
    }
    
    func setLanguageText() {
        
        if isEmailVerify {
            self.title = CVerifyEmailTitle
            self.lblNote.text = "\(CVerifyEmailVerificationInfoText) (\(userEmail))"
        } else {
            self.title = CVerifyMobileTitle
            self.lblNote.text = "\(CVerifyMobileVerificationInfoText) (\(userMobile))"
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
                //                self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: errorMsg, btnOneTitle: CBtnOk, btnOneTapped: nil)
                self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageEmailExists, btnOneTitle: CBtnOk, btnOneTapped: nil)
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
        
        //        let api = isFromEditProfile ? CAPITagResendEditVerification :  CAPITagResendVerification
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
            self.singupWithUserEmailOrMobile(otp:txtVerificationCode.text ?? "")
        }
    }
    
    @IBAction func btnResendCodeCLK(_ sender : UIButton){
        if isEmail_Mobile == true {
            self.verifyEmail()
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CREgisterREsendOTP, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }else {
            self.verifyMobile()
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CREgisterREsendOTP, btnOneTitle: CBtnOk, btnOneTapped: nil)
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
    
    //..verify OTP
    //...userenterOTPCrossCheck
    func singupWithUserEmailOrMobile(otp:String){
        DispatchQueue.main.async {
            MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        }

        if isEmail_Mobile == true {
            self.url = URL(string: "\(BASEURLOTP)auth/verifyEmailOTP?email=\(userEmail)&otp=\(otp)")
            emailverify = true
        }else {
            self.url = URL(string:"\(BASEURLOTP)auth/verifyMobileOTP?mobile=\(userMobile)&otp=\(otp)")
            mobileverify = true
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
            _ = JSONDecoder()
            let token_type = (String(data: responseData, encoding: .utf8))
            do {
                let dict = try self.convertStringToDictionary(text: token_type ?? "")
                guard let userMsg = dict?["message"] as? String else { return }
                if userMsg == "verification_failed"{
                    DispatchQueue.main.async {
                        MILoader.shared.hideLoader()
                        self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CWRONGOTP, btnOneTitle: CBtnOk, btnOneTapped: { (action) in
                            self.dismiss(animated: true, completion: nil)
                        })
                    }
                }else {
                    
                    if userMsg == "The OTP provided is valid."{
                        if self.emailverify == true{
                            self.dictSingupdatas["is_email_verify"] = "1"
                            self.dictSingupdatas["is_mobile_verify"] = "0"
                        }else if self.mobileverify == true{
                            self.dictSingupdatas["is_email_verify"] = "0"
                            self.dictSingupdatas["is_mobile_verify"] = "1"
                        }
                        if self.emailverify == true {
                            self.singup_ValidationWith_EmailID_Mobilenumber()
                        }else if self.mobileverify == true{
                            self.singup_ValidationWith_EmailID_Mobilenumber()
                        }
                    }else {
                        
                        DispatchQueue.main.async {
                            MILoader.shared.hideLoader()
                            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CWRONGOTP, btnOneTitle: CBtnOk, btnOneTapped: { (action) in
                                self.dismiss(animated: true, completion: nil)
                            })
                        }
                    }
                }
            }catch let error  {
                print("error trying to convert data to \(error)")
            }
        })
        task.resume()
    }
    
    //...vaidate emaild & Mobilenumber Exissted or not
    
    func singup_ValidationWith_EmailID_Mobilenumber(){
        
        if isEmail_Mobile == true {
            self.url = URL(string: "\(BASEMASTERURL)users/validate-email?email=\(userEmail)")
            emailverify = true
        }else {
            self.url = URL(string:"\(BASEMASTERURL)users/validate-mobile?mobile=\(userMobile)")
            mobileverify = true
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
            _ = JSONDecoder()
            let token_type = (String(data: responseData, encoding: .utf8))
            print("::::::singupValidation::::\(token_type)")
            do {
                let dict = try self.convertStringToDictionary(text: token_type ?? "")
                print("::::::singupValidation::::\(token_type)")
                if let metaInfo = dict![CJsonMeta] as? [String : Any] {
                    print("userMessage\(metaInfo)")
                    let stausLike = metaInfo["status"] as? String ?? "0"
                    if stausLike == "0" {
                        if self.emailverify == true {
                            self.singupAndRegisterUsers(param:self.dictSingupdatas, isVerifySataus: 1)
                        }else if self.mobileverify == true{
                            self.singupAndRegisterUsers(param:self.dictSingupdatas,isVerifySataus:2)
                        }
                        
                    }else {
                        if  self.emailverify == true {
                            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageEmailExists, btnOneTitle: CBtnOk, btnOneTapped: { (action) in
                                self.dismiss(animated: true, completion: nil)
                            })
                        }else {
                            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessagePhNoExists, btnOneTitle: CBtnOk, btnOneTapped: { (action) in
                                self.dismiss(animated: true, completion: nil)
                            })
                        }
                    }
                }
            }catch let error  {
                print("error trying to convert data to \(error)")
            }
        })
        task.resume()
    }
    
    //..EmailID Or Mobiele validation
    //..number Existed In Data base Or not
    func singupAndRegisterUsers(param:[String:Any],isVerifySataus:Int){
        APIRequest.shared().signUpUser(dict: param as [String : AnyObject]) { (response, error) in
            if response != nil && error == nil {
                let msgError = response?["error"] as? String
                let errorMsg = msgError?.stringAfter(":")
                if errorMsg == " User Mobile Number is Exists" ||  errorMsg == " User email Exists"{
                    if errorMsg == " User Mobile Number is Exists"{
                        CTopMostViewController.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessagePhNoExists, btnOneTitle: CBtnOk, btnOneTapped: nil)
                    }else if errorMsg == " User email Exists"{
                        CTopMostViewController.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageEmailExists, btnOneTitle: CBtnOk, btnOneTapped: nil)
                    }
                    
                } else {
                    let dict = response?.value(forKey: CJsonData) as! [String : AnyObject]
                    //   self.uploadUserProfile(userID: dict.valueForInt(key: CUserId)!, signUpResponse: response, imageEmpty:false)
                    if isVerifySataus == 1{
                        self.registerUserEmail(username:self.userEmail,password:self.passwordStr)
                    }else if isVerifySataus == 2{
                        self.registerUserMobile(username:self.userMobile,password:self.passwordStr)
                    }
                }
            }
        }
    }
    
    //..EmailID Or Mobiele Register For Database
    //..Register With EmailID
    func registerUserEmail(username:String,password:String){
        
        let dispatchGroup = DispatchGroup()
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
            _ = JSONDecoder()
            let token_type = (String(data: responseData, encoding: .utf8))
            do {
                let dict = try self.convertStringToDictionary(text: token_type ?? "")
                guard let userMsg = dict?["message"] as? String else { return }
                if userMsg == "Success!!"{
                   
                    UserDefaults.standard.set(self.profileImg, forKey: "ProfileImg")
                    UserDefaults.standard.set(self.profileImgUrlupdate,forKey: "prfileImageLoad")
                    UserDefaults.standard.synchronize()
                    
                    DispatchQueue.main.async {
                        
//                        print("profileImage\(profileImg)")
                      
//                        CUserDefaults.set(self.profileImgUrlupdate, forKey: "updateProfileImg")
                        //  MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
                        MILoader.shared.hideLoader()
                        print("Successfully Done!!")
                        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
                        alertWindow.rootViewController = UIViewController()
                        let alertController = UIAlertController(title: "", message: CRegisterSuccess, preferredStyle: UIAlertController.Style.alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: { _ in
                            alertWindow.isHidden = true
                            self.dismiss(animated: true, completion: nil)
                            self.isverify_Success = true
                            self.navigationController?.popToRootViewController(animated: true)
                            return
                        }))
                        alertWindow.windowLevel = UIWindow.Level.alert + 1;
                        alertWindow.makeKeyAndVisible()
                        alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
                        
                    }
                    //
                    //                    let concurrentQueue = DispatchQueue(label: "queue", attributes: .concurrent)
                    //                    let semaphore = DispatchSemaphore(value: 1)
                    //                    dispatchGroup.enter()
                    //                    concurrentQueue.async {
                    //                        semaphore.wait()
                    //                        self.token_Generation_LoginApiCall(userEmailId:username,completion: { [self] success in
                    //                            if success == true {
                    //                                dispatchGroup.leave()
                    //                                semaphore.signal()
                    //                            }
                    //                        })
                    //                    }
                    
                    //                    dispatchGroup.enter()
                    //                    concurrentQueue.async {
                    //                        semaphore.wait()
                    //                        let name = (appDelegate.loginUser?.first_name ?? "") + " " + (appDelegate.loginUser?.last_name ?? "")
                    //                        guard let image = appDelegate.loginUser?.profile_img else { return }
                    //                        MIGeneralsAPI.shared().addRewardsPoints(CRegisterprofile,message:"Register_profile",type:CRegisterprofile,title:"Register profile",name:name,icon:image, detail_text: "Register_profile",target_id: 0)
                    //                        dispatchGroup.leave()
                    //                        semaphore.signal()
                    //                    }
                    //                    dispatchGroup.enter()
                    //                    concurrentQueue.async {
                    //                        semaphore.wait()
                    //                        let userid = appDelegate.loginUser?.user_id
                    //                        self.uploadWithPic(userId:userid?.description ?? "",completion: { [self] success in
                    //                            if success == true {
                    //                                dispatchGroup.leave()
                    //                                semaphore.signal()
                    //                            }
                    //                        })
                    //                    }
                    
                }else {
                    DispatchQueue.main.async {
                        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
                        alertWindow.rootViewController = UIViewController()
                        let alertController = UIAlertController(title: "", message:userMsg , preferredStyle: UIAlertController.Style.alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: { _ in
                            self.dismiss(animated: true, completion: nil)
                            //                        return
                        }))
                        alertWindow.windowLevel = UIWindow.Level.alert + 1;
                        alertWindow.makeKeyAndVisible()
                        alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
                    }
                }
                //                dispatchGroup.notify(queue: .main) {
                //                    MILoader.shared.hideLoader()
                //                    print("Successfully Done!!")
                //                    let alertWindow = UIWindow(frame: UIScreen.main.bounds)
                //                    alertWindow.rootViewController = UIViewController()
                //                    let alertController = UIAlertController(title: "", message: CRegisterSuccess, preferredStyle: UIAlertController.Style.alert)
                //                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: { _ in
                //                        alertWindow.isHidden = true
                //                        self.dismiss(animated: true, completion: nil)
                //                        self.isverify_Success = true
                //                        self.navigationController?.popToRootViewController(animated: true)
                //                        return
                //                    }))
                //                    alertWindow.windowLevel = UIWindow.Level.alert + 1;
                //                    alertWindow.makeKeyAndVisible()
                //                    alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
                //
                //                }
            } catch let error  {
                print("error trying to convert data to \(error)")
            }
        })
        task.resume()
    }
    //..EmailID Or Mobiele Register For Database
    //..Register With EmailID
    
    func registerUserMobile(username:String,password:String){
        
        let dispatchGroup = DispatchGroup()
        
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
            _ = JSONDecoder()
            let token_type = (String(data: responseData, encoding: .utf8))
            do {
              
                let dict = try self.convertStringToDictionary(text: token_type ?? "")
                guard let userMsg = dict?["message"] as? String else { return }
                print("errorMsg\(userMsg)")
                
                if userMsg == "Success!!"{
//                    DispatchQueue.main.async {
//                        MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
//                    }
//                    let concurrentQueue = DispatchQueue(label: "queue", attributes: .concurrent)
//                    let semaphore = DispatchSemaphore(value: 1)
//                    dispatchGroup.enter()
//                    concurrentQueue.async {
//                        semaphore.wait()
//                        self.token_Generation_LoginApiCall(userEmailId:username,completion: { [self] success in
//                            if success == true {
//                                dispatchGroup.leave()
//                                semaphore.signal()
//                            }
//                        })
//                    }
//
//                    dispatchGroup.enter()
//                    concurrentQueue.async {
//                        semaphore.wait()
//                        let userid = appDelegate.loginUser?.user_id
//                        self.uploadWithPic(userId:userid?.description ?? "",completion: { [self] success in
//                            if success == true {
//                                dispatchGroup.leave()
//                                semaphore.signal()
//                            }
//                        })
//                    }
//                    dispatchGroup.enter()
//                    concurrentQueue.async {
//                        semaphore.wait()
//                        let name = (appDelegate.loginUser?.first_name ?? "") + " " + (appDelegate.loginUser?.last_name ?? "")
//                        guard let image = appDelegate.loginUser?.profile_img else { return }
//                        MIGeneralsAPI.shared().addRewardsPoints(CRegisterprofile,message:"Register_profile",type:CRegisterprofile,title:"Register profile",name:name,icon:image, detail_text: "Register_profile",target_id: 0)
//                        dispatchGroup.leave()
//                        semaphore.signal()
//                    }
//
                    DispatchQueue.main.async{
                    MILoader.shared.hideLoader()
                    print("Successfully Done!!")
                    let alertWindow = UIWindow(frame: UIScreen.main.bounds)
                    alertWindow.rootViewController = UIViewController()
                    let alertController = UIAlertController(title: "", message: CRegisterSuccess, preferredStyle: UIAlertController.Style.alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: { _ in
                        alertWindow.isHidden = true
                        self.dismiss(animated: true, completion: nil)
                        self.isverify_Success = true
                        self.navigationController?.popToRootViewController(animated: true)
                        return
                    }))
                    alertWindow.windowLevel = UIWindow.Level.alert + 1;
                    alertWindow.makeKeyAndVisible()
                    alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
                    }
                    
                }else {
                    DispatchQueue.main.async {
                        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
                        alertWindow.rootViewController = UIViewController()
                        let alertController = UIAlertController(title: "", message:userMsg , preferredStyle: UIAlertController.Style.alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: { _ in
                            self.dismiss(animated: true, completion: nil)
                            //                        return
                        }))
                        alertWindow.windowLevel = UIWindow.Level.alert + 1;
                        alertWindow.makeKeyAndVisible()
                        alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
                    }
                }
//                dispatchGroup.notify(queue: .main) {
//                    MILoader.shared.hideLoader()
//                    print("Successfully Done!!")
//                    let alertWindow = UIWindow(frame: UIScreen.main.bounds)
//                    alertWindow.rootViewController = UIViewController()
//                    let alertController = UIAlertController(title: "", message: CRegisterSuccess, preferredStyle: UIAlertController.Style.alert)
//                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: { _ in
//                        alertWindow.isHidden = true
//                        self.dismiss(animated: true, completion: nil)
//                        self.isverify_Success = true
//                        self.navigationController?.popToRootViewController(animated: true)
//                        return
//                    }))
//                    alertWindow.windowLevel = UIWindow.Level.alert + 1;
//                    alertWindow.makeKeyAndVisible()
//                    alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
//
//                }
            } catch let error  {
                print("error trying to convert data to \(error)")
            }
        })
        task.resume()
    }
    //Token Generation For Header
    //LogingToken
    
    func token_Generation_LoginApiCall(userEmailId:String,completion:@escaping(_ success:Bool) -> Void ){
        let txtEmailid = userEmailId.lowercased()
        let data : Data = "username=\(txtEmailid)&password=\(passwordStr)&grant_type=password&client_id=null&client_secret=null".data(using: .utf8)!
        let url = URL(string: "\(BASEAUTH)auth/login")
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
            else if response != nil {
            }else if data != nil{
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
                //            DispatchQueue.main.async { [self] in
                guard let responseData = data else {
                    print("Error: did not receive data")
                    return
                }
                _ = JSONDecoder()
                let token_type = (String(data: responseData, encoding: .utf8))
                do {
                    let dict = try self.convertStringToDictionary(text: token_type ?? "")
                    if dict == nil{
                        completion(true)
                    }else {
                        
                        guard let usertoken = dict?["token_type"] as? String else { return  }
                        guard let access_token = dict?["access_token"] as? String else { return }
                        CUserDefaults.setValue(access_token, forKey: UserDefaultDeviceToken)
                        CUserDefaults.synchronize()
                        if self.isEmailVerify == true{
                            self.UserDetailsfeath(userEmailId:userEmailId,accessToken:access_token,completion: { [self] success in
                                if success == true {
                                    completion(true)
                                }
                            })
                            
                        }else {
                            
                            self.UserDetailsfeathMobile(userEmailId:userEmailId,accessToken:access_token,completion: { [self] success in
                                if success == true {
                                    completion(true)
                                }
                            })
                        }
                    }
                }catch let error  {
                    print("error trying to convert data to \(error)")
                }
            }
        })
        task.resume()
    }
    
    //Featch From UserEamild
    //..Userdetails Feath with Useremaiid
    func UserDetailsfeath(userEmailId:String,accessToken:String,completion:@escaping(_ success:Bool) -> Void ) {
        let dict:[String:Any] = [
            CEmail_Mobile : userEmailId,
        ]
        DispatchQueue.main.async{
            APIRequest.shared().userDetails(para: dict as [String : AnyObject],access_Token:accessToken,viewType:1) { (response, error) in
                if response != nil && error == nil {
                    completion(true)
                }
            }
        }
    }
    
    //Featch From Mobilenumber
    //..Userdetails Feath with Mobile
    func UserDetailsfeathMobile(userEmailId:String,accessToken:String,completion:@escaping(_ success:Bool) -> Void ) {
        let dict:[String:Any] = [
            CMobile : userEmailId,
        ]
        DispatchQueue.main.async{
            APIRequest.shared().userDetailsMobile(para: dict as [String : AnyObject],access_Token:accessToken,viewType:1) { (response, error) in
                if response != nil && error == nil {
                    completion(true)
                }
            }
        }
    }
    
    //...UserDetails featch from Back
    func uploadWithPic(userId:String,completion:@escaping(_ success:Bool) -> Void ){
        
        let dict : [String : Any] =  [
            "user_id":userId,
            "profile_image":profileImgUrlupdate
        ]
        APIRequest.shared().uploadUserProfile(userID: userId.toInt ?? 0, para:dict,profileImgName:profileImgUrlupdate ) { (response, error) in
            if response != nil && error == nil {
                completion(true)
            }
        }
    }
    
    
}
