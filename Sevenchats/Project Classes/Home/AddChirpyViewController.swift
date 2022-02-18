//
//  AddChirpyViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 17/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : AddChirpyViewController                     *
 * Changes :                                             *
 * Add article and limit with 5000 charectes,select      *
 * Categries                                             *
 ********************************************************/


import UIKit

enum ChirpyType : Int {
    case addChirpy = 0
    case editChirpy = 1
}

class AddChirpyViewController: ParentViewController {
    
    var chirpyType : ChirpyType!
    @IBOutlet weak var topContainer : UIView!
    
    @IBOutlet weak var viewAddImageContainer : UIView!
    @IBOutlet weak var viewUploadedImageContainer : UIView!
    @IBOutlet weak var imgChirpy : UIImageView!
    @IBOutlet weak var txtViewChirpyContent : GenericTextView!{
        didSet{
            self.txtViewChirpyContent.txtDelegate = self
            self.txtViewChirpyContent.isScrollEnabled = true
            self.txtViewChirpyContent.textLimit = "150"
            self.txtViewChirpyContent.type = "1"
        }
    }
    
    @IBOutlet weak var btnAddMoreFriends : UIButton!
    @IBOutlet weak var lblTextCount : UILabel!
    @IBOutlet weak var btnSelectGroupFriend : UIButton!
    @IBOutlet weak var clGroupFriend : UICollectionView!
    @IBOutlet weak var viewSelectGroup : UIView!
    @IBOutlet private weak var categoryDropDownView: CustomDropDownView!
    @IBOutlet weak var scrollViewContainer : UIView!
    @IBOutlet weak var lblUploadImage : UILabel!
    @IBOutlet weak var txtInviteType : MIGenericTextFiled!
    
    var selectedInviteType : Int = 3 {
        didSet{
            self.didChangeInviteType()
        }
    }
    
    
    var arrSelectedGroupFriends = [[String : Any]]()
    var chirpyID : Int?
    var categoryID : Int?
    var isApiChirpyImage = false
    var imgName = ""
    var uploadImgUrl = ""
    var arrSubCategory =  [[String : Any]]()
    var categorysubName : String?
    var apiTask : URLSessionTask?
    var currentPage : Int = 1
    var categoryName : String?
    var arrsubCategorys : [MDLIntrestSubCategory] = []
    var arrImagesVideo = [String]()
    var imageString = ""
    var ImguploadStr = ""
    var quoteDesc = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Initialization()
        topContainer.isHidden = true
        viewSelectGroup.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateUIAccordingToLanguage()
    }
    // MARK:- --------- Initialization
    func Initialization(){
        
        if chirpyType == .editChirpy{
            self.loadChirpyDetailFromServer()
        }
        
        txtViewChirpyContent.genericDelegate  = self
        
        setQuoteText()
        viewUploadedImageContainer.isHidden = true
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: #imageLiteral(resourceName: "ic_add_post"), style: .plain, target: self, action: #selector(btnAddChirpyClicked(_:)))]
        
        let arrCategory = MIGeneralsAPI.shared().fetchCategoryFromLocalChiripy()
        
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
        let arrInviteType = [CPostPostsInviteGroups, CPostPostsInviteContacts,  CPostPostsInvitePublic, CPostPostsInviteAllFriends]
        
        txtInviteType.setPickerData(arrPickerData: arrInviteType, selectedPickerDataHandler: { [weak self] (text, row, component) in
            guard let self = self else { return }
            self.selectedInviteType = (row + 1)
        }, defaultPlaceholder: CPostPostsInviteGroups)
        
        // By default `All type` selected
        self.selectedInviteType = 4
        
    }
    
    fileprivate func setQuoteText(){
        var strQuote = self.quoteDesc
        if strQuote.count > 5000{
            strQuote = strQuote[0..<5000]
        }
        self.txtViewChirpyContent.text = strQuote
        self.lblTextCount.text = "\(strQuote.count)/5000"
        
        GCDMainThread.async {
            self.txtViewChirpyContent.updatePlaceholderFrame(true)
        }
    }
    
    func updateUIAccordingToLanguage(){
        
        if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
            // Reverse Flow...
            btnSelectGroupFriend.contentHorizontalAlignment = .right
            clGroupFriend.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }else{
            // Normal Flow...
            btnSelectGroupFriend.contentHorizontalAlignment = .left
            clGroupFriend.transform = CGAffineTransform.identity
        }
        
        if chirpyType == .editChirpy{
            self.title = CNavEditChirpy
        }else{
            self.title = CNavAddChirpy
        }
        txtInviteType.placeHolder = CVisiblity
        txtViewChirpyContent.placeHolder = CChirpyPlaceholderContent
        lblUploadImage.text = CUploadImage
        categoryDropDownView.txtCategory.placeholder = CChirpyPlaceholderSelecetCategory
        txtViewChirpyContent.placeHolder = CVisiblity
        btnSelectGroupFriend.setTitle(CMessagePostsSelectFriends, for: .normal)
    }
}

// MARK:- --------- Api Functions
extension AddChirpyViewController{
    func addEditChirpy(){
        var apiPara = [String : Any]()
        var apiParaGroups = [String]()
        var apiParaFriends = [String]()
        
        apiPara[CPostType] = 3
        apiPara[CCategory_Id] = categoryDropDownView.txtCategory.text
        apiPara[CPost_Detail] = txtViewChirpyContent.text
        // When user editing the article....
        if chirpyType == .editChirpy{
            apiPara[CId] = chirpyID
        }
        do {
            let data = try JSONEncoder().encode(arrImagesVideo)
            let string = String(data: data, encoding: .utf8)!
            let replaced2 = string.replacingOccurrences(of: "\"{", with: "{")
            let replaced3 = replaced2.replacingOccurrences(of: "}\"", with: "}")
            let replaced4 = replaced3.replacingOccurrences(of: "\\/\\/", with: "//")
            let replaced5 = replaced4.replacingOccurrences(of: "\\/", with: "/")
            self.ImguploadStr = replaced5
        } catch { print(error) }
        
        let txtchiripy = txtViewChirpyContent.text.replace(string: "\n", replacement: "\\n")
        
        guard let userID = appDelegate.loginUser?.user_id else {return}
        var dict :[String:Any]  =  [
            "user_id":userID.description,
            "image":uploadImgUrl,
            "post_title":categoryDropDownView.txtCategory.text ?? "",
            "post_category":categoryDropDownView.txtCategory.text ?? "",
            "post_content": txtchiripy,
            "age_limit":"20",
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
        
        APIRequest.shared().addEditPost(para: dict, image: imgChirpy.image, apiKeyCall: CAPITagchirpies) { [weak self] (response, error) in
            guard let self = self else { return }
            if response != nil && error == nil{
                
                if let chirpyInfo = response![CJsonData] as? [String : Any]{
                    MIGeneralsAPI.shared().refreshPostRelatedScreens(chirpyInfo,self.chirpyID, self,self.chirpyType == .editChirpy ? .editPost : .addPost, rss_id: 0)
                    
                    APIRequest.shared().saveNewInterest(interestID: chirpyInfo.valueForInt(key: CCategory_Id) ?? 0, interestName: chirpyInfo.valueForString(key: CCategory))
                    
                    if self.chirpyType == .editChirpy{
                        for vwController in (self.navigationController?.viewControllers)! {
                            if vwController.isKind(of: HomeViewController.classForCoder()) {
                                
                                //...Redirect on Home list screen when come from Home flow
                                let homeVC = vwController as? HomeViewController
                                self.navigationController?.popToViewController(homeVC!, animated: true)
                                break
                                
                            } else if vwController.isKind(of: MyProfileViewController.classForCoder()) {
                                
                                //...Redirect on My Profile screen when come from My Profile flow
                                let profileVC = vwController as? MyProfileViewController
                                self.navigationController?.popToViewController(profileVC!, animated: true)
                                break
                            }
                        }
                    } else {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                if let metaInfo = response![CJsonMeta] as? [String : Any] {
                    let name = (appDelegate.loginUser?.first_name ?? "") + " " + (appDelegate.loginUser?.last_name ?? "")
                    guard let image = appDelegate.loginUser?.profile_img else { return }
                    let stausLike = metaInfo["status"] as? String ?? "0"
                    if stausLike == "0" {
                        MIGeneralsAPI.shared().addRewardsPoints(CPostcreate,message:CPostcreate,type:"chirpy",title: self.categoryDropDownView.txtCategory.text ?? "",name:name,icon:image, detail_text: "post_point")
                        
                    }
                }
                
                self.navigationController?.popViewController(animated: true)
                CTopMostViewController.presentAlertViewWithOneButton(alertTitle: "", alertMessage: self.chirpyType == .editChirpy ? CMessageChirpyPostUpdated : CMessageChirpyPostUpload, btnOneTitle: CBtnOk, btnOneTapped: nil)
                
            }
        }
    }
    
    fileprivate func removeChirpyImage() {
        
        self.uploadImgUrl = ""
        
        
        
        
    }
    
    fileprivate func loadChirpyDetailFromServer(){
        if let chirpyID = self.chirpyID{
            
            APIRequest.shared().viewPostDetailNew(postID: chirpyID, apiKeyCall: CAPITagchirpiesDetials){ [weak self] (response, error) in
                guard let self = self else { return }
                if response != nil {
                    self.parentView.isHidden = false
                    if let Info = response!["data"] as? [[String:Any]]{
                        for chirpyInfo in Info {
                            self.setChirpyDetail(chirpyInfo)
                        }
                    }
                }
            }
        }
    }
    
    fileprivate func setChirpyDetail (_ chirpyInfo : [String : Any]) {
        
        self.categoryID = chirpyInfo.valueForInt(key: CCategory_Id)
        categoryDropDownView.txtCategory.text = chirpyInfo.valueForString(key: CCategory)
        txtViewChirpyContent.text = chirpyInfo.valueForString(key: CContent)
        lblTextCount.text = "\(txtViewChirpyContent.text.count)/5000"
        //...Set Chirpy image
        if chirpyInfo.valueForString(key: CImage) != "" {
            imgChirpy.loadImageFromUrl(chirpyInfo.valueForString(key: CImage), false)
            isApiChirpyImage = true
            self.viewAddImageContainer.isHidden = true
            self.viewUploadedImageContainer.isHidden = false
        }else{
            isApiChirpyImage = false
        }
        
        //...Set invite type
        self.selectedInviteType = chirpyInfo.valueForInt(key: CPublish_To) ?? 3
        
        switch self.selectedInviteType {
        case 1:
            if let arrInvitee = chirpyInfo[CInvite_Groups] as? [[String : Any]]{
                arrSelectedGroupFriends = arrInvitee
            }
        case 2:
            if let arrInvitee = chirpyInfo[CInvite_Friend] as? [[String : Any]]{
                arrSelectedGroupFriends = arrInvitee
            }
        default:
            break
        }
        
        if arrSelectedGroupFriends.count > 0{
            self.clGroupFriend.reloadData()
            self.clGroupFriend.isHidden = false
            btnAddMoreFriends.isHidden = false
            self.btnSelectGroupFriend.isHidden = true
        }
        
        GCDMainThread.async {
            for txtInfo in self.scrollViewContainer.subviews{
                if let textInfo = txtInfo as? MIGenericTextFiled {
                    textInfo.updatePlaceholderFrame(true)
                    textInfo.showHideClearTextButton()
                }
            }
            self.txtViewChirpyContent.updatePlaceholderFrame(true)
        }
    }
    
}


// MARK:- --------- UICollectionView Delegate/Datasources
extension AddChirpyViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrSelectedGroupFriends.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BubbleWithCancelCollCell", for: indexPath) as! BubbleWithCancelCollCell
        let selectedInfo = arrSelectedGroupFriends[indexPath.row]
        
        if self.selectedInviteType == 2{
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

// MARK:-  --------- Generic UITextView Delegate
extension AddChirpyViewController: GenericTextViewDelegate{
    
    func genericTextViewDidChange(_ textView: UITextView, height: CGFloat){
        
        if textView == txtViewChirpyContent{
            lblTextCount.text = "\(textView.text.count)/5000"
        }
    }
}

// MARK:- --------- Action Event
extension AddChirpyViewController{
    @IBAction func btnUplaodImageCLK(_ sender : UIButton){
        
        self.presentImagePickerController(allowEditing: false) { [weak self] (image, info) in
            guard let self = self else { return }
            if image != nil{
                self.imgChirpy.image = image
                self.viewAddImageContainer.isHidden = true
                self.viewUploadedImageContainer.isHidden = false
                
                guard let mobileNum = appDelegate.loginUser?.mobile else {return}
                MInioimageupload.shared().uploadMinioimages(mobileNo: mobileNum, ImageSTt: image!,isFrom:"",uploadFrom:"")
                MInioimageupload.shared().callback = { message in
                    self.uploadImgUrl = message
                }
            }
        }
    }
    
    @IBAction func btnDeleteImageCLK(_ sender : UIButton){
        
        if self.chirpyType == .editChirpy && self.isApiChirpyImage {
            self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CMessageDeleteImage, btnOneTitle: CBtnYes, btnOneTapped: { [weak self](action) in
                guard let self = self else { return }
                self.removeChirpyImage()
            }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
        } else {
            self.viewUploadedImageContainer.isHidden = true
            self.viewAddImageContainer.isHidden = false
            self.imgChirpy.image = nil
            self.uploadImgUrl = ""
            
            
        }
    }
    
    @IBAction func btnSelectGroupFriendCLK(_ sender : UIButton){
        
        if let groupFriendVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "GroupFriendSelectionViewController") as? GroupFriendSelectionViewController{
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
        clGroupFriend.reloadData()
        clGroupFriend.isHidden = true
        btnAddMoreFriends.isHidden = true
        btnSelectGroupFriend.isHidden = false
        
        switch self.selectedInviteType {
        case 1:
            self.txtInviteType.text = CPostPostsInviteGroups
            viewSelectGroup.hide(byHeight: false)
        case 2:
            self.txtInviteType.text = CPostPostsInviteContacts
            viewSelectGroup.hide(byHeight: false)
        case 3:
            self.txtInviteType.text = CPostPostsInvitePublic
            btnSelectGroupFriend.isHidden = true
            viewSelectGroup.hide(byHeight: true)
        case 4:
            self.txtInviteType.text = CPostPostsInviteAllFriends
            btnSelectGroupFriend.isHidden = true
            viewSelectGroup.hide(byHeight: true)
        default:
            break
        }
        
        GCDMainThread.async {
            self.txtInviteType.updatePlaceholderFrame(true)
        }
    }
    
    @objc fileprivate func btnAddChirpyClicked(_ sender : UIBarButtonItem) {
        if (categoryDropDownView.txtCategory.text?.isBlank)! {
            
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageChirpyCategory, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }else if (txtViewChirpyContent.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageChirpyContent, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }else if (self.selectedInviteType == 1 || self.selectedInviteType == 2) && arrSelectedGroupFriends.count == 0 {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageSelectContactGroupChirpy, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }else{
            if txtViewChirpyContent.text != "" {
                let characterset = CharacterSet(charactersIn:SPECIALCHAR)
                if txtViewChirpyContent.text.rangeOfCharacter(from: characterset.inverted) != nil {
                   print("true")
                    self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageSpecial, btnOneTitle: CBtnOk, btnOneTapped: nil)
                    
                } else {
                   print("false")
                    self.addEditChirpy()

                }
            }
            //self.addEditChirpy()
        }
    }
}

