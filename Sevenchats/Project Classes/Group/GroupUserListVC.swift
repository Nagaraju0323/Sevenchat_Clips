//
//  GroupUserListVC.swift
//  Sevenchats
//
//  Created by mac-00020 on 30/10/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

 /********************************************************
 * Author :  Nagaraju K and Chandrika R                                *
 * Model  : GroupChat Messages                          *
 * options: Group Messages & Notifications              *
 ********************************************************/

import Foundation
import UIKit

enum GroupListType {
    case Audio
    case Video
}

class GroupUserListVC: ParentViewController {
    
    //MARK: - IBOutlet/Object/Variable Declaration
    @IBOutlet weak var tblUsers: UITableView!{
        didSet{
            
            tblUsers.tableFooterView = UIView(frame: .zero)
            tblUsers.separatorStyle = .none
            tblUsers.register(UINib(nibName: "GroupMemberListCell", bundle: nil), forCellReuseIdentifier: "GroupMemberListCell")
            
            tblUsers.delegate = self
            tblUsers.dataSource = self
            
            self.refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
            self.refreshControl.tintColor = ColorAppTheme
            tblUsers.pullToRefreshControl = self.refreshControl
            
            tblUsers.reloadData()
        }
    }
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
    
    var refreshControl = UIRefreshControl()
    var listType : GroupListType = .Video
    var arrUsers : [MDLFriendsList] = []
    var apiTask : URLSessionTask?
    var onApplyFilter : ((String) -> Void)?
    var selectedIDs = ""
    var pageNumber : Int = 1
    var groupId : Int = 0
    
    var arrSelectedIds : [MDLFriendsList] = []
    
    var fullName = ""
    var userImage = ""
    
    //MARK: - View life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getUsersList(strSearch: "", isLoader: true)
    }
    
    
    //MARK: - Memory management methods
    deinit {
        print("### deinit -> FilterProductVC")
    }
}

//MARK: - SetupUI
extension GroupUserListVC {
    fileprivate func setupView() {
        self.title = CParticipants
        self.addBarButtonItems()
        
        registerForKeyboardWillShowNotification(tblUsers)
        registerForKeyboardWillHideNotification(tblUsers)
        
    }
    
    // Created Right bar button...
    fileprivate func addBarButtonItems() {
        
        let applyBarItem = BlockBarButtonItem(image: UIImage(named: "ic_apply_filter"), style: .plain) { [weak self] (_) in
            guard let self = self else {return}
            if self.listType == .Video{
                self.moveToVideoCallingScreen()
            } else {
                self.moveToAudioCallingScreen()
            }
        }
        
        self.navigationItem.rightBarButtonItem = applyBarItem
    }
    
    func moveToVideoCallingScreen() {
        
        let selectedUserIds =  self.arrSelectedIds.compactMap({$0.userId})
        if selectedUserIds.isEmpty{
            let meesage = CMessageChatGroupMemebers
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: meesage, btnOneTitle: CBtnOk, btnOneTapped: nil)
            return
        }
        
    }
    
    func moveToAudioCallingScreen() {
        
        let selectedMembers =  self.arrSelectedIds.compactMap({Members(id: $0.userId, firstName: $0.firstName, lastName: $0.lastName)})
        if selectedMembers.isEmpty{
            let meesage = CMessageChatGroupMemebers
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: meesage, btnOneTitle: CBtnOk, btnOneTapped: nil)
            return
        }
        
    }
}

//MARK: - IBAction / Selector
extension GroupUserListVC {
    
    @IBAction func on(_ sender: UIButton) {
        
    }
}

//MARK: - API Function
extension GroupUserListVC {
    
    @objc func pullToRefresh() {
        self.pageNumber = 1
        self.refreshControl.beginRefreshing()
        self.getUsersList(strSearch: self.txtSearch.text ?? "", isLoader: false)
    }
}

//MARK: - UITableView Delegates & DataSource
extension GroupUserListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrUsers.isEmpty{
            self.tblUsers.setEmptyMessage("")
            return 0
        }
        self.tblUsers.restore()
        return arrUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupMemberListCell") as? GroupMemberListCell else{
            return UITableViewCell(frame: .zero)
        }
        cell.model = self.arrUsers[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let obj = self.arrUsers[indexPath.row]
        
        let selectedCount = self.arrUsers.filter({$0.isSelected}).count
        
        if selectedCount > 50{
            obj.isSelected = false
            let meesage = CMaximum50ParticipantsSelect
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: meesage, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }else {
            obj.isSelected.toggle()
        }
        if obj.isSelected{
            self.arrSelectedIds.append(obj)
        }else{
            if let selectedObj = self.arrSelectedIds.filter({$0.userId == obj.userId}).first{
                self.arrSelectedIds.remove(object: selectedObj)
            }
        }
        self.tblUsers.reloadData()
    }
    
    func checkIsAllCategorySelected() -> Bool{
        return self.arrUsers.filter({$0.isSelected}).count == self.arrUsers.count
    }
}

//MARK: - UITextFieldDelegate
extension GroupUserListVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text,
            let textRange = Range(range, in: text) else{
                return true
        }
        let updatedText = text.replacingCharacters(in: textRange,with: string)
        self.pageNumber = 1
        self.getUsersList(strSearch: updatedText, isLoader: false)
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.pageNumber = 1
            self.getUsersList(strSearch: "", isLoader: false)
        }
        return true
    }
}

//MARK: - API Function
extension GroupUserListVC {
    
    fileprivate func getUsersList(strSearch: String, isLoader : Bool = true){
        
        if apiTask?.state == URLSessionTask.State.running {
            apiTask?.cancel()
        }
        
        let _ : [String : Any] = [
            "page" : self.pageNumber,
            "search":strSearch
        ]
    }
}
