//
//  SharePostViewController.swift
//  Sevenchats
//
//  Created by mac-00020 on 22/08/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : SharePostViewController                     *
 * Changes :                                             *
 * Deisplay Share Details user can like and comments,    *
 * Delete forparticular post                             *
 ********************************************************/

import Foundation
import UIKit

class SharePostViewController: ParentViewController {
    
    //MARK: - IBOutlet/Object/Variable Declaration
    @IBOutlet weak var clGroupFriend : UICollectionView!{
        didSet{
            clGroupFriend.delegate = self
            clGroupFriend.dataSource = self
        }
    }
    @IBOutlet weak var btnAddMoreFriends : UIButton!
    @IBOutlet weak var btnSelectGroupFriend : UIButton!
    @IBOutlet weak var viewSelectGroup : UIView!
    @IBOutlet weak var selectImage : UIImageView!
    @IBOutlet weak var textViewMessage : GenericTextView!{
    didSet{
        self.textViewMessage.txtDelegate = self
        self.textViewMessage.textLimit = "150"
        self.textViewMessage.type = "3"
    }
    }
    @IBOutlet weak var txtInviteType : MIGenericTextFiled!
    var selectedInviteType : Int = 3 {
        didSet{
            self.didChangeInviteType()
        }
    }
    
    var arrSelectedGroupFriends = [[String : Any]]()
    var postData : [String:Any] = [:]
    var isFromEdit = false
    var postContent = ""
    
    //MARK: - View life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.txtInviteType.isHidden = true
        self.selectImage.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - Memory management methods
    deinit {
        print("### deinit -> SharePostViewController")
    }
}

//MARK: - SetupUI
extension SharePostViewController {
    
    fileprivate func setupView() {
        
        let sendButtonItem = BlockBarButtonItem(image: UIImage(named: "ic_send"), style: .plain) { [weak self] (_) in
            guard let _ = self else {return}
            self?.resignKeyboard()
            if self?.isValidForAddPost() ?? false{
                print("Ready for post")
                if self?.textViewMessage.text != ""{
                    let characterset = CharacterSet(charactersIn:SPECIALCHAR)
                    if self?.textViewMessage.text.rangeOfCharacter(from: characterset.inverted) != nil {
                        print("contains Special charecter")
                        self?.postContent = self?.removeSpecialCharacters(from: self?.textViewMessage.text ?? "") ?? ""
                        self?.apiForSharePost()
                        
                    } else {
                       print("false")
                        self?.postContent = self?.textViewMessage.text ?? ""
                        self?.apiForSharePost()
                    }
                }
//                self?.apiForSharePost()
            }
        }
        self.navigationItem.rightBarButtonItem = sendButtonItem
        
        let arrInviteType = [CPostPostsInviteGroups, CPostPostsInviteContacts, CPostPostsInviteAllFriends, CPostPostsInvitePublic]
        
        txtInviteType.setPickerData(arrPickerData: arrInviteType, selectedPickerDataHandler: { [weak self] (text, row, component) in
            guard let self = self else { return }
            self.selectedInviteType = (row + 1)
            }, defaultPlaceholder: CPostPostsInviteGroups)
        
        // By default `All type` selected
        self.selectedInviteType = 3
        
        updateUIAccordingToLanguage()
        if isFromEdit{
            setSharedInfo()
        }
    }
    
    fileprivate func updateUIAccordingToLanguage(){
        
        if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
            // Reverse Flow...
            
            btnSelectGroupFriend.contentHorizontalAlignment = .right
            clGroupFriend.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }else{
            // Normal Flow...
            
            btnSelectGroupFriend.contentHorizontalAlignment = .left
            clGroupFriend.transform = CGAffineTransform.identity
        }
        
        self.title = CBtnShare
        txtInviteType.placeHolder = CVisiblity
        
        textViewMessage.placeHolder = CWriteYourMessageHereOptional
        btnSelectGroupFriend.setTitle(CMessagePostsSelectFriends, for: .normal)
    }
    
    fileprivate func isValidForAddPost() -> Bool{
        var message = ""
        switch self.postData.valueForInt(key: CPostType) {
        case CStaticArticleId:
            message = CMessageSelectContactGroupArticle
        case CStaticGalleryId:
            message = CMessageSelectContactGroupImage
        case CStaticChirpyId:
            message = CMessageSelectContactGroupChirpy
        case CStaticShoutId:
            message = CMessageSelectContactGroupShout
        case CStaticForumId:
            message = CMessageSelectContactGroupForum
        case CStaticEventId:
            message = CMessageSelectContactGroupEvent
        case CStaticPollId:
            message = CMessageSelectContactGroupPoll
        default:
            message = "Please select to whom you want to post this post."
            break
        }
        if (self.selectedInviteType == 1 || self.selectedInviteType == 2) && arrSelectedGroupFriends.count == 0 {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: message, btnOneTitle: CBtnOk, btnOneTapped: nil)
            return false
        }
        return true
    }
    
    fileprivate func setSharedInfo() {
        
        if let message = (self.postData[CSharedPost] as? [String:Any] ?? [:])[CMessage] as? String {
            self.textViewMessage.text = message
        }
        print(self.postData)
        
        //...Set invite type
        self.selectedInviteType = self.postData.valueForInt(key: CPublish_To) ?? 3
        
        switch self.selectedInviteType {
        case 1:
            if let arrInvitee = self.postData[CInvite_Groups] as? [[String : Any]]{
                arrSelectedGroupFriends = arrInvitee
            }
        case 2:
            if let arrInvitee = self.postData[CInvite_Friend] as? [[String : Any]]{
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
            self.textViewMessage.updatePlaceholderFrame(true)
        }
    }
}

// MARK:- --------- UICollectionView Delegate/Datasources
extension SharePostViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrSelectedGroupFriends.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BubbleWithCancelCollCell", for: indexPath) as! BubbleWithCancelCollCell
        let selectedInfo = arrSelectedGroupFriends[indexPath.row]
        
        if (self.selectedInviteType == 2) {
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

// MARK:-  --------- Generic UITextView Delegate
extension SharePostViewController: GenericTextViewDelegate{
    
    func genericTextViewDidChange(_ textView: UITextView, height: CGFloat){
    }
}

// MARK:- --------- Action Event

extension SharePostViewController{
    
    @IBAction func btnSelectGroupFriendCLK(_ sender : UIButton){
        
        if let groupFriendVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "GroupFriendSelectionViewController") as? GroupFriendSelectionViewController{
            groupFriendVC.arrSelectedGroupFriend = self.arrSelectedGroupFriends
            groupFriendVC.isFriendList = (self.selectedInviteType == 2)
            groupFriendVC.setBlock { (arrSelected, message) in
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
            self.txtInviteType.text = CPostPostsInviteAllFriends
            btnSelectGroupFriend.isHidden = true
            viewSelectGroup.hide(byHeight: true)
        case 4:
            self.txtInviteType.text = CPostPostsInvitePublic
            btnSelectGroupFriend.isHidden = true
            viewSelectGroup.hide(byHeight: true)
        default:
            break
        }
        
        DispatchQueue.main.async {
            self.txtInviteType.updatePlaceholderFrame(true)
        }
    }
}

//MARK: - API's Calling
extension SharePostViewController {
    
    func apiForSharePost(){
        shareArticle()
    }
    
    fileprivate func getPostGeneralData() -> [String:Any]{
        
        var apiPara = [String : Any]()
        if let _ = postData[CPostType] as? Int{
            apiPara[CPostType] = 11
        }else{
            apiPara[CPostType] = 4 // Shout type
        }
        
        apiPara[CPublish_To] = self.selectedInviteType
        if self.selectedInviteType == 1{
            // For group...
            let groupIDS = arrSelectedGroupFriends.map({$0.valueForString(key: CGroupId) }).joined(separator: ",")
            apiPara[CGroup_Ids] = groupIDS
        }else if self.selectedInviteType == 2{
            // For Contact...
            let userIDS = arrSelectedGroupFriends.map({$0.valueForString(key: CUserId) }).joined(separator: ",")
            apiPara[CInvite_Ids] = userIDS
        }
       
        
        /*let isPostDeleted = postData.valueForInt(key: CIsPostDeleted)
        if isPostDeleted != 1{
            apiPara["shared_post_id"] = postData[COriginalPostId]
        }*/
        apiPara["shared_post_id"] = postData[COriginalPostId]
        apiPara["shared_message"] = postContent
        
        
        if isFromEdit{
            // When user editing the article....
            if let postID = (self.postData[CSharedPost] as? [String:Any] ?? [:])[CId] as? Int {
                apiPara[CId] = postID
            }
        }
        
        return apiPara
    }
    
    fileprivate func shareArticle(){
        let message = postContent.replace(string: "\n", replacement: "\\n")
        let apiPara = getPostGeneralData()
        //apiPara[CCategory_Id] = postData[CCategory_Id]
//        print(apiPara)
        let post_ID = 0
        guard let userID = appDelegate.loginUser?.user_id else {return}
        let dict :[String:Any]  =  [
            "user_id":userID,
            "element_id":postData[COriginalPostId]!,
            "message":message
        ]
        
        APIRequest.shared().addSharedPost(para: dict, image: nil) { [weak self] (response, error) in
            guard let self = self else { return }
            if response != nil && error == nil{
                self.navigationController?.popViewController(animated: true)
                var message = CPostHasBeenShared
                if self.isFromEdit{
                    message = CSharedPostHasBeenUpdated
                }
                CTopMostViewController.presentAlertViewWithOneButton(alertTitle: "", alertMessage: message, btnOneTitle: CBtnOk, btnOneTapped: nil)
                
                if let shoutInfo = response!["meta"] as? [String : Any]{
                    if shoutInfo.valueForString(key: "status")  == "0" {
                        if self.isFromEdit{
                            MIGeneralsAPI.shared().refreshPostRelatedScreens(shoutInfo,post_ID, self, .editPost, rss_id: 0)
                        }else{
                            MIGeneralsAPI.shared().refreshPostRelatedScreens(shoutInfo,post_ID, self, .addPost, rss_id: 0)
                        }
                   }
                }
            }
        }
    }
}
extension SharePostViewController{
    
    func removeSpecialCharacters(from text: String) -> String {
        let okayChars = CharacterSet(charactersIn: SPECIALCHAR)
        return String(text.unicodeScalars.filter { okayChars.contains($0) || $0.properties.isEmoji })
    }
    
    
}
