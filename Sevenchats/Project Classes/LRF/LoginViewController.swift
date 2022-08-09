//
//  LoginViewController.swift
//  Social Media
//
//  Created by mac-0005 on 06/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Nagaraju K and Chandrika R                  *
 * Model   : LoginViewController                         *
 * Changes :                                             *
 * Login With Mobile Number (or) Emaild ID               *
 *                                                       *
 *                                                       *
 ********************************************************/

import UIKit
import GoogleSignIn
import AuthenticationServices
import Alamofire

class LoginViewController: ParentViewController {
    
    @IBOutlet var txtEmail : MIGenericTextFiled!
    @IBOutlet var txtPWD : MIGenericTextFiled!
    @IBOutlet var txtCountryCode : MIGenericTextFiled!
    @IBOutlet var btnSignIn : UIButton!
    @IBOutlet var btnForgotPWD : UIButton!
    @IBOutlet var scrollViewContainer : UIView!
    @IBOutlet var lblSignUp : UILabel!
    @IBOutlet var lblSocialogin : UILabel!
    @IBOutlet var cnTxtEmailLeading : NSLayoutConstraint!
    @IBOutlet weak var socialStackView: UIStackView!
    @IBOutlet weak var btnSignUpButton: UIButton!
    
    var isEmailMobile = false
    var country_id = 356
    var CWebSiteLink = ""
    var isLogindone:Bool?
    var userID:String?
    var profileImgUrlupdate:String?
    var categoryID = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Initialization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateUIAccordingToLanguage()
        socialStackView.isHidden = true
      //  btnSignUpButton.isHidden = true
       // lblSignUp.isHidden = true
        lblSocialogin.isUserInteractionEnabled = true
//        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.btnSignupCLK_lbl))
//        lblSocialogin.addGestureRecognizer(tap)
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- -------------Initialization
    func Initialization(){
        
      
        
        btnSignIn.layer.cornerRadius = 5
        btnSignUpButton.layer.cornerRadius = 5
        txtCountryCode.text = "--"
        self.loadCountryList()
        GCDMainThread.async {
            self.txtCountryCode.updatePlaceholderFrame(true)
        }
        AppUpdateManager.shared.checkForUpdate()
    }
    
    func setAttributedString() {
        
        let attrs = [NSAttributedString.Key.font : CFontPoppins(size: lblSignUp.font.pointSize, type: .light),
                     NSAttributedString.Key.foregroundColor: UIColor.black]
        let attrs1 = [NSAttributedString.Key.font : CFontPoppins(size: lblSignUp.font.pointSize, type: .light),
                      NSAttributedString.Key.foregroundColor: CRGB(r: 33, g: 191, b: 166)]
        let attributedString = NSMutableAttributedString(string: CLoginDontHaveAccount, attributes:attrs)
        let normalString = NSMutableAttributedString(string: " \(CRegisterSignup)", attributes:attrs1)
      //  attributedString.append(normalString)
        lblSocialogin.attributedText = attributedString
    }
    
    func updateUIAccordingToLanguage() {
        self.setAttributedString()
        
        txtEmail.placeHolder = CLoginPlaceholderEmailMobile
        txtPWD.placeHolder = CLoginPlaceholderPassword
        btnForgotPWD.setTitle(CLoginBtnForgot, for: .normal)
        btnSignIn.setTitle(CLoginBtnSignIn, for: .normal)
        if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
            // Reverse Flow...
            btnForgotPWD.contentHorizontalAlignment = .left
        }else{
            // Normal Flow...
            btnForgotPWD.contentHorizontalAlignment = .right
        }
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
                self.country_id = dict.value(forKey: CCountry_id) as? Int ?? 0
            }, defaultPlaceholder: "")
        }
    }
}

// MARK:- -------------Socail Action
extension LoginViewController:GenericTextFieldDelegate{
    
    func genericTextFieldClearText(_ textField: UITextField){
        if textField == txtEmail{
            cnTxtEmailLeading.constant = 20
            txtCountryCode.isHidden = true
            self.view.layoutIfNeeded()
            GCDMainThread.async {
                self.txtEmail.updateBottomLineAndPlaceholderFrame()
            }
        }
    }
    
    func genericTextFieldDidChange(_ textField : UITextField){
        if textField == txtEmail{
            if (txtEmail.text?.isValidPhoneNo)! && !(txtEmail.text?.isBlank)!{
               
                cnTxtEmailLeading.constant = txtCountryCode.bounds.width + 30
                txtCountryCode.isHidden = false
            }else{
                cnTxtEmailLeading.constant = 20
                txtCountryCode.isHidden = true
            }
            self.view.layoutIfNeeded()
            
            GCDMainThread.async {
                self.txtEmail.updateBottomLineAndPlaceholderFrame()
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
              //  cnTxtEmailLeading.constant = 20
                txtCountryCode.isHidden = false
            }else{
                cnTxtEmailLeading.constant = 20
                txtCountryCode.isHidden = true
            }
            self.view.layoutIfNeeded()
            
            GCDMainThread.async {
                self.txtEmail.updateBottomLineAndPlaceholderFrame()
            }
            return true
        }
        if textField == txtEmail{
            if updatedText.isValidPhoneNo && !updatedText.isBlank{
                if textField.text?.count ?? 0 >= 15{
                    return false
                }
                cnTxtEmailLeading.constant = txtCountryCode.bounds.width + 30
               // cnTxtEmailLeading.constant = 20
                txtCountryCode.isHidden = false
            }else{
                cnTxtEmailLeading.constant = 20
                txtCountryCode.isHidden = true
            }
            self.view.layoutIfNeeded()
            
            GCDMainThread.async {
                self.txtEmail.updateBottomLineAndPlaceholderFrame()
            }
        }
        return true
        
    }
    
    func genericTextField(_ textField: UITextField, shouldChangeCharactersInForEmpty range: NSRange, replacementString string: String) -> Bool {
        return self.genericTextField(textField, shouldChangeCharactersIn: range, replacementString: string)
    }
}


// MARK:- -------------Socail Action
extension LoginViewController{
    func facebookLogin(){
        
        MISocial.shared().signUpWithFacebook(fromVC: self) { (userInfo, error) in
            if error != nil {
                self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: error?.localizedDescription, btnOneTitle: CBtnOk, btnOneTapped: nil)
            } else if userInfo != nil {
                
                if let userInfo = userInfo as? NSDictionary {
                    
                    let dict = [CSocialid : userInfo.value(forKey: "id") as? String ?? "",
                                   CEmail : userInfo.value(forKey: "email") as? String ?? "",
                              CAccounttype: CFacebook,
                               CFirstname : userInfo.value(forKey: "first_name") as? String ?? "",
                                CLastname : userInfo.value(forKey: "last_name") as? String ?? ""
                    ] as [String : Any]
                    
                    self.socialLogin(dict: dict as [String : AnyObject])
                }
            }
        }
    }
    
    func twiterLogin(){
        
        self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CFeatureNotAvailable, btnOneTitle: CBtnOk, btnOneTapped: nil)
        
    }
    
    func appleLogin(){
        
        MISocial.shared().signUpWithApple(fromVC: self) { (userInfo, error) in
            if error != nil {
                self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: error?.localizedDescription, btnOneTitle: CBtnOk, btnOneTapped: nil)
            } else if userInfo != nil {
                
                if #available(iOS 13.0, *) {
                    if let userInfo = userInfo as? ASAuthorizationAppleIDCredential {
                        
                        let email = String(describing: userInfo.email ?? "")
                        //                        let fullName = String(describing: userInfo.fullName ?? "")
                        
                        let id = String(describing: userInfo.user )
                        let firstName = String(describing:userInfo.fullName?.givenName ?? "")
                        let lastName = String(describing:userInfo.fullName?.familyName ?? "" )
                        let dict = [CSocialid : id,
                                       CEmail : email,
                                  CAccounttype: CApple,
                                   CFirstname : firstName,
                                    CLastname : lastName
                        ] as [String : Any]
                        
                        
                        self.socialLogin(dict: dict as [String : AnyObject])
                    }
                } else {
                    // Fallback on earlier versions
                }
            }
        }
    }
    
    func googleLogin(){
        
        MISocial.shared().googleLogin(fromVC: self) { (info, error) in
            
            if error == nil {
                
                let dict = [CSocialid : (info as? GIDGoogleUser)?.userID ?? "",
                               CEmail : (info as? GIDGoogleUser)?.profile.email ?? "",
                          CAccounttype: CGoogle,
                           CFirstname : (info as? GIDGoogleUser)?.profile.name ?? "",
                            CLastname : (info as? GIDGoogleUser)?.profile.familyName ?? ""
                ] as [String : Any]
                
                self.socialLogin(dict: dict as [String : AnyObject])
            }
        }
    }
}
// MARK:- -------------Action Event
extension LoginViewController{
    @IBAction func btnSignInCLK(_ sender : UIButton){
        
        self.resignKeyboard()
        
        if (txtEmail.text?.isBlank)!{
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CLoginAlertEmailMobileBlank, btnOneTitle: CBtnOk, btnOneTapped: nil)
            return
        }else{
            if self.txtEmail.text?.range(of:"@") != nil || self.txtEmail.text?.rangeOfCharacter(from: CharacterSet.letters) != nil  {
                if !(self.txtEmail.text?.isValidEmail)! {
                    self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CLoginAlertValidEmail, btnOneTitle: CBtnOk , btnOneTapped: nil)
                    return
                }else {
                    self.isEmailMobile = false
                }
            }else{
                if !(self.txtEmail.text?.isValidPhoneNo)! || ((self.txtEmail.text?.count)! > 10 || (self.txtEmail.text?.count)! < 6) {
                    self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CLoginAlertValidMobileNumber, btnOneTitle: CBtnOk , btnOneTapped: nil)
                    return
                }else {
                    self.isEmailMobile = true
                }
            }
        }
        
        if (txtPWD.text?.isBlank)!{
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CLoginAlertPasswordBlank, btnOneTitle: CBtnOk , btnOneTapped: nil)
            return
        } else {
            self.loginUser()
        }
    }
    
    
    @IBAction func btnSocialCLK(_ sender : UIButton){
        switch sender.tag {
        case 0:
            // Facebook CLK
            self.facebookLogin()
            break
        case 1:
            // Twiter CLK
            self.twiterLogin()
            break
        case 2:
            // Google CLK
            self.googleLogin()
            break
        case 3:
            // Google CLK
            self.appleLogin()
            break
        default:
            break
        }
    }
    
    @IBAction func btnSignUpCLK(_ sender : UIButton){
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
            }
            .show(DemoPopupViewController2.instance())
        
//        let objSingUp = CStoryboardLRF.instantiateViewController(withIdentifier: "RegisterViewController")
//        self.navigationController?.pushViewController(objSingUp, animated: true)
    }
    
    @objc func btnSignupCLK_lbl(_ sender : UIButton){
        let objSingUp = CStoryboardLRF.instantiateViewController(withIdentifier: "RegisterViewController")
        self.navigationController?.pushViewController(objSingUp, animated: true)
    }
    
    @IBAction func btnForgotCLK(_ sender : UIButton){
        
        CWebSiteLink = "\(BASEURL_Rew)forgot_password"
        
        if UIApplication.shared.canOpenURL(URL(string: CWebSiteLink)!){
            UIApplication.shared.open(URL(string: CWebSiteLink)!, options: [:], completionHandler: nil)
        }
    }
}


// MARK:- -------------API
extension LoginViewController{
    
    func loginUser(){
        
        self.LoginWithToken(userEmailId:txtEmail.text!)
        
    }
    
    //UserDetails featch from Back
    func UserDetailsfeath(userEmailId:String,accessToken:String) {
        let encryptResult = EncryptDecrypt.shared().encryptDecryptModel(userResultStr: userEmailId ?? "")
        
        let dict:[String:Any] = [
            CEmail_Mobile : encryptResult,
        ]
        APIRequest.shared().userDetails(para: dict as [String : AnyObject],access_Token:accessToken,viewType:1) { (response, error) in
            if response != nil && error == nil {
                DispatchQueue.main.async {
                  
                    UserDefaults.standard.set(userEmailId, forKey: "email")
                    self.redirectAfterLogin(response: response, socialDetail: [:])
                    
                }
            }
        }
    }
    
    
    func UserDetailsfeathMobile(userEmailId:String,accessToken:String) {
        let encryptMobile = EncryptDecrypt.shared().encryptDecryptModel(userResultStr: userEmailId)
        let dict:[String:Any] = [
            CMobile : userEmailId,
        ]
        APIRequest.shared().userDetailsMobile(para: dict as [String : AnyObject],access_Token:accessToken,viewType:1) { (response, error) in
            //        APIRequest.shared().userDetailsMobile(para: dict as [String : AnyObject]) { (response, error) in
            if response != nil && error == nil {
                
                DispatchQueue.main.async {
                    UserDefaults.standard.set(userEmailId, forKey: "mobile")
                    self.redirectAfterLogin(response: response, socialDetail: [:])
                }
            }
        }
    }
    
    
    
    func socialLogin(dict : [String : AnyObject]) {
        
        let dictParam = [
            CAccounttype : dict.valueForString(key: CAccounttype),
            CEmail : dict.valueForString(key: CEmail),
            CSocialid : dict.valueForString(key: CSocialid),
            CLatitude : MILocationManager.shared().currentLocation?.coordinate.latitude ?? 0.0,
            CLongitude : MILocationManager.shared().currentLocation?.coordinate.longitude ?? 0.0
        ] as [String : Any]
        
    }
    
    func redirectAfterLogin(response : AnyObject?, socialDetail : [String : AnyObject]) {
        //...Load Common api
        MIGeneralsAPI.shared().fetchAllGeneralDataFromServer()
        
        
        self.getRewardPointsConfigID()
        
        
        let responseData = response?.value(forKey: CJsonData) as? [String : AnyObject]
        
        if let metaData = response?.value(forKey: CJsonMeta) as? [String : AnyObject] {
            
            if metaData.valueForInt(key: CJsonStatus) ==  CStatusTen {
                //...If user not logged in that time user will be redirect on signup screen
                
                if let objSingUp = CStoryboardLRF.instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController {
                    
                    objSingUp.dictSocial = socialDetail
                    objSingUp.isSocialSignup = true
                    self.navigationController?.pushViewController(objSingUp, animated: true)
                }
                
            } else if metaData.valueForInt(key: CJsonStatus) == CStatusFour {
                //...Email or mobile number is not verified
                self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: metaData.valueForString(key: CJsonMessage), btnOneTitle: CBtnOk, btnOneTapped: { (action) in
                    if let objVerify = CStoryboardLRF.instantiateViewController(withIdentifier: "VerifyEmailMobileViewController") as? VerifyEmailMobileViewController{
                        print("Social Login Response :  \(responseData ?? [:])")
                        if responseData?.valueForInt(key: CIs_email_verify) == 0 {
                            objVerify.isEmailVerify = true
                        } else {
                        }
                        
                        objVerify.dict =  [
                            CEmail : responseData?.valueForString(key: CEmail) as AnyObject,
                            CMobile : responseData?.valueForString(key: CMobile) as AnyObject,
                            CCountry_id : responseData?.valueForInt(key: CCountry_id) as AnyObject
                        ]
                        
                        self.navigationController?.pushViewController(objVerify, animated: true)
                    }
                })
            } else {

                UserDefaults.standard.removeObject(forKey: "ProfileImg")
                appDelegate.initHomeViewController()
            }
        }
    }
    
    func LoginWithToken(userEmailId:String){
        
//        let encryptResult = EncryptDecrypt.shared().encryptDecryptModel(userResultStr: "EnterEncryptString")
        
        
        
//        let encryptResult = EncryptDecrypt.shared().encryptDecryptModel(userResultStr: txtPWD.text ?? "" )
        
        MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        
        let txtEmailid = txtEmail.text?.lowercased()
        let data : Data = "username=\(txtEmailid?.description ?? "")&password=\(txtPWD.text ?? "")&grant_type=password&client_id=null&client_secret=null".data(using: .utf8)!
        let url = URL(string: "\(BASEAUTHLOGIN)auth/login")
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
            DispatchQueue.main.async { [self] in
                guard let responseData = data else {
                    print("Error: did not receive data")
                    return
                }
                _ = JSONDecoder()
                let token_type = (String(data: responseData, encoding: .utf8))
                do {
                    let dict = try self.convertStringToDictionary(text: token_type ?? "")
                    guard let usertoken = dict?["token_type"] as? String else { return  }
                    guard let access_token = dict?["access_token"] as? String else { return }
                    CUserDefaults.setValue(access_token, forKey: UserDefaultDeviceToken)
                    CUserDefaults.synchronize()
                    if self.isEmailMobile == true{
                        self.UserDetailsfeathMobile(userEmailId:userEmailId,accessToken:access_token)
                    }else {
                        self.UserDetailsfeath(userEmailId:userEmailId,accessToken:access_token)
                    }
                    
                    
                }catch let error  {
                    print("error trying to convert data to \(error)")
                }
            }
        })
        task.resume()
    }
}
extension LoginViewController{
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
                return json
            } catch {
                self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CLoginAlertUserExist , btnOneTitle: CBtnOk, btnOneTapped: nil)
                MILoader.shared.hideLoader()
                
            }
        }
        return nil
    }
    
    //...Reward Points categorys
    func getRewardPointsConfigID(){
        var dict = [String:Any]()
        guard let userID = appDelegate.loginUser?.user_id.description else { return }
        dict[CUserId] = userID
        APIRequest.shared().rewardsSummaryNew(dict:dict,showLoader: true) { [weak self] (response, error) in
            let points = response?["total_points"] as? String ?? ""
            if points.toInt == 0{
                let userPic = UserDefaults.standard.value(forKey: "prfileImageLoad")
                if userPic == nil{
                    self?.uploadWithPic(userId:userID,profileImg:userPic as? String ?? "",completion: { success in
                    })
                }else {
                    self?.uploadWithPic(userId:userID,profileImg:userPic as? String ?? "",completion: { success in
                    })
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    // your code here
                    let name = (appDelegate.loginUser?.first_name ?? "") + " " + (appDelegate.loginUser?.last_name ?? "")
                    let profileIcon = "https://stg.sevenchats.com:3443/sevenchats/ProfilePic/user_placeholder.png"
                    MIGeneralsAPI.shared().addRewardsPoints(CRegisterprofile,message:"Register_profile",type:CRegisterprofile,title:"Register profile",name:name,icon:profileIcon, detail_text: "Register_profile",target_id: 0)
                }
                
                
            }else {
                return
            }
        }
    }
    //..profileImageUpdate from Singup
    func uploadWithPic(userId:String,profileImg:String,completion:@escaping(_ success:Bool) -> Void ){
        let encryptUser = EncryptDecrypt.shared().encryptDecryptModel(userResultStr: userId.description)
            let dict : [String : Any] =  [
                "user_id":encryptUser,
                "profile_image":profileImg
            ]
        APIRequest.shared().uploadUserProfile(userID: userId.toInt ?? 0, para:dict,profileImgName:profileImgUrlupdate ?? "") { (response, error) in
                if response != nil && error == nil {
//                    CUserDefaults.removeObject(forKey: "updateProfileImg")
                    completion(true)
                }
            }
        }
    
}
