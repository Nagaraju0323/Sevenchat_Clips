//
//  FriendsVC.swift
//  Sevenchats
//
//  Created by mac-00018 on 05/06/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Nagaraju K and Chandrika R                  *
 * Model   : FriendsVC                                   *
 * Changes :                                             *
 * List of user Friends                                  *
 ********************************************************/


import UIKit

class FriendsVC: ParentViewController {

    @IBOutlet weak var searchBarFriends: UISearchBar! {
        didSet {
            searchBarFriends.placeholder = CSearchFriends
            searchBarFriends.backgroundImage = UIImage()
            let searchTextField = searchBarFriends.value(forKey: "searchField") as? UITextField
            searchTextField?.textColor = UIColor.black
            searchBarFriends.layer.cornerRadius = 0.0
            searchBarFriends.layer.masksToBounds = true
             searchBarFriends.change(textFont: CFontPoppins(size: (12 * CScreenWidth)/375, type: .regular))
            searchBarFriends.delegate = self
            
            if let searchFieldBackground = searchTextField?.subviews.first{
                searchFieldBackground.backgroundColor = UIColor.white
                searchFieldBackground.layer.cornerRadius = 20
                searchFieldBackground.clipsToBounds = true
            }
        }
    }
    
    @IBOutlet weak var tblVFriends: UITableView! {
        didSet {
            self.tblVFriends.register(UINib(nibName: "TblFriendsCell", bundle: nil), forCellReuseIdentifier: "TblFriendsCell")
            self.tblVFriends.tableFooterView = UIView(frame: .zero)
            self.refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
            self.refreshControl.tintColor = ColorAppTheme
            self.tblVFriends.pullToRefreshControl = self.refreshControl
        }
    }
    /// List of friends, You are connected with them
    var arrFriendList = [MDLFriendsList]()
    
    /// It's contain folder raleted info
    var folder : MDLCreateFolder!
    
    /// used for handle load more
    var pageNumber = 1
    /// refreshControl for pull to referesh
    var refreshControl = UIRefreshControl()
    /// Check all the data are loaded from server
    var isLoadMoreCompleted = false
    /// Check this controller appearance form CreateFolderVC
    var isFromCreateFolder = false
    /// handle API request on search
    var apiTask : URLSessionTask?
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialization()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        createNavigationRightButton()
    }
}

//MARK: - Initialization
extension FriendsVC {
    
    func initialization() {
        
        self.title = CNavFriends
        
        registerForKeyboardWillShowNotification(tblVFriends)
        registerForKeyboardWillHideNotification(tblVFriends)
        self.createBackButton()
        self.friendList(isLoader: true)
    }
    
    fileprivate func createBackButton() {
        var imgBack = UIImage()
        if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
            imgBack = UIImage(named: "ic_back_reverse")!
        }else{
            imgBack = UIImage(named: "ic_back")!
        }
        let backBarButtion = BlockBarButtonItem(image: imgBack, style: .plain) { [weak self] (_) in
            guard let _ = self else {return}
            self?.resignKeyboard()
            if self?.isFromCreateFolder ?? false{
                self?.navigationController?.popToRootViewController(animated: true)
            }else{
                self?.navigationController?.popViewController(animated: true)
            }
        }
        self.navigationItem.leftBarButtonItem = backBarButtion
    }
    
    // Create navigation right bar button..
    fileprivate func createNavigationRightButton() {
        
        let button = UIButton(type: .custom)
        let btnHeight = 40
        button.frame = CGRect(x: 0, y: 0, width: btnHeight, height: btnHeight)
        button.setImage(UIImage(named: "share_icon"), for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(customView: button)
        
        button.touchUpInside { (_) in
            let arrSelected = self.arrFriendList.filter({$0.isSelected}).compactMap({"\($0.userId!)"})
            let friendIds = arrSelected.joined(separator: ",")
            if arrSelected.count < 1 {
                self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageMinSelection, btnOneTitle: CBtnOk, btnOneTapped: nil)
            } else {
                self.shareFolder(friendIds: friendIds)
            }
        }
    }
}

//MARK:- UITableView Delegate & Data Source
extension FriendsVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  70 //( (CScreenWidth * 70) / 375)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrFriendList.count == 0{
            tblVFriends.setEmptyMessage(CNoFriendsYet)
            return 0
        }
        tblVFriends.restore()
        return arrFriendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if arrFriendList.count <= indexPath.row{
            return UITableViewCell(frame: .zero)
        }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier:  "TblFriendsCell") as? TblFriendsCell {
            
            let friend = self.arrFriendList[indexPath.row]
            cell.lblFriendName.text = friend.firstName + " " + friend.lastName
            cell.imgVFriend.loadImageFromUrl(friend.image, true)
            cell.imgVFriend.roundView()
            
            cell.btnSelectFriend.isSelected = friend.isSelected
            cell.btnSelectFriend.tag = indexPath.row
            
            cell.btnProfileImage.touchUpInside { [weak self] (sender) in
            guard let self = self else { return }
                appDelegate.moveOnProfileScreen("\(friend.userId!)", self)
            }
            cell.btnUserName.touchUpInside { [weak self] (sender) in
            guard let self = self else { return }
                appDelegate.moveOnProfileScreen("\(friend.userId!)", self)
            }
            
           //  Load more data....
            if (indexPath == tblVFriends.lastIndexPath()) && !self.isLoadMoreCompleted {
                self.friendList(isLoader: false)
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if arrFriendList.count <= indexPath.row{
            return
        }
        if let cell = tableView.cellForRow(at: indexPath) as? TblFriendsCell{
            let friend = self.arrFriendList[indexPath.row]
            friend.isSelected = !friend.isSelected
            cell.btnSelectFriend.isSelected = friend.isSelected
        }
    }
}

//MARK: - UISearchBarDelegate
extension FriendsVC: UISearchBarDelegate {
   
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar.text?.isBlank ?? true {
            self.pageNumber = 1
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.resignKeyboard()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.pageNumber = 1
        self.friendList(isLoader: false)
    }
}

// MARK:- --------- Api Functions
extension FriendsVC {
    
    @objc func pullToRefresh() {
        if apiTask?.state == URLSessionTask.State.running {
            apiTask?.cancel()
        }
        self.refreshControl.beginRefreshing()
        self.pageNumber = 1
        self.isLoadMoreCompleted = false
        self.friendList(isLoader: false)
    }

    
    fileprivate func friendList(isLoader: Bool) {
        
        var para = [String : Any]()
        para[CPage] = self.pageNumber
        para[CPer_page] = CLimit
        para[CFolderID] = self.folder.id
        para["search"] = searchBarFriends.text
        
        if apiTask?.state == URLSessionTask.State.running {
            apiTask?.cancel()
        }
        
    }

    fileprivate func shareFolder(friendIds:String) {
        
        var para = [String : Any] ()
        para[CFolderID] = self.folder.id
        para["friend_ids"] = friendIds
    }
}

