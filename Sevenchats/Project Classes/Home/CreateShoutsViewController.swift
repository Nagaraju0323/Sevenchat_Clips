//
//  CreateShoutsViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 21/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : CreateShoutsViewController                  *
 * Changes :                                             *
 * Create short message with text Limit 150 charectes    *
 ********************************************************/

import UIKit
import Foundation


enum ShoutsType : Int {
    case addShouts = 0
    case editShouts = 1
    case shareQuote = 3
}

class CreateShoutsViewController: ParentViewController {
    
    var shoutsType : ShoutsType!
    
    @IBOutlet weak var topContainer : UIView!
    
    @IBOutlet weak var clGroupFriend : UICollectionView!
    @IBOutlet weak var btnInviteGroup : UIButton!
    @IBOutlet weak var btnInviteContacts : UIButton!
    @IBOutlet weak var btnAddMoreFriends : UIButton!
    @IBOutlet weak var btnInviteAllFriend : UIButton!
    @IBOutlet weak var btnSelectGroupFriend : UIButton!
    @IBOutlet weak var viewSelectGroup : UIView!
    @IBOutlet weak var lblTextCount : UILabel!
    @IBOutlet weak var textViewMessage : GenericTextView!{
        didSet{
            self.textViewMessage.txtDelegate = self
            self.textViewMessage.textLimit = "150"
            self.textViewMessage.type = "3"
        }
    }
    
    var arrSelectedGroupFriends = [[String : Any]]()
    var shoutID : Int?
    var quoteDesc = ""
    var postContent = ""
    var post_ID :String?
    var editPost_id = ""
    
    
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
        if shoutsType == .editShouts{
            self.loadShoutDetailFromServer()
            self.setQuoteText()
        }
       
        textViewMessage.textContainerInset = UIEdgeInsets(top: 8, left: 0, bottom: 20, right: 0)
        
//        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: #imageLiteral(resourceName: "ic_add_post"), style: .plain, target: self, action: #selector(btnCreateShoutsClicked(_:)))]
        
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: #imageLiteral(resourceName: "ic_info_tint"), style: .plain, target: self, action: #selector(btnHelpInfoClicked(_:))),UIBarButtonItem(image: #imageLiteral(resourceName: "ic_add_post"), style: .plain, target: self, action: #selector(btnCreateShoutsClicked(_:)))]
        
        btnInviteTypeCLK(btnInviteAllFriend)
        
        if shoutsType == .addShouts || shoutsType == .shareQuote {
            self.setQuoteText()
        }
        
        
    }
    
    func updateUIAccordingToLanguage(){
        
        if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
            // Reverse Flow...
            btnInviteGroup.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 3)
            btnInviteGroup.contentHorizontalAlignment = .right
            
            btnInviteContacts.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 3)
            btnInviteContacts.contentHorizontalAlignment = .right
            
            btnInviteAllFriend.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 3)
            btnInviteAllFriend.contentHorizontalAlignment = .right
            
            btnSelectGroupFriend.contentHorizontalAlignment = .right
            clGroupFriend.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }else{
            // Normal Flow...
            btnInviteGroup.titleEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 0)
            btnInviteGroup.contentHorizontalAlignment = .left
            
            btnInviteContacts.titleEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 0)
            btnInviteContacts.contentHorizontalAlignment = .left
            
            btnInviteAllFriend.titleEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 0)
            btnInviteAllFriend.contentHorizontalAlignment = .left
            
            btnSelectGroupFriend.contentHorizontalAlignment = .left
            clGroupFriend.transform = CGAffineTransform.identity
        }
        
        if shoutsType == .editShouts{
            self.title = CNavEditShout
        }else{
            self.title = CNavAddShout
        }
        
        textViewMessage.placeHolder = CShoutPlaceholderContent
        btnSelectGroupFriend.setTitle(CMessagePostsSelectFriends, for: .normal)
        btnInviteGroup.setTitle(CPostPostsInviteGroups, for: .normal)
        btnInviteContacts.setTitle(CPostPostsInviteContacts, for: .normal)
        btnInviteAllFriend.setTitle(CPostPostsInviteAllFriends, for: .normal)
        
    }
}

// MARK:- --------- Api Functions
extension CreateShoutsViewController{
    func addEditShout(){
        var apiPara = [String : Any]()
        var apiParaGroups = [String]()
        var apiParaFriends = [String]()
        
        apiPara[CPostType] = 4
        apiPara[CPost_Detail] = textViewMessage.text
        
        if btnInviteGroup.isSelected{
            // For group...
            apiPara[CPublish_To] = 1
            let groupIDS = arrSelectedGroupFriends.map({$0.valueForString(key: CGroupId) }).joined(separator: ",")
            apiPara[CGroup_Ids] = groupIDS
        }else if btnInviteContacts.isSelected{
            // For Contact...
            apiPara[CPublish_To] = 2
            let userIDS = arrSelectedGroupFriends.map({$0.valueForString(key: CUserId) }).joined(separator: ",")
            apiPara[CInvite_Ids] = userIDS
        }else{
            // For All Friend...
            apiPara[CPublish_To] = 3
        }
        
        // When user editing the article....
        if shoutsType == .editShouts{
            apiPara[CId] = shoutID
        }
       
//
//        print("return\(return_Str)")
//        let values = textViewMessage.text.folding(options: .diacriticInsensitive, locale: .current)
        
        if shoutsType == .editShouts{
            
            guard let userid = appDelegate.loginUser?.user_id else {return}
            let userID = userid.description
    //        let txtshout = textViewMessage.text.replace(string: "\n", replacement: "\\n")
            let txtshout = textViewMessage.text.replace_str(replace: textViewMessage.text)
            var dict :[String:Any]  =  [
                    "post_id": editPost_id,
                    "image": "",
                    "post_title": "",
                    "post_content": txtshout,
                    "age_limit": "",
                    "targeted_audience": "",
                    "selected_persons": "",
                    "status_id": "1"
            ]
            
            if btnInviteGroup.isSelected{
                // For group...
                apiPara[CPublish_To] = 1
                let groupIDS = arrSelectedGroupFriends.map({$0.valueForString(key: CGroupId) }).joined(separator: ",")
                apiParaGroups = groupIDS.components(separatedBy: ",")
                
            }else if btnInviteContacts.isSelected{
                // For Contact...
                apiPara[CPublish_To] = 2
                let userIDS = arrSelectedGroupFriends.map({$0.valueForString(key: CFriendUserID) }).joined(separator: ",")
                apiParaFriends = userIDS.components(separatedBy: ",")
                
            }else{
                // For All Friend...
                apiPara[CPublish_To] = 3
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
            
            APIRequest.shared().editPost(para: dict, image: nil, apiKeyCall: CAPITagEditshouts) { [weak self] (response, error) in
                if response != nil && error == nil{
                    
                    if let responseData = response![CJsonData] as? [[String : Any]] {

                    }
//MARK:- Rewards point
                    
//                    if let metaInfo = response![CJsonMeta] as? [String : Any] {
//                        let name = (appDelegate.loginUser?.first_name ?? "") + " " + (appDelegate.loginUser?.last_name ?? "")
//                        guard let image = appDelegate.loginUser?.profile_img else { return }
//                        let stausLike = metaInfo["status"] as? String ?? "0"
//                        if stausLike == "0" {
//                           // MIGeneralsAPI.shared().addRewardsPoints(CPostcreate,message:CPostcreate,type:"shout",title: self?.textViewMessage.text! ?? "",name:name,icon:image, detail_text: "post_point",target_id: self?.post_ID?.toInt ?? 0)
//                        }
//                    }
                    if self?.shoutsType == .shareQuote{
                        (appDelegate.sideMenuController.leftViewController as? SideMenuViewController)?.selectIndex(0)
                        appDelegate.sideMenuController.rootViewController = UINavigationController.init(rootViewController: CStoryboardHome.instantiateViewController(withIdentifier: "HomeViewController"))
                    }else{
                        //self?.navigationController?.popViewController(animated: true)
                        self?.navigationController?.popToRootViewController(animated: true)
                    }
                    var message = ""
                    if self?.shoutsType == .editShouts{
                        message = CMessageShoutPostUpdated
                    }else if self?.shoutsType == .shareQuote{
                        message = CPostHasBeenShared
                    }else{
                        message = CMessageShoutPostUpload
                    }
                    
                    CTopMostViewController.presentAlertViewWithOneButton(alertTitle: "", alertMessage: message, btnOneTitle: CBtnOk, btnOneTapped: nil)
                    if let shoutInfo = response!["meta"] as? [String : Any]{
                        if shoutInfo.valueForString(key: "status")  == "0" {
                        MIGeneralsAPI.shared().refreshPostRelatedScreens(shoutInfo,self?.shoutID, self!, self?.shoutsType == .editShouts ? .editPost : .addPost, rss_id: 0)
                        }
                    }
                }
            }

        }else{
        guard let userid = appDelegate.loginUser?.user_id else {return}
        let userID = userid.description
//        let txtshout = textViewMessage.text.replace(string: "\n", replacement: "\\n")
        let txtshout = textViewMessage.text.replace_str(replace: textViewMessage.text)
        var dict :[String:Any]  =  [
            "user_id":userID,
            "image":"none", 
            "post_title":"none",
            "post_content":txtshout,
            "age_limit":"18",
            "targeted_audience":apiParaGroups,
            "selected_persons":apiParaFriends
        ]
        
        if btnInviteGroup.isSelected{
            // For group...
            apiPara[CPublish_To] = 1
            let groupIDS = arrSelectedGroupFriends.map({$0.valueForString(key: CGroupId) }).joined(separator: ",")
            apiParaGroups = groupIDS.components(separatedBy: ",")
            
        }else if btnInviteContacts.isSelected{
            // For Contact...
            apiPara[CPublish_To] = 2
            let userIDS = arrSelectedGroupFriends.map({$0.valueForString(key: CFriendUserID) }).joined(separator: ",")
            apiParaFriends = userIDS.components(separatedBy: ",")
            
        }else{
            // For All Friend...
            apiPara[CPublish_To] = 3
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
        
        APIRequest.shared().addEditPost(para: dict, image: nil, apiKeyCall: CAPITagshouts) { [weak self] (response, error) in
            if response != nil && error == nil{
                
                if let responseData = response![CJsonData] as? [[String : Any]] {
                    for data in responseData{
                        self?.post_ID = data.valueForString(key: "post_id")
                    }
                }
                
                if let metaInfo = response![CJsonMeta] as? [String : Any] {
                    let name = (appDelegate.loginUser?.first_name ?? "") + " " + (appDelegate.loginUser?.last_name ?? "")
                    guard let image = appDelegate.loginUser?.profile_img else { return }
                    let stausLike = metaInfo["status"] as? String ?? "0"
                    if stausLike == "0" {
                        MIGeneralsAPI.shared().addRewardsPoints(CPostcreate,message:CPostcreate,type:"shout",title: self?.textViewMessage.text! ?? "",name:name,icon:image, detail_text: "post_point",target_id: self?.post_ID?.toInt ?? 0)
                    }
                }
                
                if self?.shoutsType == .shareQuote{
                    (appDelegate.sideMenuController.leftViewController as? SideMenuViewController)?.selectIndex(0)
                    appDelegate.sideMenuController.rootViewController = UINavigationController.init(rootViewController: CStoryboardHome.instantiateViewController(withIdentifier: "HomeViewController"))
                }else{
                    self?.navigationController?.popViewController(animated: true)
                }
                var message = ""
                if self?.shoutsType == .editShouts{
                    message = CMessageShoutPostUpdated
                }else if self?.shoutsType == .shareQuote{
                    message = CPostHasBeenShared
                }else{
                    message = CMessageShoutPostUpload
                }
                
                CTopMostViewController.presentAlertViewWithOneButton(alertTitle: "", alertMessage: message, btnOneTitle: CBtnOk, btnOneTapped: nil)
                if let shoutInfo = response!["meta"] as? [String : Any]{
                    if shoutInfo.valueForString(key: "status")  == "0" {
                    MIGeneralsAPI.shared().refreshPostRelatedScreens(shoutInfo,self?.shoutID, self!, self?.shoutsType == .editShouts ? .editPost : .addPost, rss_id: 0)
                    }
                }
            }
        }
    }
    }
    
    fileprivate func loadShoutDetailFromServer(){
        if let shoutID = self.shoutID{
            
            APIRequest.shared().viewPostDetailNew(postID: shoutID, apiKeyCall: CAPITagshoutsDetials){ [weak self] (response, error) in
                guard let self = self else { return }
                if response != nil {
                    self.parentView.isHidden = false
                    if let Info = response!["data"] as? [[String:Any]]{
                        
                        print(Info as Any)
                        for shoutInfo in Info {
                            self.setShoutDetail(shoutInfo)
                        }
                    }
                }
            }
        }
    }
    
    fileprivate func setQuoteText(){
        var strQuote = self.quoteDesc
        if strQuote.count > 5000{
            strQuote = strQuote[0..<5000]
        }
        let str_Back = strQuote.return_replaceBack(replaceBack: strQuote)
        self.textViewMessage.text = str_Back
        self.lblTextCount.text = "\(strQuote.count)/150"
        
        GCDMainThread.async {
            self.textViewMessage.updatePlaceholderFrame(true)
        }
    }
    
    fileprivate func setShoutDetail (_ shoutInfo : [String : Any]) {
        textViewMessage.text = shoutInfo.valueForString(key: CContent)
        lblTextCount.text = "\(textViewMessage.text.count)/5000"
        
        //...Set invite type
        switch shoutInfo.valueForInt(key: CPublish_To) {
        case CPublicToGroup:
            self.btnInviteTypeCLK(btnInviteGroup)
            if let arrInvitee = shoutInfo[CInvite_Groups] as? [[String : Any]]{
                arrSelectedGroupFriends = arrInvitee
            }
        case CPublicToContact:
            self.btnInviteTypeCLK(btnInviteContacts)
            if let arrInvitee = shoutInfo[CInvite_Friend] as? [[String : Any]]{
                arrSelectedGroupFriends = arrInvitee
            }
        case CPublicToFriend:
            self.btnInviteTypeCLK(btnInviteAllFriend)
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
extension CreateShoutsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrSelectedGroupFriends.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BubbleWithCancelCollCell", for: indexPath) as! BubbleWithCancelCollCell
        let selectedInfo = arrSelectedGroupFriends[indexPath.row]
        
        if btnInviteContacts.isSelected{
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
        let title = btnInviteContacts.isSelected ? selectedInfo.valueForString(key: CFirstname) + " " + selectedInfo.valueForString(key: CLastname) : selectedInfo.valueForString(key: CGroupTitle)
        
        let fontToResize =  CFontPoppins(size: 12, type: .light).setUpAppropriateFont()
        var size = title.size(withAttributes: [NSAttributedString.Key.font: fontToResize!])
        size.width = CGFloat(ceilf(Float(size.width + 65)))
        size.height = clGroupFriend.frame.size.height
        return size
    }
}

// MARK:-  --------- Generic UITextView Delegate
extension CreateShoutsViewController: GenericTextViewDelegate{
    
    func genericTextViewDidChange(_ textView: UITextView, height: CGFloat){
        
        
        lblTextCount.text = "\(textView.text.count)/150"
        
    }
    
}

// MARK:- --------- Action Event

extension CreateShoutsViewController{
    
    @IBAction func btnSelectGroupFriendCLK(_ sender : UIButton){
        
        if let groupFriendVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "GroupFriendSelectionViewController") as? GroupFriendSelectionViewController{
            groupFriendVC.arrSelectedGroupFriend = self.arrSelectedGroupFriends
            groupFriendVC.isFriendList = btnInviteContacts.isSelected
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
    
    @IBAction func btnInviteTypeCLK(_ sender : UIButton){
        
        if sender.isSelected {return}
        btnInviteGroup.isSelected = false
        btnInviteContacts.isSelected = false
        btnInviteAllFriend.isSelected = false
        
        arrSelectedGroupFriends = []
        clGroupFriend.reloadData()
        clGroupFriend.isHidden = true
        btnAddMoreFriends.isHidden = true
        btnSelectGroupFriend.isHidden = false
        
        switch sender.tag {
        case 0:
            btnInviteGroup.isSelected = true
            viewSelectGroup.hide(byHeight: false)
        case 1:
            btnInviteContacts.isSelected = true
            viewSelectGroup.hide(byHeight: false)
        case 2:
            btnSelectGroupFriend.isHidden = true
            btnInviteAllFriend.isSelected = true
            viewSelectGroup.hide(byHeight: true)
        default:
            break
        }
    }
    
    @objc fileprivate func btnCreateShoutsClicked(_ sender : UIBarButtonItem) {
        if (textViewMessage.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageShoutContent, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }else if (btnInviteGroup.isSelected || btnInviteContacts.isSelected) && arrSelectedGroupFriends.count == 0 {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageSelectContactGroupShout, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }else{
            self.addEditShout()
//            let replace_str = textViewMessage.text.replace_str(replace: textViewMessage.text)
//            print("replace_str\(replace_str)")
//
//            var charSet = CharacterSet.init(charactersIn: SPECIALCHARNOTALLOWED)
//            if (textViewMessage.text.rangeOfCharacter(from: charSet) != nil)
//                {
//                    print("true")
//                    self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageSpecial, btnOneTitle: CBtnOk, btnOneTapped: nil)
//                    return
//
//                }else{
//                    self.addEditShout()
//                }

        }
    }
 
    @objc fileprivate func btnHelpInfoClicked(_ sender : UIBarButtonItem){
        if let helpLineVC = CStoryboardHelpLine.instantiateViewController(withIdentifier: "HelpLineViewController") as? HelpLineViewController {
            helpLineVC.fromVC = "ShoutVC"
            self.navigationController?.pushViewController(helpLineVC, animated: true)
        }
        
    }
    
}
extension CreateShoutsViewController{
func removeSpecialCharacters(from text: String) -> String {
    let okayChars = CharacterSet(charactersIn: SPECIALCHAR)
    return String(text.unicodeScalars.filter { okayChars.contains($0) || $0.properties.isEmoji })
}
}
