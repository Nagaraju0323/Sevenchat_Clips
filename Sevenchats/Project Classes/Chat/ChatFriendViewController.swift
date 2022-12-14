//
//  ChatFriendViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 30/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : ChatFriendViewController                    *
 * Description :  List out friends for chat              *
 ********************************************************/

import UIKit
import StompClientLib
import TrueTime

class ChatFriendViewController: ParentViewController {
    
    @IBOutlet weak var viewSearchBar : UIView!
    @IBOutlet weak var btnSearch : UIButton!
    @IBOutlet weak var btnBack : UIButton!
    @IBOutlet weak var btnCancel : UIButton!
    @IBOutlet weak var txtSearch : UITextField!{
        didSet{
            txtSearch.returnKeyType = .search
            txtSearch.delegate = self
        }
    }
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var cnNavigationHeight : NSLayoutConstraint!
    
    @IBOutlet var tblFriend : UITableView! {
        didSet {
            tblFriend.tableFooterView = UIView()
        }
    }
    
    var pageNumber = 1
    var userID:Int?
    var refreshControl = UIRefreshControl()
    var apiTask : URLSessionTask?
//    var arrFriends = [[String:Any]]()
    var topicName:String?
    
    
    var arrFriends = [[String:Any]]()
    var arrUser : [[String:Any]] = [[:]] {
        didSet{
            self.arrFriends = arrUser
         
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialization()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadinfor), name: NSNotification.Name(rawValue: "loadinfor"), object: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- --------- Initialization
    func Initialization(){
        self.lblTitle.text = CNavFriends
        
        GCDMainThread.async {
            self.cnNavigationHeight.constant = IS_iPhone_X_Series ? 84 : 64
            
            self.viewSearchBar.layer.cornerRadius = self.viewSearchBar.frame.size.height/2
            
            self.refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
            self.refreshControl.tintColor = ColorAppTheme
            self.tblFriend.pullToRefreshControl = self.refreshControl
        }
        if let users = appDelegate.loginUser?.user_id{
            self.userID = Int(users)
        }
   
        self.getFriendListFromServer(showLoader: true)
        
    }

    
    //...Notification Response
    @objc func loadList(notification: NSNotification){
        self.getFriendListFromServer(showLoader: true)
    }
    
    @objc func loadinfor(notification: NSNotification){
        print("Loadingis::::::::::::::")
        self.view.layoutIfNeeded()
     
    }
   
}
// MARK:- --------- Api Functions
extension ChatFriendViewController {
    @objc func pullToRefresh() {
        if apiTask?.state == URLSessionTask.State.running {
            apiTask?.cancel()
        }
        
        self.pageNumber = 1
        refreshControl.beginRefreshing()
        self.getFriendListFromServer(showLoader: false)
    }
    
    
    fileprivate func getFriendListFromServer(showLoader : Bool, strSearch:String = ""){
        if apiTask?.state == URLSessionTask.State.running {
            apiTask?.cancel()
        }
        guard let user_id = appDelegate.loginUser?.user_id else {
            return
        }
        let UserID = String(user_id)
        
        // Add load more indicator here...
        self.tblFriend.tableFooterView = self.pageNumber > 2 ? self.loadMoreIndicator(ColorAppTheme) : UIView()
        
        apiTask = APIRequest.shared().getFriendList(page: self.pageNumber, request_type: 0, search: UserID, group_id : userID, showLoader: showLoader, completion: { (response, error) in
            
            self.refreshControl.endRefreshing()
            self.tblFriend.tableFooterView = UIView()
//            self.arrFriends.removeAll()
            
            if response != nil{
                if let arrLists = response!["my_friends"] as? [[String:Any]]{
                    // Remove all data here when page number == 1
                    if self.pageNumber == 1{
                        self.arrUser.removeAll()
                        self.tblFriend.reloadData()
                    }
                    // Add Data here...
                    if arrLists.count > 0{
                        self.arrUser = self.arrUser + arrLists
                        self.tblFriend.reloadData()
                        self.pageNumber += 1
                       
                    }
//                                        self.lblNoData.isHidden = self.arrUser.count > 0
                }
            }
        })
    }
}
// MARK:- --------- UITableView Datasources/Delegate
extension ChatFriendViewController : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFriends.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ChatFriendListCell", for: indexPath) as? ChatFriendListCell {
            
            let userInfo = arrFriends[indexPath.row]
            cell.lblUserName.text = userInfo.valueForString(key: CFirstname) + " " + userInfo.valueForString(key: CLastname)
            
//            cell.imgUser.loadImageFromUrl(userInfo.valueForString(key: CImage), true)
            
            let imgExt = URL(fileURLWithPath:userInfo.valueForString(key: CImage)).pathExtension
            
            
            if imgExt == "gif"{
                        print("-----ImgExt\(imgExt)")
                        
                cell.imgUser.isHidden  = true
                cell.imgUserGIF.isHidden = false
                        cell.imgUserGIF.sd_setImage(with: URL(string:userInfo.valueForString(key: CImage)), completed: nil)
                cell.imgUserGIF.sd_cacheFLAnimatedImage = false
                        
                    }else {
                        cell.imgUserGIF.isHidden = true
                        cell.imgUser.isHidden  = false
                        cell.imgUser.loadImageFromUrl(userInfo.valueForString(key: CImage), true)
                        _ = appDelegate.loginUser?.total_friends ?? 0
                    }
            
            //..... LOAD MORE DATA.........
             if indexPath == tblFriend.lastIndexPath(){
             self.getFriendListFromServer(showLoader: false)
              }
            
            return cell
        }
        
        return tableView.tableViewDummyCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userInfo = arrFriends[indexPath.row]
        
        if apiTask?.state == URLSessionTask.State.running {
            apiTask?.cancel()
        }
        
        let user_id = userInfo.valueForString(key: CUserId)
        let friend_user_id = userInfo.valueForString(key: CFriendID)
        
        apiTask = APIRequest.shared().getChatFriendsAdd(user_id: user_id, friend_user_id : friend_user_id, completion: { (response, error) in
            if response != nil{
                if let metaInfo = response![CJsonMeta] as? [String:Any]{
                    let status =  metaInfo["status"] as? String ?? ""
                    if status == "0"{
                        
                        self.apicallTotopicCreate(userInfo: userInfo)
                    }
                    
                }
            }else {
                guard  let errorUserinfo = error?.userInfo["error"] as? String else {return}
                let errorMsg = errorUserinfo.stringAfter(":")
                  print("error\(errorMsg)")
            
                self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CFriendsExists, btnOneTitle: CBtnOk, btnOneTapped: nil)
                
//                if showAlert && errorMessage != nil{
//                    print("error\(errorMsg)")
//                }
            }
        })
    }
    
}

extension ChatFriendViewController{
    //MARK :- API Call For Topoic Create
    func apicallTotopicCreate(userInfo:[String:Any]){
        
        let userID = userInfo.valueForString(key:CUserId).toInt
        let friendUserId = userInfo.valueForString(key: "friend_user_id").toInt
        
        guard let value_one = userID, let value_two = friendUserId  else {
            return
        }
        if value_one > value_two{
            topicName = String(value_one) + "_" + String(value_two)
        }else{
            topicName = String(value_two) + "_" + String(value_one)
        }
        
        topicName = String(value_two) + "_" + String(value_one)
        
        if apiTask?.state == URLSessionTask.State.running {
            apiTask?.cancel()
        }
        apiTask = APIRequest.shared().ChatFriendsTopicCrt(TopicName: topicName, completion: { (response, error) in
            if response != nil{
                if let status =  response?["status"] as? Int {
                    if status == 0{
                        if let userDetailVC = CStoryboardChat.instantiateViewController(withIdentifier: "UserChatDetailViewController") as? UserChatDetailViewController {
                            userDetailVC.isCreateNewChat = true
                            userDetailVC.iObject = userInfo
                            userDetailVC.chatInfoNot = userInfo
                            userDetailVC.userID = userInfo.valueForString(key: "friend_user_id").toInt
                            userDetailVC.friendUserId = userInfo.valueForString(key: "friend_user_id")
                            userDetailVC.userIDuser = userInfo.valueForString(key:CUserId)
                            self.navigationController?.pushViewController(userDetailVC, animated: true)
                        }
                    }
                }
            }
        })
    }
}


// MARK:- ------------ Action Event
extension ChatFriendViewController{
    
//    @objc fileprivate func btnRefreshClicked(_ sender : UIBarButtonItem) {
//        self.pageNumber = 1
//        self.getFriendListFromServer(showLoader: true)
//    }
    
    @IBAction func btnTextClear(_ sender : UIButton){
        txtSearch.text = nil
        self.getFriendListFromServer(showLoader: false, strSearch: txtSearch.text ?? "")
    }
    
    @IBAction func btnCancelCLK(_ sender : UIButton){
        txtSearch.resignFirstResponder()
        lblTitle.isHidden = false
        viewSearchBar.isHidden = true
        btnCancel.isHidden = true
        btnSearch.isHidden = false
        
        // Clear all search data...
        if !(txtSearch.text?.isBlank)! {
            txtSearch.text = nil
            self.pageNumber = 1
            self.getFriendListFromServer(showLoader: false, strSearch: txtSearch.text ?? "")
        }
    }
    
    @IBAction func btnSearchCLK(_ sender : UIButton){
        
        lblTitle.isHidden = true
        viewSearchBar.isHidden = false
        btnCancel.isHidden = false
        btnSearch.isHidden = true
    }
    
    @IBAction func onBackButtonAction(_ sender:UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func textFieldDidChanged(_ textFiled : UITextField){
        
    
        
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}

// MARK:- ------------ UITextFieldDelegate
extension ChatFriendViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        guard let text = textField.text,
              let textRange = Range(range, in: text) else{
                 
            return true
        }
        
        let updatedText = text.replacingCharacters(in: textRange,with: string)
        if updatedText == ""{
            self.pageNumber = 1
            self.getFriendListFromServer(showLoader: false)
        }else {
//            self.pageNumber = 1
            arrFriends.removeAll()
//            self.getFriendListFromServer(showLoader: false)
            
            arrFriends =  (arrUser as? [[String: AnyObject]])?.filter({($0["first_name"] as? String)?.range(of: txtSearch.text ?? "", options: [.caseInsensitive]) != nil }) ?? []
            print("arruser\(arrUser)")
            tblFriend.reloadData()
            
        }
//
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    
    
}
