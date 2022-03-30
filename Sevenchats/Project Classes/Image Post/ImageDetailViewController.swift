//
//  ImageDetailViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 24/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : ImageDetailViewController                   *
 * Changes :                                             *
 *                                                       *
 ********************************************************/


import UIKit
import ActiveLabel
import AVKit
import AVFoundation
import Lightbox


class ImageDetailViewController: ParentViewController {
    
    @IBOutlet weak var lblUserName : UILabel!
    @IBOutlet weak var lblGalleryPostDate : UILabel!
    @IBOutlet weak var imgUser : UIImageView!
    @IBOutlet weak var lblGalleryCategory : UILabel!
    @IBOutlet weak var lblGalleryType : UILabel!
    @IBOutlet weak var clGallery : UICollectionView!{
        didSet{
            clGallery.register(UINib(nibName: "HomeEventGalleryCell", bundle: nil), forCellWithReuseIdentifier: "HomeEventGalleryCell")
            clGallery.isPagingEnabled = false
            clGallery.delegate = self
            clGallery.dataSource = self
        }
    }
    
    @IBOutlet weak var vwCountImage : UIView!
    @IBOutlet weak var lblCountImage : UILabel!
    
    
    //@IBOutlet weak var viewContentContainer : UIView!
    @IBOutlet weak var viewCommentContainer : UIView!
    @IBOutlet weak var tblCommentList : UITableView! {
        didSet {
            tblCommentList.register(UINib(nibName: "CommentTblCell", bundle: nil), forCellReuseIdentifier: "CommentTblCell")
            tblCommentList.estimatedRowHeight = 100;
            tblCommentList.rowHeight = UITableView.automaticDimension;
            tblCommentList.tableFooterView = UIView()
            tblCommentList.delegate = self
            tblCommentList.dataSource = self
            tblCommentList.separatorStyle = .none
        }
    }
    @IBOutlet weak var btnSend : UIButton!
    @IBOutlet fileprivate weak var cnTextViewHeight : NSLayoutConstraint!
    @IBOutlet weak var btnLike : UIButton!
    @IBOutlet weak var btnLikeCount : UIButton!
    @IBOutlet weak var btnComment : UIButton!
    @IBOutlet weak var btnShare : UIButton!
    @IBOutlet weak var txtViewComment : GenericTextView! {
        didSet{
            txtViewComment.genericDelegate = self
            txtViewComment.PlaceHolderColor = ColorPlaceholder
            txtViewComment.type = "1"
        }
    }
    
    // Set for User suggestion view...
    @IBOutlet fileprivate weak var viewUserSuggestion : UserSuggestionView! {
        didSet {
            viewUserSuggestion.userSuggestionDelegate = self
            viewUserSuggestion.initialization()
        }
    }
    
    @IBOutlet weak var btnProfileImg : UIButton!
    @IBOutlet weak var btnUserName : UIButton!
    
    var imageIndex:Int = 0
    var arrCommentList = [[String:Any]]()
    var arrGalleryImage : [[String : Any]] = []
    var arrGalleryImageNew : [String : Any] = [:]
    var galleryInfo = [String : Any]()
    var galleryInfoNew = [String : Any]()
    var arrGalleryImageLatest : [String] = []
    var arrGalleryImagetype : [String] = []
    var imgPostId : Int?
    var imgPostIdNew : String?
    var apiTask : URLSessionTask?
    var pageNumber = 1
    var refreshControl = UIRefreshControl()
    var likeCount = 0
    var commentCount = 0
    var editCommentId : Int? = nil
    var totalComment = 0
    var like =  0
    var info = [String:Any]()
    var commentinfo = [String:Any]()
    var likeTotalCount = 0
    var posted_ID = ""
    var profileImg = ""
    var notifcationIsSlected = false
    var isLikesOthers:Bool?
    var isLikeSelected = false
    var isFinalLikeSelected = false
    var isLikesOthersPage:Bool?
    var isLikesHomePage:Bool?
    var isLikesMyprofilePage:Bool?
    var posted_IDOthers = ""
    var notificationInfo = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Initialization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setGalleryDetailData(galleryInfo)
        updateUIAccordingToLanguage()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- ----------- Initialization
    func Initialization(){
        
        self.title = CNavImageDetails
        self.view.backgroundColor = CRGB(r: 249, g: 250, b: 250)
        self.parentView.backgroundColor = .clear
        self.tblCommentList.backgroundColor = .clear
        
        self.imgUser.layer.cornerRadius = self.imgUser.CViewWidth/2
        self.imgUser.layer.borderWidth = 2
        self.imgUser.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
        self.viewCommentContainer.shadow(color: ColorAppTheme, shadowOffset: CGSize(width: 0, height: 5), shadowRadius: 10.0, shadowOpacity: 10.0)
        self.lblGalleryType.layer.cornerRadius = 3
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: #imageLiteral(resourceName: "ic_btn_nav_more"), style: .plain, target: self, action: #selector(self.btnMenuClicked(_:)))]
        self.btnShare.setTitle(CBtnShare, for: .normal)
        
        self.refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
        self.refreshControl.tintColor = ColorAppTheme
        self.tblCommentList.pullToRefreshControl = self.refreshControl
        self.pageNumber = 1
        
        self.vwCountImage.layer.cornerRadius = 4
        self.getGalleryDetailsFromServer()
        
    }
    
    func updateUIAccordingToLanguage(){
        
        if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
            // Reverse Flow...
            btnLike.contentHorizontalAlignment = .left
            btnLikeCount.contentHorizontalAlignment = .right
            btnComment.contentHorizontalAlignment = .right
            btnShare.contentHorizontalAlignment = .right
            clGallery.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }else{
            // Normal Flow...
            btnLike.contentHorizontalAlignment = .right
            btnLikeCount.contentHorizontalAlignment = .left
            btnComment.contentHorizontalAlignment = .left
            btnShare.contentHorizontalAlignment = .left
            clGallery.transform = CGAffineTransform.identity
        }
        
        txtViewComment.placeHolder = CMessageTypeYourMessage
        
        GCDMainThread.async {
            self.clGallery.reloadData()
        }
    }
}

// MARK:- --------- Api Functions
extension ImageDetailViewController{
    
    @objc func pullToRefresh() {
        if apiTask?.state == URLSessionTask.State.running {
            apiTask?.cancel()
        }
        
        self.pageNumber = 1
        refreshControl.beginRefreshing()
        self.getGalleryDetailsFromServer()
    }
    
    fileprivate func getGalleryDetailsFromServer() {
        self.parentView.isHidden = true
        if let imgID = self.imgPostId {
            guard let userid = appDelegate.loginUser?.user_id else { return }
            APIRequest.shared().viewPostDetailLatest(postID: imgID,userid: userid.description, apiKeyCall: "galleries"){ [weak self] (response, error) in
                guard let self = self else { return }
                if response != nil {
                    self.parentView.isHidden = false
                    if let Info = response!["data"] as? [[String:Any]]{
                        
                        print(Info as Any)
                        for galleryInfo in Info {
                            //                            self.setGalleryDetailData(galleryInfo)
                            self.openUserProfileScreen()
                        }
                    }
                }
                self.getCommentListFromServer()
            }
        }
    }
    
    fileprivate func openUserProfileScreen(){
        
        self.btnProfileImg.touchUpInside { [weak self] (sender) in
            guard let self = self else { return }
            appDelegate.moveOnProfileScreenNew(self.galleryInfo.valueForString(key: CUserId), self.galleryInfo.valueForString(key: CUsermailID), self)
        }
        
        self.btnUserName.touchUpInside { [weak self] (sender) in
            guard let self = self else { return }
            appDelegate.moveOnProfileScreenNew(self.galleryInfo.valueForString(key: CUserId), self.galleryInfo.valueForString(key: CUsermailID), self)
            
        }
    }
    
    func setGalleryDetailData(_ gallerInfo : [String : Any]?) {
        arrGalleryImageLatest.removeAll()
        if let galInfo = gallerInfo{
            galleryInfo = galInfo
            notificationInfo = galInfo
            self.imgPostIdNew = galleryInfo.valueForString(key:CPostId)
//            posted_ID = galleryInfo.valueForString(key: "user_id")
            if isLikesOthersPage == true {
                posted_ID = self.posted_IDOthers
            }else {
                posted_ID = galleryInfo.valueForString(key: "user_id")
            }
            
            
            self.lblUserName.text = galInfo.valueForString(key: CFirstname) + " " + galInfo.valueForString(key: CLastname)
            self.imgUser.loadImageFromUrl(galInfo.valueForString(key: CUserProfileImage), true)
            if galInfo.valueForString(key: CCategory) == "0"{
                self.lblGalleryCategory.text = ""
            }else{
                self.lblGalleryCategory.text = galInfo.valueForString(key: CCategory).uppercased()
            }
            self.lblGalleryType.text = CTypeGallery
            if let arrImg = galInfo["image"] as? String {
                let dict = arrImg.convertToDictionary()
                let arrDictGallery = dict ?? []
                arrGalleryImage = arrDictGallery
                for imgData in arrDictGallery{
                    let imagepath = imgData.valueForString(key: "image_path")
                    let imagepathtype = imgData.valueForString(key: "mime")
                    arrGalleryImageLatest.append(imagepath)
                    arrGalleryImagetype.append(imagepathtype)
                }
            }
            
            self.vwCountImage.isHidden = (arrGalleryImage.count <= 1)
            let is_Liked = galleryInfo.valueForString(key: CIsLiked)

            if isLikesOthersPage == true {
                if galleryInfo.valueForString(key:"friend_liked") == "Yes"  && galleryInfo.valueForString(key:"is_liked") == "Yes" {
                    btnLike.isSelected = true
                    if galleryInfo.valueForString(key:"is_liked") == "No"{
                        isLikeSelected = false
                    }
                }else {
                    if galleryInfo.valueForString(key:"is_liked") == "No" && galleryInfo.valueForString(key:"friend_liked") == "No" {
                        isLikeSelected = true
                    }
                    btnLike.isSelected = false
                }
                
                if galleryInfo.valueForString(key:"is_liked") == "Yes" && galleryInfo.valueForString(key:"friend_liked") == "No" {
                    isLikeSelected = true
                    btnLike.isSelected = false
                }else if galleryInfo.valueForString(key:"is_liked") == "No" && galleryInfo.valueForString(key:"friend_liked") == "Yes"{
                    
                    isLikeSelected = false
                    btnLike.isSelected = true

                }
            }
            if isLikesHomePage == true  || isLikesMyprofilePage == true {
                if galleryInfo.valueForString(key:CIs_Liked) == "Yes"{
                    btnLike.isSelected = true
                }else {
                    btnLike.isSelected = false
                }
            }
            likeCount = galleryInfo.valueForString(key: CLikes).toInt ?? 0
            self.btnLikeCount.setTitle(appDelegate.getLikeString(like: likeCount), for: .normal)
            commentCount = galleryInfo.valueForString(key: "comments").toInt ?? 0
            self.totalComment = commentCount
            btnComment.setTitle(appDelegate.getCommentCountString(comment: commentCount), for: .normal)
            
            self.tblCommentList.updateHeaderViewHeight(extxtraSpace: 0)
            let created_At = galleryInfo.valueForString(key: CCreated_at)
            let cnvStr = created_At.stringBefore("G")
            let startCreated = DateFormatter.shared().convertDatereversLatest(strDate: cnvStr)
            lblGalleryPostDate.text = startCreated
            GCDMainThread.async {
                self.tblCommentList.updateHeaderViewHeight(extxtraSpace: 50)
            }
            self.tblCommentList.updateHeaderViewHeight(extxtraSpace: 0)
        }
    }
    
    fileprivate func deleteGalleryPost(_ galleryInfo : [String : Any]?){
        
        if let imgID = self.imgPostId{
            self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CMessageDeletePost, btnOneTitle: CBtnYes, btnOneTapped: { [weak self] (alert) in
                let postTypeDelete = "post_gallery"
                let dict = [
                    "post_id": galleryInfo?.valueForString(key: "post_id"),
                    "post_category": galleryInfo?.valueForString(key: "post_category"),
                    "images":galleryInfo?.valueForString(key: "image"),
                    "targeted_audience": galleryInfo?.valueForString(key: "targeted_audience"),
                    "selected_persons": galleryInfo?.valueForString(key: "selected_persons"),
                    "status_id": "3"
                ]
                
                guard let self = self else { return }
                APIRequest.shared().deletePostNew(postDetials: dict as [String : Any], apiKeyCall: postTypeDelete, completion: { [weak self](response, error) in
                    
                    guard let self = self else { return }
                    if response != nil && error == nil{
                        self.navigationController?.popViewController(animated: true)
                        MIGeneralsAPI.shared().refreshPostRelatedScreens(nil, imgID, self, .deletePost, rss_id: 0)
                    }
                })
            }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
        }
    }
    
    
    fileprivate func getCommentListFromServer(){
        
        if let imgID = self.imgPostIdNew{
            
            if apiTask?.state == URLSessionTask.State.running {
                self.refreshControl.endRefreshing()
                return
            }
            
            self.arrCommentList.removeAll()
            // Add load more indicator here...
            self.tblCommentList.tableFooterView = self.pageNumber > 2 ? self.loadMoreIndicator(ColorAppTheme) : UIView()
            
            apiTask = APIRequest.shared().getProductCommentLists(page: pageNumber, showLoader: false, productId:imgID) { [weak self] (response, error) in
                guard let self = self else { return }
                self.tblCommentList.tableFooterView = UIView()
                self.refreshControl.endRefreshing()
                self.apiTask?.cancel()
                
                if response != nil {
                    
                    if let arrList = response!["comments"] as? [[String:Any]] {
                        
                        // Remove all data here when page number == 1
                        if self.pageNumber == 1 {
                            self.arrCommentList.removeAll()
                            self.tblCommentList.reloadData()
                        }
                        
                        // Add Data here...
                        if arrList.count > 0{
                            self.arrCommentList = self.arrCommentList + arrList
                            self.tblCommentList.reloadData()
                            self.pageNumber += 1
                        }
                    }
                    
                    print("arrCommentListCount : \(self.arrCommentList.count)")
                }
            }
        }
    }
    
    func updateGalleryCommentSection(_ arrComm : [[String : Any]], _ totalComment : Int) {
        
    }
}

// MARK:- --------- UICollectionView Delegate/Datasources
extension ImageDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrGalleryImageLatest.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if arrGalleryImageLatest.count > 1{
            var width = clGallery.frame.size.width
            width = width - ((width * 30) / 100)
            return CGSize(width:width, height: clGallery.bounds.height)
        }
        return CGSize(width:clGallery.bounds.width, height: clGallery.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeEventGalleryCell", for: indexPath) as! HomeEventGalleryCell
        let imgInfo = arrGalleryImageLatest[indexPath.item]
        let imgInfotype = arrGalleryImagetype[indexPath.item]
        cell.vwBackgroundImg.backgroundColor = UIColor(hex: "DEDDE5")
        let mediaType = imgInfotype
        if (mediaType == "video") || (mediaType == "vidoe"){
            if let url = URL(string: imgInfo) {
                if let thumbnailImage = getThumbnailImage(forUrl: url) {
                    cell.blurImgView.image = thumbnailImage
                }
            }
            cell.imgVideoIcon.isHidden =  false
        }else {
            cell.blurImgView.heightAnchor.constraint(equalToConstant: CGFloat(0)).isActive = true
            cell.blurImgView.loadImageFromUrl(imgInfo, false)
            cell.imgVideoIcon.isHidden =  true
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let lightBoxHelper = LightBoxControllerHelper()
        weak var weakSelf = self.viewController
        _ = self.viewController
        lightBoxHelper.openMultipleImagesWithVideos(arrGalleryImage: arrGalleryImage, controller: weakSelf,selectedIndex: indexPath.row)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        setCurrentImageCount()
    }
    
    func setCurrentImageCount(){
        var visibleRect = CGRect()
        visibleRect.origin = self.clGallery.contentOffset
        visibleRect.size = self.clGallery.bounds.size
        let visiblePoint = CGPoint(x: CGFloat(visibleRect.midX), y: CGFloat(visibleRect.midY))
        if let indexPath: IndexPath = self.clGallery.indexPathForItem(at: visiblePoint){
            _ = indexPath.row + 1
            self.lblCountImage.text = ""
        }
    }
}

// MARK:- --------- UITableView Datasources/Delegate
extension ImageDetailViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrCommentList.count > 0 ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let header = EventCommentTblHeader.viewFromXib as? EventCommentTblHeader{
            header.backgroundColor =  CRGB(r: 249, g: 250, b: 250)
            header.lblTitle.text = appDelegate.getCommentCountString(comment: commentCount)
            return header
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCommentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTblCell", for: indexPath) as? CommentTblCell {
            
            weak var weakCell = cell
            let commentInfo = arrCommentList[indexPath.row]
            let timeStamp = DateFormatter.shared().getDateFromTimeStamp(timeStamp:commentInfo.valueForString(key: "updated_at").toDouble ?? 0.0)
            cell.lblCommentPostDate.text = timeStamp
            cell.lblUserName.text = commentInfo.valueForString(key: CFirstname) + " " + commentInfo.valueForString(key: CLastname)
            cell.imgUser.loadImageFromUrl(commentInfo.valueForString(key: CUserProfileImage), true)
            var commentText = commentInfo.valueForString(key: "comment")
            cell.lblCommentText.enabledTypes.removeAll()
            cell.viewDevider.isHidden = ((arrCommentList.count - 1) == indexPath.row)
            
            if Int64(commentInfo.valueForString(key: CUserId)) == appDelegate.loginUser?.user_id{
                cell.btnMoreOption.isHidden = false
            }else{
                cell.btnMoreOption.isHidden = true
            }
            cell.btnMoreOption.touchUpInside { [weak self] (_) in
                self?.btnMoreOptionOfComment(index: indexPath.row)
            }
            if let arrIncludedUsers = commentInfo[CIncludeUserId] as? [[String : Any]] {
                for userInfo in arrIncludedUsers {
                    let userName = userInfo.valueForString(key: CFirstname) + " " + userInfo.valueForString(key: CLastname)
                    let customTypeUserName = ActiveType.custom(pattern: "\(userName)") //Looks for "user name"
                    cell.lblCommentText.enabledTypes.append(customTypeUserName)
                    cell.lblCommentText.customColor[customTypeUserName] = ColorAppTheme
                    
                    cell.lblCommentText.handleCustomTap(for: customTypeUserName, handler: { [weak self] (name) in
                        guard let self = self else { return }
                        print(name)
                        let arrSelectedUser = arrIncludedUsers.filter({$0[CFullName] as? String == name})
                        
                        if arrSelectedUser.count > 0 {
                            let userSelectedInfo = arrSelectedUser[0]
                            appDelegate.moveOnProfileScreenNew(userSelectedInfo.valueForString(key: CUserId), userSelectedInfo.valueForString(key: CUsermailID), self)
                            
                        }
                    })
                    
                    commentText = commentText.replacingOccurrences(of: String(NSString(format: kMentionFriendStringFormate as NSString, userInfo.valueForString(key: CUserId))), with: userName)
                }
            }
            
            cell.lblCommentText.customize { [weak self] label in
                guard let self = self else { return }
                label.text = commentText
                label.minimumLineHeight = 0.0
                
                label.configureLinkAttribute = { [weak self](type, attributes, isSelected) in
                    guard let _ = self else { return attributes}
                    var atts = attributes
                    atts[NSAttributedString.Key.font] = CFontPoppins(size: weakCell?.lblCommentText.font.pointSize ?? 0, type: .meduim)
                    return atts
                }
            }
            
            cell.btnUserName.touchUpInside { [weak self] (sender) in
                guard let self = self else { return }
                appDelegate.moveOnProfileScreenNew(commentInfo.valueForString(key: CUserId), commentInfo.valueForString(key: CUsermailID), self)
                
            }
            
            cell.btnUserImage.touchUpInside { [weak self] (sender) in
                guard let self = self else { return }
                appDelegate.moveOnProfileScreenNew(commentInfo.valueForString(key: CUserId), commentInfo.valueForString(key: CUsermailID), self)
            }
            
            // Load more data....
            //            if (indexPath == tblCommentList.lastIndexPath()) && apiTask?.state != URLSessionTask.State.running {
            //                self.getCommentListFromServer()
            //            }
            
            return cell
        }
        
        return tableView.tableViewDummyCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}


// MARK:-  --------- Generic UITextView Delegate
extension ImageDetailViewController: GenericTextViewDelegate{
    
    func genericTextViewDidChange(_ textView: UITextView, height: CGFloat)
    {
        // Set TextView height...
        self.cnTextViewHeight.constant = height > 35 ? height : 35
        
        // If TextView height is greater then 100 (TextView Max height should be 100)
        if self.cnTextViewHeight.constant > 100 {
            self.cnTextViewHeight.constant = 100
        }
        
        if textView.text.count < 1 || textView.text.isBlank {
            btnSend.isUserInteractionEnabled = false
            btnSend.alpha = 0.5
        }else {
            btnSend.isUserInteractionEnabled = true
            btnSend.alpha = 1
        }
        if viewUserSuggestion != nil && textView == txtViewComment{
            self.viewUserSuggestion.setAttributeStringInTextView(self.txtViewComment)
        }
    }
    
    func genericTextView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if viewUserSuggestion != nil {
            let strText = textView.text ?? ""
            if !strText.isEmpty && strText.count > range.location && viewUserSuggestion.isSearchString{
                let str = String(strText[range.location ... range.location])
                if text.isEmpty{
                    //viewUserSuggestion.searchString -= text
                }
                if str == "@" {
                    viewUserSuggestion.isSearchString = false
                    viewUserSuggestion.searchString = ""
                }
            }
            if viewUserSuggestion.isSearchString{
                viewUserSuggestion.searchString += text
            }
            if text == "@"{
                viewUserSuggestion.searchString = ""
                viewUserSuggestion.isSearchString = true
            }
            
            viewUserSuggestion.filterUser(textView, shouldChangeTextIn: range, replacementText: text)
        }
        
        return true
    }
}

// MARK:-  --------- UserSuggestionDelegate
extension ImageDetailViewController: UserSuggestionDelegate{
    func didSelectSuggestedUser(_ userInfo: [String : Any]) {
        viewUserSuggestion.arrangeFinalComment(userInfo, textView: txtViewComment)
    }
}

// MARK:-  --------- Action Event
extension ImageDetailViewController{
    @objc fileprivate func btnMenuClicked(_ sender : UIBarButtonItem) {
        
        if galleryInfo.valueForString(key: "user_email") == appDelegate.loginUser?.email{
            
            self.presentActionsheetWithOneButton(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CBtnDelete, btnOneStyle: .default) { [weak self] (_) in
                guard let _ = self else {return}
                DispatchQueue.main.async {
                    self?.deleteGalleryPost(self?.galleryInfo)
                }
            }
        }else {
            if let reportVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "ReportViewController") as? ReportViewController {
                reportVC.reportType = .reportGallery
                reportVC.userID = galleryInfo.valueForInt(key: CUserId)
                reportVC.reportID = self.imgPostId
                reportVC.reportIDNEW = galleryInfo.valueForString(key: "post_id")
                self.navigationController?.pushViewController(reportVC, animated: true)
            }
        }
    }
    
    @IBAction func btnLikeCLK(_ sender : UIButton){
        if sender.tag == 0{
        self.btnLike.isSelected = !self.btnLike.isSelected
        
        if self.btnLike.isSelected == true{
            likeCount = 1
            like = 1
            notifcationIsSlected = true
            
            if isLikesOthersPage  == true {
                if isLikeSelected == true{
                    self.isFinalLikeSelected = true
                    isLikeSelected = false
                }else {
                    self.isFinalLikeSelected = false
                }
            }
        }else {
            likeCount = 2
            like = 0
            
            if isLikesOthersPage == true {
                if isLikeSelected == false{
                    self.isFinalLikeSelected = false
                    isLikeSelected = false
                }else {
                    self.isFinalLikeSelected = false
                }
            }
        }
        guard let userID = appDelegate.loginUser?.user_id else {
            return
        }
        APIRequest.shared().likeUnlikeProducts(userId: Int(userID), productId: (self.imgPostIdNew)?.toInt ?? 0 , isLike: likeCount){ [weak self](response, error) in
            guard let _ = self else { return }
            if response != nil {
                GCDMainThread.async {
                    
                    let infodatass = response![CJsonData] as? [[String:Any]] ?? [[:]]
                    for infora in infodatass{
                        self?.info = infora
                    }
                    let data = response![CJsonMeta] as? [String:Any] ?? [:]
                    let stausLike = data["status"] as? String ?? "0"
                    if stausLike == "0" {
                        self?.likeCountfromSever(productId: self?.imgPostIdNew?.toInt ?? 0,likeCount:self?.likeCount ?? 0, postInfo: self?.info ?? [:],like:self?.like ?? 0)
                    }
                }
            }
        }
    }else{
        if let likeVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "LikeViewController") as? LikeViewController{
            //likeVC.postID = self.shoutID
            likeVC.postIDNew = self.imgPostIdNew
            self.navigationController?.pushViewController(likeVC, animated: true)
        }
    }
    }
    
    func likeCountfromSever(productId: Int,likeCount:Int,postInfo:[String:Any],like:Int){
        APIRequest.shared().likeUnlikeProductCount(productId: self.imgPostIdNew?.toInt ?? 0 ){ [weak self](response, error) in
            guard let _ = self else { return }
            if response != nil {
                GCDMainThread.async { [self] in
                    self?.likeTotalCount = response?["likes_count"] as? Int ?? 0
                    self?.btnLikeCount.setTitle(appDelegate.getLikeString(like: self?.likeTotalCount ?? 0), for: .normal)
                    
                    guard let user_ID = appDelegate.loginUser?.user_id.description else { return }
                    guard let firstName = appDelegate.loginUser?.first_name else {return}
                    guard let lastName = appDelegate.loginUser?.last_name else {return}
                    if self?.notifcationIsSlected == true{
                        if self?.posted_ID != user_ID {
                        if self?.isLikesOthersPage == true {
                            self?.notificationInfo["friend_liked"] = "Yes"
                        }
                        if self?.isLikesHomePage == true  || self?.isLikesMyprofilePage == true {
                            self?.notificationInfo["is_liked"] = "Yes"
                        }
                            self?.notificationInfo["likes"] = self?.likeTotalCount.toString
                            self?.notificationInfo["image"] = ""
                            MIGeneralsAPI.shared().sendNotification(self?.posted_ID, userID: user_ID, subject: "liked your Post", MsgType: "COMMENT", MsgSent: "", showDisplayContent: "liked your Post", senderName: firstName + lastName, post_ID: self?.notificationInfo ?? [:], shareLink: "shareLikes")
                        }
                        self?.notifcationIsSlected = false
                    }
                    
//                    MIGeneralsAPI.shared().likeUnlikePostWebsites(post_id: self?.imgPostIdNew?.toInt ?? 0, rss_id: 0, type: 1, likeStatus: self?.like ?? 0 ,info:postInfo, viewController: self)
                    
                    if self?.isLikesOthersPage == true {
                    if self?.isFinalLikeSelected == true{
                        MIGeneralsAPI.shared().likeUnlikePostWebsites(post_id:self?.imgPostIdNew?.toInt ?? 0, rss_id: 1, type: 1, likeStatus: self?.like ?? 0 ,info:postInfo, viewController: self)
                        self?.isLikeSelected = false
                    }else {
                        MIGeneralsAPI.shared().likeUnlikePostWebsites(post_id: self?.imgPostIdNew?.toInt ?? 0, rss_id: 2, type: 1, likeStatus: self?.like ?? 0 ,info:postInfo, viewController: self)

                    }
                   }
                    if  self?.isLikesHomePage == true || self?.isLikesMyprofilePage == true {
                    MIGeneralsAPI.shared().likeUnlikePostWebsites(post_id: self?.imgPostIdNew?.toInt ?? 0, rss_id: 3, type: 1, likeStatus: self?.like ?? 0 ,info:postInfo, viewController: self)
                    }
                    
                    
                    
                }
                
            }
        }
    }
    
    @IBAction func btnShareReportCLK(_ sender : UIButton){
        
        let sharePost = SharePostHelper(controller: self, dataSet: galleryInfo)
        sharePost.shareURL = galleryInfo.valueForString(key: CShare_url)
        sharePost.presentShareActivity()
    }
    
    @IBAction func btnCommentCLK(_ sender : UIButton) {
        if let commentVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "CommentViewController") as? CommentViewController{
            commentVC.postId = self.imgPostId
            self.navigationController?.pushViewController(commentVC, animated: true)
        }
    }
    
    @IBAction func btnSendCommentCLK(_ sender : UIButton) {
        self.resignKeyboard()
        
        if (txtViewComment.text?.isBlank)!{
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageCommentBlank, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }else{
            if let imgId = self.imgPostId{
                // Get Final text for comment..
                let strComment = viewUserSuggestion.stringToBeSendInComment(txtViewComment)
                
                // Get Mention user's Ids..
                let includedUser = viewUserSuggestion.arrSelectedUser.map({$0.valueForString(key: CUserId) }).joined(separator: ",")
                
                guard let userID = appDelegate.loginUser?.user_id else{return}
                let userId = userID.description
                APIRequest.shared().sendProductCommentnew(productId:imgId.description, commentId : self.editCommentId, comment: strComment, include_user_id: userId)  { [weak self] (response, error) in
                    
                    guard let self = self else { return }
                    if response != nil && error == nil  {
                        
                        self.viewUserSuggestion.hideSuggestionView(self.txtViewComment)
                        self.txtViewComment.text = ""
                        self.btnSend.isUserInteractionEnabled = false
                        self.btnSend.alpha = 0.5
                        self.txtViewComment.updatePlaceholderFrame(false)
                        
                        if let comment = response![CJsonData] as? [[String : Any]] {
                            
                            for comments in comment {
                                
                                self.commentinfo = comments
                                if (self.editCommentId ?? 0) == 0{
                                    
                                    self.getCommentListFromServer()
                                    let comment_data = comments["comments"] as? String
                                    self.commentCount = comment_data?.toInt ?? 0
                                    self.btnComment.setNormalTitle(normalTitle: appDelegate.getCommentCountString(comment: self.commentCount))
                                    MIGeneralsAPI.shared().refreshPostRelatedScreens(self.commentinfo, imgId, self, .commentPost, rss_id: 0)
                                }else{
                                    // Edit comment in array
                                    if let index = self.arrCommentList.index(where: { $0[CId] as? Int ==  (self.editCommentId ?? 0)}) {
                                        self.arrCommentList.remove(at: index)
                                        self.arrCommentList.insert(comments, at: 0)
                                        self.tblCommentList.reloadData()
                                    }
                                }
                            }
                            
                            let data = response![CJsonMeta] as? [String:Any] ?? [:]
                            guard let firstName = appDelegate.loginUser?.first_name else {return}
                            guard let lastName = appDelegate.loginUser?.last_name else {return}
                            let stausLike = data["status"] as? String ?? "0"
                            self.notificationInfo["image"] = ""
                            if self.posted_ID != userID.description{
                                MIGeneralsAPI.shared().sendNotification(self.posted_ID, userID: userId, subject: "Commented on your Post", MsgType: "COMMENT", MsgSent: "", showDisplayContent: "Commented on your Post" ,senderName: firstName + lastName, post_ID: self.notificationInfo,shareLink: "shareComment" )
                            }
                            self.genericTextViewDidChange(self.txtViewComment, height: 10)
                        }
                        self.editCommentId =  nil
                        //                        self.tblCommentList.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                        //self.lblNoData.isHidden = self.arrCommentList.count != 0
                    }
                }
            }
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadder"), object: nil)
        
    }
    
    func btnMoreOptionOfComment(index:Int){
        self.presentActionsheetWithTwoButtons(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CBtnEdit, btnOneStyle: .default, btnOneTapped: {[weak self] (_) in
            
            guard let self = self else {return}
            let commentInfo = self.arrCommentList[index]
            var commentText = commentInfo.valueForString(key: "comment")
            DispatchQueue.main.async {
                self.viewUserSuggestion.resetData()
                self.editCommentId = commentInfo.valueForInt(key: CId)
                if let arrIncludedUsers = commentInfo[CIncludeUserId] as? [[String : Any]] {
                    for userInfo in arrIncludedUsers {
                        let userName = userInfo.valueForString(key: CFirstname) + " " + userInfo.valueForString(key: CLastname)
                        commentText = commentText.replacingOccurrences(of: String(NSString(format: kMentionFriendStringFormate as NSString, userInfo.valueForString(key: CUserId))), with: userName)
                        self.viewUserSuggestion.addSelectedUser(user: userInfo)
                    }
                }
                self.txtViewComment.text = commentText
                self.viewUserSuggestion.setAttributeStringInTextView(self.txtViewComment)
                self.txtViewComment.updatePlaceholderFrame(true)
                let constraintRect = CGSize(width: self.txtViewComment.frame.size.width, height: .greatestFiniteMagnitude)
                let boundingBox = self.txtViewComment.text.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self.txtViewComment.font!], context: nil)
                self.genericTextViewDidChange(self.txtViewComment, height: ceil(boundingBox.height))
            }
            
        }, btnTwoTitle: CBtnDelete, btnTwoStyle: .default) { [weak self](_) in
            guard let _ = self else {return}
            DispatchQueue.main.async {
                self?.deleteComment(index)
            }
        }
    }
    
    func deleteComment(_ index:Int){
        
        let commentInfo = self.arrCommentList[index]
        let commentId = commentInfo.valueForString(key: "updated_at")
        let strComment = commentInfo.valueForString(key: "comment")
        
        guard let userID = appDelegate.loginUser?.user_id else{
            return
        }
        let userId = userID.description
        
        APIRequest.shared().deleteProductCommentNew(productId:imgPostIdNew ?? "", commentId : commentId, comment: strComment, include_user_id: userId)  { [weak self] (response, error) in
            guard let self = self else { return }
            if response != nil && error == nil {
                DispatchQueue.main.async {
                    self.arrCommentList.remove(at: index)
                    self.commentCount -= 1
                    if self.commentCount >= 0{
                        self.btnComment.setTitle(appDelegate.getCommentCountString(comment: self.commentCount), for: .normal)
                    }else {
                        return
                    }
                    self.tblCommentList.reloadData()
                    MIGeneralsAPI.shared().refreshPostRelatedScreens(nil,self.imgPostIdNew?.toInt ?? 0 , self, .deleteComment, rss_id: 0)
                }
            }
        }
    }
}


extension ImageDetailViewController {
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60), actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }
        
        return nil
    }
}

extension String{
    func convertToDictionarys() -> [[String: Any]]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
            } catch {
                //                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    
    
}
