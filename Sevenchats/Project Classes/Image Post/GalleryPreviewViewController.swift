//
//  GalleryPreviewViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 23/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit
import Foundation
import PhotosUI
enum ImagePostType : Int {
    case editImagePost = 0
    case addImagePost = 1
}


let CELLWIDTH =  CScreenWidth * 80/100
let TRANSFORM_CELL_VALUE = CGAffineTransform(scaleX: 0.9, y: 0.9)
let TRANSFORM_CELL_VALUE_FOR_UPPER = CGAffineTransform(scaleX: 0.9, y: 0.9)
let ANIMATION_SPEED = 0.2

class GalleryPreviewViewController: ParentViewController {
    @IBOutlet var clGalleryPreview : UICollectionView!
    @IBOutlet var btnInviteGroup : UIButton!
    @IBOutlet var btnInviteContacts : UIButton!
    @IBOutlet var btnAddMoreFriends : UIButton!
    @IBOutlet var btnInviteAllFriend : UIButton!
    @IBOutlet var btnSelectGroupFriend : UIButton!
    @IBOutlet var viewSelectGroup : UIView!
    @IBOutlet var viewInviteContainer : UIView!
    @IBOutlet var clGroupFriend : UICollectionView!
    
    var imagePostType : ImagePostType!
    var imgPostId : Int!
    var arrSelectedGroupFriends = [[String : Any]]()
    var isFromChatScreen : Bool = false
    var SelectedIndexPathTapBar = IndexPath(item: 0, section: 0)
    var arrSelectedImages = [Any]()
    var arrImagesVideo = [String]()
    var arrDeletedApiImages = [[String : Any]]()
    var set_auto_Delete = 0
    
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
    deinit {
        print("#### deinit -> GalleryPreviewViewController")
    }
    // MARK: - ---------- Initialization
    
    func Initialization(){
        
        if self.isFromChatScreen {
            self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: #imageLiteral(resourceName: "ic_add_post"), style: .plain, target: self, action: #selector(btnUploadClicked(_:)))]
        }else {
            self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: #imageLiteral(resourceName: "ic_add_post"), style: .plain, target: self, action: #selector(btnUploadClicked(_:))),UIBarButtonItem(image: #imageLiteral(resourceName: "ic_add_event"), style: .plain, target: self, action: #selector(btnAddMoreClicked(_:)))]
        }
        
        btnInviteTypeCLK(btnInviteAllFriend)
        
        if imagePostType == .editImagePost{
            self.title = CNavEditImage
            self.loadGalleryDetailFromServer()
        }else{
            self.title = CNavAddImage
            GCDMainThread.async {
                self.clGalleryPreview.reloadData()
            }
        }
        viewInviteContainer.hide(byHeight: self.isFromChatScreen)
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
        
        clGalleryPreview.semanticContentAttribute = .forceLeftToRight
        
        GCDMainThread.async {
            self.clGalleryPreview.reloadData()
        }
        
        btnSelectGroupFriend.setTitle(CMessagePostsSelectFriends, for: .normal)
        btnInviteGroup.setTitle(CPostPostsInviteGroups, for: .normal)
        btnInviteContacts.setTitle(CPostPostsInviteContacts, for: .normal)
        btnInviteAllFriend.setTitle(CPostPostsInviteAllFriends, for: .normal)
        
    }
}

// MARK: - ---------- Api functions
extension GalleryPreviewViewController{
    fileprivate func addEditImagePost(){
        var apiPara = [String : Any]()
        apiPara[CPostType] = 2
        
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
        if imagePostType == .editImagePost{
            apiPara[CId] = imgPostId
            let deletedIDS = arrDeletedApiImages.map({$0.valueForString(key: CId) }).joined(separator: ",")
            apiPara[CDeleteIds] = deletedIDS
        }
        
        var arrImageData = [Data]()
        for image in arrSelectedImages{
            if let img = image as? UIImage{
                let imgData = img.jpegData(compressionQuality: 0.9)
                arrImageData.append(imgData!)
            }
        }
    }
    
    fileprivate func loadGalleryDetailFromServer(){
        if let imgID = self.imgPostId{
            
            APIRequest.shared().viewPostDetailNew(postID: imgID, apiKeyCall: CAPITagsgalleryDetials){ [weak self] (response, error) in
                guard let self = self else { return }
                if response != nil {
                    self.parentView.isHidden = false
                    if let Info = response!["data"] as? [[String:Any]]{
                        
                        print(Info as Any)
                        for imgInfo in Info {
                            
                            //...Set invite type
                            switch imgInfo.valueForInt(key: CPublish_To) {
                            case CPublicToGroup:
                                self.btnInviteTypeCLK(self.btnInviteGroup)
                                if let arrInvitee = imgInfo[CInvite_Groups] as? [[String : Any]]{
                                    self.arrSelectedGroupFriends = arrInvitee
                                }
                            case CPublicToContact:
                                self.btnInviteTypeCLK(self.btnInviteContacts)
                                if let arrInvitee = imgInfo[CInvite_Friend] as? [[String : Any]]{
                                    self.arrSelectedGroupFriends = arrInvitee
                                }
                            case CPublicToFriend:
                                self.btnInviteTypeCLK(self.btnInviteAllFriend)
                            default:
                                break
                            }
                            
                            if self.arrSelectedGroupFriends.count > 0{
                                self.clGroupFriend.reloadData()
                                self.clGroupFriend.isHidden = false
                                self.btnAddMoreFriends.isHidden = false
                                self.btnSelectGroupFriend.isHidden = true
                            }
                            
                            if let arrImg = imgInfo[CGalleryImages] as? [[String : Any]]{
                                self.arrSelectedImages = arrImg
                                GCDMainThread.async {
                                    self.clGalleryPreview.reloadData()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK:- --------- UICollectionView Delegate/Datasources
extension GalleryPreviewViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == clGroupFriend{
            return arrSelectedGroupFriends.count
        }
        
        return arrSelectedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == clGroupFriend{
            let fontToResize =  CFontPoppins(size: 12, type: .light).setUpAppropriateFont()
            let selectedInfo = arrSelectedGroupFriends[indexPath.row]
            let title = btnInviteContacts.isSelected ? selectedInfo.valueForString(key: CFirstname) + " " + selectedInfo.valueForString(key: CLastname) : selectedInfo.valueForString(key: CGroupTitle)
            
            var size = title.size(withAttributes: [NSAttributedString.Key.font: fontToResize!])
            size.width = CGFloat(ceilf(Float(size.width + 65)))
            size.height = clGroupFriend.frame.size.height
            return size
        }
        
        return CGSize(width:(self.view.frame.size.width*CELLWIDTH)/CScreenWidth, height: clGalleryPreview.frame.size.height - 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == clGroupFriend{
            return UIEdgeInsets.zero
        }
        return UIEdgeInsets(top: 0, left: (self.view.frame.size.width - ((self.view.frame.size.width * CELLWIDTH)/CScreenWidth))/2, bottom: 0, right: (self.view.frame.size.width - ((self.view.frame.size.width * CELLWIDTH)/CScreenWidth))/2);
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Select Freind collection view
        if collectionView == clGroupFriend{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BubbleWithCancelCollCell", for: indexPath) as! BubbleWithCancelCollCell
            let selectedInfo = arrSelectedGroupFriends[indexPath.row]
            
            if btnInviteContacts.isSelected{
                cell.lblBubbleText.text = selectedInfo.valueForString(key: CFirstname) + " " + selectedInfo.valueForString(key: CLastname)
            }else{
                cell.lblBubbleText.text = selectedInfo.valueForString(key: CGroupTitle)
            }
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryPreviewCollCell", for: indexPath) as! GalleryPreviewCollCell
        cell.transform = SelectedIndexPathTapBar == indexPath ? CGAffineTransform.identity : TRANSFORM_CELL_VALUE
        cell.imgGallery.backgroundColor = UIColor.white
        let imgInfo = arrSelectedImages[indexPath.item]
        // For Local images..
        if let imgLocalImage = imgInfo as? UIImage{
            cell.imgGallery.image = imgLocalImage
        }else // For Api images..
        {
            if let imgApi = imgInfo as? [String : Any]{
                cell.imgGallery.loadImageFromUrl(imgApi.valueForString(key: CImage), false)
            }
        }
        
        cell.btnDeleteImage.touchUpInside { [weak self] (sender) in
            guard let self = self else { return }
            
            if self.imagePostType == .editImagePost {
                
                self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CMessageDeleteImage, btnOneTitle: CBtnYes, btnOneTapped: { [weak self](alert) in
                    guard let self = self else { return }
                    if self.arrSelectedImages.count > self.SelectedIndexPathTapBar.item{
                        // If deleting api images then store it..
                        if let imgDeletedInfo = self.arrSelectedImages[self.SelectedIndexPathTapBar.item] as? [String : Any]{
                            self.arrDeletedApiImages.append(imgDeletedInfo)
                        }
                        
                        self.arrSelectedImages.remove(at: self.SelectedIndexPathTapBar.item)
                        if self.SelectedIndexPathTapBar.item > 0{
                            self.SelectedIndexPathTapBar = IndexPath(item: self.SelectedIndexPathTapBar.item - 1 , section: 0)
                            self.clGalleryPreview.scrollToItem(at: self.SelectedIndexPathTapBar, at: .centeredHorizontally, animated: true)
                        }
                        self.clGalleryPreview.reloadData()
                    }
                }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
                
            } else {
                if self.arrSelectedImages.count > self.SelectedIndexPathTapBar.item{
                    // If deleting api images then store it..
                    if let imgDeletedInfo = self.arrSelectedImages[self.SelectedIndexPathTapBar.item] as? [String : Any]{
                        self.arrDeletedApiImages.append(imgDeletedInfo)
                    }
                    
                    self.arrSelectedImages.remove(at: self.SelectedIndexPathTapBar.item)
                    if self.SelectedIndexPathTapBar.item > 0{
                        self.SelectedIndexPathTapBar = IndexPath(item: self.SelectedIndexPathTapBar.item - 1 , section: 0)
                        self.clGalleryPreview.scrollToItem(at: self.SelectedIndexPathTapBar, at: .centeredHorizontally, animated: true)
                    }
                    self.clGalleryPreview.reloadData()
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == clGroupFriend{
            arrSelectedGroupFriends.remove(at: indexPath.row)
            clGroupFriend.reloadData()
            
            if arrSelectedGroupFriends.count == 0
            {
                btnSelectGroupFriend.isHidden = false
                clGroupFriend.isHidden = true
                btnAddMoreFriends.isHidden = true
            }
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if scrollView == clGalleryPreview{
            let pageWidth = CELLWIDTH;
            
            let currentOffset = Float(scrollView.contentOffset.x)
            let targetOffset = Float(targetContentOffset.pointee.x)
            var newTargetOffset = Float(0)
            
            if targetOffset > currentOffset {
                newTargetOffset = ceilf(currentOffset / Float(pageWidth)) * Float(pageWidth)
            } else {
                newTargetOffset = floorf(currentOffset / Float(pageWidth)) * Float(pageWidth)
            }
            
            if newTargetOffset < 0 {
                newTargetOffset = 0
            } else if newTargetOffset > Float(scrollView.contentSize.width) {
                newTargetOffset = Float(scrollView.contentSize.width)
            }
            
            _ = Float(targetContentOffset.pointee.x) == currentOffset
            scrollView.setContentOffset(CGPoint(x: CGFloat(newTargetOffset), y: 0), animated: true)
            let index : Int = Int(newTargetOffset / Float(pageWidth));
            SelectedIndexPathTapBar = IndexPath(item: index, section: 0)
            clGalleryPreview.scrollToItem(at: SelectedIndexPathTapBar, at: .centeredHorizontally, animated: true)
            
            if index == 0{
                
                if let cell1 : GalleryPreviewCollCell  = clGalleryPreview.cellForItem(at: IndexPath(item: index, section: 0)) as? GalleryPreviewCollCell{
                    UIView.animate(withDuration: ANIMATION_SPEED) {
                        cell1.transform = CGAffineTransform.identity;
                    }
                }
                
                if let cell1 : GalleryPreviewCollCell  = clGalleryPreview.cellForItem(at: IndexPath(item: index+1, section: 0)) as? GalleryPreviewCollCell{
                    UIView.animate(withDuration: ANIMATION_SPEED) {
                        cell1.transform = TRANSFORM_CELL_VALUE;
                    }
                }
            }else{
                if let cell1 : GalleryPreviewCollCell  = clGalleryPreview.cellForItem(at: IndexPath(item: index, section: 0)) as? GalleryPreviewCollCell{
                    UIView.animate(withDuration: ANIMATION_SPEED) {
                        cell1.transform = CGAffineTransform.identity;
                    }
                }
                
                if let cell1 : GalleryPreviewCollCell  = clGalleryPreview.cellForItem(at: IndexPath(item: index-1, section: 0)) as? GalleryPreviewCollCell{
                    UIView.animate(withDuration: ANIMATION_SPEED) {
                        cell1.transform = TRANSFORM_CELL_VALUE;
                    }
                }
                
                if let cell1 : GalleryPreviewCollCell  = clGalleryPreview.cellForItem(at: IndexPath(item: index+1, section: 0)) as? GalleryPreviewCollCell{
                    UIView.animate(withDuration: ANIMATION_SPEED) {
                        cell1.transform = TRANSFORM_CELL_VALUE;
                    }
                }
            }
        }
    }
    
}

// MARK:- ----------- Action Event
extension GalleryPreviewViewController{
    @IBAction func btnInviteTypeCLK(_ sender : UIButton){
        
        if sender.isSelected {
            return
        }
        
        btnInviteGroup.isSelected = false
        btnInviteContacts.isSelected = false
        btnInviteAllFriend.isSelected = false
        
        arrSelectedGroupFriends = []
        self.clGroupFriend.reloadData()
        clGroupFriend.isHidden = true
        btnAddMoreFriends.isHidden = true
        btnSelectGroupFriend.isHidden = false
        
        GCDMainThread.async {
            self.clGalleryPreview.reloadData()
        }
        
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
    
    @IBAction func btnSelectGroupFriendCLK(_ sender : UIButton){
        if let groupFriendVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "GroupFriendSelectionViewController") as? GroupFriendSelectionViewController {
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
    
    @objc fileprivate func btnAddMoreClicked(_ sender : UIBarButtonItem) {
        self.presentActionsheetWithTwoButtons(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CRegisterChooseFromPhone, btnOneStyle: .default, btnOneTapped: { (alert) in
            if let galleryListVC = CStoryboardImage.instantiateViewController(withIdentifier: "GalleryListViewController") as? GalleryListViewController {
                galleryListVC.isAllreadySelectedImageCount = self.arrSelectedImages.count
                galleryListVC.isAddMoreImage = true
                galleryListVC.isFromChatScreen = self.isFromChatScreen
                galleryListVC.setBlock(block: { (object, message) in
                    // To Add More image with selected image..
                    if let arrImg = object as? [UIImage] {
                        self.arrSelectedImages = self.arrSelectedImages + arrImg
                        self.clGalleryPreview.reloadData()
                    }
                })
                self.navigationController?.pushViewController(galleryListVC, animated: true)
            }
            
        }, btnTwoTitle: CRegisterTakePhoto, btnTwoStyle: .default) { (alert) in
            self.presentImagePickerControllerForCamera(imagePickerControllerCompletionHandler: { (image, info) in
                if (image != nil){
                    // To Add More image from Camera..
                    self.arrSelectedImages.append(image!)
                    self.clGalleryPreview.reloadData()
                }
            })
        }
    }
    
    @objc fileprivate func btnUploadClicked(_ sender : UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Are you Sure Want to send to this image", message: "", preferredStyle: UIAlertController.Style.alert);
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
            if self.arrSelectedImages.count < 1 {
                self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageSelectImage, btnOneTitle: CBtnOk, btnOneTapped: nil)
            } else if self.arrSelectedImages.count > 5 {
                self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageMaximumImage, btnOneTitle: CBtnOk, btnOneTapped: nil)
            } else {
                
                if self.isFromChatScreen {
                    
                    // Move back on Group chat detail screen
                    if let chatVC =  self.getViewControllerFromNavigation(GroupChatDetailsViewController.self){
                        chatVC.arrSelectedMediaForChat = self.arrSelectedImages
                        self.navigationController?.popToViewController(chatVC, animated: true)
                    } else if let chatVC = self.getViewControllerFromNavigation(UserChatDetailViewController.self) {
                        chatVC.arrSelectedMediaForChat = self.arrSelectedImages
                        chatVC.autodelete = self.set_auto_Delete
                        self.navigationController?.popToViewController(chatVC, animated: true)
                    }
                    
                }else{
                    
                    if (self.btnInviteGroup.isSelected || self.btnInviteContacts.isSelected) && self.arrSelectedGroupFriends.count == 0 {
                        self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageSelectContactGroupImage, btnOneTitle: CBtnOk, btnOneTapped: nil)
                    } else{
                        self.addEditImagePost()
                    }
                    //
                }
            }
            
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alertController, animated: false, completion: { () -> Void in
        })
    }
    
    @objc func checkBoxAction(_ sender: UIButton){
        if (sender.isSelected == true){
            set_auto_Delete = 0
            sender.setBackgroundImage(UIImage(named: "ic_uncheckbox"), for:  UIControl.State())
            sender.isSelected = false;
        }
        else{
            set_auto_Delete = 1
            sender.setBackgroundImage(UIImage(named: "ic_checkbox"), for: UIControl.State())
            sender.isSelected = true;
        }
    }
}


