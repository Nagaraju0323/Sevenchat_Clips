//
//  FilesVC.swift
//  ProgressViewDemo
//
//  Created by mac-00018 on 29/05/19.
//  Copyright © 2019 mac-00018. All rights reserved.
//

/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : FilesVC                                     *
 * Changes :                                             *
 *                                                       *
 ********************************************************/



import UIKit
import PDFKit


class FilesVC: UIViewController {
    
    @IBOutlet weak var viewUpgrade: UIView!
    @IBOutlet weak var viewShadow: UIView!
    @IBOutlet weak var tblVMyFiles: UITableView!{
        didSet{
            tblVMyFiles.tableFooterView = UIView(frame: .zero)
            tblVMyFiles.separatorStyle = .none
            self.refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
            self.refreshControl.tintColor = ColorAppTheme
            self.tblVMyFiles.pullToRefreshControl = self.refreshControl
        }
    }
    
    @IBOutlet weak var lblStoragSpace: UILabel!
    @IBOutlet weak var progressUpgrade: UIProgressView!{
        didSet {
            progressUpgrade.layer.cornerRadius = 5
            progressUpgrade.clipsToBounds = true
            progressUpgrade.setProgress(0.0, animated: false)
        }
    }
    
    @IBOutlet weak var btnUpgradeNow: UIButton! {
        didSet {
            self.btnUpgradeNow.hide(byHeight: true)
            self.btnUpgradeNow.layer.cornerRadius = 8
            self.btnUpgradeNow.setNormalTitle(normalTitle: CBtnUpgradeNow)
        }
    }
    /// List of file from server
    var arrFiles : [MDLCreateFolder] = []
    var arrSortFiles : [MDLCreateFolder] = []
    var srtcharecter:String?
    /// It's appearance on edit file name
    weak var textField : UITextField?
    /// Here you can search the file name
    var txtSearch: String = ""{
        didSet{
            if apiTask?.state == URLSessionTask.State.running {
                apiTask?.cancel()
            }
            self.arrFiles.removeAll()
            self.myFilesSharedFilesFolders(isLoader:false)
        }
    }
  
    var txtSearchsort: String = ""{
        didSet{
         srtcharecter = txtSearchsort
         myFilesSharedFiles(txtSearchsort)
        }
    }
    /// `storage` used for check remanning storage space while uploading files
    var storage : MDLStorage?
    /// refreshControl for pull to referesh
    var refreshControl = UIRefreshControl()
    /// handle API request on search
    var apiTask : URLSessionTask?
    /// Check all the data are loaded from server
    var isLoadMoreCompleted = false
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialization()
        self.myFilesSharedFilesFolders()
    }
    
    func myFilesSharedFiles(_ sortedString:String){
        srtcharecter = sortedString
        self.myFilesSharedFilesFolders()
        self.myFilesSharedFilesFolders(isLoader: false)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewShadow.shadow(color: CRGB(r: 201, g: 228, b: 158), shadowOffset: CGSize(width: 0, height: 2), shadowRadius: 3.0, shadowOpacity: 4.0)
    }
    deinit {
        print("deinit -> FilesVC")
    }
}
//MARK: - Initialization
extension FilesVC {
    fileprivate func initialization() {
        // Manage scroll on keyboard appearnce....
        registerForKeyboardWillShowNotification(tblVMyFiles)
        registerForKeyboardWillHideNotification(tblVMyFiles)
    }
}

//MARK: - API Function
extension FilesVC {
 
    @objc func pullToRefresh() {
        if apiTask?.state == URLSessionTask.State.running {
            apiTask?.cancel()
        }
        self.isLoadMoreCompleted = false
        self.arrFiles.removeAll()
        refreshControl.beginRefreshing()
        self.myFilesSharedFilesFolders(isLoader: false)
    }
    
    // Get storage space from API
    func getUserStorageSpace(isLoader:Bool = true) {
        
        if apiTask?.state == URLSessionTask.State.running {
            apiTask?.cancel()
        }
    }
    
    // Get List of folder from server....
    func myFilesSharedFilesFolders(isLoader:Bool = true) {
        
        if apiTask?.state == URLSessionTask.State.running {
            return
        }
        
        var para = [String : Any]()
        para["search"] = self.txtSearch
        para[CType] = 1
        if let lastFolder = self.arrFiles.last{
            para[CTimestamp] = lastFolder.createdAt
        }
    }
    
    // Edit folder name...
    fileprivate func editFolder(folderId: Int, folderName: String) {
        var para = [String : Any]()
        para["folder_name"] = folderName
        para[CId] = folderId
        para[CType] = 1

    }
    
    // Delete folder....
    fileprivate func deleteFolder(folderId: Int){
        
        var para = [String : Any]()
        para[CFolderID] = folderId
        para[CType] = 1

    }
    
    /// Delete folder from document directory.
    // `folderID` is name of folder.
    ///
    /// - Parameter folderID: Name of folder
    fileprivate func deleteFolderInLocalStorage(folderID:String){
        //var documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentsDirectoryURL = NSURL.fileURL(withPath: NSTemporaryDirectory(), isDirectory: true)
        //documentsDirectoryURL = documentsDirectoryURL.appendingPathComponent(folderID)
        
        do{
            try? FileManager.default.removeItem(at:documentsDirectoryURL)
        }
    }
    
    
    func editFolderName(index:Int){
        
        self.presentAlertViewWithOneTextField(alertTitle: CRenameFolder, alertMessage: nil, alertFirstTextFieldHandler: { [weak self](_textField) in
            self?.textField = _textField
            self?.textField?.delegate = self
            self?.textField?.text = self?.arrFiles[index].folderName
        }, btnOneTitle: CBtnCancel, btnOneTapped: {[weak self] (_) in
            self?.textField = nil
        }, btnTwoTitle: CForgotBtnSubmit, btnTwoTapped: {[weak self] (_) in
            guard let self = self else { return }
            if (self.textField?.text?.isBlank)!{
                
                self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CCreateFolderAlertBlank, btnOneTitle: CBtnOk , btnOneTapped: { (_) in
                    self.editFolderName(index: index)
                })
                return
            }
            self.arrFiles[index].folderName = self.textField?.text ?? ""
            self.textField = nil
            
            self.editFolder(folderId: (self.arrFiles[index].id) ?? 0, folderName: (self.arrFiles[index].folderName) ?? "")
            
            self.tblVMyFiles.reloadData()
        })
    }
}

//MARK: - UITableView Delegates & DataSource
extension FilesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ((CScreenWidth * 60) / 375)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrFiles.count == 0{
            tblVMyFiles.setEmptyMessage(CFoldersCreated)
            return 0
        }
        tblVMyFiles.restore()
        if srtcharecter == "NewToOld"{
            return arrFiles.count
        }else {
            return arrSortFiles.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if arrFiles.count <= indexPath.row{
            return UITableViewCell(frame: .zero)
        }
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TblFilesCell") as? TblFilesCell {
            if srtcharecter == "NewToOld"{
                let folder = arrFiles[indexPath.row]
                cell.lblFolderName.text = folder.folderName
                cell.btnMore.tag = indexPath.row
            }else if srtcharecter == "OldToNew"{
                let folder = arrSortFiles[indexPath.row]
                cell.lblFolderName.text = folder.folderName
                cell.btnMore.tag = indexPath.row
            }else {
                let folder = arrFiles[indexPath.row]
                cell.lblFolderName.text = folder.folderName
                cell.btnMore.tag = indexPath.row
            }
                cell.btnMore.touchUpInside { [weak self] (sender) in
                guard let _ = self else {return}
                self?.presentActionsheetWithThreeButton(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CBtnEdit, btnOneStyle: .default, btnOneTapped: { [weak self] (alert) in
                    self?.editFolderName(index: sender.tag)
                }, btnTwoTitle: CBtnDelete, btnTwoStyle: .default, btnTwoTapped: { [weak self](alert) in
                    
                    self?.presentAlertViewWithTwoButtons(alertTitle: nil, alertMessage: CMessageDeleteFolder, btnOneTitle: CBtnYes, btnOneTapped: {[weak self] (_) in
                        self?.deleteFolder(folderId: (self?.arrFiles[indexPath.row].id) ?? 0)
                    }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
                    
                }, btnThreeTitle: CBtnShare, btnThreeStyle: .default) { [weak self](_) in
                    
                    if  let sharedListVC = CStoryboardFile.instantiateViewController(withIdentifier: "SharedListVC") as? SharedListVC {
                        sharedListVC.folder = self?.arrFiles[indexPath.row]
                        self?.navigationController?.pushViewController(sharedListVC, animated: true)
                    }
                }
            }
            
            // Load more data....
            if (indexPath == tblVMyFiles.lastIndexPath()) && apiTask?.state != URLSessionTask.State.running && !self.isLoadMoreCompleted {
                self.myFilesSharedFilesFolders(isLoader: false)
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let _storage = self.storage else {
            MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
            getUserStorageSpace()
            return
        }
        if let controller = self.navigationController?.getViewControllerFromNavigation(FileSharingViewController.self){
            controller.setCancelBarButton()
        }
        if arrFiles.count <= indexPath.row{
            return
        }
        if  let sharedFilesDetailsVC = CStoryboardFile.instantiateViewController(withIdentifier: "SharedFilesDetailsVC") as? SharedFilesDetailsVC {
            sharedFilesDetailsVC.folder = arrFiles[indexPath.row]
            sharedFilesDetailsVC.storage = _storage
            self.navigationController?.pushViewController(sharedFilesDetailsVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear
        footerView.isUserInteractionEnabled = false
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 70
    }
}

//MARK: - UITextFieldDelegate
extension FilesVC : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isBlank{
            return true
        }
        if self.textField == textField, self.textField?.text!.count ?? 0 > 20{
            return false
        }
        return true
    }
}

//MARK: - Action Events
extension FilesVC {
    
    @IBAction func btnUpgradeNowAction(_ sender: MIGenericButton) {
        
        if  let upgeadeStorageVC = CStoryboardFile.instantiateViewController(withIdentifier: "UpgradeStorageVC") as? UpgradeStorageVC {
            self.navigationController?.pushViewController(upgeadeStorageVC, animated: true)
        }
    }
    
    @IBAction func btnAddFolderAction(_ sender: UIButton) {
        if let controller = self.navigationController?.getViewControllerFromNavigation(FileSharingViewController.self){
            controller.setCancelBarButton()
        }
        guard let _storage = self.storage else {
            MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
            getUserStorageSpace()
            return
        }
        if  let createFolderVC = CStoryboardFile.instantiateViewController(withIdentifier: "CreateFolderVC") as? CreateFolderVC {
            createFolderVC.storage = _storage
            self.navigationController?.pushViewController(createFolderVC, animated: true)
        }
    }
}

extension URL {
    var typeIdentifier: String? {
        return (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier
    }
    var localizedName: String? {
        return (try? resourceValues(forKeys: [.localizedNameKey]))?.localizedName
    }
}
