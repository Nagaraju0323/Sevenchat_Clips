//
//  AddArticleViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 16/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : AddArticleViewController                    *
 * Changes :                                             *
 * Add article and limit with 5000 charectes             *
 ********************************************************/

import UIKit

enum ArticleType : Int {
    case editArticle = 0
    case addArticle = 1
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
    @IBOutlet weak var txtArticleTitle : MIGenericTextFiled!
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
        
        txtArticleTitle.txtDelegate = self
        if articleType == .editArticle {
            self.loadArticleDetailFromServer()
        }
        viewUploadedImageContainer.isHidden = true
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: #imageLiteral(resourceName: "ic_add_post"), style: .plain, target: self, action: #selector(btnAddArticleClicked(_:)))]
        
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
        self.txtViewArticleContent.text = strQuote
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
        
        let postcont = txtViewArticleContent.text.replace(string: "\n", replacement: "\\n")
        
        var dict :[String:Any] = [
            CUserId:userID.description,
            "image":profileImgUrl,
            "post_title":txtArticleTitle.text ?? "",
            "post_category": categoryDropDownView.txtCategory.text ?? "" ,
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
        txtViewArticleContent.text = articleInfo.valueForString(key: CContent)
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
                    MInioimageupload.shared().callback = { message in
                        print("UploadImage::::::::::::::\(message)")
                        self.profileImgUrl = message
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
            // call api here......
            
            if txtViewArticleContent.text != ""{
                let characterset = CharacterSet(charactersIn:SPECIALCHAR)
                if txtViewArticleContent.text.rangeOfCharacter(from: characterset.inverted) != nil || txtArticleTitle.text?.rangeOfCharacter(from: characterset.inverted) != nil {
                   print("true")
                    
                    self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: "Avoid Special Chrectrests", btnOneTitle: CBtnOk, btnOneTapped: nil)
                    
                } else {
                   print("false")
                    self.addEditArticle()
                }
            }
//            self.addEditArticle()
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
            let cs = NSCharacterSet(charactersIn: SPECIALCHAR).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            return (string == filtered)
        }
        return true
    }
}


extension String {
   var containsSpecialCharacter: Bool {
      let regex = SPECIALCHAR
      let testString = NSPredicate(format:"SELF MATCHES %@", regex)
      return testString.evaluate(with: self)
   }
}
