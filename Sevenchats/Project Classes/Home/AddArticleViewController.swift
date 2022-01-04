//
//  AddArticleViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 16/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

enum ArticleType : Int {
    case editArticle = 0
    case addArticle = 1
}

class AddArticleViewController: ParentViewController {
    
    var articleType : ArticleType!
    
    @IBOutlet weak var viewAddImageContainer : UIView!
    @IBOutlet weak var viewUploadedImageContainer : UIView!
    @IBOutlet weak var imgArticle : UIImageView!
    @IBOutlet weak var btnAddMoreFriends : UIButton!
    @IBOutlet weak var btnSelectGroupFriend : UIButton!
    @IBOutlet weak var lblUploadImage : UILabel!
    
    @IBOutlet weak var txtArticleTitle : MIGenericTextFiled!
    @IBOutlet weak var txtArticleAgeLimit : MIGenericTextFiled!
    @IBOutlet weak var txtViewArticleContent : GenericTextView!
    @IBOutlet weak var viewSelectGroup : UIView!
    @IBOutlet weak var scrollViewContainer : UIView!
    @IBOutlet private weak var categoryDropDownView: CustomDropDownView!
//    @IBOutlet private weak var subcategoryDropDownView: CustomDropDownView!
    
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
    var arrSubCategory =  [[String : Any]]()
    var arrsubCategorys : [MDLProductSubCategory] = []
    
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
        
        if articleType == .editArticle {
            self.loadArticleDetailFromServer()
        }
        viewUploadedImageContainer.isHidden = true
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: #imageLiteral(resourceName: "ic_add_post"), style: .plain, target: self, action: #selector(btnAddArticleClicked(_:)))]
        
//        let arrCategory = MIGeneralsAPI.shared().fetchCategoryFromLocal()
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
//            self.loadInterestList(interestType : self.categoryName ?? "" , showLoader : true)
        }
        
        /// On select text from the auto-complition
//        subcategoryDropDownView.onSelectText = { [weak self] (item) in
//
//            guard let `self` = self else { return }
//
//            let objArry = self.arrsubCategorys.filter({ (obj) -> Bool in
//                return ((obj.interestLevel2) == item)
//            })
//
//            if (objArry.count > 0) {
//                self.categorysubName = (objArry.first?.interestLevel2) ?? ""
//            }
//        }
        
        let arrInviteType = [CPostPostsInviteGroups, CPostPostsInviteContacts,  CPostPostsInvitePublic, CPostPostsInviteAllFriends]
        
        txtInviteType.setPickerData(arrPickerData: arrInviteType, selectedPickerDataHandler: { [weak self] (text, row, component) in
            guard let self = self else { return }
            self.selectedInviteType = (row + 1)
        }, defaultPlaceholder: CPostPostsInviteAllFriends)
        
        // By default `All type` selected
        self.selectedInviteType = 4
        
//        txtArticleAgeLimit.textLimit = 3
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
//        subcategoryDropDownView.txtCategory.placeholder = CArticlePlaceholderSelecetCategory
        txtViewArticleContent.placeHolder = CArticlePlaceholderContent
//        txtArticleAgeLimit.placeHolder = CPostPlaceholderMinAge
        txtInviteType.placeHolder = CVisiblity
        
        btnSelectGroupFriend.setTitle(CMessagePostsSelectFriends, for: .normal)
    }
}

// MARK:- --------- Api Functions
extension AddArticleViewController{
    
    
//    func loadInterestList(interestType : String, showLoader : Bool) {
//
//        if apiTask?.state == URLSessionTask.State.running {
//            return
//        }
//        guard let langName = appDelegate.loginUser?.lang_name else {return}
//
//        apiTask = APIRequest.shared().getInterestSubListNew(langName : langName,interestType:interestType, page: currentPage, showLoader : showLoader) { (response, error) in
//            self.arrsubCategorys.removeAll()
//            if response != nil && error == nil {
//                if let arrData = response![CJsonData] as? [[String : Any]]
//                {
//                    for obj in arrData{
//                        self.arrsubCategorys.append(MDLIntrestSubCategory(fromDictionary: obj))
//                    }
//
//                    self.subcategoryDropDownView.arrDataSource = self.arrsubCategorys.map({ (obj) -> String in
//                        return (obj.interestLevel2 ?? "")
//                    })
//
//                }
//            }
//        }
//    }
    
    
    fileprivate func addEditArticle(){
        var apiPara = [String : Any]()
        var apiParaGroups = [String]()
        var apiParaFriends = [String]()
        
        apiPara[CPostType] = 1
        apiPara[CTitle] = txtArticleTitle.text
        apiPara[CCategory_Id] = categoryDropDownView.txtCategory.text
        
        apiPara[CPost_Detail] = txtViewArticleContent.text
//        apiPara[CMin_Age] = txtArticleAgeLimit.text
        
//        apiPara[CPublish_To] = self.selectedInviteType
//        if self.selectedInviteType == 1{
//            // For group...
//            let groupIDS = arrSelectedGroupFriends.map({$0.valueForString(key: CGroupId) }).joined(separator: ",")
//            apiPara[CGroup_Ids] = groupIDS
//        }else if self.selectedInviteType == 2{
//            // For Contact...
//            let userIDS = arrSelectedGroupFriends.map({$0.valueForString(key: CUserId) }).joined(separator: ",")
//            apiPara[CInvite_Ids] = userIDS
//        }
        
        
        // When user editing the article....
        if articleType == .editArticle{
            apiPara[CId] = articleID
        }
        
        //TODO ::------------------------
        
        guard let userID = appDelegate.loginUser?.user_id else {return}
        
        let postcont = txtViewArticleContent.text.replace(string: "\n", replacement: "\\n")
        
        var dict :[String:Any] = [
            CUserId:userID.description,
            "image":profileImgUrl,
            "post_title":txtArticleTitle.text ?? "",
            "post_category": categoryDropDownView.txtCategory.text ?? "" ,
            "post_content":postcont,
            "age_limit":"16",
//            "targeted_audience":"none",
//            "selected_persons":"none"
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
        
        
        /*Oldcode by Mi
         APIRequest.shared().addEditPost(para: apiPara, image: imgArticle.image) { [weak self] (response, error) in
         guard let self = self else { return }
         if response != nil && error == nil{
         self.navigationController?.popViewController(animated: true)
         CTopMostViewController.presentAlertViewWithOneButton(alertTitle: "", alertMessage: self.articleType == .editArticle ? CMessageArticlePostUpdated : CMessageArticlePostUpload, btnOneTitle: CBtnOk, btnOneTapped: nil)
         if let articleInfo = response![CJsonData] as? [String : Any]{
         
         APIRequest.shared().saveNewInterest(interestID: articleInfo.valueForInt(key: CCategory_Id) ?? 0, interestName: articleInfo.valueForString(key: CCategory))
         MIGeneralsAPI.shared().refreshPostRelatedScreens(articleInfo,self.articleID, self, self.articleType == .editArticle ? .editPost : .addPost)
         }
         }
         }
         */
        
        
        //        APIRequest.shared().addEditPost(para: dict, image: imgArticle.image,apiKeyCall:CAPITagarticles) { [weak self] (response, error) in
        //            guard let self = self else { return }
        //            if response != nil && error == nil{
        //                self.navigationController?.popViewController(animated: true)
        //                CTopMostViewController.presentAlertViewWithOneButton(alertTitle: "", alertMessage: self.articleType == .editArticle ? CMessageArticlePostUpdated : CMessageArticlePostUpload, btnOneTitle: CBtnOk, btnOneTapped: nil)
        //                if let articleInfo = response![CJsonData] as? [String : Any]{
        //
        //                    APIRequest.shared().saveNewInterest(interestID: articleInfo.valueForInt(key: CCategory_Id) ?? 0, interestName: articleInfo.valueForString(key: CCategory))
        //                MIGeneralsAPI.shared().refreshPostRelatedScreens(articleInfo,self.articleID, self, self.articleType == .editArticle ? .editPost : .addPost)
        //                }
        //            }
        //        }
        APIRequest.shared().addEditPost(para: dict, image: imgArticle.image,apiKeyCall: CAPITagarticles) { [weak self] (response, error) in
            guard let self = self else { return }
            if response != nil && error == nil{
                let name = (appDelegate.loginUser?.first_name ?? "") + " " + (appDelegate.loginUser?.last_name ?? "")
                guard let image = appDelegate.loginUser?.profile_img else { return }
                MIGeneralsAPI.shared().addRewardsPoints(CPostcreate,message:"post_point",type:CPostcreate,title:"Article Add",name:name,icon:image)
                self.navigationController?.popViewController(animated: true)
                CTopMostViewController.presentAlertViewWithOneButton(alertTitle: "", alertMessage: self.articleType == .editArticle ? CMessageArticlePostUpdated : CMessageArticlePostUpload, btnOneTitle: CBtnOk, btnOneTapped: nil)
            }
        }
    }
    
    
    fileprivate func loadArticleDetailFromServer(){
        if let artID = self.articleID{
            
            APIRequest.shared().viewPostDetailNew(postID: artID, apiKeyCall: CAPITagarticlesDetials){ [weak self] (response, error) in
                //  APIRequest.shared().viewPostDetail(postID: shouID) { [weak self] (response, error) in
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
    
//    fileprivate func loadArticleDetailFromServer(){
//        if let artID = self.articleID{
//            APIRequest.shared().viewPostDetail(postID: artID) { [weak self] (response, error) in
//                guard let self = self else { return }
//                if response != nil {
//                    if let articleIfo = response![CJsonData] as? [String : Any]{
//                        self.setEventDetail(articleIfo)
//                    }
//                }
//            }
//        }
//
//    }
    
    fileprivate func setEventDetail (_ articleInfo : [String : Any]) {
        
        //        self.categoryID = articleInfo.valueForInt(key: CCategory_Id)
        self.categoryName = articleInfo.valueForString(key: CInteresttype)
        self.categorysubName = articleInfo.valueForString(key: CinterestLevel2)
        txtArticleTitle.text = articleInfo.valueForString(key: CTitle)
        categoryDropDownView.txtCategory.text = articleInfo.valueForString(key: CCategory)
        
        txtViewArticleContent.text = articleInfo.valueForString(key: CContent)
//        txtArticleAgeLimit.text = articleInfo.valueForString(key: CMinAge)
        
        //...Set Event image
        if articleInfo.valueForString(key: CImage) != "" {
            imgArticle.loadImageFromUrl(articleInfo.valueForString(key: CImage), false)
            self.viewAddImageContainer.isHidden = true
            self.viewUploadedImageContainer.isHidden = false
        }
        
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
        
        if arrSelectedGroupFriends.count == 0
        {
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
extension AddArticleViewController{
    
    @IBAction func btnUplaodImageCLK(_ sender : UIButton){
        
        self.presentImagePickerController(allowEditing: false) { [weak self](image, info) in
            guard let self = self else { return }
            if image != nil{
                self.imgArticle.image = image
                self.viewAddImageContainer.isHidden = true
                self.viewUploadedImageContainer.isHidden = false
               
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
                    
    //                MInioimageupload.shared().uploadMinioimage(ImgnameStr:image!)
                    //  MInioimageupload.shared().uploadMinioVideo(ImgnameStr:image!)
                    MInioimageupload.shared().callback = { message in
                        print("UploadImage::::::::::::::\(message)")
                        self.profileImgUrl = message
                                  }
                              }
                
              /*  guard let imageURL = info?[UIImagePickerController.InfoKey.imageURL] as? NSURL else {
                    return
                }
                
                self.imgName = imageURL.absoluteString ?? ""
                
                guard let mobileNum = appDelegate.loginUser?.mobile else {
                    return
                }
                MInioimageupload.shared().uploadMinioimages(mobileNo: mobileNum, ImageSTt: image!)
                
//                MInioimageupload.shared().uploadMinioimage(ImgnameStr:image!)
                //  MInioimageupload.shared().uploadMinioVideo(ImgnameStr:image!)
                MInioimageupload.shared().callback = { message in
                    print("UploadImage::::::::::::::\(message)")
                    self.profileImgUrl = message
                }*/
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
                
            }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
        } else {
            self.viewUploadedImageContainer.isHidden = true
            self.viewAddImageContainer.isHidden = false
            self.imgArticle.image = nil
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
            //self.txtInviteType.text = CPostPostsInviteAllFriends
          self.txtInviteType.text = CPostPostsInvitePublic
            btnSelectGroupFriend.isHidden = true
            viewSelectGroup.hide(byHeight: true)
        case 4:
            self.txtInviteType.text = CPostPostsInviteAllFriends
           // self.txtInviteType.text = CPostPostsInvitePublic
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
//        let ageValue = txtArticleAgeLimit.text?.toInt ?? 0
//        if imgArticle.image == nil{
//            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageArticleImage, btnOneTitle: CBtnOk, btnOneTapped: nil)
//        }else
        if (txtArticleTitle.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageArticleTitle, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }else if (categoryDropDownView.txtCategory.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageArticleCategory, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }else if (txtViewArticleContent.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageArticleContent, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }
//        else if (txtArticleAgeLimit.text?.isBlank)! {
//            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessagePostAgeLimit, btnOneTitle: CBtnOk, btnOneTapped: nil)
//        }
//        else if ageValue < 13 || ageValue > 999  {
//            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMinumumAgeLimitBetween13To100, btnOneTitle: CBtnOk, btnOneTapped: nil)
//        }
        else if (self.selectedInviteType == 1 || self.selectedInviteType == 2) && arrSelectedGroupFriends.count == 0 {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageSelectContactGroupArticle, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }else{
            // call api here......
            self.addEditArticle()
        }
        
    }
    
}
