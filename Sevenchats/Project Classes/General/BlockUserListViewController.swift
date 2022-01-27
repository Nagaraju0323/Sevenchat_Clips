//
//  BlockUserListViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 21/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : BlockUserListViewController                 *
 * Changes :                                             *
 *                                                       *
 ********************************************************/

import UIKit

class BlockUserListViewController: ParentViewController {

    @IBOutlet var viewSearchBar : UIView!
    @IBOutlet var btnSearch : UIButton!
    @IBOutlet var btnCancel : UIButton!
    @IBOutlet var btnBack : UIButton!
    @IBOutlet var txtSearch : UITextField!{
        didSet{
            txtSearch.returnKeyType = .search
        }
    }
    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var tblBlockList : UITableView!
    @IBOutlet var cnNavigationHeight : NSLayoutConstraint!
    @IBOutlet var lblBlockUserCount : UILabel!
    @IBOutlet var lblNoData : UILabel!
    @IBOutlet var vwBlockCount : UIView!

    var arrBlockUserList = [[String:Any]]()
    var pageNumber = 1
    var refreshControl = UIRefreshControl()
    var apiTask : URLSessionTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Initialization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateUIAccordingToLanguage()
    }
    
    // MARK:- --------- Initialization
    
    func Initialization(){
        self.setLanguageText()
        cnNavigationHeight.constant = IS_iPhone_X_Series ? 84 : 64
        GCDMainThread.async {
            self.viewSearchBar.layer.cornerRadius = self.viewSearchBar.frame.size.height/2
            
            self.refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
            self.refreshControl.tintColor = ColorAppTheme
            self.tblBlockList.pullToRefreshControl = self.refreshControl
        }
        
        self.getBlockUserListFromServer(true, search: "")
    }
    
    func setLanguageText() {
        lblTitle.text = CBlockedUsers.capitalized
        self.btnCancel.setTitle(CBtnCancel, for: .normal)
        self.lblNoData.text = CMessageNoBlockedUser
    }
    
    func setBlockCountAttributeString(_ totalUser : Int?) {
        let attrs = [NSAttributedString.Key.font : CFontPoppins(size: lblBlockUserCount.font.pointSize, type: .meduim),
                     NSAttributedString.Key.foregroundColor: UIColor.black]
        let attrs1 = [NSAttributedString.Key.font : CFontPoppins(size: lblBlockUserCount.font.pointSize, type: .meduim),
                      NSAttributedString.Key.foregroundColor: CRGB(r: 218, g: 66, b: 90)]
        let attributedString = NSMutableAttributedString(string: "\(CBlockedUsersCount) ", attributes:attrs)
        let normalString = NSMutableAttributedString(string: "\(totalUser ?? 0) \(totalUser == 1 ? CBlockedUser : CBlockedUsers)", attributes:attrs1)
        attributedString.append(normalString)
        lblBlockUserCount.attributedText = attributedString
    }
    
    func updateUIAccordingToLanguage(){
        
        if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
            // Reverse Flow...
            btnSearch.contentHorizontalAlignment = .left
            btnBack.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }else{
            // Normal Flow...
            btnSearch.contentHorizontalAlignment = .right
            btnBack.transform = CGAffineTransform.identity
        }
        
    }
}

// MARK:- --------- Api Functions
extension BlockUserListViewController{
    @objc func pullToRefresh() {
        self.pageNumber = 1
        refreshControl.beginRefreshing()
        self.getBlockUserListFromServer(false, search: txtSearch.text)
    }
    
 //MARK:- API Call
    fileprivate func getBlockUserListFromServer(_ shouldShowLoader : Bool, search : String?){
            
            if apiTask?.state == URLSessionTask.State.running {
                return
            }
         
            // Add load more indicator here...
            if self.pageNumber > 2 {
                self.tblBlockList.tableFooterView = self.loadMoreIndicator(ColorAppTheme)
            }else{
                self.tblBlockList.tableFooterView = nil
            }
            
            apiTask = APIRequest.shared().getBlockUserList(page: pageNumber, search: search, showLoader: shouldShowLoader) { (response, error) in
                self.refreshControl.endRefreshing()
                self.tblBlockList.tableFooterView = nil
                
                if response != nil && error == nil{
                    _ = response!["total_block_users"] as? Int
                    if let arrList = response!["block_users"] as? [[String:Any]]{
                        // Remove all data here when page number == 1
                        if self.pageNumber == 1{
                            self.arrBlockUserList.removeAll()
                            self.tblBlockList.reloadData()
                        }
                        
                        // Add Data here...
                        if arrList.count > 0{
                            self.arrBlockUserList = self.arrBlockUserList + arrList
                            self.tblBlockList.reloadData()
                            self.pageNumber += 1
                        }
                    }
                    
                    if let metaInfo = response!["total_block_users"] as? Int {
                        self.setBlockCountAttributeString(metaInfo)
                    }
                    
                    self.vwBlockCount.isHidden = self.arrBlockUserList.count == 0
                    self.lblNoData.isHidden = self.arrBlockUserList.count > 0
                }
                
            }
    }
}


// MARK:- --------- UITableView Datasources/Delegate
extension BlockUserListViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrBlockUserList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "BlockUserListTblCell", for: indexPath) as? BlockUserListTblCell {
            let userInfo = arrBlockUserList[indexPath.row]
            cell.lblUserName.text = userInfo.valueForString(key: CFirstname) + " " + userInfo.valueForString(key: CLastname)
            cell.imgUser.image=UIImage(named: "ic_sidemenu_normal_profile")
            cell.btnUnblock.touchUpInside { [weak self] (sender) in
                guard let self = self else { return }
                self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CMessageUnBlockUser, btnOneTitle: CBtnYes, btnOneTapped: { [weak self](alert) in
                    guard let self = self else { return }
                    self.apiUhblockUser(userInfo.valueForString(key: "friend_user_id") ?? "",index: indexPath.row)
                    }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
            }
            
            // Load More Data.....
            if indexPath == tblBlockList.lastIndexPath(){
//                self.getBlockUserListFromServer(false, search: txtSearch.text)
            }
            
            return cell
        }
        
        return tableView.tableViewDummyCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}

// MARK:- --------- UITextField Delegate
extension BlockUserListViewController : UITextFieldDelegate {
    
    @IBAction func textFieldDidChanged(_ textFiled : UITextField){
        if apiTask?.state == URLSessionTask.State.running {
            apiTask?.cancel()
        }
        
        if (textFiled.text?.count)! < 2{
            pageNumber = 1
            arrBlockUserList.removeAll()
            tblBlockList.reloadData()
            return
        }
        
        pageNumber = 1
        self.getBlockUserListFromServer(false, search: txtSearch.text)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}

// MARK:- -------------- Action Event
extension BlockUserListViewController{
    
        
    @IBAction func btnSearchCancelCLK(_ sender : UIButton){
        
        switch sender.tag {
        case 0:
            lblTitle.isHidden = true
            viewSearchBar.isHidden = false
            btnCancel.isHidden = false
            btnSearch.isHidden = true
            break
        case 1:
            txtSearch.resignFirstResponder()
            lblTitle.isHidden = false
            viewSearchBar.isHidden = true
            btnCancel.isHidden = true
            btnSearch.isHidden = false
            break
            
        case 2:
            txtSearch.text = nil
            break
            
        default:
            break
            
        }
        
        // Remove search data on Cancel/Clear button click...
        if sender.tag != 0{
            txtSearch.text = nil
            pageNumber = 1
            arrBlockUserList.removeAll()
            tblBlockList.reloadData()
            self.getBlockUserListFromServer(false, search: txtSearch.text)
        }
        
    }
}

//MARK: - API's Calling
extension BlockUserListViewController{
    
    func apiUhblockUser(_ userId: String, index:Int){
           APIRequest.shared().blockUnblockUserNew(userID:userId, block_unblock_status: "7", completion: { (response, error) in
            if response != nil{
                self.arrBlockUserList.remove(at: index)
                UIView.performWithoutAnimation {
                    self.tblBlockList.reloadData()
                }
                self.vwBlockCount.isHidden = self.arrBlockUserList.count == 0
                self.lblNoData.isHidden = self.arrBlockUserList.count > 0
            }
        })
    }
}
