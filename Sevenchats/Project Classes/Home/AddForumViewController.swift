//
//  AddForumViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 20/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

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
    @IBOutlet weak var txtViewForumMessage : GenericTextView!
    @IBOutlet weak var viewSelectGroup : UIView!
    @IBOutlet weak var scrollViewContainer : UIView!
    @IBOutlet private weak var categoryDropDownView: CustomDropDownView!
//    @IBOutlet private weak var subcategoryDropDownView: CustomDropDownView!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Initialization()
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
            
//            if (objArry.count > 0) {
//                self.categoryID = (objArry.first?[CId] as? Int) ?? 0
//            }
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
        
        
//        txtForumAgeLimit.textLimit = 3
        let arrInviteType = [CPostPostsInviteGroups, CPostPostsInviteContacts,  CPostPostsInvitePublic, CPostPostsInviteAllFriends]
        
        txtInviteType.setPickerData(arrPickerData: arrInviteType, selectedPickerDataHandler: { [weak self] (text, row, component) in
            guard let self = self else { return }
            self.selectedInviteType = (row + 1)
            }, defaultPlaceholder: CPostPostsInviteGroups)
        
        // By default `All type` selected
        self.selectedInviteType = 4
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
//        subcategoryDropDownView.txtCategory.placeholder = CForumPlaceholderSelecetCategory
        txtViewForumMessage.placeHolder = CForumPlaceholderContent
//        txtForumAgeLimit.placeHolder = CPostPlaceholderMinAge
        
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
//        apiPara[CMin_Age] = txtForumAgeLimit.text
        
        apiPara[CPublish_To] = self.selectedInviteType
//        if self.selectedInviteType == 1{
//            // For group...
//            let groupIDS = arrSelectedGroupFriends.map({$0.valueForString(key: CGroupId) }).joined(separator: ",")
//            apiParaGroups = groupIDS
////            apiPara[CGroup_Ids] = groupIDS
//        }else if self.selectedInviteType == 2{
//            // For Contact...
////            let userIDS = arrSelectedGroupFriends.map({$0.valueForString(key: CUserId) }).joined(separator: ",")
////            apiPara[CInvite_Ids] = userIDS
//            let userIDS = arrSelectedGroupFriends.map({$0.valueForString(key: CFriendUserID) }).joined(separator: ",")
//
//            apiParaFriends[CSelectedPerson] = userIDS
////            apiPara[CInvite_Ids] = userIDS
//        }
        
        let addforum = txtViewForumMessage.text.replace(string: "\n", replacement: "\\n")
        
        // When user editing the article....
        if forumType == .editForum{
            apiPara[CId] = forumID
        }
        /*********Newcode by Nagarju*****/
        guard let userID = appDelegate.loginUser?.user_id else { return }
        var dict :[String:Any]  =  [
            "user_id":userID.description,
            "image":"",
            "post_title":txtForumTitle.text!,
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

                if let metaInfo = response![CJsonMeta] as? [String : Any] {
                    let name = (appDelegate.loginUser?.first_name ?? "") + " " + (appDelegate.loginUser?.last_name ?? "")
                    guard let image = appDelegate.loginUser?.profile_img else { return }
                    let stausLike = metaInfo["status"] as? String ?? "0"
                    if stausLike == "0" {
                        
                        MIGeneralsAPI.shared().addRewardsPoints(CPostcreate,message:"post_point",type:CPostcreate,title:"EvForum Add",name:name,icon:image)
                    }
                }
                
                self.navigationController?.popViewController(animated: true)
                CTopMostViewController.presentAlertViewWithOneButton(alertTitle: "", alertMessage: self.forumType == .editForum ? CMessageForumPostUpdated : CMessageForumPostUpload, btnOneTitle: CBtnOk, btnOneTapped: nil)

                if let forumInfo = response![CJsonData] as? [String : Any]{
                    MIGeneralsAPI.shared().refreshPostRelatedScreens(forumInfo,self.forumID, self, self.forumType == .editForum ? .editPost : .addPost)
                    
                    APIRequest.shared().saveNewInterest(interestID: forumInfo.valueForInt(key: CCategory_Id) ?? 0, interestName: forumInfo.valueForString(key: CCategory))
                }
            }
        }
    }
    
    fileprivate func loadForumDetailFromServer(){
           if let forumID = self.forumID{
               
               APIRequest.shared().viewPostDetailNew(postID: forumID, apiKeyCall: CAPITagforumsDetials){ [weak self] (response, error) in
             //  APIRequest.shared().viewPostDetail(postID: shouID) { [weak self] (response, error) in
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
    
    
//    fileprivate func loadForumDetailFromServer(){
//        if let forumID = self.forumID{
//            APIRequest.shared().viewPostDetail(postID: forumID) { [weak self] (response, error) in
//                guard let self = self else { return }
//                if response != nil {
//                    if let forumInfo = response![CJsonData] as? [String : Any]{
//                        self.setForumDetail(forumInfo)
//                    }
//                }
//            }
//        }
//
//    }
//
    fileprivate func setForumDetail (_ forumInfo : [String : Any]) {
        
        self.categoryID = forumInfo.valueForInt(key: CCategory_Id)
        txtForumTitle.text = forumInfo.valueForString(key: CTitle)
        categoryDropDownView.txtCategory.text = forumInfo.valueForString(key: CCategory)
        txtViewForumMessage.text = forumInfo.valueForString(key: CContent)
//        txtForumAgeLimit.text = forumInfo.valueForString(key: CMinAge)
        
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
    
   
//    func loadInterestList(interestType : String, showLoader : Bool) {
//
//        if apiTask?.state == URLSessionTask.State.running {
//            return
//        }
////
////        // Add load more indicator here...
////        if self.currentPage > 2 {
////            self.tblInterest.tableFooterView = self.loadMoreIndicator(ColorAppTheme)
////        }else{
////            self.tblInterest.tableFooterView = nil
////        }
//        guard let langName = appDelegate.loginUser?.lang_name else {
//            return
//        }
//
//
//        apiTask = APIRequest.shared().getInterestSubListNew(langName : langName,interestType:interestType, page: currentPage, showLoader : showLoader) { (response, error) in
////            self.refreshControl.endRefreshing()
////            self.tblInterest.tableFooterView = nil
//            if response != nil && error == nil {
//                if let arrData = response![CJsonData] as? [[String : Any]]
//                {
//                    print(arrData)
//                    let arrsubCategory = self.fetchsubCategoryFromLocal()
//                    self.arrSubCategory = arrsubCategory
//                    /// Set Dropdown on txtCategory
//                    self.subcategoryDropDownView.arrDataSource = arrsubCategory.map({ (obj) -> String in
//                        return (obj[CinterestLevel2] as? String ?? "")
//
//
//                    })
//
//                }
//            }
//        }
//    }
    
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
        
        GCDMainThread.async {
            self.txtInviteType.updatePlaceholderFrame(true)
        }
    }
    
    @objc fileprivate func btnAddForumClicked(_ sender : UIBarButtonItem) {
        self.resignKeyboard()
        
//        let ageValue = txtForumAgeLimit.text?.toInt ?? 0
        
        if (txtForumTitle.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageForumTitle, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }else if (categoryDropDownView.txtCategory.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageForumCategory, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }else if (txtViewForumMessage.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageForumContent, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }
//        else if (txtForumAgeLimit.text?.isBlank)! {
//            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessagePostAgeLimit, btnOneTitle: CBtnOk, btnOneTapped: nil)
//        }else if ageValue < 13 || ageValue > 999  {
//            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMinumumAgeLimitBetween13To100, btnOneTitle: CBtnOk, btnOneTapped: nil)
//        }
        else if (self.selectedInviteType == 1 || self.selectedInviteType == 2) && arrSelectedGroupFriends.count == 0 {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageSelectContactGroupForum, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }else{
            self.addEditForum()
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
