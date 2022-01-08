//
//  AddEventViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 21/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit
import CoreLocation

enum EventType : Int {
    case addEvent = 0
    case editEvent = 1
}

let CDateFormat =  "dd MMM yyyy, hh:mm a"

class AddEventViewController: ParentViewController {
    
    var eventType : EventType!
    
    @IBOutlet weak var viewAddImageContainer : UIView!
    @IBOutlet weak var viewUploadedImageContainer : UIView!
    @IBOutlet weak var scrollViewContainer : UIView!
    @IBOutlet weak var imgEvent : UIImageView!
    @IBOutlet weak var btnAddMoreFriends : UIButton!
    
    @IBOutlet weak var categoryDropDownView: CustomDropDownView!
    @IBOutlet weak var btnSelectGroupFriend : UIButton!
    @IBOutlet weak var viewSelectGroup : UIView!
    @IBOutlet weak var clGroupFriend : UICollectionView!
    
    @IBOutlet weak var txtViewContent : GenericTextView!{
        didSet{
            self.txtViewContent.txtDelegate = self
            self.txtViewContent.isScrollEnabled = true
            self.txtViewContent.textLimit = "150"
            self.txtViewContent.type = "1"
        }
    }
    @IBOutlet weak var txtEventTitle : MIGenericTextFiled!
   
    @IBOutlet weak var txtAgeLimit : MIGenericTextFiled!
    @IBOutlet weak var txtEventStartDate : MIGenericTextFiled!
    @IBOutlet weak var txtEventEndDate : MIGenericTextFiled!
    @IBOutlet weak var txtLocation : MIGenericTextFiled!
    @IBOutlet weak var lblUploadImage : UILabel!
    
//    @IBOutlet weak var subcategoryDropDownView: CustomDropDownView!
    
    @IBOutlet weak var txtInviteType : MIGenericTextFiled!
    var selectedInviteType: Int = 3 {
        didSet{
            self.didChangeInviteType()
        }
    }

    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    var arrSelectedGroupFriends = [[String : Any]]()
    var eventID: Int?
    var categoryID: Int?
    var isApiEventImage = false
    var profileImgUrl = ""
    var arrSubCategory =  [[String : Any]]()
    var categorysubName : String?
    var apiTask : URLSessionTask?
    var currentPage : Int = 1
    var categoryName : String?
    var arrsubCategorys : [MDLIntrestSubCategory] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.Initialization()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateUIAccordingToLanguage()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK:- --------- Initialization
    
    func Initialization(){
        
        txtEventTitle.txtDelegate = self
        
        if eventType == .editEvent{
            self.loadEventDetailFromServer()
        }
        viewUploadedImageContainer.isHidden = true
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: #imageLiteral(resourceName: "ic_add_post"), style: .plain, target: self, action: #selector(btnAddEventClicked(_:)))]
        
        let arrCategory = MIGeneralsAPI.shared().fetchCategoryFromLocalEvent()
        
        /// Set Dropdown on txtCategory
        categoryDropDownView.arrDataSource = arrCategory.map({ (obj) -> String in
            return (obj[CCategoryName] as? String ?? "")
        })
        
        /// On select text from the auto-complition
        categoryDropDownView.onSelectText = { [weak self] (item) in
            
            guard let `self` = self else { return }
            
            let objArry = arrCategory.filter({ (obj) -> Bool in
                return ((obj[CCategoryName] as? String) == item)
            })
            if (objArry.count > 0) {
                self.categoryName = (objArry.first?[CCategoryName] as? String) ?? ""
            }
            
        }
        
        txtEventStartDate.setDatePickerMode(mode: .dateAndTime)
        txtEventStartDate.setMinimumDate(minDate: Date())
        txtEventStartDate.setDatePickerWithDateFormate(dateFormate: CDateFormat, defaultDate: Date(), isPrefilledDate: true) { [weak self] (date) in
            guard let self = self else { return }
            
            self.txtEventEndDate.setMinimumDate(minDate: date)
            
            let endEventDate = date.addingTimeInterval((2.0 * 60) * 60.0)
            let formatter = DateFormatter()
            formatter.locale = DateFormatter.shared().locale
            formatter.dateFormat = CDateFormat
            self.txtEventEndDate.text = formatter.string(from: endEventDate)
            DispatchQueue.main.async {
                self.txtEventEndDate.updatePlaceholderFrame(true)
            }
        }
        
        txtEventEndDate.setDatePickerMode(mode: .dateAndTime)
        txtEventEndDate.setMinimumDate(minDate: Date())
        txtEventEndDate.setDatePickerWithDateFormate(dateFormate: CDateFormat, defaultDate: Date(), isPrefilledDate: true) { [weak self] (date) in
            guard let _ = self else { return }
        }
     
        let arrInviteType = [CPostPostsInviteGroups, CPostPostsInviteContacts,  CPostPostsInvitePublic, CPostPostsInviteAllFriends]
        // By default `All type` selected
        self.selectedInviteType = 4
        
    }
    
    func updateUIAccordingToLanguage(){
        
        if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
        }else{
        }
        
        if eventType == .editEvent{
            self.title = CNavEditEvent
        }else{
            self.title = CNavAddEvent
        }
        
        lblUploadImage.text = CUploadImage
        txtEventTitle.placeHolder = CEventPlaceholderTitle
        categoryDropDownView.txtCategory.placeholder = CEventPlaceholderSelecetCategory
        txtViewContent.placeHolder = CEventPlaceholderContent
        txtEventStartDate.placeHolder = CEventPlaceholderStartDateTime
        txtEventEndDate.placeHolder = CEventPlaceholderEndDateTime
        txtLocation.placeholder = CEventPlaceholderLocation
    }
    
}

// MARK:- --------- Api Functions
extension AddEventViewController{
    func setEventDetail (_ eventInfo : [String : Any]) {
        
        self.categoryID = eventInfo.valueForInt(key: CCategory_Id)
        txtEventTitle.text = eventInfo.valueForString(key: CTitle)
        categoryDropDownView.txtCategory.text = eventInfo.valueForString(key: CCategory)
        txtViewContent.text = eventInfo.valueForString(key: CContent)
//        txtAgeLimit.text = eventInfo.valueForString(key: CMinAge)
        txtEventStartDate.text = DateFormatter.dateStringFrom(timestamp: eventInfo.valueForDouble(key: CEvent_Start_Date), withFormate: CDateFormat)
        txtEventEndDate.text = DateFormatter.dateStringFrom(timestamp: eventInfo.valueForDouble(key: CEvent_End_Date), withFormate: CDateFormat)
        txtLocation.text = eventInfo.valueForString(key: CEvent_Location)
        
        self.latitude = eventInfo.valueForDouble(key: "latitude") ?? 0.0
        self.longitude = eventInfo.valueForDouble(key: "longitude") ?? 0.0
        
        //...Set Event image
        if eventInfo.valueForString(key: CImage) != "" {
            imgEvent.loadImageFromUrl(eventInfo.valueForString(key: CImage), false)
            self.viewAddImageContainer.isHidden = true
            self.viewUploadedImageContainer.isHidden = false
            self.isApiEventImage = true
        } else {
            self.isApiEventImage = false
        }
      
        //...Set invite type
        self.selectedInviteType = eventInfo.valueForInt(key: CPublish_To) ?? 3
        GCDMainThread.async {
            for txtInfo in self.scrollViewContainer.subviews{
                if let textInfo = txtInfo as? MIGenericTextFiled {
                    textInfo.updatePlaceholderFrame(true)
                    textInfo.showHideClearTextButton()
                }
            }
            self.txtViewContent.updatePlaceholderFrame(true)
        }
    }
    
    func addEditEvent(){
        
        var apiPara = [String : Any]()
        var apiParaGroups = [String]()
        var apiParaFriends = [String]()
        apiPara[CPostType] = 6
        apiPara[CTitle] = txtEventTitle.text
        apiPara[CCategory_Id] = categoryDropDownView.txtCategory.text
        apiPara[CPost_Detail] = txtViewContent.text
//        apiPara[CMin_Age] = txtAgeLimit.text
        apiPara[CEvent_Location] = txtLocation.text
        apiPara[CLatitude] = self.latitude
        apiPara[CLongitude] = self.longitude
        
        apiPara[CEvent_Start_Date] = DateFormatter.shared().convertDateIntoGMTDate(dateToConvert: txtEventStartDate.text, formate: CDateFormat)
        apiPara[CEvent_End_Date] = DateFormatter.shared().convertDateIntoGMTDate(dateToConvert: txtEventEndDate.text, formate: CDateFormat)
        
        apiPara[CPublish_To] = self.selectedInviteType
        // When user editing the article....
        if eventType == .editEvent{
            apiPara[CId] = eventID
        }
        print(apiPara)
        
        
        let startEvntTime =  DateFormatter.shared().reversDateFormat(dateString:txtEventStartDate.text ?? "" )
        let endEvntTime = DateFormatter.shared().reversDateFormat(dateString:txtEventEndDate.text ?? "" )
        
        guard let userID = appDelegate.loginUser?.user_id else { return }
        
        let txtAdv = txtViewContent.text.replace(string: "\n", replacement: "\\n")
        
        var dict:[String:Any] = [
           "user_id":userID,
           "image":profileImgUrl,
           "post_title":txtEventTitle.text ?? "",
           "post_category":categoryDropDownView.txtCategory.text ?? "",
           "post_content":txtAdv,
           "age_limit":"16",
           "latitude":self.latitude,
            "longitude":self.longitude,
           "start_date":startEvntTime,
           "end_date":endEvntTime,
            "address_line1": txtLocation.text ?? ""
          ]
        
        if self.selectedInviteType == 1{
            let groupIDS = arrSelectedGroupFriends.map({$0.valueForString(key: CGroupId) }).joined(separator: ",")
           apiParaGroups = groupIDS.components(separatedBy: ",")
          
        }else if self.selectedInviteType == 2{
            let userIDS = arrSelectedGroupFriends.map({$0.valueForString(key: CFriendUserID) }).joined(separator: ",")
            apiParaFriends = userIDS.components(separatedBy: ",")
        }
        
        if apiParaGroups.isEmpty == false {
                  dict[CTargetAudiance] = apiParaGroups
              }else {
                  dict[CTargetAudiance] = "none"
              }
            
              if apiParaFriends.isEmpty == false {
                  dict[CSelectedPerson] = apiParaFriends
              }else {
                  dict[CSelectedPerson] = "none"
            }
        
        
        APIRequest.shared().addEditPost(para: dict, image: imgEvent.image, apiKeyCall: CAPITagevents) { [weak self] (response, error) in
            guard let self = self else { return }
            if response != nil && error == nil{
   
                if let eventInfo = response![CJsonData] as? [String : Any]{
                    MIGeneralsAPI.shared().refreshPostRelatedScreens(eventInfo,self.eventID, self, self.eventType == .editEvent ? .editPost : .addPost)
                    
                    APIRequest.shared().saveNewInterest(interestID: eventInfo.valueForInt(key: CCategory_Id) ?? 0, interestName: eventInfo.valueForString(key: CCategory))

                }
                
                if let metaInfo = response![CJsonMeta] as? [String : Any] {
                    let name = (appDelegate.loginUser?.first_name ?? "") + " " + (appDelegate.loginUser?.last_name ?? "")
                    guard let image = appDelegate.loginUser?.profile_img else { return }
                    let stausLike = metaInfo["status"] as? String ?? "0"
                    if stausLike == "0" {
                        
                        MIGeneralsAPI.shared().addRewardsPoints(CPostcreate,message:"post_point",type:CPostcreate,title:"Event Add",name:name,icon:image)
                    }
                }
                self.navigationController?.popViewController(animated: true)
                CTopMostViewController.presentAlertViewWithOneButton(alertTitle: "", alertMessage: self.eventType == .editEvent ? CMessageEventPostUpdated : CMessageEventPostUpload, btnOneTitle: CBtnOk, btnOneTapped: nil)
               

            }
        }
    }

//    func loadEventDetailFromServer(){
//        APIRequest.shared().viewPostDetail(postID: self.eventID) { [weak self] (response, error) in
//            guard let self = self else { return }
//            if response != nil {
//                if let eventInfo = response![CJsonData] as? [String : Any]{
//                    self.setEventDetail(eventInfo)
//                }
//            }
//        }
//    }
    
    func loadEventDetailFromServer(){
            
            APIRequest.shared().viewPostDetailNew(postID: self.eventID!, apiKeyCall: CAPITageventsDetials){ [weak self] (response, error) in
                guard let self = self else { return }
                if response != nil {
                    self.parentView.isHidden = false
                    if let Info = response!["data"] as? [[String:Any]]{
                    
                    print(Info as Any)
                        for eventInfo in Info {
                        self.setEventDetail(eventInfo)
                        }
                    }
                }
            }
        }
}

// MARK:- --------- UICollectionView Delegate/Datasources
extension AddEventViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrSelectedGroupFriends.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BubbleWithCancelCollCell", for: indexPath) as! BubbleWithCancelCollCell
        let selectedInfo = arrSelectedGroupFriends[indexPath.row]
        
        if (self.selectedInviteType == 2){
            cell.lblBubbleText.text = selectedInfo.valueForString(key: CFirstname) + " " + selectedInfo.valueForString(key: CLastname)
        }else{
            cell.lblBubbleText.text = selectedInfo.valueForString(key: CGroupTitle)
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        arrSelectedGroupFriends.remove(at: indexPath.row)
        clGroupFriend.reloadData()
        
        if arrSelectedGroupFriends.count == 0{
            btnSelectGroupFriend.isHidden = false
            clGroupFriend.isHidden = true
            btnAddMoreFriends.isHidden = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let selectedInfo = arrSelectedGroupFriends[indexPath.row]
        var title = ""
        if self.selectedInviteType == 2 {
            title = selectedInfo.valueForString(key: CFirstname) + " " + selectedInfo.valueForString(key: CLastname)
        }else{
            title = selectedInfo.valueForString(key: CGroupTitle)
        }
        
        let fontToResize =  CFontPoppins(size: 12, type: .light).setUpAppropriateFont()
        var size = title.size(withAttributes: [NSAttributedString.Key.font: fontToResize!])
        size.width = CGFloat(ceilf(Float(size.width + 65)))
        size.height = clGroupFriend.frame.size.height
        return size
        
    }
}

// MARK:- --------- Action Event
extension AddEventViewController{
    @IBAction func btnSelectLocationCLK(_ sender : UIButton){
        
        guard let locationPicker = CStoryboardLocationPicker.instantiateViewController(withIdentifier: "LocationPickerVC") as? LocationPickerVC else {
            return
        }
        locationPicker.prefixLocation = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
        locationPicker.showCurrentLocationButton = true
        locationPicker.completion = { [weak self] (placeDetail) in
            guard let self = self else { return }
            self.txtLocation.text = placeDetail?.formattedAddress
            self.latitude = placeDetail?.coordinate?.latitude ?? 0.0
            self.longitude = placeDetail?.coordinate?.longitude ?? 0.0
        }
        self.navigationController?.pushViewController(locationPicker, animated: true)
        
        /*MILocationManager.shared().openGMSPlacePicker(self) { [weak self] (place) in
            guard let self = self else { return }
            self.txtLocation.text = place.formattedAddress
            self.latitude = place.coordinate?.latitude ?? 0.0
            self.longitude = place.coordinate?.longitude ?? 0.0
        }*/
    }
    
    @IBAction func btnUplaodImageCLK(_ sender : UIButton){
        
        self.presentImagePickerController(allowEditing: false) { [weak self] (image, info) in
            guard let self = self else { return }
            if image != nil{
                self.imgEvent.image = image
                self.viewAddImageContainer.isHidden = true
                self.viewUploadedImageContainer.isHidden = false
                
//                guard let imageURL = info?[UIImagePickerController.InfoKey.imageURL] as? NSURL else {
//                    return
//                }
//                self.imgName = imageURL.absoluteString ?? ""
//                MInioimageupload.shared().uploadMinioimage(ImgnameStr:image!)
                guard let mobileNum = appDelegate.loginUser?.mobile else {
                    return
                }
                MInioimageupload.shared().uploadMinioimages(mobileNo: mobileNum, ImageSTt: image!,isFrom:"",uploadFrom:"")
                MInioimageupload.shared().callback = { message in
                print("UploadImage::::::::::::::\(message)")
                self.profileImgUrl = message
                }
            }
        }
    }
    
    @IBAction func btnDeleteImageCLK(_ sender : UIButton){
   
        if eventType == .editEvent && self.isApiEventImage {
            self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CMessageDeleteImage, btnOneTitle: CBtnYes, btnOneTapped: { [weak self](action) in
                guard let self = self else { return }
//                self.removeEventImage()
            }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
       
        } else {
            self.viewUploadedImageContainer.isHidden = true
            self.viewAddImageContainer.isHidden = false
            self.imgEvent.image = nil
        }
    }
    
    @IBAction func btnSelectGroupFriendCLK(_ sender : UIButton){
        
        if let groupFriendVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "GroupFriendSelectionViewController") as? GroupFriendSelectionViewController {
            groupFriendVC.arrSelectedGroupFriend = self.arrSelectedGroupFriends
            groupFriendVC.isFriendList = (self.selectedInviteType == 2)
            groupFriendVC.setBlock { [weak self] (arrSelected, message) in
                guard let self = self else { return }
                if let arr = arrSelected as? [[String : Any]]{
                    self.arrSelectedGroupFriends = arr
                    self.clGroupFriend.isHidden = self.arrSelectedGroupFriends.count == 0
                    self.btnAddMoreFriends.isHidden = self.arrSelectedGroupFriends.count == 0
                    self.btnSelectGroupFriend.isHidden = self.arrSelectedGroupFriends.count != 0
                    self.clGroupFriend.reloadData()
                }
            }
            self.navigationController?.pushViewController(groupFriendVC, animated: true)
        }
    }
    
    func didChangeInviteType(){
        
        arrSelectedGroupFriends = []
//        clGroupFriend.reloadData()
//        clGroupFriend.isHidden = true
//        btnAddMoreFriends.isHidden = true
//        btnSelectGroupFriend.isHidden = false
        
//        switch self.selectedInviteType {
//        case 1:
//            self.txtInviteType.text = CPostPostsInviteGroups
//            viewSelectGroup.hide(byHeight: false)
//        case 2:
//            self.txtInviteType.text = CPostPostsInviteContacts
//            viewSelectGroup.hide(byHeight: false)
//        case 3:
//            //self.txtInviteType.text = CPostPostsInviteAllFriends
//          self.txtInviteType.text = CPostPostsInvitePublic
//            btnSelectGroupFriend.isHidden = true
//            viewSelectGroup.hide(byHeight: true)
//        case 4:
//            self.txtInviteType.text = CPostPostsInviteAllFriends
//           // self.txtInviteType.text = CPostPostsInvitePublic
//            btnSelectGroupFriend.isHidden = true
//            viewSelectGroup.hide(byHeight: true)
//        default:
//            break
//        }
        
        GCDMainThread.async {
//            self.txtInviteType.updatePlaceholderFrame(true)
        }
    }

    
    @objc fileprivate func btnAddEventClicked(_ sender : UIBarButtonItem) {
        
        self.resignKeyboard()
        
//        let ageValue = txtAgeLimit.text?.toInt ?? 0
        
        if (txtEventTitle.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageEventTitle, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }else if (categoryDropDownView.txtCategory.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageEventCategory, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }else if (txtViewContent.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageEventContent, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }
        else if (self.selectedInviteType == 1 || self.selectedInviteType == 2) && arrSelectedGroupFriends.count == 0 {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageSelectContactGroupEvent, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }else if (txtEventStartDate.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageEventStartDate, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }else if (txtEventEndDate.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageEventEndDate, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }else if !DateFormatter.shared().compareTwoDates(startDate: txtEventStartDate.text, endDate: txtEventEndDate.text, formate: CDateFormat) {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CAlertEventEndMax, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }
        
        else if (txtLocation.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageEventLocation, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }
        else{
            self.addEditEvent()
        }

    }
}

// MARK:-  --------- Generic UITextView Delegate
extension AddEventViewController: GenericTextViewDelegate{
    
    func genericTextViewDidChange(_ textView: UITextView, height: CGFloat){
        
        if textView == txtViewContent{
//            lblTextCount.text = "\(textView.text.count)/\(txtViewArticleContent.textLimit ?? "0")"
        }
    }
}


extension AddEventViewController: GenericTextFieldDelegate {
   
    @objc func genericTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if textField == txtEventTitle{
        if txtEventTitle.text?.count ?? 0 > 20{
            return false
        }
        let cs = NSCharacterSet(charactersIn: PASSWORDALLOWCHAR).inverted
        let filtered = string.components(separatedBy: cs).joined(separator: "")
        return (string == filtered)
    }
    return true
    }
}
