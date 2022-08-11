//
//  ReportViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 18/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : ReportViewController                        *
 * Changes :                                             *

 ********************************************************/

import UIKit

let kReportType = "type"
let kReportId = "reportId"
let kReportIdN = "report_id"

//give report from, It should be 1, 2, 3, 4, 5, 6, 7, 8 (1-article,2-gallery,3-chripy,4-shout,5-forum,6-event,7-user, 8-rss).[ mandatory field ]

enum ReportType : Int {
    case reportArticle = 1
    case reportGallery = 2
    case reportChirpy = 3
    case reportShout = 4
    case reportForum = 5
    case reportEvent = 6
    case reportUser = 7
    case reportRss = 8
    case reportGroup = 9
    case reportPoll = 10
    case reportSharedPost = 11
}

protocol SecondVCDelegate: class {
    func didSelectData(_ result: String)
}


class ReportViewController: ParentViewController {
    
    @IBOutlet var cnTblHeight : NSLayoutConstraint!
    @IBOutlet var tblReport : UITableView!
    @IBOutlet var viewAddImageContainer : UIView!
    @IBOutlet var viewUploadedImageContainer : UIView!
    @IBOutlet var imgArticle : UIImageView!
    @IBOutlet var textViewReportMessage : GenericTextView!{
        didSet{
            self.textViewReportMessage.txtDelegate = self
            self.textViewReportMessage.type = "1"
        }
    }
    @IBOutlet var lblUploadImg : UILabel!
    
    
    var reportType : ReportType?
    
    var selectedIndexPath : IndexPath!
    var reportID : Int?
    var post_id : String?
    var reportIDNEW : String?
    var userID : Int?
    var groupID : Int?
    var reportedURL : String?
    var reportedUrl : String?
    var arrReport : [[String:Any]] = []
    var isSharedPost = false
    var imgName = ""
    var uploadImgUrl = ""
    var postContent = ""
    weak var delegate: SecondVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Initialization()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:-  ---------- Initialization
    func Initialization(){
        
        lblUploadImg.text = CUploadImage
        self.textViewReportMessage.placeHolder = CPlaceholderWriteYourMessageHere
        
        switch reportType {
        case .reportArticle?:
            self.title = CReportArticles
        case .reportGallery?:
            self.title = CReportGallery
        case .reportChirpy?:
            self.title = CReportChirpy
        case .reportShout?:
            self.title = CReportShout
        case .reportForum?:
            self.title = CReportForum
        case .reportEvent?:
            self.title = CReportEvent
        case .reportUser?:
            self.title = CNavReportUser
        case .reportGroup?:
            self.title = CNavReportGroup
        case .reportPoll?:
            self.title = CNavReportPoll
        case .reportSharedPost?:
            self.title = CReportSharePost
        default:
            self.title = CSideFavWebSites
        }
        
        switch reportType {
        case .reportUser?:
            arrReport = [[kReportType : CMessageReportInappropriateBehavior, kReportId : 1],[kReportType : CMessageReportLookLikeSpamUser, kReportId : 2],[kReportType : CMessageReportOthers, kReportId : 4]]
            break
        case .reportGroup?:
            arrReport = [[kReportType : CMessageReportInappropriateBehavior, kReportId : 1],[kReportType : CMessageReportLookLikeSpamUser, kReportId : 2],[kReportType : CMessageReportOthers, kReportId : 4]]
            break
        default:
            arrReport = [[kReportType : CMessageReportLookLikeSpamUser, kReportId : 2],[kReportType : CMessageReportAbusiveLanguage, kReportId : 3],[kReportType : CMessageReportOthers, kReportId : 4]]
            break
        }
        
        
        viewUploadedImageContainer.isHidden = true
//        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: #imageLiteral(resourceName: "ic_add_post"), style: .plain, target: self, action: #selector(btnAddReportClicked(_:)))]
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: #imageLiteral(resourceName: "ic_info_tint"), style: .plain, target: self, action: #selector(btnHelpInfoClicked(_:))),UIBarButtonItem(image: #imageLiteral(resourceName: "ic_add_post"), style: .plain, target: self, action: #selector(btnAddReportClicked(_:)))]
        
        if #available(iOS 11.0, *) {
            tblReport.performBatchUpdates({
                self.cnTblHeight.constant = self.tblReport.contentSize.height
                GCDMainThread.async {
                    self.textViewReportMessage.updateBottomLineAndPlaceholderFrame()
                }
            }) { (completed) in
                self.cnTblHeight.constant = self.tblReport.contentSize.height
                GCDMainThread.async {
                    self.textViewReportMessage.updateBottomLineAndPlaceholderFrame()
                }
            }
        } else {
            // Fallback on earlier versions
            GCDMainThread.async {
                self.cnTblHeight.constant = self.tblReport.contentSize.height
                
                GCDMainThread.async {
                    self.textViewReportMessage.updateBottomLineAndPlaceholderFrame()
                }
            }
            
        }
    }
    @objc fileprivate func btnHelpInfoClicked(_ sender : UIBarButtonItem){
        if let helpLineVC = CStoryboardHelpLine.instantiateViewController(withIdentifier: "HelpLineViewController") as? HelpLineViewController {
            helpLineVC.fromVC = "reportVC"
            self.navigationController?.pushViewController(helpLineVC, animated: true)
        }
        
    }
    
}
// MARK:- --------- Api Functions
extension ReportViewController{
    func reportApi(){
        
        var para = [String : Any]()
        
        let reportInfo = arrReport[selectedIndexPath.row]
       // para[CReportType] = reportInfo.valueForInt(key: kReportId)
        para[CReportType] = reportInfo.valueForString(key: kReportId)
        para[CReportNote] = textViewReportMessage.text
        
      
        var reportFrom = 0
        switch reportType {
        case .reportArticle?:
            reportFrom = 1
        case .reportGallery?:
            reportFrom = 2
        case .reportChirpy?:
            reportFrom = 3
        case .reportShout?:
            reportFrom = 4
        case .reportForum?:
            reportFrom = 5
        case .reportEvent?:
            reportFrom = 6
        case .reportUser?:
            reportFrom = 7
        case .reportGroup?:
            reportFrom = 9
        case .reportPoll?:
            reportFrom = 10
        default:
            reportFrom = 8
        }
        if isSharedPost{
            reportFrom = 11
        }
        para[CReportFrom] = reportFrom
        
        // Report Group
        if self.groupID != nil {
            para[CGroupId] = self.groupID
        }
        
        // Report User
        if self.userID != nil {
            para[CUserId] = self.userID
        }
        
        // Report Website
        if self.reportedURL != nil {
            para[CReportedUrl] = self.reportedURL
        }
        
        // Report POST
        if self.reportID != nil {
            para[CPostId] = self.reportID
        }
        
//        guard let userEmailID = appDelegate.loginUser?.email else {return }
        guard let status_id = appDelegate.loginUser?.status_id else { return }
        guard let user_id = appDelegate.loginUser?.user_id else { return }
        let userID = user_id.description

        let reportedurl = reportedURL ?? ""
        let reportTxt = textViewReportMessage.text?.replace_str(replace: textViewReportMessage.text ?? "")
       // let reportTxt = textViewReportMessage.text.replace(string: "\n", replacement: "\\n")
//        var dict :[String:Any]  =  [
//               "image":uploadImgUrl,
//               "reason":reportTxt,
//               "reported_user":reportIDNEW ?? "",
//               "reporter_user":userID,
//               "category":reportInfo.valueForString(key: kReportType),
//               "url":reportedurl as Any,
//               "status_id":status_id
//        ]
        let encryptUser = EncryptDecrypt.shared().encryptDecryptModel(userResultStr: userID ?? "")
        var dict :[String:Any]  =  [
        "reporter_user_id": encryptUser,
           "reported_id": reportIDNEW ?? "",
           "image": uploadImgUrl,
           "reason": reportTxt,
           "category": reportInfo.valueForString(key: kReportType),
           "url": reportedurl as Any,
           "status_id": status_id
        ]
//        if post_id == nil{
//           dict["element_id"] = reportIDNEW ?? ""
//        }else{
//            dict["element_id"] = post_id ?? ""
//        }
        APIRequest.shared().reportPostUserRSS(para: dict, image: imgArticle.image) { (response, error) in
           
        if response != nil {

//            DispatchQueue.main.async {
                
                switch self.reportType {
                case .reportUser?:
                    // Remove all user related post from previous screen
                    MIGeneralsAPI.shared().refreshPostRelatedScreens(nil, nil, self, .addPost, rss_id: 0)
                case .reportRss?:
                    // Remove website from previous screen
                    MIGeneralsAPI.shared().refreshWebSiteScreens(nil, nil, self,  .reportPost)
                default:
                    // Remove post from previous screen
                    MIGeneralsAPI.shared().refreshPostRelatedScreens(nil, self.reportID, self, .reportPost, rss_id: 0)
                }

                // Notify to previous screen.
                if let completionBlock = self.block {
                    completionBlock(nil, "")
                }

                self.redirectToPreviousScreen()
                 let metaInfo = response![CJsonMeta] as? [String : Any]
                print("::::::::::::::::metaInfo\(metaInfo)")
                if metaInfo?.valueForString(key: "status") == "0"{
                    CTopMostViewController.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageReport, btnOneTitle: CBtnOk, btnOneTapped: nil)
                }
                
//            }
          
  
        }
            self.redirectToPreviousScreen()
            guard  let errorUserinfo = error?.userInfo["error"] as? String else {return}
            let errorMsg = errorUserinfo.stringAfter(":")
            if error != nil{
                CTopMostViewController.presentAlertViewWithOneButton(alertTitle: "", alertMessage: errorMsg, btnOneTitle: CBtnOk, btnOneTapped: nil)
               // self.navigationController?.popViewController(animated: true)

            }
    }
        
        
    }
    
}

// MARK:- --------- Navigation
extension ReportViewController {
    fileprivate func redirectToPreviousScreen() {
        
        if let arrViewControllers = self.navigationController?.viewControllers {
            if arrViewControllers.contains(where: {return $0 is OtherUserProfileViewController}) {
                // Move on Other user profile screen...
                if let index = arrViewControllers.firstIndex(where: {return $0 is OtherUserProfileViewController}) {
                    let otherProfileVC = arrViewControllers[index] as? OtherUserProfileViewController
                    self.navigationController?.popToViewController(otherProfileVC!, animated: true)
                }
            }else if arrViewControllers.contains(where: {return $0 is HomeSearchViewController}) {
                // Move on Home search screen...
                if let index = arrViewControllers.firstIndex(where: {return $0 is HomeSearchViewController}) {
                    let homeSearchVC = arrViewControllers[index] as? HomeSearchViewController
                    self.navigationController?.popToViewController(homeSearchVC!, animated: true)
                }
            }else if arrViewControllers.contains(where: {return $0 is HomeViewController}) {
                // Move on Home screen...
                if let index = arrViewControllers.firstIndex(where: {return $0 is HomeViewController}) {
                    let homeVC = arrViewControllers[index] as? HomeViewController
                    self.navigationController?.popToViewController(homeVC!, animated: true)
                }
            }else {
                
                self.navigationController?.popViewController(animated: true)
                
            }
        }else {
        
            self.navigationController?.popViewController(animated: true)
           
        }
    }
}

// MARK:- --------- UITableView Datasources/Delegate
extension ReportViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrReport.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ReportTblCell", for: indexPath) as? ReportTblCell {
            let reportInfo = arrReport[indexPath.row]
            cell.lblReport.text = reportInfo.valueForString(key: kReportType)
            cell.btnCheck.isSelected = selectedIndexPath == indexPath
            
            return cell
        }
        
        return tableView.tableViewDummyCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedIndexPath == indexPath{
            selectedIndexPath = nil
        }else{
            selectedIndexPath = indexPath
        }
        
        tblReport.reloadData()
    }
    
}

// MARK:- --------- Action Event
extension ReportViewController{
    @objc fileprivate func btnAddReportClicked(_ sender : UIBarButtonItem) {
        
        if selectedIndexPath == nil{
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageSelectReportReason, btnOneTitle: CBtnOk, btnOneTapped: nil)
            return
        }
        
//        if (textViewReportMessage.text?.isBlank)! && selectedIndexPath.row == 3 {
            if (textViewReportMessage.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageReportContent, btnOneTitle: CBtnOk, btnOneTapped: nil)
//        }else if(imgArticle.image == nil) {
//            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CNavAddImage, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }else{

            
            var strMessage = ""
            if reportType == ReportType.reportUser{
                strMessage = CMessageReportConfirmation
            }else if reportType == ReportType.reportGroup{
                strMessage = CMessageReportGroup
            }else if reportType == ReportType.reportRss{
                strMessage = CReportFavWebSite
            }else{
                strMessage = CAreYouSureToReportThisPost
            }
            
            self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: strMessage, btnOneTitle: CBtnYes, btnOneTapped: { (alert) in
                self.reportApi()
//                let charSet = CharacterSet.init(charactersIn: SPECIALCHARNOTALLOWED)
//                if (self.textViewReportMessage.text?.rangeOfCharacter(from: charSet) != nil) {
//                        print("true")
//                    self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageSpecial, btnOneTitle: CBtnOk, btnOneTapped: nil)
//                        return
//                }else{
//                    self.reportApi()
//                }
//                if self.textViewReportMessage.text != ""{
//                    let characterset = CharacterSet(charactersIn:SPECIALCHAR)
//                    if self.textViewReportMessage.text?.rangeOfCharacter(from: characterset.inverted) != nil {
//                        print("contains Special charecter")
//                        self.postContent = self.removeSpecialCharacters(from: self.textViewReportMessage.text ?? "")
//                        self.reportApi()
//                    } else {
//                       print("false")
//                        self.postContent = self.textViewReportMessage.text ?? ""
//                        self.reportApi()
//                    }
//                }
             
            }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
        }
    }
    
    @IBAction func btnUplaodImageCLK(_ sender : UIButton){
        self.presentImagePickerController(allowEditing: false) { (image, info) in
            if image != nil{
                self.imgArticle.image = image
                self.viewAddImageContainer.isHidden = true
                self.viewUploadedImageContainer.isHidden = false
                guard let imageURL = info?[UIImagePickerController.InfoKey.imageURL] as? NSURL else {
                    return
                }
                self.imgName = imageURL.absoluteString ?? ""
                guard let mobileNum = appDelegate.loginUser?.mobile else { return}
                MInioimageupload.shared().uploadMinioimages(mobileNo: mobileNum, ImageSTt: image!,isFrom:"",uploadFrom:"")
                MInioimageupload.shared().callback = { message in
                print("UploadImage::::::::::::::\(message)")
                self.uploadImgUrl = message
                }
                
                if self.uploadImgUrl.isEmpty{
                    MILoader.shared.hideLoader()
                }
            }
        }
    }
    
    @IBAction func btnDeleteImageCLK(_ sender : UIButton){
        viewUploadedImageContainer.isHidden = true
        viewAddImageContainer.isHidden = false
        imgArticle.image = nil
    }
}

extension ReportViewController: GenericTextViewDelegate{
    
    func genericTextViewDidChange(_ textView: UITextView, height: CGFloat){
        
        if textView == textViewReportMessage{
            //            lblTextCount.text = "\(textView.text.count)/\(txtViewArticleContent.textLimit ?? "0")"
        }
    }

}
extension ReportViewController{
    
    func removeSpecialCharacters(from text: String) -> String {
        let okayChars = CharacterSet(charactersIn: SPECIALCHAR)
        return String(text.unicodeScalars.filter { okayChars.contains($0) || $0.properties.isEmoji })
    }
    
    
}
