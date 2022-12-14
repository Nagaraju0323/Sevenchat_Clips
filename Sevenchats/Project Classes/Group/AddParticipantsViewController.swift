//
//  AddParticipantsViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 31/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : AddParticipantsViewController               *
 * Changes :                                             *
 *  Disply Friends List & Search Friends                 *
 ********************************************************/

import UIKit

class AddParticipantsViewController: ParentViewController {
    
    @IBOutlet var tblUser : UITableView!
    @IBOutlet var lblNoData : UILabel!
    
    @IBOutlet weak var vwTxtSearch: UIView!{
        didSet{
            vwTxtSearch.layer.cornerRadius = 8
        }
    }
    @IBOutlet weak var vwSearch: UIView!
    @IBOutlet weak var txtSearch: UITextField!{
        didSet{
            txtSearch.placeholder = CSearch
            txtSearch.clearButtonMode = .whileEditing
            txtSearch.returnKeyType = .search
            txtSearch.delegate = self
        }
    }
    var arrUserListInfo = [[String:Any]]()
    var arrUserList = [[String:Any]]()
    var arrParticipants = [String]()
    var arrUser : [[String:Any]] = [[:]] {
        didSet{
            self.arrUserList = arrUser
         
        }
    }
    
    
    var isAddMoreMember = false
    var groupID : Int?
    var arrSelectedParticipant = [[String:Any]]()
    var arrAllreadySelectedParticipants = [[String : Any]]()
//    var arrUser = [[String:Any]]()
    var pageNumber = 1
    var refreshControl = UIRefreshControl()
    var apiTask : URLSessionTask?
    var apiParaFriends = [String]()
    var userIdNotification = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialization()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- --------- Initialization
    
    func Initialization(){
        self.title = CNavAddParticipants
        lblNoData.text = CNoParticipantsYet
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_apply_filter"), style: .plain, target: self, action: #selector(btnDoneCLK(_:)))
        tblUser.tableFooterView = UIView()
        
        GCDMainThread.async {
            self.refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
            self.refreshControl.tintColor = ColorAppTheme
            self.tblUser.pullToRefreshControl = self.refreshControl
        }
        
        self.getFriendList(strSearch: "", showLoader: true)
    }
}

// MARK:- --------- Api Functions
extension AddParticipantsViewController{
    @objc func pullToRefresh() {
        
        if apiTask?.state == URLSessionTask.State.running {
            apiTask?.cancel()
        }
        
        self.pageNumber = 1
        refreshControl.beginRefreshing()
        self.getFriendList(strSearch: self.txtSearch.text ?? "", showLoader: false)
    }
    
    func getFriendList(strSearch: String, showLoader : Bool = true)
    {
        if apiTask?.state == URLSessionTask.State.running {
            apiTask?.cancel()
        }
        //Add userId
        guard let userid = appDelegate.loginUser?.user_id else {
            return
        }
        // Add load more indicator here...
        if self.pageNumber > 2 {
            self.tblUser.tableFooterView = self.loadMoreIndicator(ColorAppTheme)
        }else{
            self.tblUser.tableFooterView = UIView()
        }
        apiTask = APIRequest.shared().getFriendList(page: self.pageNumber, request_type: 0, search: nil, group_id :Int(userid.description), showLoader: showLoader, completion: { (response, error) in
            self.refreshControl.endRefreshing()            
            self.tblUser.tableFooterView = UIView()
            
//            self.arrUser.removeAll()
            if response != nil{
                // if let arrList = response![CJsonData] as? [[String:Any]]{
                if let arrList = response!["my_friends"] as? [[String:Any]]{
                    
                    // Remove all data here when page number == 1
                    if self.pageNumber == 1{
                        self.arrUser.removeAll()
                        self.tblUser.reloadData()
                    }
                    // Add Data here...
//                    if arrList.count > 0{
//                        for object in arrList{
//                            if self.arrSelectedParticipant.contains(where: {$0["friend_user_id"] as? Int == object.valueForInt(key: "friend_user_id")}){
//                                if let index = self.arrSelectedParticipant.index(where: {$0["friend_user_id"] as? Int == object.valueForInt(key: "friend_user_id")}){
//                                    self.arrUser.append(self.arrSelectedParticipant[index])
//                                }
//                            }else{
//                                self.arrUser.append(object)
//                            }
//                        }
//                        self.pageNumber += 1
//                        self.tblUser.reloadData()
//                    }
                    
                    
                    if arrList.count > 0{
                        var strArr = self.arrUserListInfo.map({$0.valueForString(key: "user")})
                        var arrListInfo = arrList.map({$0.valueForString(key: "friend_user_id")})
                        arrListInfo.forEach { friends_ID in
                            if self.arrUserListInfo.contains(where: {$0["user_id"] as? String == friends_ID}) {
                            }else {
                                if let index = arrList.index(where: {$0["friend_user_id"] as? String == friends_ID}){
                                    self.arrUser.append(arrList[index])
                                }
                                
                            }
                            
                        }
                        self.pageNumber += 1
                        self.tblUser.reloadData()
                    }
                    self.lblNoData.isHidden = self.arrUser.count > 0
                }
            }
        })
        
    }
}

// MARK:- --------- UITableView Datasources/Delegate
extension AddParticipantsViewController : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUserList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CScreenWidth * 65 / 375
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AddParticipantsTblCell", for: indexPath) as? AddParticipantsTblCell {
            
            let userInfo = arrUserList[indexPath.row]
            cell.lblUserName.text = userInfo.valueForString(key: CFirstname) + " " + userInfo.valueForString(key: CLastname)
            cell.btnSelect.isSelected = arrSelectedParticipant.contains(where: {$0[CFriendUserID] as? String == userInfo.valueForString(key: CFriendUserID) })
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
            
            
//            ..... LOAD MORE DATA.........
            if indexPath == tblUser.lastIndexPath(){
                self.getFriendList(strSearch: self.txtSearch.text ?? "", showLoader: false)
            }
            
            return cell
        }
        
        return tableView.tableViewDummyCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userInfo = arrUserList[indexPath.row]
        
//        if arrSelectedParticipant.contains(where: {$0[CFriendUserID] as? String == userInfo.valueForString(key: CFriendUserID)}){
//            if let index = arrSelectedParticipant.index(where: {$0[CFriendUserID] as? String == userInfo.valueForString(key: CFriendUserID)}){
//                arrSelectedParticipant.remove(at: index)
//            }
//        }else{
//            arrSelectedParticipant.append(userInfo)
//        }
//        tblUser.reloadData()
//    }
        
        if arrSelectedParticipant.contains(where: {$0[CFriendUserID] as? String == userInfo.valueForString(key: CFriendUserID)}){
                    if let index = arrSelectedParticipant.index(where: {$0[CFriendUserID] as? String == userInfo.valueForString(key: CFriendUserID)}){
                        arrSelectedParticipant.remove(at: index)
                    }
                }else{
                    if isAddMoreMember == true {
                        if let index = arrUserListInfo.index(where: {$0["user_id"] as? String == userInfo.valueForString(key: CFriendUserID)}){
                        self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CGroupMemberExist, btnOneTitle: CBtnOk, btnOneTapped: nil)
                        }else {
                            arrSelectedParticipant.append(userInfo)
                        }
                    }else {
                        arrSelectedParticipant.append(userInfo)
                    }
                }
                tblUser.reloadData()
            }
    
}
// MARK:- ------------ Action Event
extension AddParticipantsViewController{
    
    @objc fileprivate func btnDoneCLK(_ sender : UIBarButtonItem) {
        
        if isAddMoreMember {
            // Call Add more member api here...
            
            let userid = arrSelectedParticipant.map({$0.valueForString(key: "friend_user_id") })
            for data in userid {
                let encryptUser = EncryptDecrypt.shared().encryptDecryptModel(userResultStr:  data ?? "")
                self.arrParticipants.append(encryptUser)
                        }
            print(self.arrParticipants)
            apiParaFriends = arrParticipants
            
            
            let userIDS = arrSelectedParticipant.map({$0.valueForString(key: "friend_user_id") }).joined(separator: ",")
            
         //   apiParaFriends = userIDS.components(separatedBy: ",")
            let encrypt = EncryptDecrypt.shared().encryptDecryptModel(userResultStr:  groupID?.toString ?? "")
            
            APIRequest.shared().addMemberInGroup(group_id: groupID, group_users_id: userIDS,frdsList:apiParaFriends) { (response, error) in
                if response != nil && error == nil{
                    
                    // Publish for Add status in group..
                    let arrUserIDS = self.arrSelectedParticipant.map({$0.valueForString(key: "friend_user_id") })
                    self.userIdNotification = userIDS
                    
                    if arrUserIDS.count > 0 {
                        
                    }
                    // Publish to other user to notify for newley added user..
                    let arrOldIDS = self.arrAllreadySelectedParticipants.map({$0.valueForString(key: CUserId) })
                    if arrOldIDS.count > 0 {
                    }
                    
                    let data = response![CJsonMeta] as? [String:Any] ?? [:]
                    let stausLike = data["status"] as? String ?? "0"
                    if stausLike == "0" {
                        let strArr = self.userIdNotification.map { String($0)}
                        strArr.forEach { friends_ID in
                        }
                    }
                    if let blockHandler = self.block {
                        blockHandler(self.arrSelectedParticipant, "refresh screen")
                    }
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }else{
            if let blockHandler = self.block {
                blockHandler(arrSelectedParticipant, "success")
            }
            self.navigationController?.popViewController(animated: true)
        }
        
    }
}


//MARK: - UITextFieldDelegate
extension AddParticipantsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text,
              let textRange = Range(range, in: text) else{
                 
            return true
        }
       
         
//        if textField.text == ""{
//            self.pageNumber = 1
//            self.getFriendList(strSearch: "", showLoader: false)
//        }
        
        let updatedText = text.replacingCharacters(in: textRange,with: string)
        if updatedText == ""{
            self.pageNumber = 1
            self.getFriendList(strSearch: "", showLoader: false)
        }else {
            arrUserList.removeAll()
            self.getFriendList(strSearch: updatedText, showLoader: false)
            
            arrUserList =  (arrUser as? [[String: AnyObject]])?.filter({($0["first_name"] as? String)?.range(of: txtSearch.text ?? "", options: [.caseInsensitive]) != nil }) ?? []
            tblUser.reloadData()
        }
//        self.pageNumber = 1

        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.pageNumber = 1
            self.getFriendList(strSearch: "", showLoader: false)
        }
        return true
    }
}
