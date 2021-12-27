//
//  SharedListVC.swift
//  Sevenchats
//
//  Created by mac-00018 on 05/06/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

import UIKit

class SharedListVC: ParentViewController {
    
    @IBOutlet weak var searchBarSharedList: UISearchBar! {
        didSet {
            searchBarSharedList.placeholder = CSearchFriends
            searchBarSharedList.backgroundImage = UIImage()
            let searchTextField = searchBarSharedList.value(forKey: "searchField") as? UITextField
            searchTextField?.textColor = UIColor.black
            searchBarSharedList.layer.cornerRadius = 0.0
            searchBarSharedList.layer.masksToBounds = true
             searchBarSharedList.change(textFont: CFontPoppins(size: (12 * CScreenWidth)/375, type: .regular))
            
            if let searchFieldBackground = searchTextField?.subviews.first{
                searchFieldBackground.backgroundColor = UIColor.white
                searchFieldBackground.layer.cornerRadius = 20
                searchFieldBackground.clipsToBounds = true
            }
            searchBarSharedList.delegate = self
        }
    }
    
    @IBOutlet weak var btnInviteOther: UIButton!{
        didSet{
            btnInviteOther.setTitle(CInviteOthers, for: .normal)
        }
    }
    
    @IBOutlet weak var tblSharedList: UITableView!{
        didSet {
            self.tblSharedList.tableFooterView = UIView(frame: .zero)
            self.refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
            self.refreshControl.tintColor = ColorAppTheme
            self.tblSharedList.pullToRefreshControl = self.refreshControl
        }
    }
    
    var arrUsers : [MDLFriendsList] = []
    var folder : MDLCreateFolder!
    var refreshControl = UIRefreshControl()
    var isLoadMoreCompleted = false
    var currentPage : Int = 0
    var apiTask : URLSessionTask?
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialization()
    }
    
}

//MARK: - Initialization
extension SharedListVC {
    
    func  initialization()  {
        
        self.title = CNavSharedList
        
        registerForKeyboardWillShowNotification(tblSharedList)
        registerForKeyboardWillHideNotification(tblSharedList)
        
        self.sharedFriendList(isLoader: true)
    }
    
    // Delete Folder....
    func deleteUser(_ indexPath: IndexPath) {
        
        self.presentAlertViewWithTwoButtons(alertTitle: nil, alertMessage: CAreYouSureToStopShareFolder, btnOneTitle: CBtnYes, btnOneTapped: { [weak self] (_) in
            guard let _ = self else {return}
            GCDMainThread.async {
                self?.removeSharedFriendList(friendsId: self?.arrUsers[indexPath.row].userId ?? 0)
                self?.arrUsers.remove(at: indexPath.row)
            }
            
            }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
    }
}

//MARK: - API Funcations
extension SharedListVC {
    
    @objc func pullToRefresh() {
        self.refreshControl.beginRefreshing()
        //self.arrUsers.removeAll()
        self.currentPage = 1
        self.isLoadMoreCompleted = false
        self.sharedFriendList(isLoader: false)
    }
    
    fileprivate func sharedFriendList(isLoader: Bool) {
        
        var para = [String : Any] ()
        para[CFolderID] = self.folder.id
        para["search"] = self.searchBarSharedList.text ?? ""
        para[CPage] = currentPage
        
        print(para)
        
        if apiTask?.state == URLSessionTask.State.running {
            return
        }
        
//       apiTask = APIRequest.shared().sharedFriendsList(param: para, showLoader: isLoader) { [weak self] (response, error) in
//            guard let self = self else { return }
//            self.refreshControl.endRefreshing()
//            if response != nil {
//
//                GCDMainThread.async {
//
//                    let arrData = response![CData] as? [[String : Any]] ?? []
//
//                    // Remove all data here when page number == 1
//                    if self.currentPage == 1 {
//                        self.arrUsers.removeAll()
//                        self.tblSharedList.reloadData()
//                    }
//
//                    if arrData.count > 0{
//                        self.currentPage += 1
//                    }
//
//                    for obj in arrData{
//                        self.arrUsers.append(MDLFriendsList(fromDictionary: obj))
//                    }
//
//                    self.isLoadMoreCompleted = (arrData.count == 0)
//                    self.tblSharedList.reloadData()
//                }
//            }
//        }
    }
    
    fileprivate func removeSharedFriendList(friendsId: Int) {
        var para = [String : Any] ()
        para[CFolderID] = self.folder.id
        para["friend_ids"] = friendsId
        
//        APIRequest.shared().removeSharedFriendList(param: para, showLoader: true) { (response, error) in
//            if response != nil {
//                GCDMainThread.async {
//                    self.tblSharedList.reloadData()
//                }
//            }
//        }
    }
}

//MARK: - UITableView Delegate & Data Source
extension SharedListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        if arrUsers.count == 0{
            tblSharedList.setEmptyMessage(CNoSharedUser)
            return 0
        }
        tblSharedList.restore()
        return arrUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if arrUsers.count <= indexPath.row{
            return UITableViewCell(frame: .zero)
        }
        if let cell = tableView.dequeueReusableCell(withIdentifier:  "TblSharedListCell") as? TblSharedListCell {
            
            let userInfo = arrUsers[indexPath.row]
            cell.lblFriendName.text = userInfo.firstName + " " + userInfo.lastName
            cell.imgVFriend.loadImageFromUrl(arrUsers[indexPath.row].image, true)
            cell.btnClose.touchUpInside { [weak self] (sender) in
                guard let self = self else { return }
                self.deleteUser(indexPath)
            }
            
            cell.btnProfileImage.touchUpInside { [weak self] (sender) in
                guard let self = self else { return }
                appDelegate.moveOnProfileScreen("\(userInfo.userId!)", self)
            }
            
            cell.btnUserName.touchUpInside { [weak self] (sender) in
                guard let self = self else { return }
                appDelegate.moveOnProfileScreen("\(userInfo.userId!)", self)
            }
            
            // Load more data....
            if (indexPath == self.tblSharedList.lastIndexPath()) && !self.isLoadMoreCompleted {
                self.sharedFriendList(isLoader: false)
            }
            
            return cell
        }
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ((CScreenWidth * 70) / 375)
    }
}

//MARK: - Action Events
extension SharedListVC {
    
    @IBAction func btnInviteOthersAction(_ sender: UIButton) {
        
        if let friendsVC = CStoryboardFile.instantiateViewController(withIdentifier: "FriendsVC") as? FriendsVC {
            friendsVC.folder = self.folder
            self.navigationController?.pushViewController(friendsVC, animated: true)
        }
    }
}

//MARK: - UISearchBarDelegate
extension SharedListVC: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.resignKeyboard()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if apiTask?.state == URLSessionTask.State.running {
            apiTask?.cancel()
        }
        self.currentPage = 1
        self.sharedFriendList(isLoader: false)
    }
}
