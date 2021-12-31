//
//  GroupsViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 30/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class GroupsViewController: ParentViewController {
    
    @IBOutlet weak var tblGroups : UITableView!
    var arrGroupList = [TblChatGroupList]()
    var arrGroupSearchList = [TblChatGroupList]()
    var refreshControl = UIRefreshControl()
    var apiTask : URLSessionTask?
    var groupType = CGroupTypePublic
    var isSearch : Bool = false
    @IBOutlet weak var lblNoData : UILabel!
    
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
        MIMQTT.shared().mqttDelegate = self
        self.fetchGroupListFromLocal()
        self.getGroupListFromServer(isNew: true)
    }
    
    
    // MARK:- --------- Initialization
    
    func Initialization(){
        self.title = CSideGroups
        lblNoData.text = CMessageNoGroupList
        
        //        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_add_event"), style: .plain, target: self, action: #selector(btnAddClicked(_:)))
        
        //NEW CODE
        btnfrdsList = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_add_event"), style: .plain, target: self, action: #selector(btnAddClicked(_:)))
        
        
        self.searchBarItem = BlockBarButtonItem(image: UIImage(named: "ic_btn_search"), style: .plain) { [weak self] (_) in
            guard let _ = self else {return}
            self?.navigationItem.titleView = self?.searchBar
            UIView.animate(withDuration: 0.1, animations: {
                self?.searchBar.alpha = 1
                //                self?.searchBar.searchTextField.clearButtonMode = .never
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
            self.tblGroups.pullToRefreshControl = self.refreshControl
        }
        
        /*//...Will be show alert when user come in this screen from click on group link
         if groupType == CGroupTypePrivate {
         self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CJoinPrivateGroupMsg, btnOneTitle: CBtnOk, btnOneTapped: nil)
         }*/
    }
    
    func setCancelBarButton(){
        self.navigationItem.titleView = nil
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.rightBarButtonItems = [self.searchBarItem,self.btnfrdsList] as? [UIBarButtonItem] ?? []
        self.tblGroups.reloadData()
    }
    
}

// MARK:- --------- MQTTDelegate
extension GroupsViewController: MQTTDelegate {
    func didReceiveMessage(_ message: [String : Any]?) {
        // Update chat list table from local..
        if appDelegate.getTopMostViewController().isKind(of: GroupsViewController.classForCoder()) {
            GCDMainThread.asyncAfter(deadline: .now() + 2) {
                
                if message?.valueForInt(key: CPublishType) == CPUBLISHMESSAGETYPE {
                    let groupID = message?.valueForInt(key: CGroupId)
                    
                    if let arrGroups = TblChatGroupList.fetch(predicate: NSPredicate(format: "\(CGroupId) == \(groupID ?? 0)")) as? [TblChatGroupList] {
                        
                        if arrGroups.count > 0 {
                            let groupInfo = arrGroups.first
                            groupInfo?.last_message = message?.valueForString(key: CMessage)
                            groupInfo?.msg_type = Int16(message?.valueForInt(key: CMsg_type) ?? 0)
                            
                            // If sender is not login user then only increase count..
                            if Int64(message?.valueForString(key: CSender_Id) ?? "0") != appDelegate.loginUser?.user_id {
                                groupInfo?.unread_count += 1
                            }
                            
                            groupInfo?.datetime = message?.valueForDouble(key: CCreated_at) ?? 0.0
                            groupInfo?.chat_time = DateFormatter.shared().ConvertGMTMillisecondsTimestampToLocalTimestamp(timestamp: groupInfo?.datetime ?? 0.0/1000) ?? 0.0
                            CoreData.saveContext()
                            self.fetchGroupListFromLocal()
                        }
                    }
                }else {
                    self.getGroupListFromServer(isNew: true)
                }
            }
        }
    }
    
    func didDeletedGroup(_ message: [String : Any]?) {
        // New Group/ Add member
        if message?.valueForInt(key: CJsonStatus) == 0 || message?.valueForInt(key: CJsonStatus) == 3 {
            // New Group
            self.pullToRefresh()
        }else {
            // Delete Group
            if let groupID = message?.valueForInt(key: CGroupId) {
                // Delete object from core data..
                TblChatGroupList.deleteObjects(predicate: NSPredicate(format: "\(CGroupId) == \(groupID)"))
                CoreData.saveContext()
                self.fetchGroupListFromLocal()
            }
        }
        
    }
}


// MARK:- --------- Api Functions
extension GroupsViewController {
    @objc func pullToRefresh() {
        refreshControl.beginRefreshing()
        self.getGroupListFromServer(isNew: true)
    }
    
    
    func getGroupListFromServer(isNew : Bool) {
        
        if apiTask?.state == URLSessionTask.State.running {
            return
        }
        guard let userid = appDelegate.loginUser?.user_id else {return}
        self.tblGroups.tableFooterView = nil
        var apiTimeStamp : Double = 0
        
//        if !isNew {
//            // When need old data...
//            if let chatInfo = MIGeneralsAPI.shared().fetchChatGroupObjectFromLocal(isNew: !isNew) {
//                apiTimeStamp = chatInfo.datetime
//                self.tblGroups.tableFooterView = self.loadMoreIndicator(ColorAppTheme)
//            }
//        }
        apiTask = APIRequest.shared().getGroupChatList(timestamp: apiTimeStamp,search:userid.description , showLoader: true) { [weak self] (response, error) in
            guard let self = self else { return }
            if response != nil {
                
                self.refreshControl.endRefreshing()
                self.tblGroups.tableFooterView = nil
                
                if let arrList = response![CJsonData] as? [[String:Any]] {
                    if arrList.count > 0 {
                        self.fetchGroupListFromLocal()
                    }
                    if arrList.isEmpty{
                        self.arrGroupList.removeAll()
                        self.tblGroups.reloadData()
                    }
                    DispatchQueue.main.async {
                        self.lblNoData.isHidden = self.arrGroupList.count > 0
                    }
                }
            }
        }
    }
    
    func fetchGroupListFromLocal() {
        if let arr = TblChatGroupList.fetch(predicate: nil, orderBy: CDateTime, ascending: false) as? [TblChatGroupList] {
            self.arrGroupList.removeAll()
            self.arrGroupList = arr
            self.tblGroups.reloadData()
        }
    }
}

// MARK:- --------- UITableView Datasources/Delegate
extension GroupsViewController : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //return arrGroupList.count
        //NEW CODE
        if(isSearch) {
            if self.arrGroupSearchList.isEmpty{
                self.tblGroups.setEmptyMessage(CThereIsNoOnGoingChat)
            }else{
                self.tblGroups.restore()
            }
            return arrGroupSearchList.count
        }else{
            if self.arrGroupList.isEmpty{
                self.tblGroups.setEmptyMessage(CThereIsNoOnGoingChat)
            }else{
                self.tblGroups.restore()
            }
            return arrGroupList.count
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ChatUserListTblCell", for: indexPath) as? ChatUserListTblCell {
            
            let groupInfo = arrGroupList[indexPath.row]
            if (isSearch)    {
                let groupInfo = arrGroupSearchList[indexPath.row]
                cell.groupChatCellConfiguration(groupInfo)
            }
            else {
                let groupInfo = arrGroupList[indexPath.row]
                cell.groupChatCellConfiguration(groupInfo)
            }
            cell.btnMemberInfo.touchUpInside { [weak self] (sender) in
                guard let _ = self else { return }
                
                let grpInfo = groupInfo.dictionaryWithValues(forKeys: Array((groupInfo.entity.attributesByName.keys)))
                if let groupMemberVC = CStoryboardGroup.instantiateViewController(withIdentifier: "GroupMemberRequestViewController") as? GroupMemberRequestViewController {
                    groupMemberVC.iObject = grpInfo
                    self?.navigationController?.pushViewController(groupMemberVC, animated: true)
                }
            }
            /*
             Show Group info
             NEW CODE
             */
            
            //imageButtonClick
            cell.btngroupInfo.touchUpInside { [weak self] (sender) in
                guard let _ = self else { return }
                let grpInfo = groupInfo.dictionaryWithValues(forKeys: Array((groupInfo.entity.attributesByName.keys)))
                if let groupMemberVC = CStoryboardGroup.instantiateViewController(withIdentifier: "GroupInfoViewController") as? GroupInfoViewController {
                    groupMemberVC.iObject = grpInfo
                    self?.navigationController?.pushViewController(groupMemberVC, animated: true)
                }
            }
            // LOAD MORE DATA..........
//            if indexPath == tblGroups.lastIndexPath(){
//            self.getGroupListFromServer(isNew: false)
//            }
            return cell
        }
        
        return tableView.tableViewDummyCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let groupInfo = arrGroupList[indexPath.row]
        
        if let groupChatDetailsVC = CStoryboardGroup.instantiateViewController(withIdentifier: "GroupChatDetailsViewController") as? GroupChatDetailsViewController {
            let grpInfo = groupInfo.dictionaryWithValues(forKeys: Array((groupInfo.entity.attributesByName.keys)))
            groupChatDetailsVC.setBlock { [weak self] (object, message) in
                self?.getGroupListFromServer(isNew: true)
            }
            
            if let grpID = groupInfo.group_id{
                groupChatDetailsVC.group_id = grpID
            }
            groupChatDetailsVC.iObject = grpInfo
            groupChatDetailsVC.groupInfo = grpInfo
            
            groupChatDetailsVC.isCreateNewChat = false
            self.navigationController?.pushViewController(groupChatDetailsVC, animated: true)
        }
        
    }
    
}

// MARK:- ------------ Action Event
extension GroupsViewController{
    
    @objc fileprivate func btnAddClicked(_ sender : UIBarButtonItem) {
        
        if let createGroupVC = CStoryboardGroup.instantiateViewController(withIdentifier: "CreateChatGroupViewController") as? CreateChatGroupViewController {
            createGroupVC.setBlock { [weak self] (object, message) in
                self?.getGroupListFromServer(isNew: true)
            }
            self.navigationController?.pushViewController(createGroupVC, animated: true)
        }
    }
}

extension GroupsViewController: UISearchBarDelegate{
    //MARK: UISearchbar delegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearch = false
        arrGroupSearchList.removeAll()
        self.tblGroups.reloadData()
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        isSearch = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //           searchBar.resignFirstResponder()
        searchBar.text = ""
        isSearch = false
        arrGroupSearchList.removeAll()
        self.tblGroups.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        isSearch = false
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            isSearch = false
            view.endEditing(true)
            tblGroups.reloadData()
        }else{
            isSearch = true
            arrGroupSearchList = arrGroupList.filter() {
                let strGameName = $0.group_title
                let stringToCompare = searchBar.text!
                if let range = strGameName?.range(of: stringToCompare) {
                    isSearch = false
                    return true
                } else {
                    isSearch = true
                    return false
                }
            }
            tblGroups.reloadData()
        }
//                if searchText.count == 0 {
//                    isSearch = false
//                    self.tblGroups.reloadData()
//                } else {
//                    arrGroupSearchList = arrGroupList.filter({ (text) -> Bool in
//                        let tmp: NSString = (text.group_title ?? "") as NSString
//                        let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
//                        return range.location != NSNotFound
//                    })
//                    if(arrGroupSearchList.count == 0) || self.searchBar.text == ""{
//        //                print("this is calling count and empty")
//        //                MIToastAlert.shared.showToastAlert(position: .bottom, message: CMessageNoDataFound)
//        //
//                        isSearch = false
//                    } else {
//
//                        isSearch = true
//                    }
//                    self.tblGroups.reloadData()
//                }
    }
    
}
