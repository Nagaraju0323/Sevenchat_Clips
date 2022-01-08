
//
//  RegisterViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 08/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//


/*********************************************************
 * Author : Chandrika.R                                 *
 * Model   : RegisterUserName action sheet             *
 * Changes   :                                          *
 ********************************************************/

import UIKit
import CoreLocation
//import GooglePlacePicker
import ActiveLabel



class RegisterViewController: ParentViewController {
    
    @IBOutlet weak var btnSingUp : UIButton!
    @IBOutlet weak var btnUploadImage : UIButton!
    @IBOutlet weak var imgUser : UIImageView!
    @IBOutlet weak var imgEditIcon : UIImageView!
    //@IBOutlet weak var viewLocation : UIView!
    @IBOutlet weak var viewContainer : UIView!
    
    @IBOutlet weak var txtFirstName : MIGenericTextFiled!
    @IBOutlet weak var txtLastName : MIGenericTextFiled!
    @IBOutlet weak var txtEmail : MIGenericTextFiled!
    @IBOutlet weak var txtPWD : MIGenericTextFiled!
    @IBOutlet weak var txtConfirmPWD : MIGenericTextFiled!
    @IBOutlet weak var txtMobileNumber : MIGenericTextFiled!
    //@IBOutlet weak var txtLocation : MIGenericTextFiled!
    @IBOutlet weak var txtCountryCode : MIGenericTextFiled!
    @IBOutlet weak var txtGender : MIGenericTextFiled!
    @IBOutlet weak var txtDob : MIGenericTextFiled!
    @IBOutlet weak var lblCode : UILabel!
    
    @IBOutlet weak var lblTermsAndCondition : ActiveLabel!
    
    @IBOutlet weak var txtCountrys : MIGenericTextFiled!
    @IBOutlet weak var txtStates : MIGenericTextFiled!
    @IBOutlet weak var txtCitys : MIGenericTextFiled!
    
    var countryID : Int?
    var stateID : Int?
    var cityID : Int?
    
    var countryName:String?
    var stateName : String?
    var cityName : String?
    
    var countryCodeId = "91" //India
    var latitude : Double = 0.0
    var longitude : Double = 0.0
    var dictSocial : [String : AnyObject]? = [:]
    var dictSinup : [String : Any]? = [:]
    var isSocialSignup : Bool = false
    var imgName = ""
    var profileImgUrl = ""
    var defaultprofileImgUrl = ""
    var profileImgUrlupdate = ""
    var profileImage:UIImage?
    
    
    var apiTask : URLSessionTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Initialization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setLanguageText()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- --------- Initialization
    func Initialization(){
        txtPWD.txtDelegate = self
        txtConfirmPWD.txtDelegate = self
        txtMobileNumber.txtDelegate = self
        if isSocialSignup {
            self.txtPWD.hide(byHeight: true)
            self.txtConfirmPWD.hide(byHeight: true)
            _ = txtEmail.setConstraintConstant(0, edge: .bottom, ancestor: true)
            _ = txtMobileNumber.setConstraintConstant(0, edge: .top, ancestor: true)
            
            GCDMainThread.async {
                //Prefilled social detail
                if !(self.dictSocial?.valueForString(key: CFirstname).isBlank)! {
                    self.txtFirstName.text = self.dictSocial?.valueForString(key: CFirstname) ?? ""
                    self.txtFirstName.updatePlaceholderFrame(true)
                }
                if !(self.dictSocial?.valueForString(key: CLastname).isBlank)! {
                    self.txtLastName.text = self.dictSocial?.valueForString(key: CLastname) ?? ""
                    self.txtLastName.updatePlaceholderFrame(true)
                }
                if !(self.dictSocial?.valueForString(key: CEmail).isBlank)! {
                    self.txtEmail.text = self.dictSocial?.valueForString(key: CEmail) ?? ""
                    self.txtEmail.updatePlaceholderFrame(true)
                }
            }
        }
        
        btnSingUp.layer.cornerRadius = 5
        imgUser.layer.cornerRadius = imgUser.frame.size.width / 2
        txtDob.setMaximumDate(maxDate: Date().dateByAdd(years: -16))
        txtDob.setDatePickerMode(mode: .date)
        //txtDob.text = txtDob.datePickerDateFormatter?.string(from: txtDob.)
        txtDob.setDatePickerWithDateFormate(dateFormate: "dd MMM yyyy", defaultDate: Date(), isPrefilledDate: false) { (date) in
        }
        configTermsAndConditionLabel()
        self.loadCountryCodeList()
        self.loadCountryList()
        
        guard let mobileNum = appDelegate.loginUser?.mobile else {return}
        
        MInioimageupload.shared().uploadMinioimages(mobileNo: mobileNum, ImageSTt: #imageLiteral(resourceName: "ic_sidemenu_normal_profile"),isFrom:"",uploadFrom:"")
        MInioimageupload.shared().callback = { message in
            print("UploadImage::::::::::::::\(message)")
            self.defaultprofileImgUrl = message
        }
        
    }
    
    func setLanguageText() {
        
        self.title = CRegisterTitle
        
        txtFirstName.placeHolder = CRegisterPlaceholderFirstName
        txtLastName.placeHolder = CRegisterPlaceholderLastName
        txtEmail.placeHolder = CRegisterPlaceholderEmail
        txtPWD.placeHolder = CRegisterPlaceholderPassword
        txtConfirmPWD.placeHolder = CRegisterPlaceholderConfirmPassword
        txtMobileNumber.placeHolder = CRegisterPlaceholderMobileNumber
        txtGender.placeHolder = CRegisterPlaceholderGender
        txtDob.placeHolder = CRegisterPlaceholderDob
        //txtLocation.placeholder = CRegisterPlaceholderSelectLocation
        lblCode.text = CRegisterPlaceholderCode
        btnSingUp.setTitle(CRegisterSignup, for: .normal)
        
        txtGender.setPickerData(arrPickerData: [CRegisterGenderMale, CRegisterGenderFemale ,CRegisterGenderOther], selectedPickerDataHandler: { (text, row, component) in
        }, defaultPlaceholder: "")
        
        txtCountrys.placeHolder = CCountryPlaceholder
        txtStates.placeHolder = CStatePlaceholder
        txtCitys.placeHolder = CCityPlaceholder
    }
    
    fileprivate func configTermsAndConditionLabel(){
        
        lblTermsAndCondition.configureLinkAttribute = { [weak self](type, attributes, isSelected) in
            guard let self = self else { return attributes}
            var attributes = attributes
            attributes[NSAttributedString.Key.font] = CFontPoppins(size: self.lblTermsAndCondition.font.pointSize, type: .meduim)
            return attributes
        }
        
        let customType1 = ActiveType.custom(pattern: "(\\s\(CSettingTermsAndConditions)\\b)|(\\s\(CSettingPrivacyPolicy)\\b)")
        lblTermsAndCondition.enabledTypes = [customType1]
        lblTermsAndCondition.customColor[customType1] = UIColor(hex: "a1b975") //.blue
        
        lblTermsAndCondition.text = CTermsAndConditionsText
        
        lblTermsAndCondition.handleCustomTap(for: customType1) { [weak self] (custom) in
            
            guard let self = self else {return}
            GCDMainThread.async {
                if custom == CSettingTermsAndConditions{
                    print(CSettingTermsAndConditions)
                    let cmsVC : AboutUsViewController = CStoryboardGeneral.instantiateViewController(withIdentifier: "AboutUsViewController") as! AboutUsViewController
                    cmsVC.cmsType = .termsAndConditions
                    self.navigationController?.pushViewController(cmsVC, animated: true)
                    
                }else if custom == CSettingPrivacyPolicy{
                    print(CSettingPrivacyPolicy)
                    let cmsVC : AboutUsViewController = CStoryboardGeneral.instantiateViewController(withIdentifier: "AboutUsViewController") as! AboutUsViewController
                    cmsVC.cmsType = .privacyPolicy
                    self.navigationController?.pushViewController(cmsVC, animated: true)
                }
            }
        }
    }
}

//MARK:- Manage Country, State and City
extension RegisterViewController {
    func loadCountryCodeList(){
        let arrCountry = TblCountry.fetch(predicate: nil, orderBy: CCountryName, ascending: true)
        let arrCountryCode = arrCountry?.value(forKeyPath: "country_name") as? [Any]
        if (arrCountryCode?.count)! > 0 {
            txtCountryCode.setPickerData(arrPickerData: arrCountryCode!, selectedPickerDataHandler: { (select, index, component) in
                let dict = arrCountry![index] as AnyObject
                self.txtCountryCode.text = dict.value(forKey: CCountrycode) as? String
                //Oldcode by Mi
                /*self.countryCodeId = dict.value(forKey: CCountry_id) as? Int ?? 0*/
                self.countryCodeId = dict.value(forKey: CCountryName) as! String
            }, defaultPlaceholder: "+91")
        }
    }
    
    fileprivate func loadCountryList(){
        
        self.txtCountrys.isEnabled = true
        self.txtStates.isEnabled = false
        self.txtCitys.isEnabled = false
        
        self.showHideCountryStateCityFileds()
        
        let arrCountryList = TblCountry.fetch(predicate: NSPredicate(format:"country_code = %@", "+91"))
        
        if (arrCountryList?.count ?? 0) > 0{
            self.txtCountryCode.text = ((arrCountryList![0] as! TblCountry).country_code)
            self.countryID = Int(((arrCountryList![0] as! TblCountry).country_id))
            self.countryName = (arrCountryList![0] as! TblCountry).country_name
            
        }
        
        
        let arrCountry = TblCountry.fetch(predicate: nil, orderBy: CCountryName, ascending: true)
        let arrCountryCode = arrCountry?.value(forKeyPath: "country_name") as? [Any]
        
        if (arrCountryCode?.count)! > 0 {
            
            txtCountrys.setPickerData(arrPickerData: arrCountryCode!, selectedPickerDataHandler: { [weak self] (select, index, component) in
                guard let self = self else { return }
                let dict = arrCountry![index] as AnyObject
                let countryName = dict.value(forKey: CCountryName) as? String
                if countryName != self.countryName {
                    self.countryName = dict.value(forKey: CCountryName) as? String
                    self.txtStates.text = ""
                    self.txtCitys.text = ""
                    self.stateID = nil
                    self.cityID = nil
                    self.txtStates.isEnabled = false
                    self.txtCitys.isEnabled = false
                    self.showHideCountryStateCityFileds()
                    self.loadStateList()
                }
            }, defaultPlaceholder: "")
        }
    }
    
    fileprivate func loadStateList(isCancelTask:Bool = true) {
        
        func setStateList(arrState:[MDLState]){
            let states = arrState.compactMap({$0.stateName})
            self.txtStates.setPickerData(arrPickerData: states as [Any], selectedPickerDataHandler: { [weak self](text, row, component) in
                guard let self = self else {return}
                
                if arrState[row].stateName != self.stateName{
                    self.stateName = arrState[row].stateName
                    self.txtCitys.isEnabled = false
                    self.txtCitys.text = ""
                    self.showHideCountryStateCityFileds()
                    self.loadCityList()
                }
                
            }, defaultPlaceholder: "")
        }
        if apiTask?.state == URLSessionTask.State.running && isCancelTask {
            apiTask?.cancel()
        }
        //...Load country list from server
        let timestamp : TimeInterval = 0
        
        apiTask = APIRequest.shared().stateList(timestamp: timestamp as AnyObject, countryID: self.countryName ?? "") { [weak self] (response, error) in
            guard let self = self else {return}
            if response != nil && error == nil {
                DispatchQueue.main.async {
                    let arrData = response![CData] as? [[String : Any]] ?? []
                    var arrState : [MDLState] = []
                    for obj in arrData{
                        arrState.append(MDLState(fromDictionary: obj))
                    }
                    if arrState.isEmpty{
                        arrState.append(MDLState(fromDictionary: ["state_name":" "]))
                        self.stateID = 0
                        self.cityID = 0
                        self.txtStates.isEnabled = false
                        self.txtCitys.isEnabled = false
                        self.txtStates.text = ""
                        self.txtCitys.text = ""
                    }else{
                        self.txtStates.isEnabled = true
                    }
                    self.showHideCountryStateCityFileds()
                    setStateList(arrState: arrState)
                }
            }
        }
    }
    
    fileprivate func loadCityList(isCancelTask:Bool = true) {
        
        func setCityList(arrCity:[MDLCity]){
            let states = arrCity.compactMap({$0.cityName})
            self.txtCitys.setPickerData(arrPickerData: states as [Any], selectedPickerDataHandler: { [weak self](text, row, component) in
                guard let self = self else {return}
                /*Oldcode by Mi
                 self.cityID = arrCity[row].cityId
                 */
                self.cityName = arrCity[row].cityName
                //self.showHideCountryStateCityFileds()
            }, defaultPlaceholder: "")
        }
        if apiTask?.state == URLSessionTask.State.running && isCancelTask {
            apiTask?.cancel()
        }
        //...Load country list from server
        let timestamp : TimeInterval = 0
        apiTask = APIRequest.shared().cityList(timestamp: timestamp as AnyObject, stateId: self.stateName ?? "") { [weak self] (response, error) in
            guard let self = self else {return}
            if response != nil && error == nil {
                DispatchQueue.main.async {
                    let arrData = response![CData] as? [[String : Any]] ?? []
                    var arrCity : [MDLCity] = []
                    for obj in arrData{
                        arrCity.append(MDLCity(fromDictionary: obj))
                    }
                    if arrCity.isEmpty{
                        arrCity.append(MDLCity(fromDictionary: ["city_name":" "]))
                        self.cityID = 0
                        self.txtCitys.isEnabled = false
                        self.txtCitys.text = ""
                    }else{
                        self.txtCitys.isEnabled = true
                    }
                    self.showHideCountryStateCityFileds()
                    setCityList(arrCity: arrCity)
                }
            }
        }
    }
    
    fileprivate func showHideCountryStateCityFileds(){
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, animations: {
                if !self.txtStates.isEnabled{
                    self.txtStates.superview?.alpha = 0
                }else{
                    self.txtStates.superview?.alpha = 1
                }
                if !self.txtCitys.isEnabled{
                    self.txtCitys.superview?.alpha = 0
                }else{
                    self.txtCitys.superview?.alpha = 1
                }
            }, completion: { (_) in
                self.txtStates.superview?.isHidden = !self.txtStates.isEnabled
                self.txtCitys.superview?.isHidden = !self.txtCitys.isEnabled
            })
        }
    }
}


// MARK:- --------- API
extension RegisterViewController {
    
    func signup(){
        var gender = 1
        if txtGender.text == "Male" {
            gender = CMale
        } else if txtGender.text == "Female" {
            gender = CFemale
        } else {
            gender = COther
        }
        
        if imgUser.image == nil{
            profileImgUrlupdate = defaultprofileImgUrl
        }else {
            profileImgUrlupdate = profileImgUrl
        }
        let dobconvert = DateFormatter.shared().convertDatereversSinup(strDate: txtDob.text)
        let FirstName = txtFirstName.text ?? ""
        let LastName = txtLastName.text ?? ""
        let Emailtext = txtEmail.text ?? ""
        let Password = txtPWD.text ?? ""
        let CityName = txtCitys.text ?? ""
        let MobileNumber = txtMobileNumber.text ?? ""
        let Gender = String(gender)
        let dobirth = dobconvert ?? ""
        let verificationmail = txtEmail.text ?? ""
        let CountryName = txtCountrys.text ?? ""
        
        let dict : [String : Any] = [
            "user_acc_type":0,
            CFirstname:FirstName,
            CLastname:LastName,
            "email":Emailtext,
            "password":Password,
            "city_name":CityName,
            "profile_image":profileImgUrlupdate,
            "mobile":MobileNumber,
            "gender":Gender,
            "dob":dobirth,
            "short_biography":"",
            "relationship":"",
            "profession":"",
            "address_line1":"",
            "latitude":(MILocationManager.shared().currentLocation?.coordinate.latitude ?? 0.0),
            "longitude":(MILocationManager.shared().currentLocation?.coordinate.longitude ?? 0.0),
            "users_type":1,
            "lang_name":CUserDefaults.object(forKey: UserDefaultSelectedLang) as Any,
            "social_id":"",
            "verification_mail":verificationmail,
            "country_name":CountryName,
            "religion":""
        ] as [String : Any]
        
        dictSinup = dict
    }

    func uploadUserProfile(userID : Int, signUpResponse : AnyObject?,imageEmpty:Bool) {
        if imageEmpty == true{
            print("image empty convert text to image")
        }else {
            let dict : [String : Any] =  [
                "user_id":userID,
                "profile_image":profileImgUrlupdate
            ]
            //Profileimage Upload Image
            APIRequest.shared().uploadUserProfile(userID: userID, para:dict,profileImgName:profileImgUrlupdate) { (response, error) in
                if response != nil && error == nil {
                    print("message::::::::::::::uploadprifileimage")
                }
            }
        }
    }
    
    func redirectToVerificationScreen() {
        MILoader.shared.hideLoader()
        CUserDefaults.set(true, forKey: UserDefaultIsAppLaunchHere)
        CUserDefaults.synchronize()
        
        let alert = UIAlertController(title: "", message: "Sinup Verfication Code", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Singup With EmailID", style: .default, handler: { (_) in
            self.verifyEmail()
        }))
        
        alert.addAction(UIAlertAction(title: "Singup With MobileNumber", style: .default, handler: { (_) in
            self.verifyMobile()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (_) in
            print("You've pressed the destructive")
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
}

// MARK:- --------- Action Event
extension RegisterViewController{
    
    @IBAction func btnSelectLocationCLK(_ sender : UIButton){
        
        guard let locationPicker = CStoryboardLocationPicker.instantiateViewController(withIdentifier: "LocationPickerVC") as? LocationPickerVC else {
            return
        }
        locationPicker.completion = { [weak self] (placeDetail) in
            guard let self = self else { return }
            //self.txtLocation.text = placeDetail?.formattedAddress
            self.latitude = placeDetail?.coordinate?.latitude ?? 0.0
            self.longitude = placeDetail?.coordinate?.longitude ?? 0.0
        }
        self.navigationController?.pushViewController(locationPicker, animated: true)
    }
    
    @IBAction func btnUploadImageCLK(_ sender : UIButton) {
        guard let mobileNo = self.txtMobileNumber.text else {return}
        if self.imgUser.image != nil {
            
            self.presentActionsheetWithThreeButton(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CRegisterChooseFromPhone, btnOneStyle: .default, btnOneTapped: { (action) in
                
                self.presentImagePickerControllerForGallery(imagePickerControllerCompletionHandler: { (image, info) in
                    if image != nil{
                        self.imgEditIcon.isHidden = false
                        self.imgUser.image = image
                        MInioimageupload.shared().uploadMinioimages(mobileNo: mobileNo, ImageSTt: image!,isFrom:"",uploadFrom:"")
                        MInioimageupload.shared().callback = { message in
                            print("message::::::::::::::\(message)")
                            self.profileImgUrl = message
                        }
                    }
                })
                
            }, btnTwoTitle: CRegisterTakePhoto, btnTwoStyle: .default, btnTwoTapped: { (action) in
                self.presentImagePickerControllerForCamera(imagePickerControllerCompletionHandler: { (image, info) in
                    if image != nil{
                        self.imgEditIcon.isHidden = false
                        self.imgUser.image = image
                        MInioimageupload.shared().uploadMinioimages(mobileNo: mobileNo, ImageSTt: image!,isFrom:"",uploadFrom:"")
                        MInioimageupload.shared().callback = { message in
                            print("message::::::::::::::\(message)")
                            self.profileImgUrl = message
                        }
                        
                    }
                })
            }, btnThreeTitle: CRegisterRemovePhoto, btnThreeStyle: .default) { (action) in
                self.imgUser.image = nil
                self.imgEditIcon.isHidden = true
            }
            
        } else {
            
            self.presentImagePickerController(allowEditing: true) { [self] (image, info) in
                if image != nil{
                    self.imgEditIcon.isHidden = false
                    self.imgUser.image = image
                    MInioimageupload.shared().uploadMinioimages(mobileNo: mobileNo, ImageSTt: image!,isFrom:"",uploadFrom:"")
                    MInioimageupload.shared().callback = { message in
                        print("message::::::::::::::\(message)")
                        self.profileImgUrl = message
                    }
                }
            }
        }
        
    }
    
    @IBAction func btnSignUpCLK(_ sender : UIButton){
        
        self.resignKeyboard()
        
        if (txtFirstName.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CRegisterAlertFirstNameBlank, btnOneTitle: CBtnOk, btnOneTapped: nil)
            return
        }
        if (txtLastName.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CRegisterAlertLastNameBlank, btnOneTitle: CBtnOk, btnOneTapped: nil)
            return
        }
        if (txtEmail.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CRegisterAlertEmailBlank, btnOneTitle: CBtnOk, btnOneTapped: nil)
            return
        }
        if !(txtEmail.text?.isValidEmail)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CRegisterAlertValidEmail, btnOneTitle: CBtnOk, btnOneTapped: nil)
            return
        }
        if !isSocialSignup && (txtPWD.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CRegisterAlertPasswordBlank, btnOneTitle: CBtnOk, btnOneTapped: nil)
            return
        }
        /*if !isSocialSignup && (!(txtPWD.text?.isValidPassword)! || (txtPWD.text?.count)! < 8  || !(txtPWD.text?.isPasswordSpecialCharacterValid)!){
         self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CRegisterPasswordMinLimit, btnOneTitle: CBtnOk, btnOneTapped: nil)
         return
         }*/
        if !isSocialSignup && !(txtPWD.text?.isValidPassword ?? false) {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CRegisterPasswordMinLimit, btnOneTitle: CBtnOk, btnOneTapped: nil)
            return
        }
        if !isSocialSignup && (txtConfirmPWD.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CRegisterAlertConfirmPasswordBlank, btnOneTitle: CBtnOk, btnOneTapped: nil)
            return
        }
        if !isSocialSignup && txtPWD.text != txtConfirmPWD.text{
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CRegisterAlertPasswordConfirmPasswordNotMatch, btnOneTitle: CBtnOk, btnOneTapped: nil)
            return
        }
        if (txtCountryCode.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CRegisterAlertCountryCodeBlank, btnOneTitle: CBtnOk, btnOneTapped: nil)
            return
        }
        if (txtMobileNumber.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CRegisterAlertMobileNumberBlank, btnOneTitle: CBtnOk, btnOneTapped: nil)
            return
        }
        if !(self.txtMobileNumber.text?.isValidPhoneNo)! || ((self.txtMobileNumber.text?.count)! > 10 || (self.txtMobileNumber.text?.count)! < 6) {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CRegisterAlertValidMobileNumber, btnOneTitle: CBtnOk, btnOneTapped: nil)
            return
        }
        if (txtGender.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CRegisterAlertGenderBlank, btnOneTitle: CBtnOk, btnOneTapped: nil)
            return
        }
        if (txtDob.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CRegisterAlertDobBlank, btnOneTitle: CBtnOk, btnOneTapped: nil)
            return
        }
        let comfirmationMessage = CRegisterAlertConfirmedEmailMobile + "\n" + txtEmail.text! + "\n" + txtMobileNumber.text!
        self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: comfirmationMessage, btnOneTitle: CBtnConfirm, btnOneTapped: { (alert) in
            
            MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: CMessagePleaseWait)
            self.signup()
            self.redirectToVerificationScreen()
            
            
        }, btnTwoTitle: CBtnCancel, btnTwoTapped: nil)
    }
    
}

// MARK:- -------- UITextFieldDelegate
extension RegisterViewController: GenericTextFieldDelegate {
    
    @objc func genericTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtMobileNumber{
            if textField.text?.count ?? 0 >= 15{
                return false
            }
        }else if textField == txtPWD || textField == txtConfirmPWD{
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

//MARK :- API CALL

extension RegisterViewController{
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
    
    func verifyEmail() {
        let api  = CAPITagverifyEmailOTP
        APIRequest.shared().verifyEmail(api: api,email : txtEmail.text ?? "", verifyCode: txtEmail.text!) { (response, error) in
            if response != nil && error == nil{
                
                    if let objVerify = CStoryboardLRF.instantiateViewController(withIdentifier: "VerifyEmailMobileViewController") as? VerifyEmailMobileViewController{
                        objVerify.userEmail = self.txtEmail.text ?? ""
                        objVerify.passwordStr = self.txtPWD.text ?? ""
                        objVerify.isEmail_Mobile = true
                        objVerify.dictSingupdatas = self.dictSinup ?? [:]
                        objVerify.userMobile = self.txtMobileNumber.text ?? ""
                        self.navigationController?.pushViewController(objVerify, animated: true)
                    }
//                }
            }else {
                guard  let errorUserinfo = error?.userInfo["error"] as? String else {return}
                let errorMsg = errorUserinfo.stringAfter(":")
                self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: errorMsg, btnOneTitle: CBtnOk, btnOneTapped: nil)
            }
        }
    }
    
    
    func verifyMobile() {
        let api = CAPITagVerifyMobile
        APIRequest.shared().verifyMobile(api : api, email : txtEmail.text ?? "", mobile: txtMobileNumber.text ?? "") { (response, error) in
            if response != nil && error == nil{
                if let objVerify = CStoryboardLRF.instantiateViewController(withIdentifier: "VerifyEmailMobileViewController") as? VerifyEmailMobileViewController{
                    objVerify.userEmail = self.txtEmail.text ?? ""
                    objVerify.isEmail_Mobile = false
                    objVerify.dictSingupdatas = self.dictSinup ?? [:]
                    objVerify.userMobile = self.txtMobileNumber.text ?? ""
                    objVerify.passwordStr = self.txtPWD.text ?? ""
                    self.navigationController?.pushViewController(objVerify, animated: true)
                }
                
                if let responseData = response?.value(forKey: CJsonData) as? [String : AnyObject] {
                    let step = responseData.valueForInt(key: "step") ?? 0
                }
            }else {
                
                guard  let errorUserinfo = error?.userInfo["error"] as? String else {return}
                let errorMsg = errorUserinfo.stringAfter(":")
                self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: errorMsg, btnOneTitle: CBtnOk, btnOneTapped: nil)
            }
        }
    }
    
}


