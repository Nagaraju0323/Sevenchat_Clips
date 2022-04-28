//
//  GroupMemberRequestViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 26/11/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//
/********************************************************
 * Author :  Nagaraju K and Chandrika R                                *
 * Model  : GroupChat Messages                          *
 * options: Group Messages & Notifications              *
 ********************************************************/

import UIKit

class GroupMemberRequestViewController: ParentViewController {

    @IBOutlet var viewSearchBar : UIView!
    @IBOutlet var btnSearch : UIButton!
    @IBOutlet var btnBack : UIButton!
    @IBOutlet var btnCancel : UIButton!
    @IBOutlet var txtSearch : UITextField!{
        didSet{
            txtSearch.returnKeyType = .search
        }
    }
    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var tblMember : UITableView!
    @IBOutlet var lblNoData : UILabel!
    @IBOutlet var cnNavigationHeight : NSLayoutConstraint!

    var refreshControl = UIRefreshControl()
    var apiTask : URLSessionTask?
    
    var arrMember = [[String : Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Initialization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateUIAccordingToLanguage()
    }
    
    // MARK:- --------- Initialization
    
    func Initialization(){
        lblNoData.text = CMessageNoMemberRequest
        cnNavigationHeight.constant = IS_iPhone_X_Series ? 84 : 64

        GCDMainThread.async {
            self.viewSearchBar.layer.cornerRadius = self.viewSearchBar.frame.size.height/2
            self.refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
            self.refreshControl.tintColor = ColorAppTheme
            self.tblMember.pullToRefreshControl = self.refreshControl
            self.getPendingRequestFromServer(search: self.txtSearch.text)
        }
    }
    
    func updateUIAccordingToLanguage(){
        
        lblTitle.text = CNavMemberRequest
        if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
            // Reverse Flow...
            btnSearch.contentHorizontalAlignment = .left
            btnBack.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }else{
            // Normal Flow...
            btnSearch.contentHorizontalAlignment = .right
            btnBack.transform = CGAffineTransform.identity
        }
        
        btnCancel.setTitle(CBtnCancel, for: .normal)
    }
}

// MARK:- --------- Api Functions
extension GroupMemberRequestViewController{
    @objc func pullToRefresh() {
        if apiTask?.state == URLSessionTask.State.running {
            apiTask?.cancel()
        }
        
        refreshControl.beginRefreshing()
        self.getPendingRequestFromServer(search: txtSearch.text)
    }
    
    func getPendingRequestFromServer(search : String?){
        if apiTask?.state == URLSessionTask.State.running {
            return
        }
        
//        if let groupInfo = self.iObject as? [String : Any]{
//        }
    }
    
    func accpetRejectGroupRequest(user_id : Int?, status : Int?, index : Int?){
//        if let groupInfo = self.iObject as? [String : Any]{
//
//        }
    }
}

// MARK:- --------- UITableView Datasources/Delegate
extension GroupMemberRequestViewController : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMember.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MyFriendTblCell", for: indexPath) as? MyFriendTblCell {
            let userInfo = arrMember[indexPath.row]
            cell.lblUserName.text = userInfo.valueForString(key: CFirstname) + " " + userInfo.valueForString(key: CLastname)
            cell.imgUser.loadImageFromUrl(userInfo.valueForString(key: CImage), true)
            
            cell.btnAcceptRequest.touchUpInside { [weak self] (sender) in
                guard let self = self else { return }
                self.accpetRejectGroupRequest(user_id: userInfo.valueForInt(key: CUserId), status: 2, index: indexPath.row)
                
            }
            
            cell.btnRejectRequest.touchUpInside { [weak self] (sender) in
                guard let self = self else { return }
                self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CMessageCancelRequest, btnOneTitle: CBtnYes, btnOneTapped: { (alert) in
                    self.accpetRejectGroupRequest(user_id: userInfo.valueForInt(key: CUserId), status: 3, index: indexPath.row)
                }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
                
            }
            
            return cell
        }
        
        return tableView.tableViewDummyCell()
    }
    
}


// MARK:- --------- Action Event
extension GroupMemberRequestViewController {
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
        
    }
}


// MARK:- --------- UITextField Delegate
extension GroupMemberRequestViewController : UITextFieldDelegate {
    
    @IBAction func textFieldDidChanged(_ textFiled : UITextField){
        if apiTask?.state == URLSessionTask.State.running {
            apiTask?.cancel()
        }
        
        if (textFiled.text?.count)! < 2{
            arrMember.removeAll()
            tblMember.reloadData()
            self.getPendingRequestFromServer(search: "")
            return
        }
        
        self.getPendingRequestFromServer(search: txtSearch.text)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
