//
//  AddMediaViewController.swift
//  Sevenchats
//
//  Created by mac-00020 on 28/05/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

import Foundation
import UIKit
import TLPhotoPicker
import Photos
import AssetsLibrary

class AddMediaViewController: ParentViewController {
    
    //MARK: - IBOutlet/Object/Variable Declaration
    //    @IBOutlet weak var txtCategory: MIGenericTextFiled!
    @IBOutlet weak var btnUploadMedia: MIGenericButton!
    @IBOutlet weak var lblNote: MIGenericLabel!
    @IBOutlet private weak var categoryDropDownView: CustomDropDownView!
    //    @IBOutlet private weak var subcategoryDropDownView: CustomDropDownView!
    
    let imagePicker = UIImagePickerController()
    var photosPickerVC = TLPhotosPickerViewController()
    
    @IBOutlet weak var colVMedia: UICollectionView! {
        didSet {
            colVMedia.register(UINib(nibName: "AddMediaCollCell", bundle: nil), forCellWithReuseIdentifier: "AddMediaCollCell")
            colVMedia.isPagingEnabled    = false
            colVMedia.delegate = self
            colVMedia.dataSource = self
        }
    }
    
    @IBOutlet weak var clGroupFriend : UICollectionView!
    @IBOutlet weak var btnAddMoreFriends : UIButton!
    @IBOutlet weak var btnSelectGroupFriend : UIButton!
    @IBOutlet weak var viewSelectGroup : UIView!
    var profileImage:UIImage?
    
    
    @IBOutlet weak var txtInviteType : MIGenericTextFiled!
    var selectedInviteType : Int = 3 {
        didSet{
            self.didChangeInviteType()
        }
    }
    
    var arrMedia : [MDLAddMedia] = []
    var arrMediaString = [String]()
    let maxVideoFileSizeInMB : Int = 50
    let totalMediaUploadLimit = 5
    //var selectedAssets = [TLPHAsset]()
    
    var categoryID : Int?
    var arrSelectedGroupFriends = [[String : Any]]()
    var imagePostType : ImagePostType!
    var imgPostId : Int!
    var arrDeletedApiImages : [String] = []
    let dispatchGroup = DispatchGroup()
    var imgName = ""
    
    var arrImages = [String]()
    var arrImagesVideo = [String]()
    var arrSubCategory =  [[String : Any]]()
    var categorysubName : String?
    var apiTask : URLSessionTask?
    var currentPage : Int = 1
    var categoryName : String?
    var arrsubCategorys : [MDLIntrestSubCategory] = []
    var ImgName = ""
    var imgUpoloadUrl = ""
    var imageString = ""
    
    //MARK: - View life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - Memory management methods
    deinit {
        print("### deinit -> AddMediaViewController")
    }
}

//MARK: - SetupUI
extension AddMediaViewController {
    
    fileprivate func setupView() {
        
        self.title = CAddMedia
        updateUIAccordingToLanguage()
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: #imageLiteral(resourceName: "ic_add_post"), style: .plain, target: self, action: #selector(btnAddMediaPost(_:)))]
        
        btnUploadMedia.backgroundColor = ColorAppBackgorund
        btnUploadMedia.setTitle(CUploadMedia, for: .normal)
        btnUploadMedia.layer.cornerRadius = 8
        btnUploadMedia.clipsToBounds = true
        
        let arrCategory = MIGeneralsAPI.shared().fetchCategoryFromLocalGallery()
        
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
            //
            //                if let id = (objArry.first?[CId] as? Int16) {
            //                    self.categoryID = Int(id)
            //                }
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
        //            let objArry = self.arrSubCategory.filter({ (obj) -> Bool in
        //                return ((obj[CinterestLevel2] as? String) == item)
        //            })
        //
        //            if (objArry.count > 0) {
        //                self.categorysubName = (objArry.first?[CinterestLevel2] as? String) ?? ""
        //            }
        //        }
        
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
        }, defaultPlaceholder: CPostPostsInviteGroups)
        
        // By default `All type` selected
        self.selectedInviteType = 4
        
        if arrSelectedGroupFriends.count > 0{
            self.clGroupFriend.reloadData()
            self.clGroupFriend.isHidden = false
            self.btnAddMoreFriends.isHidden = false
            self.btnSelectGroupFriend.isHidden = true
        }
        
        self.clGroupFriend.delegate = self
        self.clGroupFriend.dataSource = self
        
        if imagePostType == .editImagePost{
            self.title = CEditMedia
            self.loadGalleryDetailFromServer()
        }
    }
    
    fileprivate func updateUIAccordingToLanguage(){
        txtInviteType.placeHolder = CVisiblity
        
        lblNote.text = CMax5MediaAllowedOf50MB
        categoryDropDownView.txtCategory.placeholder = CSelectCategoryOfGallery
        //        subcategoryDropDownView.txtCategory.placeholder = CSelectCategoryOfGallery
    }
    
    
    fileprivate func loadGalleryDetailFromServer(){
        if let imgID = self.imgPostId{
            
            APIRequest.shared().viewPostDetailNew(postID: imgID, apiKeyCall: CAPITagsgalleryDetials){ [weak self] (response, error) in
                //  APIRequest.shared().viewPostDetail(postID: shouID) { [weak self] (response, error) in
                guard let self = self else { return }
                if response != nil {
                    self.parentView.isHidden = false
                    if let Info = response!["data"] as? [[String:Any]]{
                        
                        print(Info as Any)
                        for imgInfo in Info {
                            GCDMainThread.async {
                                self.categoryID = imgInfo.valueForInt(key: CCategory_Id)
                                self.categoryDropDownView.txtCategory.text = imgInfo.valueForString(key: CCategory)
                            }
                            
                            //...Set invite type
                            self.selectedInviteType = imgInfo.valueForInt(key: CPublish_To) ?? 3
                            
                            switch self.selectedInviteType {
                            case 1:
                                if let arrInvitee = imgInfo[CInvite_Groups] as? [[String : Any]]{
                                    self.arrSelectedGroupFriends = arrInvitee
                                }
                            case 2:
                                if let arrInvitee = imgInfo[CInvite_Friend] as? [[String : Any]]{
                                    self.arrSelectedGroupFriends = arrInvitee
                                }
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
                                self.arrMedia = []
                                self.arrMediaString = []
                                for imgData in arrImg{
                                    let imgID = imgData.valueForString(key: CId)
                                    let media = MDLAddMedia(mediaID: imgID)
                                    media.isFromGallery = false
                                    media.uploadMediaStatus = .Succeed
                                    media.assetType = AssetTypes(rawValue: imgData.valueForInt(key: CType) ?? 0) ?? AssetTypes.Image
                                    if media.assetType == .Video{
                                        media.serverImgURL = imgData.valueForString(key: CThumbNail)
                                        media.url = imgData.valueForString(key: CImage)
                                    }else{
                                        media.serverImgURL = imgData.valueForString(key: CImage)
                                    }
                                    self.arrMedia.append(media)
                                    
                                    
                                }
                                GCDMainThread.async {
                                    self.colVMedia.reloadData()
                                }
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    
    
    
    //    fileprivate func loadGalleryDetailFromServer(){
    //        if let imgID = self.imgPostId{
    //            APIRequest.shared().viewPostDetail(postID: imgID) { [weak self] (response, error) in
    //                guard let self = self else { return }
    //                guard response != nil else {return}
    //                guard let imgInfo = response![CJsonData] as? [String : Any] else{return}
    //
    //                //...Set invite type
    //                GCDMainThread.async {
    //                    self.categoryID = imgInfo.valueForInt(key: CCategory_Id)
    //                    self.categoryDropDownView.txtCategory.text = imgInfo.valueForString(key: CCategory)
    //                }
    //
    //                //...Set invite type
    //                self.selectedInviteType = imgInfo.valueForInt(key: CPublish_To) ?? 3
    //
    //                switch self.selectedInviteType {
    //                case 1:
    //                    if let arrInvitee = imgInfo[CInvite_Groups] as? [[String : Any]]{
    //                        self.arrSelectedGroupFriends = arrInvitee
    //                    }
    //                case 2:
    //                    if let arrInvitee = imgInfo[CInvite_Friend] as? [[String : Any]]{
    //                        self.arrSelectedGroupFriends = arrInvitee
    //                    }
    //                default:
    //                    break
    //                }
    //
    //                if self.arrSelectedGroupFriends.count > 0{
    //                    self.clGroupFriend.reloadData()
    //                    self.clGroupFriend.isHidden = false
    //                    self.btnAddMoreFriends.isHidden = false
    //                    self.btnSelectGroupFriend.isHidden = true
    //                }
    //
    //                if let arrImg = imgInfo[CGalleryImages] as? [[String : Any]]{
    //                    self.arrMedia = []
    //                    self.arrMediaString = []
    //                    for imgData in arrImg{
    //                        let imgID = imgData.valueForString(key: CId)
    //                        let media = MDLAddMedia(mediaID: imgID)
    //                        media.isFromGallery = false
    //                        media.uploadMediaStatus = .Succeed
    //                        media.assetType = AssetTypes(rawValue: imgData.valueForInt(key: CType) ?? 0) ?? AssetTypes.Image
    //                        if media.assetType == .Video{
    //                            media.serverImgURL = imgData.valueForString(key: CThumbNail)
    //                            media.url = imgData.valueForString(key: CImage)
    //                        }else{
    //                            media.serverImgURL = imgData.valueForString(key: CImage)
    //                        }
    //                        self.arrMedia.append(media)
    //
    //
    //                    }
    //                    GCDMainThread.async {
    //                        self.colVMedia.reloadData()
    //                    }
    //                }
    //            }
    //        }
    //    }
    fileprivate func addEditImagePost(){
        
        var apiPara = [String : Any]()
        var apiParaGroups = [String]()
        var apiParaFriends = [String]()
        
        apiPara[CPostType] = 2
        apiPara[CCategory_Id] = categoryDropDownView.txtCategory.text
        apiPara[CPublish_To] = self.selectedInviteType
        
        
        //           if self.selectedInviteType == 1{
        //               // For group...
        //               let groupIDS = arrSelectedGroupFriends.map({$0.valueForString(key: CGroupId) }).joined(separator: ",")
        //               apiPara[CGroup_Ids] = groupIDS
        //           }else if self.selectedInviteType == 2{
        //               // For Contact...
        //               let userIDS = arrSelectedGroupFriends.map({$0.valueForString(key: CUserId) }).joined(separator: ",")
        //               apiPara[CInvite_Ids] = userIDS
        //           }
        
        
        var _arrMedia = self.arrMedia
        // When user editing the article....
        if imagePostType == .editImagePost{
            apiPara[CId] = imgPostId
            let deletedIDS = self.arrDeletedApiImages.map({$0}).joined(separator: ",")
            apiPara[CDeleteIds] = deletedIDS
            
            _arrMedia = self.arrMedia.filter({$0.uploadMediaStatus != .Succeed})
        }
        //
        do {
            let data = try JSONEncoder().encode(arrImagesVideo)
            let string = String(data: data, encoding: .utf8)!
            let replaced2 = string.replacingOccurrences(of: "\"{", with: "{")
            let replaced3 = replaced2.replacingOccurrences(of: "}\"", with: "}")
            let replaced4 = replaced3.replacingOccurrences(of: "\\/\\/", with: "//")
            let replaced5 = replaced4.replacingOccurrences(of: "\\/", with: "/")
            print(replaced5)
            self.imgUpoloadUrl = replaced5
            
        } catch { print(error) }
        
        
        
        guard let userID = appDelegate.loginUser?.user_id else { return }
        
        var dict :[String:Any]  =  [
            "user_id":userID.description,
            "post_category":categoryDropDownView.txtCategory.text ?? "",
            "images": imgUpoloadUrl,
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
        
        APIRequest.shared().addEditPost(para: dict, image: nil, apiKeyCall: CAPITagsgallery) { [weak self] (response, error) in
            guard let self = self else { return }
            if response != nil && error == nil{
                
                if let metaInfo = response![CJsonMeta] as? [String : Any] {
                    let name = (appDelegate.loginUser?.first_name ?? "") + " " + (appDelegate.loginUser?.last_name ?? "")
                    guard let image = appDelegate.loginUser?.profile_img else { return }
                    let stausLike = metaInfo["status"] as? String ?? "0"
                    if stausLike == "0" {
                        
                        MIGeneralsAPI.shared().addRewardsPoints(CPostcreate,message:"post_point",type:CPostcreate,title:"Gallery Add",name:name,icon:image)
                    }
                }
                
                if let imgInfo = response![CJsonData] as? [String : Any]{
                    MIGeneralsAPI.shared().refreshPostRelatedScreens(imgInfo,self.imgPostId, self, self.imagePostType == .editImagePost ? .editPost : .addPost)
                    
                    APIRequest.shared().saveNewInterest(interestID: imgInfo.valueForInt(key: CCategory_Id) ?? 0, interestName: imgInfo.valueForString(key: CCategory))
                }
                self.navigationController?.popToRootViewController(animated: true)
                CTopMostViewController.presentAlertViewWithOneButton(alertTitle: "", alertMessage: self.imagePostType == .editImagePost ? CMessageImagePostUpdated : CGalleryHasBeenPosted, btnOneTitle: CBtnOk, btnOneTapped: nil)
            }
        }
    }
    /* fileprivate func addEditImagePost(){
     var apiPara = [String : Any]()
     apiPara[CPostType] = 2
     apiPara[CCategory_Id] = categoryDropDownView.txtCategory.text
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
     
     var _arrMedia = self.arrMedia
     // When user editing the article....
     if imagePostType == .editImagePost{
     apiPara[CId] = imgPostId
     let deletedIDS = self.arrDeletedApiImages.map({$0}).joined(separator: ",")
     apiPara[CDeleteIds] = deletedIDS
     
     _arrMedia = self.arrMedia.filter({$0.uploadMediaStatus != .Succeed})
     }
     
     print(apiPara)
     /* Oldcode by Mi
     APIRequest.shared().addEditImageVideoPost(para: apiPara, arrMedia: _arrMedia, shoudShowLoader: true) { [weak self] (response, error) in
     guard let self = self else { return }
     if response != nil && error == nil{
     
     if let imgInfo = response![CJsonData] as? [String : Any]{
     MIGeneralsAPI.shared().refreshPostRelatedScreens(imgInfo,self.imgPostId, self, self.imagePostType == .editImagePost ? .editPost : .addPost)
     
     APIRequest.shared().saveNewInterest(interestID: imgInfo.valueForInt(key: CCategory_Id) ?? 0, interestName: imgInfo.valueForString(key: CCategory))
     }
     self.navigationController?.popToRootViewController(animated: true)
     CTopMostViewController.presentAlertViewWithOneButton(alertTitle: "", alertMessage: self.imagePostType == .editImagePost ? CMessageImagePostUpdated : CGalleryHasBeenPosted, btnOneTitle: CBtnOk, btnOneTapped: nil)
     }
     }
     */
     
     
     
     guard let userID = appDelegate.loginUser?.user_id else { return }
     
     let dict :[String:Any]  =  [
     "user_id":userID,
     "post_category":categoryDropDownView.txtCategory.text ?? "",
     //"images":["imagee15.jpeg","imagee16.jpeg","imagee17.jpeg"],
     "images": self.arrMedia,
     "targeted_audience":"VIP",
     "selected_persons":"Test3"
     ]
     
     
     APIRequest.shared().addEditPost(para: dict, image: nil, apiKeyCall: CAPITagsgallery) { [weak self] (response, error) in
     guard let self = self else { return }
     if response != nil && error == nil{
     
     if let imgInfo = response![CJsonData] as? [String : Any]{
     MIGeneralsAPI.shared().refreshPostRelatedScreens(imgInfo,self.imgPostId, self, self.imagePostType == .editImagePost ? .editPost : .addPost)
     
     APIRequest.shared().saveNewInterest(interestID: imgInfo.valueForInt(key: CCategory_Id) ?? 0, interestName: imgInfo.valueForString(key: CCategory))
     }
     self.navigationController?.popToRootViewController(animated: true)
     CTopMostViewController.presentAlertViewWithOneButton(alertTitle: "", alertMessage: self.imagePostType == .editImagePost ? CMessageImagePostUpdated : CGalleryHasBeenPosted, btnOneTitle: CBtnOk, btnOneTapped: nil)
     }
     }
     }*/
}


//MARK:- Collection View Delegate and Data Source Methods
extension AddMediaViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.colVMedia{
            if arrMedia.count > totalMediaUploadLimit{
                self.btnUploadMedia.alpha = 0.7
                self.btnUploadMedia.isEnabled = false
            }else{
                self.btnUploadMedia.alpha = 1.0
                self.btnUploadMedia.isEnabled = true
            }
            return arrMedia.count
        }
        if collectionView == self.clGroupFriend{
            return arrSelectedGroupFriends.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.colVMedia {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddMediaCollCell", for: indexPath) as? AddMediaCollCell else {
                return UICollectionViewCell(frame: .zero)
            }
            let media = arrMedia[indexPath.row]
            cell.media = media
            print(media)
            cell.btnClose.tag = indexPath.row
            cell.btnClose.touchUpInside { [weak self] (sender) in
                guard let _ = self else {return}
                if (self?.imagePostType == .editImagePost) {
                    self?.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CAreYouSureToDeleteThisMedia, btnOneTitle: CBtnYes, btnOneTapped: { (alert) in
                        let obj = self?.arrMedia[sender.tag]
                        if let mediaId = obj?.mediaID{
                            self?.arrDeletedApiImages.append(mediaId)
                        }
                        //self?.selectedAssets.remove(at: sender.tag)
                        self?.arrMedia.remove(at: sender.tag)
                        self?.colVMedia.reloadData()
                        
                    }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
                }else{
                    let obj = self?.arrMedia[sender.tag]
                    if let mediaId = obj?.mediaID{
                        self?.arrDeletedApiImages.append(mediaId)
                    }
                    
                    //self?.selectedAssets.remove(at: sender.tag)
                    self?.arrImagesVideo.remove(at: sender.tag)
                    self?.arrMedia.remove(at: sender.tag)
                    
                    self?.colVMedia.reloadData()
                }
            }
            return cell
        }
        
        if collectionView == self.clGroupFriend {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BubbleWithCancelCollCell", for: indexPath) as! BubbleWithCancelCollCell
            let selectedInfo = arrSelectedGroupFriends[indexPath.row]
            
            if (self.selectedInviteType == 2) {
                cell.lblBubbleText.text = selectedInfo.valueForString(key: CFirstname) + " " + selectedInfo.valueForString(key: CLastname)
            }else {
                cell.lblBubbleText.text = selectedInfo.valueForString(key: CGroupTitle)
            }
            return cell
        }
        
        return UICollectionViewCell(frame: .zero)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.clGroupFriend{
            arrSelectedGroupFriends.remove(at: indexPath.row)
            clGroupFriend.reloadData()
            
            if arrSelectedGroupFriends.count == 0{
                btnSelectGroupFriend.isHidden = false
                clGroupFriend.isHidden = true
                btnAddMoreFriends.isHidden = true
            }
        }
    }
}

//MARK:- UICollectionViewDelegateFlowLayout
extension AddMediaViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.colVMedia{
            let width = (collectionView.bounds.width - 20) / 2
            //width = width - 15
            let height = width - ((width * 40) / 100)
            return CGSize(width: width, height: height)
        }
        
        if collectionView == self.clGroupFriend{
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
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets.zero
    }
}

//MARK: - UIImagePickerControllerDelegate
extension AddMediaViewController  {
    
    func openImagePickerViewController(){
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .denied {
            let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!
            let alert = UIAlertController(
                title: nil,
                message: CDeniedCameraPermission,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: CBtnCancel, style: .destructive, handler: nil))
            alert.addAction(UIAlertAction(title: CNavSettings, style: .default, handler: { (alert) -> Void in
                UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("This device doesn't have a camera.")
            return
        }
        
        imagePicker.sourceType = .camera
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for:.camera)!
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    override func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String ?? ""
        if mediaType == "public.image"{
            var image:UIImage?
            //            var selectedImage: UIImage!
            var imageUrl: URL!
            if self.imagePicker.allowsEditing {
                image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
            } else {
                image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            }
            
            
            //            if picker.sourceType == UIImagePickerController.SourceType.camera {
            //
            //                   let imgName = "\(UUID().uuidString).jpeg"
            //                   let documentDirectory = NSTemporaryDirectory()
            //                   let localPath = documentDirectory.appending(imgName)
            //
            //                let data = (image?.jpegData(compressionQuality: 0.3)!)! as NSData
            //                   data.write(toFile: localPath, atomically: true)
            //                   imageUrl = URL.init(fileURLWithPath: localPath)
            //                 print("imageurl\(imageUrl)")
            //               } else if let selectedImageUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL {
            //                   imageUrl = selectedImageUrl
            //               }
            //
            
            //            guard let imageURL = info[UIImagePickerController.InfoKey.imageURL] as? NSURL else {
            //                return
            //            }
            //
            //            self.imgName = imageURL.absoluteString ?? ""
            //            self.arrMediaString.append(self.imgName)
            //
            ////            self.imgName = imageURL.absoluteString ?? ""
            //            MInioimageupload.shared().uploadMinioVideo(ImgnameStr:imageURL as URL)
            //            MInioimageupload.shared().callback = { message in
            //            print("UploadImage::::::::::::::\(message)")
            //  //          self.profileImgUrl = message
            //           }
            //
            //            if image != nil{
            //                let media = MDLAddMedia(image: image, url:nil)
            //                media.isFromGallery = false
            //                media.assetType = .Image
            //                media.isDownloadedFromiCloud = true
            //                self.arrMedia.append(media)
            ////                self.arrMediaString.append(media)
            //                self.colVMedia.reloadData()
            //            }
            //*************************************** NEW CODE ************************************************
            if image != nil{
                let media = MDLAddMedia(image: image, url:nil)
                media.isFromGallery = false
                media.assetType = .Image
                DispatchQueue.main.async {
                    MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: CMessagePleaseWait)
                }
                
                if (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) != nil {
                    let imgName = UUID().uuidString
                    let documentDirectory = NSTemporaryDirectory()
                    let localPath = documentDirectory.appending(imgName)
                    
                    let modileNum = appDelegate.loginUser?.mobile
                    
                    MInioimageupload.shared().uploadMinioimages(mobileNo: modileNum ?? "", ImageSTt: image!,isFrom:"",uploadFrom:"")
                    
                    MInioimageupload.shared().callback = { [self] imgUrls in
                        print("UploadImage::::::::::::::\(imgUrls)")
                        self.imgName = imgUrls
                        let content:[String:Any]  = [
                            //                                "mime": "video",
                            "mime": "image",
                            "media": "blob:http://localhost:3000/589fd493-401f-4c7c-867c-1938e16d7b68",
                            "image_path":imgUrls
                        ]
                        
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: content, options: .prettyPrinted)
                            let jsonString = String(data: jsonData, encoding: String.Encoding.ascii)
                            let trimmedString = jsonString?.components(separatedBy: .whitespacesAndNewlines).joined()
                            let replaced1 = trimmedString?.replacingOccurrences(of: "\\", with: "")
                            //                                        print("replace1\(replaced1)")
                            self.imageString = replaced1!
                        } catch {
                            print(error.localizedDescription)
                        }
                        self.arrImagesVideo.append(self.imageString)
                        print("*****************\(self.arrImagesVideo)")
                        if localPath.count == self.arrImagesVideo.count{
                            print("Success")
                            DispatchQueue.main.async {
                                MILoader.shared.hideLoader()
                            }
                        }else{
                            print("Failed")
                            DispatchQueue.main.async {
                                MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: CMessagePleaseWait)
                            }
                        }
                    }
                }
                
                media.isDownloadedFromiCloud = true
                self.arrMedia.append(media)
                //                self.arrMediaString.append(media)
                self.colVMedia.reloadData()
            }
        }else{
            if #available(iOS 11.0, *) {
                if let asset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset {
                    PHImageManager.default().requestAVAsset(forVideo: asset, options: nil, resultHandler: { (avAsset, audioMix, info) in
                        if let urlasset = avAsset as? AVURLAsset {
                            self.createThumbnailOfVideoFromRemoteUrl(url: urlasset.url)
                        }
                    })
                }else{
                    let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL
                    if videoURL != nil {
                        let asset = AVURLAsset(url: videoURL!, options: nil)
                        
                        let modileNum = appDelegate.loginUser?.mobile
                        let sampleImage = UIImage()
                        
                        MInioimageupload.shared().uploadMinioimages(mobileNo: modileNum ?? "", ImageSTt:sampleImage ,isFrom:"videos",uploadFrom:videoURL?.toString ?? "")
                        
                        MInioimageupload.shared().callback = { [self] imgUrls in
                            print("UploadImage::::::::::::::\(imgUrls)")
                            self.imgName = imgUrls
                            let content:[String:Any]  = [
                                "mime": "video",
                                "media": "blob:http://localhost:3000/589fd493-401f-4c7c-867c-1938e16d7b68",
                                "image_path":imgUrls
                            ]
                            
                            do {
                                let jsonData = try JSONSerialization.data(withJSONObject: content, options: .prettyPrinted)
                                let jsonString = String(data: jsonData, encoding: String.Encoding.ascii)
                                let trimmedString = jsonString?.components(separatedBy: .whitespacesAndNewlines).joined()
                                let replaced1 = trimmedString?.replacingOccurrences(of: "\\", with: "")
                                //                                        print("replace1\(replaced1)")
                                self.imageString = replaced1!
                            } catch {
                                print(error.localizedDescription)
                            }
                            self.arrImagesVideo.append(self.imageString)
                            print("*****************\(self.arrImagesVideo)")
                        }
                        
                        
                        self.createThumbnailOfVideoFromRemoteUrl(url: asset.url)
                    }
                }
            } else {
                let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL
                if videoURL != nil {
                    let asset = AVURLAsset(url: videoURL!, options: nil)
                    self.createThumbnailOfVideoFromRemoteUrl(url: asset.url)
                }
            }
        }
        picker.dismiss(animated: true)
    }
    
    override func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func createThumbnailOfVideoFromRemoteUrl(url: URL) {
        let asset = AVAsset(url: url)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        let time = CMTimeMakeWithSeconds(1.0, preferredTimescale: 500)
        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: img)
            let media = MDLAddMedia(image: thumbnail, url:url.absoluteString)
            media.isFromGallery = false
            media.assetType = .Video
            media.isDownloadedFromiCloud = true
            self.arrMedia.append(media)
            self.colVMedia.reloadData()
        } catch {
            print(error.localizedDescription)
        }
    }
}

//MARK: - TLPhotosPickerViewController
extension AddMediaViewController {
    
    func pickerButtonTap() {
        
        self.photosPickerVC.delegate = self
        var configure = TLPhotosPickerConfigure()
        configure.usedCameraButton = false
        configure.numberOfColumn = 3
        let count = self.arrMedia.filter({!$0.isFromGallery}).count
        configure.maxSelectedAssets = (5 - count)
        self.photosPickerVC.configure = configure
        self.photosPickerVC.selectedAssets = self.arrMedia.filter({$0.isFromGallery}).map({$0.asset!})
        self.photosPickerVC.logDelegate = self
        if #available(iOS 13.0, *){
            self.photosPickerVC.isModalInPresentation = true
            self.photosPickerVC.modalPresentationStyle = .fullScreen
        }
        self.present(self.photosPickerVC, animated: true, completion: nil)
    }
    
    func converVideoByteToHumanReadable(_ bytes:Int64) -> String {
        let formatter:ByteCountFormatter = ByteCountFormatter()
        formatter.countStyle = .binary
        return formatter.string(fromByteCount: Int64(bytes))
    }
    
    func exportVideo(asset:TLPHAsset ,onComplete:((_ thembnil:UIImage,_ videoURL:URL)->Void)?) {
        var vThum : UIImage!
        var vUrl : URL!
        if let thum = asset.fullResolutionImage{
            print(thum)
            vThum = thum
            if let videoURL = vUrl, let videoThum = vThum{
                onComplete?(videoThum,videoURL)
            }
        }
        //asset.phAsset
        let options = PHVideoRequestOptions()
        options.isNetworkAccessAllowed = true
        options.deliveryMode = .automatic
        //iCloud download progress
        options.progressHandler = { [weak self] (progress, error, stop, info) in
            guard let _ = self else { return }
            print(progress)
            print(info ?? ["Info":"Empty"])
            if (error != nil) {
                print(error?.localizedDescription ?? "")
            }
        }
        asset.exportVideoFile(options: options, progressBlock: { [weak self] (progress) in
            guard let _ = self else { return }
            print(progress)
        }) { [weak self] (url, mimeType) in
            guard let _ = self else { return }
            print("exportVideoFile : \(url)")
            print(mimeType)
            vUrl = url
            if let videoURL = vUrl, let videoThum = vThum{
                onComplete?(videoThum,videoURL)
            }
        }
    }
    
    func getSelectedImage(asset:TLPHAsset, onComplete:((_ thembnil:UIImage)->Void)?) {
        
        asset.cloudImageDownload(progressBlock: { [weak self] (progress) in
            guard let _ = self else { return }
            //guard let _ = self else {return}
            DispatchQueue.main.async {
                print(progress)
            }
        }, completionBlock: { [weak self] (image) in
            guard let _ = self else { return }
            //guard let _ = self else {return}
            if let _image = image {
                //use image
                DispatchQueue.main.async {
                    print(_image)
                    print("Image Path : \(asset.originalFileName ?? "")")
                    print("complete download")
                    onComplete?(_image)
                }
            }
        })
    }
    
    func getAssetsFromFileName(fileName:String) -> MDLAddMedia?{
        return self.arrMedia.filter({$0.fileName == fileName}).first
    }
}

//MARK: - TLPhotosPickerViewControllerDelegate ,TLPhotosPickerLogDelegate
extension AddMediaViewController : TLPhotosPickerViewControllerDelegate,TLPhotosPickerLogDelegate {
    
    func shouldDismissPhotoPicker(withTLPHAssets: [TLPHAsset]) -> Bool {
        
        //self.selectedAssets = withTLPHAssets
        self.arrMedia = self.arrMedia.filter({!$0.isFromGallery})
        
        for asset in withTLPHAssets{
            dispatchGroup.enter()
            
            print("File Name :  \(asset.originalFileName ?? "File not found")")
            switch asset.type{
            case .video:
                
                //***************************** NEW CODE ********************************************
                let videoMedia = MDLAddMedia()
                videoMedia.isFromGallery = false
                videoMedia.fileName = asset.originalFileName
                videoMedia.assetType = .Video
                
                DispatchQueue.main.async {
                    MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: CMessagePleaseWait)
                }
                asset.tempCopyMediaFile { [weak self] (url, min) in
                    guard let _ = self else {return}
                    self?.arrImages.append(url.absoluteString)
                    videoMedia.url = url.absoluteString
                    let urlVidoes = UIImage()
                    self?.imgName = url.absoluteString
                    
                    //                    self?.imgName.stringToImage { [self](image) in
                    let modileNum = appDelegate.loginUser?.mobile
                    
                    MInioimageupload.shared().uploadMinioimages(mobileNo: modileNum ?? "", ImageSTt: urlVidoes ,isFrom:"videos",uploadFrom:self?.imgName ?? "")
                    
                    MInioimageupload.shared().callback = { [self] imgUrls in
                        print("UploadImage::::::::::::::\(imgUrls)")
                        self?.imgName = imgUrls
                        let content:[String:Any]  = [
                            "mime": "video",
                            "media": "blob:http://localhost:3000/589fd493-401f-4c7c-867c-1938e16d7b68",
                            "image_path":imgUrls
                        ]
                        
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: content, options: .prettyPrinted)
                            let jsonString = String(data: jsonData, encoding: String.Encoding.ascii)
                            let trimmedString = jsonString?.components(separatedBy: .whitespacesAndNewlines).joined()
                            let replaced1 = trimmedString?.replacingOccurrences(of: "\\", with: "")
                            //                                        print("replace1\(replaced1)")
                            self?.imageString = replaced1!
                        } catch {
                            print(error.localizedDescription)
                        }
                        self?.arrImagesVideo.append(self!.imageString)
                        print("*****************\(self!.arrImagesVideo)")
                        if self?.arrImages.count == self?.arrImagesVideo.count{
                            print("Success")
                            DispatchQueue.main.async {
                                MILoader.shared.hideLoader()
                            }
                        }else{
                            print("Failed")
                            DispatchQueue.main.async {
                                MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: CMessagePleaseWait)
                            }
                        }
                    }
                }
                
                videoMedia.asset = asset
                self.arrMedia.append(videoMedia)
                self.colVMedia.reloadData()
                exportVideo(asset: asset) { [weak self] (thum,url)in
                    guard let _ = self else {return}
                    if let media = self?.getAssetsFromFileName(fileName: asset.originalFileName ?? ""){
                        media.image = thum
                        media.url = url.absoluteString
                        media.fileName = asset.originalFileName
                        media.isDownloadedFromiCloud = true
                        //                        self.arrImages.append(contentsOf: url.absoluteURL)
                        GCDMainThread.async {
                            self?.colVMedia.reloadData()
                        }
                    }
                    self?.dispatchGroup.leave()
                }
                break
            /*let videoMedia = MDLAddMedia()
             videoMedia.fileName = asset.originalFileName
             videoMedia.assetType = .Video
             videoMedia.asset = asset
             self.arrMedia.append(videoMedia)
             self.colVMedia.reloadData()
             
             asset.tempCopyMediaFile { [weak self] (url, min) in
             self?.arrImages.append(url.absoluteString)
             print("::::::::",url.absoluteString)
             let urlStr = URL(string: url.absoluteString)
             
             MInioimageupload.shared().uploadMinioVideo(ImgnameStr:urlStr!)
             MInioimageupload.shared().callback = { [self] imgUrls in
             print("UploadImage::::::::::::::\(imgUrls)")
             self?.imgName = imgUrls
             self?.arrImagesVideo.append(imgUrls)
             print("*****************\(self!.arrImagesVideo)")
             }
             
             }
             exportVideo(asset: asset) { [weak self] (thum,url)in
             guard let _ = self else {return}
             if let media = self?.getAssetsFromFileName(fileName: asset.originalFileName ?? ""){
             media.image = thum
             media.url = url.absoluteString
             media.fileName = asset.originalFileName
             media.isDownloadedFromiCloud = true
             //                        self.arrImages.append(contentsOf: url.absoluteURL)
             GCDMainThread.async {
             self?.colVMedia.reloadData()
             }
             }
             self?.dispatchGroup.leave()
             }
             break*/
            case .livePhoto:
                let imageMedia = MDLAddMedia()
                imageMedia.isFromGallery = false
                imageMedia.fileName = asset.originalFileName
                imageMedia.assetType = .Image
                DispatchQueue.main.async {
                    MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: CMessagePleaseWait)
                }
                asset.tempCopyMediaFile { [weak self] (url, min) in
                    guard let _ = self else {return}
                    self?.arrImages.append(url.absoluteString)
                    imageMedia.url = url.absoluteString
                    let urlVidoes = UIImage()
                    self?.imgName = url.absoluteString
                    let modileNum = appDelegate.loginUser?.mobile
                    MInioimageupload.shared().uploadMinioimages(mobileNo: modileNum ?? "", ImageSTt: urlVidoes ,isFrom:"videos",uploadFrom:self?.imgName ?? "")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                        MInioimageupload.shared().callback = { [self] imgUrls in
                            print("UploadImage::::::::::::::\(imgUrls)")
                            self?.imgName = imgUrls
                            let content:[String:Any]  = [
                                "mime": "video",
                                "media": "blob:http://localhost:3000/589fd493-401f-4c7c-867c-1938e16d7b68",
                                "image_path":imgUrls
                            ]
                            
                            do {
                                let jsonData = try JSONSerialization.data(withJSONObject: content, options: .prettyPrinted)
                                let jsonString = String(data: jsonData, encoding: String.Encoding.ascii)
                                let trimmedString = jsonString?.components(separatedBy: .whitespacesAndNewlines).joined()
                                let replaced1 = trimmedString?.replacingOccurrences(of: "\\", with: "")
                                //                                        print("replace1\(replaced1)")
                                self?.imageString = replaced1!
                            } catch {
                                print(error.localizedDescription)
                            }
                            self?.arrImagesVideo.append(self!.imageString)
                            print("*****************\(self!.arrImagesVideo)")
                            if self?.arrImages.count == self?.arrImagesVideo.count{
                                print("Success")
                                DispatchQueue.main.async {
                                    MILoader.shared.hideLoader()
                                }
                            }else{
                                print("Failed")
                                DispatchQueue.main.async {
                                    MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: CMessagePleaseWait)
                                }
                                
                            }
                        }
                    }
                }
                
                imageMedia.asset = asset
                self.arrMedia.append(imageMedia)
                getSelectedImage(asset: asset) { [weak self] (image) in
                    guard let _ = self else {return}
                    if let media = self?.getAssetsFromFileName(fileName: asset.originalFileName ?? ""){
                        media.image = image
                        media.fileName = asset.originalFileName
                        media.isDownloadedFromiCloud = true
                        GCDMainThread.async {
                            self?.colVMedia.reloadData()
                        }
                    }
                    self?.dispatchGroup.leave()
                }
                break
            case .photo :
                var content = [String:Any]()
                let imageMedia = MDLAddMedia()
                imageMedia.isFromGallery = false
                imageMedia.fileName = asset.originalFileName
                imageMedia.assetType = .Image
                DispatchQueue.main.async {
                    MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: CMessagePleaseWait)
                }
                asset.tempCopyMediaFile { [weak self] (url, min) in
                    guard let _ = self else {return}
                    self?.arrImages.append(url.absoluteString)
                    imageMedia.url = url.absoluteString
                    self?.imgName = url.absoluteString
                    self?.imgName.stringToImage { [self](image) in
                        guard let modileNum = appDelegate.loginUser?.mobile else {
                            return
                        }
                        MInioimageupload.shared().uploadMinioimages(mobileNo: modileNum, ImageSTt: image!,isFrom:"",uploadFrom:"")
                        MInioimageupload.shared().callback = { [self] imgUrls in
                            print("UploadImage::::::::::::::\(imgUrls)")
                            self?.imgName = imgUrls
                            let imgExt = imgUrls.fileExtension()
                            print("imgExt\(imgExt)")
                            if imgExt == "mp4" ||  imgExt == "mov" ||  imgExt == "MOV"{
                                content = [
                                    "mime": "video",
                                    "media": "blob:http://localhost:3000/589fd493-401f-4c7c-867c-1938e16d7b68",
                                    "image_path":imgUrls
                                ]
                            }else {
                                content = [
                                    "mime": "image",
                                    "media": "blob:http://localhost:3000/589fd493-401f-4c7c-867c-1938e16d7b68",
                                    "image_path":imgUrls
                                ]
                            }
                            do {
                                let jsonData = try JSONSerialization.data(withJSONObject: content, options: .prettyPrinted)
                                let jsonString = String(data: jsonData, encoding: String.Encoding.ascii)
                                let trimmedString = jsonString?.components(separatedBy: .whitespacesAndNewlines).joined()
                                let replaced1 = trimmedString?.replacingOccurrences(of: "\\", with: "")
                                //                                        print("replace1\(replaced1)")
                                self?.imageString = replaced1!
                            } catch {
                                print(error.localizedDescription)
                            }
                            self?.arrImagesVideo.append(self!.imageString)
                            print("*****************\(self!.arrImagesVideo)")
                            if self?.arrImages.count == self?.arrImagesVideo.count{
                                print("Success")
                                DispatchQueue.main.async {
                                    MILoader.shared.hideLoader()
                                }
                            }else{
                                print("Failed")
                                DispatchQueue.main.async {
                                    MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: CMessagePleaseWait)
                                }
                                
                            }
                        }
                        
                        //                                self?.imgName.stringToImage {(image) in
                        //                                    guard let mobileNum = appDelegate.loginUser?.mobile else {return}
                        //                                    MInioimageupload.shared().uploadMinioimages(mobileNo: mobileNum, ImageSTt: image!)
                        //                                    MInioimageupload.shared().callback = { [self] imgUrls in
                        //                                    print("UploadImage::::::::::::::\(imgUrls)")
                        //                                        self?.imgName = imgUrls
                        //                                        self?.arrImagesVideo.append(imgUrls)
                        //                                        print("*****************\(self!.arrImagesVideo)")
                        //                                    }
                        
                    }
                }
                imageMedia.asset = asset
                self.arrMedia.append(imageMedia)
                getSelectedImage(asset: asset) { [weak self] (image) in
                    guard let _ = self else {return}
                    if let media = self?.getAssetsFromFileName(fileName: asset.originalFileName ?? ""){
                        media.image = image
                        media.isDownloadedFromiCloud = true
                        media.fileName = asset.originalFileName
                        GCDMainThread.async {
                            self?.colVMedia.reloadData()
                        }
                    }
                    
                    self?.dispatchGroup.leave()
                }
                //*********************************** OLD ******************************************
                /*  let imageMedia = MDLAddMedia()
                 imageMedia.fileName = asset.originalFileName
                 imageMedia.assetType = .Image
                 imageMedia.asset = asset
                 self.arrMedia.append(imageMedia)
                 
                 
                 getSelectedImage(asset: asset) { [weak self] (image) in
                 guard let _ = self else {return}
                 if let media = self?.getAssetsFromFileName(fileName: asset.originalFileName ?? ""){
                 media.image = image
                 media.isDownloadedFromiCloud = true
                 media.fileName = asset.originalFileName
                 GCDMainThread.async {
                 self?.colVMedia.reloadData()
                 }
                 }
                 self?.dispatchGroup.leave()
                 }*/
                break
            }
            
        }
        self.colVMedia.reloadData()
        dispatchGroup.notify(queue: .main) {
            print("All Assets downloaded 👍")
        }
        return true
    }
    
    func dismissPhotoPicker(withPHAssets: [PHAsset]) {
    }
    
    func handleNoAlbumPermissions(picker: TLPhotosPickerViewController) {
        picker.dismiss(animated: true) {
            let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!
            let alert = UIAlertController(
                title: nil,
                message: CDeniedAlbumsPermission,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: CBtnCancel, style: .destructive, handler: nil))
            alert.addAction(UIAlertAction(title: CNavSettings, style: .default, handler: { (alert) -> Void in
                UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //For Log User Interaction
    func selectedCameraCell(picker: TLPhotosPickerViewController) {
        print("selectedCameraCell")
    }
    
    func selectedPhoto(picker: TLPhotosPickerViewController, at: Int) {
        print("selectedPhoto")
    }
    
    func deselectedPhoto(picker: TLPhotosPickerViewController, at: Int) {
        print("deselectedPhoto")
    }
    
    func selectedAlbum(picker: TLPhotosPickerViewController, title: String, at: Int) {
        print("selectedAlbum")
    }
    
    func canSelectAsset(phAsset: PHAsset) -> Bool {
        
        if phAsset.mediaType == .video{
            
            let resources = PHAssetResource.assetResources(for: phAsset)
            var sizeOnDisk: Int64? = 0
            if let resource = resources.first {
                let unsignedInt64 = resource.value(forKey: "fileSize") as? CLong
                sizeOnDisk = Int64(bitPattern: UInt64(unsignedInt64!))
            }
            
            let onDisk = sizeOnDisk ?? 0
            let mb : Int = Int(onDisk / 1000 / 1000)
            print("sizeOnDisk : \(converVideoByteToHumanReadable(sizeOnDisk ?? 0))")
            let tooLarge = mb > maxVideoFileSizeInMB
            if tooLarge {
                self.photosPickerVC.presentAlertViewWithOneButton(alertTitle: nil, alertMessage: CMaximumStorageOfProductVideoExceeds, btnOneTitle: CBtnOk , btnOneTapped: nil)
                print("Too large")
                return false
            }
        }
        return true
    }
}

//MARK: - IBAction / Selector -

extension AddMediaViewController {
    
    @IBAction func onUploadMedia(_ sender: UIButton) {
        self.presentActionsheetWithTwoButtons(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CRegisterChooseFromPhone, btnOneStyle: .default, btnOneTapped: { [weak self] (alert) in
            guard let self = self else { return }
            self.pickerButtonTap()
            
        }, btnTwoTitle: CRegisterTakePhoto, btnTwoStyle: .default) { [weak self] (alert) in
            guard let self = self else { return }
            if self.arrMedia.count < self.totalMediaUploadLimit {
                self.openImagePickerViewController()
            }
        }
    }
    
    @IBAction func btnSelectGroupFriendCLK(_ sender : UIButton){
        
        if let groupFriendVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "GroupFriendSelectionViewController") as? GroupFriendSelectionViewController {
            
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
    
    @objc fileprivate func btnAddMediaPost(_ sender : UIBarButtonItem) {
        self.resignKeyboard()
        
        if (categoryDropDownView.txtCategory.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageGalleryCategory, btnOneTitle: CBtnOk, btnOneTapped: nil)
            return
        }
        
        if arrMedia.count < 1 {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CPleaseSelectAtLeastOneOmageVideo, btnOneTitle: CBtnOk, btnOneTapped: nil)
            return
        } else if arrMedia.count > totalMediaUploadLimit {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageMaximumImage, btnOneTitle: CBtnOk, btnOneTapped: nil)
            return
        }
        
        if (self.selectedInviteType == 1 || self.selectedInviteType == 2) && arrSelectedGroupFriends.count == 0 {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageSelectContactGroupImage, btnOneTitle: CBtnOk, btnOneTapped: nil)
            return
        }
        
        self.addEditImagePost()
    }
}

extension String {
    
    func stringToImage(_ handler: @escaping ((UIImage?)->())) {
        if let url = URL(string: self) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    let image = UIImage(data: data)
                    handler(image)
                }
            }.resume()
        }
    }
}

//MARK: -Api call
extension AddMediaViewController{
    
    //    func loadInterestList(interestType : String, showLoader : Bool) {
    //
    //        if apiTask?.state == URLSessionTask.State.running {
    //            return
    //        }
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

extension AddMediaViewController{
    
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

