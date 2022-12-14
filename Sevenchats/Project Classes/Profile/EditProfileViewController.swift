//
//  EditProfileViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 29/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//
/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : EditProfileViewController                   *
 * Changes :                                             *
 *                                                       *
 ********************************************************/


/*import UIKit
import CoreLocation
//import GooglePlacePicker
//
class EditProfileViewController: ParentViewController {
    
    @IBOutlet weak var scrollViewContainer : UIView!
    @IBOutlet weak var btnUpdate : UIButton!
    @IBOutlet weak var btnUpdateComplete : UIButton!
    @IBOutlet weak var btnUploadImage : UIButton!
    @IBOutlet weak var imgUser : UIImageView!
    @IBOutlet weak var downarrow : UIImageView!
    @IBOutlet weak var imgEditIcon : UIImageView!
    @IBOutlet weak var imgCover : UIImageView!
    @IBOutlet weak var CoverEditIcon : UIImageView!
    @IBOutlet weak var txtFirstName : MIGenericTextFiled!
    @IBOutlet weak var txtLastName : MIGenericTextFiled!
    @IBOutlet weak var txtUserId : MIGenericTextFiled!
    @IBOutlet weak var txtEmail : MIGenericTextFiled!
    @IBOutlet weak var txtMobileNumber : MIGenericTextFiled!
    @IBOutlet weak var txtCountryCode : MIGenericTextFiled!
    @IBOutlet weak var txtDOB : MIGenericTextFiled!
    @IBOutlet weak var lblCode : UILabel!
    @IBOutlet weak var txtCountrys : MIGenericTextFiled!
    @IBOutlet weak var txtStates : MIGenericTextFiled!
    @IBOutlet weak var txtCitys : MIGenericTextFiled!
    @IBOutlet var cnTxtEmailLeading : NSLayoutConstraint!
    
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
    var isProfileImg = false
    var isCoverImg = false
    var postFirstName = ""
    var postLastName = ""
    var startDate = ""
    var chngDate = ""
    
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
        txtFirstName.txtDelegate = self
        txtLastName.txtDelegate = self
        txtEmail.isHidden = true
        
       // txtUserId.txtDelegate = self
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
        txtDOB.setMaximumDate(maxDate: Date().dateByAdd(years: -16))
        txtDOB.setDatePickerWithDateFormate(dateFormate: "dd MMM yyyy", defaultDate: Date(), isPrefilledDate: false) { [weak self] (date) in
            guard let self = self else { return }
            self.dobDate = DateFormatter.shared().string(fromDate: date, dateFormat: "dd MMM yyyy")
        }
        setupCuntryStateCityList()
        self.preFilledUserDetail()
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: #imageLiteral(resourceName: "ic_info_tint"), style: .plain, target: self, action: #selector(btnHelpInfoClicked(_:)))]
    }
    
    func setLanguageText() {
        self.title = CNavEditProfile
        txtFirstName.placeHolder = CRegisterPlaceholderFirstName
        txtLastName.placeHolder = CRegisterPlaceholderLastName
        txtEmail.placeHolder = CRegisterPlaceholderEmail
        txtEmail.btnClearText.isHidden = true
//        txtMobileNumber.placeHolder = CRegisterPlaceholderMobileNumber
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
  //MARK: - NEW
        if appDelegate.loginUser?.mobile != "" {
            txtMobileNumber.placeHolder = CRegisterPlaceholderMobileNumber
            txtMobileNumber.text = appDelegate.loginUser?.mobile
            cnTxtEmailLeading.constant = txtCountryCode.bounds.width + 30
            txtCountryCode.isHidden = false
            lblCode.isHidden = false
            downarrow.isHidden = false
        }else{
            txtMobileNumber.placeHolder = CRegisterPlaceholderEmail
            txtMobileNumber.text = appDelegate.loginUser?.email
            cnTxtEmailLeading.constant = 20
            txtCountryCode.isHidden = true
            lblCode.isHidden = true
            downarrow.isHidden = true
        }
 //MARK: - NEW
        
        
//        if appDelegate.loginUser?.email == "" {
////            txtMobileNumber.isEnabled = false
////            txtMobileNumber.isUserInteractionEnabled = false
//        }else if appDelegate.loginUser?.mobile  == "" {
//            txtEmail.isEnabled = false
//            txtEmail.isUserInteractionEnabled = false
//        }
//
//        txtEmail.isEnabled = false
//        txtEmail.isUserInteractionEnabled = false
//
       txtMobileNumber.isEnabled = false
       txtMobileNumber.isUserInteractionEnabled = false
        
        txtCountryCode.isEnabled = false
        txtCountryCode.isUserInteractionEnabled = false
        
        self.loadCountryCodeList()
        self.loadCountryList()
        oldFirstName = appDelegate.loginUser?.first_name ?? ""
        oldLastName = appDelegate.loginUser?.last_name ?? ""
        txtFirstName.text = appDelegate.loginUser?.first_name
        txtLastName.text = appDelegate.loginUser?.last_name
        txtEmail.text = appDelegate.loginUser?.email
        
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
            isProfileImg = true
            imgUser.loadImageFromUrl((appDelegate.loginUser?.profile_url ?? ""), true)
            imgEditIcon.isHidden = true
        }
        if appDelegate.loginUser?.cover_image != "" {
            
            imgCover.loadImageFromUrl((appDelegate.loginUser?.cover_image ?? ""), true)
            btnUploadImage.setImage(UIImage(), for: .normal)
            imgEditIcon.isHidden = false
        } else{
            isCoverImg = true
            imgCover.image = UIImage(named: "CoverImage.png")
//            imgCover.loadImageFromUrl((appDelegate.loginUser?.cover_image ?? ""), true)
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
    
    @objc fileprivate func btnHelpInfoClicked(_ sender : UIBarButtonItem){
        if let helpLineVC = CStoryboardHelpLine.instantiateViewController(withIdentifier: "HelpLineViewController") as? HelpLineViewController {
            helpLineVC.fromVC = "ediProfileVC"
            self.navigationController?.pushViewController(helpLineVC, animated: true)
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
                let countryName = dict.value(forKey: CCountryName) as? String
                if countryName == self.countryName {
                    self.countryName = dict.value(forKey: CCountryName) as? String
              //  let countryID = dict.value(forKey: CCountry_id) as? Int
//                if countryID != self.countryID{
//                    self.countryID = dict.value(forKey: CCountry_id) as? Int
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
        print("self.txtDOB\(self.txtDOB)")
        
        if self.txtDOB.text?.range(of:"ಜನವರಿ") != nil{
            startDate = self.txtDOB.text?.replacingOccurrences(of: "ಜನವರಿ", with: "Jan") ?? ""
              }else if self.txtDOB.text?.range(of:"ಫೆಬ್ರವರಿ") != nil{
                  startDate = self.txtDOB.text?.replacingOccurrences(of: "ಫೆಬ್ರವರಿ", with: "Feb") ?? ""
              } else if self.txtDOB.text?.range(of:"ಮಾರ್ಚ್") != nil{
                  startDate = self.txtDOB.text?.replacingOccurrences(of: "ಮಾರ್ಚ್", with: "Mar") ?? ""
              }else if self.txtDOB.text?.range(of:"ಏಪ್ರಿ") != nil{
                  startDate = self.txtDOB.text?.replacingOccurrences(of: "ಏಪ್ರಿ", with: "Apr") ?? ""
              }else if self.txtDOB.text?.range(of:"ಮೇ") != nil{
                  startDate = self.txtDOB.text?.replacingOccurrences(of: "ಮೇ", with: "May") ?? ""
              }else if self.txtDOB.text?.range(of:"ಜೂನ್") != nil{
                  startDate = self.txtDOB.text?.replacingOccurrences(of: "ಜೂನ್", with: "Jun") ?? ""
              }else if self.txtDOB.text?.range(of:"ಜುಲೈ") != nil{
                  startDate = self.txtDOB.text?.replacingOccurrences(of: "ಜುಲೈ", with: "Jul") ?? ""
              }else if txtDOB.text?.range(of:"ಆಗ") != nil{
                  startDate = txtDOB.text?.replacingOccurrences(of: "ಆಗ", with: "Aug") ?? ""
              }else if txtDOB.text?.range(of:"ಸೆಪ್ಟೆಂ") != nil{
                  startDate = txtDOB.text?.replacingOccurrences(of: "ಸೆಪ್ಟೆಂ", with: "Sep") ?? ""
              }else if txtDOB.text?.range(of:"ಅಕ್ಟೋ") != nil{
                  startDate = txtDOB.text?.replacingOccurrences(of: "ಅಕ್ಟೋ", with: "Oct") ?? ""
              } else if txtDOB.text?.range(of:"ನವೆಂ") != nil{
                  startDate = txtDOB.text?.replacingOccurrences(of: "ನವೆಂ", with: "Nov") ?? ""
              }else if txtDOB.text?.range(of:"ಡಿಸೆಂ") != nil{
                  startDate = txtDOB.text?.replacingOccurrences(of: "ಡಿಸೆಂ", with: "Dec") ?? ""
              }else {
                  chngDate = self.txtDOB.text ?? ""
              }
        if startDate.range(of:"ಅಪರಾಹ್ನ") != nil{
            chngDate = startDate.replacingOccurrences(of: "ಅಪರಾಹ್ನ", with: "PM")
        }
        if startDate.range(of:"ಪೂರ್ವಾಹ್ನ") != nil{
            chngDate = startDate.replacingOccurrences(of: "ಪೂರ್ವಾಹ್ನ", with: "AM")
        }
        
        let dobconvert = DateFormatter.shared().convertDaterevers(strDate: chngDate)
        let dobupdateUserDtls = DateFormatter.shared().convertDatereveruserDetails(strDate: chngDate)
        let chgtimeFormat = "\(dobupdateUserDtls?.description ?? "" ) \(" GMT+0000 (Coordinated Universal Time)")"
        
        let encryptUser = EncryptDecrypt.shared().encryptDecryptModel(userResultStr: userID.description)
        let encryptEmail = EncryptDecrypt.shared().encryptDecryptModel(userResultStr: txtEmail.text ?? "")
        let encryptPhoneNo = EncryptDecrypt.shared().encryptDecryptModel(userResultStr: txtMobileNumber.text ?? "")

        
        
        let dict :[String:Any]  =  [
           /* "user_acc_type":"1",
            "user_id": encryptUser,
            "first_name":txtFirstName.text ?? "",
            "last_name":txtLastName.text ?? "",
            "gender":String(appDelegate.loginUser!.gender),
            "religion":appDelegate.loginUser?.religion ?? "",
            "city_name":txtCitys.text ?? "",
            "profile_image":appDelegate.loginUser?.profile_img ?? "",
            "cover_image":appDelegate.loginUser?.cover_image ?? "",
           // "mobile":encryptPhoneNo,
          //  "email":encryptEmail,
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
            "status_id":"1",*/
            
            
            
            "user_acc_type":"1",
                "user_id": encryptUser,
                "email":txtEmail.text ?? "",
                "first_name":txtFirstName.text ?? "",
                "last_name":txtLastName.text ?? "",
                "gender":String(appDelegate.loginUser!.gender),
                "city_name":txtCitys.text ?? "",
                "profile_image":appDelegate.loginUser?.profile_img ?? "",
                "cover_image":appDelegate.loginUser?.cover_image ?? "",
                "religion": appDelegate.loginUser?.religion ?? "",
                "dob":dobconvert ?? "",
                "short_biography":appDelegate.loginUser?.short_biography ?? "",
                "relationship":appDelegate.loginUser?.relationship ?? "",
                "profession":appDelegate.loginUser?.profession ?? "",
                "address_line1":appDelegate.loginUser?.address ?? "",
                "latitude":0,
                "longitude":0,
                "user_type": "1",
                "employment_status": appDelegate.loginUser?.employment_status ?? 0,
                "education":appDelegate.loginUser?.education_name ?? "",
                "income":appDelegate.loginUser?.annual_income ?? "",
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
//                            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage:"Detials updated successfully", btnOneTitle: CBtnOk, btnOneTapped: nil)
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
        let encryptUser = EncryptDecrypt.shared().encryptDecryptModel(userResultStr: userID.description)
        let dict :[String:Any]  =  [
            CUserId: encryptUser,
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
        guard let userID = appDelegate.loginUser?.user_id else {return}
        let encryptUser = EncryptDecrypt.shared().encryptDecryptModel(userResultStr: userID.description)
        
       
        let dict :[String:Any]  =  [
            CUserId: encryptUser,
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
                        self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageUpdatedprofile, btnOneTitle: CBtnOk, btnOneTapped: { [weak self] (alert) in
                            self?.navigationController?.popViewController(animated: true)
                        })
                        //self.navigationController?.popViewController(animated: true)
                        break
                    } else if vwController.isKind(of: MyProfileViewController .classForCoder()){
                        MILoader.shared.hideLoader()
                        let profileVC = vwController as? MyProfileViewController
                        profileVC?.tblUser.reloadData()
                        self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageUpdatedprofile, btnOneTitle: CBtnOk, btnOneTapped: { [weak self] (alert) in
                            self?.navigationController?.popViewController(animated: true)
                        })
                        //self.navigationController?.popViewController(animated: true)
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
        
        if isProfileImg == true{
            guard let modileNum = appDelegate.loginUser?.mobile else {return}
            if self.imgUser.image != nil || self.imgUser.image == nil {
                self.presentActionsheetWithTwoButtons(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CRegisterChooseFromPhone, btnOneStyle: .default, btnOneTapped: { [weak self] (action) in
                    guard let self = self else { return }
                    self.presentImagePickerControllerForGallery(imagePickerControllerCompletionHandler: { [weak self] (image, info) in
                        guard let self = self else { return }
                        if image != nil{
                            self.uploadedImg = true
                            self.imgEditIcon.isHidden = false
                            self.imgUser.image = image
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
                                self.profileImgUrl = message
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                    self.uploadProfilePic()
                                })
                            }
                            
                        }
                        
                    })
                }, btnTwoTitle: CRegisterTakePhoto, btnTwoStyle: .default) { [weak self](alert) in
                    guard let _ = self else { return }
                    self?.presentImagePickerControllerForCamera(imagePickerControllerCompletionHandler: { [weak self] (image, info) in
                        guard let self = self else { return }
                        if image != nil{
                            self.uploadedImg = true
                            self.imgEditIcon.isHidden = false
                            self.imgUser.image = image
                            MInioimageupload.shared().uploadMinioimages(mobileNo: modileNum, ImageSTt: image!,isFrom:"",uploadFrom:"")
                            MInioimageupload.shared().callback = { message in
                                self.profileImgUrl = message
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                    self.uploadProfilePic()
                               })
                            }
                        }
                    })
                }
                
                
            }
        }else{
            guard let modileNum = appDelegate.loginUser?.mobile else {return}
            if self.imgUser.image != nil {
                self.presentActionsheetWithThreeButton(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CRegisterChooseFromPhone, btnOneStyle: .default, btnOneTapped: { [weak self] (action) in
                    guard let self = self else { return }
                    
                    self.presentImagePickerControllerForGallery(imagePickerControllerCompletionHandler: { [weak self] (image, info) in
                        guard let self = self else { return }
                        if image != nil{
                            self.uploadedImg = true
                            self.imgEditIcon.isHidden = false
                            self.imgUser.image = image
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
                            MInioimageupload.shared().uploadMinioimages(mobileNo: modileNum, ImageSTt: image!,isFrom:"",uploadFrom:"")
                            MInioimageupload.shared().callback = { message in
                                self.profileImgUrl = message
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                    self.uploadProfilePic()
                               })
                            }
                        }
//                        if image != nil{
//                            self.uploadedImg = true
//                            self.imgEditIcon.isHidden = false
//                            self.imgUser.image = image
//                            self.uploadProfilePic()
//                        }
                    })
                }, btnThreeTitle: CRegisterRemovePhoto, btnThreeStyle: .default) { [weak self] (action) in
                    guard let self = self else { return }

     //                self.coverImgUrl = "https://qa.sevenchats.com:3443/sevenchats/CoverImage/IOS1643088311733.png"
                    self.imgUser.image = UIImage(named: "CoverImage.png")
                    self.imgEditIcon.isHidden = true
                    self.uploadProfilePic()
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
        
    }
    @IBAction func btnUploadCoverCLK (_ sender : UIButton) {
        if isCoverImg == true{
            guard let modileNum = appDelegate.loginUser?.mobile else {return}
            if self.imgCover.image != nil {
                self.presentActionsheetWithTwoButtons(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CRegisterChooseFromPhone, btnOneStyle: .default, btnOneTapped: { [weak self] (action) in
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
                }, btnTwoTitle: CRegisterTakePhoto, btnTwoStyle: .default) { [weak self](alert) in
                    guard let _ = self else { return }
                    self?.presentImagePickerControllerForCamera(imagePickerControllerCompletionHandler: { [weak self] (image, info) in
                        guard let self = self else { return }
                        if image != nil{
                            self.coverImg = true
                            self.CoverEditIcon.isHidden = false
                            self.imgCover.image = image
                            MInioimageupload.shared().uploadMinioimages(mobileNo: modileNum, ImageSTt: image!,isFrom:"",uploadFrom:"")
                            MInioimageupload.shared().callback = { message in
                                self.coverImgUrl = message
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                    self.uploadCoverPic()
                               })
                            }
                        }
//                        if image != nil{
//                            self.coverImg = true
//                            self.CoverEditIcon.isHidden = false
//                            self.imgCover.image = image
//                            self.uploadCoverPic()
//                        }
                    })
                }
                
                
            }
        }else{
            guard let modileNum = appDelegate.loginUser?.mobile else {return}
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
                            MInioimageupload.shared().uploadMinioimages(mobileNo: modileNum, ImageSTt: image!,isFrom:"",uploadFrom:"")
                            MInioimageupload.shared().callback = { message in
                                self.coverImgUrl = message
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                    self.uploadCoverPic()
                               })
                            }
                        }
//                        if image != nil{
//                            self.coverImg = true
//                            self.CoverEditIcon.isHidden = false
//                            self.imgCover.image = image
//                            self.uploadCoverPic()
//                        }
                    })
                }, btnThreeTitle: CRegisterRemovePhoto, btnThreeStyle: .default) { [weak self] (action) in
                    guard let self = self else { return }

    //                self.coverImgUrl = "https://qa.sevenchats.com:3443/sevenchats/CoverImage/IOS1643088311733.png"
                    self.imgCover.image = UIImage(named: "CoverImage.png")
                    self.CoverEditIcon.isHidden = true
                    self.uploadCoverPic()
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
    }
   /* @IBAction func btnUploadImageCLK(_ sender : UIButton){
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
                }, btnThreeTitle: CRegisterRemovePhoto, btnThreeStyle: .default) { [weak self] (action) in
                    guard let self = self else { return }
                    
                    //Name To image Convert Future version
//                    let frstNameltr = (self.txtFirstName.text?.first)!
//                    let convStrName = String(frstNameltr)
//                    let text = convStrName
//                    let attributes = [
//                        NSAttributedString.Key.foregroundColor: UIColor.white,
//                        NSAttributedString.Key.backgroundColor:#colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1),
//                        NSAttributedString.Key.font: UIFont.init(name: "AmericanTypewriter-Semibold", size: 40),
//                    ]
//                    let textSize = text.size(withAttributes: attributes)
//                    UIGraphicsBeginImageContextWithOptions(textSize, true, 0)
//                    text.draw(at: CGPoint.zero, withAttributes: attributes)
//                    let image = UIGraphicsGetImageFromCurrentImageContext()
//                    UIGraphicsEndImageContext()
                    self.isremovedImage = true
//                    self.imgUser.image = image
                    CUserDefaults.set(2, forKey:"imageReplaced")
                    CUserDefaults.synchronize()
                    self.imgEditIcon.isHidden = true
//                    self.uploadProfilePic()
                    
                    self.profileImgUrl = "https://qa.sevenchats.com:3443/sevenchats/ProfilePic/IOS1643090910947.png"
                        self.uploadProfilePic()
                    self.imgUser.image = UIImage(named: "user_placeholder.png")
                    
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
                        self.uploadCoverPic()
                    }
                })
            }, btnThreeTitle: CRegisterRemovePhoto, btnThreeStyle: .default) { [weak self] (action) in
                guard let self = self else { return }

                self.coverImgUrl = "https://qa.sevenchats.com:3443/sevenchats/CoverImage/IOS1643088311733.png"
                self.imgCover.image = UIImage(named: "CoverImage.png")
                self.CoverEditIcon.isHidden = true
                self.uploadCoverPic()
                
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
    }*/
    
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
//        if (txtEmail.text?.isBlank)! {
//            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CRegisterAlertEmailBlank, btnOneTitle: CBtnOk, btnOneTapped: nil)
//            return
//        }
//        if !(txtEmail.text?.isValidEmail)! {
//            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CRegisterAlertValidEmail, btnOneTitle: CBtnOk, btnOneTapped: nil)
//            return
//        }
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
        //if (txtCountrys.text?.isEmpty ?? true) && JSON(rawValue: (countryName ?? "")) ?? "" == 0{
        if (txtCountrys.text?.isBlank)!{
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CBlankCountry, btnOneTitle: CBtnOk, btnOneTapped: nil)
            return
        }
        //if !(txtStates.superview?.isHidden ?? true) && JSON(rawValue: (stateName ?? "")) ?? "" == 0{
        if (txtStates.text?.isBlank)!{
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CBlankState, btnOneTitle: CBtnOk, btnOneTapped: nil)
            return
        }
        //if !(txtCitys.superview?.isHidden ?? true) && JSON(rawValue: (cityName ?? "")) ?? "" == 0{
        if (txtCitys.text?.isBlank)!{
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CBlankCity, btnOneTitle: CBtnOk, btnOneTapped: nil)
            return
        }
        let charSet = CharacterSet.init(charactersIn: SPECIALCHARNOTALLOWED)
        if (self.txtFirstName.text?.rangeOfCharacter(from: charSet) != nil) || (self.txtLastName.text?.rangeOfCharacter(from: charSet) != nil)
            {
                print("true")
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageSpecial, btnOneTitle: CBtnOk, btnOneTapped: nil)
                return
            }else{
                self.editProfile()
            }
//        if self.txtFirstName.text != "" && self.txtLastName.text != "" {
//            let characterset = CharacterSet(charactersIn:SPECIALCHAR)
//            if self.txtFirstName.text?.rangeOfCharacter(from: characterset.inverted) != nil || self.txtLastName.text?.rangeOfCharacter(from: characterset.inverted) != nil  {
//                print("contains Special charecter")
//                if txtFirstName.text != "" || txtLastName.text != "" {
//                postFirstName = removeSpecialCharacters(from: txtFirstName.text!)
//                postLastName = removeSpecialCharacters(from: txtLastName.text!)
//
//              }
//              self.editProfile()
//            } else {
//               print("false")
//                postFirstName = txtFirstName.text ?? ""
//                postLastName = txtLastName.text ?? ""
//                self.editProfile()
//            }
//        }
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
extension EditProfileViewController: GenericTextFieldDelegate {
    
    @objc func genericTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtFirstName || textField == txtLastName {
            if string.isSingleEmoji {
                return (string == string)
            }else {
                if string.count <= 20{
                    let inverted = NSCharacterSet(charactersIn: SPECIALCHARNOTALLOWED).inverted

                        let filtered = string.components(separatedBy: inverted).joined(separator: "")
                    
                        if (string.isEmpty  && filtered.isEmpty ) {
                                    let isBackSpace = strcmp(string, "\\b")
                                    if (isBackSpace == -92) {
                                        print("Backspace was pressed")
                                        return (string == filtered)
                                    }
                        } else {
                            return (string != filtered)
                        }

                }else{
                    return (string == "")
                }
            }
        }
        //MARK: - NEW
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
                lblCode.isHidden = false
                downarrow.isHidden = false
            }else{
                cnTxtEmailLeading.constant = 20
                txtCountryCode.isHidden = true
                lblCode.isHidden = true
                downarrow.isHidden = true
            }
            self.view.layoutIfNeeded()
            
            GCDMainThread.async {
               self.txtMobileNumber.updateBottomLineAndPlaceholderFrame()
            }
            return true
        }
        if textField == txtMobileNumber{
            if updatedText.isValidPhoneNo && !updatedText.isBlank{
                if textField.text?.count ?? 0 >= 15{
                    return false
                }
                cnTxtEmailLeading.constant = txtCountryCode.bounds.width + 30
                // cnTxtEmailLeading.constant = 20
                txtCountryCode.isHidden = false
                lblCode.isHidden = false
                downarrow.isHidden = false
            }else{
                cnTxtEmailLeading.constant = 20
                txtCountryCode.isHidden = true
                lblCode.isHidden = true
                downarrow.isHidden = true
            }
            self.view.layoutIfNeeded()
            
            GCDMainThread.async {
               self.txtMobileNumber.updateBottomLineAndPlaceholderFrame()
            }
    }
        //MARK: - NEW
        return true
    }
 //MARK: - NEW
        func genericTextFieldDidChange(_ textField : UITextField){
            if textField == txtMobileNumber{
                if (txtMobileNumber.text?.isValidPhoneNo)! && !(txtMobileNumber.text?.isBlank)!{
                    
                    cnTxtEmailLeading.constant = txtCountryCode.bounds.width + 30
                    txtCountryCode.isHidden = false
                    lblCode.isHidden = false
                    downarrow.isHidden = false
                }else{
                    cnTxtEmailLeading.constant = 20
                    txtCountryCode.isHidden = true
                    lblCode.isHidden = true
                    downarrow.isHidden = true
                }
                self.view.layoutIfNeeded()
                
                GCDMainThread.async {
                   self.txtMobileNumber.updateBottomLineAndPlaceholderFrame()
                }
            }
        }
    func genericTextFieldClearText(_ textField: UITextField){
        if textField == txtMobileNumber{
            cnTxtEmailLeading.constant = 20
            txtCountryCode.isHidden = true
            self.view.layoutIfNeeded()
            GCDMainThread.async {
             self.txtMobileNumber.updateBottomLineAndPlaceholderFrame()
            }
        }
    }
    //MARK: - NEW
}
extension EditProfileViewController {
func removeSpecialCharacters(from text: String) -> String {
    let okayChars = CharacterSet(charactersIn: SPECIALCHAR)
    return String(text.unicodeScalars.filter { okayChars.contains($0) || $0.properties.isEmoji })
}
    
}
*/



import UIKit
import CoreLocation
//import GooglePlacePicker
//
class EditProfileViewController: ParentViewController, GenericTextViewDelegate {
    
    @IBOutlet weak var scrollViewContainer : UIView!
    @IBOutlet weak var btnUpdate : UIButton!
    @IBOutlet weak var btnUpdateComplete : UIButton!
    @IBOutlet weak var btnUploadImage : UIButton!
    @IBOutlet weak var imgUser : UIImageView!
    @IBOutlet weak var downarrow : UIImageView!
    @IBOutlet weak var imgEditIcon : UIImageView!
    @IBOutlet weak var imgCover : UIImageView!
    @IBOutlet weak var CoverEditIcon : UIImageView!
    @IBOutlet weak var txtFirstName : MIGenericTextFiledNew!
    @IBOutlet weak var txtLastName : MIGenericTextFiledNew!
   // @IBOutlet weak var txtUserId : MIGenericTextFiledNew!
    @IBOutlet weak var txtEmail : MIGenericTextFiledNew!
    @IBOutlet weak var txtMobileNumber : MIGenericTextFiledNew!
    @IBOutlet weak var txtCountryCode : MIGenericTextFiledNew!
    @IBOutlet weak var txtDOB : MIGenericTextFiledNew!
    @IBOutlet weak var lblCode : UILabel!
    @IBOutlet weak var txtCountrys : MIGenericTextFiledNew!
    @IBOutlet weak var txtStates : MIGenericTextFiledNew!
    @IBOutlet weak var txtCitys : MIGenericTextFiledNew!
    @IBOutlet var cnTxtEmailLeading : NSLayoutConstraint!
    
    @IBOutlet var txtGender : MIGenericTextFiledNew!
    @IBOutlet var txtStatus : MIGenericTextFiledNew!
    @IBOutlet var txtEducation : MIGenericTextFiledNew!
    @IBOutlet var vwProfessionAndIncome : UIView!
    @IBOutlet var txtIncomeLevel : MIGenericTextFiledNew!
    @IBOutlet var txtProfession : MIGenericTextFiledNew!
    @IBOutlet var btnEmployed : UIButton!
    @IBOutlet var btnUnEmployed : UIButton!
    @IBOutlet var btnStudent : UIButton!
    @IBOutlet var txtReligion : MIGenericTextFiledNew!

    
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
    var isProfileImg = false
    var isCoverImg = false
    var postFirstName = ""
    var postLastName = ""
    var startDate = ""
    var chngDate = ""
    var educationName = ""
    var relationShip = ""
    var inCome = ""
    var postProfession = ""
    var incomeID = 0
    
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
        txtFirstName.txtDelegate = self
        txtLastName.txtDelegate = self
        txtEmail.isHidden = true
        txtCountryCode.layer.borderWidth = 1
        txtCountryCode.layer.cornerRadius = 5
       // txtReligion.txtDelegate = self
       // txtProfession.txtDelegate = self
        
       // txtUserId.txtDelegate = self
        btnUpdate.layer.cornerRadius = 5
        scrollViewContainer.layer.cornerRadius = 20
       // btnUpdateComplete.layer.cornerRadius = 5
//        btnUpdateComplete.layer.borderWidth = 1
//        btnUpdateComplete.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
        GCDMainThread.async {
//            self.imgUser.layer.cornerRadius = self.imgUser.frame.height/2
//            //self.btnUploadImage.layer.cornerRadius = self.btnUploadImage.frame.size.width/2
//            self.imgUser.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
//            self.imgUser.layer.borderWidth = 3
        }
        txtDOB.setDatePickerMode(mode: .date)
        txtDOB.setMaximumDate(maxDate: Date().dateByAdd(years: -16))
        txtDOB.setDatePickerWithDateFormate(dateFormate: "dd MMM yyyy", defaultDate: Date(), isPrefilledDate: false) { [weak self] (date) in
            guard let self = self else { return }
            self.dobDate = DateFormatter.shared().string(fromDate: date, dateFormat: "dd MMM yyyy")
        }
      //  setupCuntryStateCityList()
        self.preFilledUserDetail()
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: #imageLiteral(resourceName: "ic_info_tint"), style: .plain, target: self, action: #selector(btnHelpInfoClicked(_:)))]
        
        txtGender.setPickerData(arrPickerData: [CRegisterGenderMale, CRegisterGenderFemale ,CRegisterGenderOther], selectedPickerDataHandler: { (text, row, component) in
        }, defaultPlaceholder: "")
        
    }
    
    func setLanguageText() {
        self.title = CNavEditProfile
        txtFirstName.placeHolder = CRegisterPlaceholderFirstName
        txtLastName.placeHolder = CRegisterPlaceholderLastName
        txtEmail.placeHolder = CRegisterPlaceholderEmail
        txtEmail.btnClearText.isHidden = true
      // txtCountryCode.placeHolder = CRegisterPlaceholderCode
        txtDOB.placeHolder = CRegisterPlaceholderDob
       // lblCode.text = CRegisterPlaceholderCode
        btnUpdate.setTitle(CResetBtnUpdate, for: .normal)
        txtGender.placeHolder = CRegisterPlaceholderGender
     txtStatus.placeHolder = CProfilePlaceholderStatus
      txtEducation.placeHolder = CProfilePlaceholderEducation
        txtIncomeLevel.placeHolder = CProfilePlaceholderReligiousIncomeLevel
        txtReligion.placeHolder = CProfilePlaceholderReligiousInclination
    }
    
//    fileprivate func setupCuntryStateCityList(){
//
//        self.showHideCountryStateCityFileds()
//
//        let arrCountrys = [["name":"India", "id":"10"]]
//        txtCountrys.setPickerData(arrPickerData: arrCountrys, key: CName, selectedPickerDataHandler: {  [weak self](text, row, component) in
//            guard let self = self else { return }
//            let catInfo = arrCountrys[row]
//            self.countryName = catInfo.valueForString(key: CCountryName)
//            self.showHideCountryStateCityFileds()
//        }, defaultPlaceholder: "")
//    }
    
    

    
    func preFilledUserDetail (){
  //MARK: - NEW
        if appDelegate.loginUser?.mobile != "" {
            txtMobileNumber.placeHolder = CRegisterPlaceholderMobileNumber
            txtMobileNumber.text = appDelegate.loginUser?.mobile
            cnTxtEmailLeading.constant = txtCountryCode.bounds.width + 30
            txtCountryCode.isHidden = false
            lblCode.isHidden = false
            downarrow.isHidden = false
        }else{
            txtMobileNumber.placeHolder = CRegisterPlaceholderEmail
            txtMobileNumber.text = appDelegate.loginUser?.email
            cnTxtEmailLeading.constant = 20
            txtCountryCode.isHidden = true
            lblCode.isHidden = true
            downarrow.isHidden = true
        }
        
        if Int((appDelegate.loginUser?.gender)!) == CMale {
            txtGender.text = CRegisterGenderMale
        } else if Int((appDelegate.loginUser?.gender)!) == CFemale {
            txtGender.text = CRegisterGenderFemale
        } else{
            txtGender.text = CRegisterGenderOther
        }
 //MARK: - NEW
        
        
//        if appDelegate.loginUser?.email == "" {
////            txtMobileNumber.isEnabled = false
////            txtMobileNumber.isUserInteractionEnabled = false
//        }else if appDelegate.loginUser?.mobile  == "" {
//            txtEmail.isEnabled = false
//            txtEmail.isUserInteractionEnabled = false
//        }
//
//        txtEmail.isEnabled = false
//        txtEmail.isUserInteractionEnabled = false
//
       txtMobileNumber.isEnabled = false
       txtMobileNumber.isUserInteractionEnabled = false
        
        txtCountryCode.isEnabled = false
        txtCountryCode.isUserInteractionEnabled = false
        
        self.loadCountryCodeList()
      //  self.loadCountryList()
        oldFirstName = appDelegate.loginUser?.first_name ?? ""
        oldLastName = appDelegate.loginUser?.last_name ?? ""
        txtFirstName.text = appDelegate.loginUser?.first_name
        txtLastName.text = appDelegate.loginUser?.last_name
        txtEmail.text = appDelegate.loginUser?.email
        
        countryName = appDelegate.loginUser?.country ?? ""
        stateName =  appDelegate.loginUser?.state ?? ""
        cityName =  appDelegate.loginUser?.city ?? ""
        
        self.loadStateList(isCancelTask: true) { [weak self] in
            self?.loadCityList(isCancelTask: true, completion: { [weak self] in
                guard let _ = self else {return}
                MILoader.shared.hideLoader()
            })
        }

  
        let arrCountryList = TblCountry.fetch(predicate: NSPredicate(format:"country_name = %@", countryName ?? ""))
        if (arrCountryList?.count ?? 0) > 0{
            self.txtCountryCode.text = ((arrCountryList![0] as! TblCountry).country_code)
            countryCodeId = ((arrCountryList![0] as! TblCountry).country_code ?? "")
            
        }
        
      //  self.imgUser.image = nil
        let dobtxtAppDlg = appDelegate.loginUser?.dob?.description ?? ""
        let addTimeformat = " GMT+0000 (Coordinated Universal Time)"
        
    if dobtxtAppDlg.contains(find:" GMT+0000 (Coordinated Universal Time)"){
            self.Dob = "\(dobtxtAppDlg)"
        }else {
            self.Dob = "\(dobtxtAppDlg) \(addTimeformat)"
        }
        
        txtDOB.text = DateFormatter.shared().dateConvertUTC(fromDate: Dob)
        if appDelegate.loginUser?.profile_url != "" {
           // imgUser.loadImageFromUrl((appDelegate.loginUser?.profile_url ?? ""), true)
          //  btnUploadImage.setImage(UIImage(), for: .normal)
          //  imgEditIcon.isHidden = false
        } else{
            isProfileImg = true
           // imgUser.loadImageFromUrl((appDelegate.loginUser?.profile_url ?? ""), true)
           // imgEditIcon.isHidden = true
        }
        if appDelegate.loginUser?.cover_image != "" {
            
           // imgCover.loadImageFromUrl((appDelegate.loginUser?.cover_image ?? ""), true)
          //  btnUploadImage.setImage(UIImage(), for: .normal)
           // imgEditIcon.isHidden = false
        } else{
            //isCoverImg = true
          //  imgCover.image = UIImage(named: "CoverImage.png")
//            imgCover.loadImageFromUrl((appDelegate.loginUser?.cover_image ?? ""), true)
          //  imgEditIcon.isHidden = false
        }
        
        GCDMainThread.async {
            self.showHideCountryStateCityFileds()
            if !(self.txtFirstName.text?.isBlank)! {
                          self.txtFirstName.updatePlaceholderFrame(true)
                      }
                      if !(self.txtLastName.text?.isBlank)! {
                          self.txtLastName.updatePlaceholderFrame(true)
                      }
                      if !(self.txtReligion.text?.isBlank)! {
                          self.txtReligion.updatePlaceholderFrame(true)
                      }
                      if !(self.txtDOB.text?.isBlank)! {
                          self.txtDOB.updatePlaceholderFrame(true)
                      }
                      if !(self.txtGender.text?.isBlank)! {
                          self.txtGender.updatePlaceholderFrame(true)
                      }
                      if !(self.txtMobileNumber.text?.isBlank)! {
                          self.txtMobileNumber.updatePlaceholderFrame(true)
                      }
                      if !(self.txtCountryCode.text?.isBlank)! {
                       self.txtCountryCode.updatePlaceholderFrame(true)
                        }
                      if !(self.txtStatus.text?.isBlank)! {
                            self.txtStatus.updatePlaceholderFrame(true)
                             }
                      if !(self.txtEducation.text?.isBlank)! {
                                 self.txtEducation.updatePlaceholderFrame(true)
                                  }
            //self.txtCountrys.updatePlaceholderFrame(true)
          //  self.txtStates.updatePlaceholderFrame(true)
           // self.txtCitys.updatePlaceholderFrame(true)
            
            for txtInfo in self.scrollViewContainer.subviews{
                if let textInfo = txtInfo as? MIGenericTextFiled {
                    textInfo.updatePlaceholderFrame(true)
                    textInfo.showHideClearTextButton()
                }
            }
        }
        
        self.loadRelationList()
       self.loadAnnualIncomeList()
      self.loadEducationList()
        
       // txtViewBiography.text = appDelegate.loginUser?.short_biography
       txtReligion.text = appDelegate.loginUser?.religion
        if appDelegate.loginUser?.relationship == "N/A" ||  appDelegate.loginUser?.relationship == "null" || appDelegate.loginUser?.relationship == ""{
            txtStatus.text = ""
        }else {
            txtStatus.text = appDelegate.loginUser?.relationship
        }
        if appDelegate.loginUser?.education_name == "N/A" ||  appDelegate.loginUser?.education_name == "null" || appDelegate.loginUser?.education_name == ""{
        
            txtEducation.text  = ""
        }else {
           txtEducation.text  = appDelegate.loginUser?.education_name
        }
        if appDelegate.loginUser?.annual_income == "N/A" ||  appDelegate.loginUser?.annual_income == "null" || appDelegate.loginUser?.annual_income == ""{
            txtIncomeLevel.text = ""
        }else {
            txtIncomeLevel.text = appDelegate.loginUser?.annual_income
        }
        
        if Int((appDelegate.loginUser?.gender)!) == CMale {
            txtGender.text = CRegisterGenderMale
        } else if Int((appDelegate.loginUser?.gender)!) == CFemale {
            txtGender.text = CRegisterGenderFemale
        } else{
            txtGender.text = CRegisterGenderOther
        }
        
        switch appDelegate.loginUser?.employment_status {
        case 1:
            self.btnProfessionCLK(btnEmployed)
            txtProfession.text = appDelegate.loginUser?.profession
        case 2:
            self.btnProfessionCLK(btnUnEmployed)
            txtProfession.text = nil
        case 3:
            self.btnProfessionCLK(btnStudent)
            txtProfession.text = nil
        default:
            self.vwProfessionAndIncome.hide(byHeight: true)
            break
        }
        
        GCDMainThread.async {
            if !(self.txtProfession.text?.isBlank)! {
                self.txtProfession.updatePlaceholderFrame(true)
            }
            if !(self.txtIncomeLevel.text?.isBlank)! {
                self.txtIncomeLevel.updatePlaceholderFrame(true)
            }



            for txtInfo in self.scrollViewContainer.subviews{
                if let textInfo = txtInfo as? MIGenericTextFiled {
                    if !(textInfo.text?.isBlank)! {
                        textInfo.updatePlaceholderFrame(true)
                        textInfo.showHideClearTextButton()
                    }
                }
            }
        }

    }
    
    
//MARK: -
    
    func loadRelationList(){
        
        let arr = TblRelation.fetch(predicate: NSPredicate(format: "%K == %s", CName, CName), orderBy:CName, ascending: true)
        let arrData = TblRelation.fetch(predicate: nil, orderBy: CName, ascending: true)
        let arrRelation = arrData?.value(forKeyPath: CName) as? [Any]
        
        //...Prefill relation status
        if (arr?.count)! > 0 {
            let dict = arr![0] as? TblRelation
            txtStatus.text = dict?.name
          //  self.btnTextfiledClearStatus.isSelected = true
            self.relationShip = dict?.name ?? ""
        }
        
//        btnTextfiledClearStatus.touchUpInside { [weak self] (sender) in
//            guard let self = self else { return }
//            self.relationshipID = 0
//            self.btnTextfiledClearStatus.isSelected = false
//            self.txtStatus.text = nil
//            self.relationShip = ""
//            self.txtStatus.updatePlaceholderFrame(false)
//            self.txtStatus.resignFirstResponder()
//        }
        
        if arrRelation?.count != 0 {
            self.txtStatus.setPickerData(arrPickerData: arrRelation!, selectedPickerDataHandler: { [weak self] (text, row, component) in
                guard let self = self else { return }
               // self.btnTextfiledClearStatus.isSelected = true
                let dict = arrData![row] as AnyObject
                self.relationShip = dict.value(forKey: CName) as! String
            }, defaultPlaceholder: "")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotificationForItemEdit"), object: nil)
    }
    
    func loadAnnualIncomeList(){

        let arr = TblAnnualIncomes.fetch(predicate: NSPredicate(format: "%K == %s", CIncome,CIncome), orderBy: CIncome, ascending: true)
        let arrData = TblAnnualIncomes.fetch(predicate: nil, orderBy: CIncome, ascending: true)
        let arrIncome = arrData?.value(forKeyPath: CIncome) as? [Any]
        //...Prefill income
        if (arrData?.count)! > 0 {
            let dict = arrData![0] as? TblAnnualIncomes
            txtIncomeLevel.text = dict?.income
          //  self.btnTextfiledClearIncomLevel.isSelected = true
            self.inCome = dict?.income ?? ""
        }

//        btnTextfiledClearIncomLevel.touchUpInside { [weak self] (sender) in
//            guard let self = self else { return }
//            self.incomeID = 0
//            self.inCome = ""
//            self.btnTextfiledClearIncomLevel.isSelected = false
//            self.txtIncomeLevel.text = nil
//            self.txtIncomeLevel.updatePlaceholderFrame(false)
//            self.txtIncomeLevel.resignFirstResponder()
//        }

        if arrIncome?.count != 0 {
            self.txtIncomeLevel.setPickerData(arrPickerData: arrIncome!, selectedPickerDataHandler: { [weak self] (text, row, component) in
                guard let self = self else { return }
             //   self.btnTextfiledClearIncomLevel.isSelected = true
                let dict = arrData![row] as AnyObject
                self.inCome = dict.value(forKey: CIncome) as! String
            }, defaultPlaceholder: "")
        }
    }
    
    func loadEducationList() {
        let arr = TblEducation.fetch(predicate: NSPredicate(format: "%K == %s", CName, CName), orderBy: CName, ascending: true)
        let arrData = TblEducation.fetch(predicate: nil, orderBy: CName, ascending: true)
        let arrEducation = arrData?.value(forKeyPath: CName) as? [Any]

        //...Prefill education
        if (arr?.count)! > 0 {
            let dict = arr![0] as? TblEducation
            txtEducation.text = dict?.name
           // self.btnTextfiledClearEducation.isSelected = true
            self.educationName = (dict?.name ?? "")
        }

//        btnTextfiledClearEducation.touchUpInside { [weak self] (sender) in
//            guard let self = self else { return }
//            self.educationID = 0
//            self.educationName = ""
//            self.btnTextfiledClearEducation.isSelected = false
//            self.txtEducation.text = nil
//            self.txtEducation.updatePlaceholderFrame(false)
//            self.txtEducation.resignFirstResponder()
//        }

        if arrEducation?.count != 0 {
            self.txtEducation.setPickerData(arrPickerData: arrEducation!, selectedPickerDataHandler: { [weak self] (text, row, component) in
                guard let self = self else { return }
               // self.btnTextfiledClearEducation.isSelected = true
                let dict = arrData![row] as AnyObject
                self.educationName = (dict.name ?? "")
            }, defaultPlaceholder: "")
        }
    }
    //MARK: -
    @objc fileprivate func btnHelpInfoClicked(_ sender : UIBarButtonItem){
        if let helpLineVC = CStoryboardHelpLine.instantiateViewController(withIdentifier: "HelpLineViewController") as? HelpLineViewController {
            helpLineVC.fromVC = "ediProfileVC"
            self.navigationController?.pushViewController(helpLineVC, animated: true)
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
    
//    fileprivate func loadCountryList(){
//
//        self.txtCountrys.isEnabled = true
//        self.txtStates.isEnabled = false
//        self.txtCitys.isEnabled = false
//        self.showHideCountryStateCityFileds()
//        let arrCountry = TblCountry.fetch(predicate: nil, orderBy: CCountryName, ascending: true)
//        let arrCountryName = arrCountry?.value(forKeyPath: "country_name") as? [Any]
//
//        if (arrCountryName?.count)! > 0 {
//
//            txtCountrys.setPickerData(arrPickerData: arrCountryName!, selectedPickerDataHandler: { [weak self] (select, index, component) in
//                guard let self = self else { return }
//                let dict = arrCountry![index] as AnyObject
//                let countryName = dict.value(forKey: CCountryName) as? String
//                if countryName == self.countryName {
//                    self.countryName = dict.value(forKey: CCountryName) as? String
//              //  let countryID = dict.value(forKey: CCountry_id) as? Int
////                if countryID != self.countryID{
////                    self.countryID = dict.value(forKey: CCountry_id) as? Int
//                    self.txtStates.text = ""
//                    self.txtCitys.text = ""
//                    self.stateID = nil
//                    self.cityID = nil
//                    self.txtStates.isEnabled = false
//                    self.txtCitys.isEnabled = false
//                    self.showHideCountryStateCityFileds()
//                    self.loadStateList()
//                }
//            }, defaultPlaceholder: "")
//        }
//    }
    
    fileprivate func loadStateList(isCancelTask:Bool = true, completion:(()->Void)? = nil) {
        
//        func setStateList(arrState:[MDLState]){
//            let states = arrState.compactMap({$0.stateName})
//            self.txtStates.setPickerData(arrPickerData: states as [Any], selectedPickerDataHandler: { [weak self](text, row, component) in
//                guard let self = self else {return}
//                if arrState[row].stateName != self.stateName{
//                    self.stateName = arrState[row].stateName
//                    self.txtCitys.isEnabled = false
//                    self.txtCitys.text = ""
//                    self.showHideCountryStateCityFileds()
//                    self.loadCityList()
//                }
//
//            }, defaultPlaceholder: "")
//        }
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
                       // self.txtStates.isEnabled = false
                        //self.txtCitys.isEnabled = false
                        //self.txtStates.text = ""
                       // self.txtCitys.text = ""
                        self.btnUpdate.isEnabled = true
                    }else{
                       // self.txtStates.isEnabled = true
                    }
                    self.showHideCountryStateCityFileds()
                   // setStateList(arrState: arrState)
                    
                    completion?()
                }
            }else {
                print(error?.localizedDescription ?? "N/A")
            }
        }
    }
    
    fileprivate func loadCityList(isCancelTask:Bool = true, completion:(()->Void)? = nil) {
        
//        func setCityList(arrCity:[MDLCity]){
//            let states = arrCity.compactMap({$0.cityName})
//            self.txtCitys.setPickerData(arrPickerData: states as [Any], selectedPickerDataHandler: { [weak self](text, row, component) in
//                guard let self = self else {return}
//                self.cityID = arrCity[row].cityId
//            }, defaultPlaceholder: "")
//        }
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
                       // self.txtCitys.isEnabled = false
                       // self.txtCitys.text = ""
                    }else{
                       // self.txtCitys.isEnabled = true
                    }
                    self.showHideCountryStateCityFileds()
                   // setCityList(arrCity: arrCity)
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
//                if !self.txtStates.isEnabled{
//                    self.txtStates.superview?.alpha = 0
//                }else{
//                    self.txtStates.superview?.alpha = 1
//                }
//                if !self.txtCitys.isEnabled{
//                    self.txtCitys.superview?.alpha = 0
//                }else{
//                    self.txtCitys.superview?.alpha = 1
//                }
            }, completion: { (_) in
               // self.txtStates.superview?.isHidden = !self.txtStates.isEnabled
                //self.txtCitys.superview?.isHidden = !self.txtCitys.isEnabled
            })
        }
    }
}
//MARK:- ---------- API
extension EditProfileViewController {
    
    func editProfile() {
        
        var gender = 1
        if txtGender.text == CRegisterGenderMale {
            gender = CMale
        } else if txtGender.text == CRegisterGenderFemale {
            gender = CFemale
        } else {
            gender = COther
        }
        
        guard let langName = appDelegate.loginUser?.lang_name else {return}
        guard let userID = appDelegate.loginUser?.user_id else {return}
        print("self.txtDOB\(self.txtDOB)")
        
        if self.txtDOB.text?.range(of:"ಜನವರಿ") != nil{
            startDate = self.txtDOB.text?.replacingOccurrences(of: "ಜನವರಿ", with: "Jan") ?? ""
              }else if self.txtDOB.text?.range(of:"ಫೆಬ್ರವರಿ") != nil{
                  startDate = self.txtDOB.text?.replacingOccurrences(of: "ಫೆಬ್ರವರಿ", with: "Feb") ?? ""
              } else if self.txtDOB.text?.range(of:"ಮಾರ್ಚ್") != nil{
                  startDate = self.txtDOB.text?.replacingOccurrences(of: "ಮಾರ್ಚ್", with: "Mar") ?? ""
              }else if self.txtDOB.text?.range(of:"ಏಪ್ರಿ") != nil{
                  startDate = self.txtDOB.text?.replacingOccurrences(of: "ಏಪ್ರಿ", with: "Apr") ?? ""
              }else if self.txtDOB.text?.range(of:"ಮೇ") != nil{
                  startDate = self.txtDOB.text?.replacingOccurrences(of: "ಮೇ", with: "May") ?? ""
              }else if self.txtDOB.text?.range(of:"ಜೂನ್") != nil{
                  startDate = self.txtDOB.text?.replacingOccurrences(of: "ಜೂನ್", with: "Jun") ?? ""
              }else if self.txtDOB.text?.range(of:"ಜುಲೈ") != nil{
                  startDate = self.txtDOB.text?.replacingOccurrences(of: "ಜುಲೈ", with: "Jul") ?? ""
              }else if txtDOB.text?.range(of:"ಆಗ") != nil{
                  startDate = txtDOB.text?.replacingOccurrences(of: "ಆಗ", with: "Aug") ?? ""
              }else if txtDOB.text?.range(of:"ಸೆಪ್ಟೆಂ") != nil{
                  startDate = txtDOB.text?.replacingOccurrences(of: "ಸೆಪ್ಟೆಂ", with: "Sep") ?? ""
              }else if txtDOB.text?.range(of:"ಅಕ್ಟೋ") != nil{
                  startDate = txtDOB.text?.replacingOccurrences(of: "ಅಕ್ಟೋ", with: "Oct") ?? ""
              } else if txtDOB.text?.range(of:"ನವೆಂ") != nil{
                  startDate = txtDOB.text?.replacingOccurrences(of: "ನವೆಂ", with: "Nov") ?? ""
              }else if txtDOB.text?.range(of:"ಡಿಸೆಂ") != nil{
                  startDate = txtDOB.text?.replacingOccurrences(of: "ಡಿಸೆಂ", with: "Dec") ?? ""
              }else {
                  chngDate = self.txtDOB.text ?? ""
              }
        if startDate.range(of:"ಅಪರಾಹ್ನ") != nil{
            chngDate = startDate.replacingOccurrences(of: "ಅಪರಾಹ್ನ", with: "PM")
        }
        if startDate.range(of:"ಪೂರ್ವಾಹ್ನ") != nil{
            chngDate = startDate.replacingOccurrences(of: "ಪೂರ್ವಾಹ್ನ", with: "AM")
        }
        let txtprofession = txtProfession.text?.replace_str(replace: txtProfession.text ?? "")
        let txtreligion = txtReligion.text?.replace_str(replace: txtReligion.text ?? "")
        let dobconvert = DateFormatter.shared().convertDaterevers(strDate: chngDate)
        let dobupdateUserDtls = DateFormatter.shared().convertDatereveruserDetails(strDate: chngDate)
        let chgtimeFormat = "\(dobupdateUserDtls?.description ?? "" ) \(" GMT+0000 (Coordinated Universal Time)")"
        
        let encryptUser = EncryptDecrypt.shared().encryptDecryptModel(userResultStr: userID.description)
        let encryptEmail = EncryptDecrypt.shared().encryptDecryptModel(userResultStr: txtEmail.text ?? "")
        let encryptPhoneNo = EncryptDecrypt.shared().encryptDecryptModel(userResultStr: txtMobileNumber.text ?? "")

        var emplymenntStatus = 0
        var professionText = ""
        if btnEmployed.isSelected{
            emplymenntStatus = 1
            professionText = postProfession
        }else if btnUnEmployed.isSelected{
            emplymenntStatus = 2
            professionText = CBtnUnemployed
        }else if btnStudent.isSelected{
            emplymenntStatus = 3
            professionText = CBtnStudent
        }
        if !btnEmployed.isSelected{
            incomeID = 0
        }
        
        
        let dict :[String:Any]  =  [
           /* "user_acc_type":"1",
            "user_id": encryptUser,
            "first_name":txtFirstName.text ?? "",
            "last_name":txtLastName.text ?? "",
            "gender":String(appDelegate.loginUser!.gender),
            "religion":appDelegate.loginUser?.religion ?? "",
            "city_name":txtCitys.text ?? "",
            "profile_image":appDelegate.loginUser?.profile_img ?? "",
            "cover_image":appDelegate.loginUser?.cover_image ?? "",
           // "mobile":encryptPhoneNo,
          //  "email":encryptEmail,
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
            "status_id":"1",
            
            
            
            "user_acc_type":"1",
                "user_id": encryptUser,
                "email":txtEmail.text ?? "",
                "first_name":txtFirstName.text ?? "",
                "last_name":txtLastName.text ?? "",
                "gender":String(appDelegate.loginUser!.gender),
                "city_name":txtCitys.text ?? "",
                "profile_image":appDelegate.loginUser?.profile_img ?? "",
                "cover_image":appDelegate.loginUser?.cover_image ?? "",
                "religion": appDelegate.loginUser?.religion ?? "",
                "dob":dobconvert ?? "",
                "short_biography":appDelegate.loginUser?.short_biography ?? "",
                "relationship":appDelegate.loginUser?.relationship ?? "",
                "profession":appDelegate.loginUser?.profession ?? "",
                "address_line1":appDelegate.loginUser?.address ?? "",
                "latitude":0,
                "longitude":0,
                "user_type": "1",
                "employment_status": appDelegate.loginUser?.employment_status ?? 0,
                "education":appDelegate.loginUser?.education_name ?? "",
                "income":appDelegate.loginUser?.annual_income ?? "",
                "lang_name": langName,
                "status_id":"1"*/
            
            
            "user_acc_type":"1",
                "user_id": encryptUser,
                "email":txtEmail.text ?? "",
                "first_name":txtFirstName.text ?? "",
                "last_name":txtLastName.text ?? "",
                "gender":String(appDelegate.loginUser!.gender),
                "city_name":appDelegate.loginUser?.city ?? "",
                "profile_image":appDelegate.loginUser?.profile_img ?? "",
                "cover_image":appDelegate.loginUser?.cover_image ?? "",
                "religion": txtreligion ?? "",
                "dob":dobconvert ?? "",
                "short_biography":appDelegate.loginUser?.short_biography ?? "",
            "relationship":txtStatus.text ?? "",
                "profession":txtprofession ?? "",
                "address_line1":appDelegate.loginUser?.address ?? "",
                "latitude":0,
                "longitude":0,
                "user_type": "1",
                "employment_status": emplymenntStatus.description,
                "education":txtEducation.text ?? "",
                "income":inCome,
                "lang_name": langName,
                "status_id":"1"
            
            
            
            
        ]
        
        let dictUserDetails :[String:Any]  =  [
            
            "user_acc_type":"1",
            "first_name":txtFirstName.text ?? "",
            "last_name":txtLastName.text ?? "",
            "gender":String(appDelegate.loginUser!.gender),
            "city_name":appDelegate.loginUser?.city ?? "",
            "country_name":appDelegate.loginUser?.country ?? "",
            "state_name":appDelegate.loginUser?.state ?? "",
            "profile_image":appDelegate.loginUser?.profile_img ?? "",
            "cover_image":appDelegate.loginUser?.cover_image ?? "",
            "mobile":txtMobileNumber.text ?? "",
            "email":txtEmail.text ?? "",
            "dob":chgtimeFormat,
            "short_biography":appDelegate.loginUser?.short_biography ?? "",
            "relationship":txtStatus.text ?? "",
            "profession":txtprofession ?? "",
            "address_line1":appDelegate.loginUser?.address ?? "",
            "latitude":0,
            "longitude":0,
            "user_type": "1",
            "annual_income": inCome,
            "education_name":txtEducation.text ?? "",
            "employment_status":  emplymenntStatus ,
            "lang_name": langName,
            "status_id":"1",
            "user_id":userID.description,
            "religion" : txtreligion ?? ""
            
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
//                            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage:"Detials updated successfully", btnOneTitle: CBtnOk, btnOneTapped: nil)
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
        let encryptUser = EncryptDecrypt.shared().encryptDecryptModel(userResultStr: userID.description)
        let dict :[String:Any]  =  [
            CUserId: encryptUser,
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
        guard let userID = appDelegate.loginUser?.user_id else {return}
        let encryptUser = EncryptDecrypt.shared().encryptDecryptModel(userResultStr: userID.description)
        
       
        let dict :[String:Any]  =  [
            CUserId: encryptUser,
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
                        self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageUpdatedprofile, btnOneTitle: CBtnOk, btnOneTapped: { [weak self] (alert) in
                            self?.navigationController?.popViewController(animated: true)
                        })
                        //self.navigationController?.popViewController(animated: true)
                        break
                    } else if vwController.isKind(of: MyProfileViewController .classForCoder()){
                        MILoader.shared.hideLoader()
                        let profileVC = vwController as? MyProfileViewController
                        profileVC?.tblUser.reloadData()
                        self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageUpdatedprofile, btnOneTitle: CBtnOk, btnOneTapped: { [weak self] (alert) in
                            self?.navigationController?.popViewController(animated: true)
                        })
                        //self.navigationController?.popViewController(animated: true)
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
        
        if isProfileImg == true{
            guard let modileNum = appDelegate.loginUser?.mobile else {return}
            if self.imgUser.image != nil || self.imgUser.image == nil {
                self.presentActionsheetWithTwoButtons(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CRegisterChooseFromPhone, btnOneStyle: .default, btnOneTapped: { [weak self] (action) in
                    guard let self = self else { return }
                    self.presentImagePickerControllerForGallery(imagePickerControllerCompletionHandler: { [weak self] (image, info) in
                        guard let self = self else { return }
                        if image != nil{
                            self.uploadedImg = true
                            self.imgEditIcon.isHidden = false
                            self.imgUser.image = image
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
                                self.profileImgUrl = message
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                    self.uploadProfilePic()
                                })
                            }
                            
                        }
                        
                    })
                }, btnTwoTitle: CRegisterTakePhoto, btnTwoStyle: .default) { [weak self](alert) in
                    guard let _ = self else { return }
                    self?.presentImagePickerControllerForCamera(imagePickerControllerCompletionHandler: { [weak self] (image, info) in
                        guard let self = self else { return }
                        if image != nil{
                            self.uploadedImg = true
                            self.imgEditIcon.isHidden = false
                            self.imgUser.image = image
                            MInioimageupload.shared().uploadMinioimages(mobileNo: modileNum, ImageSTt: image!,isFrom:"",uploadFrom:"")
                            MInioimageupload.shared().callback = { message in
                                self.profileImgUrl = message
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                    self.uploadProfilePic()
                               })
                            }
                        }
                    })
                }
                
                
            }
        }else{
            guard let modileNum = appDelegate.loginUser?.mobile else {return}
            if self.imgUser.image != nil {
                self.presentActionsheetWithThreeButton(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CRegisterChooseFromPhone, btnOneStyle: .default, btnOneTapped: { [weak self] (action) in
                    guard let self = self else { return }
                    
                    self.presentImagePickerControllerForGallery(imagePickerControllerCompletionHandler: { [weak self] (image, info) in
                        guard let self = self else { return }
                        if image != nil{
                            self.uploadedImg = true
                            self.imgEditIcon.isHidden = false
                            self.imgUser.image = image
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
                            MInioimageupload.shared().uploadMinioimages(mobileNo: modileNum, ImageSTt: image!,isFrom:"",uploadFrom:"")
                            MInioimageupload.shared().callback = { message in
                                self.profileImgUrl = message
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                    self.uploadProfilePic()
                               })
                            }
                        }
//                        if image != nil{
//                            self.uploadedImg = true
//                            self.imgEditIcon.isHidden = false
//                            self.imgUser.image = image
//                            self.uploadProfilePic()
//                        }
                    })
                }, btnThreeTitle: CRegisterRemovePhoto, btnThreeStyle: .default) { [weak self] (action) in
                    guard let self = self else { return }

     //                self.coverImgUrl = "https://qa.sevenchats.com:3443/sevenchats/CoverImage/IOS1643088311733.png"
                    self.imgUser.image = UIImage(named: "CoverImage.png")
                    self.imgEditIcon.isHidden = true
                    self.uploadProfilePic()
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
        
    }
    @IBAction func btnUploadCoverCLK (_ sender : UIButton) {
        if isCoverImg == true{
            guard let modileNum = appDelegate.loginUser?.mobile else {return}
            if self.imgCover.image != nil {
                self.presentActionsheetWithTwoButtons(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CRegisterChooseFromPhone, btnOneStyle: .default, btnOneTapped: { [weak self] (action) in
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
                }, btnTwoTitle: CRegisterTakePhoto, btnTwoStyle: .default) { [weak self](alert) in
                    guard let _ = self else { return }
                    self?.presentImagePickerControllerForCamera(imagePickerControllerCompletionHandler: { [weak self] (image, info) in
                        guard let self = self else { return }
                        if image != nil{
                            self.coverImg = true
                            self.CoverEditIcon.isHidden = false
                            self.imgCover.image = image
                            MInioimageupload.shared().uploadMinioimages(mobileNo: modileNum, ImageSTt: image!,isFrom:"",uploadFrom:"")
                            MInioimageupload.shared().callback = { message in
                                self.coverImgUrl = message
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                    self.uploadCoverPic()
                               })
                            }
                        }
//                        if image != nil{
//                            self.coverImg = true
//                            self.CoverEditIcon.isHidden = false
//                            self.imgCover.image = image
//                            self.uploadCoverPic()
//                        }
                    })
                }
                
                
            }
        }else{
            guard let modileNum = appDelegate.loginUser?.mobile else {return}
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
                            MInioimageupload.shared().uploadMinioimages(mobileNo: modileNum, ImageSTt: image!,isFrom:"",uploadFrom:"")
                            MInioimageupload.shared().callback = { message in
                                self.coverImgUrl = message
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                    self.uploadCoverPic()
                               })
                            }
                        }
//                        if image != nil{
//                            self.coverImg = true
//                            self.CoverEditIcon.isHidden = false
//                            self.imgCover.image = image
//                            self.uploadCoverPic()
//                        }
                    })
                }, btnThreeTitle: CRegisterRemovePhoto, btnThreeStyle: .default) { [weak self] (action) in
                    guard let self = self else { return }

    //                self.coverImgUrl = "https://qa.sevenchats.com:3443/sevenchats/CoverImage/IOS1643088311733.png"
                    self.imgCover.image = UIImage(named: "CoverImage.png")
                    self.CoverEditIcon.isHidden = true
                    self.uploadCoverPic()
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
    }
   /* @IBAction func btnUploadImageCLK(_ sender : UIButton){
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
                }, btnThreeTitle: CRegisterRemovePhoto, btnThreeStyle: .default) { [weak self] (action) in
                    guard let self = self else { return }
                    
                    //Name To image Convert Future version
//                    let frstNameltr = (self.txtFirstName.text?.first)!
//                    let convStrName = String(frstNameltr)
//                    let text = convStrName
//                    let attributes = [
//                        NSAttributedString.Key.foregroundColor: UIColor.white,
//                        NSAttributedString.Key.backgroundColor:#colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1),
//                        NSAttributedString.Key.font: UIFont.init(name: "AmericanTypewriter-Semibold", size: 40),
//                    ]
//                    let textSize = text.size(withAttributes: attributes)
//                    UIGraphicsBeginImageContextWithOptions(textSize, true, 0)
//                    text.draw(at: CGPoint.zero, withAttributes: attributes)
//                    let image = UIGraphicsGetImageFromCurrentImageContext()
//                    UIGraphicsEndImageContext()
                    self.isremovedImage = true
//                    self.imgUser.image = image
                    CUserDefaults.set(2, forKey:"imageReplaced")
                    CUserDefaults.synchronize()
                    self.imgEditIcon.isHidden = true
//                    self.uploadProfilePic()
                    
                    self.profileImgUrl = "https://qa.sevenchats.com:3443/sevenchats/ProfilePic/IOS1643090910947.png"
                        self.uploadProfilePic()
                    self.imgUser.image = UIImage(named: "user_placeholder.png")
                    
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
                        self.uploadCoverPic()
                    }
                })
            }, btnThreeTitle: CRegisterRemovePhoto, btnThreeStyle: .default) { [weak self] (action) in
                guard let self = self else { return }

                self.coverImgUrl = "https://qa.sevenchats.com:3443/sevenchats/CoverImage/IOS1643088311733.png"
                self.imgCover.image = UIImage(named: "CoverImage.png")
                self.CoverEditIcon.isHidden = true
                self.uploadCoverPic()
                
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
    }*/
    
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
//        if (txtEmail.text?.isBlank)! {
//            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CRegisterAlertEmailBlank, btnOneTitle: CBtnOk, btnOneTapped: nil)
//            return
//        }
//        if !(txtEmail.text?.isValidEmail)! {
//            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CRegisterAlertValidEmail, btnOneTitle: CBtnOk, btnOneTapped: nil)
//            return
//        }
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
        //if (txtCountrys.text?.isEmpty ?? true) && JSON(rawValue: (countryName ?? "")) ?? "" == 0{
//        if (txtCountrys.text?.isBlank)!{
//            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CBlankCountry, btnOneTitle: CBtnOk, btnOneTapped: nil)
//            return
//        }
        //if !(txtStates.superview?.isHidden ?? true) && JSON(rawValue: (stateName ?? "")) ?? "" == 0{
//        if (txtStates.text?.isBlank)!{
//            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CBlankState, btnOneTitle: CBtnOk, btnOneTapped: nil)
//            return
//        }
        //if !(txtCitys.superview?.isHidden ?? true) && JSON(rawValue: (cityName ?? "")) ?? "" == 0{
//        if (txtCitys.text?.isBlank)!{
//            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CBlankCity, btnOneTitle: CBtnOk, btnOneTapped: nil)
//            return
//        }
        let charSet = CharacterSet.init(charactersIn: SPECIALCHARNOTALLOWED)
        if (self.txtFirstName.text?.rangeOfCharacter(from: charSet) != nil) || (self.txtLastName.text?.rangeOfCharacter(from: charSet) != nil)
            {
                print("true")
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageSpecial, btnOneTitle: CBtnOk, btnOneTapped: nil)
                return
            }else{
                self.editProfile()
            }
//        if self.txtFirstName.text != "" && self.txtLastName.text != "" {
//            let characterset = CharacterSet(charactersIn:SPECIALCHAR)
//            if self.txtFirstName.text?.rangeOfCharacter(from: characterset.inverted) != nil || self.txtLastName.text?.rangeOfCharacter(from: characterset.inverted) != nil  {
//                print("contains Special charecter")
//                if txtFirstName.text != "" || txtLastName.text != "" {
//                postFirstName = removeSpecialCharacters(from: txtFirstName.text!)
//                postLastName = removeSpecialCharacters(from: txtLastName.text!)
//
//              }
//              self.editProfile()
//            } else {
//               print("false")
//                postFirstName = txtFirstName.text ?? ""
//                postLastName = txtLastName.text ?? ""
//                self.editProfile()
//            }
//        }
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
    
    @IBAction func btnProfessionCLK(_ sender : UIButton){
        
        switch sender.tag {
        case 0:
            btnEmployed.isSelected = !btnEmployed.isSelected
            btnUnEmployed.isSelected = false
            btnStudent.isSelected = false
            break
        case 1:
            btnUnEmployed.isSelected = !btnUnEmployed.isSelected
            btnEmployed.isSelected = false
            btnStudent.isSelected = false
            break
        case 2:
            btnStudent.isSelected = !btnStudent.isSelected
            btnEmployed.isSelected = false
            btnUnEmployed.isSelected = false
            break
            
        default:
            break
        }
        if btnEmployed.isSelected{
            self.vwProfessionAndIncome.hide(byHeight: false)
            
        }else{
            self.vwProfessionAndIncome.hide(byHeight: true)
        }
        GCDMainThread.async {
          //  self.txtProfession.updateBottomLineAndPlaceholderFrame()
        }
        
    }

}
extension EditProfileViewController: GenericTextFieldDelegateNew {
    
    @objc func genericTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtFirstName || textField == txtLastName {
            if string.isSingleEmoji {
                return (string == string)
            }else {
                if string.count <= 20{
                    let inverted = NSCharacterSet(charactersIn: SPECIALCHARNOTALLOWED).inverted

                        let filtered = string.components(separatedBy: inverted).joined(separator: "")
                    
                        if (string.isEmpty  && filtered.isEmpty ) {
                                    let isBackSpace = strcmp(string, "\\b")
                                    if (isBackSpace == -92) {
                                        print("Backspace was pressed")
                                        return (string == filtered)
                                    }
                        } else {
                            return (string != filtered)
                        }

                }else{
                    return (string == "")
                }
            }
            if textField == txtReligion || txtProfession == txtProfession{
                if txtReligion.text?.count ?? 0 > 20{
                    return false
                }
                if string.isSingleEmoji {
                    return (string == string)
                }else {
                    if string.count <= 20{
                        return (string == string)
                    }
                }
            }
            if txtProfession == txtProfession{
                if txtProfession.text?.count ?? 0 > 20{
                    return false
                }
                if string.isSingleEmoji {
                    return (string == string)
                }else {
                    if string.count <= 20{
                        return (string == string)
                    }
                }
            }
        }
        //MARK: - NEW
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
                lblCode.isHidden = false
                downarrow.isHidden = false
            }else{
                cnTxtEmailLeading.constant = 20
                txtCountryCode.isHidden = true
                lblCode.isHidden = true
                downarrow.isHidden = true
            }
            self.view.layoutIfNeeded()
            
            GCDMainThread.async {
              // self.txtMobileNumber.updateBottomLineAndPlaceholderFrame()
            }
            return true
        }
        if textField == txtMobileNumber{
            if updatedText.isValidPhoneNo && !updatedText.isBlank{
                if textField.text?.count ?? 0 >= 15{
                    return false
                }
                cnTxtEmailLeading.constant = txtCountryCode.bounds.width + 30
                // cnTxtEmailLeading.constant = 20
                txtCountryCode.isHidden = false
                lblCode.isHidden = false
                downarrow.isHidden = false
            }else{
                cnTxtEmailLeading.constant = 20
                txtCountryCode.isHidden = true
                lblCode.isHidden = true
                downarrow.isHidden = true
            }
            self.view.layoutIfNeeded()
            
            GCDMainThread.async {
               //self.txtMobileNumber.updateBottomLineAndPlaceholderFrame()
            }
    }
        //MARK: - NEW
        return true
    }
 //MARK: - NEW
        func genericTextFieldDidChange(_ textField : UITextField){
            if textField == txtMobileNumber{
                if (txtMobileNumber.text?.isValidPhoneNo)! && !(txtMobileNumber.text?.isBlank)!{
                    
                    cnTxtEmailLeading.constant = txtCountryCode.bounds.width + 30
                    txtCountryCode.isHidden = false
                    lblCode.isHidden = false
                    downarrow.isHidden = false
                }else{
                    cnTxtEmailLeading.constant = 20
                    txtCountryCode.isHidden = true
                    lblCode.isHidden = true
                    downarrow.isHidden = true
                }
                self.view.layoutIfNeeded()
                
                GCDMainThread.async {
                 //  self.txtMobileNumber.updateBottomLineAndPlaceholderFrame()
                }
            }
        }
    func genericTextFieldClearText(_ textField: UITextField){
        if textField == txtMobileNumber{
            cnTxtEmailLeading.constant = 20
            txtCountryCode.isHidden = true
            self.view.layoutIfNeeded()
            GCDMainThread.async {
             //self.txtMobileNumber.updateBottomLineAndPlaceholderFrame()
            }
        }
    }
    //MARK: - NEW
}
extension EditProfileViewController {
func removeSpecialCharacters(from text: String) -> String {
    let okayChars = CharacterSet(charactersIn: SPECIALCHAR)
    return String(text.unicodeScalars.filter { okayChars.contains($0) || $0.properties.isEmoji })
}
    
}

