//
//  SharedFilesVC.swift
//  Sevenchats
//
//  Created by mac-00018 on 31/05/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : SharedFilesVC                              *
 * Changes :                                             *
 *                                                       *
 ********************************************************/


import UIKit

class SharedFilesVC: UIViewController {
    
    @IBOutlet weak var tblVSharedFiles: UITableView!{
        didSet{
            tblVSharedFiles.tableFooterView = UIView(frame: .zero)
            tblVSharedFiles.separatorStyle = .none
            self.refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
            self.refreshControl.tintColor = ColorAppTheme
            self.tblVSharedFiles.pullToRefreshControl = self.refreshControl
            
        }
    }
    /// list of file from server
    var arrFiles : [MDLCreateFolder] = []
    /// refreshControl for pull to referesh
    var refreshControl = UIRefreshControl()
    /// Check all the data are loaded from server
    var isLoadMoreCompleted = false
    /// handle API request on search
    var apiTask : URLSessionTask?
    /// Here you can search the file name
    var txtSearch: String = ""{
        didSet{
            if apiTask?.state == URLSessionTask.State.running {
                apiTask?.cancel()
            }
            self.arrFiles.removeAll()
            self.sharedFolders(isLoader: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialization()
    }
    
    deinit {
        print("deinit -> SharedFilesVC")
    }
}

//MARK: - Initialization
extension SharedFilesVC {
    
    func initialization() {
        registerForKeyboardWillShowNotification(tblVSharedFiles)
        registerForKeyboardWillHideNotification(tblVSharedFiles)
        
        GCDMainThread.async {
            self.sharedFolders()
        }
    }
}

//MARK:- API Function......
extension SharedFilesVC {
    
    @objc func pullToRefresh() {
        self.refreshControl.beginRefreshing()
        self.isLoadMoreCompleted = false
        self.arrFiles.removeAll()
        self.sharedFolders(isLoader: false)
    }
    
    fileprivate func sharedFolders(isLoader:Bool = true) {
        
        if apiTask?.state == URLSessionTask.State.running {
            return
        }
        
        var para = [String : Any]()
        para["search"] = self.txtSearch
        para[CType] = 0
        if let lastFolder = self.arrFiles.last{
            para[CTimestamp] = lastFolder.createdAt
        }
        
//        apiTask = APIRequest.shared().myFolderSharedFolders(param: para, showLoader: isLoader, completion: { [weak self](response, error) in
//            guard let self = self else { return }
//            self.refreshControl.endRefreshing()
//            if response != nil {
//                GCDMainThread.async {
//                    let arrData = response![CData] as? [[String : Any]] ?? []
//                    self.isLoadMoreCompleted = (arrData.count == 0)
//
//                    for obj in arrData{
//                        self.arrFiles.append(MDLCreateFolder(fromDictionary: obj))
//                    }
//                    self.tblVSharedFiles.reloadData()
//                }
//            }
//        })
    }
    
    fileprivate func deleteFolder(folderId: Int){
        
        var para = [String : Any]()
        para[CFolderID] = folderId
        para[CType] = 0
    }
}

//MARK: - UITableView Delegates & DataSource
extension SharedFilesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrFiles.count == 0{
            tblVSharedFiles.setEmptyMessage(CFoldersHasBeenSharedWithYou)
            return 0
        }
        tblVSharedFiles.restore()
        return arrFiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if arrFiles.count <= indexPath.row{
            return UITableViewCell(frame: .zero)
        }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TblFilesCell") as? TblFilesCell {
            
            let folder = arrFiles[indexPath.row]
            cell.lblFolderName.text = folder.folderName
            cell.lblSharedBy.text = "Shared by: \(folder.sharedBy!)"
            cell.btnMore.tag = indexPath.row
            cell.btnMore.touchUpInside { [weak self](sender) in
                guard let _ = self else {return}
                self?.presentAlertViewWithTwoButtons(alertTitle: nil, alertMessage: CMessageDeleteFolder, btnOneTitle: CBtnYes, btnOneTapped: { [weak self](_) in
                    self?.deleteFolder(folderId: (self?.arrFiles[cell.btnMore.tag].id) ?? 0)
                    
                    }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
            }
            
            // Load more data....
            if (indexPath == tblVSharedFiles.lastIndexPath()) && !self.isLoadMoreCompleted {
                self.sharedFolders(isLoader: false)
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ((CScreenWidth * 60) / 375)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if arrFiles.count <= indexPath.row{
            return
        }
        if let controller = self.navigationController?.getViewControllerFromNavigation(FileSharingViewController.self){
            controller.setCancelBarButton()
        }
        
        if  let sharedFilesDetailsVC = CStoryboardFile.instantiateViewController(withIdentifier: "SharedFilesDetailsVC") as? SharedFilesDetailsVC {
            sharedFilesDetailsVC.folder = arrFiles[indexPath.row]
            sharedFilesDetailsVC.isFromSharedFiles = true
            self.navigationController?.pushViewController(sharedFilesDetailsVC, animated: true)
        }
    }
}

