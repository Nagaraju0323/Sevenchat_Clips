//
//  EditProfileViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 29/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit
import CoreLocation
//import GooglePlacePicker
//
class EditProfileViewController: ParentViewController {
    
    @IBOutlet weak var scrollViewContainer : UIView!
    @IBOutlet weak var btnUpdate : UIButton!
    @IBOutlet weak var btnUpdateComplete : UIButton!
    @IBOutlet weak var btnUploadImage : UIButton!
    @IBOutlet weak var imgUser : UIImageView!
    @IBOutlet weak var imgEditIcon : UIImageView!
    @IBOutlet weak var imgCover : UIImageView!
    @IBOutlet weak var CoverEditIcon : UIImageView!
    @IBOutlet weak var txtFirstName : MIGenericTextFiled!
    @IBOutlet weak var txtLastName : MIGenericTextFiled!
    @IBOutlet weak var txtEmail : MIGenericTextFiled!
    @IBOutlet weak var txtMobileNumber : MIGenericTextFiled!
    @IBOutlet weak var txtCountryCode : MIGenericTextFiled!
    @IBOutlet weak var txtDOB : MIGenericTextFiled!
    @IBOutlet weak var lblCode : UILabel!
    @IBOutlet weak var txtCountrys : MIGenericTextFiled!
    @IBOutlet weak var txtStates : MIGenericTextFiled!
    @IBOutlet weak var txtCitys : MIGenericTextFiled!
    
    var countryCodeId = "91" //India
    var countryID : Int?
    var stateID : Int?
    var cityID : Int?
    var countryName : String?
    var stateName : String?
    var cityName : String?
    var latitude : Double = 0.0
    var longitude : Double = 0.0
    var uploadedImg : Bool = false
    var coverImg : Bool = false
    var dobDate = ""
    var strCity = ""
    var apiTask : URLSessionTask?
    var verificationStep = 0
    var oldFirstName = ""
    var oldLastName = ""
    var isremovedImage:Bool?
    var imgName = ""
    var profileImgUrl = ""
    var coverImgUrl = ""
    var Dob = ""
    var isSelectedprofile = false
    var isSelectedCover = false
    var prefs = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialization()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setLanguageText()
    }
    
    // MARK:- ---------- Initialization
    
    func Initialization(){
        btnUpdate.layer.cornerRadius = 5
        btnUpdateComplete.layer.cornerRadius = 5
        btnUpdateComplete.layer.borderWidth = 1
        btnUpdateComplete.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
        GCDMainThread.async {
            self.imgUser.layer.cornerRadius = self.imgUser.frame.height/2
            self.btnUploadImage.layer.cornerRadius = self.btnUploadImage.frame.size.width/2
            self.imgUser.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
            self.imgUser.layer.borderWidth = 3
        }
        txtDOB.setDatePickerMode(mode: .date)
        txtDOB.setMaximumDate(maxDate: Date().dateByAdd(years: -13))
        txtDOB.setDatePickerWithDateFormate(dateFormate: "dd MMM yyyy", defaultDate: Date(), isPrefilledDate: false) { [weak self] (date) in
            guard let self = self else { return }
            self.dobDate = DateFormatter.shared().string(fromDate: date, dateFormat: "dd MMM yyyy")
        }
        setupCuntryStateCityList()
        self.preFilledUserDetail()
    }
    
    func setLanguageText() {
        self.title = CNavEditProfile
        txtFirstName.placeHolder = CRegisterPlaceholderFirstName
        txtLastName.placeHolder = CRegisterPlaceholderLastName
        txtEmail.placeHolder = CRegisterPlaceholderEmail
        txtEmail.btnClearText.isHidden = true
        txtMobileNumber.placeHolder = CRegisterPlaceholderMobileNumber
        txtDOB.placeHolder = CRegisterPlaceholderDob
        lblCode.text = CRegisterPlaceholderCode
        btnUpdate.setTitle(CResetBtnUpdate, for: .normal)
        btnUpdateComplete.setTitle(CProfileBtnUpdateComplete, for: .normal)
        txtCountrys.placeHolder = CCountryPlaceholder
        txtStates.placeHolder = CStatePlaceholder
        txtCitys.placeHolder = CCityPlaceholder
    }
    
    fileprivate func setupCuntryStateCityList(){
        
        self.showHideCountryStateCityFileds()
        
        let arrCountrys = [["name":"India", "id":"10"]]
        txtCountrys.setPickerData(arrPickerData: arrCountrys, key: CName, selectedPickerDataHandler: {  [weak self](text, row, component) in
            guard let self = self else { return }
            let catInfo = arrCountrys[row]
            self.countryName = catInfo.valueForString(key: CCountryName)
            self.showHideCountryStateCityFileds()
        }, defaultPlaceholder: "")
    }
    
    func preFilledUserDetail (){
        
        txtEmail.isEnabled = false
        txtEmail.isUserInteractionEnabled = false
        
        txtMobileNumber.isEnabled = true
        txtMobileNumber.isUserInteractionEnabled = true
        
        txtCountryCode.isEnabled = false
        txtCountryCode.isUserInteractionEnabled = false
        
        self.loadCountryCodeList()
        self.loadCountryList()
        oldFirstName = appDelegate.loginUser?.first_name ?? ""
        oldLastName = appDelegate.loginUser?.last_name ?? ""
        txtFirstName.text = appDelegate.loginUser?.first_name
        txtLastName.text = appDelegate.loginUser?.last_name
        txtEmail.text = appDelegate.loginUser?.email
        txtMobileNumber.text = appDelegate.loginUser?.mobile
        countryName = appDelegate.loginUser?.country ?? ""
        stateName =  appDelegate.loginUser?.state ?? ""
        cityName =  appDelegate.loginUser?.city ?? ""
        
        self.loadStateList(isCancelTask: true) { [weak self] in
            self?.loadCityList(isCancelTask: true, completion: { [weak self] in
                guard let _ = self else {return}
                MILoader.shared.hideLoader()
            })
        }
        txtCountrys.text = appDelegate.loginUser?.country
        txtStates.text = appDelegate.loginUser?.state
        txtCitys.text = appDelegate.loginUser?.city
        self.txtCountrys.isEnabled = true
        self.txtStates.isEnabled = !(txtStates.text?.isEmpty ?? true)
        self.txtCitys.isEnabled = !(txtCitys.text?.isEmpty ?? true)
        let arrCountryList = TblCountry.fetch(predicate: NSPredicate(format:"country_name = %@", countryName ?? ""))
        if (arrCountryList?.count ?? 0) > 0{
            self.txtCountryCode.text = ((arrCountryList![0] as! TblCountry).country_code)
            countryCodeId = ((arrCountryList![0] as! TblCountry).country_code ?? "")
            
        }
        
        self.imgUser.image = nil
        let dobtxtAppDlg = appDelegate.loginUser?.dob?.description ?? ""
        let addTimeformat = " GMT+0000 (Coordinated Universal Time)"
        
        if dobtxtAppDlg.contains(find:" GMT+0000 (Coordinated Universal Time)"){
            self.Dob = "\(dobtxtAppDlg)"
        }else {
            self.Dob = "\(dobtxtAppDlg) \(addTimeformat)"
        }
        
        txtDOB.text = DateFormatter.shared().dateConvertUTC(fromDate: Dob)
        if appDelegate.loginUser?.profile_url != "" {
            imgUser.loadImageFromUrl((appDelegate.loginUser?.profile_url ?? ""), true)
            
            btnUploadImage.setImage(UIImage(), for: .normal)
            imgEditIcon.isHidden = false
        } else{
            imgUser.loadImageFromUrl((appDelegate.loginUser?.profile_url ?? ""), true)
            imgEditIcon.isHidden = true
        }
        if appDelegate.loginUser?.cover_image != "" {
            
            imgCover.loadImageFromUrl((appDelegate.loginUser?.cover_image ?? ""), true)
            btnUploadImage.setImage(UIImage(), for: .normal)
            imgEditIcon.isHidden = false
        } else{
            imgCover.loadImageFromUrl((appDelegate.loginUser?.cover_image ?? ""), true)
            imgEditIcon.isHidden = false
        }
        
        GCDMainThread.async {
            self.showHideCountryStateCityFileds()
            self.txtCountrys.updatePlaceholderFrame(true)
            self.txtStates.updatePlaceholderFrame(true)
            self.txtCitys.updatePlaceholderFrame(true)
            
            for txtInfo in self.scrollViewContainer.subviews{
                if let textInfo = txtInfo as? MIGenericTextFiled {
                    textInfo.updatePlaceholderFrame(true)
                    textInfo.showHideClearTextButton()
                }
            }
        }
    }
}
//MARK:- Manage Country, State and City
extension EditProfileViewController {
    
    func loadCountryCodeList(){
        
        let arrCountry = TblCountry.fetch(predicate: nil, orderBy: CCountryName, ascending: true)
        let arrCountryCode = arrCountry?.value(forKeyPath: "countryname_code") as? [Any]
        
        if (arrCountryCode?.count)! > 0 {
            txtCountryCode.setPickerData(arrPickerData: arrCountryCode!, selectedPickerDataHandler: { [weak self] (select, index, component) in
                guard let self = self else { return }
                let dict = arrCountry![index] as AnyObject
                self.txtCountryCode.text = dict.value(forKey: CCountrycode) as? String
                self.txtCountryCode.text = dict.value(forKey: CCountrycode) as? String
            }, defaultPlaceholder: "+91")
        }
    }
    
    fileprivate func loadCountryList(){
        
        self.txtCountrys.isEnabled = true
        self.txtStates.isEnabled = false
        self.txtCitys.isEnabled = false
        self.showHideCountryStateCityFileds()
        let arrCountry = TblCountry.fetch(predicate: nil, orderBy: CCountryName, ascending: true)
        let arrCountryName = arrCountry?.value(forKeyPath: "country_name") as? [Any]
        
        if (arrCountryName?.count)! > 0 {
            
            txtCountrys.setPickerData(arrPickerData: arrCountryName!, selectedPickerDataHandler: { [weak self] (select, index, component) in
                guard let self = self else { return }
                let dict = arrCountry![index] as AnyObject
                let countryID = dict.value(forKey: CCountry_id) as? Int
                if countryID != self.countryID{
                    self.countryID = dict.value(forKey: CCountry_id) as? Int
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
    
    fileprivate func loadStateList(isCancelTask:Bool = true, completion:(()->Void)? = nil) {
        
        func setStateList(arrState:[MDLState]){
            let states = arrState.compactMap({$0.stateName})
            self.txtStates.setPickerData(arrPickerData: states as [Any], selectedPickerDataHandler: { [weak self](text, row, component) in
                guard let self = self else {return}
                if arrState[row].stateId != self.stateID{
                    self.stateID = arrState[row].stateId
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
            guard let self = self else {
                return
            }
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
                        self.btnUpdate.isEnabled = true
                    }else{
                        self.txtStates.isEnabled = true
                    }
                    self.showHideCountryStateCityFileds()
                    setStateList(arrState: arrState)
                    
                    completion?()
                }
            }else {
                print(error?.localizedDescription ?? "N/A")
            }
        }
    }
    
    fileprivate func loadCityList(isCancelTask:Bool = true, completion:(()->Void)? = nil) {
        
        func setCityList(arrCity:[MDLCity]){
            let states = arrCity.compactMap({$0.cityName})
            self.txtCitys.setPickerData(arrPickerData: states as [Any], selectedPickerDataHandler: { [weak self](text, row, component) in
                guard let self = self else {return}
                self.cityID = arrCity[row].cityId
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
                    //self.btnUpdate.isEnabled = true
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
                    completion?()
                }
            }else{
                completion?()
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
//MARK:- ---------- API
extension EditProfileViewController {
    
    func editProfile() {
        
        
        guard let langName = appDelegate.loginUser?.lang_name else {return}
        guard let userID = appDelegate.loginUser?.user_id else {return}
        let dobconvert = DateFormatter.shared().convertDaterevers(strDate: txtDOB.text)
        let dobupdateUserDtls = DateFormatter.shared().convertDatereveruserDetails(strDate: txtDOB.text)
        let chgtimeFormat = "\(dobupdateUserDtls?.description ?? "" ) \(" GMT+0000 (Coordinated Universal Time)")"
        
        let dict :[String:Any]  =  [
            "user_acc_type":"1",
            "first_name":txtFirstName.text ?? "",
            "last_name":txtLastName.text ?? "",
            "gender":String(appDelegate.loginUser!.gender),
            "religion":appDelegate.loginUser?.religion ?? "",
            "city_name":txtCitys.text ?? "",
            "profile_image":appDelegate.loginUser?.profile_img ?? "",
            "cover_image":appDelegate.loginUser?.cover_image ?? "",
            "mobile":txtMobileNumber.text ?? "",
            "email":txtEmail.text ?? "",
            "dob":dobconvert ?? "",
            "short_biography":appDelegate.loginUser?.short_biography ?? "",
            "relationship":appDelegate.loginUser?.relationship ?? "",
            "profession":appDelegate.loginUser?.profession ?? "",
            "address_line1":appDelegate.loginUser?.address ?? "",
            "latitude":0,
            "longitude":0,
            "income": appDelegate.loginUser?.annual_income ?? "",
            "education":appDelegate.loginUser?.education_name ?? "",
            "user_type": "1",
            "employment_status": appDelegate.loginUser?.employment_status ?? 0,
            "lang_name": langName,
            "status_id":"1"
        ]
        
        let dictUserDetails :[String:Any]  =  [
            
            "user_acc_type":"1",
            "first_name":txtFirstName.text ?? "",
            "last_name":txtLastName.text ?? "",
            "gender":String(appDelegate.loginUser!.gender),
            "city_name":txtCitys.text ?? "",
            "country_name":txtCountrys.text ?? "",
            "state_name":txtStates.text ?? "",
            "profile_image":appDelegate.loginUser?.profile_img ?? "",
            "cover_image":appDelegate.loginUser?.cover_image ?? "",
            "mobile":txtMobileNumber.text ?? "",
            "email":txtEmail.text ?? "",
            "dob":chgtimeFormat,
            "short_biography":appDelegate.loginUser?.short_biography ?? "",
            "relationship":appDelegate.loginUser?.relationship ?? "",
            "profession":appDelegate.loginUser?.profession ?? "",
            "address_line1":appDelegate.loginUser?.address ?? "",
            "latitude":0,
            "longitude":0,
            "user_type": "1",
            "annual_income": appDelegate.loginUser?.annual_income ?? "",
            "education_name":appDelegate.loginUser?.education_name ?? "",
            "employment_status": appDelegate.loginUser?.employment_status ?? 0,
            "lang_name": langName,
            "status_id":"1",
            "user_id":userID.description,
            "religion" : appDelegate.loginUser?.religion ?? ""
            
        ]
        APIRequest.shared().editProfile(dict: dict as [String : AnyObject],para:dictUserDetails as [String:AnyObject] ,userID:userID.description, dob: chgtimeFormat) { [weak self] (response, error) in
            guard let self = self else { return }
            
            if let _response = response as? [String : AnyObject], error == nil {
                //                guard let dict = _response.valueForJSON(key: CJsonData) as? [String : AnyObject] else{
                //                    return
                //                }
                
                guard let dict = _response.valueForJSON(key: "meta") as? [String : AnyObject] else{return}
                
                self.verificationStep = dict.valueForInt(key: "step") ?? 0
                if let sideMenuVc = appDelegate.sideMenuController.leftViewController as? SideMenuViewController {
                    sideMenuVc.updateUserProfile()
                }
                if self.uploadedImg {
                    self.uploadProfilePic()
                    self.uploadCoverPic()
                } else{
                    self.registerAudioToken()
                    guard let metaData = _response.valueForJSON(key: CJsonMeta) as? [String : AnyObject] else{
                        return
                    }
                    self.redirectOnSuccess(metaData: metaData)
                    for vwController in (self.navigationController?.viewControllers)! {
                        if vwController.isKind(of: SettingViewController .classForCoder()){
                            self.navigationController?.popViewController(animated: true)
                            break
                        } else if vwController.isKind(of: MyProfileViewController .classForCoder()){
                            let profileVC = vwController as? MyProfileViewController
                            profileVC?.tblUser.reloadData()
                            self.navigationController?.popViewController(animated: true)
                            break
                        }
                    }
                }
            }
        }
    }
    
    func uploadProfilePic() {
        isSelectedprofile = true
        guard let userID = appDelegate.loginUser?.user_id else {
            return
        }
        let dict :[String:Any]  =  [
            CUserId: userID.description,
            CProfileImage: profileImgUrl
        ]
        APIRequest.shared().uploadUserProfile(userID:Int(userID),para: dict as [String : AnyObject],profileImgName: profileImgUrl) { [weak self] (response, error) in
            guard let self = self else { return }
            if let _response = response as? [String : AnyObject], error == nil {
                guard let dict = _response.valueForJSON(key: CJsonMeta) as? [String : AnyObject] else{
                    return
                }
                if let sideMenuVc = appDelegate.sideMenuController.leftViewController as? SideMenuViewController {
                    sideMenuVc.updateUserProfile()
                }
                self.redirectOnSuccess(metaData: dict)
            }
        }
    }
    
    func uploadCoverPic() {
        isSelectedCover = true
        
        guard let userID = appDelegate.loginUser?.user_id else {
            return
        }
        let dict :[String:Any]  =  [
            CUserId: userID.description,
            CCoverImage: coverImgUrl
        ]
        APIRequest.shared().uploadUserCover(dict: dict as [String : AnyObject], coverImage: coverImgUrl) { [weak self] (response, error) in
            guard let self = self else { return }
            if let _response = response as? [String : AnyObject], error == nil {
                guard let dict = _response.valueForJSON(key: CJsonMeta) as? [String : AnyObject] else{
                    return
                }
                if let sideMenuVc = appDelegate.sideMenuController.leftViewController as? SideMenuViewController {
                    sideMenuVc.updateUserProfile()
                }
                self.redirectOnSuccess(metaData: dict)
            }
        }
    }
    
    func registerAudioToken(){
        if txtFirstName.text != oldFirstName || txtLastName.text != oldLastName{
        }
    }
    
    func redirectOnSuccess(metaData : [String : AnyObject]){
        
        if self.verificationStep == 1 || self.verificationStep == 2 {
            if let objVerify = CStoryboardLRF.instantiateViewController(withIdentifier: "VerifyEmailMobileViewController") as? VerifyEmailMobileViewController{
                objVerify.apiStatusCode = metaData.valueForInt(key: CJsonStatus) ?? 0
                objVerify.isFromEditProfile = true
                objVerify.isEmailVerify = (self.verificationStep == 1)
                objVerify.otpCode = ""
                objVerify.dict =  [
                    CEmail : (txtEmail.text ?? "") as AnyObject,
                    CMobile : (txtMobileNumber.text ?? "") as AnyObject,
                    CCountry_id : self.countryCodeId as AnyObject
                ]
                self.navigationController?.pushViewController(objVerify, animated: true)
            }
        } else {
            
            let isAppLaunchHere = CUserDefaults.value(forKey: UserDefaultIsAppLaunchHere) as? Bool ?? true
            
            if metaData.valueForInt(key: CJsonStatus) == CStatusTwelve && isAppLaunchHere {
                CUserDefaults.set(false, forKey: UserDefaultIsAppLaunchHere)
                CUserDefaults.synchronize()
                appDelegate.initHomeViewController()
            } else if metaData.valueForInt(key: CJsonStatus) == CStatusZero && !isAppLaunchHere {
                CUserDefaults.set(true, forKey: UserDefaultIsAppLaunchHere)
                CUserDefaults.synchronize()
                appDelegate.initHomeViewController()
            } else {
                
                for vwController in (self.navigationController?.viewControllers)! {
                    if vwController.isKind(of: SettingViewController .classForCoder()){
                        MILoader.shared.hideLoader()
                        self.navigationController?.popViewController(animated: true)
                        break
                    } else if vwController.isKind(of: MyProfileViewController .classForCoder()){
                        MILoader.shared.hideLoader()
                        let profileVC = vwController as? MyProfileViewController
                        profileVC?.tblUser.reloadData()
                        self.navigationController?.popViewController(animated: true)
                        break
                    }
                }
            }
        }
    }
}

// MARK:- --------- Action Event
extension EditProfileViewController{
    
    @IBAction func btnSelectLocationCLK(_ sender : UIButton){
        
        guard let locationPicker = CStoryboardLocationPicker.instantiateViewController(withIdentifier: "LocationPickerVC") as? LocationPickerVC else {
            return
        }
        locationPicker.completion = { [weak self] (placeDetail) in
            guard let self = self else { return }
            self.latitude = placeDetail?.coordinate?.latitude ?? 0.0
            self.longitude = placeDetail?.coordinate?.longitude ?? 0.0
            self.strCity = placeDetail?.locality ?? ""
        }
        self.navigationController?.pushViewController(locationPicker, animated: true)
    }
    
    @IBAction func btnUploadImageCLK(_ sender : UIButton){
        if self.imgUser.image != nil {
            let userdata:Int = CUserDefaults.value(forKey:"imageReplaced") as? Int ?? 0
            if userdata == 0  || userdata == 3 {
                self.presentActionsheetWithThreeButton(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CRegisterChooseFromPhone, btnOneStyle: .default, btnOneTapped: { [weak self] (action) in
                    guard let self = self else { return }
                    self.presentImagePickerControllerForGallery(imagePickerControllerCompletionHandler: { [weak self] (image, info) in
                        guard let self = self else { return }
                        if image != nil{
                            self.uploadedImg = true
                            self.imgEditIcon.isHidden = false
                            self.imgUser.image = image
                            
                            self.isremovedImage = false
                            CUserDefaults.set(3, forKey:"imageReplaced")
                            CUserDefaults.synchronize()
                            MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: nil)
                            guard let imageURL = info?[UIImagePickerController.InfoKey.imageURL] as? NSURL else {
                                return
                            }
                            self.imgName = imageURL.absoluteString ?? ""
                            guard let mobileNum = appDelegate.loginUser?.mobile else {
                                return
                            }
                            MInioimageupload.shared().uploadMinioimages(mobileNo: mobileNum, ImageSTt: image!,isFrom:"",uploadFrom:"")
                            MInioimageupload.shared().callback = { message in
                                print("UploadImage::::::::::::::\(message)")
                                self.profileImgUrl = message
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                    self.uploadProfilePic()
                                })
                            }
                        }
                    })
                    
                }, btnTwoTitle: CRegisterTakePhoto, btnTwoStyle: .default, btnTwoTapped: { [weak self] (action) in
                    guard let self = self else { return }
                    self.presentImagePickerControllerForCamera(imagePickerControllerCompletionHandler: { [weak self] (image, info) in
                        guard let self = self else { return }
                        if image != nil{
                            self.uploadedImg = true
                            self.imgEditIcon.isHidden = false
                            self.imgUser.image = image
                            self.isremovedImage = false
                            CUserDefaults.set(3, forKey:"imageReplaced")
                            CUserDefaults.synchronize()
                        }
                    })
                }, btnThreeTitle: CRegisterRemovePhoto, btnThreeStyle: .default) { [weak self] (action) in
                    guard let self = self else { return }
                    let frstNameltr = (self.txtFirstName.text?.first)!
                    let convStrName = String(frstNameltr)
                    let text = convStrName
                    let attributes = [
                        NSAttributedString.Key.foregroundColor: UIColor.white,
                        NSAttributedString.Key.backgroundColor:#colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1),
                        NSAttributedString.Key.font: UIFont.init(name: "AmericanTypewriter-Semibold", size: 40),
                    ]
                    let textSize = text.size(withAttributes: attributes)
                    UIGraphicsBeginImageContextWithOptions(textSize, true, 0)
                    text.draw(at: CGPoint.zero, withAttributes: attributes)
                    let image = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                    self.isremovedImage = true
                    self.imgUser.image = image
                    CUserDefaults.set(2, forKey:"imageReplaced")
                    CUserDefaults.synchronize()
                    self.imgEditIcon.isHidden = true
                    self.uploadProfilePic()
                }
                
            }
            
            if userdata == 2 {
                self.presentActionsheetWithTwoButtons(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CRegisterChooseFromPhone, btnOneStyle: .default, btnOneTapped: { [weak self] (action) in
                    guard let self = self else { return }
                    self.presentImagePickerControllerForGallery(imagePickerControllerCompletionHandler: { [weak self] (image, info) in
                        guard let self = self else { return }
                        if image != nil{
                            self.uploadedImg = true
                            self.imgEditIcon.isHidden = false
                            self.imgUser.image = image
                            self.imgUser.image = image
                            CUserDefaults.set(3, forKey:"imageReplaced")
                            CUserDefaults.synchronize()
                        }
                    })
                }, btnTwoTitle: CRegisterTakePhoto, btnTwoStyle: .default) { [weak self] (action) in
                    guard let self = self else { return }
                    self.presentImagePickerControllerForCamera(imagePickerControllerCompletionHandler: { [weak self] (image, info) in
                        guard let self = self else { return }
                        if image != nil{
                            self.uploadedImg = true
                            self.imgEditIcon.isHidden = false
                            self.imgUser.image = image
                            self.isremovedImage = false
                            self.imgUser.image = image
                            CUserDefaults.set(3, forKey:"imageReplaced")
                            CUserDefaults.synchronize()
                        }
                    })
                }
            }
        } else {
            self.presentImagePickerController(allowEditing: true) { [weak self](image, info) in
                guard let self = self else { return }
                if image != nil{
                    self.uploadedImg = true
                    self.imgEditIcon.isHidden = false
                    self.imgUser.image = image
                }
            }
        }
    }
    @IBAction func btnUploadCoverCLK (_ sender : UIButton) {
        if self.imgCover.image != nil {
            self.presentActionsheetWithThreeButton(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CRegisterChooseFromPhone, btnOneStyle: .default, btnOneTapped: { [weak self] (action) in
                guard let self = self else { return }
                
                self.presentImagePickerControllerForGallery(imagePickerControllerCompletionHandler: { [weak self] (image, info) in
                    guard let self = self else { return }
                    if image != nil{
                        self.coverImg = true
                        self.CoverEditIcon.isHidden = false
                        self.imgCover.image = image
                        NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil,userInfo: ["imagename":image ?? ""])
                        MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: nil)
                        
                        guard let imageURL = info?[UIImagePickerController.InfoKey.imageURL] as? NSURL else {
                            return
                        }
                        
                        self.imgName = imageURL.absoluteString ?? ""
                        guard let mobileNum = appDelegate.loginUser?.mobile else {return}
                        MInioimageupload.shared().uploadMinioimages(mobileNo: mobileNum, ImageSTt: image!,isFrom:"",uploadFrom:"")
                        
                        MInioimageupload.shared().callback = { message in
                            print("UploadImage::::::::::::::\(message)")
                            self.coverImgUrl = message
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                self.uploadCoverPic()
                            })
                        }
                        
                    }
                    
                })
                
            }, btnTwoTitle: CRegisterTakePhoto, btnTwoStyle: .default, btnTwoTapped: { [weak self] (action) in
                guard let self = self else { return }
                self.presentImagePickerControllerForCamera(imagePickerControllerCompletionHandler: { [weak self] (image, info) in
                    guard let self = self else { return }
                    if image != nil{
                        self.coverImg = true
                        self.CoverEditIcon.isHidden = false
                        self.imgCover.image = image
                    }
                })
            }, btnThreeTitle: CRegisterRemovePhoto, btnThreeStyle: .default) { [weak self] (action) in
                guard let self = self else { return }
                self.imgCover.image = nil
                self.CoverEditIcon.isHidden = true
                self.uploadProfilePic()
                
            }
            
        } else {
            self.presentImagePickerController(allowEditing: true) { [weak self](image, info) in
                guard let self = self else { return }
                if image != nil{
                    self.coverImg = true
                    self.CoverEditIcon.isHidden = false
                    self.imgCover.image = image
                }
            }
        }
    }
    
    @IBAction func btnUpdateCLK(_ sender : UIButton)
    {
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
        if (txtDOB.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CRegisterAlertDobBlank, btnOneTitle: CBtnOk, btnOneTapped: nil)
            return
        }
        if (txtCountrys.text?.isEmpty ?? true) && JSON(rawValue: (countryName ?? "")) ?? "" == 0{
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CBlankCountry, btnOneTitle: CBtnOk, btnOneTapped: nil)
            return
        }
        if !(txtStates.superview?.isHidden ?? true) && JSON(rawValue: (stateName ?? "")) ?? "" == 0{
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CBlankState, btnOneTitle: CBtnOk, btnOneTapped: nil)
            return
        }
        if !(txtCitys.superview?.isHidden ?? true) && JSON(rawValue: (cityName ?? "")) ?? "" == 0{
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CBlankCity, btnOneTitle: CBtnOk, btnOneTapped: nil)
            return
        }
        self.editProfile()
    }
    
    @IBAction func btnUpdateCompleteCLK(_ sender : UIButton) {
        if let completeProfileVC = CStoryboardProfile.instantiateViewController(withIdentifier: "CompleteProfileViewController") as? CompleteProfileViewController{
            let dobupdateUserDtls = DateFormatter.shared().convertDatereveruserDetails(strDate: txtDOB.text)
            let Dob = "\(dobupdateUserDtls?.description ?? "" ) \(" GMT+0000 (Coordinated Universal Time)")"
            completeProfileVC.dob_edit = Dob
            completeProfileVC.firstName_edit = txtFirstName.text ?? ""
            completeProfileVC.lastName_edit = txtLastName.text ?? ""
            completeProfileVC.isSelected = true
            self.navigationController?.pushViewController(completeProfileVC, animated: true)
        }
    }
}
