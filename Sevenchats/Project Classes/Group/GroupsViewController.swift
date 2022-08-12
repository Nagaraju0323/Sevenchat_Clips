
//
//  GroupsViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 30/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/********************************************************
 * Author :  Nagaraju K and Chandrika R                                *
 * Model  : GroupChat Messages                          *
 * options: Group Members Info                          *
 ********************************************************/

import UIKit

class GroupsViewController: ParentViewController {
    
    @IBOutlet weak var tblGroups : UITableView!
    
    
    @IBOutlet weak var viewImg: UIView!
    @IBOutlet weak var showImg: UIImageView!
    @IBOutlet weak var activeLbl: UILabel!
    
    var arrGroupList = [TblChatGroupList]()
    var arrGroupSearchList = [TblChatGroupList]()
    
    
   
    var arrUserList = [[String:Any]]()
    var arrUser : [[String:Any]] = [[:]] {
        didSet{
            self.arrUserList = arrUser
         
        }
    }
    
//    var arrUserList = [[String:Any]]()
//    var arrUser : [[String:Any]] = [[:]] {
//        didSet{
//            self.arrUserList = arrUser
//
//        }
//    }
    
    
    var refreshControl = UIRefreshControl()
    var apiTask : URLSessionTask?
    var groupType = CGroupTypePublic
    var isSearch : Bool = false
    var isLoadMoreCompleted =  false
    var txtSearch = ""
    var pageNumber = 1
    var pageNumberSearch = 1
    @IBOutlet weak var lblNoData : UILabel!
    
    
    /// searchBar for search files in list
    fileprivate var searchBar = UISearchBar()
    /// searchBarItem is used search file
    fileprivate var searchBarItem : UIBarButtonItem!
    /// cancelBarItem is used to cancel the searchBar
    fileprivate var cancelBarItem : UIBarButtonItem!
    
    fileprivate var btnfrdsList : UIBarButtonItem!
    
    fileprivate var helpInfo : UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialization()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.fetchGroupListFromLocal()
        pageNumber = 1
      
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        pageNumber = 1
        
    }
    
    
    
    // MARK:- --------- Initialization
    
    func Initialization(){
        self.title = CSideGroups
//      lblNoData.text = CMessageNoGroupList
        btnfrdsList = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_add_event"), style: .plain, target: self, action: #selector(btnAddClicked(_:)))
        
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
        helpInfo = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_info_tint"), style: .plain, target: self, action: #selector(btnHelpInfoClicked(_:)))
       
       self.navigationItem.rightBarButtonItems = [helpInfo,searchBarItem,btnfrdsList]
        
//        self.navigationItem.rightBarButtonItems = [searchBarItem,btnfrdsList]
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
        
        self.getGroupListFromServer(isNew: true,txtChange:false)
        
    }
    
    func setCancelBarButton(){
        self.navigationItem.titleView = nil
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.rightBarButtonItems = [self.searchBarItem,self.btnfrdsList] as? [UIBarButtonItem] ?? []
        searchBar.text = ""
        isSearch = false

        self.pageNumber = 1
                arrUserList.removeAll()
        self.getGroupListFromServer(isNew: false, txtChange: false)
//        arrUserList.removeAll()
        self.tblGroups.reloadData()
    }
    
    @objc fileprivate func btnHelpInfoClicked(_ sender : UIBarButtonItem){
        if let helpLineVC = CStoryboardHelpLine.instantiateViewController(withIdentifier: "HelpLineViewController") as? HelpLineViewController {
            helpLineVC.fromVC = "groupVC"
            self.navigationController?.pushViewController(helpLineVC, animated: true)
        }
        
    }
    
}
// MARK:- --------- Api Functions
extension GroupsViewController {
    @objc func pullToRefresh() {
        refreshControl.beginRefreshing()
        self.getGroupListFromServer(isNew: true,txtChange:false)
    }
    
    
//    func getGroupListFromServer(isNew : Bool) {
//
//        if apiTask?.state == URLSessionTask.State.running {
//            return
//        }
//        guard let userid = appDelegate.loginUser?.user_id else {return}
//        self.tblGroups.tableFooterView = nil
//        var apiTimeStamp : Double = 0
//        apiTask = APIRequest.shared().getGroupChatList(timestamp: apiTimeStamp,search:userid.description , showLoader: true) { [weak self] (response, error) in
//            guard let self = self else { return }
//            if response != nil {
//
//                self.refreshControl.endRefreshing()
//                self.tblGroups.tableFooterView = nil
//
//                if let arrList = response![CJsonData] as? [[String:Any]] {
//                    if arrList.count > 0 {
//                        self.fetchGroupListFromLocal()
//                    }
//                    if arrList.isEmpty{
//                        self.arrGroupList.removeAll()
//                        self.tblGroups.reloadData()
//                    }
//                    DispatchQueue.main.async {
//                        self.lblNoData.isHidden = self.arrGroupList.count > 0
//                    }
//                }
//            }
//        }
//    }
    
    
    func getGroupListFromServer(isNew : Bool,txtChange:Bool) {
        
        if apiTask?.state == URLSessionTask.State.running {
            return
        }
        
        self.tblGroups.tableFooterView = self.pageNumber > 2 ? self.loadMoreIndicator(ColorAppTheme) : UIView()
        guard let userid = appDelegate.loginUser?.user_id else {return}
        self.tblGroups.tableFooterView = nil
        let encryptUser = EncryptDecrypt.shared().encryptDecryptModel(userResultStr: userid.description ?? "")

        if txtChange == true {
            pageNumber = 1
        }
        var apiTimeStamp : Double = 0
        apiTask = APIRequest.shared().getGroupChatListNew(timestamp: apiTimeStamp,search:encryptUser.description , showLoader: true, page: pageNumber) { [weak self] (response, error) in
            guard let self = self else { return }
            if response != nil {
                
                self.refreshControl.endRefreshing()
                self.tblGroups.tableFooterView = nil
                
                if let arrList = response!["data"] as? [[String:Any]] {
                    if self.pageNumber == 1 {
                        self.arrUser.removeAll()
                        self.tblGroups.reloadData()
                    }
                    
                    self.isLoadMoreCompleted = self.arrUser.isEmpty
                    
                    // Add Data here...
                    if arrList.count > 0{
                        self.arrUser = self.arrUser + arrList
                        self.tblGroups.reloadData()
                        self.pageNumber += 1
                    }
                }
                
                
//                let itemsreponse = response?["groups"] as? [String : Any]
              
//                if let arrList = response?["data"] as? [[String:Any]]{
//
//                    // Remove all data here when page number == 1
////                    if self.pageNumber == 1{
////                        self.arrGroupList.removeAll()
//////                        self.tblGroups.reloadData()
//////                        self.fetchGroupListFromLocal()
////                        self.tblGroups.reloadData()
////                    }
////                    // Add Data here...
////                    if arrList.count > 0{
////                        self.fetchGroupListFromLocal()
//////                        self.tblGroups.reloadData()
////                        self.pageNumber += 1
////                    }
//
//
//
//                    if let arrList = response!["comments"] as? [[String:Any]] {
//                        if self.pageNumber == 1 {
//                            self.arrGroupList_New.removeAll()
//                            self.tblGroups.reloadData()
//                        }
//                        // Add Data here...
//                        if arrList.count > 0{
//                            self.arrGroupList_New = self.arrGroupList_New + arrList
//                            self.tblGroups.reloadData()
//                            self.pageNumber += 1
//                        }
//                    }
//
//
//
//                    //self.lblNoData.isHidden = self.arrUser.count > 0
//                }
            }
        }
    }
    
    
    
    func fetchGroupListFromLocal() {
        if let arr = TblChatGroupList.fetch(predicate: nil, orderBy: "group_title", ascending: false) as? [TblChatGroupList] {
//            if let arr = TblChatGroupList.fetch(predicate: nil, orderBy: CDateTime, ascending: false) as? [TblChatGroupList] {
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
        if(isSearch) {
            if self.arrUserList.isEmpty{
//                self.tblGroups.setEmptyMessage(CThereIsNoOnGoingChat)
                self.tblGroups.setImage(url: URL(string: "ic_2_onboarding_new.png")!)
                
            }else{
                self.tblGroups.restore()
            }
            return arrUserList.count
        }else{
            if self.arrUserList.isEmpty{
                showImg.isHidden = false
                activeLbl.text = CMessageNoGroupList
                activeLbl.isHidden = false
                viewImg.isHidden = false
//                self.tblGroups.setEmptyMessage(CThereIsNoOnGoingChat)
            }else{
                showImg.isHidden = true
                activeLbl.isHidden = true
                viewImg.isHidden = true
                self.tblGroups.restore()
                
            }
//            showImg.isHidden = true
//            activeLbl.isHidden = true
            return arrUserList.count
           
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ChatUserListTblCell", for: indexPath) as? ChatUserListTblCell {
            
            let groupInfo = arrUserList[indexPath.row]
            print("groupinfo\(groupInfo)")
            if (isSearch)    {
                let groupInfo = arrUserList[indexPath.row]
                
                cell.groupChatCellConfigurations(groupInfo)
            }
            else {
                let groupInfo = arrUserList[indexPath.row]
                cell.groupChatCellConfigurations(groupInfo)
            }
            cell.btnMemberInfo.touchUpInside { [weak self] (sender) in
                guard let _ = self else { return }
                
//                let grpInfo = groupInfo.dictionaryWithValues(forKeys: Array((groupInfo.entity.attributesByName.keys)))
                
                let grpInfo = self?.arrUserList[indexPath.row]
                
                if let groupMemberVC = CStoryboardGroup.instantiateViewController(withIdentifier: "GroupMemberRequestViewController") as? GroupMemberRequestViewController {
                    groupMemberVC.iObject = grpInfo
                    self?.navigationController?.pushViewController(groupMemberVC, animated: true)
                }
            }

            cell.btngroupInfo.touchUpInside { [weak self] (sender) in
                guard let _ = self else { return }
//                let grpInfo = groupInfo.dictionaryWithValues(forKeys: Array((groupInfo.entity.attributesByName.keys)))
                let grpInfo = self?.arrUserList[indexPath.row]
                if let groupMemberVC = CStoryboardGroup.instantiateViewController(withIdentifier: "GroupInfoViewController") as? GroupInfoViewController {
                    groupMemberVC.iObject = grpInfo
                    self?.navigationController?.pushViewController(groupMemberVC, animated: true)
                }
            }
            // LOAD MORE DATA..........
            //            if indexPath == tblGroups.lastIndexPath(){
            //            self.getGroupListFromServer(isNew: false)
            //            }
            
            if indexPath == tblGroups.lastIndexPath() && !self.isLoadMoreCompleted{
                if isSearch == true{
                    self.getSearchDataFromServer(txtSearch, "new",searchTxtOther:false)
                }else {
                    self.getGroupListFromServer(isNew: false,txtChange:false)
                }
               
            }
            return cell
        }
        
        return tableView.tableViewDummyCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        var groupInfo = arrUserList[indexPath.row]
        
        if let groupChatDetailsVC = CStoryboardGroup.instantiateViewController(withIdentifier: "GroupChatDetailsViewController") as? GroupChatDetailsViewController {
  
            groupChatDetailsVC.setBlock { [weak self] (object, message) in
                self?.getGroupListFromServer(isNew: true,txtChange:false)
            }
            
            
            if let grpID = groupInfo["group_id"] as? String{
                groupChatDetailsVC.group_id = grpID
            }
            groupChatDetailsVC.iObject = groupInfo
            groupChatDetailsVC.groupInfo = groupInfo
            groupChatDetailsVC.groupInfoLatest = groupInfo
            
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
                self?.getGroupListFromServer(isNew: true,txtChange:false)
            }
            self.navigationController?.pushViewController(createGroupVC, animated: true)
        }
    }
}

extension GroupsViewController: UISearchBarDelegate{
    //MARK: UISearchbar delegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearch = true
        arrUserList.removeAll()
    
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        isSearch = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //           searchBar.resignFirstResponder()
        searchBar.text = ""
        isSearch = false
        arrUserList.removeAll()
        self.getGroupListFromServer(isNew: true,txtChange:false)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        isSearch = false
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.count == 0 {
            isSearch = false
            self.getGroupListFromServer(isNew: true,txtChange:true)
        } else {
            self.txtSearch = searchText
            self.getSearchDataFromServer(self.txtSearch , "new",searchTxtOther:true)
            isSearch = true
        }
    }
    
}

//MARK:-  uiSearch delegate
extension GroupsViewController{
 
    func getSearchDataFromServer(_ searchText : String?, _ typeLook : String?,searchTxtOther:Bool){
      
        var param = [String:Any]()
        
            if apiTask?.state == URLSessionTask.State.running {
                return
            }
            if self.pageNumber > 2 {
                self.tblGroups.tableFooterView = self.loadMoreIndicator(ColorAppTheme)
            }else{
                self.tblGroups.tableFooterView = nil
            }
        let serchTextStr = searchText
        param["search_text"] = serchTextStr?.lowercased()

            if searchTxtOther == true {
                param[CPage] = 1
            }else {
                param[CPage] = pageNumberSearch
            }
        
            param["search_type"] = "group"

            param[CLimitS] = "10"
            param["user_id"] = appDelegate.loginUser?.user_id.description
            APIRequest.shared().userSearchDetails(Param: param){ [weak self] (response, error) in
                guard let self = self else { return }
               
                self.tblGroups.tableFooterView = nil
                self.refreshControl.endRefreshing()

                GCDMainThread.async {
                    if response != nil && error == nil {
                        self.arrUserList.removeAll()
                        self.arrUser.removeAll()
                        let arrLists = response!["data"] as? [[String : Any]] ?? [[:]]
                        for arrLst in arrLists{
                            if let arrList = arrLst["groups"] as? [[String : Any]] {
                                if self.pageNumberSearch == 1 {
                                    self.arrUser.removeAll()
                                    self.tblGroups.reloadData()
                                }
                                // Add Data here...
                                if arrList.count > 0 {
                                    self.arrUser = self.arrUser + arrList
                                    self.tblGroups.reloadData()
                                    self.pageNumberSearch += 1
                                }
                            }
                        }

                    }else{
                        self.arrUser.removeAll()
                        self.tblGroups.reloadData()
                       
                        
                    }
                }
            }
        }
    
    
    
    
}
