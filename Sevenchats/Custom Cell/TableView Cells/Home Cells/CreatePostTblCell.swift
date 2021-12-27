//
//  CreatePostTblCell.swift
//  Sevenchats
//
//  Created by APPLE on 17/11/20.
//  Copyright © 2020 mac-00020. All rights reserved.
//

import UIKit
import ISEmojiView

enum ShoutsTypes : Int {
    case addShouts = 0
    case editShouts = 1
    case shareQuote = 3
}

protocol CollectionViewSelectionDelegate: class {
    func didSelectedCollectionViewItem(selectedObject: AnyObject)
}

class CreatePostTblCell: UITableViewCell{

    var closure: ((Bool,[[String : Any]])-> Void)?
    var closureReload: ((Bool)-> Void)?
    var closureShowMessage: ((_ data :Int)-> ())?
    var onDataAvailable : ((_ data: Bool) -> ())?
    
    @IBOutlet weak var emjButton: UIButton!
    @IBOutlet weak var placeHolderLabel: UILabel!
    @IBOutlet weak var PostButton: UIButton!
    @IBOutlet weak var textViewMessage: GenericTextView!
    @IBOutlet weak var viewMainContainer : UIView!
    @IBOutlet weak var viewSubContainer : UIView!
    @IBOutlet weak var lblTextCount : UILabel!
    
    @IBOutlet weak var btnInviteGroup : UIButton!
    @IBOutlet weak var btnInviteContacts : UIButton!
    @IBOutlet weak var btnInviteAllFriend : UIButton!
    @IBOutlet weak var btnAddMoreFriends : UIButton!
    @IBOutlet weak var btnSelectGroupFriend : UIButton!
    @IBOutlet weak var clGroupFriend : UICollectionView!
    @IBOutlet weak var viewSelectGroup : UIView!
    @IBOutlet weak var imgUser : UIImageView!
    @IBOutlet weak var btnimgUser : UIButton!
    @IBOutlet weak var lblCreateShout : UILabel!

    var quoteDesc = ""
    var shoutsType : ShoutsTypes!
    var shoutID : Int?
    var userID:String?
    var arrSelectedGroupFriends = [[String : Any]]()
    
 //   CShoutPlaceholderContents
    override func awakeFromNib() {
        super.awakeFromNib()
        textViewMessage.genericDelegate = self
        clGroupFriend.delegate = self
        clGroupFriend.dataSource = self
        lblTextCount.isHidden = true
        lblCreateShout.text = CCreateshout
        // Initialization code
        GCDMainThread.async {
            self.imgUser.loadImageFromUrl((appDelegate.loginUser?.profile_img ?? ""), true)
            self.imgUser.layer.cornerRadius = self.imgUser.bounds.height / 2
                       self.imgUser.layer.masksToBounds = true
                       self.imgUser.clipsToBounds = true
            self.PostButton.layer.cornerRadius = 8
            
               self.viewSubContainer.layer.cornerRadius = 8
               self.viewMainContainer.layer.cornerRadius = 8
               self.viewMainContainer.shadow(color: CRGB(r: 237, g: 236, b: 226), shadowOffset: CGSize(width: 0, height: 5), shadowRadius: 10.0, shadowOpacity: 10.0)
               self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width/2
           }
        self.Initialization()
        self.updateUIAccordingToLanguage()
    }
    // MARK:- --------- Initialization
    func Initialization(){
        
//        textViewMessage.delegate = self
//        lblCreateShout.text = CCreateshout
        textViewMessage.textContainerInset = UIEdgeInsets(top: 8, left: 0, bottom: 20, right: 0)
        textViewMessage.textContainerInset = UIEdgeInsets(top: 8, left: 0, bottom: 20, right: 0)
        
//        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: #imageLiteral(resourceName: "ic_add_post"), style: .plain, target: self, action: #selector(btnCreateShoutsClicked(_:)))]
        PostButton.addTarget(self, action:#selector(btnCreateShoutsClicked(_:)), for: .touchUpInside)
        
        btnInviteTypeCLK(btnInviteAllFriend)
        if shoutsType == .shareQuote{
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
            lblCreateShout.textAlignment = .right
            
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
            lblCreateShout.textAlignment = .left
           
        }
        
//        var CProfilePost: String{ return appDelegate.langugaeText?.post ?? "Post"
//        textViewMessage.placeHolder = CShoutPlaceholderContent
        PostButton.setTitle(CProfilePost, for: .normal)
        btnSelectGroupFriend.setTitle(CMessagePostsSelectFriends, for: .normal)
        /*OLD CODE
        btnInviteGroup.setTitle(CPostPostsInviteGroups, for: .normal)
         */
        
        /*NEW CODE
         */
//        btnInviteGroup.setTitle(Cshout_groups, for: .normal)
//        btnInviteContacts.setTitle(CCFriends, for: .normal)
//        btnInviteAllFriend.setTitle(CPostPostsInviteAllFriends, for: .normal)

        btnInviteGroup.setTitle(Cshout_groups, for: .normal)
        btnInviteContacts.setTitle(Cshout_friends, for: .normal)
        btnInviteAllFriend.setTitle(Cshout_public, for: .normal)

        
    }
    @IBAction func brtEmojiClick(_ sender:UIButton){
        textViewMessage.becomeFirstResponder()
    }
    fileprivate func setQuoteText(){
        var strQuote = self.quoteDesc
        if strQuote.count > 150{
            strQuote = strQuote[0..<150]
        }
        self.textViewMessage.text = strQuote
        self.lblTextCount.text = "\(strQuote.count)/150"
        GCDMainThread.async {
            self.textViewMessage.updatePlaceholderFrame(true)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    // callback when tap a emoji on keyboard
    func emojiViewDidSelectEmoji(_ emoji: String, emojiView: EmojiView) {
        textViewMessage.insertText(emoji)
    }

    // callback when tap change keyboard button on keyboard
    func emojiViewDidPressChangeKeyboardButton(_ emojiView: EmojiView) {
        textViewMessage.inputView = nil
        textViewMessage.keyboardType = .default
        textViewMessage.reloadInputViews()
    }
        
    // callback when tap delete button on keyboard
    func emojiViewDidPressDeleteBackwardButton(_ emojiView: EmojiView) {
        textViewMessage.deleteBackward()
    }

    // callback when tap dismiss button on keyboard
    func emojiViewDidPressDismissKeyboardButton(_ emojiView: EmojiView) {
        textViewMessage.resignFirstResponder()
    }
    
}

// MARK:- --------- UICollectionView Delegate/Datasources
extension CreatePostTblCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
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
        if arrSelectedGroupFriends.count == 0{
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
// MARK:- --------- Action Event
extension CreatePostTblCell{
    @IBAction func btnSelectGroupFriendCLK(_ sender : UIButton){
        let selectedVal:Bool = btnInviteContacts.isSelected
        closure?(selectedVal,self.arrSelectedGroupFriends)
    }
    
    @IBAction func btnInviteTypeCLK(_ sender : UIButton){
        if sender.isSelected {
            return
        }
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
            let selectedVal:Bool = btnInviteContacts.isSelected
            closure?(selectedVal,self.arrSelectedGroupFriends)
        case 1:
            btnInviteContacts.isSelected = true
            viewSelectGroup.hide(byHeight: false)
            let selectedVal:Bool = btnInviteContacts.isSelected
            closure?(selectedVal,self.arrSelectedGroupFriends)
        case 2:
            btnSelectGroupFriend.isHidden = true
            btnInviteAllFriend.isSelected = true
            viewSelectGroup.hide(byHeight: true)
        default:
            break
        }
    }
    
    @objc fileprivate func btnCreateShoutsClicked(_ sender : UIButton) {
       
        if (textViewMessage.text?.isBlank)! {
           self.closureShowMessage?(1)
            
        }else if (btnInviteGroup.isSelected || btnInviteContacts.isSelected) && arrSelectedGroupFriends.count == 0 {
            self.closureShowMessage?(2)
        }else{
            self.addEditShout()
        }
    }
    
    func addEditShout(){
        var apiPara = [String : Any]()
        apiPara[CPostType] = 4
        apiPara[CPost_Detail] = textViewMessage.text
        var apiParaGroups = [String]()
        var apiParaFriends = [String]()

//        if btnInviteGroup.isSelected{
//            // For group...
//            apiPara[CPublish_To] = 1
//            let groupIDS = arrSelectedGroupFriends.map({$0.valueForString(key: CGroupId) }).joined(separator: ",")
//            apiPara[CGroup_Ids] = groupIDS
//        }else if btnInviteContacts.isSelected{
//            // For Contact...
//            apiPara[CPublish_To] = 2
//            let userIDS = arrSelectedGroupFriends.map({$0.valueForString(key: CUserId) }).joined(separator: ",")
//            apiPara[CInvite_Ids] = userIDS
//        }else{
//            // For All Friend...
//            apiPara[CPublish_To] = 3
//        }
        guard let userid = appDelegate.loginUser?.user_id else {return}

        // When user editing the article....
        if shoutsType == .editShouts{
            apiPara[CId] = shoutID
        }
       
        let txtshout = textViewMessage.text.replace(string: "\n", replacement: "\\n")
        
        var dict = [String:Any]()
        dict[CUserId] = userid.description
        dict[Cimages] = ""
        dict[CTitle] = ""
        dict[CpostContent] = txtshout
        dict["age_limit"] = "20"
        
        
        if btnInviteGroup.isSelected{
            // For group...
            apiPara[CPublish_To] = 1
//            let groupIDS = arrSelectedGroupFriends.map({$0.valueForString(key: CGroupId) }).joined(separator: ",")
//            apiPara[CGroup_Ids] = groupIDS
            
            let groupIDS = arrSelectedGroupFriends.map({$0.valueForString(key: CGroupId) }).joined(separator: ",")
            apiParaGroups = groupIDS.components(separatedBy: ",")
            
        }else if btnInviteContacts.isSelected{
            // For Contact...
            apiPara[CPublish_To] = 2
//            let userIDS = arrSelectedGroupFriends.map({$0.valueForString(key: CUserId) }).joined(separator: ",")
//            apiPara[CInvite_Ids] = userIDS
            
            let userIDS = arrSelectedGroupFriends.map({$0.valueForString(key: CFriendUserID) }).joined(separator: ",")
            apiParaFriends = userIDS.components(separatedBy: ",")
            
        }else{
            // For All Friend...
            apiPara[CPublish_To] = 3
        }
        
        
        if apiParaGroups.isEmpty == false {
//            dict[CTargetAudiance] = apiParaGroups
            dict[CTargetAudiance] = apiParaGroups
        }else {
            dict[CTargetAudiance] = "none"
        }
        
        if apiParaFriends.isEmpty == false {
            dict[CSelectedPerson] = apiParaFriends
        }else {
            dict[CSelectedPerson] = "none"
        }
        
        dict["targeted_audience"] = apiParaGroups
        dict["selected_persons"] = apiParaFriends
        
        
        APIRequest.shared().addEditPost(para: dict, image: nil, apiKeyCall: CAPITagshouts) { (response, error) in
            if response != nil && error == nil{
                print("responsevalues",response)
//                if self.shoutsType == .shareQuote{
//                    (appDelegate.sideMenuController.leftViewController as? SideMenuViewController)?.selectIndex(0)
//                    appDelegate.sideMenuController.rootViewController = UINavigationController.init(rootViewController: CStoryboardHome.instantiateViewController(withIdentifier: "HomeViewController"))
//                }else{
//                    self.onDataAvailable?(true)
////                    self.navigationController?.popViewController(animated: true)
//                }
              
                
               
                var message = ""
                if self.shoutsType == .editShouts{
                    message = CMessageShoutPostUpdated
                }else if self.shoutsType == .shareQuote{
                    message = CPostHasBeenShared
                }else{
                    message = CMessageShoutPostUpload
                }
                
                CTopMostViewController.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageShoutPostUpload, btnOneTitle: CBtnOk, btnOneTapped: nil)
                if let metaInfo = response![CJsonMeta] as? [String:Any]{
                    let timeStamp = metaInfo.valueForString(key: "status")
                    if timeStamp == "0"{
                        self.textViewMessage.text = ""
                        self.onDataAvailable?(true)
                    }
                }
                
                
//                if let shoutInfo = response![CJsonData] as? [String : Any]{
//                    MIGeneralsAPI.shared().refreshPostRelatedScreens(shoutInfo,self.shoutID, self, self.shoutsType == .editShouts ? .editPost : .addPost)
//                    MIGeneralsAPI.shared().refreshPostRelatedScreens(shoutInfo, self.shoutsType == .editShouts ? .editPost : .addPost)
              
//                }
                
                
                
                
                
                
                
                
                
                
            }
        }
    }
}

//
// MARK:-  --------- Generic UITextView Delegate
extension CreatePostTblCell: GenericTextViewDelegate{
    
    static var countCompletion: ((_ data :Int)-> ())?
    
    func genericTextViewDidChange(_ textView: UITextView, height: CGFloat){
//        lblTextCount.text = "\(textView.text.count)/150"
//        print("\(textView.text.count)/150")
        let txtCount = Int(textView.text.count)
              
        if txtCount == 150 {
                    lblTextCount.isHidden = false
                    lblTextCount.text = "\(textView.text.count)/150"
                     print("\(textView.text.count)/150")
                } else {
                    lblTextCount.isHidden = true
                    lblTextCount.text = "\(textView.text.count)/150"
                     print("\(textView.text.count)/150")
                }
//        let txtCount = Int(textView.text.count)
        if txtCount == 0{
        CreatePostTblCell.countCompletion?(0)
        }else {
         CreatePostTblCell.countCompletion?(1)
        }
    }
    
    func genericTextViewDidBeginEditing(_ textView: UITextView){
//        print(textViewMessage.text)
        if  textViewMessage.text == "" ||  textViewMessage.text == " " || textViewMessage.text.isEmpty || !textViewMessage.text.isEmpty {
            placeHolderLabel.isHidden = true
        }
    }
    func genericTextViewDidEndEditing(_ textView: UITextView){
        if  textViewMessage.text == "" ||  textViewMessage.text == " "  || textViewMessage.text.isEmpty {
            placeHolderLabel.isHidden = false
        }else {
            placeHolderLabel.isHidden = true
        }
    }
}
    


class CreatePostTblCell1: UITableViewCell{
    
    @IBOutlet weak var viewMainContainer : UIView!
    @IBOutlet weak var viewSubContainer : UIView!
    
    @IBOutlet weak var pollButton: UIButton!
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var forumButton: UIButton!
    @IBOutlet weak var eventButton: UIButton!
    @IBOutlet weak var cripyButton: UIButton!
    @IBOutlet weak var articleButton: UIButton!
    
    //   CShoutPlaceholderContents
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        GCDMainThread.async {
            self.viewSubContainer.layer.cornerRadius = 8
            self.viewMainContainer.layer.cornerRadius = 8
            self.viewMainContainer.shadow(color: CRGB(r: 237, g: 236, b: 226), shadowOffset: CGSize(width: 0, height: 5), shadowRadius: 10.0, shadowOpacity: 10.0)
            
        }
    }
}
