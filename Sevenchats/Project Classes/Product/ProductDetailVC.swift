//
//  ProductDetailVC.swift
//  Sevenchats
//
//  Created by mac-00020 on 26/08/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : RestrictedFilesVC                           *
 * Changes :                                             *
 *                                                       *
 ********************************************************/

import Foundation
import ActiveLabel
import UIKit

class ProductDetailVC: ParentViewController {
    
    //MARK: - IBOutlet/Object/Variable Declaration
    @IBOutlet weak var tblProduct: UITableView!{
        didSet{
            tblProduct.estimatedRowHeight = 100;
            tblProduct.rowHeight = UITableView.automaticDimension;
            tblProduct.tableFooterView = UIView(frame: .zero)
            tblProduct.separatorStyle = .none
            tblProduct.delegate = self
            tblProduct.dataSource = self
            
            tblProduct.register(UINib(nibName: "CommentTblCell", bundle: nil), forCellReuseIdentifier: "CommentTblCell")
            tblProduct.register(UINib(nibName: "MakeAsSoldProduceCell", bundle: nil), forCellReuseIdentifier: "MakeAsSoldProduceCell")
            tblProduct.register(UINib(nibName: "ProductDetailCell", bundle: nil), forCellReuseIdentifier: "ProductDetailCell")
            tblProduct.register(UINib(nibName: "SellerInfoCell", bundle: nil), forCellReuseIdentifier: "SellerInfoCell")
            tblProduct.register(UINib(nibName: "AddReviewProductCell", bundle: nil), forCellReuseIdentifier: "AddReviewProductCell")
            tblProduct.register(UINib(nibName: "ReviewProductCell", bundle: nil), forCellReuseIdentifier: "ReviewProductCell")
            
        }
    }
    
    @IBOutlet fileprivate weak var viewCommentContainer : UIView!
    @IBOutlet fileprivate weak var btnSend : UIButton!
    @IBOutlet fileprivate weak var cnTextViewHeight : NSLayoutConstraint!
    @IBOutlet fileprivate weak var txtViewComment : GenericTextView!{
        didSet{
            txtViewComment.genericDelegate = self
            txtViewComment.PlaceHolderColor = ColorPlaceholder
            txtViewComment.placeHolder = CMessageTypeYourMessage
            txtViewComment.type = "1"
        }
    }
    
    @IBOutlet fileprivate weak var viewUserSuggestion : UserSuggestionView! {
        didSet {
            viewUserSuggestion.initialization()
            viewUserSuggestion.userSuggestionDelegate = self
        }
    }
    
    var arrProducts : [ProductBaseModel] = []
    var apiTask : URLSessionTask?
    var apiTaskCommentList : URLSessionTask?
    var arrMedia : [MDLAddMedia] = []
    var arrCommentList = [[String:Any]]()
    var arrUserForMention = [[String:Any]]()
    var arrFilterUser = [[String:Any]]()
    var likeCount = 0
    var commentCount = 0
    var productId = 0
    var productIds = ""
    var pageNumber = 1
    var product : MDLProduct?
    var editCommentId : Int? = nil
    var editComment : String? = ""
    var index_Row:Int?
    var VcController :Int? = nil
    var isEditBtnCLK = false
    var commentsInfo = [String:Any]()
    var productVC:Int?
    var productUserID = ""
    var ImgName = ""
    var productNotfi = [String:Any]()
    
    //MARK: - View life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        //self.addAddProduct()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func addAddProduct(){
        self.arrProducts.append(MDLProductReview())
        self.tblProduct.reloadData()
    }
    
    //MARK: - Memory management methods
    deinit {
        print("### deinit -> ProductDetailVC")
    }
}

//MARK: - SetupUI
extension ProductDetailVC {
    
    fileprivate func setupView() {
        
        self.title = product?.productTitle ?? ""
        addBarButtonItems()
        
        getProductDetail()
        getCommentListFromServer(showLoader: true)
    }
    
    fileprivate func addBarButtonItems() {
        
        let moreBarItem = BlockBarButtonItem(image: UIImage(named: "ic_btn_nav_more"), style: .plain) { [weak self] (_) in
            guard let _ = self else { return }
            DispatchQueue.main.async {
                if (self?.product?.userId.description == appDelegate.loginUser?.user_id.description){
                    self?.editDeleteProduct()
                }else{
                    self?.pushToProductReport()
                }
            }
        }
        self.navigationItem.rightBarButtonItem = moreBarItem
    }
    func pushToProductReport(){
        self.presentActionsheetWithOneButton(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CReport, btnOneStyle: .default) { [weak self] (alert) in
            guard let _ = self else { return }
            if let productReport : ProductReportVC = CStoryboardProduct.instantiateViewController(withIdentifier: "ProductReportVC") as? ProductReportVC{
                productReport.productId = self?.product?.id ?? 0
                self?.navigationController?.pushViewController(productReport, animated: true)
            }
        }
    }
    func editDeleteProduct(){
        //product
        self.presentActionsheetWithTwoButtons(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CBtnEdit, btnOneStyle: .default, btnOneTapped: { [weak self](alert) in
            guard let _ = self else { return }
            guard let addEditProduct = CStoryboardProduct.instantiateViewController(withIdentifier: "AddEditProductVC") as? AddEditProductVC else{
                return
            }
            addEditProduct.isEdit = "addEditProduct"
            addEditProduct.product = self?.product
            self?.navigationController?.pushViewController(addEditProduct, animated: true)
        }, btnTwoTitle: CBtnDelete, btnTwoStyle: .default) { [weak self](alert) in
            guard let _ = self else { return }
            self?.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CMessageDeleteProduct, btnOneTitle: CBtnYes, btnOneTapped: { [weak self] (alert) in
                guard let _ = self else { return }
                ProductHelper<UIViewController>.deleteProduct(
                    controller: self,
                    refreshCnt: [StoreListVC.self,ProductSearchVC.self],
                    productID: (self?.product?.id ?? 0),
                    isLoader: true
                )
            }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
        }
    }
    
    func updateOnMarkAsSold(available_status:String){
        self.product?.isSold = 2
        _ = product?.productID
        guard let userId = appDelegate.loginUser?.user_id else { return }
        let userID = userId.description
        arrMedia = product?.galleryImages ?? []
        guard let imgStr = product?.galleyimagesArray else {return}
        do {
            let data = try JSONEncoder().encode(imgStr)
            let jsonCnvstr = String(data: data, encoding: .utf8)!
            
            let rpl_Str1 = jsonCnvstr.replacingOccurrences(of: "\"[", with: "[")
            let rpl_Str2 = rpl_Str1.replacingOccurrences(of: "]\"", with: "]")
            let rep_Str3 = rpl_Str2.replacingOccurrences(of: "\\/", with: "/")
            ImgName = rep_Str3
            
        } catch { print(error) }
        
        var dict = [String:Any]()
        dict = [
            "product_id": product?.productID ?? "",
            "category_name":product?.category ?? "" ,
            "product_image":ImgName,
            "product_title":product?.productTitle ?? "",
            "description":product?.productDescription ?? "" ,
            "available_status":"2" ,
            "cost":product?.productPrice ?? "",
            "currency_name":self.product?.currencyName ?? "",
            "last_date_selling":product?.lastdateSelling ?? "",
            "location":product?.address ?? "",
            "latitude":"60",
            "longitude":"80",
            "status_id":"1",
            "city_name":product?.cityName ?? "",
            "address_line1":""
            
        ]
        
        if (userID ) != ""{
            dict["user_id"] = userID.description
        }
        
        dict["city_name"] = product?.cityName
        
        APIRequest.shared().productEditProduct(apiTag: CEditProductNew, dict:dict, showLoader: true) { [weak self] (response, error) in
            guard let self = self else { return }
            if response != nil && error == nil{
                var message = CProductHasBeenCreated
                if self.product != nil {
                    message = CProductHasBeenUpdate
                    let data = response![CData] as? [String : Any] ?? [:]
                    _ = MDLProduct(fromDictionary: data)
                    
                    ProductHelper<UIViewController>.updateProductData(product: self.product!, controller: self.viewController, refreshCnt: [StoreListVC.self, ProductSearchVC.self,MyProductListVC.self])
                    self.arrProducts = self.arrProducts.filter({$0.tpye != .MakeAsSoldProduceCell})
                    UIView.performWithoutAnimation {
                        self.tblProduct.reloadSections(IndexSet(integer: 0), with: .none)
                    }
                    
                    
                }else{
                    ProductHelper.createProduct(controller: self, refreshCnt: [StoreListVC.self])
                }
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func btnMoreOptionOfComment(index:Int){
        self.presentActionsheetWithTwoButtons(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CBtnEdit, btnOneStyle: .default, btnOneTapped: {[weak self] (_) in
            guard let self = self else {return}
            self.isEditBtnCLK = true
            let commentInfo = self.arrCommentList[index]
            self.commentsInfo = commentInfo
            
            self.index_Row = index
            var commentText = commentInfo.valueForString(key: "comment")
            DispatchQueue.main.async {
                self.viewUserSuggestion.resetData()
                self.editComment = commentInfo.valueForString(key: "user_id")
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
}

//MARK: - IBAction / Selector
extension ProductDetailVC {
    
    @IBAction func onSendCommentCLK(_ sender : UIButton){
        self.resignKeyboard()
        
        if (txtViewComment.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageCommentBlank, btnOneTitle: CBtnOk, btnOneTapped: nil)
        } else {
            addEditComment()
        }
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension ProductDetailVC : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if arrCommentList.isEmpty{
            return 1
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if product == nil{
            return 0
        }
        if section == 0{
            return arrProducts.count
        }
        return arrCommentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            
            let cellModel = self.arrProducts[indexPath.row]
            let cellIdentifier = cellModel.tpye.rawValue
            
            guard let customCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ProductDetailBaseCell else{
                return UITableViewCell(frame: .zero)
            }
            customCell.configure(withModel: cellModel)
            (customCell as! UITableViewCell).layoutIfNeeded()
            
            return customCell as! UITableViewCell
        }else{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTblCell", for: indexPath) as? CommentTblCell{
                let commentInfo = arrCommentList[indexPath.row]
                let timeStamp = DateFormatter.shared().getDateFromTimeStamp(timeStamp:commentInfo.valueForString(key: "updated_at").toDouble ?? 0.0)
                cell.lblCommentPostDate.text = timeStamp
                cell.lblUserName.text = commentInfo.valueForString(key: CFirstname) + " " + commentInfo.valueForString(key: CLastname)
                cell.imgUser.loadImageFromUrl(commentInfo.valueForString(key: CUserProfileImages), true)
                
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
                        
                        cell.lblCommentText.handleCustomTap(for: customTypeUserName, handler: { [weak self](name) in
                            guard let self = self else { return }
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
                    label.minimumLineHeight = 0
                    label.configureLinkAttribute = { [weak self] (type, attributes, isSelected) in
                        guard let _ = self else { return  attributes}
                        var atts = attributes
                        atts[NSAttributedString.Key.font] = CFontPoppins(size: cell.lblCommentText.font.pointSize, type: .meduim)
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
                
                cell.lblCommentText.text = commentText
                // Load more data....
                
                //                if (indexPath == tblProduct.lastIndexPath()) && apiTaskCommentList?.state != URLSessionTask.State.running {
                //                    self.getCommentListFromServer(showLoader: false)
                //                }
                return cell
            }
        }
        return tableView.tableViewDummyCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let header = EventCommentTblHeader.viewFromXib as? EventCommentTblHeader, section == 1{
            header.backgroundColor =  CRGB(r: 249, g: 250, b: 250)
            header.lblTitle.text = appDelegate.getCommentCountString(comment: self.product?.totalComments.toInt ?? 0)
            return header
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1{
            return 40
        }
        return 0
    }
}

// MARK:-  --------- Generic UITextView Delegate
extension ProductDetailVC: GenericTextViewDelegate{
    
    func genericTextViewDidChange(_ textView: UITextView, height: CGFloat) {
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
extension ProductDetailVC: UserSuggestionDelegate{
    func didSelectSuggestedUser(_ userInfo: [String : Any]) {
        viewUserSuggestion.arrangeFinalComment(userInfo, textView: txtViewComment)
    }
}

//MARK: - API Function
extension ProductDetailVC {
    
    func getProductDetail() {
        
        if apiTask?.state == URLSessionTask.State.running {
            return
        }
        guard let userId = appDelegate.loginUser?.user_id else {
            return
        }
        let userID = String(userId)
        var para = [String:Any]()
        para["user_id"] = userID
        para["product_id"] = self.productIds
        
        let _ = APIRequest.shared().getProductDetail(para:para,productID: self.productId,userID:userID, showLoader: true, completion:{ [weak self](response, error) in
            guard let self = self else { return }
            if response != nil {
                GCDMainThread.async {
                    guard let data = response?[CData] as? [[String:Any]] else {
                        return
                    }
                    for arrayData in data{
                        self.product = MDLProduct(fromDictionary: arrayData)
                        self.title = self.product?.productTitle ?? ""
                        self.arrProducts.append(self.product!)
                        self.commentCount = self.product?.totalComments.toInt ?? 0
                        let isMyProduct = (self.product!.userId.description == appDelegate.loginUser?.user_id.description)
                        
                        guard let emailID  = appDelegate.loginUser?.email else {return}
                        if self.product?.email == emailID {
                            if self.product?.productState == "1"{
                                self.arrProducts.append(MDLMarkAsSold(fromDictionary: arrayData))
                            }
                        } else {
                            self.arrProducts.append(MDLSellerInfo(fromDictionary: arrayData))
                        }
                    }
                    self.tblProduct.reloadData()
                }
            }else{
                MILoader.shared.hideLoader()
            }
        })
    }
    
    fileprivate func getCommentListFromServer(showLoader: Bool){
        
        if apiTaskCommentList?.state == URLSessionTask.State.running {
            return
        }
        // Add load more indicator here...
        self.tblProduct.tableFooterView = self.pageNumber > 2 ? self.loadMoreIndicator(ColorAppTheme) : UIView()
        
        self.arrCommentList.removeAll()
        apiTaskCommentList = APIRequest.shared().getProductCommentLists(page: pageNumber, showLoader: showLoader, productId: productIds) { [weak self] (response, error) in
            
            guard let self = self else { return }
            
            self.tblProduct.tableFooterView = UIView()
            self.apiTask?.cancel()
            if response != nil {
                
                if let arrList = response!["comments"] as? [[String:Any]] {
                    // Remove all data here when page number == 1
                    if self.pageNumber == 1 {
                        self.arrCommentList.removeAll()
                        self.tblProduct.reloadData()
                    }
                    // Add Data here...
                    if arrList.count > 0{
                        self.arrCommentList = self.arrCommentList + arrList
                        self.tblProduct.reloadData()
                        self.pageNumber += 1
                    }
                }
                print("arrCommentListCount : \(self.arrCommentList.count)")
                //self.lblNoData.isHidden = self.arrCommentList.count != 0
            }
        }
    }
    
    func addEditComment(){
        
        // Get Final text for comment..
        let strComment = viewUserSuggestion.stringToBeSendInComment(txtViewComment)
        // Get Mention user's Ids..
        let includedUser = viewUserSuggestion.arrSelectedUser.map({$0.valueForString(key: CUserId) }).joined(separator: ",")
        guard let userID = appDelegate.loginUser?.user_id else{
            return
        }
        let userId = userID.description
        
        APIRequest.shared().sendProductCommentnew(productId:productIds, commentId : self.editCommentId, comment: strComment, include_user_id: userId)  { [weak self] (response, error) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if response != nil && error == nil {
                    
                    self.viewUserSuggestion.hideSuggestionView(self.txtViewComment)
                    self.txtViewComment.text = ""
                    self.btnSend.isUserInteractionEnabled = false
                    self.btnSend.alpha = 0.5
                    self.txtViewComment.updatePlaceholderFrame(false)
                    if let comment = response!["meta"] as? [String : Any] {
                        if (comment["status"] as? String ?? "") == "0"{
                            if self.isEditBtnCLK == true {
                                self.arrCommentList.remove(at: self.index_Row ?? 0)
                                self.commentsInfo["comment"] = strComment
                                self.arrCommentList.insert(self.commentsInfo, at: self.index_Row ?? 0)
                                self.tblProduct.reloadData()
                                UIView.performWithoutAnimation {
                                    let indexPath = IndexPath(item: self.index_Row ?? 0, section: 1)
                                    if (self.tblProduct.indexPathsForVisibleRows?.contains(indexPath))!{
                                        self.tblProduct.reloadRows(at: [indexPath], with: .none)
                                    }
                                }
                                self.isEditBtnCLK = false
                            }else {
                                var productCount = self.product?.totalComments.toInt ?? 0
                                productCount += 1
                                self.product?.totalComments = productCount.toString
                                self.getCommentListFromServer(showLoader: true)
                                ProductHelper<UIViewController>.updateProductDatacomments(product: self.product!,totalComment:productCount.toString, controller: self, refreshCnt: [StoreListVC.self, ProductSearchVC.self])
                                self.isEditBtnCLK = false
                            }
                        }
                        self.genericTextViewDidChange(self.txtViewComment, height: 10)
                    }
                    let data = response![CJsonMeta] as? [String:Any] ?? [:]
                    guard let userID = appDelegate.loginUser?.user_id else{return}
                    guard let firstName = appDelegate.loginUser?.first_name else {return}
                    guard let lastName = appDelegate.loginUser?.last_name else {return}
                    let stausLike = data["status"] as? String ?? "0"
                    if stausLike == "0" {
                       
                    }
                    
                    self.productNotfi["type"] = "productDetails"
                    self.productNotfi["product_id"] = self.product?.productID
                    self.productNotfi["productUserID"] = self.product?.productUserID
                    
                    MIGeneralsAPI.shared().sendNotification(self.productUserID, userID: userID.description, subject: "Commented on your Product", MsgType: "COMMENT", MsgSent: "", showDisplayContent: "Commented on your Product", senderName: firstName + lastName, post_ID: self.productNotfi)
                    self.editCommentId =  nil
                    //self.tblProduct.scrollToRow(at: IndexPath(row: 0, section: 1), at: .top, animated: false)
                    //self.lblNoData.isHidden = self.arrCommentList.count != 0
                }
            }
        }
    }
    func deleteComment(_ index:Int){
        
        let commentInfo = self.arrCommentList[index]
        let commentId = commentInfo.valueForString(key: "updated_at")
        let strComment = commentInfo.valueForString(key: "comment")
        
        guard let userID = appDelegate.loginUser?.user_id else{return}
        let userId = userID.description
        APIRequest.shared().deleteProductCommentNew(productId:productIds, commentId : commentId, comment: strComment, include_user_id: userId)  { [weak self] (response, error) in
            guard let self = self else { return }
            if response != nil && error == nil {
                DispatchQueue.main.async {
                    self.arrCommentList.remove(at: index)
                    var productCount = self.product?.totalComments.toInt ?? 0
                    productCount -= 1
                    self.product?.totalComments = productCount.toString
                    self.tblProduct.reloadData()
                    ProductHelper<UIViewController>.updateProductDatacomments(product: self.product!,totalComment:productCount.toString, controller: self, refreshCnt: [StoreListVC.self, ProductSearchVC.self])
                }
            }
        }
    }
}

