//
//  CompleteProfileViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 29/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : EditProfileViewController                   *
 * Changes :                                             *
 *                                                       *
 ********************************************************/

import UIKit

class CompleteProfileViewController: ParentViewController, GenericTextViewDelegate {
    
    @IBOutlet var txtViewBiography : GenericTextView!{
        didSet{
            txtViewBiography.txtDelegate = self
            txtViewBiography.type = "1"
        }
    }
    @IBOutlet var txtStatus : MIGenericTextFiled!
    @IBOutlet var txtEducation : MIGenericTextFiled!
    @IBOutlet var txtReligion : MIGenericTextFiled!
    @IBOutlet var txtProfession : MIGenericTextFiled!
    @IBOutlet var txtIncomeLevel : MIGenericTextFiled!
    @IBOutlet var txtGender : MIGenericTextFiled!
    @IBOutlet var lblPersonalInterest : UILabel!
    @IBOutlet var lblProfession : UILabel!
    @IBOutlet var viewAddInterest : UIView!
    @IBOutlet var scrollViewContainer : UIView!
    @IBOutlet var clInterest : UICollectionView!
    @IBOutlet var btnEmployed : UIButton!
    @IBOutlet var btnUnEmployed : UIButton!
    @IBOutlet var btnStudent : UIButton!
    @IBOutlet var btnAddInterest : UIButton!
    @IBOutlet var btnTextfiledClearStatus : UIButton!
    @IBOutlet var btnTextfiledClearEducation : UIButton!
    @IBOutlet var btnTextfiledClearIncomLevel : UIButton!
    @IBOutlet var vwProfessionAndIncome : UIView!
    @IBOutlet var scrollView : UIScrollView!
    
    var arrInterest = [[String : Any]]()
    var relationshipID = 0
    var incomeID = 0
    var educationID = 0
    var educationName = ""
    var relationShip = ""
    var inCome = ""
    var currentPage : Int = 0
    var apiTask : URLSessionTask?
    var firstName_edit:String?
    var lastName_edit:String?
    var dob_edit:String?
    var isSelected:Bool?
    var category_id = ""
    var addRewardCategory = [String]()
    var postProfession = ""
    var postBiography = ""
    var postReligion = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialization()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateUIAccordingToLanguage()
        btnAddInterest.isHidden = true
        viewAddInterest.isHidden = true
        lblPersonalInterest.isHidden = true
        viewAddInterest.backgroundColor = .clear
        
        rewardsCategory()
    }
    
    // MARK:- ---------- Initialization
    
    func Initialization(){
        
        self.title = CNavCompleteProfile
        txtReligion.txtDelegate = self
        txtProfession.txtDelegate = self
        viewAddInterest.layer.cornerRadius = 3
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_save_profile"), style: .plain, target: self, action: #selector(btnCompleteClicked(_:)))
        self.prefilledUserDetail()
        txtGender.setPickerData(arrPickerData: [CRegisterGenderMale, CRegisterGenderFemale ,CRegisterGenderOther], selectedPickerDataHandler: { (text, row, component) in
        }, defaultPlaceholder: "")
        
    }
    
    func updateUIAccordingToLanguage(){
        
        if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
            // Reverse Flow...
            btnEmployed.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 3)
            btnEmployed.contentHorizontalAlignment = .right
            
            btnUnEmployed.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 3)
            btnUnEmployed.contentHorizontalAlignment = .right
            
            btnStudent.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 3)
            btnStudent.contentHorizontalAlignment = .right
            
            clInterest.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }else{
            // Normal Flow...
            btnEmployed.titleEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 0)
            btnEmployed.contentHorizontalAlignment = .left
            
            btnUnEmployed.titleEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 0)
            btnUnEmployed.contentHorizontalAlignment = .left
            
            btnStudent.titleEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 0)
            btnStudent.contentHorizontalAlignment = .left
            
            clInterest.transform = CGAffineTransform.identity
        }
        
        txtViewBiography.placeHolder = CProfilePlaceholderBiography
        txtGender.placeHolder = CRegisterPlaceholderGender
        txtStatus.placeHolder = CProfilePlaceholderStatus
        txtEducation.placeHolder = CProfilePlaceholderEducation
        txtReligion.placeHolder = CProfilePlaceholderReligiousInclination
        txtProfession.placeHolder = CProfilePlaceholderEnterProfession
        txtIncomeLevel.placeHolder = CProfilePlaceholderReligiousIncomeLevel
        lblPersonalInterest.text = CProfilePlaceholderReligiousPersonalInterest
        lblProfession.text = CProfilePlaceholderProfession
        btnAddInterest.setTitle("+" + "    " + CBtnAddYourInterest, for: .normal)
        btnEmployed.setTitle(CProfilePlaceholderEmployed, for: .normal)
        btnUnEmployed.setTitle(CBtnUnemployed, for: .normal)
        btnStudent.setTitle(CBtnStudent, for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.scrollView.contentOffset = CGPoint.zero
        }
    }
    
    func prefilledUserDetail() {
        
        self.loadRelationList()
        self.loadAnnualIncomeList()
        self.loadEducationList()
        
        txtViewBiography.text = appDelegate.loginUser?.short_biography
        txtReligion.text = appDelegate.loginUser?.religion
        if appDelegate.loginUser?.relationship == "null"{
            txtStatus.text = ""
        }else {
            txtStatus.text = appDelegate.loginUser?.relationship
        }
        
        if appDelegate.loginUser?.education_name == "null"{
            txtEducation.text  = ""
        }else {
            txtEducation.text  = appDelegate.loginUser?.education_name
        }
        
        if appDelegate.loginUser?.annual_income == "null"{
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
            
            if !(self.txtViewBiography.text?.isBlank)! {
                self.txtViewBiography.updatePlaceholderFrame(true)
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
        guard let addIntrest = appDelegate.loginUser?.interests as? [[String : AnyObject]] else {
            return
        }
        arrInterest = addIntrest
        clInterest.reloadData()
    }
    
    
    func loadRelationList(){
        
        let arr = TblRelation.fetch(predicate: NSPredicate(format: "%K == %s", CName, CName), orderBy:CName, ascending: true)
        let arrData = TblRelation.fetch(predicate: nil, orderBy: CName, ascending: true)
        let arrRelation = arrData?.value(forKeyPath: CName) as? [Any]
        
        //...Prefill relation status
        if (arr?.count)! > 0 {
            let dict = arr![0] as? TblRelation
            txtStatus.text = dict?.name
            self.btnTextfiledClearStatus.isSelected = true
            self.relationShip = dict?.name ?? ""
        }
        
        btnTextfiledClearStatus.touchUpInside { [weak self] (sender) in
            guard let self = self else { return }
            self.relationshipID = 0
            self.btnTextfiledClearStatus.isSelected = false
            self.txtStatus.text = nil
            self.relationShip = ""
            self.txtStatus.updatePlaceholderFrame(false)
            self.txtStatus.resignFirstResponder()
        }
        
        if arrRelation?.count != 0 {
            self.txtStatus.setPickerData(arrPickerData: arrRelation!, selectedPickerDataHandler: { [weak self] (text, row, component) in
                guard let self = self else { return }
                self.btnTextfiledClearStatus.isSelected = true
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
            self.btnTextfiledClearIncomLevel.isSelected = true
            self.inCome = dict?.income ?? ""
        }
        
        btnTextfiledClearIncomLevel.touchUpInside { [weak self] (sender) in
            guard let self = self else { return }
            self.incomeID = 0
            self.inCome = ""
            self.btnTextfiledClearIncomLevel.isSelected = false
            self.txtIncomeLevel.text = nil
            self.txtIncomeLevel.updatePlaceholderFrame(false)
            self.txtIncomeLevel.resignFirstResponder()
        }
        
        if arrIncome?.count != 0 {
            self.txtIncomeLevel.setPickerData(arrPickerData: arrIncome!, selectedPickerDataHandler: { [weak self] (text, row, component) in
                guard let self = self else { return }
                self.btnTextfiledClearIncomLevel.isSelected = true
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
            self.btnTextfiledClearEducation.isSelected = true
            self.educationName = (dict?.name ?? "")
        }
        
        btnTextfiledClearEducation.touchUpInside { [weak self] (sender) in
            guard let self = self else { return }
            self.educationID = 0
            self.educationName = ""
            self.btnTextfiledClearEducation.isSelected = false
            self.txtEducation.text = nil
            self.txtEducation.updatePlaceholderFrame(false)
            self.txtEducation.resignFirstResponder()
        }
        
        if arrEducation?.count != 0 {
            self.txtEducation.setPickerData(arrPickerData: arrEducation!, selectedPickerDataHandler: { [weak self] (text, row, component) in
                guard let self = self else { return }
                self.btnTextfiledClearEducation.isSelected = true
                let dict = arrData![row] as AnyObject
                self.educationName = (dict.name ?? "")
            }, defaultPlaceholder: "")
        }
    }
}

// MARK:- --------- UICollectionView Delegate/Datasources
extension CompleteProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrInterest.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BubbleWithCancelCollCell", for: indexPath) as! BubbleWithCancelCollCell
        let strCat = arrInterest[indexPath.row].valueForString(key: "interest_type")
        cell.lblBubbleText.text = strCat
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        arrInterest.remove(at: indexPath.row)
        clInterest.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let fontToResize =  CFontPoppins(size: 12, type: .light).setUpAppropriateFont()
        let title = arrInterest[indexPath.row].valueForString(key: "interest_type")
        var size = title.size(withAttributes: [NSAttributedString.Key.font: fontToResize!])
        size.width = CGFloat(ceilf(Float(size.width + 65)))
        size.height = clInterest.frame.size.height
        return size
    }
}

// MARK:- ------------ API
extension CompleteProfileViewController{
    
    func completeProfile() {
        
        var gender = 1
        if txtGender.text == CRegisterGenderMale {
            gender = CMale
        } else if txtGender.text == CRegisterGenderFemale {
            gender = CFemale
        } else {
            gender = COther
        }
        var interestID = ""
        if arrInterest.count > 0 {
            interestID = arrInterest.map({"\($0.valueForInt(key: "id") ?? 0)"}).joined(separator: ",")
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = DateFormatter.shared().locale
        let user_acc_type = "1"
        var emplymenntStatus = 0
        var professionText = ""
        if btnEmployed.isSelected{
            emplymenntStatus = 1
            professionText = txtProfession.text ?? ""
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
        var dict : [String:Any] = [
            CFirstname : appDelegate.loginUser?.first_name ?? "",
            CLastname : appDelegate.loginUser?.last_name ?? "",
            CDob : dob_edit ?? "" ,
            CShort_biography : txtViewBiography.text ?? "",
            CGender : gender,
            CRelationship_id : relationshipID,
            CAnnual_income_id : incomeID,
            CEducation_id : educationID,
            CReligion : txtReligion.text ?? "",
            CEmployment_status : emplymenntStatus,
            CProfession : professionText,
            CInterest_ids : interestID
        ]
        guard let langName = appDelegate.loginUser?.lang_name else {return}
        guard let userID = appDelegate.loginUser?.user_id else {return}
        guard let txtCity = appDelegate.loginUser?.city else {return}
        guard let txtmobile = appDelegate.loginUser?.mobile else {return}
        guard let txtemail = appDelegate.loginUser?.email else {return}
        
        
        let dictcomp:[String:Any] = [
            "user_acc_type":user_acc_type,
            "first_name":firstName_edit ?? "",
            "last_name":lastName_edit ?? "",
            "gender":gender.toString,
            "religion":txtReligion.text ?? "",
            "city_name":txtCity,
            "profile_image":appDelegate.loginUser?.profile_img ?? "",
            "cover_image":appDelegate.loginUser?.cover_image ?? "",
            "mobile":txtmobile,
            "email":txtemail,
            "education":txtEducation.text ?? "",
            "dob":dob_edit ?? "",
            "short_biography":txtViewBiography.text ?? "",
            "relationship":txtStatus.text ?? "",
            "profession":professionText,
            "address_line1":txtCity,
            "latitude":0,
            "longitude":0,
            "user_type": "1",
            "lang_name": langName,
            "status_id":"1",
            "income":inCome,
            "employment_status":emplymenntStatus.description
        ]
        
        
        let dictUserDetails:[String:Any] = [
            "user_acc_type":user_acc_type,
            "first_name":firstName_edit ?? "",
            "last_name":lastName_edit ?? "",
            "gender":gender.toString,
            "religion":txtReligion.text ?? "",
            "city_name":txtCity,
            "profile_image":appDelegate.loginUser?.profile_img ?? "",
            "cover_image":appDelegate.loginUser?.cover_image ?? "",
            "mobile":txtmobile,
            "email":txtemail,
            "dob":dob_edit ?? "",
            "short_biography":txtViewBiography.text ?? "",
            "relationship":txtStatus.text ?? "",
            "profession":txtProfession.text ?? "",
            "address_line1":txtCity,
            "latitude":0,
            "longitude":0,
            "user_type": "1",
            "lang_name": langName,
            "status_id":"1",
            "user_id":userID.description,
            "country_name":appDelegate.loginUser?.country ?? "",
            "state_name":appDelegate.loginUser?.state ?? "",
            "education_name":txtEducation.text ?? "",
            "employment_status":emplymenntStatus.description,
            "annual_income" : inCome,
            
        ]
        
        
        APIRequest.shared().editProfile(dict: dictcomp as [String : AnyObject], para: dictUserDetails as [String : AnyObject], userID:userID.description, dob: userID.description ) { [self] (response, error) in
            if response != nil && error == nil {
                
                let lastname = self.lastName_edit ?? ""
                let firstName = self.firstName_edit ?? ""
                let gender = gender.toString
                let religion = self.txtReligion.text ?? ""
                let profile = appDelegate.loginUser?.profile_img ?? ""
//                let cover = appDelegate.loginUser?.cover_image ?? ""
                let dob = self.dob_edit ?? ""
                let bio = self.txtViewBiography.text ?? ""
                let reltionship  = self.txtStatus.text ?? ""
                let latitude  = 0
                let lang = 0
                let user_type = "1"
                let status_id = "1"
                let income = self.inCome
                let user_id = userID.description
                let country_name = appDelegate.loginUser?.country ?? ""
                let state_name = appDelegate.loginUser?.state ?? ""
                let education = txtEducation.text ?? ""
                
                if !lastname.isEmpty && !firstName.isEmpty && !user_acc_type.isEmpty && !gender.isEmpty && !religion.isEmpty && !txtCity.isEmpty && !profile.isEmpty && !txtmobile.isEmpty && !txtemail.isEmpty && !dob.isEmpty && !bio.isEmpty && !reltionship.isEmpty && !professionText.isEmpty && !txtCity.isEmpty && !latitude.description.isEmpty && !lang.description.isEmpty && !user_type.isEmpty && !status_id.isEmpty && !langName.isEmpty && !emplymenntStatus.description.isEmpty && !income.isEmpty && !user_id.isEmpty && !country_name.isEmpty && !state_name.isEmpty  && !education.isEmpty{
                    self.getRewardsDetail(isLoader:true)
                }
               
                let metaInfo = response![CJsonMeta] as? [String:Any] ?? [:]
                let message = metaInfo["status"] as? String ?? "0"
                if message == "0"{
                    self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageUpdatedprofile, btnOneTitle: CBtnOk, btnOneTapped: { [weak self] (alert) in
                        self?.navigationController?.popViewController(animated: true)
                    })
                }
                
            }
            
        }
    }
    
    
    func getRewardsDetail(isLoader: Bool) {
        
        self.currentPage = 1
        if apiTask?.state == URLSessionTask.State.running {
            return
        }
        
        //        if BASEURL_Rew == "QA"{
        //            category_id = "44953672"
        //        }else {
        //            category_id = "1007720"
        //        }
        var dict = [String:Any]()
        guard let userID = appDelegate.loginUser?.user_id.description else { return}
        dict["user_id"] = userID
        dict["category_id"] = category_id
        dict["page"] = "1"
        dict["limit"] = "20"
        addRewardCategory.removeAll()
        apiTask = APIRequest.shared().rewardsDetail(param:dict,showLoader: isLoader) { [weak self] (response, error) in
            guard let self = self else { return }
            
            if response != nil {
                GCDMainThread.async {
                    if self.currentPage == 1 {
                    }
                    self.currentPage += 1
                    let arrData = response!["rewards_history"] as? [String : Any] ?? [:]
                    let arrDatas = arrData["rewards_history"] as? [[String : Any]] ?? [[:]]
                    for arrDataPoint in arrDatas{
                        let rewardCatg = arrDataPoint["type"] as? String
                        self.addRewardCategory.append(rewardCatg ?? "")
                    }
                    if self.addRewardCategory.contains("Complete profile") {
                        return
                    }
                    else{
                        let name = (appDelegate.loginUser?.first_name ?? "") + " " + (appDelegate.loginUser?.last_name ?? "")
                        guard let image = appDelegate.loginUser?.profile_img else { return }
                        MIGeneralsAPI.shared().addRewardsPoints(CCompleteprofile,message:"Complete profile",type:CCompleteprofile,title:"Complete profile",name:name,icon:image, detail_text: "complete_profile_point",target_id:0)
                       
                    }
                }
            }
        }
    }
    
    func rewardsCategory(){
        let timestamp : TimeInterval = 0
        APIRequest.shared().loadRewardsCategory(timestamp:timestamp as AnyObject) { (response, error) in
            if response != nil && error == nil {
                if let data = response![CJsonData] as? [[String : Any]]{
                    for infora in data{
                        if infora.valueForString(key: "category_name") == "Profile"{
                            self.category_id = infora.valueForString(key: "category_id")
                            
                        }
                    }
                }
            }
        }
    }
    
    
}

// MARK:- ------------ Action Event
extension CompleteProfileViewController{
    
    @objc fileprivate func btnCompleteClicked(_ sender : UIBarButtonItem) {
        if self.txtProfession.text != "" || self.txtViewBiography.text != "" || self.txtReligion.text != ""{
            let characterset = CharacterSet(charactersIn:SPECIALCHAR)
            if self.txtProfession.text?.rangeOfCharacter(from: characterset.inverted) != nil || self.txtViewBiography.text?.rangeOfCharacter(from: characterset.inverted) != nil || self.txtReligion.text?.rangeOfCharacter(from: characterset.inverted) != nil {
                print("contains Special charecter")
              postBiography = removeSpecialCharacters(from: txtViewBiography.text)
                if txtReligion.text != "" || txtProfession.text != "" {
                  postReligion = removeSpecialCharacters(from: txtReligion.text!)
                postProfession = removeSpecialCharacters(from: txtProfession.text!)
                  print("specialcCharecte\(postProfession)")
              }
              self.completeProfile()
            } else {
               print("false")
                self.completeProfile()
            }
        }
//        self.completeProfile()
    }
    
    @IBAction func btnAddInterestCLK(_ sender : UIButton){
        
        let objInterest : SelectInterestsViewController = CStoryboardLRF.instantiateViewController(withIdentifier: "SelectInterestsViewController") as! SelectInterestsViewController
        objInterest.isBackButtomHide = false
        objInterest.arrSelectedInterest = arrInterest
        self.navigationController?.pushViewController(objInterest, animated: true)
        
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
            self.txtProfession.updateBottomLineAndPlaceholderFrame()
        }
        
    }
}

extension Optional where Wrapped == String {
    func isEmptyOrWhitespace() -> Bool {
        // Check nil
        guard let this = self else { return true }
        
        // Check empty string
        if this.isEmpty {
            return true
        }
        // Trim and check empty string
        return (this.trimmingCharacters(in: .whitespaces) == "")
    }
}
//MARK: - GenericTextFieldDelegate
extension CompleteProfileViewController : GenericTextFieldDelegate{
    
    func genericTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        
        if textField == txtReligion || txtProfession == txtProfession{
            if txtReligion.text?.count ?? 0 > 20{
                return false
            }
            if string.isSingleEmoji {
                return (string == string)
            }else {
                
                let cs = NSCharacterSet(charactersIn: SPECIALCHAR).inverted
                let filtered = string.components(separatedBy: cs).joined(separator: "")
                return (string == filtered)
            }
        }
        return true
    }
}
extension CompleteProfileViewController {
func removeSpecialCharacters(from text: String) -> String {
    let okayChars = CharacterSet(charactersIn: SPECIALCHAR)
    return String(text.unicodeScalars.filter { okayChars.contains($0) || $0.properties.isEmoji })
}
}
