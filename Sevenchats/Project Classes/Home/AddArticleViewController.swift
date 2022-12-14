//
//  AddArticleViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 16/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : AddArticleViewController                    *
 * Changes :                                             *
 * Add article and limit with 5000 charectes             *
 ********************************************************/

import UIKit

enum ArticleType : Int {
    case editArticle = 0
    case addArticle = 1
    
//    case addShouts = 0
//    case editShouts = 1
//    case shareQuote = 3
}

class AddArticleViewController: ParentViewController {
    
    var articleType : ArticleType!
    
    @IBOutlet weak var topContainer : UIView!
    @IBOutlet weak var viewAddImageContainer : UIView!
    @IBOutlet weak var viewUploadedImageContainer : UIView!
    @IBOutlet weak var imgArticle : UIImageView!
    @IBOutlet weak var btnAddMoreFriends : UIButton!
    @IBOutlet weak var btnSelectGroupFriend : UIButton!
    @IBOutlet weak var lblUploadImage : UILabel!
    @IBOutlet weak var lblTextCount : UILabel!
    @IBOutlet weak var txtArticleTitle : MIGenericTextFiled!{
        didSet{
            self.txtArticleTitle.txtDelegate = self
        }
    }
    @IBOutlet weak var txtArticleAgeLimit : MIGenericTextFiled!
    @IBOutlet weak var txtViewArticleContent : GenericTextView!{
        didSet{
            self.txtViewArticleContent.txtDelegate = self
            self.txtViewArticleContent.isScrollEnabled = true
            self.txtViewArticleContent.textLimit = "5000"
            self.txtViewArticleContent.type = "1"
        }
    }
    @IBOutlet weak var viewSelectGroup : UIView!
    @IBOutlet weak var scrollViewContainer : UIView!
    @IBOutlet private weak var categoryDropDownView: CustomDropDownView!
    
    @IBOutlet weak var clGroupFriend : UICollectionView!
    var apiTask : URLSessionTask?
    var currentPage : Int = 1
    
    @IBOutlet weak var txtInviteType : MIGenericTextFiled!
    var selectedInviteType : Int = 3 {
        didSet{
            self.didChangeInviteType()
        }
    }
    
    var arrSelectedGroupFriends = [[String : Any]]()
    var articleID : Int?
    var categoryID : Int?
    var categoryName : String?
    var categorysubName : String?
    var imgName = ""
    var profileImgUrl = ""
    var quoteDesc = ""
    var arrSubCategory =  [[String : Any]]()
    var arrsubCategorys : [MDLProductSubCategory] = []
    var postContent = ""
    var postTxtFieldContent = ""
    var post_ID:String?
    var articleInfo = [String:Any]()
    var postID = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Initialization()
        setQuoteText()
        topContainer.isHidden = true
        viewSelectGroup.isHidden = true 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateUIAccordingToLanguage()
        txtViewArticleContent.genericDelegate = self
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- --------- Initialization
    func Initialization(){
        if articleType == .editArticle {
            if articleInfo.valueForString(key: "image") != ""{
                viewUploadedImageContainer.isHidden = false
                viewAddImageContainer.isHidden = true
                profileImgUrl = articleInfo.valueForString(key: "image")
                
            }else{
                viewUploadedImageContainer.isHidden = true
                viewAddImageContainer.isHidden = false
            }
        }else{
            viewUploadedImageContainer.isHidden = true
            viewAddImageContainer.isHidden = false
        }
        txtArticleTitle.txtDelegate = self
        if articleType == .editArticle {
            self.setEventDetail(articleInfo)
            self.loadArticleDetailFromServer()
            
        }

//        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: #imageLiteral(resourceName: "ic_add_post"), style: .plain, target: self, action: #selector(btnAddArticleClicked(_:)))]
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: #imageLiteral(resourceName: "ic_info_tint"), style: .plain, target: self, action: #selector(btnHelpInfoClicked(_:))),UIBarButtonItem(image: #imageLiteral(resourceName: "ic_add_post"), style: .plain, target: self, action: #selector(btnAddArticleClicked(_:)))]
        
        let arrCategory = MIGeneralsAPI.shared().fetchCategoryFromLocalArticle()
        
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
        }, defaultPlaceholder: CPostPostsInviteAllFriends)
        
        // By default `All type` selected
        self.selectedInviteType = 4
    }
    
    //List text charectes
    fileprivate func setQuoteText(){
        var strQuote = self.quoteDesc
        if strQuote.count > 5000{
            strQuote = strQuote[0..<5000]
        }
        let str_Back = strQuote.return_replaceBack(replaceBack: strQuote)
        self.txtViewArticleContent.text = str_Back
        self.lblTextCount.text = "\(strQuote.count)/5000"
        
        GCDMainThread.async {
            self.txtViewArticleContent.updatePlaceholderFrame(true)
        }
    }
    
    func updateUIAccordingToLanguage(){
        
        if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
            btnSelectGroupFriend.contentHorizontalAlignment = .right
            clGroupFriend.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }else{
            
            btnSelectGroupFriend.contentHorizontalAlignment = .left
            clGroupFriend.transform = CGAffineTransform.identity
        }
        
        if articleType == .editArticle{
            self.title = CNavEditArticle
        }else{
            self.title = CNavAddArticle
        }
        
        lblUploadImage.text = CUploadImage
        txtArticleTitle.placeHolder = CArticlePlaceholderTitle
        categoryDropDownView.txtCategory.placeholder = CArticlePlaceholderSelecetCategory
        txtViewArticleContent.placeHolder = CArticlePlaceholderContent
        txtInviteType.placeHolder = CVisiblity
        btnSelectGroupFriend.setTitle(CMessagePostsSelectFriends, for: .normal)
    }
}

// MARK:- --------- Api Functions
extension AddArticleViewController{
    
    fileprivate func addEditArticle(){
        
        var apiPara = [String : Any]()
        var apiParaGroups = [String]()
        var apiParaFriends = [String]()
        apiPara[CPostType] = 1
        apiPara[CTitle] = txtArticleTitle.text
        apiPara[CCategory_Id] = categoryDropDownView.txtCategory.text
        
        apiPara[CPost_Detail] = txtViewArticleContent.text
        // When user editing the article....
        if articleType == .editArticle{
            apiPara[CId] = articleID
        }
        guard let userID = appDelegate.loginUser?.user_id else {return}
        
       // let postcont = txtViewArticleContent.text.replace(string: "\n", replacement: "\\n")
        let postcont = txtViewArticleContent.text.replace_str(replace: txtViewArticleContent.text)
        let posttitle = txtArticleTitle.text?.replace_str(replace: txtArticleTitle.text ?? "")
        
        if articleType == .editArticle{
            
            var dict :[String:Any] = [
                 "post_id": postID,
                   "image": profileImgUrl,
                   "post_title": posttitle ?? "",
                   "post_category": categoryDropDownView.txtCategory.text ?? "",
                   "post_content": postcont,
                   "age_limit": "3",
                   "targeted_audience": "",
                   "selected_persons": "",
                   "status_id": "1"
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
            APIRequest.shared().editPost(para: dict, image: nil, apiKeyCall: CAPITagEditarticles) { [weak self] (response, error) in
                guard let self = self else { return }
                if response != nil && error == nil{
                    
                   // self.navigationController?.popViewController(animated: true)
                    self.navigationController?.popToRootViewController(animated: true)
                    CTopMostViewController.presentAlertViewWithOneButton(alertTitle: "", alertMessage: self.articleType == .editArticle ? CMessageArticlePostUpdated : CMessageArticlePostUpload, btnOneTitle: CBtnOk, btnOneTapped: nil)
                    
                 
                    if let shoutInfo = response!["meta"] as? [String : Any]{
                        if shoutInfo.valueForString(key: "status")  == "0" {
                            MIGeneralsAPI.shared().refreshPostRelatedScreens(shoutInfo,self.articleID, self,.addPost, rss_id: 0)
                        }
                    }

                }
            }
        }else{
            
            let encryptUser = EncryptDecrypt.shared().encryptDecryptModel(userResultStr: userID.description ?? "")
        var dict :[String:Any] = [
            CUserId:encryptUser,
            "image":profileImgUrl,
            "post_title":posttitle ?? "",
            "post_category": categoryDropDownView.txtCategory.text ?? "",
            "post_content":postcont,
            "age_limit":"16",
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
        APIRequest.shared().addEditPost(para: dict, image: imgArticle.image,apiKeyCall: CAPITagarticles) { [weak self] (response, error) in
            guard let self = self else { return }
            if response != nil && error == nil{
                
                if let responseData = response![CJsonData] as? [[String : Any]] {
                    for data in responseData{
                        self.post_ID = data.valueForString(key: "post_id")
                    }
                }
                
                let name = (appDelegate.loginUser?.first_name ?? "") + " " + (appDelegate.loginUser?.last_name ?? "")
                guard let image = appDelegate.loginUser?.profile_img else { return }
                //Add rewards Points
                MIGeneralsAPI.shared().addRewardsPoints(CPostcreate,message:CPostcreate,type:"article",title: self.txtArticleTitle.text!,name:name,icon:image, detail_text: "post_point",target_id: self.post_ID?.toInt ?? 0)
                
                //self.navigationController?.popViewController(animated: true)
                self.navigationController?.popToRootViewController(animated: true)
                CTopMostViewController.presentAlertViewWithOneButton(alertTitle: "", alertMessage: self.articleType == .editArticle ? CMessageArticlePostUpdated : CMessageArticlePostUpload, btnOneTitle: CBtnOk, btnOneTapped: nil)
                
             
                if let shoutInfo = response!["meta"] as? [String : Any]{
                    if shoutInfo.valueForString(key: "status")  == "0" {
                        MIGeneralsAPI.shared().refreshPostRelatedScreens(shoutInfo,self.articleID, self,.addPost, rss_id: 0)
                    }
                }

            }
        }
        }
    }
    
    fileprivate func loadArticleDetailFromServer(){
        if let artID = self.articleID{
            
            APIRequest.shared().viewPostDetailNew(postID: artID, apiKeyCall: CAPITagarticlesDetials){ [weak self] (response, error) in
                guard let self = self else { return }
                if response != nil {
                    self.parentView.isHidden = false
                    if let Info = response!["data"] as? [[String:Any]]{
                        print(Info as Any)
                        for articleIfo in Info {
                            self.setEventDetail(articleIfo)
                        }
                    }
                }
            }
        }
    }
    
    fileprivate func setEventDetail (_ articleInfo : [String : Any]) {
        
        self.categoryName = articleInfo.valueForString(key: CInteresttype)
        self.categorysubName = articleInfo.valueForString(key: CinterestLevel2)
        txtArticleTitle.text = articleInfo.valueForString(key: CTitle)
        categoryDropDownView.txtCategory.text = articleInfo.valueForString(key: CCategory)
        txtViewArticleContent.text = articleInfo.valueForString(key: "post_detail")
        //...Set Event image
        self.imgArticle.loadImageFromUrl(articleInfo.valueForString(key: "image"), true)
      /*  if articleInfo.valueForString(key: CImage) != "" {
        
        profileImgUrl = articleInfo.valueForString(key: "image")
            //        self.viewAddImageContainer.isHidden = true
            //        self.viewUploadedImageContainer.isHidden = false
                    
        }*/

       
        
        self.selectedInviteType = articleInfo.valueForInt(key: CPublish_To) ?? 3
        //...Set invite type
        switch self.selectedInviteType {
        case 1:
            if let arrInvitee = articleInfo[CInvite_Groups] as? [[String : Any]]{
                arrSelectedGroupFriends = arrInvitee
            }
        case 2:
            if let arrInvitee = articleInfo[CInvite_Friend] as? [[String : Any]]{
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
            self.txtViewArticleContent.updatePlaceholderFrame(true)
        }
    }
    
    @objc fileprivate func btnHelpInfoClicked(_ sender : UIBarButtonItem){
        
        if let helpLineVC = CStoryboardHelpLine.instantiateViewController(withIdentifier: "HelpLineViewController") as? HelpLineViewController {
            helpLineVC.fromVC = "ArticleVC"
            self.navigationController?.pushViewController(helpLineVC, animated: true)
        }
        
    }
}

// MARK:- --------- UICollectionView Delegate/Datasources
extension AddArticleViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
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
        var title = ""
        let selectedInfo = arrSelectedGroupFriends[indexPath.row]
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
extension AddArticleViewController{
    
    @IBAction func btnUplaodImageCLK(_ sender : UIButton){
       // MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: CMessagePleaseWait)
        self.presentImagePickerController(allowEditing: false) { [weak self](image, info) in
            MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: CMessagePleaseWait)
            guard let self = self else { return }
            if image != nil{
                self.imgArticle.image = image
                self.viewAddImageContainer.isHidden = true
                self.viewUploadedImageContainer.isHidden = false
                MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: CMessagePleaseWait)
                if let selectedImage = info?[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                    let imgName = UUID().uuidString
                    let documentDirectory = NSTemporaryDirectory()
                    let localPath = documentDirectory.appending(imgName)
                    
                    let data = selectedImage.jpegData(compressionQuality: 0.3)! as NSData
                    data.write(toFile: localPath, atomically: true)
                    let photoURL = URL.init(fileURLWithPath: localPath)
                    print("imageURl\(photoURL)")
                    
                    self.imgName = photoURL.absoluteString ?? ""
                    guard let mobileNum = appDelegate.loginUser?.mobile else {
                        return
                    }
                    MInioimageupload.shared().uploadMinioimages(mobileNo: mobileNum, ImageSTt: image!,isFrom:"",uploadFrom:"")
                    MInioimageupload.shared().callback = { message in
                        print("UploadImage::::::::::::::\(message)")
                        MILoader.shared.hideLoader()
                        self.profileImgUrl = message
                    }
                    
                    if self.profileImgUrl.isEmpty{
                        MILoader.shared.hideLoader()
                    }
                    
                }
                
            }
        }
    }
    
    @IBAction func btnDeleteImageCLK(_ sender : UIButton){
        
        if articleType == .editArticle {
            self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CMessageDeleteImage, btnOneTitle: CBtnYes, btnOneTapped: { [weak self] (action) in
                guard let self = self else { return }
                self.viewUploadedImageContainer.isHidden = true
                self.viewAddImageContainer.isHidden = false
                self.imgArticle.image = nil
                self.profileImgUrl = ""
                
            }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
        } else {
            self.viewUploadedImageContainer.isHidden = true
            self.viewAddImageContainer.isHidden = false
            self.imgArticle.image = nil
            self.profileImgUrl = ""
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
        DispatchQueue.main.async {
            self.txtInviteType.updatePlaceholderFrame(true)
        }
    }
    
    @objc fileprivate func btnAddArticleClicked(_ sender : UIBarButtonItem) {
        
        self.resignKeyboard()
        if (txtArticleTitle.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageArticleTitle, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }else if (categoryDropDownView.txtCategory.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageArticleCategory, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }else if (txtViewArticleContent.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageArticleContent, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }
        else if (self.selectedInviteType == 1 || self.selectedInviteType == 2) && arrSelectedGroupFriends.count == 0 {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageSelectContactGroupArticle, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }else{
            self.addEditArticle()

//            var charSet = CharacterSet.init(charactersIn: SPECIALCHARNOTALLOWED)
//            if (txtViewArticleContent.text.rangeOfCharacter(from: charSet) != nil) || (txtArticleTitle.text?.rangeOfCharacter(from: charSet) != nil)
//                {
//                    print("true")
//                    self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageSpecial, btnOneTitle: CBtnOk, btnOneTapped: nil)
//                    return
//                }else{
//                    self.addEditArticle()
//                }
        }
        
    }

    func removeSpecialCharsFromString(text: String) -> String {
        let okayChars = Set(SPECIALCHAR)
        return text.filter {okayChars.contains($0) }
    }
    
}

// MARK:-  --------- Generic UITextView Delegate
extension AddArticleViewController: GenericTextViewDelegate{
    
    func genericTextViewDidChange(_ textView: UITextView, height: CGFloat){
        if textView == txtViewArticleContent{
            lblTextCount.text = "\(textView.text.count)/5000"
        }
       
    }
}

extension AddArticleViewController: GenericTextFieldDelegate {
    
    @objc func genericTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtArticleTitle{
            if txtArticleTitle.text?.count ?? 0 > 20{
                return false
            }
            if string.isSingleEmoji {
                return (string == string)
            }else {
                if string.count <= 20{
                    return (string == string)
//                    let inverted = NSCharacterSet(charactersIn: SPECIALCHARNOTALLOWED).inverted
//
//                        let filtered = string.components(separatedBy: inverted).joined(separator: "")
//
//                        if (string.isEmpty  && filtered.isEmpty ) {
//                                    let isBackSpace = strcmp(string, "\\b")
//                                    if (isBackSpace == -92) {
//                                        print("Backspace was pressed")
//                                        return (string == filtered)
//                                    }
//                        } else {
//                            return (string != filtered)
//                        }
//
//                }else{
//                    return (string == "")
                }
         
//                let cs = NSCharacterSet(charactersIn: SPECIALCHAR).inverted
//                let filtered = string.components(separatedBy: cs).joined(separator: "")
//                return (string == filtered)
            }
        }
        return true
    }
}

extension AddArticleViewController{
    
    func removeSpecialCharacters(from text: String) -> String {
        let okayChars = CharacterSet(charactersIn: SPECIALCHAR)
        return String(text.unicodeScalars.filter { okayChars.contains($0) || $0.properties.isEmoji })
    }
    
    
}
extension String {
   var containsSpecialCharacter: Bool {
      let regex = SPECIALCHAR
      let testString = NSPredicate(format:"SELF MATCHES %@", regex)
      return testString.evaluate(with: self)
   }
}
