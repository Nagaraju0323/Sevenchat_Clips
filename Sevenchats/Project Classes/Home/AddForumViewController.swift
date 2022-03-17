//
//  AddForumViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 20/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : AddForumViewController                      *
 * Changes :                                             *
 * AddForum with text Limit 5000 charectes                *
 ********************************************************/

import UIKit

enum ForumType : Int {
    case addForum = 0
    case editForum = 1
    
}

class AddForumViewController: ParentViewController {
    
    var forumType : ForumType!
    
    
    @IBOutlet weak var topContainer : UIView!
    @IBOutlet weak var clGroupFriend : UICollectionView!
    @IBOutlet weak var btnAddMoreFriends : UIButton!
    @IBOutlet weak var btnSelectGroupFriend : UIButton!
    
    @IBOutlet weak var txtForumTitle : MIGenericTextFiled!
    @IBOutlet weak var txtForumAgeLimit : MIGenericTextFiled!
    @IBOutlet weak var txtViewForumMessage : GenericTextView!{
        didSet{
            self.txtViewForumMessage.txtDelegate = self
            self.txtViewForumMessage.isScrollEnabled = true
            self.txtViewForumMessage.textLimit = "150"
            self.txtViewForumMessage.type = "1"
        }
    }
    @IBOutlet weak var viewSelectGroup : UIView!
    @IBOutlet weak var scrollViewContainer : UIView!
    @IBOutlet weak var lblTextCount : UILabel!
    @IBOutlet private weak var categoryDropDownView: CustomDropDownView!
    @IBOutlet weak var txtInviteType : MIGenericTextFiled!
    
    var selectedInviteType : Int = 3 {
        didSet{
            self.didChangeInviteType()
        }
    }
    
    var arrSelectedGroupFriends = [[String : Any]]()
    var forumID : Int?
    var categoryID : Int?
    var arrSubCategory =  [[String : Any]]()
    var categorysubName : String?
    var apiTask : URLSessionTask?
    var currentPage : Int = 1
    var categoryName : String?
    var arrsubCategorys : [MDLIntrestSubCategory] = []
    var quoteDesc = ""
    var postContent = ""
    var postTxtFieldContent = ""
    var post_ID:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Initialization()
        txtForumTitle.txtDelegate = self
        topContainer.isHidden = true
        viewSelectGroup.isHidden = true
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
        if forumType == .editForum{
            self.loadForumDetailFromServer()
        }
        setQuoteText()
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: #imageLiteral(resourceName: "ic_add_post"), style: .plain, target: self, action: #selector(btnAddForumClicked(_:)))]
        
        let arrCategory = MIGeneralsAPI.shared().fetchCategoryFromLocalForum()
        
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
        self.txtViewForumMessage.text = strQuote
        self.lblTextCount.text = "\(strQuote.count)/5000"
        
        GCDMainThread.async {
            self.txtViewForumMessage.updatePlaceholderFrame(true)
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
        
        if forumType == .editForum{
            self.title = CNavFavEditForum
        }else{
            self.title = CNavFavAddForum
        }
        txtInviteType.placeHolder = CVisiblity
        
        txtForumTitle.placeHolder = CForumPlaceholderTitle
        categoryDropDownView.txtCategory.placeholder = CForumPlaceholderSelecetCategory
        txtViewForumMessage.placeHolder = CForumPlaceholderContent
        btnSelectGroupFriend.setTitle(CMessagePostsSelectFriends, for: .normal)
    }
}

// MARK:- --------- Api Functions
extension AddForumViewController{
    fileprivate func addEditForum(){
        
        var apiPara = [String : Any]()
        var apiParaGroups = [String]()
        var apiParaFriends = [String]()
        
        apiPara[CPostType] = 5
        apiPara[CTitle] = txtForumTitle.text
        apiPara[CCategory_Id] = categoryDropDownView.txtCategory.text
        apiPara[CPost_Detail] = txtViewForumMessage.text
        apiPara[CPublish_To] = self.selectedInviteType
        let addforum = postContent.replace(string: "\n", replacement: "\\n")
        
        // When user editing the article....
        if forumType == .editForum{
            apiPara[CId] = forumID
        }
        guard let userID = appDelegate.loginUser?.user_id else { return }
        var dict :[String:Any]  =  [
            "user_id":userID.description,
            "image":"",
            "post_title":postTxtFieldContent,
            "post_category":categoryDropDownView.txtCategory.text!,
            "post_content":addforum,
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
        
        
        APIRequest.shared().addEditPost(para: dict, image: nil, apiKeyCall: CAPITagforums) { [weak self] (response, error) in
            guard let self = self else { return }
            if response != nil && error == nil{
                
                
                if let responseData = response![CJsonData] as? [[String : Any]] {
                    for data in responseData{
                        self.post_ID = data.valueForString(key: "post_id")
                    }
                }
                
                
                if let metaInfo = response![CJsonMeta] as? [String : Any] {
                    let name = (appDelegate.loginUser?.first_name ?? "") + " " + (appDelegate.loginUser?.last_name ?? "")
                    guard let image = appDelegate.loginUser?.profile_img else { return }
                    let stausLike = metaInfo["status"] as? String ?? "0"
                    if stausLike == "0" {
 
                        MIGeneralsAPI.shared().addRewardsPoints(CPostcreate,message:CPostcreate,type:"forum",title: self.txtForumTitle.text! ,name:name,icon:image, detail_text: "post_point",target_id: self.post_ID?.toInt ?? 0)

                        MIGeneralsAPI.shared().refreshPostRelatedScreens(metaInfo,self.forumID, self,.addPost, rss_id: 0)
                        
                    }
                }
                
                self.navigationController?.popViewController(animated: true)
                CTopMostViewController.presentAlertViewWithOneButton(alertTitle: "", alertMessage: self.forumType == .editForum ? CMessageForumPostUpdated : CMessageForumPostUpload, btnOneTitle: CBtnOk, btnOneTapped: nil)
                
                if let forumInfo = response![CJsonData] as? [String : Any]{
//                    MIGeneralsAPI.shared().refreshPostRelatedScreens(forumInfo,self.forumID, self, self.forumType == .editForum ? .editPost : .addPost, rss_id: 0)
                    
                    APIRequest.shared().saveNewInterest(interestID: forumInfo.valueForInt(key: CCategory_Id) ?? 0, interestName: forumInfo.valueForString(key: CCategory))
                }
            }
        }
    }
    
    fileprivate func loadForumDetailFromServer(){
        if let forumID = self.forumID{
            
            APIRequest.shared().viewPostDetailNew(postID: forumID, apiKeyCall: CAPITagforumsDetials){ [weak self] (response, error) in
                guard let self = self else { return }
                if response != nil {
                    self.parentView.isHidden = false
                    if let Info = response!["data"] as? [[String:Any]]{
                        
                        print(Info as Any)
                        for forumInfo in Info {
                            
                            self.setForumDetail(forumInfo)
                        }
                    }
                }
            }
        }
        
    }
    
    fileprivate func setForumDetail (_ forumInfo : [String : Any]) {
        
        self.categoryID = forumInfo.valueForInt(key: CCategory_Id)
        txtForumTitle.text = forumInfo.valueForString(key: CTitle)
        categoryDropDownView.txtCategory.text = forumInfo.valueForString(key: CCategory)
        txtViewForumMessage.text = forumInfo.valueForString(key: CContent)
        //...Set invite type
        self.selectedInviteType = forumInfo.valueForInt(key: CPublish_To) ?? 3
        
        switch self.selectedInviteType {
        case 1:
            if let arrInvitee = forumInfo[CInvite_Groups] as? [[String : Any]]{
                arrSelectedGroupFriends = arrInvitee
            }
        case 2:
            if let arrInvitee = forumInfo[CInvite_Friend] as? [[String : Any]]{
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
            self.txtViewForumMessage.updatePlaceholderFrame(true)
        }
    }
    
    
}

// MARK:- --------- UICollectionView Delegate/Datasources
extension AddForumViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
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

// MARK:- ----------- Action Event
extension AddForumViewController{
    
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
    
    @objc fileprivate func btnAddForumClicked(_ sender : UIBarButtonItem) {
        self.resignKeyboard()
        
        if (txtForumTitle.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageForumTitle, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }else if (categoryDropDownView.txtCategory.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageForumCategory, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }else if (txtViewForumMessage.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageForumContent, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }
        
        else if (self.selectedInviteType == 1 || self.selectedInviteType == 2) && arrSelectedGroupFriends.count == 0 {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageSelectContactGroupForum, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }else{
            if txtViewForumMessage.text != "" && txtForumTitle.text != ""{
                let characterset = CharacterSet(charactersIn:SPECIALCHAR)
                if txtViewForumMessage.text.rangeOfCharacter(from: characterset.inverted) != nil || txtForumTitle.text?.rangeOfCharacter(from: characterset.inverted) != nil {
                    print("contains Special charecter")
                  postContent = removeSpecialCharacters(from: txtViewForumMessage.text)
                  if txtForumTitle.text != ""{
                      postTxtFieldContent = removeSpecialCharacters(from: txtForumTitle.text!)
                      print("specialcCharecte\(postTxtFieldContent)")
                  }
                  self.addEditForum()
                } else {
                   print("false")
                    postContent = txtViewForumMessage.text ?? ""
                    postTxtFieldContent = txtForumTitle.text ?? ""
                    self.addEditForum()
                }
            }
           // self.addEditForum()
        }
    }
}

extension AddForumViewController{
    func fetchsubCategoryFromLocal() -> [[String : Any]] {
        var arrCategory = [[String : Any]]()
        
        if arrCategory.count < 1 {
            // If not intereste selected by user then show all interest.....
            let arrCategoryTemp = TblSubIntrest.fetchAllObjects()
            for interest in arrCategoryTemp!{
                var dicData = [String : Any]()
                let interestInfo = interest as? TblSubIntrest
                dicData[CinterestLevel2] = interestInfo?.interest_level2
                arrCategory.append(dicData)
            }
        }
        if !arrCategory.isEmpty{
            let sortedResults =  arrCategory.sorted { (obj1, obj2) -> Bool in
                (obj1[CinterestLevel2] as! String).localizedCaseInsensitiveCompare(obj2[CinterestLevel2] as! String) == .orderedAscending
            }
            return sortedResults
        }
        return arrCategory
    }
    
}


// MARK:-  --------- Generic UITextView Delegate
extension AddForumViewController: GenericTextViewDelegate{
    
    func genericTextViewDidChange(_ textView: UITextView, height: CGFloat){
        
        if textView == txtViewForumMessage{
            lblTextCount.text = "\(textView.text.count)/5000"
        }
    }
    
}


extension AddForumViewController: GenericTextFieldDelegate {
    
    @objc func genericTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtForumTitle{
            if txtForumTitle.text?.count ?? 0 > 20{
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
extension AddForumViewController {
func removeSpecialCharacters(from text: String) -> String {
    let okayChars = CharacterSet(charactersIn: SPECIALCHAR)
    return String(text.unicodeScalars.filter { okayChars.contains($0) || $0.properties.isEmoji })
}
}
