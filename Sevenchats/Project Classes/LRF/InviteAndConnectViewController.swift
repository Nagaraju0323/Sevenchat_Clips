////
////  InviteAndConnectViewController.swift
////  Sevenchats
////
////  Created by mac-0005 on 08/08/18.
////  Copyright © 2018 mac-0005. All rights reserved.
////
//
//import UIKit
//import FBSDKCoreKit
//import ContactsUI
//import PhoneNumberKit
//
//class InviteAndConnectViewController: ParentViewController, UITableViewDelegate, UITableViewDataSource {
//
//    private let phoneNumberKit = PhoneNumberKit()
//    @IBOutlet var viewButtonSeparator : UIView!
//    @IBOutlet var tblFriend : UITableView!
//    @IBOutlet var viewSearchBar : UIView!
//    @IBOutlet var btnSearch : UIButton!
//    @IBOutlet var btnCancel : UIButton!
//    @IBOutlet var txtSearch : UITextField!{
//        didSet{
//            txtSearch.returnKeyType = .search
//        }
//    }
//    @IBOutlet var lblTitle : UILabel!
//    @IBOutlet var btnSideMenu : UIButton!
//    @IBOutlet var btnBigDone : UIButton! {
//        didSet {
//            btnBigDone.isUserInteractionEnabled = false
//            btnBigDone.alpha = 0.5
//        }
//    }
//    @IBOutlet weak var btnSmallDone : UIButton! {
//        didSet {
//            btnSmallDone.isUserInteractionEnabled = false
//            btnSmallDone.alpha = 0.5
//        }
//    }
//
//    @IBOutlet var viewButtonView : UIView!
//
//    @IBOutlet var cnNavigationHeight : NSLayoutConstraint!
//    @IBOutlet var btnSkip : UIButton!
//    var isFromSideMenu : Bool!
//    var arrFriendList : [Any] = [] {
//        didSet{
//            self.arrSearchFriendList = arrFriendList
//            manageSorting()
//        }
//    }
//    var arrSyncUser = [[String : Any]]()
//    var arrConnectAllFriend = [[String : Any]]()
//    var arrSearchFriendList = [Any]()
//    var arrPhoneList = [[String : Any]?]()
//    var arrTempList = [[String:Any]]()
//
//    var selectedType = 1
//    var twitterCursor = "-1"
//    //var isSearch : Bool = false
//    var apiTask : URLSessionTask?
//    var arrphoneNo : [MDLInivte] = []
//    var arrListModel = [MDLUsers]()
//    var Friend_status = 0
//    var Check_status :Int?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.Initialization()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.updateUIAccordingToLanguage()
//    }
//    deinit {
//        print("Deinit -> InviteViewController")
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//         super.viewWillDisappear(true)
//         tblFriend.removeFromSuperview()
//     }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
//
//    // MARK:- --------- Initialization
//    func Initialization(){
//        //self.title = CNavInviteContact
//        lblTitle.text = CInviteConnectTitle
//        if isFromSideMenu{
//            btnSideMenu.isHidden = false
//            btnBigDone.isHidden = true
//            btnSmallDone.isHidden = true
//            btnSkip.isHidden = true
//            viewButtonSeparator.isHidden = true
//        }else{
//            btnSideMenu.isHidden = true
//            btnBigDone.isHidden = true
//            btnSmallDone.isHidden = false
//            btnSkip.isHidden = false
//            viewButtonSeparator.isHidden = false
//        }
//
//
//        tblFriend.register(UINib(nibName: "ConnectAllHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "ConnectAllHeaderView")
//        tblFriend.register(UINib(nibName: "InviteSectionCell", bundle: nil), forCellReuseIdentifier: "InviteSectionCell")
//        tblFriend.register(UINib(nibName: "EmptyInviteFriendCell", bundle: nil), forCellReuseIdentifier: "EmptyInviteFriendCell")
//        tblFriend.register(UINib(nibName: "InviteFriendCell", bundle: nil), forCellReuseIdentifier: "InviteFriendCell")
//        tblFriend.tableFooterView = UIView()
//        tblFriend.delegate = self
//        tblFriend.dataSource = self
//        tblFriend.reloadData()
//        self.btnSearch.isHidden = true
//        self.viewButtonView.isHidden = true
//
//        cnNavigationHeight.constant = IS_iPhone_X_Series ? 84 : 64
//        GCDMainThread.async {
//            self.viewSearchBar.layer.cornerRadius = self.viewSearchBar.frame.size.height/2
//        }
//    }
//
//    func updateUIAccordingToLanguage(){
//
//        if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
//            // Reverse Flow...
//            btnSideMenu.isSelected = true
//            btnSearch.contentHorizontalAlignment = .left
//        }else{
//            // Normal Flow...
//            btnSideMenu.isSelected = false
//            btnSearch.contentHorizontalAlignment = .right
//        }
//    }
//
//    func manageSorting() {
//
//        arrSearchFriendList = (arrSearchFriendList as? [CNContact])?.sorted(by: { (Obj1, Obj2) -> Bool in
//
//            let Obj1_Name: String = Obj1.givenName.lowercased().trim + Obj1.familyName.lowercased().trim
//            let Obj2_Name: String = Obj2.givenName.lowercased().trim + Obj2.familyName.lowercased().trim
//
//            return (Obj1_Name.localizedCaseInsensitiveCompare(Obj2_Name) == .orderedAscending)
//        }) ?? []
//        tblFriend.reloadData()
//    }
//}
//
//// MARK:- --------- Api Functions
//extension InviteAndConnectViewController{
//    func friendStatusApi( _ userid : String?,  _ status : Int?){
//        let friend_ID = userid
//        guard let user_ID = appDelegate.loginUser?.user_id else { return }
//
//        let dict :[String:Any]  =  [
//            "user_id":  user_ID.description,
//            "friend_user_id": friend_ID as Any,
//            "request_type": status?.toString as Any
//        ]
//
//        APIRequest.shared().friendRquestStatus(dict: dict, completion: { [weak self] (response, error) in
//            guard let self = self else { return }
//            if response != nil{
//
//                if let metaData = response?.value(forKey: CJsonMeta) as? [String : AnyObject] {
//                    if  metaData.valueForString(key: "message") == "Request sent successfully"{
//                        guard let user_ID =  appDelegate.loginUser?.user_id.description else { return}
//                        guard let firstName = appDelegate.loginUser?.first_name else {return}
//                        guard let lastName = appDelegate.loginUser?.last_name else {return}
//                        MIGeneralsAPI.shared().sendNotification(userid ?? "", userID: user_ID.description, subject: "send you a Friends Request", MsgType: "FRIEND_REQUEST", MsgSent:"", showDisplayContent: "send you a Friends Request", senderName: firstName + lastName, post_ID:dict,shareLink: "sendFrdRequestLink")
//                    }
//                }
//            }
//        })
//    }
//
//    func connectAllFriend(_ isSignup : Bool){
//
//        var arrSocialID = arrConnectAllFriend.map({$0.valueForString(key: CUserId) })
//        arrSocialID = arrSocialID.removeDuplicates()
//        let socialIDS = arrSocialID.joined(separator: ",")
//
//        if !socialIDS.isBlank{
//
//        }
//    }
//
//}
//// MARK:- --------- Get friend from social
//extension InviteAndConnectViewController{
//
//    func getFBFriendList() {
//
//        arrFriendList.removeAll()
//        tblFriend.reloadData()
//
//        MISocial.shared().facebookFriendList(fromVC: self) { (response, error) in
//
//            //print("Response :",response)
//        }
//
//        return
//    }
//
//    // Fetch contact from local......
//    func fetchTwitterList() {
//    }
//
//    func parseNumber(_ number: String) ->String? {
//        do {
//            let phoneNumber = try self.phoneNumberKit.parse(number)
//            var internationNumber = self.phoneNumberKit.format(phoneNumber, toType: .international)
//            internationNumber = internationNumber.replacingOccurrences(of: String(phoneNumber.countryCode), with: "")
//            internationNumber = internationNumber.replacingOccurrences(of: "(", with: "")
//            internationNumber = internationNumber.replacingOccurrences(of: " ", with: "")
//            internationNumber = internationNumber.replacingOccurrences(of: ")", with: "")
//            internationNumber = internationNumber.replacingOccurrences(of: "-", with: "")
//            internationNumber = internationNumber.replacingOccurrences(of: "+", with: "")
//            return internationNumber
//        } catch {
//            //print("Number is not valid === ")
//            var phoneNumber = number.replacingOccurrences(of: "(", with: "")
//            phoneNumber = phoneNumber.replacingOccurrences(of: " ", with: "")
//            phoneNumber = phoneNumber.replacingOccurrences(of: ")", with: "")
//            phoneNumber = phoneNumber.replacingOccurrences(of: "-", with: "")
//            phoneNumber = phoneNumber.replacingOccurrences(of: "+", with: "")
//            return phoneNumber
//        }
//    }
//
//    // Fetch contact from local......
//    func fetchLocalContact()
//    {
//        MIPhoneContacts.shared().getContacts { (results) in
//            if results.count > 0 {
//                if self.selectedType == 3 {
//                    var arrPhoneNumbers = [String?]()
//                    for contactInfo in results {
//                        if !(contactInfo?.phoneNumbers.isEmpty ?? true) {
//                            //                        arrPhoneNumbers.append(contactInfo?.phoneNumbers[0].value.stringValue)
//
//                            if let number = contactInfo?.phoneNumbers[0].value.stringValue,
//                               let finalNumber = self.parseNumber(number) {
//                                arrPhoneNumbers.append(finalNumber)
//                            }
//
//                        }else {
//                            arrPhoneNumbers.append("0000000000")
//                        }
//                    }
//
//                    var phoneNumber = (arrPhoneNumbers as? Array)!.joined(separator: ",")
//                    phoneNumber = phoneNumber.replacingOccurrences(of: "(", with: "")
//                    phoneNumber = phoneNumber.replacingOccurrences(of: " ", with: "")
//                    phoneNumber = phoneNumber.replacingOccurrences(of: ")", with: "")
//                    phoneNumber = phoneNumber.replacingOccurrences(of: "-", with: "")
//                    phoneNumber = phoneNumber.replacingOccurrences(of: "+", with: "")
//                    phoneNumber = phoneNumber.replacingOccurrences(of: ".", with: "")
//
//                    MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: CMessagePleaseWait)
//                    //self.activityIndicatorView.isHidden = false
//                    //self.activityIndicatorView.startAnimating()
//                    let fullNameArr = phoneNumber.components(separatedBy: ",")
//
//                    let strArr = fullNameArr.map { String($0)}
//                    strArr.forEach { mobileNumber in
//                        print(mobileNumber)
//
//                        let dict:[String:Any] = [
//                            CMobile : mobileNumber
//                        ]
//
//                        APIRequest.shared().inviteAndconnect(para: dict as [String : AnyObject]) { (response, error) in
//                            if response != nil && error == nil {
//                                if let metaInfo = response![CJsonMeta] as? [String:Any]{
//                                    let status =  metaInfo["status"] as? String ?? ""
//                                    if status == "1"{
//                                        //                                                self.Check_status = 1
//                                        if let arrData = response?.value(forKey: CJsonData) as? [[String : AnyObject]] {
//                                            self.arrPhoneList =  arrData
//                                            for arr in arrData{
//                                                //                                                        self.arrListModel.append(MDLUsers(fromDictionary: arr))
//                                            }
//                                            print("arrData\(arrData)")
//                                            //                                                    self.Check_status = 1
//                                            self.arrPhoneList += self.arrTempList
//                                            self.btnSearch.isHidden = false
//                                            self.arrSyncUser = arrData
//                                            self.arrFriendList = results as [Any]
//                                            self.tblFriend.reloadData()
//                                            self.checkConnectAllFriendStatus()
//                                        }else {
//                                            self.arrPhoneList += self.arrTempList
//                                            self.btnSearch.isHidden = false
//                                            //                                                      self.arrSyncUser = arrData
//                                            self.arrFriendList = results as [Any]
//                                            self.tblFriend.reloadData()
//                                            self.checkConnectAllFriendStatus()
//                                        }
//                                    }else {
//                                        self.arrPhoneList += self.arrTempList
//                                        self.btnSearch.isHidden = false
//                                        //                                                      self.arrSyncUser = arrData
//                                        self.arrFriendList = results as [Any]
//                                        self.tblFriend.reloadData()
//                                        self.checkConnectAllFriendStatus()
//                                    }
//                                }
//                            }else{
//                                self.btnSearch.isHidden = true
//                            }
//                        }
//                    }
//                }
//            }else{
//                self.checkConnectAllFriendStatus()
//                self.btnSearch.isHidden = true
//            }
//        }
//    }
//}
//
//
//// MARK:- --------- UITextField Delegate -
//
//extension InviteAndConnectViewController: UITextFieldDelegate {
//
//    @IBAction func textFieldDidChanged(textField: UITextField) {
//
//        if textField.text?.isEmpty ?? true {
//            //isSearch = false
//            arrSearchFriendList = arrFriendList
//            manageSorting()
//
//        } else {
//            //isSearch = true
//            arrSearchFriendList.removeAll()
//
//            switch(selectedType){
//            case 1,2: //Facebook, Twitter
//                arrSearchFriendList =  (arrFriendList as? [[String: AnyObject]])?.filter({($0["name"] as? String)?.range(of: textField.text ?? "", options: [.caseInsensitive]) != nil }) ?? []
//            //                manageSorting()
//
//            case 3: // PhoneBook
//                arrSearchFriendList = (arrFriendList as? [CNContact])?.filter({
//                                                                                ($0.givenName.trim).range(of: textField.text ?? "", options: [.caseInsensitive]) != nil || ($0.familyName.trim).range(of:  textField.text ?? "", options: [.caseInsensitive]) != nil}) ?? []
//
//                // Now sorting Only for Phone Contact
//                manageSorting()
//            default :
//                print("")
//            }
//        }
//
//        tblFriend.reloadData()
//    }
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        return textField.resignFirstResponder()
//    }
//}
//
//// MARK:- --------- UITableView Datasources/Delegate
//extension InviteAndConnectViewController{
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if section == 0 { return nil }
//        if arrSearchFriendList.isEmpty { return nil }
//        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ConnectAllHeaderView")as? ConnectAllHeaderView else {
//            return nil
//        }
//        headerView.imgSelectAllFriend.isHidden = self.arrConnectAllFriend.isEmpty
//        headerView.onConnectAll = { [weak self] (sender) in
//            self?.btnSelectAllFriendCLK(sender)
//        }
//        return headerView
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if section == 0 { return 0.0 }
//        if arrSearchFriendList.isEmpty { return 0.0 }
//        return UITableView.automaticDimension
//    }
//
//    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
//        if arrSearchFriendList.isEmpty { return 0.0 }
//        return 50.0
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
//
//    /*func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//     return 63.0
//     }*/
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        //return isSearch ? arrSearchFriendList.count : arrFriendList.count
//        if section == 0 {
//            return 1
//        }
//        if arrSearchFriendList.isEmpty {
//            return 1
//        }
//        return arrSearchFriendList.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        if indexPath.section == 0 {
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: "InviteSectionCell") as? InviteSectionCell else {
//                return UITableViewCell(frame: .zero)
//            }
//            cell.onPhoneBook = { [weak self] (sender) in
//                self?.btnFriendTypeCLK(sender)
//            }
//
//            cell.btnShareSocialMedia.touchUpInside { [weak self](sender) in
//
////                self?.presentActivityViewController(mediaData: CAppStoreURI, contentTitle: "Sevenchats app invitation.\n" )
//
//                self?.presentActivityViewController(mediaData: CAppStoreURI, contentTitle: "Let's chat on Sevenchats! It's a fast, simple, and secure app we can use to message, sale and buy products, and do many things for free. Get it at\n" )
//            }
//
//
//            let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.hide(_: )))
//            recognizer.numberOfTapsRequired = 1
//            cell.contentView.addGestureRecognizer(recognizer)
//
//
//
//            return cell
//        }
//
//        if arrSearchFriendList.isEmpty {
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyInviteFriendCell") as? EmptyInviteFriendCell else {
//                return UITableViewCell(frame: .zero)
//            }
//            return cell
//        }
//
//        if let cell = tableView.dequeueReusableCell(withIdentifier: "InviteFriendCell", for: indexPath) as? InviteFriendCell {
//
//            switch(selectedType) {
//            case 1:
//                // Facebook
//                let fbInfo = arrSearchFriendList[indexPath.row] as? [String : Any]
//                cell.lblUserName.text = fbInfo?.valueForString(key: "name")
//                cell.imgUserType.image = UIImage(named: "ic_login_btn_facebook")
//                break
//            case 2:
//                // Twitter
//                let twitterInfo = arrSearchFriendList[indexPath.row] as? [String : Any]
//                cell.lblUserName.text = twitterInfo?.valueForString(key: "name")
//                cell.lblUserInfo.text = twitterInfo?.valueForString(key: "screen_name")
//                cell.imgUser.loadImageFromUrl((twitterInfo?.valueForString(key: "profile_image_url_https"))!, true)
//                cell.imgUserType.image = UIImage(named: "ic_login_btn_twitter")
//
//                // Load more Data.....
//                if tblFriend.lastIndexPath() == indexPath {
//                    self.fetchTwitterList()
//                }
//
//                if let index = arrSyncUser.firstIndex(where: { $0["common_id"] as? String == twitterInfo?.valueForString(key: "id")}) {
//                    let syncUserInfo = arrSyncUser[index]
//                    cell.btnInviteConnect.setTitle(nil, for: .normal)
//                    cell.btnInviteConnect.setImage(nil, for: .normal)
//                    if syncUserInfo.valueForInt(key: CCheck_status) == 0{
//                        cell.btnInviteConnect.setTitle(CBtnInvite, for: .normal)
//                    }else{
//                        let friendStatus = syncUserInfo.valueForInt(key: CFriend_status)
//                        switch friendStatus {
//                        case 0, 4:
//                            if arrConnectAllFriend.contains(where: {$0[CUserId] as? Int == syncUserInfo.valueForInt(key: CUserId)}){
//                                cell.btnInviteConnect.setImage(UIImage(named: "ic_right"), for: .normal)
//                            }else{
//                                cell.btnInviteConnect.setTitle("  \(CBtnConnect)  ", for: .normal)
//                            }
//                        case 1:
//                            cell.btnInviteConnect.setTitle("  \(CBtnCancelRequest)  ", for: .normal)
//                        case 5:
//                            cell.btnInviteConnect.setTitle("  \(CBtnUnfriend)  ", for: .normal)
//                        default:
//                            break
//                        }
//                    }
//
//                    cell.btnInviteConnect.touchUpInside { [weak self] (sender) in
//                        guard let self = self else { return }
//                        // Remove all selected friend....
//                        if syncUserInfo.valueForInt(key: CCheck_status) == 0 {
//                            /*
//                             MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: nil)
//                             MISocial.shared().sendDirectMessage(userID: twitterInfo?.valueForString(key: "id"), fromVC: self, friendListBlock: { (response, error) in
//                             MILoader.shared.hideLoader()
//                             print("Response :",response as Any)
//                             if response != nil{
//                             MIToastAlert.shared.showToastAlert(position: .bottom, message: CInviteSentSuccess)
//                             }else{
//                             MIToastAlert.shared.showToastAlert(position: .bottom, message: CInviteSentUnSuccess)
//                             }
//                             })*/
//                        }else{
//                            let friendStatus = syncUserInfo.valueForInt(key: CFriend_status)
//                            if  friendStatus == 0 {
//                                if self.arrConnectAllFriend.contains(where: {$0[CUserId] as? Int == syncUserInfo.valueForInt(key: CUserId)}){
//                                    if let index = self.arrConnectAllFriend.index(where: {$0[CUserId] as? Int == syncUserInfo.valueForInt(key: CUserId)}) {
//                                        self.arrConnectAllFriend.remove(at: index)
//                                    }
//                                }else{
//                                    self.arrConnectAllFriend.append(syncUserInfo)
//                                }
//                                self.tblFriend.reloadData()
//                                self.checkConnectAllFriendStatus()
//                            }else{
//                                // Friend request api...
//                                var frndStatus = 0
//                                var isShowAlert = false
//                                var alertMessage = ""
//                                let first_name = syncUserInfo.valueForString(key: "first_name")
//                                let last_name = syncUserInfo.valueForString(key: "last_name")
//                                switch friendStatus {
//                                case 0:
//                                    frndStatus = CFriendRequestSent
//                                case 1:
//                                    frndStatus = CFriendRequestCancel
//                                    isShowAlert = true
//                                    alertMessage = CMessageCancelRequest
//                                case 5:
//                                    frndStatus = CFriendRequestUnfriend
//                                    isShowAlert = true
//                                    alertMessage = CMessageUnfriend + " " + first_name + " " + last_name
//                                default:
//                                    break
//                                }
//                                if isShowAlert{
//                                    self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: alertMessage, btnOneTitle: CBtnYes, btnOneTapped: { (alert) in
//                                        //self.friendStatusApi(syncUserInfo, syncUserInfo.valueForInt(key: CUserId), frndStatus)
//                                    }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
//                                }else{
//                                    //self.friendStatusApi(syncUserInfo, syncUserInfo.valueForInt(key: CUserId), frndStatus)
//                                }
//                            }
//                        }
//                    }
//                }
//
//                break
//            case 3:
//                // Phonebook
//                let contactInfo = arrSearchFriendList[indexPath.row] as? CNContact
//                cell.lblUserName.text = (contactInfo?.givenName.trim)! + " " + (contactInfo?.familyName.trim)!
//                cell.imgUserType.image = UIImage(named: "ic_btn_phonebook")
//
//                if let imgData = contactInfo!.thumbnailImageData {
//                    let image = UIImage(data: imgData)
//                    cell.imgUser.image = image
//                } else {
//                    cell.imgUser.image = UIImage(named: "ic_add_user.png")
//
//                }
//
//                if (contactInfo?.phoneNumbers.count)! > 0 {
//
//                    cell.lblUserInfo.text = contactInfo?.phoneNumbers[0].value.stringValue
//                    cell.btnInviteConnect.isHidden = false
//                    //                    cell.btnInviteContentMove.isHidden = true
//
//                    let phoneNumber = self.parseNumber(contactInfo?.phoneNumbers[0].value.stringValue ?? "")
//
//                    cell.setupCell(loan: phoneNumber,arrSyncUser: self.arrSyncUser)
//
//                    cell.btnInviteContentMove.isHidden = true
//
//
//                    cell.callBackInviteReturn = { Friendstatus,check_Status,arrListModel in
//
//                        let User_Id = arrListModel.first?.user_id
//                        //                        print("arralist\(arrlist.user_id)")
//                        if check_Status == 0 {
////                            let strInviteText = "Sevenchats app invitation.\n" + CAppStoreURI
////                            self.openMessageComposer(number: cell.lblUserInfo.text, body: strInviteText)
//                            let strInviteText = "Let's chat on Sevenchats! It's a fast, simple, and secure app we can use to message, sale and buy products, and do many things for free. Get it at.\n" + CAppStoreURI
//                                                        self.openMessageComposer(number: cell.lblUserInfo.text, body: strInviteText)
//
//                        } else {
//                            var frndStatus = 0
//                            var isShowAlert = false
//                            var alertMessage = ""
//                            switch Friendstatus {
//                            // switch syncUserInfo.valueForInt(key: CFriend_status) {
//                            case 0, 3, 4:
//                                frndStatus = CFriendRequestSent
//                                isShowAlert = true
//                                alertMessage = CAlertMessageForSendRequest
//                            case 1:
//                                frndStatus = CFriendRequestCancel
//                                isShowAlert = true
//                                alertMessage = CMessageCancelRequest
//                            case 5:
//                                frndStatus = CFriendRequestUnfriend
//                                isShowAlert = true
//                                alertMessage = CMessageUnfriend
//                            case 2:
//                                frndStatus = CFriendRequestAccept
//                                isShowAlert = true
//                                alertMessage = CAlertMessageForAcceptRequest
//                            default:
//                                break
//                            }
//                            if isShowAlert{
//                                self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: alertMessage, btnOneTitle: CBtnYes, btnOneTapped: { (alert) in
//                                    self.friendStatusApi(User_Id, frndStatus)
//                                    self.tblFriend.reloadData()
//                                }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
//                            }else{
//                                self.friendStatusApi(User_Id, frndStatus)
//                            }
//                            // }
//
//                        }
//                    }
//                }else{
//                    cell.lblUserInfo.text = ""
//                    cell.btnInviteConnect.isHidden = true
//                }
//
//                break
//            default:
//                break
//            }
//
//            return cell
//        }
//
//        return tableView.tableViewDummyCell()
//    }
//
//
//    @objc func hide(_ recognizer: UITapGestureRecognizer){
//        print("this is calling    ")
//
//
//    }
//
//}
//// MARK:- --------- Helper Functions
//extension InviteAndConnectViewController {
//
//    func checkConnectAllFriendStatus() {
//        var arrConnTemp = [[String : Any]]()
//        //            check_status == 1 && friend_status == 0 && user_id != 0 && user_id != appDelegate.loginUser?.user_id
//        arrConnTemp = arrSyncUser.filter({$0[CFriend_status] as? Int == 0 && $0[CCheck_status] as? Int == 1  && $0[CUserId] as? Int != 0   && $0[CUserId] as? Int64 != appDelegate.loginUser?.user_id })
//        if arrConnTemp.count > 0 {
//            //btnSelectAllFriend.isSelected = arrConnTemp.count == arrConnectAllFriend.count
//
//            if arrConnectAllFriend.count > 0{
//                btnBigDone.alpha = 1.0
//                btnSmallDone.alpha = 1.0
//                btnBigDone.isUserInteractionEnabled = true
//                btnSmallDone.isUserInteractionEnabled = true
//            } else {
//                btnBigDone.alpha = 0.5
//                btnSmallDone.alpha = 0.5
//                btnBigDone.isUserInteractionEnabled = false
//                btnSmallDone.isUserInteractionEnabled = false
//            }
//        } else {
//            //btnSelectAllFriend.isSelected = false
//
//            btnBigDone.alpha = 0.5
//            btnSmallDone.alpha = 0.5
//            btnBigDone.isUserInteractionEnabled = false
//            btnSmallDone.isUserInteractionEnabled = false
//        }
//
//        //imgSelectAllFriend.isHidden = !btnSelectAllFriend.isSelected
//        //lblNoDataFound.isHidden = arrFriendList.count > 0 ? true : false
//
//    }
//}
//// MARK:- --------- Action Event
//extension InviteAndConnectViewController{
//
//    @IBAction func btnFriendTypeCLK(_ sender : UIButton){
//
//        if apiTask?.state == URLSessionTask.State.running {
//            apiTask?.cancel()
//        }
//        self.btnSearch.isHidden = true
//        /*btnSelectAllFriend.isSelected = false
//         imgSelectAllFriend.isHidden = true
//         lblNoDataFound.isHidden = true
//         activityIndicatorView.isHidden = true
//         */
//        arrConnectAllFriend.removeAll()
//        arrSearchFriendList.removeAll()
//        arrSyncUser.removeAll()
//        arrFriendList.removeAll()
//        tblFriend.reloadData()
//
//        switch sender.tag {
//        case 0: // Facebook
//            if selectedType == 1{
//                return
//            }
//            selectedType = 1
//            self.getFBFriendList()
//
//            break
//        case 1: // Twitter
//            /*if selectedType == 2{
//             return
//             }
//             twitterCursor = "-1"
//             selectedType = 2
//             self.fetchTwitterList()*/
//            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CFeatureNotAvailable, btnOneTitle: CBtnOk, btnOneTapped: nil)
//            break
//        case 2: // PhoneBook
//            /*if selectedType == 3{
//             return
//             }*/
//            selectedType = 3
//            self.fetchLocalContact()
//            break
//        default:
//            break
//        }
//
//        //viewFriendInfo.isHidden = true
//        //viewFriendList.isHidden = false
//    }
//
//    @IBAction func btnSelectAllFriendCLK(_ sender : UIButton) {
//        sender.isSelected = !sender.isSelected
//        //imgSelectAllFriend.isHidden = !btnSelectAllFriend.isSelected
//        if sender.isSelected{
//            // fetch all user from sync user to connect...
//            //            check_status == 1 && friend_status == 0 && user_id != 0 && user_id != appDelegate.loginUser?.user_id
//            arrConnectAllFriend.removeAll()
//            arrConnectAllFriend = arrSyncUser.filter({$0[CFriend_status] as? Int == 0 && $0[CCheck_status] as? Int == 1  && $0[CUserId] as? Int != 0   && $0[CUserId] as? Int64 != appDelegate.loginUser?.user_id })
//        }else{
//            arrConnectAllFriend.removeAll()
//        }
//
//        tblFriend.reloadData()
//        self.checkConnectAllFriendStatus()
//    }
//
//    @IBAction func btnDoneCLK(_ sender : UIButton){
//
//        if arrConnectAllFriend.count == 0 {
//            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageConnectNoFriend, btnOneTitle: CBtnOk, btnOneTapped: nil)
//        } else {
//            self.connectAllFriend(false)
//        }
//    }
//
//    @IBAction func btnSkipDoneCLK(_ sender : UIButton){
//
//        switch sender.tag {
//        case 0: // Skip CLK
//            // Move on next screen here.......
//            let objInterest : SelectInterestsViewController = CStoryboardLRF.instantiateViewController(withIdentifier: "SelectInterestsViewController") as! SelectInterestsViewController
//            objInterest.isBackButtomHide = true
//            self.navigationController?.pushViewController(objInterest, animated: true)
//            break
//
//        case 1: // Done CLK
//            if arrConnectAllFriend.count == 0 {
//                self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageConnectNoFriend, btnOneTitle: CBtnOk, btnOneTapped: nil)
//            }else{
//                self.connectAllFriend(true)
//            }
//            break
//
//        default:
//            break
//        }
//    }
//
//    @IBAction func btnSearchCancelCLK(_ sender: UIButton) {
//
//        switch sender.tag {
//        case 0:
//            txtSearch.becomeFirstResponder()
//            txtSearch.text = nil
//            lblTitle.isHidden = true
//            viewSearchBar.isHidden = false
//            btnCancel.isHidden = false
//            btnSearch.isHidden = true
//            break
//        case 1:
//            txtSearch.resignFirstResponder()
//            lblTitle.isHidden = false
//            viewSearchBar.isHidden = true
//            btnCancel.isHidden = true
//            btnSearch.isHidden = false
//            break
//
//        case 2:
//            txtSearch.text = nil
//            break
//
//        default:
//            break
//        }
//        //isSearch = false
//        tblFriend.reloadData()
//    }
//}
//


//
//  InviteAndConnectViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 08/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import ContactsUI
import PhoneNumberKit

class InviteAndConnectViewController: ParentViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let phoneNumberKit = PhoneNumberKit()
    @IBOutlet var viewButtonSeparator : UIView!
    @IBOutlet var tblFriend : UITableView!
    @IBOutlet var viewSearchBar : UIView!
    @IBOutlet var btnSearch : UIButton!
    @IBOutlet var btnCancel : UIButton!
    @IBOutlet var txtSearch : UITextField!{
        didSet{
            txtSearch.returnKeyType = .search
        }
    }
    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var btnSideMenu : UIButton!
    @IBOutlet var btnBigDone : UIButton! {
        didSet {
            btnBigDone.isUserInteractionEnabled = false
            btnBigDone.alpha = 0.5
        }
    }
    @IBOutlet weak var btnSmallDone : UIButton! {
        didSet {
            btnSmallDone.isUserInteractionEnabled = false
            btnSmallDone.alpha = 0.5
        }
    }
    
    @IBOutlet var viewButtonView : UIView!
    
    @IBOutlet var cnNavigationHeight : NSLayoutConstraint!
    @IBOutlet var btnSkip : UIButton!
    var isFromSideMenu : Bool!
    var arrFriendList : [Any] = [] {
        didSet{
            self.arrSearchFriendList = arrFriendList
            manageSorting()
        }
    }
    var arrSyncUser = [[String : Any]]()
    var arrConnectAllFriend = [[String : Any]]()
    var arrSearchFriendList = [Any]()
    var arrPhoneList = [[String : Any]?]()
    var arrTempList = [[String:Any]]()
    var selectedType = 1
    var twitterCursor = "-1"
    //var isSearch : Bool = false
    var apiTask : URLSessionTask?
    var arrphoneNo : [MDLInivte] = []
    var arrListModel = [MDLUsers]()
    var arrBulkSms = [String]()
    var Friend_status = 0
    var Check_status :Int?
    var isBulkSms = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Initialization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateUIAccordingToLanguage()
    }
    deinit {
        print("Deinit -> InviteViewController")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(true)
         tblFriend.removeFromSuperview()
     }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- --------- Initialization
    func Initialization(){
        //self.title = CNavInviteContact
        lblTitle.text = CInviteConnectTitle
        if isFromSideMenu{
            btnSideMenu.isHidden = false
            btnBigDone.isHidden = true
            btnSmallDone.isHidden = true
            btnSkip.isHidden = true
            viewButtonSeparator.isHidden = true
        }else{
            btnSideMenu.isHidden = true
            btnBigDone.isHidden = true
            btnSmallDone.isHidden = false
            btnSkip.isHidden = false
            viewButtonSeparator.isHidden = false
        }
        
        
        tblFriend.register(UINib(nibName: "ConnectAllHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "ConnectAllHeaderView")
        tblFriend.register(UINib(nibName: "InviteSectionCell", bundle: nil), forCellReuseIdentifier: "InviteSectionCell")
        tblFriend.register(UINib(nibName: "EmptyInviteFriendCell", bundle: nil), forCellReuseIdentifier: "EmptyInviteFriendCell")
        tblFriend.register(UINib(nibName: "InviteFriendCell", bundle: nil), forCellReuseIdentifier: "InviteFriendCell")
        tblFriend.tableFooterView = UIView()
        tblFriend.delegate = self
        tblFriend.dataSource = self
        tblFriend.reloadData()
        self.btnSearch.isHidden = true
        self.viewButtonView.isHidden = true
        
        cnNavigationHeight.constant = IS_iPhone_X_Series ? 84 : 64
        GCDMainThread.async {
            self.viewSearchBar.layer.cornerRadius = self.viewSearchBar.frame.size.height/2
        }
    }
    
    func updateUIAccordingToLanguage(){
        
        if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
            // Reverse Flow...
            btnSideMenu.isSelected = true
            btnSearch.contentHorizontalAlignment = .left
        }else{
            // Normal Flow...
            btnSideMenu.isSelected = false
            btnSearch.contentHorizontalAlignment = .right
        }
    }
    
    func manageSorting() {
        
        arrSearchFriendList = (arrSearchFriendList as? [CNContact])?.sorted(by: { (Obj1, Obj2) -> Bool in
            
            let Obj1_Name: String = Obj1.givenName.lowercased().trim + Obj1.familyName.lowercased().trim
            let Obj2_Name: String = Obj2.givenName.lowercased().trim + Obj2.familyName.lowercased().trim
            
            return (Obj1_Name.localizedCaseInsensitiveCompare(Obj2_Name) == .orderedAscending)
        }) ?? []
        tblFriend.reloadData()
    }
}

// MARK:- --------- Api Functions
extension InviteAndConnectViewController{
    func friendStatusApi( _ userid : String?,  _ status : Int?){
        let friend_ID = userid
        guard let user_ID = appDelegate.loginUser?.user_id else { return }
        
        let dict :[String:Any]  =  [
            "user_id":  user_ID.description,
            "friend_user_id": friend_ID as Any,
            "request_type": status?.toString as Any
        ]
        
        APIRequest.shared().friendRquestStatus(dict: dict, completion: { [weak self] (response, error) in
            guard let self = self else { return }
            if response != nil{
                
                if let metaData = response?.value(forKey: CJsonMeta) as? [String : AnyObject] {
                    if  metaData.valueForString(key: "message") == "Request sent successfully"{
                        guard let user_ID =  appDelegate.loginUser?.user_id.description else { return}
                        guard let firstName = appDelegate.loginUser?.first_name else {return}
                        guard let lastName = appDelegate.loginUser?.last_name else {return}
                        MIGeneralsAPI.shared().sendNotification(userid ?? "", userID: user_ID.description, subject: "send you a Friends Request", MsgType: "FRIEND_REQUEST", MsgSent:"", showDisplayContent: "send you a Friends Request", senderName: firstName + lastName, post_ID:dict,shareLink: "sendFrdRequestLink")
                    }
                }
            }
        })
    }
    
    func connectAllFriend(_ isSignup : Bool){
        
        var arrSocialID = arrConnectAllFriend.map({$0.valueForString(key: CUserId) })
        arrSocialID = arrSocialID.removeDuplicates()
        let socialIDS = arrSocialID.joined(separator: ",")
        
        if !socialIDS.isBlank{
            
        }
    }
    
}
// MARK:- --------- Get friend from social
extension InviteAndConnectViewController{
    
    func getFBFriendList() {
        
        arrFriendList.removeAll()
        tblFriend.reloadData()
        
        MISocial.shared().facebookFriendList(fromVC: self) { (response, error) in
            
            //print("Response :",response)
        }
        
        return
    }
    
    // Fetch contact from local......
    func fetchTwitterList() {
    }
    
    func parseNumber(_ number: String) ->String? {
        do {
            let phoneNumber = try self.phoneNumberKit.parse(number)
            var internationNumber = self.phoneNumberKit.format(phoneNumber, toType: .international)
            internationNumber = internationNumber.replacingOccurrences(of: String(phoneNumber.countryCode), with: "")
            internationNumber = internationNumber.replacingOccurrences(of: "(", with: "")
            internationNumber = internationNumber.replacingOccurrences(of: " ", with: "")
            internationNumber = internationNumber.replacingOccurrences(of: ")", with: "")
            internationNumber = internationNumber.replacingOccurrences(of: "-", with: "")
            internationNumber = internationNumber.replacingOccurrences(of: "+", with: "")
            return internationNumber
        } catch {
            //print("Number is not valid === ")
            var phoneNumber = number.replacingOccurrences(of: "(", with: "")
            phoneNumber = phoneNumber.replacingOccurrences(of: " ", with: "")
            phoneNumber = phoneNumber.replacingOccurrences(of: ")", with: "")
            phoneNumber = phoneNumber.replacingOccurrences(of: "-", with: "")
            phoneNumber = phoneNumber.replacingOccurrences(of: "+", with: "")
            return phoneNumber
        }
    }
    
    // Fetch contact from local......
    func fetchLocalContact()
    {
        MIPhoneContacts.shared().getContacts { (results) in
            if results.count > 0 {
                if self.selectedType == 3 {
                    var arrPhoneNumbers = [String?]()
                    for contactInfo in results {
                        if !(contactInfo?.phoneNumbers.isEmpty ?? true) {
                            //                        arrPhoneNumbers.append(contactInfo?.phoneNumbers[0].value.stringValue)
                            
                            if let number = contactInfo?.phoneNumbers[0].value.stringValue,
                               let finalNumber = self.parseNumber(number) {
                                arrPhoneNumbers.append(finalNumber)
                            }
                            
                        }else {
                            arrPhoneNumbers.append("0000000000")
                        }
                    }
                    
                    var phoneNumber = (arrPhoneNumbers as? Array)!.joined(separator: ",")
                    phoneNumber = phoneNumber.replacingOccurrences(of: "(", with: "")
                    phoneNumber = phoneNumber.replacingOccurrences(of: " ", with: "")
                    phoneNumber = phoneNumber.replacingOccurrences(of: ")", with: "")
                    phoneNumber = phoneNumber.replacingOccurrences(of: "-", with: "")
                    phoneNumber = phoneNumber.replacingOccurrences(of: "+", with: "")
                    phoneNumber = phoneNumber.replacingOccurrences(of: ".", with: "")
                    
                    MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: CMessagePleaseWait)
                    //self.activityIndicatorView.isHidden = false
                    //self.activityIndicatorView.startAnimating()
                    let fullNameArr = phoneNumber.components(separatedBy: ",")
                    
                    let strArr = fullNameArr.map { String($0)}
                    strArr.forEach { mobileNumber in
                        print(mobileNumber)
                        
                        let dict:[String:Any] = [
                            CMobile : mobileNumber
                        ]
                        
                        APIRequest.shared().inviteAndconnect(para: dict as [String : AnyObject]) { (response, error) in
                            if response != nil && error == nil {
                                if let metaInfo = response![CJsonMeta] as? [String:Any]{
                                    let status =  metaInfo["status"] as? String ?? ""
                                    if status == "1"{
                                        //                                                self.Check_status = 1
                                        if let arrData = response?.value(forKey: CJsonData) as? [[String : AnyObject]] {
                                            self.arrPhoneList =  arrData
                                            for arr in arrData{
                                                //                                                        self.arrListModel.append(MDLUsers(fromDictionary: arr))
                                            }
                                            print("arrData\(arrData)")
                                            //                                                    self.Check_status = 1
                                            self.arrPhoneList += self.arrTempList
                                            self.btnSearch.isHidden = false
                                            self.arrSyncUser = arrData
                                            self.arrFriendList = results as [Any]
                                            self.tblFriend.reloadData()
                                            self.checkConnectAllFriendStatus()
                                        }else {
                                            self.arrPhoneList += self.arrTempList
                                            self.btnSearch.isHidden = false
                                            //                                                      self.arrSyncUser = arrData
                                            self.arrFriendList = results as [Any]
                                            self.tblFriend.reloadData()
                                            self.checkConnectAllFriendStatus()
                                        }
                                    }else {
                                        self.arrPhoneList += self.arrTempList
                                        self.btnSearch.isHidden = false
                                        //                                                      self.arrSyncUser = arrData
                                        self.arrFriendList = results as [Any]
                                        self.tblFriend.reloadData()
                                        self.checkConnectAllFriendStatus()
                                    }
                                }
                            }else{
                                self.btnSearch.isHidden = true
                            }
                        }
                    }
                }
            }else{
                self.checkConnectAllFriendStatus()
                self.btnSearch.isHidden = true
            }
        }
    }
    
    
    
    
    
    //Bulk Sms
    func fetchLocalContacttoBulksms(){
        MIPhoneContacts.shared().getContacts { (results) in
            if results.count > 0 {
                if self.selectedType == 3 {
                    var arrPhoneNumbers = [String?]()
                    for contactInfo in results {
                        if !(contactInfo?.phoneNumbers.isEmpty ?? true) {
                            //                        arrPhoneNumbers.append(contactInfo?.phoneNumbers[0].value.stringValue)
                            
                            if let number = contactInfo?.phoneNumbers[0].value.stringValue,
                               let finalNumber = self.parseNumber(number) {
                                arrPhoneNumbers.append(finalNumber)
                            }
                            
                        }else {
                            arrPhoneNumbers.append("0000000000")
                        }
                    }
                    
                    let arrPhoneNum = arrPhoneNumbers.compactMap { Int($0!) }
                    
                    MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: CMessagePleaseWait)
          
                    let dict:[String:Any] = [
                            CMobile : arrPhoneNum
                        ]
                    
                        APIRequest.shared().InviteBulkSms(para: dict as [String : AnyObject]) { (response, error) in
                            if response != nil && error == nil {
                                print("--------response\(response)")
                                
                                
                                if let metaInfo = response![CJsonMeta] as? [String:Any]{
                                    let status =  metaInfo["status"] as? String ?? ""
//                                    if status == "1"{
                                        //                                                self.Check_status = 1
                                        if let arrData = response?.value(forKey: CJsonData) as? [[String : AnyObject]] {
                                            self.arrPhoneList =  arrData
                                            self.arrPhoneList += self.arrTempList
                                            self.btnSearch.isHidden = false
                                            self.arrSyncUser = arrData
                                            self.arrFriendList = results as [Any]
                                            self.tblFriend.reloadData()
                                            self.checkConnectAllFriendStatus()
                                        }else {
                                            self.arrPhoneList += self.arrTempList
                                            self.btnSearch.isHidden = false
                                            //                                                      self.arrSyncUser = arrData
                                            self.arrFriendList = results as [Any]
                                            self.tblFriend.reloadData()
                                            self.checkConnectAllFriendStatus()
                                        }
//                                    }
                                    
                                    
//                                    else {
//                                        self.arrPhoneList += self.arrTempList
//                                        self.btnSearch.isHidden = false
//                                        // self.arrSyncUser = arrData
//                                        self.arrFriendList = results as [Any]
//                                        self.tblFriend.reloadData()
//                                        self.checkConnectAllFriendStatus()
//                                    }
                                }
                            }else{
                                self.btnSearch.isHidden = true
                            }
                        }
                
                }
            }else{
                self.checkConnectAllFriendStatus()
                self.btnSearch.isHidden = true
            }
        }
    }
    
    
    
    
    
}


// MARK:- --------- UITextField Delegate -

extension InviteAndConnectViewController: UITextFieldDelegate {
    
    @IBAction func textFieldDidChanged(textField: UITextField) {
        
        if textField.text?.isEmpty ?? true {
            //isSearch = false
            arrSearchFriendList = arrFriendList
            manageSorting()
            
        } else {
            //isSearch = true
            arrSearchFriendList.removeAll()
            
            switch(selectedType){
            case 1,2: //Facebook, Twitter
                arrSearchFriendList =  (arrFriendList as? [[String: AnyObject]])?.filter({($0["name"] as? String)?.range(of: textField.text ?? "", options: [.caseInsensitive]) != nil }) ?? []
            //                manageSorting()
            
            case 3: // PhoneBook
                arrSearchFriendList = (arrFriendList as? [CNContact])?.filter({
                                                                                ($0.givenName.trim).range(of: textField.text ?? "", options: [.caseInsensitive]) != nil || ($0.familyName.trim).range(of:  textField.text ?? "", options: [.caseInsensitive]) != nil}) ?? []
                
                // Now sorting Only for Phone Contact
                manageSorting()
            default :
                print("")
            }
        }
        
        tblFriend.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}

// MARK:- --------- UITableView Datasources/Delegate
extension InviteAndConnectViewController{
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 { return nil }
        if arrSearchFriendList.isEmpty { return nil }
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ConnectAllHeaderView")as? ConnectAllHeaderView else {
            return nil
        }
        headerView.imgSelectAllFriend.isHidden = self.arrConnectAllFriend.isEmpty
        headerView.onConnectAll = { [weak self] (sender) in
            self?.btnSelectAllFriendCLK(sender)
            headerView.imgSelectAllFriend.isHidden = !headerView.btnSelectAllFriend.isSelected
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 { return 0.0 }
        if arrSearchFriendList.isEmpty { return 0.0 }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        if arrSearchFriendList.isEmpty { return 0.0 }
        return 50.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    /*func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     return 63.0
     }*/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return isSearch ? arrSearchFriendList.count : arrFriendList.count
        if section == 0 {
            return 1
        }
        if arrSearchFriendList.isEmpty {
            return 1
        }
        if isBulkSms{
           return arrPhoneList.count
        }
        return arrSearchFriendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "InviteSectionCell") as? InviteSectionCell else {
                return UITableViewCell(frame: .zero)
            }
            cell.onPhoneBook = { [weak self] (sender) in
                self?.btnFriendTypeCLK(sender)
            }
            
            cell.btnShareSocialMedia.touchUpInside { [weak self](sender) in
                
//                self?.presentActivityViewController(mediaData: CAppStoreURI, contentTitle: "Sevenchats app invitation.\n" )
                
                self?.presentActivityViewController(mediaData: CAppStoreURI, contentTitle: "Let's chat on Sevenchats! It's a fast, simple, and secure app we can use to message, sale and buy products, and do many things for free. Get it at\n" )
            }
            
            
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.hide(_: )))
            recognizer.numberOfTapsRequired = 1
            cell.contentView.addGestureRecognizer(recognizer)
            
            
            
            return cell
        }
        
        if arrSearchFriendList.isEmpty {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyInviteFriendCell") as? EmptyInviteFriendCell else {
                return UITableViewCell(frame: .zero)
            }
            return cell
        }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "InviteFriendCell", for: indexPath) as? InviteFriendCell {
            
            switch(selectedType) {
            case 1:
                // Facebook
                let fbInfo = arrSearchFriendList[indexPath.row] as? [String : Any]
                cell.lblUserName.text = fbInfo?.valueForString(key: "name")
                cell.imgUserType.image = UIImage(named: "ic_login_btn_facebook")
                break
            case 2:
                // Twitter
                let twitterInfo = arrSearchFriendList[indexPath.row] as? [String : Any]
                cell.lblUserName.text = twitterInfo?.valueForString(key: "name")
                cell.lblUserInfo.text = twitterInfo?.valueForString(key: "screen_name")
                cell.imgUser.loadImageFromUrl((twitterInfo?.valueForString(key: "profile_image_url_https"))!, true)
                cell.imgUserType.image = UIImage(named: "ic_login_btn_twitter")
                
                // Load more Data.....
                if tblFriend.lastIndexPath() == indexPath {
                    self.fetchTwitterList()
                }
                
                if let index = arrSyncUser.firstIndex(where: { $0["common_id"] as? String == twitterInfo?.valueForString(key: "id")}) {
                    let syncUserInfo = arrSyncUser[index]
                    cell.btnInviteConnect.setTitle(nil, for: .normal)
                    cell.btnInviteConnect.setImage(nil, for: .normal)
                    if syncUserInfo.valueForInt(key: CCheck_status) == 0{
                        cell.btnInviteConnect.setTitle(CBtnInvite, for: .normal)
                    }else{
                        let friendStatus = syncUserInfo.valueForInt(key: CFriend_status)
                        switch friendStatus {
                        case 0, 4:
                            if arrConnectAllFriend.contains(where: {$0[CUserId] as? Int == syncUserInfo.valueForInt(key: CUserId)}){
                                cell.btnInviteConnect.setImage(UIImage(named: "ic_right"), for: .normal)
                            }else{
                                cell.btnInviteConnect.setTitle("  \(CBtnConnect)  ", for: .normal)
                            }
                        case 1:
                            cell.btnInviteConnect.setTitle("  \(CBtnCancelRequest)  ", for: .normal)
                        case 5:
                            cell.btnInviteConnect.setTitle("  \(CBtnUnfriend)  ", for: .normal)
                        default:
                            break
                        }
                    }
                    
                    cell.btnInviteConnect.touchUpInside { [weak self] (sender) in
                        guard let self = self else { return }
                        // Remove all selected friend....
                        if syncUserInfo.valueForInt(key: CCheck_status) == 0 {
                            /*
                             MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: nil)
                             MISocial.shared().sendDirectMessage(userID: twitterInfo?.valueForString(key: "id"), fromVC: self, friendListBlock: { (response, error) in
                             MILoader.shared.hideLoader()
                             print("Response :",response as Any)
                             if response != nil{
                             MIToastAlert.shared.showToastAlert(position: .bottom, message: CInviteSentSuccess)
                             }else{
                             MIToastAlert.shared.showToastAlert(position: .bottom, message: CInviteSentUnSuccess)
                             }
                             })*/
                        }else{
                            let friendStatus = syncUserInfo.valueForInt(key: CFriend_status)
                            if  friendStatus == 0 {
                                if self.arrConnectAllFriend.contains(where: {$0[CUserId] as? Int == syncUserInfo.valueForInt(key: CUserId)}){
                                    if let index = self.arrConnectAllFriend.index(where: {$0[CUserId] as? Int == syncUserInfo.valueForInt(key: CUserId)}) {
                                        self.arrConnectAllFriend.remove(at: index)
                                    }
                                }else{
                                    self.arrConnectAllFriend.append(syncUserInfo)
                                }
                                self.tblFriend.reloadData()
                                self.checkConnectAllFriendStatus()
                            }else{
                                // Friend request api...
                                var frndStatus = 0
                                var isShowAlert = false
                                var alertMessage = ""
                                let first_name = syncUserInfo.valueForString(key: "first_name")
                                let last_name = syncUserInfo.valueForString(key: "last_name")
                                switch friendStatus {
                                case 0:
                                    frndStatus = CFriendRequestSent
                                case 1:
                                    frndStatus = CFriendRequestCancel
                                    isShowAlert = true
                                    alertMessage = CMessageCancelRequest
                                case 5:
                                    frndStatus = CFriendRequestUnfriend
                                    isShowAlert = true
                                    alertMessage = CMessageUnfriend + " " + first_name + " " + last_name
                                default:
                                    break
                                }
                                if isShowAlert{
                                    self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: alertMessage, btnOneTitle: CBtnYes, btnOneTapped: { (alert) in
                                        //self.friendStatusApi(syncUserInfo, syncUserInfo.valueForInt(key: CUserId), frndStatus)
                                    }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
                                }else{
                                    //self.friendStatusApi(syncUserInfo, syncUserInfo.valueForInt(key: CUserId), frndStatus)
                                }
                            }
                        }
                    }
                }
                
                break
            case 3:
                // Phonebook
                
                if isBulkSms {
                    
                    cell.lblUserName.text = arrPhoneList[indexPath.row]?.valueForString(key: "first_name")
                    cell.imgUserType.loadImageFromUrl(arrPhoneList[indexPath.row]?.valueForString(key: CUserProfileImage), true)
                    cell.lblUserInfo.text = arrPhoneList[indexPath.row]?.valueForString(key: "mobile")
                    cell.btnInviteConnect.isHidden = false
                }else {
                    
                    
                    
                    let contactInfo = arrSearchFriendList[indexPath.row] as? CNContact
                    cell.lblUserName.text = (contactInfo?.givenName.trim)! + " " + (contactInfo?.familyName.trim)!
                    cell.imgUserType.image = UIImage(named: "ic_btn_phonebook")
                    
                    if let imgData = contactInfo!.thumbnailImageData {
                        let image = UIImage(data: imgData)
                        cell.imgUser.image = image
                    } else {
                        cell.imgUser.image = UIImage(named: "ic_add_user.png")
                        
                    }
                    
                    if (contactInfo?.phoneNumbers.count)! > 0 {
                        
                        cell.lblUserInfo.text = contactInfo?.phoneNumbers[0].value.stringValue
                        cell.btnInviteConnect.isHidden = false
                        //                    cell.btnInviteContentMove.isHidden = true
                        
                        let phoneNumber = self.parseNumber(contactInfo?.phoneNumbers[0].value.stringValue ?? "")
                        
                        cell.setupCell(loan: phoneNumber,arrSyncUser: self.arrSyncUser)
                        
                        cell.btnInviteContentMove.isHidden = true
                        
                        
                        cell.callBackInviteReturn = { Friendstatus,check_Status,arrListModel in
                            
                            let User_Id = arrListModel.first?.user_id
                            //                        print("arralist\(arrlist.user_id)")
                            if check_Status == 0 {
                                //                            let strInviteText = "Sevenchats app invitation.\n" + CAppStoreURI
                                //                            self.openMessageComposer(number: cell.lblUserInfo.text, body: strInviteText)
                                let strInviteText = "Let's chat on Sevenchats! It's a fast, simple, and secure app we can use to message, sale and buy products, and do many things for free. Get it at.\n" + CAppStoreURI
                                self.openMessageComposer(number: cell.lblUserInfo.text, body: strInviteText)
                                
                            } else {
                                var frndStatus = 0
                                var isShowAlert = false
                                var alertMessage = ""
                                switch Friendstatus {
                                    // switch syncUserInfo.valueForInt(key: CFriend_status) {
                                case 0, 3, 4:
                                    frndStatus = CFriendRequestSent
                                    isShowAlert = true
                                    alertMessage = CAlertMessageForSendRequest
                                case 1:
                                    frndStatus = CFriendRequestCancel
                                    isShowAlert = true
                                    alertMessage = CMessageCancelRequest
                                case 5:
                                    frndStatus = CFriendRequestUnfriend
                                    isShowAlert = true
                                    alertMessage = CMessageUnfriend
                                case 2:
                                    frndStatus = CFriendRequestAccept
                                    isShowAlert = true
                                    alertMessage = CAlertMessageForAcceptRequest
                                default:
                                    break
                                }
                                if isShowAlert{
                                    self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: alertMessage, btnOneTitle: CBtnYes, btnOneTapped: { (alert) in
                                        self.friendStatusApi(User_Id, frndStatus)
                                        self.tblFriend.reloadData()
                                    }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
                                }else{
                                    self.friendStatusApi(User_Id, frndStatus)
                                }
                                // }
                                
                            }
                        }
                    }else{
                        cell.lblUserInfo.text = ""
                        cell.btnInviteConnect.isHidden = true
                    }
                }
                
                break
            default:
                break
            }
            
            return cell
        }
        
        return tableView.tableViewDummyCell()
    }
    
    
    @objc func hide(_ recognizer: UITapGestureRecognizer){
        print("this is calling    ")
        
        
    }
    
}
// MARK:- --------- Helper Functions
extension InviteAndConnectViewController {
    
    func checkConnectAllFriendStatus() {
        var arrConnTemp = [[String : Any]]()
        //            check_status == 1 && friend_status == 0 && user_id != 0 && user_id != appDelegate.loginUser?.user_id
        arrConnTemp = arrSyncUser.filter({$0[CFriend_status] as? Int == 0 && $0[CCheck_status] as? Int == 1  && $0[CUserId] as? Int != 0   && $0[CUserId] as? Int64 != appDelegate.loginUser?.user_id })
        if arrConnTemp.count > 0 {
            //btnSelectAllFriend.isSelected = arrConnTemp.count == arrConnectAllFriend.count
            
            if arrConnectAllFriend.count > 0{
                btnBigDone.alpha = 1.0
                btnSmallDone.alpha = 1.0
                btnBigDone.isUserInteractionEnabled = true
                btnSmallDone.isUserInteractionEnabled = true
            } else {
                btnBigDone.alpha = 0.5
                btnSmallDone.alpha = 0.5
                btnBigDone.isUserInteractionEnabled = false
                btnSmallDone.isUserInteractionEnabled = false
            }
        } else {
            //btnSelectAllFriend.isSelected = false
            
            btnBigDone.alpha = 0.5
            btnSmallDone.alpha = 0.5
            btnBigDone.isUserInteractionEnabled = false
            btnSmallDone.isUserInteractionEnabled = false
        }
        
        //imgSelectAllFriend.isHidden = !btnSelectAllFriend.isSelected
        //lblNoDataFound.isHidden = arrFriendList.count > 0 ? true : false
        
    }
}
// MARK:- --------- Action Event
extension InviteAndConnectViewController{
    
    @IBAction func btnFriendTypeCLK(_ sender : UIButton){
        
        if apiTask?.state == URLSessionTask.State.running {
            apiTask?.cancel()
        }
        self.btnSearch.isHidden = true
        /*btnSelectAllFriend.isSelected = false
         imgSelectAllFriend.isHidden = true
         lblNoDataFound.isHidden = true
         activityIndicatorView.isHidden = true
         */
        arrConnectAllFriend.removeAll()
        arrSearchFriendList.removeAll()
        arrSyncUser.removeAll()
        arrFriendList.removeAll()
        tblFriend.reloadData()
        
        switch sender.tag {
        case 0: // Facebook
            if selectedType == 1{
                return
            }
            selectedType = 1
            self.getFBFriendList()
            
            break
        case 1: // Twitter
            /*if selectedType == 2{
             return
             }
             twitterCursor = "-1"
             selectedType = 2
             self.fetchTwitterList()*/
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CFeatureNotAvailable, btnOneTitle: CBtnOk, btnOneTapped: nil)
            break
        case 2: // PhoneBook
            /*if selectedType == 3{
             return
             }*/
            selectedType = 3
            if isBulkSms{
                self.fetchLocalContacttoBulksms()
            }else {
               self.fetchLocalContact()
            }

           
            break
        default:
            break
        }
        
        //viewFriendInfo.isHidden = true
        //viewFriendList.isHidden = false
    }
    
    @IBAction func btnSelectAllFriendCLK(_ sender : UIButton) {
       
        
        
        if isBulkSms{
            sender.isSelected = !sender.isSelected
            
            sendBulkSms()
            
            
        }else {
            sender.isSelected = !sender.isSelected
            //imgSelectAllFriend.isHidden = !btnSelectAllFriend.isSelected
            if sender.isSelected{
                // fetch all user from sync user to connect...
                //            check_status == 1 && friend_status == 0 && user_id != 0 && user_id != appDelegate.loginUser?.user_id
                arrConnectAllFriend.removeAll()
                arrConnectAllFriend = arrSyncUser.filter({$0[CFriend_status] as? Int == 0 && $0[CCheck_status] as? Int == 1  && $0[CUserId] as? Int != 0   && $0[CUserId] as? Int64 != appDelegate.loginUser?.user_id })
            }else{
                arrConnectAllFriend.removeAll()
            }
            
            tblFriend.reloadData()
            self.checkConnectAllFriendStatus()
        }
        
        
        
        
//        sender.isSelected = !sender.isSelected
//        //imgSelectAllFriend.isHidden = !btnSelectAllFriend.isSelected
//        if sender.isSelected{
//            // fetch all user from sync user to connect...
//            //            check_status == 1 && friend_status == 0 && user_id != 0 && user_id != appDelegate.loginUser?.user_id
//            arrConnectAllFriend.removeAll()
//            arrConnectAllFriend = arrSyncUser.filter({$0[CFriend_status] as? Int == 0 && $0[CCheck_status] as? Int == 1  && $0[CUserId] as? Int != 0   && $0[CUserId] as? Int64 != appDelegate.loginUser?.user_id })
//        }else{
//            arrConnectAllFriend.removeAll()
//        }
//
//        tblFriend.reloadData()
//        self.checkConnectAllFriendStatus()
    }
    //TODO: - Send bulk sms
    
    func sendBulkSms(){
        self.arrBulkSms.removeAll()
        let userID = EncryptDecrypt.shared().encryptDecryptModel(userResultStr: appDelegate.loginUser?.user_id.description ?? "")
        
        for arrPhoneNo in arrPhoneList{
            let phoneNo = arrPhoneNo?["mobile"] as? String
            print("-------\(phoneNo)")
            let encryptNunm = EncryptDecrypt.shared().encryptDecryptModel(userResultStr: phoneNo ?? "")
            arrBulkSms.append(encryptNunm)
            
        }
        
        let dict:[String:Any] = [
            "user_id" : userID,
            "friend_user_id":arrBulkSms,
            "request_type": 8
        ]
        
        APIRequest.shared().InvitesentBulkSms(para: dict as [String : AnyObject]) { (response, error) in
            if response != nil && error == nil {
                print("--------response\(response)")
                
                
                //                    if let metaInfo = response![CJsonMeta] as? [String:Any]{
                //                        let status =  metaInfo["status"] as? String ?? ""
                ////                                    if status == "1"{
                //                            //                                                self.Check_status = 1
                //                            if let arrData = response?.value(forKey: CJsonData) as? [[String : AnyObject]] {
                //                                self.arrPhoneList =  arrData
                //                                self.arrPhoneList += self.arrTempList
                //                                self.btnSearch.isHidden = false
                //                                self.arrSyncUser = arrData
                //                                self.arrFriendList = results as [Any]
                //                                self.tblFriend.reloadData()
                //                                self.checkConnectAllFriendStatus()
                //                            }else {
                //                                self.arrPhoneList += self.arrTempList
                //                                self.btnSearch.isHidden = false
                //                                //                                                      self.arrSyncUser = arrData
                //                                self.arrFriendList = results as [Any]
                //                                self.tblFriend.reloadData()
                //                                self.checkConnectAllFriendStatus()
                //                            }
                //
                //                    }
                
              //  self.navigationController?.pushViewController(self., animated: true)
                
                
            }
        }
    }
    
    
    
    
    
    
    @IBAction func btnDoneCLK(_ sender : UIButton){
        
        if arrConnectAllFriend.count == 0 {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageConnectNoFriend, btnOneTitle: CBtnOk, btnOneTapped: nil)
        } else {
            self.connectAllFriend(false)
        }
    }
    
    @IBAction func btnSkipDoneCLK(_ sender : UIButton){
        
        switch sender.tag {
        case 0: // Skip CLK
            // Move on next screen here.......
            let objInterest : SelectInterestsViewController = CStoryboardLRF.instantiateViewController(withIdentifier: "SelectInterestsViewController") as! SelectInterestsViewController
            objInterest.isBackButtomHide = true
            self.navigationController?.pushViewController(objInterest, animated: true)
            break
            
        case 1: // Done CLK
            if arrConnectAllFriend.count == 0 {
                self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageConnectNoFriend, btnOneTitle: CBtnOk, btnOneTapped: nil)
            }else{
                self.connectAllFriend(true)
            }
            break
            
        default:
            break
        }
    }
    
    @IBAction func btnSearchCancelCLK(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            txtSearch.becomeFirstResponder()
            txtSearch.text = nil
            lblTitle.isHidden = true
            viewSearchBar.isHidden = false
            btnCancel.isHidden = false
            btnSearch.isHidden = true
            break
        case 1:
            txtSearch.resignFirstResponder()
            lblTitle.isHidden = false
            viewSearchBar.isHidden = true
            btnCancel.isHidden = true
            btnSearch.isHidden = false
            break
            
        case 2:
            txtSearch.text = nil
            break
            
        default:
            break
        }
        //isSearch = false
        tblFriend.reloadData()
    }
}

