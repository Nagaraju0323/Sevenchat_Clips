//
//  SingleUserForwardViewController.swift
//  Sevenchats
//
//  Created by mac-00012 on 30/04/20.
//  Copyright © 2020 mac-00020. All rights reserved.
//

import UIKit

class SingleUserForwardViewController: UIViewController {

    @IBOutlet weak var tblFriend : UITableView!{
        didSet {
            self.tblFriend.register(UINib(nibName: "TblFriendsCell", bundle: nil), forCellReuseIdentifier: "TblFriendsCell")
            self.tblFriend.tableFooterView = UIView(frame: .zero)
            self.refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
            self.refreshControl.tintColor = ColorAppTheme
            self.tblFriend.pullToRefreshControl = self.refreshControl
            self.tblFriend.delegate = self
            self.tblFriend.dataSource = self
        }
    }
    var currentSelected : Int = 0
    var pageNumber = 1
    var refreshControl = UIRefreshControl()
    var apiTask : URLSessionTask?
    var arrFriends : [MDLFriendsList] = []
    var isLoadMoreCompleted = false
    
    /// Here you can search the file name
    var txtSearch: String = ""{
        didSet{
            if apiTask?.state == URLSessionTask.State.running {
                apiTask?.cancel()
            }
            self.pageNumber = 1
            self.arrFriends.removeAll()
            self.getFriendListFromServer(showLoader: false, strSearch: txtSearch)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getFriendListFromServer(showLoader: true)
    }
    
    deinit {
        print("### Deinit -> SingleUserForwardViewController")
    }
}

//MARK:- UITableView Delegate & Data Source
extension SingleUserForwardViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrFriends.count == 0{
            tblFriend.setEmptyMessage(CNoFriendsYet)
            return 0
        }
        tblFriend.restore()
        return arrFriends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if arrFriends.count <= indexPath.row{
            return UITableViewCell(frame: .zero)
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier:  "TblFriendsCell") as? TblFriendsCell else {
            
            return UITableViewCell()
        }
        let friend = self.arrFriends[indexPath.row]
        cell.lblFriendName.text = friend.firstName + " " + friend.lastName
        cell.imgVFriend.loadImageFromUrl(friend.image, true)
        cell.imgVFriend.roundView()
        
        cell.btnSelectFriend.isSelected = friend.isSelected
        cell.btnSelectFriend.tag = indexPath.row
        
        cell.btnUserName.isEnabled = false
        cell.btnProfileImage.isEnabled = false
        cell.btnProfileImage.touchUpInside { [weak self] (sender) in
            guard let self = self else { return }
            appDelegate.moveOnProfileScreen("\(friend.userId!)", self)
            
        }
        
        cell.btnUserName.touchUpInside { [weak self] (sender) in
            guard let self = self else { return }
            appDelegate.moveOnProfileScreen("\(friend.userId!)", self)
        }
        
        // Load more data....
        if (indexPath == tblFriend.lastIndexPath()) && !self.isLoadMoreCompleted {
            self.getFriendListFromServer(showLoader: false)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if arrFriends.count <= indexPath.row{
            return
        }
        guard let forwardVC = self.getViewControllerFromNavigation(ForwardViewController.self) else {
            return
        }
        let friend = self.arrFriends[indexPath.row]
        var selectedCount = self.arrFriends.filter({$0.isSelected}).count
        self.currentSelected = selectedCount
        selectedCount += forwardVC.groupUserVC?.currentSelected ?? 0
        if !friend.isSelected && selectedCount >= forwardVC.maxSelection {
            return
        }
        friend.isSelected = !friend.isSelected
        if friend.isSelected {
            self.currentSelected += 1
            selectedCount += 1
        } else {
            self.currentSelected -= 1
            selectedCount -= 1
        }
        forwardVC.btnSend.isEnabled = !(self.currentSelected == 0 && selectedCount == 0)
        guard let cell = tableView.cellForRow(at: indexPath) as? TblFriendsCell else{
            return
        }
        cell.btnSelectFriend.isSelected = friend.isSelected
    }
}

//MARK:- API's Calling
extension SingleUserForwardViewController {
    
    @objc func pullToRefresh() {
        if apiTask?.state == URLSessionTask.State.running {
            apiTask?.cancel()
        }
        
        self.pageNumber = 1
        refreshControl.beginRefreshing()
        self.getFriendListFromServer(showLoader: false)
    }
    
    fileprivate func getFriendListFromServer(showLoader : Bool, strSearch:String = "") {
        if apiTask?.state == URLSessionTask.State.running {
            apiTask?.cancel()
        }
        
        // assinged user_id
        guard let user_id = appDelegate.loginUser?.user_id else {
            return
        }

        let userID = String(user_id)
        
        // Add load more indicator here...
        self.tblFriend.tableFooterView = self.pageNumber > 2 ? self.loadMoreIndicator(ColorAppTheme) : UIView()
        
        apiTask = APIRequest.shared().getFriendList(page: self.pageNumber, request_type: 0, search: userID, group_id : nil, showLoader: showLoader, completion: { (response, error) in
            self.refreshControl.endRefreshing()
            self.tblFriend.tableFooterView = UIView()
            
            guard let _response = response else {
                self.isLoadMoreCompleted = true
                self.arrFriends.removeAll()
                self.tblFriend.reloadData()
                return
            }
            GCDMainThread.async {
                
                let arrData = _response[CJsonData] as? [[String : Any]] ?? []
               
                // Remove all data here when page number == 1
                if self.pageNumber == 1 {
                    self.arrFriends.removeAll()
                    self.tblFriend.reloadData()
                }
                
                if arrData.count > 0{
                    self.pageNumber += 1
                }
                
                for obj in arrData{
                    self.arrFriends.append(MDLFriendsList(fromDictionary: obj))
                }
                
                self.isLoadMoreCompleted = (arrData.count == 0)
                self.tblFriend.reloadData()
            }
        })
        
    }
}

