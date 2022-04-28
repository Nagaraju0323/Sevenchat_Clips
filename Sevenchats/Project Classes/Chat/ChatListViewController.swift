//
//  ChatListViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 30/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//
/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : ChatListViewController                      *
 * Changes :                                             *
 * Chat Friends List                                    *
 ********************************************************/

import UIKit

class ChatListViewController: ParentViewController {
    
    @IBOutlet weak var viewImg: UIView!
    @IBOutlet var tblUserChat : UITableView!
    @IBOutlet weak var showImg: UIImageView!
    @IBOutlet weak var activeLbl: UILabel!
    var arrUserList = [TblChatUserList]()
    var arrUsersearchList = [TblChatUserList]()
    
    var refreshControl = UIRefreshControl()
    var apiTask : URLSessionTask?
    
    var isChangingOnlineOffline = false
    var isSearch : Bool = false
    
    /// searchBar for search files in list
    fileprivate var searchBar = UISearchBar()
    /// searchBarItem is used search file
    fileprivate var searchBarItem : UIBarButtonItem!
    /// cancelBarItem is used to cancel the searchBar
    fileprivate var cancelBarItem : UIBarButtonItem!
    
    fileprivate var btnfrdsList : UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialization()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getUserChatListFromServer(isNew: true)
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
      
    }
   
    //...Notficatin Response
    @objc func methodOfReceivedNotification(notification: Notification) {
           pullToRefresh()
       }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Stoped runnig api..
        if apiTask != nil {
            if apiTask!.state == .running {
                apiTask?.cancel()
            }
        }  
    }
    
    // MARK:- --------- Initialization
    func Initialization(){
        self.title = CNavChats
        btnfrdsList = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_chat_white"), style: .plain, target: self, action: #selector(btnAddClicked(_:)))
        
        
        self.searchBarItem = BlockBarButtonItem(image: UIImage(named: "ic_btn_search"), style: .plain) { [weak self] (_) in
            guard let _ = self else {return}
            self?.navigationItem.titleView = self?.searchBar
            UIView.animate(withDuration: 0.1, animations: {
                self?.searchBar.alpha = 1
            }, completion: { finished in
                self?.searchBar.becomeFirstResponder()
            })
            self?.navigationItem.rightBarButtonItems = []
            self?.navigationItem.rightBarButtonItem = self?.cancelBarItem
        }
        self.navigationItem.rightBarButtonItems = [searchBarItem,btnfrdsList]
        ///... For Cancel Search
        self.cancelBarItem = BlockBarButtonItem(title: CBtnCancel, style: .plain, actionHandler: { [weak self] (item) in
            guard let _ = self else {return}
            self?.searchBar.endEditing(true)
            UIView.animate(withDuration: 0.1, animations: {
                self?.searchBar.alpha = 0
                self?.searchBar.text = ""
            }, completion: { finished in
                self?.setCancelBarButton()
            })
        })
        
        searchBar.alpha = 0
        searchBar.placeholder = CSearch
        searchBar.tintColor = .black
        searchBar.change(textFont: CFontPoppins(size: (14 * CScreenWidth)/375, type: .regular))
        searchBar.delegate = self
        
        
        GCDMainThread.async {
            self.refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
            self.refreshControl.tintColor = ColorAppTheme
            self.tblUserChat.pullToRefreshControl = self.refreshControl
        }
    }
    
    func setCancelBarButton(){
        self.navigationItem.titleView = nil
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.rightBarButtonItems = [self.searchBarItem,self.btnfrdsList] as? [UIBarButtonItem] ?? []
        self.tblUserChat.reloadData()
    }
    
}
// MARK:- --------- Api Functions
extension ChatListViewController {
    
    @objc fileprivate func pullToRefresh() {
        
        if apiTask != nil {
            if apiTask!.state == .running {
                return
            }
        }
        
        refreshControl.beginRefreshing()
        self.getUserChatListFromServer(isNew: true)
    }
    
    fileprivate func getUserChatListFromServer(isNew : Bool) {
        
        if apiTask != nil {
            if apiTask!.state == .running {
                apiTask?.cancel()
            }
        }
        
        var apiTimeStamp : Double = 0
        
//        if !isNew {
//            // When need old data...
//            if let chatInfo = MIGeneralsAPI.shared().fetchChatUserObjectFromLocal(isNew: !isNew) {
//                apiTimeStamp = chatInfo.created_at
//            }
//        }
        
        guard let userid = appDelegate.loginUser?.user_id else {return}
        let userID = String(userid)
        MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        
        apiTask = APIRequest.shared().getUserChatList(timestamp: apiTimeStamp, userID:userID,showLoader: false, completion: { (response, error) in
            self.refreshControl.endRefreshing()
            
            if response != nil {
                if let arrList = response![CJsonData] as? [[String : Any]] {
                    if arrList.count > 0 {
                        self.fetchUserListFromLocal()
                    }else {
                        self.fetchUserListFromLocal()
                    }
                }
            }
        })
    }
    
    func fetchUserListFromLocal() {
        if let arr = TblChatUserList.fetch(predicate: nil, orderBy: CCreated_at, ascending: false) as? [TblChatUserList] {
            self.arrUserList.removeAll()
            self.arrUserList = arr
            self.tblUserChat.reloadData()
        }
    }
}

// MARK:- --------- UITableView Datasources/Delegate
extension ChatListViewController : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(isSearch) {
            if self.arrUsersearchList.isEmpty{
                self.tblUserChat.setEmptyMessage(CThereIsNoOnGoingChat)
            }else{
                self.tblUserChat.restore()
            }
            return arrUsersearchList.count
            
        }else{
            if self.arrUserList.isEmpty{
                showImg.isHidden = false
                activeLbl.text = CMessageNoGroupList
                activeLbl.isHidden = false
                viewImg.isHidden = false
               // self.tblUserChat.setEmptyMessage(CThereIsNoOnGoingChat)
            }else{
                showImg.isHidden = true
                activeLbl.isHidden = true
                viewImg.isHidden = true
                self.tblUserChat.restore()
            }
            return arrUserList.count
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ChatUserListTblCell", for: indexPath) as? ChatUserListTblCell {
            
            let chatUserInfo = arrUserList[indexPath.row]
            if (isSearch) {
                let chatUserInfo = arrUsersearchList[indexPath.row]
                cell.userChatCellConfiguration(chatUserInfo)
                
            }
            else {
                let chatUserInfo = arrUserList[indexPath.row]
                cell.userChatCellConfiguration(chatUserInfo)
            }
            
            /*
             Redirect to th userprofile
             */
            cell.btnUserInfo.touchUpInside { [weak self] (sender) in
                guard let _ = self else { return }
                if let userDetailVC = CStoryboardProfile.instantiateViewController(withIdentifier: "OtherUserProfileViewController") as? OtherUserProfileViewController {
                    let chatInfo = chatUserInfo.dictionaryWithValues(forKeys: Array((chatUserInfo.entity.attributesByName.keys)))
                    userDetailVC.iObject = chatInfo
                    userDetailVC.userIDNew = chatInfo.valueForString(key: "user_id")
                    self?.navigationController?.pushViewController(userDetailVC, animated: true)
                }
            }
            /*
             LOAD MORE DATA...
             If not update online offline status.
             */
            if indexPath == tblUserChat.lastIndexPath() && !isChangingOnlineOffline {
               // self.getUserChatListFromServer(isNew: false)
            }
            return cell
        }
        return tableView.tableViewDummyCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatUserInfo = arrUserList[indexPath.row]
        if let userDetailVC = CStoryboardChat.instantiateViewController(withIdentifier: "UserChatDetailViewController") as? UserChatDetailViewController {
            let chatInfo = chatUserInfo.dictionaryWithValues(forKeys: Array((chatUserInfo.entity.attributesByName.keys)))
            userDetailVC.iObject = chatInfo
            userDetailVC.chatInfoNot = chatInfo
            userDetailVC.ChatListPage = true
            userDetailVC.userID = chatInfo.valueForString(key:"user_id").toInt
            userDetailVC.userIDuser = chatInfo.valueForString(key:CUserId)
            userDetailVC.userEmail = chatInfo.valueForString(key: "email")
            self.navigationController?.pushViewController(userDetailVC, animated: true)
        }
    }
    
}

// MARK:- ------------ Action Event
extension ChatListViewController{
    
    @objc fileprivate func btnAddClicked(_ sender : UIBarButtonItem) {
        if let chatFriendListVC = CStoryboardChat.instantiateViewController(withIdentifier: "ChatFriendViewController") as? ChatFriendViewController {
            self.navigationController?.pushViewController(chatFriendListVC, animated: true)
        }
    }
}
// MARK:- ------------ Search Delegate
extension ChatListViewController: UISearchBarDelegate{
    //MARK: UISearchbar delegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearch = false
        arrUsersearchList.removeAll()
        self.tblUserChat.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        isSearch = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        isSearch = false
        arrUsersearchList.removeAll()
        self.tblUserChat.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        isSearch = false
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            isSearch = false
            self.tblUserChat.reloadData()
        } else {
            arrUsersearchList = arrUserList.filter({ (text) -> Bool in
                let tmp: NSString = (text.first_name ?? "") as NSString
                let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                return range.location != NSNotFound
            })
            if(arrUsersearchList.count == 0) || self.searchBar.text == ""{
                isSearch = true
                arrUsersearchList = arrUserList.filter() {
                    let strGameName = $0.first_name
                    let stringToCompare = searchBar.text!
                    if let range = strGameName?.range(of: stringToCompare) {
                        isSearch = false
                        return true
                    } else {
                        isSearch = true
                        return false
                    }
                }
//                tblUserChat.reloadData()
            } else {
                isSearch = true
            }
            self.tblUserChat.reloadData()
        }
    }
    
}
