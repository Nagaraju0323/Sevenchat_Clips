//
//  GroupForwardViewController.swift
//  Sevenchats
//
//  Created by mac-00012 on 30/04/20.
//  Copyright © 2020 mac-00020. All rights reserved.
//

import UIKit

class GroupForwardViewController: UIViewController {

    @IBOutlet weak var tblGroups : UITableView!{
        didSet {
            self.tblGroups.register(UINib(nibName: "TblFriendsCell", bundle: nil), forCellReuseIdentifier: "TblFriendsCell")
            self.tblGroups.tableFooterView = UIView(frame: .zero)
            self.refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
            self.refreshControl.tintColor = ColorAppTheme
            self.tblGroups.pullToRefreshControl = self.refreshControl
            self.tblGroups.delegate = self
            self.tblGroups.dataSource = self
        }
    }
    
    var currentSelected : Int = 0
    /// Here you can search the file name
    var txtSearch: String = ""{
        didSet{
            if apiTask?.state == URLSessionTask.State.running {
                apiTask?.cancel()
            }
            self.pageNumber = 1
            self.arrFriends.removeAll()
            self.getGroupListFromServer(isNew: true)
        }
    }
    
    var pageNumber = 1
    var refreshControl = UIRefreshControl()
    var apiTask : URLSessionTask?
    var arrFriends : [MDLFriendsList] = []
    var isLoadMoreCompleted = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getGroupListFromServer(isNew: true)
    }

    deinit {
        print("deinit -> GroupForwardViewController")
    }
}

//MARK:- UITableView Delegate & Data Source
extension GroupForwardViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrFriends.count == 0{
            tblGroups.setEmptyMessage(CNoFriendsYet)
            return 0
        }
        tblGroups.restore()
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
        cell.lblFriendName.text = friend.groupTitle
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
        if (indexPath == tblGroups.lastIndexPath()) && !self.isLoadMoreCompleted {
            self.getGroupListFromServer(isNew: false)
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
        selectedCount += forwardVC.singleUserVC?.currentSelected ?? 0
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

extension GroupForwardViewController {
    @objc func pullToRefresh() {
        refreshControl.beginRefreshing()
        self.getGroupListFromServer(isNew: true)
    }
    
    
    func getGroupListFromServer(isNew : Bool) {
        
        if apiTask?.state == URLSessionTask.State.running {
            return
        }
        
        self.tblGroups.tableFooterView = nil
        var apiTimeStamp : Double = 0
        
        if !isNew {
            if let model = arrFriends.last {
                apiTimeStamp = model.datetime
            }
        }
        
        apiTask = APIRequest.shared().getGroupChatList(timestamp: apiTimeStamp, search:  self.txtSearch, showLoader: true) { [weak self] (response, error) in
            guard let self = self else { return }
            self.refreshControl.endRefreshing()
            self.tblGroups.tableFooterView = UIView()
            
            guard let _response = response else {
                self.isLoadMoreCompleted = true
                self.arrFriends.removeAll()
                self.tblGroups.reloadData()
                return
            }
            let arrData = _response[CJsonData] as? [[String : Any]] ?? []
            
             if self.pageNumber == 1 {
                 self.arrFriends.removeAll()
                 self.tblGroups.reloadData()
             }
             
             if arrData.count > 0{
                 self.pageNumber += 1
             }
             
             for obj in arrData{
                 self.arrFriends.append(MDLFriendsList(forGroup: obj))
             }
             
             self.isLoadMoreCompleted = (arrData.count == 0)
             self.tblGroups.reloadData()
        }
    }
}
