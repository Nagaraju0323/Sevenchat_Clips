//
//  GroupFriendSelectionViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 23/11/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : GroupFriendSelectionViewController          *
 * Changes :                                             *
 ********************************************************/

import UIKit

class GroupFriendSelectionViewController: ParentViewController {
    
    @IBOutlet var tblGroupFriend : UITableView!
    @IBOutlet var lblNoData : UILabel!
    
    var arrSelectedGroupFriend = [[String:Any]]()
    var arrGroupFriend = [[String:Any]]()
    var pageNumber = 1
    var refreshControl = UIRefreshControl()
    var apiTask : URLSessionTask?
    
    var isFriendList:Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Initialization()
    }
    
    func Initialization(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_apply_filter"), style: .plain, target: self, action: #selector(btnDoneCLK(_:)))
        tblGroupFriend.tableFooterView = UIView()
        
        GCDMainThread.async {
            self.refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
            self.refreshControl.tintColor = ColorAppTheme
            self.tblGroupFriend.pullToRefreshControl = self.refreshControl
        }
        
        if isFriendList!{
            self.getFriendList(showLoader: true)
            self.title = CNavAddContact
            lblNoData.text = CMessageNoContactYet
        }else{
            self.title = CNavAddGroup
            lblNoData.text = CMessageNoGroupList
            self.getGroupList(showLoader: true, isNew: true)
        }
    }
}


// MARK:- --------- Api Functions
extension GroupFriendSelectionViewController{
    @objc func pullToRefresh() {
        if apiTask?.state == URLSessionTask.State.running {
            apiTask?.cancel()
        }
        
        self.pageNumber = 1
        refreshControl.beginRefreshing()
        
        if isFriendList!{
            self.getFriendList(showLoader: false)
        }else{
            self.getGroupList(showLoader: false, isNew: true)
        }
    }
    
    func getGroupList(showLoader : Bool, isNew: Bool){
        
        if apiTask?.state == URLSessionTask.State.running {
            return
        }
        
        self.tblGroupFriend.tableFooterView = nil
        var apiTimeStamp : Double = 0
        
        if !isNew {
            if let chatInfo = MIGeneralsAPI.shared().fetchChatGroupObjectFromLocal(isNew: !isNew) {
                apiTimeStamp = chatInfo.datetime
                self.tblGroupFriend.tableFooterView = self.loadMoreIndicator(ColorAppTheme)
            }
        }
        guard let userid = appDelegate.loginUser?.user_id else {
            return
        }
        
        apiTask = APIRequest.shared().getGroupChatList(timestamp: apiTimeStamp, search: userid.description, showLoader: showLoader) { (response, error) in
            self.arrGroupFriend.removeAll()
            if response != nil{
                if let arrList = response![CJsonData] as? [[String:Any]]{
                    
                    // Remove all data here when timestamp == 0
                    if apiTimeStamp == 0{
                        self.arrGroupFriend.removeAll()
                        self.tblGroupFriend.reloadData()
                    }
                    // Add Data here...
                    if arrList.count > 0{
                        self.arrGroupFriend = self.arrGroupFriend + arrList
                        self.tblGroupFriend.reloadData()
                    }
                }
                self.lblNoData.isHidden = self.arrGroupFriend.count != 0
            }
        }
    }
    
    func getFriendList(showLoader : Bool)
    {
        if apiTask?.state == URLSessionTask.State.running {
            apiTask?.cancel()
        }
        //Add userId
        guard let userid = appDelegate.loginUser?.user_id else {
            return
        }
        let userID = userid.description
        
        // Add load more indicator here...
        if self.pageNumber > 2 {
            self.tblGroupFriend.tableFooterView = self.loadMoreIndicator(ColorAppTheme)
        }else{
            self.tblGroupFriend.tableFooterView = UIView()
        }
        
        apiTask = APIRequest.shared().getFriendList(page: self.pageNumber, request_type: 0, search: userID, group_id : userID.toInt, showLoader: showLoader, completion: { (response, error) in
            self.refreshControl.endRefreshing()
            self.tblGroupFriend.tableFooterView = UIView()
            self.arrGroupFriend.removeAll()
            if response != nil{
                if let arrList = response!["my_friends"] as? [[String:Any]]{
                    // Remove all data here when page number == 1
                    if self.pageNumber == 1{
                        self.arrGroupFriend.removeAll()
                        self.tblGroupFriend.reloadData()
                    }
                    
                    // Add Data here...
                    if arrList.count > 0{
                        self.arrGroupFriend = self.arrGroupFriend + arrList
                        self.tblGroupFriend.reloadData()
                        self.pageNumber += 1
                    }
                }
                
                self.lblNoData.isHidden = self.arrGroupFriend.count != 0
            }
        })
        
    }
    
    
}

// MARK:- --------- UITableView Datasources/Delegate
extension GroupFriendSelectionViewController : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrGroupFriend.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CScreenWidth * 65 / 375
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AddParticipantsTblCell", for: indexPath) as? AddParticipantsTblCell {
            let userGroupInfo = arrGroupFriend[indexPath.row]
            
            // If user looking for friend....
            if isFriendList!{
                cell.lblUserName.text = userGroupInfo.valueForString(key: "first_name") + " " + userGroupInfo.valueForString(key: CLastname)
                cell.btnSelect.isSelected = arrSelectedGroupFriend.contains(where: {$0["friend_user_id"] as? String == userGroupInfo.valueForString(key: "friend_user_id") })
                cell.imgUser.loadImageFromUrl(userGroupInfo.valueForString(key: "profile_image"), true)
                
                let imgExt = URL(fileURLWithPath:userGroupInfo.valueForString(key: "profile_image")).pathExtension
                
                
                if imgExt == "gif"{
                            print("-----ImgExt\(imgExt)")
                            
                    cell.imgUser.isHidden  = true
                    cell.imgUserGIF.isHidden = false
                    cell.imgUserGIF.sd_setImage(with: URL(string:userGroupInfo.valueForString(key: "profile_image")), completed: nil)
                    cell.imgUserGIF.sd_cacheFLAnimatedImage = false
                            
                        }else {
                            cell.imgUserGIF.isHidden = true
                            cell.imgUser.isHidden  = false
                            cell.imgUser.loadImageFromUrl(userGroupInfo.valueForString(key: "profile_image"), true)
                           
                            _ = appDelegate.loginUser?.total_friends ?? 0
                        }
                
            }else{
                // If user looking for Group....
                cell.lblUserName.text = userGroupInfo.valueForString(key: CGroupTitle)
                cell.btnSelect.isSelected = arrSelectedGroupFriend.contains(where: {$0[CGroupId] as? String == userGroupInfo.valueForString(key: CGroupId) })
                cell.imgUser.loadImageFromUrl(userGroupInfo.valueForString(key: CGroupImage), true)
            }
            
            
            //            //..... LOAD MORE DATA.........
            //            if indexPath == tblGroupFriend.lastIndexPath(){
            //                if isFriendList!{
            //                    self.getFriendList(showLoader: false)
            //                }else{
            //                    self.getGroupList(showLoader: false, isNew: false)
            //                }
            //            }
            
            return cell
        }
        
        return tableView.tableViewDummyCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userGroupInfo = arrGroupFriend[indexPath.row]
        
        if isFriendList!{
            // For Friend selection.....
            if arrSelectedGroupFriend.contains(where: {$0["friend_user_id"] as? String == userGroupInfo.valueForString(key: "friend_user_id")}){
                if let index = arrSelectedGroupFriend.index(where: {$0["friend_user_id"] as? String == userGroupInfo.valueForString(key: "friend_user_id")}){
                    arrSelectedGroupFriend.remove(at: index)
                }
                
            }else{
                arrSelectedGroupFriend.append(userGroupInfo)
            }
        }else{
            // For Group selection.....
            if arrSelectedGroupFriend.contains(where: {$0[CGroupId] as? String == userGroupInfo.valueForString(key: CGroupId)}){
                if let index = arrSelectedGroupFriend.index(where: {$0[CGroupId] as? String == userGroupInfo.valueForString(key: CGroupId)}){
                    arrSelectedGroupFriend.remove(at: index)
                }
            }else{
                arrSelectedGroupFriend.append(userGroupInfo)
            }
        }
        tblGroupFriend.reloadData()
    }
}

// MARK:- ------------ Action Event
extension GroupFriendSelectionViewController{
    
    @objc fileprivate func btnDoneCLK(_ sender : UIBarButtonItem) {
        
        if let blockHandler = self.block {
            blockHandler(arrSelectedGroupFriend, "success")
        }
        self.navigationController?.popViewController(animated: true)
    }
    
}

