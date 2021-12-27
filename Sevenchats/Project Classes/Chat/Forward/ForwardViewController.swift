//
//  ForwardViewController.swift
//  Sevenchats
//
//  Created by mac-00012 on 29/04/20.
//  Copyright © 2020 mac-00020. All rights reserved.
//

//import UIKit
//
//class ForwardViewController: ParentViewController {
//
//    @IBOutlet weak var vwSegment: UIView!
//    @IBOutlet weak var btnSend: UIButton!{
//        didSet{
//            btnSend.isEnabled = false
//        }
//    }
//
//    /// Custome Segemtn for Single and Groups
//    weak var sementView: SegmentView!
//
//    /// it's contain SingleUserForwardViewController and GroupForwardViewController
//    weak var forwardPageVC : ForwardPageViewController?
//
//    /// searchBar for search files in list
//    fileprivate var searchBar = UISearchBar()
//    /// searchBarItem is used search file
//    fileprivate var searchBarItem : UIBarButtonItem!
//    /// cancelBarItem is used to cancel the searchBar
//    fileprivate var cancelBarItem : UIBarButtonItem!
//
//    weak var singleUserVC :  SingleUserForwardViewController?
//    weak var groupUserVC : GroupForwardViewController?
//    var maxSelection : Int = 5
//
//    var forwardMsg : TblMessages!
//
//    //MARK: - Life Cycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        self.title = "Forward"
//        Initialization()
//    }
//
//    /// PageViewController controller embed with this controller
//    /// - Parameters:
//    ///   - segue: segue type and identifier
//    ///   - sender: sender object
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let pageController = segue.destination as? ForwardPageViewController {
//            self.forwardPageVC = pageController
//        }
//    }
//    deinit {
//        print("deinit -> ForwardViewController")
//    }
//}
//
////MARK: - Initialization
//extension ForwardViewController {
//
//    func Initialization() {
//
//        addBarButtonItems()
//
//        /// Confiure PageViewController
//        self.forwardPageVC?.mForwardDelegate = self
//        singleUserVC = CStoryboardForward.instantiateViewController(withIdentifier: "SingleUserForwardViewController") as? SingleUserForwardViewController
//
//        groupUserVC = CStoryboardForward.instantiateViewController(withIdentifier: "GroupForwardViewController") as? GroupForwardViewController
//
//        let arrPage : [UIViewController] = [singleUserVC!, groupUserVC!]
//        self.forwardPageVC?.config(controllers: arrPage)
//
//        if sementView != nil {
//            sementView.removeFromSuperview()
//        }
//
//        /// Confiure custome segment controller
//        sementView = SegmentView.viewFromXib as? SegmentView
//        sementView.delegate = self
//        sementView.translatesAutoresizingMaskIntoConstraints = false
//        vwSegment.addSubview(sementView)
//
//        NSLayoutConstraint.activate([
//            sementView.leftAnchor.constraint(equalTo: vwSegment.leftAnchor, constant: 0),
//            sementView.rightAnchor.constraint(equalTo: vwSegment.rightAnchor, constant: 0),
//            sementView.topAnchor.constraint(equalTo: vwSegment.topAnchor, constant: 0),
//            sementView.bottomAnchor.constraint(equalTo: vwSegment.bottomAnchor, constant: 0)
//        ])
//
//        let myFile : SegmentText = SegmentText.viewFromXib as! SegmentText
//        myFile.lblText.text = CNavFriends
//
//        let sharedFile : SegmentText = SegmentText.viewFromXib as! SegmentText
//        sharedFile.lblText.text = CSideGroups
//
//        sementView.addSubItems(arrViews: [myFile,sharedFile])
//        sementView.selectedSegmentIndex = 0
//
//    }
//
//    // Created Right bar button...
//    fileprivate func addBarButtonItems() {
//
//        ///... For Searching
//
//        self.searchBarItem = BlockBarButtonItem(image: UIImage(named: "ic_btn_search"), style: .plain) { [weak self] (_) in
//            guard let _ = self else {return}
//            self?.navigationItem.titleView = self?.searchBar
//            UIView.animate(withDuration: 0.5, animations: {
//                self?.searchBar.alpha = 1
//            }, completion: { finished in
//                self?.searchBar.becomeFirstResponder()
//            })
//            self?.navigationItem.rightBarButtonItems = []
//            self?.navigationItem.rightBarButtonItem = self?.cancelBarItem
//        }
//        self.navigationItem.rightBarButtonItems = [searchBarItem]
//
//        ///... For Cancel Search
//        self.cancelBarItem = BlockBarButtonItem(title: CBtnCancel, style: .plain, actionHandler: { [weak self] (item) in
//            guard let _ = self else {return}
//            self?.searchBar.endEditing(true)
//            UIView.animate(withDuration: 0.5, animations: {
//                self?.searchBar.alpha = 0
//            }, completion: { finished in
//                self?.setCancelBarButton()
//            })
//        })
//
//        searchBar.alpha = 0
//        searchBar.placeholder = CSearch
//        searchBar.tintColor = .black
//
//        searchBar.change(textFont: CFontPoppins(size: (14 * CScreenWidth)/375, type: .regular))
//        searchBar.delegate = self
//    }
//
//    func setCancelBarButton(){
//        self.navigationItem.titleView = nil
//        self.navigationItem.rightBarButtonItem = nil
//        self.navigationItem.rightBarButtonItems = [self.searchBarItem] as? [UIBarButtonItem] ?? []
//    }
//}
////MARK: - ForwardMessages
//extension ForwardViewController {
//
//    func forwardMessageToUsers(usersIDs: [Int], groupIDs:[String:[String]]) {
//        for userId in usersIDs {
//            let channelId = CMQTTUSERTOPIC + "\(userId)"
//
//            MIMQTT.shared().messagePaylaod(
//                arrUser: ["\(appDelegate.loginUser?.user_id ?? 0)", "\(userId)"],
//                channelId: channelId,
//                message: forwardMsg.message,
//                messageType: .text,
//                chatType: .user,
//                groupID: nil,
//                forwardedMsgId: forwardMsg.message_id ?? ""
//            )
//        }
//        for (_, obj) in groupIDs.enumerated() {
//            let channelId = CMQTTUSERTOPIC + obj.key
//            MIMQTT.shared().messagePaylaod(
//                arrUser: obj.value,
//                channelId: channelId,
//                message: forwardMsg.message,
//                messageType: .text,
//                chatType: .group,
//                groupID: obj.key,
//                forwardedMsgId: forwardMsg.message_id ?? ""
//            )
//        }
//
//        self.navigationController?.popViewController(animated: true)
//    }
//
//    func forwardMediaToUsers(msgType : MessageType,users: [MDLCloneMedia], groups: [MDLCloneMedia]) {
//
//        for userObj in users {
//            let channelId = CMQTTUSERTOPIC + userObj.userId
//            MIMQTT.shared().messagePaylaod(
//                arrUser: ["\(appDelegate.loginUser?.user_id ?? 0)",userObj.userId],
//                channelId: channelId,
//                message: userObj.imageUrl,
//                messageType: msgType, chatType: .user,
//                groupID: nil,
//                forwardedMsgId: forwardMsg.message_id ?? "",
//                cloleFile: userObj
//            )
//        }
//
//        for groupObj in groups {
//            let channelId = CMQTTUSERTOPIC + groupObj.groupId
//            MIMQTT.shared().messagePaylaod(
//                arrUser: groupObj.groupUsersIds,
//                channelId: channelId,
//                message: groupObj.imageUrl,
//                messageType: msgType,
//                chatType: .group,
//                groupID: groupObj.groupId,
//                forwardedMsgId: forwardMsg.message_id ?? "",
//                cloleFile: groupObj
//            )
//        }
//        self.navigationController?.popViewController(animated: true)
//    }
//
//    func forwardSharedLocationToUsers(msgType : MessageType,users: [MDLCloneMedia], groups: [MDLCloneMedia]) {
//
//        for userObj in users {
//            let channelId = CMQTTUSERTOPIC + userObj.userId
//            MIMQTT.shared().messagePaylaod(
//                arrUser: ["\(appDelegate.loginUser?.user_id ?? 0)",
//                userObj.userId],
//                channelId: channelId,
//                message: userObj.imageUrl,
//                messageType: msgType,
//                chatType: .user,
//                groupID: nil,
//                latitude: self.forwardMsg.latitude,
//                longitude: self.forwardMsg.longitude,
//                address: self.forwardMsg.address ?? "",
//                forwardedMsgId:forwardMsg.message_id ?? "",
//                cloleFile: userObj
//            )
//        }
//
//        for groupObj in groups {
//            let channelId = CMQTTUSERTOPIC + groupObj.groupId
//            MIMQTT.shared().messagePaylaod(
//                arrUser: groupObj.groupUsersIds,
//                channelId: channelId,
//                message: groupObj.imageUrl,
//                messageType: msgType,
//                chatType: .group,
//                groupID: groupObj.groupId,
//                latitude: self.forwardMsg.latitude,
//                longitude: self.forwardMsg.longitude,
//                address: self.forwardMsg.address ?? "",
//                forwardedMsgId: forwardMsg.message_id ?? "",
//                cloleFile: groupObj
//            )
//        }
//        self.navigationController?.popViewController(animated: true)
//    }
//}
//
// //MARK: - UISearchBarDelegate
//extension ForwardViewController: UISearchBarDelegate {
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.endEditing(true)
//        searchTextInFile("")
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        searchTextInFile(searchText)
//    }
//
//    func searchTextInFile(_ searchText:String){
//
//        if self.forwardPageVC?.currentIndex == 0{
//            if self.singleUserVC?.txtSearch != searchText{
//                self.singleUserVC?.txtSearch = searchText
//            }
//        }else if self.forwardPageVC?.currentIndex == 1{
//
//            if self.groupUserVC?.txtSearch != searchText{
//                self.groupUserVC?.txtSearch = searchText
//            }
//        }
//    }
//}
//
//// MARK: - PageViewControllerDelegate
//extension ForwardViewController : ForwardPageViewControllerDelegate {
//
//    func changedController(index: Int) {
//        sementView.selectedSegmentIndex = index
//    }
//}
//
//// MARK: - ScrollableSegmentDelegate
//extension ForwardViewController : SegmentViewDelegate {
//
//    func didSelectSegmentAt(index: Int) {
//
//        guard index != self.forwardPageVC?.currentIndex else {
//            return
//        }
//        self.forwardPageVC?.setViewControllerAt(index: index)
//        if index == 0 {
//            self.searchBar.text = self.singleUserVC?.txtSearch
//        } else if index == 1 {
//            self.searchBar.text = self.groupUserVC?.txtSearch
//        }
//    }
//}
//
////MARK: - Action Events
//extension ForwardViewController {
//
//    @IBAction func onSendPressed(_ sender: UIButton) {
//
//        guard let singleUserVC = self.singleUserVC else {
//            return
//        }
//        guard let groupListVC = self.groupUserVC else {
//            return
//        }
//        guard let msgType = MessageType(rawValue: Int(forwardMsg.msg_type)) else {
//            return
//        }
//
//        let userIDs = singleUserVC.arrFriends.filter({$0.isSelected}).compactMap({$0.userId})
//
//        var groupIDs : [String:[String]] = [:]
//        _ = groupListVC.arrFriends.filter({$0.isSelected}).compactMap { (obj) -> Void in
//            if !obj.groupUsersId.isEmpty {
//                groupIDs[obj.id.toString] = obj.groupUsersId
//            }
//        }
//        //print("groupIDs : \(groupIDs)")
//
//        switch msgType {
//        case .text :
//            self.forwardMessageToUsers(usersIDs: userIDs, groupIDs: groupIDs)
//            break
//        case .image, .video, .location :
//            self.cloneFile(msgType: msgType, usersIDs: userIDs, groupsIDs: groupIDs)
//            break
//        case .audio :
//            self.cloneFile(msgType: .audio, usersIDs: userIDs, groupsIDs: groupIDs)
//            break
//        }
//    }
//}
//
////MARK: - APIs Calling
//extension ForwardViewController {
//
//    fileprivate func cloneFile(msgType : MessageType, usersIDs: [Int], groupsIDs:[String:[String]] ) {
//
//        var request = [String : Any]()
//        request["msg_id"] = self.forwardMsg.message_id ?? ""
//        request["user_ids"] = usersIDs.map({$0.description}).joined(separator: ",")
//        request["group_ids"] = groupsIDs.compactMap({$0.key}).joined(separator: ",")
//        print("Request : \(request)")
//
//        APIRequest.shared().cloneFile(param: request, showLoader: true) {[weak self] (response, error) in
//
//            guard let _ = self else { return }
//            guard let _response = response as? [String :Any] else { return }
//            print(_response)
//
//
//            let data = _response["data"] as? [String:Any] ?? [:]
//
//            let user = data["user"] as? [String:Any] ?? [:]
//            var imgUsers = user["images"] as? [[String:Any]] ?? []
//            var validIDs = user["valid_ids"] as? String ?? ""
//            validIDs = validIDs.replacingOccurrences(of: " ", with: "")
//            var arrUserIds = validIDs.components(separatedBy: ",")
//            if validIDs.isEmpty {arrUserIds = [] }
//            var arrUser : [MDLCloneMedia] = []
//            for (index, element) in arrUserIds.enumerated() {
//                arrUser.append(MDLCloneMedia(fromJson: imgUsers[index], userId: element,localMediaUrl: self?.forwardMsg.localMediaUrl))
//            }
//
//            let group = data["group"] as? [String:Any] ?? [:]
//            imgUsers = group["images"] as? [[String:Any]] ?? []
//            validIDs = group["valid_ids"] as? String ?? ""
//            validIDs = validIDs.replacingOccurrences(of: " ", with: "")
//            arrUserIds = validIDs.components(separatedBy: ",")
//            if validIDs.isEmpty {arrUserIds = [] }
//            var arrGroup : [MDLCloneMedia] = []
//            for (index, element) in arrUserIds.enumerated() {
//                arrGroup.append(
//                    MDLCloneMedia(
//                        fromJson: imgUsers[index],
//                        groupId: element,
//                        groupUsersIds: groupsIDs[element] ?? [],
//                        localMediaUrl: self?.forwardMsg.localMediaUrl
//                    )
//                )
//            }
//
//            switch msgType {
//            case .location :
//                self?.forwardSharedLocationToUsers(msgType: msgType, users: arrUser, groups: arrGroup)
//                break
//            default :
//                self?.forwardMediaToUsers(msgType: msgType, users: arrUser, groups: arrGroup)
//            }
//        }
//    }
//}
/**********************NEW CODE **********************************/
import UIKit

class ForwardViewController: ParentViewController {

    @IBOutlet weak var vwSegment: UIView!
    @IBOutlet weak var btnSend: UIButton!{
        didSet{
            btnSend.isEnabled = false
        }
    }
    
    /// Custome Segemtn for Single and Groups
    weak var sementView: SegmentView!
    
    /// it's contain SingleUserForwardViewController and GroupForwardViewController
    weak var forwardPageVC : ForwardPageViewController?
    
    /// searchBar for search files in list
    fileprivate var searchBar = UISearchBar()
    /// searchBarItem is used search file
    fileprivate var searchBarItem : UIBarButtonItem!
    /// cancelBarItem is used to cancel the searchBar
    fileprivate var cancelBarItem : UIBarButtonItem!
    
    weak var singleUserVC :  SingleUserForwardViewController?
    weak var groupUserVC : GroupForwardViewController?
    var maxSelection : Int = 5
    
    var msgidUsertItems:[String] = []
    
    var usrCharinfo:Bool?
    var forwardMsg : TblMessages!
    
    var forwaordCallBack : ((Bool) -> Void)?
    var msgCount = 1
    
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Forward"
        Initialization()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.forwaordCallBack?(true)
    }
    
    /// PageViewController controller embed with this controller
    /// - Parameters:
    ///   - segue: segue type and identifier
    ///   - sender: sender object
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let pageController = segue.destination as? ForwardPageViewController {
            self.forwardPageVC = pageController
        }
    }
    deinit {
        print("deinit -> ForwardViewController")
    }
}

//MARK: - Initialization
extension ForwardViewController {
    
    func Initialization() {
        addBarButtonItems()
        /// Confiure PageViewController
        self.forwardPageVC?.mForwardDelegate = self
        singleUserVC = CStoryboardForward.instantiateViewController(withIdentifier: "SingleUserForwardViewController") as? SingleUserForwardViewController
        
        groupUserVC = CStoryboardForward.instantiateViewController(withIdentifier: "GroupForwardViewController") as? GroupForwardViewController
        
        let arrPage : [UIViewController] = [singleUserVC!, groupUserVC!]
        self.forwardPageVC?.config(controllers: arrPage)
        if sementView != nil {
            sementView.removeFromSuperview()
        }
        
        /// Confiure custome segment controller
        sementView = SegmentView.viewFromXib as? SegmentView
        sementView.delegate = self
        sementView.translatesAutoresizingMaskIntoConstraints = false
        vwSegment.addSubview(sementView)
        NSLayoutConstraint.activate([
            sementView.leftAnchor.constraint(equalTo: vwSegment.leftAnchor, constant: 0),
            sementView.rightAnchor.constraint(equalTo: vwSegment.rightAnchor, constant: 0),
            sementView.topAnchor.constraint(equalTo: vwSegment.topAnchor, constant: 0),
            sementView.bottomAnchor.constraint(equalTo: vwSegment.bottomAnchor, constant: 0)
        ])
        
        let myFile : SegmentText = SegmentText.viewFromXib as! SegmentText
        myFile.lblText.text = CNavFriends
        let sharedFile : SegmentText = SegmentText.viewFromXib as! SegmentText
        sharedFile.lblText.text = CSideGroups
        sementView.addSubItems(arrViews: [myFile,sharedFile])
        sementView.selectedSegmentIndex = 0
    }
    
    // Created Right bar button...
    fileprivate func addBarButtonItems() {
        ///... For Searching
        self.searchBarItem = BlockBarButtonItem(image: UIImage(named: "ic_btn_search"), style: .plain) { [weak self] (_) in
            guard let _ = self else {return}
            self?.navigationItem.titleView = self?.searchBar
            UIView.animate(withDuration: 0.5, animations: {
                self?.searchBar.alpha = 1
            }, completion: { finished in
                self?.searchBar.becomeFirstResponder()
            })
            self?.navigationItem.rightBarButtonItems = []
            self?.navigationItem.rightBarButtonItem = self?.cancelBarItem
        }
        self.navigationItem.rightBarButtonItems = [searchBarItem]
        ///... For Cancel Search
        self.cancelBarItem = BlockBarButtonItem(title: CBtnCancel, style: .plain, actionHandler: { [weak self] (item) in
            guard let _ = self else {return}
            self?.searchBar.endEditing(true)
            UIView.animate(withDuration: 0.5, animations: {
                self?.searchBar.alpha = 0
            }, completion: { finished in
                self?.setCancelBarButton()
            })
        })
        
        searchBar.alpha = 0
        searchBar.placeholder = CSearch
        searchBar.tintColor = .black
        searchBar.change(textFont: CFontPoppins(size: (14 * CScreenWidth)/375, type: .regular))
        searchBar.delegate = self
    }
    
    func setCancelBarButton(){
        self.navigationItem.titleView = nil
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.rightBarButtonItems = [self.searchBarItem] as? [UIBarButtonItem] ?? []
    }
}
//MARK: - ForwardMessages
extension ForwardViewController {
    func forwardMessageToUsers(usersIDs: [Int], groupIDs:[String:[String]]) {
        for userId in usersIDs {
            let channelId = CMQTTUSERTOPIC + "\(userId)"
            MIMQTT.shared().messagePaylaod(
                arrUser: ["\(appDelegate.loginUser?.user_id ?? 0)", "\(userId)"],
                channelId: channelId,
                message: forwardMsg.message,
                messageType: .text,
                chatType: .user,
                groupID: nil,
                forwardedMsgId: forwardMsg.message_id ?? "", is_auto_delete: 0
            )
        }
        for (_, obj) in groupIDs.enumerated() {
            let channelId = CMQTTUSERTOPIC + obj.key
            MIMQTT.shared().messagePaylaod(
                arrUser: obj.value,
                channelId: channelId,
                message: forwardMsg.message,
                messageType: .text,
                chatType: .group,
                groupID: obj.key,
                forwardedMsgId: forwardMsg.message_id ?? "", is_auto_delete: 0
            )
        }
        if msgCount == msgidUsertItems.count{
            self.navigationController?.popViewController(animated: true)
        }
        if msgCount == 0{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func forwardMediaToUsers(msgType : MessageType,users: [MDLCloneMedia], groups: [MDLCloneMedia]) {
        for userObj in users {
            let channelId = CMQTTUSERTOPIC + userObj.userId
            MIMQTT.shared().messagePaylaod(
                arrUser: ["\(appDelegate.loginUser?.user_id ?? 0)",userObj.userId],
                channelId: channelId,
                message: userObj.imageUrl,
                messageType: msgType, chatType: .user,
                groupID: nil,
                forwardedMsgId: forwardMsg.message_id ?? "",
                cloleFile: userObj, is_auto_delete: 0
            )
        }
        
        for groupObj in groups {
            let channelId = CMQTTUSERTOPIC + groupObj.groupId
            MIMQTT.shared().messagePaylaod(
                arrUser: groupObj.groupUsersIds,
                channelId: channelId,
                message: groupObj.imageUrl,
                messageType: msgType,
                chatType: .group,
                groupID: groupObj.groupId,
                forwardedMsgId: forwardMsg.message_id ?? "",
                cloleFile: groupObj, is_auto_delete: 0
            )
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func forwardSharedLocationToUsers(msgType : MessageType,users: [MDLCloneMedia], groups: [MDLCloneMedia]) {
        for userObj in users {
            let channelId = CMQTTUSERTOPIC + userObj.userId
            MIMQTT.shared().messagePaylaod(
                arrUser: ["\(appDelegate.loginUser?.user_id ?? 0)",
                userObj.userId],
                channelId: channelId,
                message: userObj.imageUrl,
                messageType: msgType,
                chatType: .user,
                groupID: nil,
                latitude: self.forwardMsg.latitude,
                longitude: self.forwardMsg.longitude,
                address: self.forwardMsg.address ?? "",
                forwardedMsgId:forwardMsg.message_id ?? "",
                cloleFile: userObj, is_auto_delete: 0
            )
        }
        for groupObj in groups {
            let channelId = CMQTTUSERTOPIC + groupObj.groupId
            MIMQTT.shared().messagePaylaod(
                arrUser: groupObj.groupUsersIds,
                channelId: channelId,
                message: groupObj.imageUrl,
                messageType: msgType,
                chatType: .group,
                groupID: groupObj.groupId,
                latitude: self.forwardMsg.latitude,
                longitude: self.forwardMsg.longitude,
                address: self.forwardMsg.address ?? "",
                forwardedMsgId: forwardMsg.message_id ?? "",
                cloleFile: groupObj, is_auto_delete: 0
            )
        }
        self.navigationController?.popViewController(animated: true)
    }
}

 //MARK: - UISearchBarDelegate
extension ForwardViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchTextInFile("")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTextInFile(searchText)
    }
    
    func searchTextInFile(_ searchText:String){
        if self.forwardPageVC?.currentIndex == 0{
            if self.singleUserVC?.txtSearch != searchText{
                self.singleUserVC?.txtSearch = searchText
            }
        }else if self.forwardPageVC?.currentIndex == 1{
            if self.groupUserVC?.txtSearch != searchText{
                self.groupUserVC?.txtSearch = searchText
            }
        }
    }
}

// MARK: - PageViewControllerDelegate
extension ForwardViewController : ForwardPageViewControllerDelegate {
    func changedController(index: Int) {
        sementView.selectedSegmentIndex = index
    }
}

// MARK: - ScrollableSegmentDelegate
extension ForwardViewController : SegmentViewDelegate {
    func didSelectSegmentAt(index: Int) {
        guard index != self.forwardPageVC?.currentIndex else {
            return
        }
        self.forwardPageVC?.setViewControllerAt(index: index)
        if index == 0 {
            self.searchBar.text = self.singleUserVC?.txtSearch
        } else if index == 1 {
            self.searchBar.text = self.groupUserVC?.txtSearch
        }
    }
}

//MARK: - Action Events
extension ForwardViewController {
    
    @IBAction func onSendPressed(_ sender: UIButton) {
        if usrCharinfo == true {
            for messageCount in msgidUsertItems{
                if messageCount.count > 0 {
                    for msArrayid in msgidUsertItems{
                        if let arrMessages = TblMessages.fetchAllObjects() as? [TblMessages] {
                            for arrMsg in arrMessages{
                                if arrMsg.message_id == msArrayid{
                                    forwardMsg = arrMsg
                                    if msgidUsertItems.count == 1{
                                    msgCount = 0
                                    }else {
                                        msgCount = msgCount+1
                                    }
                                    guard let singleUserVC = self.singleUserVC else {
                                        return
                                    }
                                    guard let groupListVC = self.groupUserVC else {
                                        return
                                    }
                                    guard let msgType = MessageType(rawValue: Int(forwardMsg.msg_type)) else {
                                        return
                                    }
                                    let userIDs = singleUserVC.arrFriends.filter({$0.isSelected}).compactMap({$0.userId})
                                    
                                    var groupIDs : [String:[String]] = [:]
                                    _ = groupListVC.arrFriends.filter({$0.isSelected}).compactMap { (obj) -> Void in
                                        if !obj.groupUsersId.isEmpty {
                                            groupIDs[obj.id.toString] = obj.groupUsersId
                                        }
                                    }
                                    //print("groupIDs : \(groupIDs)")
                                    switch msgType {
                                    case .text :
                                        self.forwardMessageToUsers(usersIDs: userIDs, groupIDs: groupIDs)
                                        break
                                    case .image, .video, .location :
                                        self.cloneFile(msgType: msgType, usersIDs: userIDs, groupsIDs: groupIDs)
                                        break
                                    case .audio :
                                        self.cloneFile(msgType: .audio, usersIDs: userIDs, groupsIDs: groupIDs)
                                        break
                                    }
//                                    forwardMsg.deleteObject()
                                }
                            }
                            
                        }
                    }
                }
                self.msgidUsertItems.removeAll()
            }
            }else {
            guard let singleUserVC = self.singleUserVC else {
                return
            }
            guard let groupListVC = self.groupUserVC else {
                return
            }
            guard let msgType = MessageType(rawValue: Int(forwardMsg.msg_type)) else {
                return
            }
            let userIDs = singleUserVC.arrFriends.filter({$0.isSelected}).compactMap({$0.userId})
            
            var groupIDs : [String:[String]] = [:]
            _ = groupListVC.arrFriends.filter({$0.isSelected}).compactMap { (obj) -> Void in
                if !obj.groupUsersId.isEmpty {
                    groupIDs[obj.id.toString] = obj.groupUsersId
                }
            }
            //print("groupIDs : \(groupIDs)")
            switch msgType {
            case .text :
                self.forwardMessageToUsers(usersIDs: userIDs, groupIDs: groupIDs)
                break
            case .image, .video, .location :
                self.cloneFile(msgType: msgType, usersIDs: userIDs, groupsIDs: groupIDs)
                break
            case .audio :
                self.cloneFile(msgType: .audio, usersIDs: userIDs, groupsIDs: groupIDs)
                break
            }
        }
    }
}

//MARK: - APIs Calling
extension ForwardViewController {
    
    fileprivate func cloneFile(msgType : MessageType, usersIDs: [Int], groupsIDs:[String:[String]] ) {
        var request = [String : Any]()
        request["msg_id"] = self.forwardMsg.message_id ?? ""
        request["user_ids"] = usersIDs.map({$0.description}).joined(separator: ",")
        request["group_ids"] = groupsIDs.compactMap({$0.key}).joined(separator: ",")
//        APIRequest.shared().cloneFile(param: request, showLoader: true) {[weak self] (response, error) in
//            
//            guard let _ = self else { return }
//            guard let _response = response as? [String :Any] else { return }
//            print(_response)
//            let data = _response["data"] as? [String:Any] ?? [:]
//            let user = data["user"] as? [String:Any] ?? [:]
//            var imgUsers = user["images"] as? [[String:Any]] ?? []
//            var validIDs = user["valid_ids"] as? String ?? ""
//            validIDs = validIDs.replacingOccurrences(of: " ", with: "")
//            var arrUserIds = validIDs.components(separatedBy: ",")
//            if validIDs.isEmpty {arrUserIds = [] }
//            var arrUser : [MDLCloneMedia] = []
//            for (index, element) in arrUserIds.enumerated() {
//                arrUser.append(MDLCloneMedia(fromJson: imgUsers[index], userId: element,localMediaUrl: self?.forwardMsg.localMediaUrl))
//            }
//            
//            let group = data["group"] as? [String:Any] ?? [:]
//            imgUsers = group["images"] as? [[String:Any]] ?? []
//            validIDs = group["valid_ids"] as? String ?? ""
//            validIDs = validIDs.replacingOccurrences(of: " ", with: "")
//            arrUserIds = validIDs.components(separatedBy: ",")
//            if validIDs.isEmpty {arrUserIds = [] }
//            var arrGroup : [MDLCloneMedia] = []
//            for (index, element) in arrUserIds.enumerated() {
//                arrGroup.append(
//                    MDLCloneMedia(
//                        fromJson: imgUsers[index],
//                        groupId: element,
//                        groupUsersIds: groupsIDs[element] ?? [],
//                        localMediaUrl: self?.forwardMsg.localMediaUrl
//                    )
//                )
//            }
//            
//            switch msgType {
//            case .location :
//                self?.forwardSharedLocationToUsers(msgType: msgType, users: arrUser, groups: arrGroup)
//                break
//            default :
//                self?.forwardMediaToUsers(msgType: msgType, users: arrUser, groups: arrGroup)
//            }
//        }
    }
}
