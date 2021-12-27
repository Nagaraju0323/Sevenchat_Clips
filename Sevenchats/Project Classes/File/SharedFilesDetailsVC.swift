////
////  SharedFilesDetailsVC.swift
////  Sevenchats
////
////  Created by mac-00018 on 31/05/19.
////  Copyright © 2019 mac-0005. All rights reserved.
////
//
//import UIKit
//import QuickLook
//import TLPhotoPicker
//import Photos
//import AVKit
//import AVFoundation
//import MobileCoreServices
//import Lightbox
//
//class SharedFilesDetailsVC: ParentViewController {
//
//    /// UISearchBar for search files in list
//    @IBOutlet weak var searchBarSharedFile: UISearchBar! {
//        didSet {
//            searchBarSharedFile.placeholder = CSearch
//            searchBarSharedFile.tintColor = .black
//
//            searchBarSharedFile.change(textFont: CFontPoppins(size: (12 * CScreenWidth)/375, type: .regular))
//            searchBarSharedFile.delegate = self
//
//            searchBarSharedFile.backgroundImage = UIImage()
//            let searchTextField = searchBarSharedFile.value(forKey: "searchField") as? UITextField
//            searchTextField?.textColor = UIColor.black
//            searchBarSharedFile.layer.cornerRadius = 0.0
//            searchBarSharedFile.layer.masksToBounds = true
//
//            if let searchFieldBackground = searchTextField?.subviews.first{
//                searchFieldBackground.backgroundColor = UIColor.white
//                searchFieldBackground.layer.cornerRadius = 20
//                searchFieldBackground.clipsToBounds = true
//            }
//        }
//    }
//
//    @IBOutlet weak var tblSharedFile: UITableView! {
//        didSet {
//            self.tblSharedFile.tableFooterView = UIView(frame: .zero)
//            self.tblSharedFile.allowsSelection = true
//            self.tblSharedFile.register(UINib(nibName: "CreateFileTableCell", bundle: nil), forCellReuseIdentifier: "CreateFileTableCell")
//            self.tblSharedFile.delegate = self
//            self.tblSharedFile.dataSource = self
//            self.refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
//            self.refreshControl.tintColor = ColorAppTheme
//            self.tblSharedFile.pullToRefreshControl = self.refreshControl
//        }
//    }
//
//    /// btnAddFiles for add/upload new file
//    @IBOutlet weak var btnAddFiles: UIButton!
//
//    /// Arrary of added item in list
//    var arrMedia : [MDLAddMedia] = []
//    var failedFiles : [MDLAddMedia] = []
//    var isFromSharedFiles: Bool = false
//
//    /// `dispatchGroup` Used for get assets item from gallery
//    let dispatchGroup = DispatchGroup()
//
//    /// refreshControl for pull to referesh
//    var refreshControl = UIRefreshControl()
//
//    /// `previewItem` containt a URL of previewing file from list
//    lazy var previewItem = NSURL()
//
//    /// `folder` it's containt folder id and name
//    var folder : MDLCreateFolder!
//
//
//    /// `storage` used for check remanning storage space while uploading files
//    var storage : MDLStorage?
//    var totalSpace = 0.0
//    var selectedData = 0.0
//
//    /// `timestamp` containt timestamp of last record. it's used for load more..
//    var timestamp : Int = 0
//
//
//    /// Check all the data are loaded from server
//    var isLoadMoreCompleted = false
//
//    var apiTask : URLSessionTask?
//
//    /// It's list of extension. It will be used while uploading file on server to check
//    /// file is restricted or not
//    var restrictedFile : [MDLRestractedFile] = []
//
//    /// Select photos and video from Gallery
//    let photosPickerViewController = TLPhotosPickerViewController()
//
//    // MARK:- Life Cycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.initialization()
//        self.createBackButton()
//        self.getFileListFromServer()
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//
//        if !self.isFromSharedFiles {
//            createNavigationRightButton()
//        }
//    }
//
//
//    /// Add the Share button from right side of the navigatin bar
//    /// It's used to share file with your friends.
//    /// - Returns: Share button If restricted file exist from server
//    func addInfoBarButton() -> UIBarButtonItem?{
//
//        if let controller = self.navigationController?.getViewControllerFromNavigation(FileSharingViewController.self){
//
//            self.restrictedFile = controller.arrRestrictedFileType
//            if self.restrictedFile.isEmpty{
//                return nil
//            }
//
//            return BlockBarButtonItem(image: UIImage(named: "ic_info_tint"), style: .plain) { [weak self] (_) in
//                guard let _ = self else {return}
//
//                if let restrictionVC = CStoryboardFile.instantiateViewController(withIdentifier: "RestrictedFilesVC") as? RestrictedFilesVC{
//                    restrictionVC.arrDatasource = self?.restrictedFile ?? []
//                    self?.navigationController?.pushViewController(restrictionVC, animated: true)
//                }
//            }
//        }
//        return nil
//    }
//
//    // Delete Folder....
//    func deleteFile(_ index: Int) {
//
//        self.presentAlertViewWithTwoButtons(alertTitle: nil, alertMessage: CMessageDeleteFile , btnOneTitle: CBtnYes, btnOneTapped: { [weak self] (_) in
//            guard let _ = self else {return}
//            self?.arrMedia.remove(at: index)
//            GCDMainThread.async {
//                self?.tblSharedFile.reloadData()
//            }
//
//            }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
//    }
//
//    /// Delete file from document directory.
//    // `folderID` is name of folder.
//    ///
//    /// - Parameter folderID: Name of folder
//    fileprivate func deleteFileInLocalStorage(fileName:String){
//        //var documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        var documentsDirectoryURL = NSURL.fileURL(withPath: NSTemporaryDirectory(), isDirectory: true)
//        //documentsDirectoryURL = documentsDirectoryURL.appendingPathComponent("\(self.folder.id ?? 0)")
//        documentsDirectoryURL = documentsDirectoryURL.appendingPathComponent(fileName)
//        print("FileManager.default.removeItem : \(documentsDirectoryURL.absoluteString)")
//
//        do{
//            try? FileManager.default.removeItem(at:documentsDirectoryURL)
//        }
//    }
//
//    func getDownloadedFileURL(url:URL, completion:@escaping (URL?)->Void){
//
//        self.downloadfile(fileUrl: url, completion: {(success, fileLocationURL) in
//            DispatchQueue.main.async {
//                //MILoader.shared.hideLoader()
//                if success {
//                    // Set the preview item to display======
//                    //self.previewItem = fileLocationURL! as NSURL
//                    //self.previewFile(fileURL: fileLocationURL!)
//                    completion(fileLocationURL)
//                }else{
//                    completion(nil)
//                    debugPrint("File can't be downloaded")
//                }
//            }
//        })
//    }
//
//    deinit {
//        print("Deinit -> SharedFilesDetailsVC")
//    }
//}
//
////MARK: - Initialization
//extension SharedFilesDetailsVC {
//
//    fileprivate func initialization() {
//
//        self.title = folder.folderName
//
//        self.totalSpace = (self.storage?.totalSpace ?? 0) * UnitOfBytes
//        self.selectedData = (self.storage?.uploaded ?? 0) * UnitOfBytes
//
//        if  self.isFromSharedFiles {
//            self.btnAddFiles.isHidden = true
//        }
//
//        registerForKeyboardWillShowNotification(tblSharedFile)
//        registerForKeyboardWillHideNotification(tblSharedFile)
//    }
//
//    /// Add back button in navigation bar
//    fileprivate func createBackButton() {
//
//        var imgBack = UIImage()
//        if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
//            imgBack = UIImage(named: "ic_back_reverse")!
//        }else{
//            imgBack = UIImage(named: "ic_back")!
//        }
//        let backBarButtion = BlockBarButtonItem(image: imgBack, style: .plain) { [weak self] (_) in
//            guard let _ = self else {return}
//            self?.resignKeyboard()
//            if self?.arrMedia.filter({$0.uploadMediaStatus == .Failed || $0.uploadMediaStatus == .Failed}).count ?? 0 > 0{
//
//                self?.presentAlertViewWithTwoButtons(alertTitle: nil, alertMessage: CAlertMessageForFilesNotUploaded, btnOneTitle: CBtnNo, btnOneTapped: nil, btnTwoTitle: CBtnYes, btnTwoTapped: { (_) in
//                    self?.navigationController?.popViewController(animated: true)
//                })
//            }else{
//                self?.navigationController?.popViewController(animated: true)
//            }
//        }
//
//        self.navigationItem.leftBarButtonItem = backBarButtion
//    }
//
//    // Create navigation right bar button..
//    fileprivate func createNavigationRightButton() {
//
//        let button = UIButton(type: .custom)
//        let btnHeight = 40
//        button.frame = CGRect(x: 0, y: 0, width: btnHeight, height: btnHeight)
//        button.setImage(UIImage(named: "share_icon"), for: .normal)
//        button.setTitleColor(UIColor.white, for: .normal)
//        let infoBarButton = self.addInfoBarButton()
//        if infoBarButton != nil{
//            self.navigationController?.navigationBar.topItem?.rightBarButtonItems = [UIBarButtonItem(customView: button),infoBarButton!]
//        }else{
//            self.navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(customView: button)
//        }
//
//        button.touchUpInside { [weak self](_) in
//            guard let _ = self else {return}
//            if let shareListVC = CStoryboardFile.instantiateViewController(withIdentifier: "SharedListVC") as? SharedListVC {
//                shareListVC.folder = self?.folder
//                self?.navigationController?.pushViewController(shareListVC, animated: true)
//            }
//        }
//    }
//}
//
////MARK: - UISearchBarDelegate
//extension SharedFilesDetailsVC: UISearchBarDelegate {
//
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//
//    }
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        self.resignKeyboard()
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//
//        if apiTask?.state == URLSessionTask.State.running {
//            apiTask?.cancel()
//        }
//        self.timestamp = 0
//        self.arrMedia.removeAll()
//        if searchText.isBlank{
//            self.arrMedia += self.failedFiles
//        }
//        self.getFileListFromServer(isLoader: false)
//    }
//}
//
////MARK: - UITableView Delegate & Data Source
//extension SharedFilesDetailsVC: UITableViewDelegate,UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return ((CScreenWidth * 60) / 375)
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if arrMedia.count == 0 {
//            //tblSharedFile.setEmptyMessage(CNoFileYet)
//            tblSharedFile.setEmptyMessage(CNoFileAdded)
//            return 0
//        }
//        tblSharedFile.restore()
//        return arrMedia.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        if arrMedia.count <= indexPath.row{
//            return UITableViewCell(frame: .zero)
//        }
//
//        if let cell = tableView.dequeueReusableCell(withIdentifier: "CreateFileTableCell") as? CreateFileTableCell {
//
//            let media = arrMedia[indexPath.row]
//
//            cell.vwShareFile.isHidden = false
//            cell.imgV.isHidden = true
//            cell.lblFileDate.isHidden = false
//
//            if let file = media.fileList{
//                /// Here is the configure cell for list of files are from server.
//                cell.lblFileName.text = file.fileName
//                cell.lblFileDate.text = file.createdDate
//
//                if media.assetType == .Image{
//                    cell.imgV.loadImageFromUrl(file.filePath, false)
//                    cell.imgV.isHidden = false
//                }
//
//            }else{
//                /// If user has added files from Gallery or File controller
//                /// then it will be configure here.
//                cell.lblFileName.text = media.fileName ?? ""
//                cell.lblFileDate.text = media.createdAt
//
//                if media.assetType == .Image{
//                    cell.imgV.image = media.image
//                    cell.imgV.isHidden = false
//                }
//            }
//
//            cell.updateStatus(status: media.uploadMediaStatus)
//
//            cell.btnShareFile.tag = indexPath.row
//            /// on Share File button
//            cell.btnShareFile.touchUpInside {[weak self] (sender) in
//                guard let self = self else { return }
//                let model = self.arrMedia[sender.tag]
//                if let file = model.fileList{
//
//                    guard let url = URL(string: file.filePath) else{return}
//
//                    if let fileSharing = FileSharingProgressVC.getInstance(){
//                        //fileSharing.presentController(controller:self)
//
//                        fileSharing.downloadfile(controller: self, fileUrl: url, folderID: file.id, completion: { (status, url) in
//                            if status{
//                                let objectsToShare = [url]
//                                let activityVC = UIActivityViewController(activityItems: objectsToShare as [Any], applicationActivities: nil)
//
//                                //New Excluded Activities Code
//                                //activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop]
//
//                                activityVC.popoverPresentationController?.sourceView = sender
//                                if #available(iOS 13.0, *){
//                                    activityVC.isModalInPresentation = true
//                                    activityVC.modalPresentationStyle = .fullScreen
//                                }
//                                self.present(activityVC, animated: true, completion: nil)
//                                activityVC.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
//                                    print("activityVC.completionWithItemsHandler")
//                                    if let _url = url {
//                                        try! FileManager.default.removeItem(at: _url)
//                                    }
//                                    if completed == true {
//                                    }
//                                }
//                            }
//                        })
//                        return
//                    }
//                }
//            }
//
//            cell.btnStatus.tag = indexPath.row
//            cell.btnStatus.isHidden = self.isFromSharedFiles
//            /// on close or Info button
//            cell.btnStatus.touchUpInside {[weak self] (_) in
//                guard let _ = self else{return}
//                switch media.uploadMediaStatus{
//                case .Pendding:
//                    self?.deleteFile(cell.btnStatus.tag)
//                case .Succeed: /// If file is available on server
//                    self?.presentAlertViewWithTwoButtons(alertTitle: nil, alertMessage: CMessageDeleteFile , btnOneTitle: CBtnYes, btnOneTapped: { [weak self] (_) in
//                        guard let _ = self else {return}
//                        GCDMainThread.async {
//                            self?.apiDeleteFile(index: cell.btnStatus.tag)
//                        }
//                        }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
//                case .Failed: /// If file is filed to upload on server
//                    /// and file type is not allowed to upload
//                    self?.presentAlertViewWithTwoButtons(alertTitle: nil, alertMessage: CFileTypeNotAllowedtoUpload, btnOneTitle: CBtnDelete, btnOneTapped: { [weak self] (_) in
//                        guard let _ = self else {return}
//                        GCDMainThread.async {
//                            if let file = self?.arrMedia[cell.btnStatus.tag]{
//                                self?.failedFiles.remove(object: file)
//                            }
//                            self?.arrMedia.remove(at: cell.btnStatus.tag)
//                            self?.tblSharedFile.reloadData()
//                        }
//                        }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
//                case .FailedWithRetry: /// If file is filed whule uploading
//                    self?.presentAlertViewWithTwoButtons(alertTitle: nil, alertMessage: CThereIsSomeIssueInUploadingFile , btnOneTitle: CBtnRetry, btnOneTapped: { [weak self] (_) in
//                        guard let _ = self else {return}
//                        GCDMainThread.async {
//                            self?.createFiles(file: self?.arrMedia[cell.btnStatus.tag])
//                        }
//                        }, btnTwoTitle: CBtnRemove, btnTwoTapped: { [weak self] (_) in
//                            guard let _ = self else {return}
//                            GCDMainThread.async {
//                                if let file = self?.arrMedia[cell.btnStatus.tag]{
//                                    self?.failedFiles.remove(object: file)
//                                }
//                                self?.arrMedia.remove(at: cell.btnStatus.tag)
//                                self?.tblSharedFile.reloadData()
//                            }
//                    })
//                case .FileExist: /// If file is filed to upload on server
//                    /// and file type is not allowed to upload
//                    self?.presentAlertViewWithOneButton(alertTitle: nil, alertMessage: CFileIsAlreadyExistsInThisFolder, btnOneTitle: CBtnDelete, btnOneTapped: { [weak self] (_) in
//                        guard let _ = self else {return}
//                        GCDMainThread.async {
//                            if let file = self?.arrMedia[cell.btnStatus.tag]{
//                                self?.failedFiles.remove(object: file)
//                            }
//                            self?.arrMedia.remove(at: cell.btnStatus.tag)
//                            self?.tblSharedFile.reloadData()
//                        }
//                    })
//                }
//            }
//            // Load more data....
//            if (indexPath == tblSharedFile.lastIndexPath()) && !self.isLoadMoreCompleted && apiTask?.state != URLSessionTask.State.running {
//                self.getFileListFromServer(isLoader: false)
//            }
//            return cell
//        }
//        return UITableViewCell()
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        if arrMedia.count <= indexPath.row{
//            return
//        }
//        let media = arrMedia[indexPath.row]
//        if let file = media.fileList{
//
//            guard let url = URL(string: file.filePath) else{return}
//            let fileType = AssetTypes.getType(ext: url.pathExtension)
//
//            if fileType == .Video{
//
//                /// Video will be play from server URL
//                let player = AVPlayer(url: url)
//                let playerViewController = AVPlayerViewController()
//                playerViewController.player = player
//                if #available(iOS 13.0, *){
//                    playerViewController.isModalInPresentation = true
//                    playerViewController.modalPresentationStyle = .fullScreen
//                }
//                self.present(playerViewController, animated: true) {
//                    playerViewController.player!.play()
//                }
//                return
//
//            }else if fileType == .Image{
//                guard let cell = tableView.cellForRow(at: indexPath) as? CreateFileTableCell else {
//                    return
//                }
//                let lightBoxHelper = LightBoxControllerHelper()
//                lightBoxHelper.openSingleImage(image: cell.imgV.image, viewController: self)
//
//                return
//            }
//
//            guard QLPreviewController.canPreview(url as QLPreviewItem) else{
//                self.presentAlertViewWithOneButton(alertTitle: nil, alertMessage:CUnsupportedFileType, btnOneTitle: CBtnOk , btnOneTapped: nil)
//                return
//            }
//
//            if let fileSharing = FileSharingProgressVC.getInstance(){
//
//                fileSharing.downloadfile(controller: self, fileUrl: url, folderID: file.id, completion: { [weak self] (status, fileURL) in
//                    guard let self = self else { return }
//                    if status{
//                        if let _url = fileURL{
//                            self.previewFile(fileURL: _url)
//                        }
//                    }
//                })
//            }
//        }
//    }
//
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let footerView = UIView()
//        footerView.backgroundColor = .clear
//        footerView.isUserInteractionEnabled = false
//        return footerView
//    }
//
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 70
//    }
//
//}
//
////MARK: - Action Events
//extension SharedFilesDetailsVC {
//
//    @IBAction func btnAddFolderAction(_ sender: UIButton) {
//
//        self.presentActionsheetWithTwoButtons(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CNavFiles, btnOneStyle: .default, btnOneTapped: { [weak self] (filesButton) in
//            //print("Files")
//            guard let self = self else { return }
//            let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.audio", "public.video", "public.text", "com.apple.iwork.pages.pages", "public.data"], in: .import)
//
//            documentPicker.delegate = self
//            self.present(documentPicker, animated: true, completion: nil)
//
//        }, btnTwoTitle: CBtnGallery, btnTwoStyle: .default) { [weak self] (cameraButton) in
//            guard let self = self else { return }
//            self.pickerButtonTap()
//        }
//    }
//}
//
//
////MARK: - API Function
//extension SharedFilesDetailsVC {
//
//    @objc func pullToRefresh() {
//
//        if apiTask?.state == URLSessionTask.State.running {
//            apiTask?.cancel()
//        }
//
//        if !self.arrMedia.isEmpty{
//            self.failedFiles = self.arrMedia.filter({$0.uploadMediaStatus == .Failed || $0.uploadMediaStatus == .Failed})
//        }
//        self.arrMedia.removeAll()
//        self.arrMedia += self.failedFiles
//        self.isLoadMoreCompleted = false
//        self.timestamp = 0
//        self.refreshControl.beginRefreshing()
//        self.getFileListFromServer(isLoader: false)
//    }
//
//    func getFileListFromServer(isLoader:Bool = true) {
//
//        var para = [String : Any]()
//
//        para["search"] = self.searchBarSharedFile.text
//        para[CFolderID] = folder.id
//        para[CTimestamp] = self.timestamp // == 0 ? "" : self.timestamp
//
//        apiTask = APIRequest.shared().fileList(param: para, showLoader: isLoader, completion: { (response, error) in
//            self.refreshControl.endRefreshing()
//            self.apiTask?.cancel()
//            if response != nil {
//                GCDMainThread.async {
//                    let data = response![CData] as? [String : Any] ?? [:]
//                    let arrData = data[CFiles] as? [[String : Any]] ?? []
//                    self.isLoadMoreCompleted = (arrData.count == 0)
//                    for obj in arrData {
//                        let media = MDLAddMedia()
//                        media.isFromGallery = false
//                        media.uploadMediaStatus = .Succeed
//                        media.fileList = MDLFileList(fromDictionary: obj)
//                        media.assetType = AssetTypes.getTypeFromValue(value: media.fileList?.type ?? "")
//                        self.arrMedia.append(media)
//                        self.timestamp = media.fileList?.createdAt ?? 0
//                    }
//                    self.tblSharedFile.reloadData()
//                }
//            }
//        })
//    }
//
//    fileprivate func createFiles(file:MDLAddMedia?) {
//
//        let dispatchGroup = DispatchGroup()
//
//        var uploadFiles : [MDLAddMedia] = []
//
//        if file != nil{ /// For single file upload
//            uploadFiles.append(file!)
//        }else{ /// For multiple file upload
//            uploadFiles = self.arrMedia.filter({$0.uploadMediaStatus == .Pendding})
//        }
//        if uploadFiles.isEmpty{
//            return
//        }
//
//        GCDMainThread.async {
//            MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
//        }
//        var statusFailed = false
//        let concurrentQueue = DispatchQueue(label: "queue", attributes: .concurrent)
//        let semaphore = DispatchSemaphore(value: 1)
//        var index = 0
//        for asset in uploadFiles {
//            var para = [String : Any]()
//            para[CFolderID] = folder.id
//            para[CFileType] = asset.assetType.rawValue
//            print(para)
//            dispatchGroup.enter()
//            concurrentQueue.async {
//                semaphore.wait() /// wait until last file is not upload
//                index += 1
//                var strPlaceholder = ""
//                if uploadFiles.count > 1{
//                    strPlaceholder = "(\(index) \(COutOf) \(uploadFiles.count))\n"
//                }
//                print("----------------------------------")
//                print((BASEURL + CAPITagCreateFiles))
//                print(para)
//                print(CFile)
//
//                APIRequest.shared().uploadFiles(apiName: CAPITagCreateFiles, param: para, key: CFile, assets: asset, progressBlock: { (progress) in
//
//                    var str = "\(CMessagePleaseWait)...\n"
//                    str += "\(strPlaceholder)"
//                    str += "\(CUploading) \(Int(progress))%"
//                    //MILoader.shared.setLblMessageText(message:str)
//                    //print("==> \(str)")
//                    GCDMainThread.async {
//                        MILoader.shared.setLblMessageText(message:str)
//                        MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: str)
//                    }
//
//
//                }, completion: { [weak self] (response, error) in
//                    guard let _ = self else {
//                        statusFailed = true
//                        dispatchGroup.leave()
//                        semaphore.signal()
//                        return
//                    }
//
//                    if response != nil {
//                        print("File Response : \(response ?? "[:]" as AnyObject)")
//                        if let meta = response!.value(forKey: CJsonMeta) as? [String : Any]{
//                            if meta.valueForInt(key: CStatus) == 0{
//                                let data = response!.value(forKey: CData) as? [String : Any] ?? [:]
//                                asset.isFromGallery = false
//                                asset.fileList = MDLFileList(fromDictionary: data)
//                                asset.assetType = AssetTypes.getTypeFromValue(value: asset.fileList?.type ?? "")
//                                asset.uploadMediaStatus = .Succeed
//                            }else if meta.valueForInt(key: CStatus) == 1{
//                                asset.uploadMediaStatus = .FileExist
//                                //statusFailed = false
//                                if !(self?.failedFiles.contains(asset) ?? false){
//                                    self?.failedFiles.insert(asset, at: 0)
//                                }
//                            }else{
//                                asset.uploadMediaStatus = .Failed
//                                statusFailed = true
//                                if !(self?.failedFiles.contains(asset) ?? false){
//                                    self?.failedFiles.insert(asset, at: 0)
//                                }
//                            }
//                        }else{
//                            let data = response as? [String:Any]
//                            if data?.valueForInt(key: CStatus) == 400{
//                                asset.uploadMediaStatus = .Failed
//                                statusFailed = true
//                                if !(self?.failedFiles.contains(asset) ?? false){
//                                    self?.failedFiles.insert(asset, at: 0)
//                                }
//                            }else{
//                                asset.uploadMediaStatus = .FailedWithRetry
//                                statusFailed = true
//                                if !(self?.failedFiles.contains(asset) ?? false){
//                                    self?.failedFiles.insert(asset, at: 0)
//                                }
//                            }
//                        }
//                    }else{
//                        if !(self?.failedFiles.contains(asset) ?? false){
//                            self?.failedFiles.insert(asset, at: 0)
//                        }
//                        if (error?.code ?? 0) == 400 {
//                            asset.uploadMediaStatus = .Failed
//                            statusFailed = true
//                        }else{
//                            asset.uploadMediaStatus = .FailedWithRetry
//                            statusFailed = true
//                        }
//                    }
//                    semaphore.signal()
//                    dispatchGroup.leave()
//                })
//            }
//        }
//
//        dispatchGroup.notify(queue: .main) {
//            /// DispatchGroup will be notify once all task has been completed
//            DispatchQueue.main.async {
//                MILoader.shared.hideLoader()
//                if let controller = self.navigationController?.getViewControllerFromNavigation(FileSharingViewController.self){
//                    controller.fileVC?.myFilesSharedFilesFolders()
//                }
//                let arrSucceed = self.arrMedia.filter({$0.uploadMediaStatus == .Succeed})
//                self.arrMedia = self.failedFiles
//                self.arrMedia += arrSucceed
//                self.tblSharedFile.reloadData()
//                if statusFailed{
//                    var strMsg = CThereIsSomeIssueInUploadingFile
//                    if self.failedFiles.count > 1{
//                        strMsg = CThereIsSomeIssueInUploadingFiles
//                    }
//                    self.presentAlertViewWithOneButton(alertTitle: nil, alertMessage:strMsg, btnOneTitle: CBtnOk , btnOneTapped: nil)
//                }
//            }
//        }
//    }
//
//    fileprivate func checkFileExistOnServer(){
//        var arrFilesName : [String] = []
//        for file in self.arrMedia{
//            if file.uploadMediaStatus == .Pendding, let fileName = file.fileName{
//                arrFilesName.append(fileName.lowercased())
//            }
//        }
//        var para = [String : Any]()
//        para[CFolderID] = self.folder.id
//        para["file_name"] =  arrFilesName
//        print(para)
//
//        APIRequest.shared().checkFilesExists(param: para, showLoader: true) { (response, error) in
//            if response != nil {
//                if let arrData = response!.value(forKey: CData) as? [[String : Any]]{
//                    for data in arrData{
//                        guard data.valueForInt(key: "status") == 1 else{
//                            continue
//                        }
//                        let fname = data.valueForString(key: "file_name")
//                        guard let fileObj = self.arrMedia.filter({($0.fileName ?? "").lowercased() == fname.lowercased() && $0.uploadMediaStatus == .Pendding}).first else{
//                            continue
//                        }
//                        fileObj.uploadMediaStatus = .FileExist
//                    }
//                    DispatchQueue.main.async {
//                        self.tblSharedFile.reloadData()
//                        self.createFiles(file: nil)
//                    }
//                }
//            }
//        }
//    }
//
//    fileprivate func apiDeleteFile(index:Int){
//        if self.arrMedia.count <= index{
//            return
//        }
//        let fileName = self.arrMedia[index].fileList?.fileName ?? ""
//        var para = [String : Any]()
//        para["file_id"] = self.arrMedia[index].fileList?.id
//        para[CFolderID] = self.folder.id
//
//        APIRequest.shared().deleteFile(param: para, showLoader: true) { (response, error) in
//            if response != nil {
//                GCDMainThread.async {
//
//                    if let controller = self.navigationController?.getViewControllerFromNavigation(FileSharingViewController.self){
//                        controller.fileVC?.getUserStorageSpace(isLoader: false)
//                    }
//                    self.deleteFileInLocalStorage(fileName: fileName)
//                    self.arrMedia.remove(at: index)
//                    self.tblSharedFile.reloadData()
//                }
//            }
//        }
//    }
//}
//
////MARK: - UIDocument Picker Delegate
//extension SharedFilesDetailsVC: UIDocumentPickerDelegate {
//
//    func fileSize(forURL url: URL) -> Double {
//        let fileURL = url
//        var fileSize: Double = 0.0
//        var fileSizeValue = 0.0
//        try? fileSizeValue = (fileURL.resourceValues(forKeys: [URLResourceKey.fileSizeKey]).allValues.first?.value as? Double ?? 0.0)
//        if fileSizeValue > 0.0 {
//            fileSize = (Double(fileSizeValue) / (UnitOfBytes))
//        }
//        return fileSize // KB
//    }
//
//    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
//
//        let fileUrl = url
//        print("The Url is : \(fileUrl)")
//
//        let arrRestricted = self.restrictedFile.filter({$0.fileName.lowercased() == fileUrl.pathExtension.lowercased()})
//        /// Check file is exist in restricted file list
//        if arrRestricted.count > 0{
//            DispatchQueue.main.async {
//                self.presentAlertViewWithOneButton(alertTitle: nil, alertMessage: CFileTypeNotAllowedtoUpload, btnOneTitle: CBtnOk , btnOneTapped: nil)
//            }
//            return
//        }
//        /// Check the storage space before uploading
//        print("File Size : \(fileSize(forURL: fileUrl))")
//        let size = self.fileSize(forURL: fileUrl)
//
//        let sizeMB = size / UnitOfBytes
//        let sizeGB = sizeMB / UnitOfBytes
//        if sizeGB > 1 {
//            DispatchQueue.main.async {
//                self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMaximumFileSizeAllowedToUploadIs1GB, btnOneTitle: CBtnOk , btnOneTapped: nil)
//            }
//            return
//        }
//        self.selectedData += size
//        if selectedData > totalSpace {
//            print("Disk is Full....")
//            self.selectedData -= size
//            DispatchQueue.main.async {
//                self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CStoregFullMessage, btnOneTitle: CBtnOk , btnOneTapped: nil)
//            }
//            return
//        }
//
//        /*if !Utility.isFileTypeAllowsToUpload(controller:self, extention: fileUrl.pathExtension){ return}*/
//
//        let assetTypes = AssetTypes.getType(ext: fileUrl.pathExtension)
//        let media = MDLAddMedia()
//        media.url = fileUrl.absoluteString
//        media.isDownloadedFromiCloud = false
//        media.fileName = fileUrl.lastPathComponent
//        media.assetType = assetTypes
//        media.createdAt = Date.generateCurrentWith()
//        media.isFromGallery = false
//        if assetTypes == .Image{
//            if let imageData = try? Data(contentsOf: fileUrl){
//                media.image = UIImage(data: imageData)
//                self.arrMedia.insert(media, at: 0)
//                self.tblSharedFile.reloadData()
//            }
//        }else{
//            self.arrMedia.insert(media, at: 0)
//            self.tblSharedFile.reloadData()
//        }
//        checkFileExistOnServer()
//        //self.createFiles(file: nil)
//    }
//
//    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
//        print(" cancelled by user")
//        dismiss(animated: true, completion: nil)
//    }
//}
//
////MARK: - TLPhotosPickerViewController
//extension SharedFilesDetailsVC {
//
//    func pickerButtonTap() {
//
//        photosPickerViewController.delegate = self
//        var configure = TLPhotosPickerConfigure()
//        configure.usedCameraButton = false
//        configure.numberOfColumn = 3
//        configure.maxSelectedAssets = 10
//        configure.recordingVideoQuality = .typeMedium
//        photosPickerViewController.configure = configure
//        photosPickerViewController.selectedAssets = self.arrMedia.filter({$0.isFromGallery}).compactMap({$0.asset})
//        photosPickerViewController.logDelegate = self
//        if #available(iOS 13.0, *){
//            photosPickerViewController.isModalInPresentation = true
//            photosPickerViewController.modalPresentationStyle = .fullScreen
//        }
//        self.present(photosPickerViewController, animated: true, completion: nil)
//    }
//
//    func converVideoByteToHumanReadable(_ bytes:Int64) -> String {
//        let formatter:ByteCountFormatter = ByteCountFormatter()
//        formatter.countStyle = .binary
//        return formatter.string(fromByteCount: Int64(bytes))
//    }
//    func MIMEType(_ url: URL?) -> String? {
//        guard let ext = url?.pathExtension else { return nil }
//        if !ext.isEmpty {
//            let UTIRef = UTTypeCreatePreferredIdentifierForTag("public.filename-extension" as CFString, ext as CFString, nil)
//            let UTI = UTIRef?.takeUnretainedValue()
//            UTIRef?.release()
//            if let UTI = UTI {
//                guard let MIMETypeRef = UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType) else { return nil }
//                let MIMEType = MIMETypeRef.takeUnretainedValue()
//                MIMETypeRef.release()
//                return MIMEType as String
//            }
//        }
//        return nil
//    }
//
//    func exportVideoFile(asset:TLPHAsset ,options: PHVideoRequestOptions? = nil, progressBlock:((Float) -> Void)? = nil, completionBlock:@escaping ((URL?,String) -> Void)) {
//        guard let phAsset = asset.phAsset, phAsset.mediaType == .video else {
//            completionBlock(nil,"")
//            return
//        }
//        var type = PHAssetResourceType.video
//        guard let resource = (PHAssetResource.assetResources(for: phAsset).filter{ $0.type == type }).first else {
//            completionBlock(nil,"")
//            return
//        }
//        let fileName = resource.originalFilename
//        var writeURL: URL? = nil
//        if #available(iOS 10.0, *) {
//            writeURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(fileName)")
//        } else {
//            writeURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true).appendingPathComponent("\(fileName)")
//        }
//        guard let localURL = writeURL,let mimetype = MIMEType(writeURL) else {
//            completionBlock(nil,"")
//            return
//        }
//        var requestOptions = PHVideoRequestOptions()
//        if let options = options {
//            requestOptions = options
//        }else {
//            requestOptions.isNetworkAccessAllowed = true
//        }
//        PHImageManager.default().requestAVAsset(forVideo: phAsset, options: options) { (avasset, avaudioMix, infoDict) in
//            guard let avasset = avasset else {
//                print("PHImageManager.default().requestAVAsset Faild!!!")
//                completionBlock(nil,"")
//                return
//            }
//            let exportSession = AVAssetExportSession.init(asset: avasset, presetName: AVAssetExportPresetHighestQuality)
//            exportSession?.outputURL = localURL
//            exportSession?.outputFileType = AVFileType.mov
//            exportSession?.exportAsynchronously(completionHandler: {
//                completionBlock(localURL,mimetype)
//            })
//            func checkExportSession() {
//                DispatchQueue.global().async { [weak exportSession] in
//                    guard let exportSession = exportSession else {
//                        print("checkExportSession Faild!!!")
//                        completionBlock(nil,"")
//                        return
//                    }
//                    switch exportSession.status {
//                    case .waiting,.exporting:
//                        DispatchQueue.main.async {
//                            progressBlock?(exportSession.progress)
//                        }
//                        Thread.sleep(forTimeInterval: 1)
//                        checkExportSession()
//                    default:
//                        break
//                    }
//                }
//            }
//            checkExportSession()
//        }
//    }
//
//    func exportVideo(placeholder:String,asset:TLPHAsset ,onComplete:((_ thembnil:UIImage?,_ videoURL:URL?)->Void)?) {
//        var vThum : UIImage!
//        var vUrl : URL!
//        if let thum = asset.fullResolutionImage{
//            print(thum)
//            vThum = thum
//            /*if let videoURL = vUrl, let videoThum = vThum{
//                onComplete?(videoThum,videoURL)
//            }*/
//        }
//        let options = PHVideoRequestOptions()
//        options.isNetworkAccessAllowed = true
//        options.deliveryMode = .automatic
//        //iCloud download progress
//        options.progressHandler = { (progress, error, stop, info) in
//            var str = "\(CMessagePleaseWait)...\n"
//            str += "\(placeholder)"
//            str += "\(CDownloadFromiCloud) \(Int(progress * 100))%"
//            //MILoader.shared.setLblMessageText(message:str)
//            GCDMainThread.async {
//                MILoader.shared.setLblMessageText(message:str)
//                MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: str)
//            }
//            print("Downloading from iCloud \(progress)")
//            if (error != nil) {
//                print(error?.localizedDescription ?? "")
//            }
//        }
//
//        self.exportVideoFile(asset: asset, options:options, progressBlock: { (progress) in
//
//            print(progress)
//            var str = "\(CMessagePleaseWait)...\n"
//            str += "\(placeholder)"
//            str += "\(CExportingFile) \(Int(progress * 100))%"
//            //MILoader.shared.setLblMessageText(message:str)
//            GCDMainThread.async {
//                MILoader.shared.setLblMessageText(message:str)
//                MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: str)
//            }
//
//        }) { (url, mimeType) in
//            print("exportVideoFile : \(url?.absoluteString ?? "URL not found")")
//            vUrl = url
//            if let videoURL = vUrl, let videoThum = vThum {
//                onComplete?(videoThum,videoURL)
//            }else{
//                onComplete?(nil,nil)
//            }
//        }
//    }
//
//    func getSelectedImage(asset:TLPHAsset, onComplete:((_ thembnil:UIImage)->Void)?) {
//
//        if let image = asset.fullResolutionImage {
//            print(image)
//            onComplete?(image)
//        }else {
//            print("Can't get image at local storage, try download image")
//            asset.cloudImageDownload(progressBlock: { [weak self] (progress) in
//                guard let _ = self else {return}
//                DispatchQueue.main.async {
//                    print(progress)
//                }
//                }, completionBlock: { [weak self] (image) in
//                    guard let _ = self else {return}
//                    if let _image = image {
//                        //use image
//                        DispatchQueue.main.async {
//                            print(_image)
//                            print("complete download")
//                            onComplete?(_image)
//                        }
//                    }
//            })
//        }
//    }
//}
//
////MARK: - TLPhotosPickerViewControllerDelegate ,TLPhotosPickerLogDelegate
//extension SharedFilesDetailsVC : TLPhotosPickerViewControllerDelegate,TLPhotosPickerLogDelegate {
//
//    func shouldDismissPhotoPicker(withTLPHAssets: [TLPHAsset]) -> Bool {
//
//        if withTLPHAssets.isEmpty{
//            return false
//        }
//
//        MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
//
//        self.arrMedia = self.arrMedia.filter({!$0.isFromGallery})
//
//        let concurrentQueue = DispatchQueue(label: "queue", attributes: .concurrent)
//        let semaphore = DispatchSemaphore(value: 1)
//        var index = 0
//        for asset in withTLPHAssets{
//
//            let resources = PHAssetResource.assetResources(for: asset.phAsset!)
//            var sizeOnDisk: Double = 0.0
//            if let resource = resources.first {
//                sizeOnDisk = resource.value(forKey: "fileSize") as? Double ?? 0.0
//                print("sizeOnDisk : \(sizeOnDisk)")
//                /// Check the storage space before uploading
//                self.selectedData += (sizeOnDisk / UnitOfBytes )
//                if self.selectedData > self.totalSpace{
//                    print("Disk is Full....")
//                    self.selectedData -= (sizeOnDisk / UnitOfBytes )
//                    DispatchQueue.main.async {
//                        self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CStoregFullMessage, btnOneTitle: CBtnOk , btnOneTapped: nil)
//                    }
//                    continue;
//                }
//            }
//            self.dispatchGroup.enter()
//
//            concurrentQueue.async {
//                semaphore.wait()
//                index += 1
//                switch asset.type{
//                case .video:
//                    var strPlaceholder = ""
//                    if withTLPHAssets.count > 1{
//                        strPlaceholder = "(\(index) \(COutOf) \(withTLPHAssets.count))\n"
//                    }
//                    self.exportVideo(placeholder: strPlaceholder, asset: asset) { [weak self] (thum,url)in
//                        guard let _ = thum, let _ = url else{
//                            self?.dispatchGroup.leave()
//                            semaphore.signal()
//                            return
//                        }
//                        guard let _ = self else {
//                            self?.dispatchGroup.leave()
//                            semaphore.signal()
//                            return
//                        }
//                        let media = MDLAddMedia()
//                        media.image = thum
//                        media.url = url!.absoluteString
//                        media.isDownloadedFromiCloud = true
//                        media.fileName = asset.originalFileName
//                        media.assetType = .Video
//                        media.createdAt = Date.generateCurrentWith()
//                        self?.arrMedia.insert(media, at: 0)
//                        GCDMainThread.async {
//                            self?.tblSharedFile.reloadData()
//                            self?.dispatchGroup.leave()
//                            semaphore.signal()
//                        }
//                    }
//                    break
//                case .livePhoto:
//
//                    self.getSelectedImage(asset: asset) { [weak self] (image) in
//                        guard let _ = self else {
//                            self?.dispatchGroup.leave()
//                            semaphore.signal()
//                            return
//                        }
//                        let media = MDLAddMedia()
//                        media.image = image
//                        media.fileName = asset.originalFileName
//                        media.isDownloadedFromiCloud = true
//                        media.assetType = .Image
//                        media.createdAt = Date.generateCurrentWith()
//                        self?.arrMedia.insert(media, at: 0)
//                        GCDMainThread.async {
//                            self?.tblSharedFile.reloadData()
//                            self?.dispatchGroup.leave()
//                            semaphore.signal()
//                        }
//                    }
//                    break
//                case .photo :
//
//                    self.getSelectedImage(asset: asset) { [weak self] (image) in
//                        guard let _ = self else {
//                            self?.dispatchGroup.leave()
//                            semaphore.signal()
//                            return
//                        }
//                        let media = MDLAddMedia()
//                        media.image = image
//                        media.fileName = asset.originalFileName
//                        media.isDownloadedFromiCloud = true
//                        media.assetType = .Image
//                        media.createdAt = Date.generateCurrentWith()
//                        self?.arrMedia.insert(media, at: 0)
//                        GCDMainThread.async {
//                            self?.tblSharedFile.reloadData()
//                            self?.dispatchGroup.leave()
//                            semaphore.signal()
//                        }
//                    }
//                    break
//                }
//            }
//        }
//
//        dispatchGroup.notify(queue: .main) {
//            print("all activities complete 👍")
//            MILoader.shared.hideLoader()
//            self.tblSharedFile.reloadData()
//            //self.createFiles(file: nil)
//            self.checkFileExistOnServer()
//        }
//        return true
//    }
//
//    func dismissPhotoPicker(withPHAssets: [PHAsset]) {
//    }
//
//    func handleNoAlbumPermissions(picker: TLPhotosPickerViewController) {
//        picker.dismiss(animated: true) {
//            let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!
//            let alert = UIAlertController(
//                title: nil,
//                message: CDeniedAlbumsPermission,
//                preferredStyle: .alert
//            )
//            alert.addAction(UIAlertAction(title: CBtnCancel, style: .destructive, handler: nil))
//            alert.addAction(UIAlertAction(title: CNavSettings, style: .default, handler: { (alert) -> Void in
//                UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
//            }))
//            self.present(alert, animated: true, completion: nil)
//        }
//    }
//
//    //For Log User Interaction
//    func selectedCameraCell(picker: TLPhotosPickerViewController) {
//        print("selectedCameraCell")
//    }
//
//    func selectedPhoto(picker: TLPhotosPickerViewController, at: Int) {
//        print("selectedPhoto")
//    }
//
//    func deselectedPhoto(picker: TLPhotosPickerViewController, at: Int) {
//        print("deselectedPhoto")
//    }
//
//    func selectedAlbum(picker: TLPhotosPickerViewController, title: String, at: Int) {
//        print("selectedAlbum")
//    }
//
//    func canSelectAsset(phAsset: PHAsset) -> Bool {
//
//        if phAsset.mediaType == .video{
//
//            let resources = PHAssetResource.assetResources(for: phAsset)
//            var sizeOnDisk: Int64? = 0
//            if let resource = resources.first {
//                let unsignedInt64 = resource.value(forKey: "fileSize") as? CLong
//                sizeOnDisk = Int64(bitPattern: UInt64(unsignedInt64!))
//            }
//
//            let onDisk = sizeOnDisk ?? 0
//            let sizeMB : Double = Double(onDisk) / 1000000.0
//            if sizeMB > UnitOfBytes {
//                DispatchQueue.main.async {
//                    self.photosPickerViewController.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMaximumFileSizeAllowedToUploadIs1GB, btnOneTitle: CBtnOk , btnOneTapped: nil)
//                }
//                return false
//            }
//            print(onDisk)
//        }
//
//        let resources = PHAssetResource.assetResources(for: phAsset)
//        if let resource = resources.first{
//            let strExtension = resource.originalFilename.components(separatedBy: ".").last ?? ""
//            let arrRestricted = self.restrictedFile.filter({$0.fileName.lowercased() == strExtension.lowercased()})
//            /// Check file is exist in restricted file list
//            if arrRestricted.count > 0{
//                DispatchQueue.main.async {
//                    self.photosPickerViewController.presentAlertViewWithOneButton(alertTitle: nil, alertMessage: CFileTypeNotAllowedtoUpload, btnOneTitle: CBtnOk , btnOneTapped: nil)
//                }
//                return false
//            }
//        }
//        return true
//    }
//}
//
////MARK: - QLPreviewControllerDataSource && Utility Methods
//extension SharedFilesDetailsVC : QLPreviewControllerDataSource,QLPreviewControllerDelegate {
//
//    func previewFile(fileURL:URL){
//
//        self.previewItem = fileURL as NSURL
//        let previewController = QLPreviewController()
//        previewController.dataSource = self
//        previewController.delegate = self
//        if #available(iOS 13.0, *){
//            previewController.isModalInPresentation = true
//            previewController.modalPresentationStyle = .fullScreen
//        }
//        self.present(previewController, animated: true, completion: nil)
//    }
//
//    func downloadfile(fileUrl:URL,completion: @escaping (_ success: Bool,_ fileLocation: URL?) -> Void){
//
//        // then lets create your document folder url
//        //var documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let documentsDirectoryURL = NSURL.fileURL(withPath: NSTemporaryDirectory(), isDirectory: true)
//        // Make a directory if Folder ID
//        //documentsDirectoryURL = documentsDirectoryURL.appendingPathComponent("\(self.folder.id ?? 0)")
//        do
//        {
//            try FileManager.default.createDirectory(at: documentsDirectoryURL, withIntermediateDirectories: true, attributes: nil)
//        }
//        catch let error as NSError
//        {
//            NSLog("Unable to create directory \(error.debugDescription)")
//        }
//
//        // lets create your destination file url
//        let destinationUrl = documentsDirectoryURL.appendingPathComponent(fileUrl.lastPathComponent)
//        print("File URL : \(destinationUrl.absoluteString)")
//        // to check if it exists before downloading it
//        if FileManager.default.fileExists(atPath: destinationUrl.path) {
//            debugPrint("The file already exists at path")
//            completion(true, destinationUrl)
//
//            // if the file doesn't exist
//        } else {
//
//            // you can use NSURLSession.sharedSession to download the data asynchronously
//            URLSession.shared.downloadTask(with: fileUrl, completionHandler: { (location, response, error) -> Void in
//                guard let tempLocation = location, error == nil else { return }
//                do {
//                    // after downloading your file you need to move it to your destination url
//                    try FileManager.default.moveItem(at: tempLocation, to: destinationUrl)
//                    print("File moved to documents folder")
//                    completion(true, destinationUrl)
//                } catch let error as NSError {
//                    print(error.localizedDescription)
//                    completion(false, nil)
//                }
//            }).resume()
//        }
//    }
//
//    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
//        return 1
//    }
//
//    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
//        return self.previewItem as QLPreviewItem
//    }
//
//    func previewControllerDidDismiss(_ controller: QLPreviewController) {
//        try? FileManager.default.removeItem(at: (previewItem as URL))
//    }
//}


/*
 import UIKit
 import QuickLook
 import TLPhotoPicker
 import Photos
 import AVKit
 import AVFoundation
 import MobileCoreServices
 import Lightbox
 
 class SharedFilesDetailsVC: ParentViewController {
 
 /// UISearchBar for search files in list
 @IBOutlet weak var searchBarSharedFile: UISearchBar! {
 didSet {
 searchBarSharedFile.placeholder = CSearch
 searchBarSharedFile.tintColor = .black
 
 searchBarSharedFile.change(textFont: CFontPoppins(size: (12 * CScreenWidth)/375, type: .regular))
 searchBarSharedFile.delegate = self
 
 searchBarSharedFile.backgroundImage = UIImage()
 let searchTextField = searchBarSharedFile.value(forKey: "searchField") as? UITextField
 searchTextField?.textColor = UIColor.black
 searchBarSharedFile.layer.cornerRadius = 0.0
 searchBarSharedFile.layer.masksToBounds = true
 
 if let searchFieldBackground = searchTextField?.subviews.first{
 searchFieldBackground.backgroundColor = UIColor.white
 searchFieldBackground.layer.cornerRadius = 20
 searchFieldBackground.clipsToBounds = true
 }
 }
 }
 
 @IBOutlet weak var tblSharedFile: UITableView! {
 didSet {
 self.tblSharedFile.tableFooterView = UIView(frame: .zero)
 self.tblSharedFile.allowsSelection = true
 self.tblSharedFile.register(UINib(nibName: "CreateFileTableCell", bundle: nil), forCellReuseIdentifier: "CreateFileTableCell")
 self.tblSharedFile.delegate = self
 self.tblSharedFile.dataSource = self
 self.refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
 self.refreshControl.tintColor = ColorAppTheme
 self.tblSharedFile.pullToRefreshControl = self.refreshControl
 }
 }
 
 /// btnAddFiles for add/upload new file
 @IBOutlet weak var btnAddFiles: UIButton!
 
 @IBOutlet weak var btnShowlistView: UIButton!
 
 /// Arrary of added item in list
 var arrMedia : [MDLAddMedia] = []
 var failedFiles : [MDLAddMedia] = []
 var isFromSharedFiles: Bool = false
 
 /// `dispatchGroup` Used for get assets item from gallery
 let dispatchGroup = DispatchGroup()
 
 /// refreshControl for pull to referesh
 var refreshControl = UIRefreshControl()
 
 /// `previewItem` containt a URL of previewing file from list
 lazy var previewItem = NSURL()
 
 /// `folder` it's containt folder id and name
 var folder : MDLCreateFolder!
 
 
 /// `storage` used for check remanning storage space while uploading files
 var storage : MDLStorage?
 var totalSpace = 0.0
 var selectedData = 0.0
 
 /// `timestamp` containt timestamp of last record. it's used for load more..
 var timestamp : Int = 0
 
 
 /// Check all the data are loaded from server
 var isLoadMoreCompleted = false
 
 var isSelect = false
 
 var apiTask : URLSessionTask?
 
 /// It's list of extension. It will be used while uploading file on server to check
 /// file is restricted or not
 var restrictedFile : [MDLRestractedFile] = []
 
 /// Select photos and video from Gallery
 let photosPickerViewController = TLPhotosPickerViewController()
 
 // MARK:- Life Cycle
 override func viewDidLoad() {
 super.viewDidLoad()
 self.initialization()
 self.createBackButton()
 self.getFileListFromServer()
 }
 
 override func viewDidAppear(_ animated: Bool) {
 super.viewWillAppear(true)
 
 if !self.isFromSharedFiles {
 createNavigationRightButton()
 }
 }
 //Show cloumss and main view contoller
 
 
 @IBAction func showClmButtonClick(_ sender: UIButton) {
 
 if let button = sender as? UIButton {
 if button.isSelected {
 isSelect = true
 //                button.backgroundColor = .blue
 button.isSelected = false
 self.tblSharedFile.reloadData()
 } else {
 // set selected
 isSelect = false
 //                    button.backgroundColor = .cyan
 button.isSelected = true
 self.tblSharedFile.reloadData()
 }
 }
 
 
 }
 
 
 /// Add the Share button from right side of the navigatin bar
 /// It's used to share file with your friends.
 /// - Returns: Share button If restricted file exist from server
 func addInfoBarButton() -> UIBarButtonItem?{
 
 if let controller = self.navigationController?.getViewControllerFromNavigation(FileSharingViewController.self){
 
 self.restrictedFile = controller.arrRestrictedFileType
 if self.restrictedFile.isEmpty{
 return nil
 }
 
 return BlockBarButtonItem(image: UIImage(named: "ic_info_tint"), style: .plain) { [weak self] (_) in
 guard let _ = self else {return}
 
 if let restrictionVC = CStoryboardFile.instantiateViewController(withIdentifier: "RestrictedFilesVC") as? RestrictedFilesVC{
 restrictionVC.arrDatasource = self?.restrictedFile ?? []
 self?.navigationController?.pushViewController(restrictionVC, animated: true)
 }
 }
 }
 return nil
 }
 
 // Delete Folder....
 func deleteFile(_ index: Int) {
 
 self.presentAlertViewWithTwoButtons(alertTitle: nil, alertMessage: CMessageDeleteFile , btnOneTitle: CBtnYes, btnOneTapped: { [weak self] (_) in
 guard let _ = self else {return}
 self?.arrMedia.remove(at: index)
 GCDMainThread.async {
 self?.tblSharedFile.reloadData()
 }
 
 }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
 }
 
 /// Delete file from document directory.
 // `folderID` is name of folder.
 ///
 /// - Parameter folderID: Name of folder
 fileprivate func deleteFileInLocalStorage(fileName:String){
 //var documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
 var documentsDirectoryURL = NSURL.fileURL(withPath: NSTemporaryDirectory(), isDirectory: true)
 //documentsDirectoryURL = documentsDirectoryURL.appendingPathComponent("\(self.folder.id ?? 0)")
 documentsDirectoryURL = documentsDirectoryURL.appendingPathComponent(fileName)
 print("FileManager.default.removeItem : \(documentsDirectoryURL.absoluteString)")
 
 do{
 try? FileManager.default.removeItem(at:documentsDirectoryURL)
 }
 }
 
 func getDownloadedFileURL(url:URL, completion:@escaping (URL?)->Void){
 
 self.downloadfile(fileUrl: url, completion: {(success, fileLocationURL) in
 DispatchQueue.main.async {
 //MILoader.shared.hideLoader()
 if success {
 // Set the preview item to display======
 //self.previewItem = fileLocationURL! as NSURL
 //self.previewFile(fileURL: fileLocationURL!)
 completion(fileLocationURL)
 }else{
 completion(nil)
 debugPrint("File can't be downloaded")
 }
 }
 })
 }
 
 deinit {
 print("Deinit -> SharedFilesDetailsVC")
 }
 }
 
 //MARK: - Initialization
 extension SharedFilesDetailsVC {
 
 fileprivate func initialization() {
 
 self.title = folder.folderName
 
 self.totalSpace = (self.storage?.totalSpace ?? 0) * UnitOfBytes
 self.selectedData = (self.storage?.uploaded ?? 0) * UnitOfBytes
 
 if  self.isFromSharedFiles {
 self.btnAddFiles.isHidden = true
 }
 
 registerForKeyboardWillShowNotification(tblSharedFile)
 registerForKeyboardWillHideNotification(tblSharedFile)
 }
 
 /// Add back button in navigation bar
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
 if self?.arrMedia.filter({$0.uploadMediaStatus == .Failed || $0.uploadMediaStatus == .Failed}).count ?? 0 > 0{
 
 self?.presentAlertViewWithTwoButtons(alertTitle: nil, alertMessage: CAlertMessageForFilesNotUploaded, btnOneTitle: CBtnNo, btnOneTapped: nil, btnTwoTitle: CBtnYes, btnTwoTapped: { (_) in
 self?.navigationController?.popViewController(animated: true)
 })
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
 let infoBarButton = self.addInfoBarButton()
 
 if infoBarButton != nil{
 self.navigationController?.navigationBar.topItem?.rightBarButtonItems = [UIBarButtonItem(customView: button),infoBarButton!]
 }else{
 self.navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(customView: button)
 }
 
 button.touchUpInside { [weak self](_) in
 guard let _ = self else {return}
 if let shareListVC = CStoryboardFile.instantiateViewController(withIdentifier: "SharedListVC") as? SharedListVC {
 shareListVC.folder = self?.folder
 self?.navigationController?.pushViewController(shareListVC, animated: true)
 }
 }
 }
 }
 
 //MARK: - UISearchBarDelegate
 extension SharedFilesDetailsVC: UISearchBarDelegate {
 
 func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
 
 }
 func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
 self.resignKeyboard()
 }
 
 func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
 
 if apiTask?.state == URLSessionTask.State.running {
 apiTask?.cancel()
 }
 self.timestamp = 0
 self.arrMedia.removeAll()
 if searchText.isBlank{
 self.arrMedia += self.failedFiles
 }
 self.getFileListFromServer(isLoader: false)
 }
 }
 
 //MARK: - UITableView Delegate & Data Source
 extension SharedFilesDetailsVC: UITableViewDelegate,UITableViewDataSource {
 
 func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
 if indexPath.section == 0{
 return ((CScreenWidth * 60) / 375)
 }else {
 //         return ((CScreenWidth * 85) / 375)
 return UITableView.automaticDimension
 }
 }
 
 func numberOfSections(in tableView: UITableView) -> Int {
 return 2
 }
 
 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 
 
 if isSelect == true {
 if section == 0{
 if arrMedia.count == 0 {
 tblSharedFile.setEmptyMessage(CNoFileAdded)
 return 0
 }
 tblSharedFile.restore()
 return arrMedia.count
 }else {
 return 1
 }
 }else if isSelect == false{
 return 1
 
 }
 return 1
 
 
 //        if section == 0{
 //        if arrMedia.count == 0 {
 //        tblSharedFile.setEmptyMessage(CNoFileAdded)
 //        return 0
 //       }
 //        tblSharedFile.restore()
 //        return arrMedia.count
 //        }else {
 //            return 1
 //        }
 
 
 }
 
 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
 if arrMedia.count <= indexPath.row{
 return UITableViewCell(frame: .zero)
 }
 
 if isSelect == true {
 
 if let cell = tableView.dequeueReusableCell(withIdentifier: "CreateFileTableCell") as? CreateFileTableCell {
 
 let media = arrMedia[indexPath.row]
 
 cell.vwShareFile.isHidden = false
 cell.imgV.isHidden = true
 cell.lblFileDate.isHidden = false
 
 if let file = media.fileList{
 /// Here is the configure cell for list of files are from server.
 cell.lblFileName.text = file.fileName
 cell.lblFileDate.text = file.createdDate
 
 if media.assetType == .Image{
 cell.imgV.loadImageFromUrl(file.filePath, false)
 cell.imgV.isHidden = false
 }
 
 }else{
 /// If user has added files from Gallery or File controller
 /// then it will be configure here.
 cell.lblFileName.text = media.fileName ?? ""
 cell.lblFileDate.text = media.createdAt
 
 if media.assetType == .Image{
 cell.imgV.image = media.image
 cell.imgV.isHidden = false
 }
 }
 
 cell.updateStatus(status: media.uploadMediaStatus)
 
 cell.btnShareFile.tag = indexPath.row
 /// on Share File button
 cell.btnShareFile.touchUpInside {[weak self] (sender) in
 guard let self = self else { return }
 let model = self.arrMedia[sender.tag]
 if let file = model.fileList{
 
 guard let url = URL(string: file.filePath) else{return}
 
 if let fileSharing = FileSharingProgressVC.getInstance(){
 //fileSharing.presentController(controller:self)
 
 fileSharing.downloadfile(controller: self, fileUrl: url, folderID: file.id, completion: { (status, url) in
 if status{
 let objectsToShare = [url]
 let activityVC = UIActivityViewController(activityItems: objectsToShare as [Any], applicationActivities: nil)
 
 //New Excluded Activities Code
 //activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop]
 
 activityVC.popoverPresentationController?.sourceView = sender
 if #available(iOS 13.0, *){
 activityVC.isModalInPresentation = true
 activityVC.modalPresentationStyle = .fullScreen
 }
 self.present(activityVC, animated: true, completion: nil)
 activityVC.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
 print("activityVC.completionWithItemsHandler")
 if let _url = url {
 try! FileManager.default.removeItem(at: _url)
 }
 if completed == true {
 }
 }
 }
 })
 return
 }
 }
 }
 
 cell.btnStatus.tag = indexPath.row
 cell.btnStatus.isHidden = self.isFromSharedFiles
 /// on close or Info button
 cell.btnStatus.touchUpInside {[weak self] (_) in
 guard let _ = self else{return}
 switch media.uploadMediaStatus{
 case .Pendding:
 self?.deleteFile(cell.btnStatus.tag)
 case .Succeed: /// If file is available on server
 self?.presentAlertViewWithTwoButtons(alertTitle: nil, alertMessage: CMessageDeleteFile , btnOneTitle: CBtnYes, btnOneTapped: { [weak self] (_) in
 guard let _ = self else {return}
 GCDMainThread.async {
 self?.apiDeleteFile(index: cell.btnStatus.tag)
 }
 }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
 case .Failed: /// If file is filed to upload on server
 /// and file type is not allowed to upload
 self?.presentAlertViewWithTwoButtons(alertTitle: nil, alertMessage: CFileTypeNotAllowedtoUpload, btnOneTitle: CBtnDelete, btnOneTapped: { [weak self] (_) in
 guard let _ = self else {return}
 GCDMainThread.async {
 if let file = self?.arrMedia[cell.btnStatus.tag]{
 self?.failedFiles.remove(object: file)
 }
 self?.arrMedia.remove(at: cell.btnStatus.tag)
 self?.tblSharedFile.reloadData()
 }
 }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
 case .FailedWithRetry: /// If file is filed whule uploading
 self?.presentAlertViewWithTwoButtons(alertTitle: nil, alertMessage: CThereIsSomeIssueInUploadingFile , btnOneTitle: CBtnRetry, btnOneTapped: { [weak self] (_) in
 guard let _ = self else {return}
 GCDMainThread.async {
 self?.createFiles(file: self?.arrMedia[cell.btnStatus.tag])
 }
 }, btnTwoTitle: CBtnRemove, btnTwoTapped: { [weak self] (_) in
 guard let _ = self else {return}
 GCDMainThread.async {
 if let file = self?.arrMedia[cell.btnStatus.tag]{
 self?.failedFiles.remove(object: file)
 }
 self?.arrMedia.remove(at: cell.btnStatus.tag)
 self?.tblSharedFile.reloadData()
 }
 })
 case .FileExist: /// If file is filed to upload on server
 /// and file type is not allowed to upload
 self?.presentAlertViewWithOneButton(alertTitle: nil, alertMessage: CFileIsAlreadyExistsInThisFolder, btnOneTitle: CBtnDelete, btnOneTapped: { [weak self] (_) in
 guard let _ = self else {return}
 GCDMainThread.async {
 if let file = self?.arrMedia[cell.btnStatus.tag]{
 self?.failedFiles.remove(object: file)
 }
 self?.arrMedia.remove(at: cell.btnStatus.tag)
 self?.tblSharedFile.reloadData()
 }
 })
 }
 }
 // Load more data....
 if (indexPath == tblSharedFile.lastIndexPath()) && !self.isLoadMoreCompleted && apiTask?.state != URLSessionTask.State.running {
 self.getFileListFromServer(isLoader: false)
 }
 return cell
 }
 
 
 }else {
 
 if let cell = tableView.dequeueReusableCell(withIdentifier: "TblSharedFileDetailsCollCell") as? TblSharedFileDetailsCollCell {
 cell.arrMediaFiles = arrMedia
 cell.layoutIfNeeded()
 return cell
 }
 
 }
 
 //        if indexPath.section == 0{
 //        if let cell = tableView.dequeueReusableCell(withIdentifier: "CreateFileTableCell") as? CreateFileTableCell {
 //
 //            let media = arrMedia[indexPath.row]
 //
 //            cell.vwShareFile.isHidden = false
 //            cell.imgV.isHidden = true
 //            cell.lblFileDate.isHidden = false
 //
 //            if let file = media.fileList{
 //                /// Here is the configure cell for list of files are from server.
 //                cell.lblFileName.text = file.fileName
 //                cell.lblFileDate.text = file.createdDate
 //
 //                if media.assetType == .Image{
 //                    cell.imgV.loadImageFromUrl(file.filePath, false)
 //                    cell.imgV.isHidden = false
 //                }
 //
 //            }else{
 //                /// If user has added files from Gallery or File controller
 //                /// then it will be configure here.
 //                cell.lblFileName.text = media.fileName ?? ""
 //                cell.lblFileDate.text = media.createdAt
 //
 //                if media.assetType == .Image{
 //                    cell.imgV.image = media.image
 //                    cell.imgV.isHidden = false
 //                }
 //            }
 //
 //            cell.updateStatus(status: media.uploadMediaStatus)
 //
 //            cell.btnShareFile.tag = indexPath.row
 //            /// on Share File button
 //            cell.btnShareFile.touchUpInside {[weak self] (sender) in
 //                guard let self = self else { return }
 //                let model = self.arrMedia[sender.tag]
 //                if let file = model.fileList{
 //
 //                    guard let url = URL(string: file.filePath) else{return}
 //
 //                    if let fileSharing = FileSharingProgressVC.getInstance(){
 //                        //fileSharing.presentController(controller:self)
 //
 //                        fileSharing.downloadfile(controller: self, fileUrl: url, folderID: file.id, completion: { (status, url) in
 //                            if status{
 //                                let objectsToShare = [url]
 //                                let activityVC = UIActivityViewController(activityItems: objectsToShare as [Any], applicationActivities: nil)
 //
 //                                //New Excluded Activities Code
 //                                //activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop]
 //
 //                                activityVC.popoverPresentationController?.sourceView = sender
 //                                if #available(iOS 13.0, *){
 //                                    activityVC.isModalInPresentation = true
 //                                    activityVC.modalPresentationStyle = .fullScreen
 //                                }
 //                                self.present(activityVC, animated: true, completion: nil)
 //                                activityVC.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
 //                                    print("activityVC.completionWithItemsHandler")
 //                                    if let _url = url {
 //                                        try! FileManager.default.removeItem(at: _url)
 //                                    }
 //                                    if completed == true {
 //                                    }
 //                                }
 //                            }
 //                        })
 //                        return
 //                    }
 //                }
 //            }
 //
 //            cell.btnStatus.tag = indexPath.row
 //            cell.btnStatus.isHidden = self.isFromSharedFiles
 //            /// on close or Info button
 //            cell.btnStatus.touchUpInside {[weak self] (_) in
 //                guard let _ = self else{return}
 //                switch media.uploadMediaStatus{
 //                case .Pendding:
 //                    self?.deleteFile(cell.btnStatus.tag)
 //                case .Succeed: /// If file is available on server
 //                    self?.presentAlertViewWithTwoButtons(alertTitle: nil, alertMessage: CMessageDeleteFile , btnOneTitle: CBtnYes, btnOneTapped: { [weak self] (_) in
 //                        guard let _ = self else {return}
 //                        GCDMainThread.async {
 //                            self?.apiDeleteFile(index: cell.btnStatus.tag)
 //                        }
 //                        }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
 //                case .Failed: /// If file is filed to upload on server
 //                    /// and file type is not allowed to upload
 //                    self?.presentAlertViewWithTwoButtons(alertTitle: nil, alertMessage: CFileTypeNotAllowedtoUpload, btnOneTitle: CBtnDelete, btnOneTapped: { [weak self] (_) in
 //                        guard let _ = self else {return}
 //                        GCDMainThread.async {
 //                            if let file = self?.arrMedia[cell.btnStatus.tag]{
 //                                self?.failedFiles.remove(object: file)
 //                            }
 //                            self?.arrMedia.remove(at: cell.btnStatus.tag)
 //                            self?.tblSharedFile.reloadData()
 //                        }
 //                        }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
 //                case .FailedWithRetry: /// If file is filed whule uploading
 //                    self?.presentAlertViewWithTwoButtons(alertTitle: nil, alertMessage: CThereIsSomeIssueInUploadingFile , btnOneTitle: CBtnRetry, btnOneTapped: { [weak self] (_) in
 //                        guard let _ = self else {return}
 //                        GCDMainThread.async {
 //                            self?.createFiles(file: self?.arrMedia[cell.btnStatus.tag])
 //                        }
 //                        }, btnTwoTitle: CBtnRemove, btnTwoTapped: { [weak self] (_) in
 //                            guard let _ = self else {return}
 //                            GCDMainThread.async {
 //                                if let file = self?.arrMedia[cell.btnStatus.tag]{
 //                                    self?.failedFiles.remove(object: file)
 //                                }
 //                                self?.arrMedia.remove(at: cell.btnStatus.tag)
 //                                self?.tblSharedFile.reloadData()
 //                            }
 //                    })
 //                case .FileExist: /// If file is filed to upload on server
 //                    /// and file type is not allowed to upload
 //                    self?.presentAlertViewWithOneButton(alertTitle: nil, alertMessage: CFileIsAlreadyExistsInThisFolder, btnOneTitle: CBtnDelete, btnOneTapped: { [weak self] (_) in
 //                        guard let _ = self else {return}
 //                        GCDMainThread.async {
 //                            if let file = self?.arrMedia[cell.btnStatus.tag]{
 //                                self?.failedFiles.remove(object: file)
 //                            }
 //                            self?.arrMedia.remove(at: cell.btnStatus.tag)
 //                            self?.tblSharedFile.reloadData()
 //                        }
 //                    })
 //                }
 //            }
 //            // Load more data....
 //            if (indexPath == tblSharedFile.lastIndexPath()) && !self.isLoadMoreCompleted && apiTask?.state != URLSessionTask.State.running {
 //                self.getFileListFromServer(isLoader: false)
 //            }
 //            return cell
 //        }}else {
 //            if let cell = tableView.dequeueReusableCell(withIdentifier: "TblSharedFileDetailsCollCell") as? TblSharedFileDetailsCollCell {
 //                cell.arrMediaFiles = arrMedia
 //                cell.layoutIfNeeded()
 //                return cell
 //            }
 //        }
 return UITableViewCell()
 }
 
 func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 
 if arrMedia.count <= indexPath.row{
 return
 }
 let media = arrMedia[indexPath.row]
 if let file = media.fileList{
 
 guard let url = URL(string: file.filePath) else{return}
 let fileType = AssetTypes.getType(ext: url.pathExtension)
 
 if fileType == .Video{
 
 /// Video will be play from server URL
 let player = AVPlayer(url: url)
 let playerViewController = AVPlayerViewController()
 playerViewController.player = player
 if #available(iOS 13.0, *){
 playerViewController.isModalInPresentation = true
 playerViewController.modalPresentationStyle = .fullScreen
 }
 self.present(playerViewController, animated: true) {
 playerViewController.player!.play()
 }
 return
 
 }else if fileType == .Image{
 guard let cell = tableView.cellForRow(at: indexPath) as? CreateFileTableCell else {
 return
 }
 let lightBoxHelper = LightBoxControllerHelper()
 lightBoxHelper.openSingleImage(image: cell.imgV.image, viewController: self)
 
 return
 }
 
 guard QLPreviewController.canPreview(url as QLPreviewItem) else{
 self.presentAlertViewWithOneButton(alertTitle: nil, alertMessage:CUnsupportedFileType, btnOneTitle: CBtnOk , btnOneTapped: nil)
 return
 }
 
 if let fileSharing = FileSharingProgressVC.getInstance(){
 
 fileSharing.downloadfile(controller: self, fileUrl: url, folderID: file.id, completion: { [weak self] (status, fileURL) in
 guard let self = self else { return }
 if status{
 if let _url = fileURL{
 self.previewFile(fileURL: _url)
 }
 }
 })
 }
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
 
 //MARK: - Action Events
 extension SharedFilesDetailsVC {
 
 @IBAction func btnAddFolderAction(_ sender: UIButton) {
 
 self.presentActionsheetWithTwoButtons(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CNavFiles, btnOneStyle: .default, btnOneTapped: { [weak self] (filesButton) in
 //print("Files")
 guard let self = self else { return }
 let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.audio", "public.video", "public.text", "com.apple.iwork.pages.pages", "public.data"], in: .import)
 
 documentPicker.delegate = self
 self.present(documentPicker, animated: true, completion: nil)
 
 }, btnTwoTitle: CBtnGallery, btnTwoStyle: .default) { [weak self] (cameraButton) in
 guard let self = self else { return }
 self.pickerButtonTap()
 }
 }
 }
 
 
 //MARK: - API Function
 extension SharedFilesDetailsVC {
 
 @objc func pullToRefresh() {
 
 if apiTask?.state == URLSessionTask.State.running {
 apiTask?.cancel()
 }
 
 if !self.arrMedia.isEmpty{
 self.failedFiles = self.arrMedia.filter({$0.uploadMediaStatus == .Failed || $0.uploadMediaStatus == .Failed})
 }
 self.arrMedia.removeAll()
 self.arrMedia += self.failedFiles
 self.isLoadMoreCompleted = false
 self.timestamp = 0
 self.refreshControl.beginRefreshing()
 self.getFileListFromServer(isLoader: false)
 }
 
 func getFileListFromServer(isLoader:Bool = true) {
 
 var para = [String : Any]()
 
 para["search"] = self.searchBarSharedFile.text
 para[CFolderID] = folder.id
 para[CTimestamp] = self.timestamp // == 0 ? "" : self.timestamp
 
 apiTask = APIRequest.shared().fileList(param: para, showLoader: isLoader, completion: { (response, error) in
 self.refreshControl.endRefreshing()
 self.apiTask?.cancel()
 if response != nil {
 GCDMainThread.async {
 let data = response![CData] as? [String : Any] ?? [:]
 let arrData = data[CFiles] as? [[String : Any]] ?? []
 self.isLoadMoreCompleted = (arrData.count == 0)
 for obj in arrData {
 let media = MDLAddMedia()
 media.isFromGallery = false
 media.uploadMediaStatus = .Succeed
 media.fileList = MDLFileList(fromDictionary: obj)
 media.assetType = AssetTypes.getTypeFromValue(value: media.fileList?.type ?? "")
 self.arrMedia.append(media)
 self.timestamp = media.fileList?.createdAt ?? 0
 }
 self.tblSharedFile.reloadData()
 }
 }
 })
 }
 
 fileprivate func createFiles(file:MDLAddMedia?) {
 
 let dispatchGroup = DispatchGroup()
 
 var uploadFiles : [MDLAddMedia] = []
 
 if file != nil{ /// For single file upload
 uploadFiles.append(file!)
 }else{ /// For multiple file upload
 uploadFiles = self.arrMedia.filter({$0.uploadMediaStatus == .Pendding})
 }
 if uploadFiles.isEmpty{
 return
 }
 
 GCDMainThread.async {
 MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
 }
 var statusFailed = false
 let concurrentQueue = DispatchQueue(label: "queue", attributes: .concurrent)
 let semaphore = DispatchSemaphore(value: 1)
 var index = 0
 for asset in uploadFiles {
 var para = [String : Any]()
 para[CFolderID] = folder.id
 para[CFileType] = asset.assetType.rawValue
 print(para)
 dispatchGroup.enter()
 concurrentQueue.async {
 semaphore.wait() /// wait until last file is not upload
 index += 1
 var strPlaceholder = ""
 if uploadFiles.count > 1{
 strPlaceholder = "(\(index) \(COutOf) \(uploadFiles.count))\n"
 }
 print("----------------------------------")
 print((BASEURL + CAPITagCreateFiles))
 print(para)
 print(CFile)
 
 APIRequest.shared().uploadFiles(apiName: CAPITagCreateFiles, param: para, key: CFile, assets: asset, progressBlock: { (progress) in
 
 var str = "\(CMessagePleaseWait)...\n"
 str += "\(strPlaceholder)"
 str += "\(CUploading) \(Int(progress))%"
 //MILoader.shared.setLblMessageText(message:str)
 //print("==> \(str)")
 GCDMainThread.async {
 MILoader.shared.setLblMessageText(message:str)
 MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: str)
 }
 
 
 }, completion: { [weak self] (response, error) in
 guard let _ = self else {
 statusFailed = true
 dispatchGroup.leave()
 semaphore.signal()
 return
 }
 
 if response != nil {
 print("File Response : \(response ?? "[:]" as AnyObject)")
 if let meta = response!.value(forKey: CJsonMeta) as? [String : Any]{
 if meta.valueForInt(key: CStatus) == 0{
 let data = response!.value(forKey: CData) as? [String : Any] ?? [:]
 asset.isFromGallery = false
 asset.fileList = MDLFileList(fromDictionary: data)
 asset.assetType = AssetTypes.getTypeFromValue(value: asset.fileList?.type ?? "")
 asset.uploadMediaStatus = .Succeed
 }else if meta.valueForInt(key: CStatus) == 1{
 asset.uploadMediaStatus = .FileExist
 //statusFailed = false
 if !(self?.failedFiles.contains(asset) ?? false){
 self?.failedFiles.insert(asset, at: 0)
 }
 }else{
 asset.uploadMediaStatus = .Failed
 statusFailed = true
 if !(self?.failedFiles.contains(asset) ?? false){
 self?.failedFiles.insert(asset, at: 0)
 }
 }
 }else{
 let data = response as? [String:Any]
 if data?.valueForInt(key: CStatus) == 400{
 asset.uploadMediaStatus = .Failed
 statusFailed = true
 if !(self?.failedFiles.contains(asset) ?? false){
 self?.failedFiles.insert(asset, at: 0)
 }
 }else{
 asset.uploadMediaStatus = .FailedWithRetry
 statusFailed = true
 if !(self?.failedFiles.contains(asset) ?? false){
 self?.failedFiles.insert(asset, at: 0)
 }
 }
 }
 }else{
 if !(self?.failedFiles.contains(asset) ?? false){
 self?.failedFiles.insert(asset, at: 0)
 }
 if (error?.code ?? 0) == 400 {
 asset.uploadMediaStatus = .Failed
 statusFailed = true
 }else{
 asset.uploadMediaStatus = .FailedWithRetry
 statusFailed = true
 }
 }
 semaphore.signal()
 dispatchGroup.leave()
 })
 }
 }
 
 dispatchGroup.notify(queue: .main) {
 /// DispatchGroup will be notify once all task has been completed
 DispatchQueue.main.async {
 MILoader.shared.hideLoader()
 if let controller = self.navigationController?.getViewControllerFromNavigation(FileSharingViewController.self){
 controller.fileVC?.myFilesSharedFilesFolders()
 }
 let arrSucceed = self.arrMedia.filter({$0.uploadMediaStatus == .Succeed})
 self.arrMedia = self.failedFiles
 self.arrMedia += arrSucceed
 self.tblSharedFile.reloadData()
 if statusFailed{
 var strMsg = CThereIsSomeIssueInUploadingFile
 if self.failedFiles.count > 1{
 strMsg = CThereIsSomeIssueInUploadingFiles
 }
 self.presentAlertViewWithOneButton(alertTitle: nil, alertMessage:strMsg, btnOneTitle: CBtnOk , btnOneTapped: nil)
 }
 }
 }
 }
 
 fileprivate func checkFileExistOnServer(){
 var arrFilesName : [String] = []
 for file in self.arrMedia{
 if file.uploadMediaStatus == .Pendding, let fileName = file.fileName{
 arrFilesName.append(fileName.lowercased())
 }
 }
 var para = [String : Any]()
 para[CFolderID] = self.folder.id
 para["file_name"] =  arrFilesName
 print(para)
 
 APIRequest.shared().checkFilesExists(param: para, showLoader: true) { (response, error) in
 if response != nil {
 if let arrData = response!.value(forKey: CData) as? [[String : Any]]{
 for data in arrData{
 guard data.valueForInt(key: "status") == 1 else{
 continue
 }
 let fname = data.valueForString(key: "file_name")
 guard let fileObj = self.arrMedia.filter({($0.fileName ?? "").lowercased() == fname.lowercased() && $0.uploadMediaStatus == .Pendding}).first else{
 continue
 }
 fileObj.uploadMediaStatus = .FileExist
 }
 DispatchQueue.main.async {
 self.tblSharedFile.reloadData()
 self.createFiles(file: nil)
 }
 }
 }
 }
 }
 
 fileprivate func apiDeleteFile(index:Int){
 if self.arrMedia.count <= index{
 return
 }
 let fileName = self.arrMedia[index].fileList?.fileName ?? ""
 var para = [String : Any]()
 para["file_id"] = self.arrMedia[index].fileList?.id
 para[CFolderID] = self.folder.id
 
 APIRequest.shared().deleteFile(param: para, showLoader: true) { (response, error) in
 if response != nil {
 GCDMainThread.async {
 
 if let controller = self.navigationController?.getViewControllerFromNavigation(FileSharingViewController.self){
 controller.fileVC?.getUserStorageSpace(isLoader: false)
 }
 self.deleteFileInLocalStorage(fileName: fileName)
 self.arrMedia.remove(at: index)
 self.tblSharedFile.reloadData()
 }
 }
 }
 }
 }
 
 //MARK: - UIDocument Picker Delegate
 extension SharedFilesDetailsVC: UIDocumentPickerDelegate {
 
 func fileSize(forURL url: URL) -> Double {
 let fileURL = url
 var fileSize: Double = 0.0
 var fileSizeValue = 0.0
 try? fileSizeValue = (fileURL.resourceValues(forKeys: [URLResourceKey.fileSizeKey]).allValues.first?.value as? Double ?? 0.0)
 if fileSizeValue > 0.0 {
 fileSize = (Double(fileSizeValue) / (UnitOfBytes))
 }
 return fileSize // KB
 }
 
 func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
 
 let fileUrl = url
 print("The Url is : \(fileUrl)")
 
 let arrRestricted = self.restrictedFile.filter({$0.fileName.lowercased() == fileUrl.pathExtension.lowercased()})
 /// Check file is exist in restricted file list
 if arrRestricted.count > 0{
 DispatchQueue.main.async {
 self.presentAlertViewWithOneButton(alertTitle: nil, alertMessage: CFileTypeNotAllowedtoUpload, btnOneTitle: CBtnOk , btnOneTapped: nil)
 }
 return
 }
 /// Check the storage space before uploading
 print("File Size : \(fileSize(forURL: fileUrl))")
 let size = self.fileSize(forURL: fileUrl)
 
 let sizeMB = size / UnitOfBytes
 let sizeGB = sizeMB / UnitOfBytes
 if sizeGB > 1 {
 DispatchQueue.main.async {
 self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMaximumFileSizeAllowedToUploadIs1GB, btnOneTitle: CBtnOk , btnOneTapped: nil)
 }
 return
 }
 self.selectedData += size
 if selectedData > totalSpace {
 print("Disk is Full....")
 self.selectedData -= size
 DispatchQueue.main.async {
 self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CStoregFullMessage, btnOneTitle: CBtnOk , btnOneTapped: nil)
 }
 return
 }
 
 /*if !Utility.isFileTypeAllowsToUpload(controller:self, extention: fileUrl.pathExtension){ return}*/
 
 let assetTypes = AssetTypes.getType(ext: fileUrl.pathExtension)
 let media = MDLAddMedia()
 media.url = fileUrl.absoluteString
 media.isDownloadedFromiCloud = false
 media.fileName = fileUrl.lastPathComponent
 media.assetType = assetTypes
 media.createdAt = Date.generateCurrentWith()
 media.isFromGallery = false
 if assetTypes == .Image{
 if let imageData = try? Data(contentsOf: fileUrl){
 media.image = UIImage(data: imageData)
 self.arrMedia.insert(media, at: 0)
 self.tblSharedFile.reloadData()
 }
 }else{
 self.arrMedia.insert(media, at: 0)
 self.tblSharedFile.reloadData()
 }
 checkFileExistOnServer()
 //self.createFiles(file: nil)
 }
 
 func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
 print(" cancelled by user")
 dismiss(animated: true, completion: nil)
 }
 }
 
 //MARK: - TLPhotosPickerViewController
 extension SharedFilesDetailsVC {
 
 func pickerButtonTap() {
 
 photosPickerViewController.delegate = self
 var configure = TLPhotosPickerConfigure()
 configure.usedCameraButton = false
 configure.numberOfColumn = 3
 configure.maxSelectedAssets = 10
 configure.recordingVideoQuality = .typeMedium
 photosPickerViewController.configure = configure
 photosPickerViewController.selectedAssets = self.arrMedia.filter({$0.isFromGallery}).compactMap({$0.asset})
 photosPickerViewController.logDelegate = self
 if #available(iOS 13.0, *){
 photosPickerViewController.isModalInPresentation = true
 photosPickerViewController.modalPresentationStyle = .fullScreen
 }
 self.present(photosPickerViewController, animated: true, completion: nil)
 }
 
 func converVideoByteToHumanReadable(_ bytes:Int64) -> String {
 let formatter:ByteCountFormatter = ByteCountFormatter()
 formatter.countStyle = .binary
 return formatter.string(fromByteCount: Int64(bytes))
 }
 func MIMEType(_ url: URL?) -> String? {
 guard let ext = url?.pathExtension else { return nil }
 if !ext.isEmpty {
 let UTIRef = UTTypeCreatePreferredIdentifierForTag("public.filename-extension" as CFString, ext as CFString, nil)
 let UTI = UTIRef?.takeUnretainedValue()
 UTIRef?.release()
 if let UTI = UTI {
 guard let MIMETypeRef = UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType) else { return nil }
 let MIMEType = MIMETypeRef.takeUnretainedValue()
 MIMETypeRef.release()
 return MIMEType as String
 }
 }
 return nil
 }
 
 func exportVideoFile(asset:TLPHAsset ,options: PHVideoRequestOptions? = nil, progressBlock:((Float) -> Void)? = nil, completionBlock:@escaping ((URL?,String) -> Void)) {
 guard let phAsset = asset.phAsset, phAsset.mediaType == .video else {
 completionBlock(nil,"")
 return
 }
 var type = PHAssetResourceType.video
 guard let resource = (PHAssetResource.assetResources(for: phAsset).filter{ $0.type == type }).first else {
 completionBlock(nil,"")
 return
 }
 let fileName = resource.originalFilename
 var writeURL: URL? = nil
 if #available(iOS 10.0, *) {
 writeURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(fileName)")
 } else {
 writeURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true).appendingPathComponent("\(fileName)")
 }
 guard let localURL = writeURL,let mimetype = MIMEType(writeURL) else {
 completionBlock(nil,"")
 return
 }
 var requestOptions = PHVideoRequestOptions()
 if let options = options {
 requestOptions = options
 }else {
 requestOptions.isNetworkAccessAllowed = true
 }
 PHImageManager.default().requestAVAsset(forVideo: phAsset, options: options) { (avasset, avaudioMix, infoDict) in
 guard let avasset = avasset else {
 print("PHImageManager.default().requestAVAsset Faild!!!")
 completionBlock(nil,"")
 return
 }
 let exportSession = AVAssetExportSession.init(asset: avasset, presetName: AVAssetExportPresetHighestQuality)
 exportSession?.outputURL = localURL
 exportSession?.outputFileType = AVFileType.mov
 exportSession?.exportAsynchronously(completionHandler: {
 completionBlock(localURL,mimetype)
 })
 func checkExportSession() {
 DispatchQueue.global().async { [weak exportSession] in
 guard let exportSession = exportSession else {
 print("checkExportSession Faild!!!")
 completionBlock(nil,"")
 return
 }
 switch exportSession.status {
 case .waiting,.exporting:
 DispatchQueue.main.async {
 progressBlock?(exportSession.progress)
 }
 Thread.sleep(forTimeInterval: 1)
 checkExportSession()
 default:
 break
 }
 }
 }
 checkExportSession()
 }
 }
 
 func exportVideo(placeholder:String,asset:TLPHAsset ,onComplete:((_ thembnil:UIImage?,_ videoURL:URL?)->Void)?) {
 var vThum : UIImage!
 var vUrl : URL!
 if let thum = asset.fullResolutionImage{
 print(thum)
 vThum = thum
 /*if let videoURL = vUrl, let videoThum = vThum{
 onComplete?(videoThum,videoURL)
 }*/
 }
 let options = PHVideoRequestOptions()
 options.isNetworkAccessAllowed = true
 options.deliveryMode = .automatic
 //iCloud download progress
 options.progressHandler = { (progress, error, stop, info) in
 var str = "\(CMessagePleaseWait)...\n"
 str += "\(placeholder)"
 str += "\(CDownloadFromiCloud) \(Int(progress * 100))%"
 //MILoader.shared.setLblMessageText(message:str)
 GCDMainThread.async {
 MILoader.shared.setLblMessageText(message:str)
 MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: str)
 }
 print("Downloading from iCloud \(progress)")
 if (error != nil) {
 print(error?.localizedDescription ?? "")
 }
 }
 
 self.exportVideoFile(asset: asset, options:options, progressBlock: { (progress) in
 
 print(progress)
 var str = "\(CMessagePleaseWait)...\n"
 str += "\(placeholder)"
 str += "\(CExportingFile) \(Int(progress * 100))%"
 //MILoader.shared.setLblMessageText(message:str)
 GCDMainThread.async {
 MILoader.shared.setLblMessageText(message:str)
 MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: str)
 }
 
 }) { (url, mimeType) in
 print("exportVideoFile : \(url?.absoluteString ?? "URL not found")")
 vUrl = url
 if let videoURL = vUrl, let videoThum = vThum {
 onComplete?(videoThum,videoURL)
 }else{
 onComplete?(nil,nil)
 }
 }
 }
 
 func getSelectedImage(asset:TLPHAsset, onComplete:((_ thembnil:UIImage)->Void)?) {
 
 if let image = asset.fullResolutionImage {
 print(image)
 onComplete?(image)
 }else {
 print("Can't get image at local storage, try download image")
 asset.cloudImageDownload(progressBlock: { [weak self] (progress) in
 guard let _ = self else {return}
 DispatchQueue.main.async {
 print(progress)
 }
 }, completionBlock: { [weak self] (image) in
 guard let _ = self else {return}
 if let _image = image {
 //use image
 DispatchQueue.main.async {
 print(_image)
 print("complete download")
 onComplete?(_image)
 }
 }
 })
 }
 }
 }
 
 //MARK: - TLPhotosPickerViewControllerDelegate ,TLPhotosPickerLogDelegate
 extension SharedFilesDetailsVC : TLPhotosPickerViewControllerDelegate,TLPhotosPickerLogDelegate {
 
 func shouldDismissPhotoPicker(withTLPHAssets: [TLPHAsset]) -> Bool {
 
 if withTLPHAssets.isEmpty{
 return false
 }
 
 MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
 
 self.arrMedia = self.arrMedia.filter({!$0.isFromGallery})
 
 let concurrentQueue = DispatchQueue(label: "queue", attributes: .concurrent)
 let semaphore = DispatchSemaphore(value: 1)
 var index = 0
 for asset in withTLPHAssets{
 
 let resources = PHAssetResource.assetResources(for: asset.phAsset!)
 var sizeOnDisk: Double = 0.0
 if let resource = resources.first {
 sizeOnDisk = resource.value(forKey: "fileSize") as? Double ?? 0.0
 print("sizeOnDisk : \(sizeOnDisk)")
 /// Check the storage space before uploading
 self.selectedData += (sizeOnDisk / UnitOfBytes )
 if self.selectedData > self.totalSpace{
 print("Disk is Full....")
 self.selectedData -= (sizeOnDisk / UnitOfBytes )
 DispatchQueue.main.async {
 self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CStoregFullMessage, btnOneTitle: CBtnOk , btnOneTapped: nil)
 }
 continue;
 }
 }
 self.dispatchGroup.enter()
 
 concurrentQueue.async {
 semaphore.wait()
 index += 1
 switch asset.type{
 case .video:
 var strPlaceholder = ""
 if withTLPHAssets.count > 1{
 strPlaceholder = "(\(index) \(COutOf) \(withTLPHAssets.count))\n"
 }
 self.exportVideo(placeholder: strPlaceholder, asset: asset) { [weak self] (thum,url)in
 guard let _ = thum, let _ = url else{
 self?.dispatchGroup.leave()
 semaphore.signal()
 return
 }
 guard let _ = self else {
 self?.dispatchGroup.leave()
 semaphore.signal()
 return
 }
 let media = MDLAddMedia()
 media.image = thum
 media.url = url!.absoluteString
 media.isDownloadedFromiCloud = true
 media.fileName = asset.originalFileName
 media.assetType = .Video
 media.createdAt = Date.generateCurrentWith()
 self?.arrMedia.insert(media, at: 0)
 GCDMainThread.async {
 self?.tblSharedFile.reloadData()
 self?.dispatchGroup.leave()
 semaphore.signal()
 }
 }
 break
 case .livePhoto:
 
 self.getSelectedImage(asset: asset) { [weak self] (image) in
 guard let _ = self else {
 self?.dispatchGroup.leave()
 semaphore.signal()
 return
 }
 let media = MDLAddMedia()
 media.image = image
 media.fileName = asset.originalFileName
 media.isDownloadedFromiCloud = true
 media.assetType = .Image
 media.createdAt = Date.generateCurrentWith()
 self?.arrMedia.insert(media, at: 0)
 GCDMainThread.async {
 self?.tblSharedFile.reloadData()
 self?.dispatchGroup.leave()
 semaphore.signal()
 }
 }
 break
 case .photo :
 
 self.getSelectedImage(asset: asset) { [weak self] (image) in
 guard let _ = self else {
 self?.dispatchGroup.leave()
 semaphore.signal()
 return
 }
 let media = MDLAddMedia()
 media.image = image
 media.fileName = asset.originalFileName
 media.isDownloadedFromiCloud = true
 media.assetType = .Image
 media.createdAt = Date.generateCurrentWith()
 self?.arrMedia.insert(media, at: 0)
 GCDMainThread.async {
 self?.tblSharedFile.reloadData()
 self?.dispatchGroup.leave()
 semaphore.signal()
 }
 }
 break
 }
 }
 }
 
 dispatchGroup.notify(queue: .main) {
 print("all activities complete 👍")
 MILoader.shared.hideLoader()
 self.tblSharedFile.reloadData()
 //self.createFiles(file: nil)
 self.checkFileExistOnServer()
 }
 return true
 }
 
 func dismissPhotoPicker(withPHAssets: [PHAsset]) {
 }
 
 func handleNoAlbumPermissions(picker: TLPhotosPickerViewController) {
 picker.dismiss(animated: true) {
 let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!
 let alert = UIAlertController(
 title: nil,
 message: CDeniedAlbumsPermission,
 preferredStyle: .alert
 )
 alert.addAction(UIAlertAction(title: CBtnCancel, style: .destructive, handler: nil))
 alert.addAction(UIAlertAction(title: CNavSettings, style: .default, handler: { (alert) -> Void in
 UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
 }))
 self.present(alert, animated: true, completion: nil)
 }
 }
 
 //For Log User Interaction
 func selectedCameraCell(picker: TLPhotosPickerViewController) {
 print("selectedCameraCell")
 }
 
 func selectedPhoto(picker: TLPhotosPickerViewController, at: Int) {
 print("selectedPhoto")
 }
 
 func deselectedPhoto(picker: TLPhotosPickerViewController, at: Int) {
 print("deselectedPhoto")
 }
 
 func selectedAlbum(picker: TLPhotosPickerViewController, title: String, at: Int) {
 print("selectedAlbum")
 }
 
 func canSelectAsset(phAsset: PHAsset) -> Bool {
 
 if phAsset.mediaType == .video{
 
 let resources = PHAssetResource.assetResources(for: phAsset)
 var sizeOnDisk: Int64? = 0
 if let resource = resources.first {
 let unsignedInt64 = resource.value(forKey: "fileSize") as? CLong
 sizeOnDisk = Int64(bitPattern: UInt64(unsignedInt64!))
 }
 
 let onDisk = sizeOnDisk ?? 0
 let sizeMB : Double = Double(onDisk) / 1000000.0
 if sizeMB > UnitOfBytes {
 DispatchQueue.main.async {
 self.photosPickerViewController.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMaximumFileSizeAllowedToUploadIs1GB, btnOneTitle: CBtnOk , btnOneTapped: nil)
 }
 return false
 }
 print(onDisk)
 }
 
 let resources = PHAssetResource.assetResources(for: phAsset)
 if let resource = resources.first{
 let strExtension = resource.originalFilename.components(separatedBy: ".").last ?? ""
 let arrRestricted = self.restrictedFile.filter({$0.fileName.lowercased() == strExtension.lowercased()})
 /// Check file is exist in restricted file list
 if arrRestricted.count > 0{
 DispatchQueue.main.async {
 self.photosPickerViewController.presentAlertViewWithOneButton(alertTitle: nil, alertMessage: CFileTypeNotAllowedtoUpload, btnOneTitle: CBtnOk , btnOneTapped: nil)
 }
 return false
 }
 }
 return true
 }
 }
 
 //MARK: - QLPreviewControllerDataSource && Utility Methods
 extension SharedFilesDetailsVC : QLPreviewControllerDataSource,QLPreviewControllerDelegate {
 
 func previewFile(fileURL:URL){
 
 self.previewItem = fileURL as NSURL
 let previewController = QLPreviewController()
 previewController.dataSource = self
 previewController.delegate = self
 if #available(iOS 13.0, *){
 previewController.isModalInPresentation = true
 previewController.modalPresentationStyle = .fullScreen
 }
 self.present(previewController, animated: true, completion: nil)
 }
 
 func downloadfile(fileUrl:URL,completion: @escaping (_ success: Bool,_ fileLocation: URL?) -> Void){
 
 // then lets create your document folder url
 //var documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
 let documentsDirectoryURL = NSURL.fileURL(withPath: NSTemporaryDirectory(), isDirectory: true)
 // Make a directory if Folder ID
 //documentsDirectoryURL = documentsDirectoryURL.appendingPathComponent("\(self.folder.id ?? 0)")
 do
 {
 try FileManager.default.createDirectory(at: documentsDirectoryURL, withIntermediateDirectories: true, attributes: nil)
 }
 catch let error as NSError
 {
 NSLog("Unable to create directory \(error.debugDescription)")
 }
 
 // lets create your destination file url
 let destinationUrl = documentsDirectoryURL.appendingPathComponent(fileUrl.lastPathComponent)
 print("File URL : \(destinationUrl.absoluteString)")
 // to check if it exists before downloading it
 if FileManager.default.fileExists(atPath: destinationUrl.path) {
 debugPrint("The file already exists at path")
 completion(true, destinationUrl)
 
 // if the file doesn't exist
 } else {
 
 // you can use NSURLSession.sharedSession to download the data asynchronously
 URLSession.shared.downloadTask(with: fileUrl, completionHandler: { (location, response, error) -> Void in
 guard let tempLocation = location, error == nil else { return }
 do {
 // after downloading your file you need to move it to your destination url
 try FileManager.default.moveItem(at: tempLocation, to: destinationUrl)
 print("File moved to documents folder")
 completion(true, destinationUrl)
 } catch let error as NSError {
 print(error.localizedDescription)
 completion(false, nil)
 }
 }).resume()
 }
 }
 
 func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
 return 1
 }
 
 func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
 return self.previewItem as QLPreviewItem
 }
 
 func previewControllerDidDismiss(_ controller: QLPreviewController) {
 try? FileManager.default.removeItem(at: (previewItem as URL))
 }
 }*/





import UIKit
import QuickLook
import TLPhotoPicker
import Photos
import AVKit
import AVFoundation
import MobileCoreServices
import Lightbox

class SharedFilesDetailsVC: ParentViewController {
    
    /// UISearchBar for search files in list
    @IBOutlet weak var searchBarSharedFile: UISearchBar! {
        didSet {
            searchBarSharedFile.placeholder = CSearch
            searchBarSharedFile.tintColor = .black
            
            searchBarSharedFile.change(textFont: CFontPoppins(size: (12 * CScreenWidth)/375, type: .regular))
            searchBarSharedFile.delegate = self
            
            searchBarSharedFile.backgroundImage = UIImage()
            let searchTextField = searchBarSharedFile.value(forKey: "searchField") as? UITextField
            searchTextField?.textColor = UIColor.black
            searchBarSharedFile.layer.cornerRadius = 0.0
            searchBarSharedFile.layer.masksToBounds = true
            
            if let searchFieldBackground = searchTextField?.subviews.first{
                searchFieldBackground.backgroundColor = UIColor.white
                searchFieldBackground.layer.cornerRadius = 20
                searchFieldBackground.clipsToBounds = true
            }
        }
    }
    
    @IBOutlet weak var colSharedFile: UICollectionView! {
        didSet {
            
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            //            self.colSharedFile.
            //            self.colSharedFile.tableFooterView = UIView(frame: .zero)
            self.colSharedFile.allowsSelection = true
            self.colSharedFile.register(UINib(nibName: "CreateFileColls", bundle: nil), forCellWithReuseIdentifier: "CreateFileColls")
            
            self.colSharedFile.register(UINib(nibName: "ClListviewCell", bundle: nil), forCellWithReuseIdentifier: "ClListviewCell")
            
            
            self.colSharedFile.delegate = self
            self.colSharedFile.dataSource = self
            self.refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
            self.refreshControl.tintColor = ColorAppTheme
            self.colSharedFile!.addSubview(self.refreshControl)
            //            self.colSharedFile.pullToRefreshControl = self.refreshControl
        }
    }
    
    /// btnAddFiles for add/upload new file
    @IBOutlet weak var btnAddFiles: UIButton!
    
    @IBOutlet weak var btnShowgridView: UIButton!
    
    /// Arrary of added item in list
    var arrMedia : [MDLAddMedia] = []
    var failedFiles : [MDLAddMedia] = []
    var isFromSharedFiles: Bool = false
    var isGridviewSelect:Bool = false
    
    /// `dispatchGroup` Used for get assets item from gallery
    let dispatchGroup = DispatchGroup()
    
    /// refreshControl for pull to referesh
    var refreshControl = UIRefreshControl()
    
    /// `previewItem` containt a URL of previewing file from list
    lazy var previewItem = NSURL()
    
    /// `folder` it's containt folder id and name
    var folder : MDLCreateFolder!
    
    /// `storage` used for check remanning storage space while uploading files
    var storage : MDLStorage?
    var totalSpace = 0.0
    var selectedData = 0.0
    
    /// `timestamp` containt timestamp of last record. it's used for load more..
    var timestamp : Int = 0
    
    /// Check all the data are loaded from server
    var isLoadMoreCompleted = false
    
    var apiTask : URLSessionTask?
    
    /// It's list of extension. It will be used while uploading file on server to check
    /// file is restricted or not
    var restrictedFile : [MDLRestractedFile] = []
    
    /// Select photos and video from Gallery
    let photosPickerViewController = TLPhotosPickerViewController()
    
    // MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialization()
        self.createBackButton()
        self.getFileListFromServer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if !self.isFromSharedFiles {
            createNavigationRightButton()
        }
    }
    
    //Show cloumss and main view contoller
    @IBAction func showGridview(_ sender: UIButton) {
        
        if btnShowgridView.isSelected == true {
            isGridviewSelect = false
            btnShowgridView.isSelected = false
            DispatchQueue.main.async {
                self.colSharedFile.reloadData()
            }
            
            
        }else {
            isGridviewSelect = true
            btnShowgridView.isSelected = true
//            colSharedFile.reloadData()
            DispatchQueue.main.async {
                self.colSharedFile.reloadData()
            }
            
        }
    }
    /// Add the Share button from right side of the navigatin bar
    /// It's used to share file with your friends.
    /// - Returns: Share button If restricted file exist from server
    func addInfoBarButton() -> UIBarButtonItem?{
        
        if let controller = self.navigationController?.getViewControllerFromNavigation(FileSharingViewController.self){
            
            self.restrictedFile = controller.arrRestrictedFileType
            if self.restrictedFile.isEmpty{
                return nil
            }
            
            return BlockBarButtonItem(image: UIImage(named: "ic_info_tint"), style: .plain) { [weak self] (_) in
                guard let _ = self else {return}
                
                if let restrictionVC = CStoryboardFile.instantiateViewController(withIdentifier: "RestrictedFilesVC") as? RestrictedFilesVC{
                    restrictionVC.arrDatasource = self?.restrictedFile ?? []
                    self?.navigationController?.pushViewController(restrictionVC, animated: true)
                }
            }
        }
        return nil
    }
    
    // Delete Folder....
    func deleteFile(_ index: Int) {
        
        self.presentAlertViewWithTwoButtons(alertTitle: nil, alertMessage: CMessageDeleteFile , btnOneTitle: CBtnYes, btnOneTapped: { [weak self] (_) in
            guard let _ = self else {return}
            self?.arrMedia.remove(at: index)
            GCDMainThread.async {
                self?.colSharedFile.reloadData()
            }
            
        }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
    }
    
    /// Delete file from document directory.
    // `folderID` is name of folder.
    ///
    /// - Parameter folderID: Name of folder
    fileprivate func deleteFileInLocalStorage(fileName:String){
        //var documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        var documentsDirectoryURL = NSURL.fileURL(withPath: NSTemporaryDirectory(), isDirectory: true)
        //documentsDirectoryURL = documentsDirectoryURL.appendingPathComponent("\(self.folder.id ?? 0)")
        documentsDirectoryURL = documentsDirectoryURL.appendingPathComponent(fileName)
        print("FileManager.default.removeItem : \(documentsDirectoryURL.absoluteString)")
        
        do{
            try? FileManager.default.removeItem(at:documentsDirectoryURL)
        }
    }
    
    func getDownloadedFileURL(url:URL, completion:@escaping (URL?)->Void){
        
        self.downloadfile(fileUrl: url, completion: {(success, fileLocationURL) in
            DispatchQueue.main.async {
                //MILoader.shared.hideLoader()
                if success {
                    // Set the preview item to display======
                    //self.previewItem = fileLocationURL! as NSURL
                    //self.previewFile(fileURL: fileLocationURL!)
                    completion(fileLocationURL)
                }else{
                    completion(nil)
                    debugPrint("File can't be downloaded")
                }
            }
        })
    }
    
    deinit {
        print("Deinit -> SharedFilesDetailsVC")
    }
}
//MARK: - Initialization
extension SharedFilesDetailsVC {
    
    fileprivate func initialization() {
        
        self.title = folder.folderName
        self.totalSpace = (self.storage?.totalSpace ?? 0) * UnitOfBytes
        self.selectedData = (self.storage?.uploaded ?? 0) * UnitOfBytes
        
        if  self.isFromSharedFiles {
            self.btnAddFiles.isHidden = true
        }
        
        registerForKeyboardWillShowNotification(colSharedFile)
        registerForKeyboardWillHideNotification(colSharedFile)
    }
    
    /// Add back button in navigation bar
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
            if self?.arrMedia.filter({$0.uploadMediaStatus == .Failed || $0.uploadMediaStatus == .Failed}).count ?? 0 > 0{
                
                self?.presentAlertViewWithTwoButtons(alertTitle: nil, alertMessage: CAlertMessageForFilesNotUploaded, btnOneTitle: CBtnNo, btnOneTapped: nil, btnTwoTitle: CBtnYes, btnTwoTapped: { (_) in
                    self?.navigationController?.popViewController(animated: true)
                })
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
        let infoBarButton = self.addInfoBarButton()
        
        if infoBarButton != nil{
            self.navigationController?.navigationBar.topItem?.rightBarButtonItems = [UIBarButtonItem(customView: button),infoBarButton!]
        }else{
            self.navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(customView: button)
        }
        
        button.touchUpInside { [weak self](_) in
            guard let _ = self else {return}
            if let shareListVC = CStoryboardFile.instantiateViewController(withIdentifier: "SharedListVC") as? SharedListVC {
                shareListVC.folder = self?.folder
                self?.navigationController?.pushViewController(shareListVC, animated: true)
            }
        }
    }
}

//MARK: - UISearchBarDelegate
extension SharedFilesDetailsVC: UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.resignKeyboard()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if apiTask?.state == URLSessionTask.State.running {
            apiTask?.cancel()
        }
        self.timestamp = 0
        self.arrMedia.removeAll()
        if searchText.isBlank{
            self.arrMedia += self.failedFiles
        }
        self.getFileListFromServer(isLoader: false)
    }
}

//MARK: - UITableView Delegate & Data Source
extension SharedFilesDetailsVC:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if  self.isGridviewSelect == false  {
            if section == 0{
                if arrMedia.count == 0 {
                    return 0
                }
                return arrMedia.count
            }
        } else {
            if section == 1{
                return self.arrMedia.count
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if arrMedia.count <= indexPath.row{
            return UICollectionViewCell(frame: .zero)
        }
        if isGridviewSelect == false{
            if indexPath.section == 0{
                if let cell =
                    colSharedFile.dequeueReusableCell(withReuseIdentifier: "CreateFileColls", for: indexPath) as? CreateFileColls {
                    let media = arrMedia[indexPath.row]
                    cell.vwShareFile.isHidden = false
                    cell.imgV.isHidden = true
                    cell.lblFileDate.isHidden = false
                    if let file = media.fileList{
                        /// Here is the configure cell for list of files are from server.
                        cell.lblFileName.text = file.fileName
                        cell.lblFileDate.text = file.createdDate
                        /// Here is the configure cell for list of files are from server.
                        if media.assetType == .Image{
                            cell.imgV.loadImageFromUrl(file.filePath, false)
                            cell.imgV.isHidden = false
                        }
                        if media.assetType == .Pdf{
                            cell.imgV.image = UIImage(named: "ic_pdf")
                            cell.imgV.isHidden = false
                        }
                        if media.assetType == .Pdf{
                            cell.imgV.image = UIImage(named: "ic_pdf")
                            cell.imgV.isHidden = false
                        }
                        if media.assetType == .Audio{
                            cell.imgV.image = UIImage(named: "ic_mp3")
                            cell.imgV.isHidden = false
                        }
                        if media.assetType == .Video{
                            cell.imgV.image = UIImage(named: "ic_mp4")
                            cell.imgV.isHidden = false
                        }
                        if media.assetType == .Text{
                            cell.imgV.image = UIImage(named: "ic_doc")
                            cell.imgV.isHidden = false
                        }
                        
                    }else{
                        /// If user has added files from Gallery or File controller
                        /// then it will be configure here.
                        cell.lblFileName.text = media.fileName ?? ""
                        cell.lblFileDate.text = media.createdAt
                        
                        if media.assetType == .Image{
                            cell.imgV.image = media.image
                            cell.imgV.isHidden = false
                        }
                        if media.assetType == .Pdf{
                            cell.imgV.image = UIImage(named: "ic_pdf")
                            cell.imgV.isHidden = false
                        }
                        if media.assetType == .Audio{
                            cell.imgV.image = UIImage(named: "ic_mp3")
                            cell.imgV.isHidden = false
                        }
                        if media.assetType == .Video{
                            cell.imgV.image = UIImage(named: "ic_mp4")
                            cell.imgV.isHidden = false
                        }
                        if media.assetType == .Text{
                            cell.imgV.image = UIImage(named: "ic_doc")
                            cell.imgV.isHidden = false
                        }
                        
                    }
                    
                    
                    cell.updateStatus(status: media.uploadMediaStatus)
                    cell.btnShareFile.tag = indexPath.row
                    /// on Share File button
                    cell.btnShareFile.touchUpInside {[weak self] (sender) in
                        guard let self = self else { return }
                        let model = self.arrMedia[sender.tag]
                        if let file = model.fileList{
                            
                            guard let url = URL(string: file.filePath) else{return}
                            
                            if let fileSharing = FileSharingProgressVC.getInstance(){
                                //fileSharing.presentController(controller:self)
                                
                                fileSharing.downloadfile(controller: self, fileUrl: url, folderID: file.id, completion: { (status, url) in
                                    if status{
                                        let objectsToShare = [url]
                                        let activityVC = UIActivityViewController(activityItems: objectsToShare as [Any], applicationActivities: nil)
                                        
                                        //New Excluded Activities Code
                                        //activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop]
                                        
                                        activityVC.popoverPresentationController?.sourceView = sender
                                        if #available(iOS 13.0, *){
                                            activityVC.isModalInPresentation = true
                                            activityVC.modalPresentationStyle = .fullScreen
                                        }
                                        self.present(activityVC, animated: true, completion: nil)
                                        activityVC.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
                                            print("activityVC.completionWithItemsHandler")
                                            if let _url = url {
                                                try! FileManager.default.removeItem(at: _url)
                                            }
                                            if completed == true {
                                            }
                                        }
                                    }
                                })
                                return
                            }
                        }
                    }
                    cell.btnStatus.tag = indexPath.row
                    cell.btnStatus.isHidden = self.isFromSharedFiles
                    /// on close or Info button
                    cell.btnStatus.touchUpInside {[weak self] (_) in
                        guard let _ = self else{return}
                        switch media.uploadMediaStatus{
                        case .Pendding:
                            self?.deleteFile(cell.btnStatus.tag)
                        case .Succeed: /// If file is available on server
                            self?.presentAlertViewWithTwoButtons(alertTitle: nil, alertMessage: CMessageDeleteFile , btnOneTitle: CBtnYes, btnOneTapped: { [weak self] (_) in
                                guard let _ = self else {return}
                                GCDMainThread.async {
                                    self?.apiDeleteFile(index: cell.btnStatus.tag)
                                }
                            }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
                        case .Failed: /// If file is filed to upload on server
                            /// and file type is not allowed to upload
                            self?.presentAlertViewWithTwoButtons(alertTitle: nil, alertMessage: CFileTypeNotAllowedtoUpload, btnOneTitle: CBtnDelete, btnOneTapped: { [weak self] (_) in
                                guard let _ = self else {return}
                                GCDMainThread.async {
                                    if let file = self?.arrMedia[cell.btnStatus.tag]{
                                        self?.failedFiles.remove(object: file)
                                    }
                                    self?.arrMedia.remove(at: cell.btnStatus.tag)
                                    DispatchQueue.main.async {
                                        self.self?.colSharedFile.reloadData()
                                    }
//                                    self?.colSharedFile.reloadData()
                                }
                            }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
                        case .FailedWithRetry: /// If file is filed whule uploading
                            self?.presentAlertViewWithTwoButtons(alertTitle: nil, alertMessage: CThereIsSomeIssueInUploadingFile , btnOneTitle: CBtnRetry, btnOneTapped: { [weak self] (_) in
                                guard let _ = self else {return}
                                GCDMainThread.async {
                                    self?.createFiles(file: self?.arrMedia[cell.btnStatus.tag])
                                }
                            }, btnTwoTitle: CBtnRemove, btnTwoTapped: { [weak self] (_) in
                                guard let _ = self else {return}
                                GCDMainThread.async {
                                    if let file = self?.arrMedia[cell.btnStatus.tag]{
                                        self?.failedFiles.remove(object: file)
                                    }
                                    self?.arrMedia.remove(at: cell.btnStatus.tag)
                                    DispatchQueue.main.async {
                                        self?.colSharedFile.reloadData()
                                    }
//                                    self?.colSharedFile.reloadData()
                                }
                            })
                        case .FileExist: /// If file is filed to upload on server
                            /// and file type is not allowed to upload
                            self?.presentAlertViewWithOneButton(alertTitle: nil, alertMessage: CFileIsAlreadyExistsInThisFolder, btnOneTitle: CBtnDelete, btnOneTapped: { [weak self] (_) in
                                guard let _ = self else {return}
                                GCDMainThread.async {
                                    if let file = self?.arrMedia[cell.btnStatus.tag]{
                                        self?.failedFiles.remove(object: file)
                                    }
                                    self?.arrMedia.remove(at: cell.btnStatus.tag)
                                    DispatchQueue.main.async {
                                        self?.colSharedFile.reloadData()
                                    }
//                                    self?.colSharedFile.reloadData()
                                }
                            })
                        }
                    }
                    // Load more data....
                    
                    //                            if (indexPath == colSharedFile.lastIndexPath()) && !self.isLoadMoreCompleted && apiTask?.state != URLSessionTask.State.running {
                    //                                self.getFileListFromServer(isLoader: false)
                    //                            }
                    //
                    return cell
                }
                
            }
            
        }else {
            
            if let cell = colSharedFile.dequeueReusableCell(withReuseIdentifier: "ClListviewCell", for: indexPath) as? ClListviewCell {
                
                let media = arrMedia[indexPath.row]
                cell.vwShareFile.isHidden = false
                cell.imgV.isHidden = true
                cell.lblFileDate.isHidden = false
                
                
                /*****************OLD CODE **************/
//                if let file = media.fileList{
//                    /// Here is the configure cell for list of files are from server.
//                    cell.lblFileName.text = file.fileName
//                    cell.lblFileDate.text = file.createdDate
//
//                    if media.assetType == .Image{
//                        cell.imgV.loadImageFromUrl(file.filePath, false)
//                        cell.imgV.isHidden = false
//                    }
//
//                }else{
//                    /// If user has added files from Gallery or File controller
//                    /// then it will be configure here.
//                    cell.lblFileName.text = media.fileName ?? ""
//                    cell.lblFileDate.text = media.createdAt
//
//                    if media.assetType == .Image{
//                        cell.imgV.image = media.image
//                        cell.imgV.isHidden = false
//                    }
                
                /*****************NEW CODE **************/
                if let file = media.fileList{
                    /// Here is the configure cell for list of files are from server.
                    cell.lblFileName.text = file.fileName
                    cell.lblFileDate.text = file.createdDate
                    /// Here is the configure cell for list of files are from server.
                    if media.assetType == .Image{
                        cell.imgV.loadImageFromUrl(file.filePath, false)
                        cell.imgV.isHidden = false
                    }
                    if media.assetType == .Pdf{
                        cell.imgV.image = UIImage(named: "ic_pdf")
                        cell.imgV.isHidden = false
                    }
                    if media.assetType == .Pdf{
                        cell.imgV.image = UIImage(named: "ic_pdf")
                        cell.imgV.isHidden = false
                    }
                    if media.assetType == .Audio{
                        cell.imgV.image = UIImage(named: "ic_mp3")
                        cell.imgV.isHidden = false
                    }
                    if media.assetType == .Video{
                        cell.imgV.image = UIImage(named: "ic_mp4")
                        cell.imgV.isHidden = false
                    }
                    if media.assetType == .Text{
                        cell.imgV.image = UIImage(named: "ic_doc")
                        cell.imgV.isHidden = false
                    }
                    
                }else{
                    /// If user has added files from Gallery or File controller
                    /// then it will be configure here.
                    cell.lblFileName.text = media.fileName ?? ""
                    cell.lblFileDate.text = media.createdAt
                    
                    if media.assetType == .Image{
                        cell.imgV.image = media.image
                        cell.imgV.isHidden = false
                    }
                    if media.assetType == .Pdf{
                        cell.imgV.image = UIImage(named: "ic_pdf")
                        cell.imgV.isHidden = false
                    }
                    if media.assetType == .Audio{
                        cell.imgV.image = UIImage(named: "ic_mp3")
                        cell.imgV.isHidden = false
                    }
                    if media.assetType == .Video{
                        cell.imgV.image = UIImage(named: "ic_mp4")
                        cell.imgV.isHidden = false
                    }
                    if media.assetType == .Text{
                        cell.imgV.image = UIImage(named: "ic_doc")
                        cell.imgV.isHidden = false
                    }
                  
                }
                
                
                cell.updateStatus(status: media.uploadMediaStatus)
                cell.btnShareFile.tag = indexPath.row
                /// on Share File button
                cell.btnShareFile.touchUpInside {[weak self] (sender) in
                    guard let self = self else { return }
                    let model = self.arrMedia[sender.tag]
                    if let file = model.fileList{
                        
                        guard let url = URL(string: file.filePath) else{return}
                        
                        if let fileSharing = FileSharingProgressVC.getInstance(){
                            //fileSharing.presentController(controller:self)
                            
                            fileSharing.downloadfile(controller: self, fileUrl: url, folderID: file.id, completion: { (status, url) in
                                if status{
                                    let objectsToShare = [url]
                                    let activityVC = UIActivityViewController(activityItems: objectsToShare as [Any], applicationActivities: nil)
                                    
                                    //New Excluded Activities Code
                                    //activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop]
                                    
                                    activityVC.popoverPresentationController?.sourceView = sender
                                    if #available(iOS 13.0, *){
                                        activityVC.isModalInPresentation = true
                                        activityVC.modalPresentationStyle = .fullScreen
                                    }
                                    self.present(activityVC, animated: true, completion: nil)
                                    activityVC.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
                                        print("activityVC.completionWithItemsHandler")
                                        if let _url = url {
                                            try! FileManager.default.removeItem(at: _url)
                                        }
                                        if completed == true {
                                        }
                                    }
                                }
                            })
                            return
                        }
                    }
                }
                cell.btnStatus.tag = indexPath.row
                cell.btnStatus.isHidden = self.isFromSharedFiles
                /// on close or Info button
                cell.btnStatus.touchUpInside {[weak self] (_) in
                    guard let _ = self else{return}
                    switch media.uploadMediaStatus{
                    case .Pendding:
                        self?.deleteFile(cell.btnStatus.tag)
                    case .Succeed: /// If file is available on server
                        self?.presentAlertViewWithTwoButtons(alertTitle: nil, alertMessage: CMessageDeleteFile , btnOneTitle: CBtnYes, btnOneTapped: { [weak self] (_) in
                            guard let _ = self else {return}
                            GCDMainThread.async {
                                self?.apiDeleteFile(index: cell.btnStatus.tag)
                            }
                        }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
                    case .Failed: /// If file is filed to upload on server
                        /// and file type is not allowed to upload
                        self?.presentAlertViewWithTwoButtons(alertTitle: nil, alertMessage: CFileTypeNotAllowedtoUpload, btnOneTitle: CBtnDelete, btnOneTapped: { [weak self] (_) in
                            guard let _ = self else {return}
                            GCDMainThread.async {
                                if let file = self?.arrMedia[cell.btnStatus.tag]{
                                    self?.failedFiles.remove(object: file)
                                }
                                self?.arrMedia.remove(at: cell.btnStatus.tag)
                                DispatchQueue.main.async {
                                    self?.colSharedFile.reloadData()
                                }
//                                self?.colSharedFile.reloadData()
                            }
                        }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
                    case .FailedWithRetry: /// If file is filed whule uploading
                        self?.presentAlertViewWithTwoButtons(alertTitle: nil, alertMessage: CThereIsSomeIssueInUploadingFile , btnOneTitle: CBtnRetry, btnOneTapped: { [weak self] (_) in
                            guard let _ = self else {return}
                            GCDMainThread.async {
                                self?.createFiles(file: self?.arrMedia[cell.btnStatus.tag])
                            }
                        }, btnTwoTitle: CBtnRemove, btnTwoTapped: { [weak self] (_) in
                            guard let _ = self else {return}
                            GCDMainThread.async {
                                if let file = self?.arrMedia[cell.btnStatus.tag]{
                                    self?.failedFiles.remove(object: file)
                                }
                                self?.arrMedia.remove(at: cell.btnStatus.tag)
                                DispatchQueue.main.async {
                                    self?.colSharedFile.reloadData()
                                }
//                                self?.colSharedFile.reloadData()
                            }
                        })
                    case .FileExist: /// If file is filed to upload on server
                        /// and file type is not allowed to upload
                        self?.presentAlertViewWithOneButton(alertTitle: nil, alertMessage: CFileIsAlreadyExistsInThisFolder, btnOneTitle: CBtnDelete, btnOneTapped: { [weak self] (_) in
                            guard let _ = self else {return}
                            GCDMainThread.async {
                                if let file = self?.arrMedia[cell.btnStatus.tag]{
                                    self?.failedFiles.remove(object: file)
                                }
                                self?.arrMedia.remove(at: cell.btnStatus.tag)
                                DispatchQueue.main.async {
                                    self?.colSharedFile.reloadData()
                                }
//                                self?.colSharedFile.reloadData()
                            }
                        })
                    }
                }
                // Load more data....
                
                //                            if (indexPath == colSharedFile.lastIndexPath()) && !self.isLoadMoreCompleted && apiTask?.state != URLSessionTask.State.running {
                //                                self.getFileListFromServer(isLoader: false)
                //                            }
                //
                return cell
            }
            
        }
        
        return UICollectionViewCell()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if arrMedia.count <= indexPath.row{
            return
        }
        if isGridviewSelect == false  {
            
            let media = arrMedia[indexPath.row]
            if let file = media.fileList{
                
                guard let url = URL(string: file.filePath) else{return}
                let fileType = AssetTypes.getType(ext: url.pathExtension)
                
                if fileType == .Video{
                    
                    /// Video will be play from server URL
                    let player = AVPlayer(url: url)
                    let playerViewController = AVPlayerViewController()
                    playerViewController.player = player
                    if #available(iOS 13.0, *){
                        playerViewController.isModalInPresentation = true
                        playerViewController.modalPresentationStyle = .fullScreen
                    }
                    self.present(playerViewController, animated: true) {
                        playerViewController.player!.play()
                    }
                    return
                    
                }else if fileType == .Image{
                    
                    
                    guard let cell = colSharedFile.cellForItem(at: indexPath) as? CreateFileColls else {
                        return
                    }
                    let lightBoxHelper = LightBoxControllerHelper()
                    lightBoxHelper.openSingleImage(image: cell.imgV.image, viewController: self)
                    
                    return
                }
                
                guard QLPreviewController.canPreview(url as QLPreviewItem) else{
                    self.presentAlertViewWithOneButton(alertTitle: nil, alertMessage:CUnsupportedFileType, btnOneTitle: CBtnOk , btnOneTapped: nil)
                    return
                }
                
                if let fileSharing = FileSharingProgressVC.getInstance(){
                    
                    fileSharing.downloadfile(controller: self, fileUrl: url, folderID: file.id, completion: { [weak self] (status, fileURL) in
                        guard let self = self else { return }
                        if status{
                            if let _url = fileURL{
                                self.previewFile(fileURL: _url)
                            }
                        }
                    })
                }
            }
        }else {
            
            let media = arrMedia[indexPath.row]
            if let file = media.fileList{
                
                guard let url = URL(string: file.filePath) else{return}
                let fileType = AssetTypes.getType(ext: url.pathExtension)
                
                if fileType == .Video{
                    
                    /// Video will be play from server URL
                    let player = AVPlayer(url: url)
                    let playerViewController = AVPlayerViewController()
                    playerViewController.player = player
                    if #available(iOS 13.0, *){
                        playerViewController.isModalInPresentation = true
                        playerViewController.modalPresentationStyle = .fullScreen
                    }
                    self.present(playerViewController, animated: true) {
                        playerViewController.player!.play()
                    }
                    return
                    
                }else if fileType == .Image{
                    
                    
                    guard let cell = colSharedFile.cellForItem(at: indexPath) as? ClListviewCell else {
                        return
                    }
                    let lightBoxHelper = LightBoxControllerHelper()
                    lightBoxHelper.openSingleImage(image: cell.imgV.image, viewController: self)
                    
                    return
                }
                
                guard QLPreviewController.canPreview(url as QLPreviewItem) else{
                    self.presentAlertViewWithOneButton(alertTitle: nil, alertMessage:CUnsupportedFileType, btnOneTitle: CBtnOk , btnOneTapped: nil)
                    return
                }
                
                if let fileSharing = FileSharingProgressVC.getInstance(){
                    
                    fileSharing.downloadfile(controller: self, fileUrl: url, folderID: file.id, completion: { [weak self] (status, fileURL) in
                        guard let self = self else { return }
                        if status{
                            if let _url = fileURL{
                                self.previewFile(fileURL: _url)
                            }
                        }
                    })
                }
            }
        }
    }
}


extension SharedFilesDetailsVC:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0{
            let height = collectionView.frame.height/10
            let width = UIScreen.main.bounds.width
            let size = CGSize(width: width, height: height)
            return size
        }else{
            let width = collectionView.frame.size.width
            return CGSize(width: ((width / 2) - 1.5) , height: collectionView.frame.size.height/6)
//            return CGSize(width: ((width / 2) - 10) , height: collectionView.bounds.height/6)
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
        
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
}




//extension SharedFilesDetailsVC: UITableViewDelegate,UITableViewDataSource {
//     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == 0{
//            if isGridviewSelect == false {
//                return ((CScreenWidth * 60) / 375)
//            }
//        }else{
//            if isGridviewSelect == true {
//                return UITableView.automaticDimension
//            }
//        }
//
////        if isGridviewSelect == false {
////            if indexPath.section == 0{
////            return ((CScreenWidth * 60) / 375)
////            }
////        }else {
////            if indexPath.section == 1{
////            return UITableView.automaticDimension
////            }
////        }
////
////        if indexPath.section == 0{
////        return ((CScreenWidth * 60) / 375)
////        }else {
//////         return ((CScreenWidth * 85) / 375)
////            return UITableView.automaticDimension
////        }
//        return UITableView.automaticDimension
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        if isGridviewSelect == false{
//            if section == 0{
//            if arrMedia.count == 0 {
//            tblSharedFile.setEmptyMessage(CNoFileAdded)
//            return 0
//           }
//            tblSharedFile.restore()
//            return arrMedia.count
//            }
//        }else{
//            if section == 1{
//             if arrMedia.count == 0 {
//                tblSharedFile.setEmptyMessage(CNoFileAdded)
//                return 0
//               }
//                return 1
//            }else {
//                return 0
//            }
//        }
//
////        if section == 0{
////        if arrMedia.count == 0 {
////        //tblSharedFile.setEmptyMessage(CNoFileYet)
////        tblSharedFile.setEmptyMessage(CNoFileAdded)
////        return 0
////       }
////        tblSharedFile.restore()
////        return arrMedia.count
////        }else {
////            return 1
////        }
//
//       return 0
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        if arrMedia.count <= indexPath.row{
//            return UITableViewCell(frame: .zero)
//        }
//
////        if isGridviewSelect == false{
//            if indexPath.section == 0{
//            if let cell = tableView.dequeueReusableCell(withIdentifier: "CreateFileTableCell") as? CreateFileTableCell {
//
//                let media = arrMedia[indexPath.row]
//
//                cell.vwShareFile.isHidden = false
//                cell.imgV.isHidden = true
//                cell.lblFileDate.isHidden = false
//
//                if let file = media.fileList{
//                    /// Here is the configure cell for list of files are from server.
//                    cell.lblFileName.text = file.fileName
//                    cell.lblFileDate.text = file.createdDate
//
//                    if media.assetType == .Image{
//                        cell.imgV.loadImageFromUrl(file.filePath, false)
//                        cell.imgV.isHidden = false
//                    }
//
//                }else{
//                    /// If user has added files from Gallery or File controller
//                    /// then it will be configure here.
//                    cell.lblFileName.text = media.fileName ?? ""
//                    cell.lblFileDate.text = media.createdAt
//
//                    if media.assetType == .Image{
//                        cell.imgV.image = media.image
//                        cell.imgV.isHidden = false
//                    }
//                }
//
//                cell.updateStatus(status: media.uploadMediaStatus)
//
//                cell.btnShareFile.tag = indexPath.row
//                /// on Share File button
////                cell.btnShareFile.touchUpInside {[weak self] (sender) in
////                    guard let self = self else { return }
////                    let model = self.arrMedia[sender.tag]
////                    if let file = model.fileList{
////
////                        guard let url = URL(string: file.filePath) else{return}
////
////                        if let fileSharing = FileSharingProgressVC.getInstance(){
////                            //fileSharing.presentController(controller:self)
////
////                            fileSharing.downloadfile(controller: self, fileUrl: url, folderID: file.id, completion: { (status, url) in
////                                if status{
////                                    let objectsToShare = [url]
////                                    let activityVC = UIActivityViewController(activityItems: objectsToShare as [Any], applicationActivities: nil)
////
////                                    //New Excluded Activities Code
////                                    //activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop]
////
////                                    activityVC.popoverPresentationController?.sourceView = sender
////                                    if #available(iOS 13.0, *){
////                                        activityVC.isModalInPresentation = true
////                                        activityVC.modalPresentationStyle = .fullScreen
////                                    }
////                                    self.present(activityVC, animated: true, completion: nil)
////                                    activityVC.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
////                                        print("activityVC.completionWithItemsHandler")
////                                        if let _url = url {
////                                            try! FileManager.default.removeItem(at: _url)
////                                        }
////                                        if completed == true {
////                                        }
////                                    }
////                                }
////                            })
////                            return
////                        }
////                    }
////                }
//
//                cell.btnStatus.tag = indexPath.row
//                cell.btnStatus.isHidden = self.isFromSharedFiles
//                /// on close or Info button
////                cell.btnStatus.touchUpInside {[weak self] (_) in
////                    guard let _ = self else{return}
////                    switch media.uploadMediaStatus{
////                    case .Pendding:
////                        self?.deleteFile(cell.btnStatus.tag)
////                    case .Succeed: /// If file is available on server
////                        self?.presentAlertViewWithTwoButtons(alertTitle: nil, alertMessage: CMessageDeleteFile , btnOneTitle: CBtnYes, btnOneTapped: { [weak self] (_) in
////                            guard let _ = self else {return}
////                            GCDMainThread.async {
////                                self?.apiDeleteFile(index: cell.btnStatus.tag)
////                            }
////                            }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
////                    case .Failed: /// If file is filed to upload on server
////                        /// and file type is not allowed to upload
////                        self?.presentAlertViewWithTwoButtons(alertTitle: nil, alertMessage: CFileTypeNotAllowedtoUpload, btnOneTitle: CBtnDelete, btnOneTapped: { [weak self] (_) in
////                            guard let _ = self else {return}
////                            GCDMainThread.async {
////                                if let file = self?.arrMedia[cell.btnStatus.tag]{
////                                    self?.failedFiles.remove(object: file)
////                                }
////                                self?.arrMedia.remove(at: cell.btnStatus.tag)
////                                self?.tblSharedFile.reloadData()
////                            }
////                            }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
////                    case .FailedWithRetry: /// If file is filed whule uploading
////                        self?.presentAlertViewWithTwoButtons(alertTitle: nil, alertMessage: CThereIsSomeIssueInUploadingFile , btnOneTitle: CBtnRetry, btnOneTapped: { [weak self] (_) in
////                            guard let _ = self else {return}
////                            GCDMainThread.async {
////                                self?.createFiles(file: self?.arrMedia[cell.btnStatus.tag])
////                            }
////                            }, btnTwoTitle: CBtnRemove, btnTwoTapped: { [weak self] (_) in
////                                guard let _ = self else {return}
////                                GCDMainThread.async {
////                                    if let file = self?.arrMedia[cell.btnStatus.tag]{
////                                        self?.failedFiles.remove(object: file)
////                                    }
////                                    self?.arrMedia.remove(at: cell.btnStatus.tag)
////                                    self?.tblSharedFile.reloadData()
////                                }
////                        })
////                    case .FileExist: /// If file is filed to upload on server
////                        /// and file type is not allowed to upload
////                        self?.presentAlertViewWithOneButton(alertTitle: nil, alertMessage: CFileIsAlreadyExistsInThisFolder, btnOneTitle: CBtnDelete, btnOneTapped: { [weak self] (_) in
////                            guard let _ = self else {return}
////                            GCDMainThread.async {
////                                if let file = self?.arrMedia[cell.btnStatus.tag]{
////                                    self?.failedFiles.remove(object: file)
////                                }
////                                self?.arrMedia.remove(at: cell.btnStatus.tag)
////                                self?.tblSharedFile.reloadData()
////                            }
////                        })
////                    }
////                }
//                // Load more data....
//                if (indexPath == tblSharedFile.lastIndexPath()) && !self.isLoadMoreCompleted && apiTask?.state != URLSessionTask.State.running {
//                    self.getFileListFromServer(isLoader: false)
//                }
//                return cell
//            }
//
//        }
//        return UITableViewCell()
//    }

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        if arrMedia.count <= indexPath.row{
//            return
//        }
//        let media = arrMedia[indexPath.row]
//        if let file = media.fileList{
//
//            guard let url = URL(string: file.filePath) else{return}
//            let fileType = AssetTypes.getType(ext: url.pathExtension)
//
//            if fileType == .Video{
//
//                /// Video will be play from server URL
//                let player = AVPlayer(url: url)
//                let playerViewController = AVPlayerViewController()
//                playerViewController.player = player
//                if #available(iOS 13.0, *){
//                    playerViewController.isModalInPresentation = true
//                    playerViewController.modalPresentationStyle = .fullScreen
//                }
//                self.present(playerViewController, animated: true) {
//                    playerViewController.player!.play()
//                }
//                return
//
//            }else if fileType == .Image{
//                guard let cell = tableView.cellForRow(at: indexPath) as? CreateFileTableCell else {
//                    return
//                }
//                let lightBoxHelper = LightBoxControllerHelper()
//                lightBoxHelper.openSingleImage(image: cell.imgV.image, viewController: self)
//
//                return
//            }
//
//            guard QLPreviewController.canPreview(url as QLPreviewItem) else{
//                self.presentAlertViewWithOneButton(alertTitle: nil, alertMessage:CUnsupportedFileType, btnOneTitle: CBtnOk , btnOneTapped: nil)
//                return
//            }
//
//            if let fileSharing = FileSharingProgressVC.getInstance(){
//
//                fileSharing.downloadfile(controller: self, fileUrl: url, folderID: file.id, completion: { [weak self] (status, fileURL) in
//                    guard let self = self else { return }
//                    if status{
//                        if let _url = fileURL{
//                            self.previewFile(fileURL: _url)
//                        }
//                    }
//                })
//            }
//        }
//    }

//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let footerView = UIView()
//        footerView.backgroundColor = .clear
//        footerView.isUserInteractionEnabled = false
//        return footerView
//    }
//
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 70
//    }

//}





//MARK: - Action Events
extension SharedFilesDetailsVC {
    
    @IBAction func btnAddFolderAction(_ sender: UIButton) {
        
        self.presentActionsheetWithTwoButtons(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CNavFiles, btnOneStyle: .default, btnOneTapped: { [weak self] (filesButton) in
            //print("Files")
            guard let self = self else { return }
            let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.audio", "public.video", "public.text", "com.apple.iwork.pages.pages", "public.data"], in: .import)
            
            documentPicker.delegate = self
            self.present(documentPicker, animated: true, completion: nil)
            
        }, btnTwoTitle: CBtnGallery, btnTwoStyle: .default) { [weak self] (cameraButton) in
            guard let self = self else { return }
            self.pickerButtonTap()
        }
    }
}


//MARK: - API Function
extension SharedFilesDetailsVC {
    
    @objc func pullToRefresh() {
        
        if apiTask?.state == URLSessionTask.State.running {
            apiTask?.cancel()
        }
        
        if !self.arrMedia.isEmpty{
            self.failedFiles = self.arrMedia.filter({$0.uploadMediaStatus == .Failed || $0.uploadMediaStatus == .Failed})
        }
        self.arrMedia.removeAll()
        self.arrMedia += self.failedFiles
        self.isLoadMoreCompleted = false
        self.timestamp = 0
        self.refreshControl.beginRefreshing()
        self.getFileListFromServer(isLoader: false)
    }
    
    func preparemediafile(arr:[[String:Any]],completion : @escaping  ()-> Void) {
      
        for obj in arr {
            let media = MDLAddMedia()
            media.isFromGallery = false
            media.uploadMediaStatus = .Succeed
            media.fileList = MDLFileList(fromDictionary: obj)
            media.assetType = AssetTypes.getTypeFromValue(value: media.fileList?.type ?? "")
            self.arrMedia.append(media)
            self.timestamp = media.fileList?.createdAt ?? 0
        }
        completion()
    }
    
    func getFileListFromServer(isLoader:Bool = true) {
        
        var para = [String : Any]()
        
        para["search"] = self.searchBarSharedFile.text
        para[CFolderID] = folder.id
        para[CTimestamp] = self.timestamp // == 0 ? "" : self.timestamp
        
//        apiTask = APIRequest.shared().fileList(param: para, showLoader: isLoader, completion: { (response, error) in
//            self.refreshControl.endRefreshing()
//            self.apiTask?.cancel()
//            if response != nil {
//                GCDMainThread.async {
//                    let data = response![CData] as? [String : Any] ?? [:]
//                    let arrData = data[CFiles] as? [[String : Any]] ?? []
//                    self.isLoadMoreCompleted = (arrData.count == 0)
//                    self.preparemediafile(arr: arrData) {
//                        [weak self] in
//
//                        DispatchQueue.main.async {
//                            self?.colSharedFile.reloadData()
//                        }
//                    }
////                    for obj in arrData {
////                        let media = MDLAddMedia()
////                        media.isFromGallery = false
////                        media.uploadMediaStatus = .Succeed
////                        media.fileList = MDLFileList(fromDictionary: obj)
////                        media.assetType = AssetTypes.getTypeFromValue(value: media.fileList?.type ?? "")
////                        self.arrMedia.append(media)
////                        self.timestamp = media.fileList?.createdAt ?? 0
////                    }
//
////                    self.colSharedFile.reloadData()
//
//                }
//            }
//        })
    }
    
    fileprivate func createFiles(file:MDLAddMedia?) {
        
        let dispatchGroup = DispatchGroup()
        
        var uploadFiles : [MDLAddMedia] = []
        
        if file != nil{ /// For single file upload
            uploadFiles.append(file!)
        }else{ /// For multiple file upload
            uploadFiles = self.arrMedia.filter({$0.uploadMediaStatus == .Pendding})
        }
        if uploadFiles.isEmpty{
            return
        }
        
        GCDMainThread.async {
            MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        }
        var statusFailed = false
        let concurrentQueue = DispatchQueue(label: "queue", attributes: .concurrent)
        let semaphore = DispatchSemaphore(value: 1)
        var index = 0
        for asset in uploadFiles {
            var para = [String : Any]()
            para[CFolderID] = folder.id
            para[CFileType] = asset.assetType.rawValue
            print(para)
            dispatchGroup.enter()
            concurrentQueue.async {
                semaphore.wait() /// wait until last file is not upload
                index += 1
                var strPlaceholder = ""
                if uploadFiles.count > 1{
                    strPlaceholder = "(\(index) \(COutOf) \(uploadFiles.count))\n"
                }
                print("----------------------------------")
                print((BASEURLNEW + CAPITagCreateFiles))
                print(para)
                print(CFile)
                
                APIRequest.shared().uploadFiles(apiName: CAPITagCreateFiles, param: para, key: CFile, assets: asset, progressBlock: { (progress) in
                    
                    var str = "\(CMessagePleaseWait)...\n"
                    str += "\(strPlaceholder)"
                    str += "\(CUploading) \(Int(progress))%"
                    //MILoader.shared.setLblMessageText(message:str)
                    //print("==> \(str)")
                    GCDMainThread.async {
                        MILoader.shared.setLblMessageText(message:str)
                        MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: str)
                    }
                    
                    
                }, completion: { [weak self] (response, error) in
                    guard let _ = self else {
                        statusFailed = true
                        dispatchGroup.leave()
                        semaphore.signal()
                        return
                    }
                    
                    if response != nil {
                        print("File Response : \(response ?? "[:]" as AnyObject)")
                        if let meta = response!.value(forKey: CJsonMeta) as? [String : Any]{
                            if meta.valueForInt(key: CStatus) == 0{
                                let data = response!.value(forKey: CData) as? [String : Any] ?? [:]
                                asset.isFromGallery = false
                                asset.fileList = MDLFileList(fromDictionary: data)
                                asset.assetType = AssetTypes.getTypeFromValue(value: asset.fileList?.type ?? "")
                                asset.uploadMediaStatus = .Succeed
                            }else if meta.valueForInt(key: CStatus) == 1{
                                asset.uploadMediaStatus = .FileExist
                                //statusFailed = false
                                if !(self?.failedFiles.contains(asset) ?? false){
                                    self?.failedFiles.insert(asset, at: 0)
                                }
                            }else{
                                asset.uploadMediaStatus = .Failed
                                statusFailed = true
                                if !(self?.failedFiles.contains(asset) ?? false){
                                    self?.failedFiles.insert(asset, at: 0)
                                }
                            }
                        }else{
                            let data = response as? [String:Any]
                            if data?.valueForInt(key: CStatus) == 400{
                                asset.uploadMediaStatus = .Failed
                                statusFailed = true
                                if !(self?.failedFiles.contains(asset) ?? false){
                                    self?.failedFiles.insert(asset, at: 0)
                                }
                            }else{
                                asset.uploadMediaStatus = .FailedWithRetry
                                statusFailed = true
                                if !(self?.failedFiles.contains(asset) ?? false){
                                    self?.failedFiles.insert(asset, at: 0)
                                }
                            }
                        }
                    }else{
                        if !(self?.failedFiles.contains(asset) ?? false){
                            self?.failedFiles.insert(asset, at: 0)
                        }
                        if (error?.code ?? 0) == 400 {
                            asset.uploadMediaStatus = .Failed
                            statusFailed = true
                        }else{
                            asset.uploadMediaStatus = .FailedWithRetry
                            statusFailed = true
                        }
                    }
                    semaphore.signal()
                    dispatchGroup.leave()
                })
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            /// DispatchGroup will be notify once all task has been completed
            DispatchQueue.main.async {
                MILoader.shared.hideLoader()
                if let controller = self.navigationController?.getViewControllerFromNavigation(FileSharingViewController.self){
                    controller.fileVC?.myFilesSharedFilesFolders()
                }
                let arrSucceed = self.arrMedia.filter({$0.uploadMediaStatus == .Succeed})
                self.arrMedia = self.failedFiles
                self.arrMedia += arrSucceed
                DispatchQueue.main.async {
                    self.colSharedFile.reloadData()
                }
//                self.colSharedFile.reloadData()
                if statusFailed{
                    var strMsg = CThereIsSomeIssueInUploadingFile
                    if self.failedFiles.count > 1{
                        strMsg = CThereIsSomeIssueInUploadingFiles
                    }
                    self.presentAlertViewWithOneButton(alertTitle: nil, alertMessage:strMsg, btnOneTitle: CBtnOk , btnOneTapped: nil)
                }
            }
        }
    }
    
    fileprivate func checkFileExistOnServer(){
        var arrFilesName : [String] = []
        for file in self.arrMedia{
            if file.uploadMediaStatus == .Pendding, let fileName = file.fileName{
                arrFilesName.append(fileName.lowercased())
            }
        }
        var para = [String : Any]()
        para[CFolderID] = self.folder.id
        para["file_name"] =  arrFilesName
        print(para)
        
//        APIRequest.shared().checkFilesExists(param: para, showLoader: true) { (response, error) in
//            if response != nil {
//                if let arrData = response!.value(forKey: CData) as? [[String : Any]]{
//                    for data in arrData{
//                        guard data.valueForInt(key: "status") == 1 else{
//                            continue
//                        }
//                        let fname = data.valueForString(key: "file_name")
//                        guard let fileObj = self.arrMedia.filter({($0.fileName ?? "").lowercased() == fname.lowercased() && $0.uploadMediaStatus == .Pendding}).first else{
//                            continue
//                        }
//                        fileObj.uploadMediaStatus = .FileExist
//                    }
//                    DispatchQueue.main.async {
//                        self.colSharedFile.reloadData()
//                        self.createFiles(file: nil)
//                    }
//                }
//            }
//        }
    }
    
    fileprivate func apiDeleteFile(index:Int){
        if self.arrMedia.count <= index{
            return
        }
        let fileName = self.arrMedia[index].fileList?.fileName ?? ""
        var para = [String : Any]()
        para["file_id"] = self.arrMedia[index].fileList?.id
        para[CFolderID] = self.folder.id
        
//        APIRequest.shared().deleteFile(param: para, showLoader: true) { (response, error) in
//            if response != nil {
//                GCDMainThread.async {
//                    
//                    if let controller = self.navigationController?.getViewControllerFromNavigation(FileSharingViewController.self){
//                        controller.fileVC?.getUserStorageSpace(isLoader: false)
//                    }
//                    self.deleteFileInLocalStorage(fileName: fileName)
//                    self.arrMedia.remove(at: index)
//                    DispatchQueue.main.async {
//                        self.colSharedFile.reloadData()
//                    }
////                    self.colSharedFile.reloadData()
//                }
//            }
//        }
    }
}

//MARK: - UIDocument Picker Delegate
extension SharedFilesDetailsVC: UIDocumentPickerDelegate {
    
    func fileSize(forURL url: URL) -> Double {
        let fileURL = url
        var fileSize: Double = 0.0
        var fileSizeValue = 0.0
        try? fileSizeValue = (fileURL.resourceValues(forKeys: [URLResourceKey.fileSizeKey]).allValues.first?.value as? Double ?? 0.0)
        if fileSizeValue > 0.0 {
            fileSize = (Double(fileSizeValue) / (UnitOfBytes))
        }
        return fileSize // KB
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        
        let fileUrl = url
        print("The Url is : \(fileUrl)")
        
        let arrRestricted = self.restrictedFile.filter({$0.fileName.lowercased() == fileUrl.pathExtension.lowercased()})
        /// Check file is exist in restricted file list
        if arrRestricted.count > 0{
            DispatchQueue.main.async {
                self.presentAlertViewWithOneButton(alertTitle: nil, alertMessage: CFileTypeNotAllowedtoUpload, btnOneTitle: CBtnOk , btnOneTapped: nil)
            }
            return
        }
        /// Check the storage space before uploading
        print("File Size : \(fileSize(forURL: fileUrl))")
        let size = self.fileSize(forURL: fileUrl)
        
        let sizeMB = size / UnitOfBytes
        let sizeGB = sizeMB / UnitOfBytes
        if sizeGB > 1 {
            DispatchQueue.main.async {
                self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMaximumFileSizeAllowedToUploadIs1GB, btnOneTitle: CBtnOk , btnOneTapped: nil)
            }
            return
        }
        self.selectedData += size
        if selectedData > totalSpace {
            print("Disk is Full....")
            self.selectedData -= size
            DispatchQueue.main.async {
                self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CStoregFullMessage, btnOneTitle: CBtnOk , btnOneTapped: nil)
            }
            return
        }
        
        /*if !Utility.isFileTypeAllowsToUpload(controller:self, extention: fileUrl.pathExtension){ return}*/
        
        let assetTypes = AssetTypes.getType(ext: fileUrl.pathExtension)
        let media = MDLAddMedia()
        media.url = fileUrl.absoluteString
        media.isDownloadedFromiCloud = false
        media.fileName = fileUrl.lastPathComponent
        media.assetType = assetTypes
        media.createdAt = Date.generateCurrentWith()
        media.isFromGallery = false
        if assetTypes == .Image{
            if let imageData = try? Data(contentsOf: fileUrl){
                media.image = UIImage(data: imageData)
                self.arrMedia.insert(media, at: 0)
                DispatchQueue.main.async {
                    self.colSharedFile.reloadData()
                }
//                self.colSharedFile.reloadData()
                
            }
        }else{
            self.arrMedia.insert(media, at: 0)
            DispatchQueue.main.async {
                self.colSharedFile.reloadData()
            }
//            self.colSharedFile.reloadData()
        }
        checkFileExistOnServer()
        //self.createFiles(file: nil)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print(" cancelled by user")
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - TLPhotosPickerViewController
extension SharedFilesDetailsVC {
    
    func pickerButtonTap() {
        
        photosPickerViewController.delegate = self
        var configure = TLPhotosPickerConfigure()
        configure.usedCameraButton = false
        configure.numberOfColumn = 3
        configure.maxSelectedAssets = 10
        configure.recordingVideoQuality = .typeMedium
        photosPickerViewController.configure = configure
        photosPickerViewController.selectedAssets = self.arrMedia.filter({$0.isFromGallery}).compactMap({$0.asset})
        photosPickerViewController.logDelegate = self
        if #available(iOS 13.0, *){
            photosPickerViewController.isModalInPresentation = true
            photosPickerViewController.modalPresentationStyle = .fullScreen
        }
        self.present(photosPickerViewController, animated: true, completion: nil)
    }
    
    func converVideoByteToHumanReadable(_ bytes:Int64) -> String {
        let formatter:ByteCountFormatter = ByteCountFormatter()
        formatter.countStyle = .binary
        return formatter.string(fromByteCount: Int64(bytes))
    }
    func MIMEType(_ url: URL?) -> String? {
        guard let ext = url?.pathExtension else { return nil }
        if !ext.isEmpty {
            let UTIRef = UTTypeCreatePreferredIdentifierForTag("public.filename-extension" as CFString, ext as CFString, nil)
            let UTI = UTIRef?.takeUnretainedValue()
            UTIRef?.release()
            if let UTI = UTI {
                guard let MIMETypeRef = UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType) else { return nil }
                let MIMEType = MIMETypeRef.takeUnretainedValue()
                MIMETypeRef.release()
                return MIMEType as String
            }
        }
        return nil
    }
    
    func exportVideoFile(asset:TLPHAsset ,options: PHVideoRequestOptions? = nil, progressBlock:((Float) -> Void)? = nil, completionBlock:@escaping ((URL?,String) -> Void)) {
        guard let phAsset = asset.phAsset, phAsset.mediaType == .video else {
            completionBlock(nil,"")
            return
        }
        var type = PHAssetResourceType.video
        guard let resource = (PHAssetResource.assetResources(for: phAsset).filter{ $0.type == type }).first else {
            completionBlock(nil,"")
            return
        }
        let fileName = resource.originalFilename
        var writeURL: URL? = nil
        if #available(iOS 10.0, *) {
            writeURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(fileName)")
        } else {
            writeURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true).appendingPathComponent("\(fileName)")
        }
        guard let localURL = writeURL,let mimetype = MIMEType(writeURL) else {
            completionBlock(nil,"")
            return
        }
        var requestOptions = PHVideoRequestOptions()
        if let options = options {
            requestOptions = options
        }else {
            requestOptions.isNetworkAccessAllowed = true
        }
        PHImageManager.default().requestAVAsset(forVideo: phAsset, options: options) { (avasset, avaudioMix, infoDict) in
            guard let avasset = avasset else {
                print("PHImageManager.default().requestAVAsset Faild!!!")
                completionBlock(nil,"")
                return
            }
            let exportSession = AVAssetExportSession.init(asset: avasset, presetName: AVAssetExportPresetHighestQuality)
            exportSession?.outputURL = localURL
            exportSession?.outputFileType = AVFileType.mov
            exportSession?.exportAsynchronously(completionHandler: {
                completionBlock(localURL,mimetype)
            })
            func checkExportSession() {
                DispatchQueue.global().async { [weak exportSession] in
                    guard let exportSession = exportSession else {
                        print("checkExportSession Faild!!!")
                        completionBlock(nil,"")
                        return
                    }
                    switch exportSession.status {
                    case .waiting,.exporting:
                        DispatchQueue.main.async {
                            progressBlock?(exportSession.progress)
                        }
                        Thread.sleep(forTimeInterval: 1)
                        checkExportSession()
                    default:
                        break
                    }
                }
            }
            checkExportSession()
        }
    }
    
    func exportVideo(placeholder:String,asset:TLPHAsset ,onComplete:((_ thembnil:UIImage?,_ videoURL:URL?)->Void)?) {
        var vThum : UIImage!
        var vUrl : URL!
        if let thum = asset.fullResolutionImage{
            print(thum)
            vThum = thum
            /*if let videoURL = vUrl, let videoThum = vThum{
             onComplete?(videoThum,videoURL)
             }*/
        }
        let options = PHVideoRequestOptions()
        options.isNetworkAccessAllowed = true
        options.deliveryMode = .automatic
        //iCloud download progress
        options.progressHandler = { (progress, error, stop, info) in
            var str = "\(CMessagePleaseWait)...\n"
            str += "\(placeholder)"
            str += "\(CDownloadFromiCloud) \(Int(progress * 100))%"
            //MILoader.shared.setLblMessageText(message:str)
            GCDMainThread.async {
                MILoader.shared.setLblMessageText(message:str)
                MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: str)
            }
            print("Downloading from iCloud \(progress)")
            if (error != nil) {
                print(error?.localizedDescription ?? "")
            }
        }
        
        self.exportVideoFile(asset: asset, options:options, progressBlock: { (progress) in
            
            print(progress)
            var str = "\(CMessagePleaseWait)...\n"
            str += "\(placeholder)"
            str += "\(CExportingFile) \(Int(progress * 100))%"
            //MILoader.shared.setLblMessageText(message:str)
            GCDMainThread.async {
                MILoader.shared.setLblMessageText(message:str)
                MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: str)
            }
            
        }) { (url, mimeType) in
            print("exportVideoFile : \(url?.absoluteString ?? "URL not found")")
            vUrl = url
            if let videoURL = vUrl, let videoThum = vThum {
                onComplete?(videoThum,videoURL)
            }else{
                onComplete?(nil,nil)
            }
        }
    }
    
    func getSelectedImage(asset:TLPHAsset, onComplete:((_ thembnil:UIImage)->Void)?) {
        
        if let image = asset.fullResolutionImage {
            print(image)
            onComplete?(image)
        }else {
            print("Can't get image at local storage, try download image")
            asset.cloudImageDownload(progressBlock: { [weak self] (progress) in
                guard let _ = self else {return}
                DispatchQueue.main.async {
                    print(progress)
                }
            }, completionBlock: { [weak self] (image) in
                guard let _ = self else {return}
                if let _image = image {
                    //use image
                    DispatchQueue.main.async {
                        print(_image)
                        print("complete download")
                        onComplete?(_image)
                    }
                }
            })
        }
    }
}

//MARK: - TLPhotosPickerViewControllerDelegate ,TLPhotosPickerLogDelegate
extension SharedFilesDetailsVC : TLPhotosPickerViewControllerDelegate,TLPhotosPickerLogDelegate {
    
    func shouldDismissPhotoPicker(withTLPHAssets: [TLPHAsset]) -> Bool {
        
        if withTLPHAssets.isEmpty{
            return false
        }
        
        MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        
        self.arrMedia = self.arrMedia.filter({!$0.isFromGallery})
        
        let concurrentQueue = DispatchQueue(label: "queue", attributes: .concurrent)
        let semaphore = DispatchSemaphore(value: 1)
        var index = 0
        for asset in withTLPHAssets{
            
            let resources = PHAssetResource.assetResources(for: asset.phAsset!)
            var sizeOnDisk: Double = 0.0
            if let resource = resources.first {
                sizeOnDisk = resource.value(forKey: "fileSize") as? Double ?? 0.0
                print("sizeOnDisk : \(sizeOnDisk)")
                /// Check the storage space before uploading
                self.selectedData += (sizeOnDisk / UnitOfBytes )
                if self.selectedData > self.totalSpace{
                    print("Disk is Full....")
                    self.selectedData -= (sizeOnDisk / UnitOfBytes )
                    DispatchQueue.main.async {
                        self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CStoregFullMessage, btnOneTitle: CBtnOk , btnOneTapped: nil)
                    }
                    continue;
                }
            }
            self.dispatchGroup.enter()
            
            concurrentQueue.async {
                semaphore.wait()
                index += 1
                switch asset.type{
                case .video:
                    var strPlaceholder = ""
                    if withTLPHAssets.count > 1{
                        strPlaceholder = "(\(index) \(COutOf) \(withTLPHAssets.count))\n"
                    }
                    self.exportVideo(placeholder: strPlaceholder, asset: asset) { [weak self] (thum,url)in
                        guard let _ = thum, let _ = url else{
                            self?.dispatchGroup.leave()
                            semaphore.signal()
                            return
                        }
                        guard let _ = self else {
                            self?.dispatchGroup.leave()
                            semaphore.signal()
                            return
                        }
                        let media = MDLAddMedia()
                        media.image = thum
                        media.url = url!.absoluteString
                        media.isDownloadedFromiCloud = true
                        media.fileName = asset.originalFileName
                        media.assetType = .Video
                        media.createdAt = Date.generateCurrentWith()
                        self?.arrMedia.insert(media, at: 0)
                        GCDMainThread.async {
                            self?.colSharedFile.reloadData()
                            self?.dispatchGroup.leave()
                            semaphore.signal()
                        }
                    }
                    break
                case .livePhoto:
                    
                    self.getSelectedImage(asset: asset) { [weak self] (image) in
                        guard let _ = self else {
                            self?.dispatchGroup.leave()
                            semaphore.signal()
                            return
                        }
                        let media = MDLAddMedia()
                        media.image = image
                        media.fileName = asset.originalFileName
                        media.isDownloadedFromiCloud = true
                        media.assetType = .Image
                        media.createdAt = Date.generateCurrentWith()
                        self?.arrMedia.insert(media, at: 0)
                        GCDMainThread.async {
                            self?.colSharedFile.reloadData()
                            self?.dispatchGroup.leave()
                            semaphore.signal()
                        }
                    }
                    break
                case .photo :
                    self.getSelectedImage(asset: asset) { [weak self] (image) in
                        guard let _ = self else {
                            self?.dispatchGroup.leave()
                            semaphore.signal()
                            return
                        }
                        let media = MDLAddMedia()
                        media.image = image
                        media.fileName = asset.originalFileName
                        media.isDownloadedFromiCloud = true
                        media.assetType = .Image
                        media.createdAt = Date.generateCurrentWith()
                        self?.arrMedia.insert(media, at: 0)
                        GCDMainThread.async {
                            self?.colSharedFile.reloadData()
                            self?.dispatchGroup.leave()
                            semaphore.signal()
                        }
                    }
                    break
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            print("all activities complete 👍")
            MILoader.shared.hideLoader()
            DispatchQueue.main.async {
                self.colSharedFile.reloadData()
            }
//            self.colSharedFile.reloadData()
            //self.createFiles(file: nil)
            self.checkFileExistOnServer()
        }
        return true
    }
    
    func dismissPhotoPicker(withPHAssets: [PHAsset]) {
    }
    
    func handleNoAlbumPermissions(picker: TLPhotosPickerViewController) {
        picker.dismiss(animated: true) {
            let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!
            let alert = UIAlertController(
                title: nil,
                message: CDeniedAlbumsPermission,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: CBtnCancel, style: .destructive, handler: nil))
            alert.addAction(UIAlertAction(title: CNavSettings, style: .default, handler: { (alert) -> Void in
                UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //For Log User Interaction
    func selectedCameraCell(picker: TLPhotosPickerViewController) {
        print("selectedCameraCell")
    }
    
    func selectedPhoto(picker: TLPhotosPickerViewController, at: Int) {
        print("selectedPhoto")
    }
    
    func deselectedPhoto(picker: TLPhotosPickerViewController, at: Int) {
        print("deselectedPhoto")
    }
    
    func selectedAlbum(picker: TLPhotosPickerViewController, title: String, at: Int) {
        print("selectedAlbum")
    }
    
    func canSelectAsset(phAsset: PHAsset) -> Bool {
        
        if phAsset.mediaType == .video{
            
            let resources = PHAssetResource.assetResources(for: phAsset)
            var sizeOnDisk: Int64? = 0
            if let resource = resources.first {
                let unsignedInt64 = resource.value(forKey: "fileSize") as? CLong
                sizeOnDisk = Int64(bitPattern: UInt64(unsignedInt64!))
            }
            
            let onDisk = sizeOnDisk ?? 0
            let sizeMB : Double = Double(onDisk) / 1000000.0
            if sizeMB > UnitOfBytes {
                DispatchQueue.main.async {
                    self.photosPickerViewController.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMaximumFileSizeAllowedToUploadIs1GB, btnOneTitle: CBtnOk , btnOneTapped: nil)
                }
                return false
            }
            print(onDisk)
        }
        
        let resources = PHAssetResource.assetResources(for: phAsset)
        if let resource = resources.first{
            let strExtension = resource.originalFilename.components(separatedBy: ".").last ?? ""
            let arrRestricted = self.restrictedFile.filter({$0.fileName.lowercased() == strExtension.lowercased()})
            /// Check file is exist in restricted file list
            if arrRestricted.count > 0{
                DispatchQueue.main.async {
                    self.photosPickerViewController.presentAlertViewWithOneButton(alertTitle: nil, alertMessage: CFileTypeNotAllowedtoUpload, btnOneTitle: CBtnOk , btnOneTapped: nil)
                }
                return false
            }
        }
        return true
    }
}

//MARK: - QLPreviewControllerDataSource && Utility Methods
extension SharedFilesDetailsVC : QLPreviewControllerDataSource,QLPreviewControllerDelegate {
    
    func previewFile(fileURL:URL){
        
        self.previewItem = fileURL as NSURL
        let previewController = QLPreviewController()
        previewController.dataSource = self
        previewController.delegate = self
        if #available(iOS 13.0, *){
            previewController.isModalInPresentation = true
            previewController.modalPresentationStyle = .fullScreen
        }
        self.present(previewController, animated: true, completion: nil)
    }
    
    func downloadfile(fileUrl:URL,completion: @escaping (_ success: Bool,_ fileLocation: URL?) -> Void){
        
        // then lets create your document folder url
        //var documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentsDirectoryURL = NSURL.fileURL(withPath: NSTemporaryDirectory(), isDirectory: true)
        // Make a directory if Folder ID
        //documentsDirectoryURL = documentsDirectoryURL.appendingPathComponent("\(self.folder.id ?? 0)")
        do
        {
            try FileManager.default.createDirectory(at: documentsDirectoryURL, withIntermediateDirectories: true, attributes: nil)
        }
        catch let error as NSError
        {
            NSLog("Unable to create directory \(error.debugDescription)")
        }
        
        // lets create your destination file url
        let destinationUrl = documentsDirectoryURL.appendingPathComponent(fileUrl.lastPathComponent)
        print("File URL : \(destinationUrl.absoluteString)")
        // to check if it exists before downloading it
        if FileManager.default.fileExists(atPath: destinationUrl.path) {
            debugPrint("The file already exists at path")
            completion(true, destinationUrl)
            
            // if the file doesn't exist
        } else {
            
            // you can use NSURLSession.sharedSession to download the data asynchronously
            URLSession.shared.downloadTask(with: fileUrl, completionHandler: { (location, response, error) -> Void in
                guard let tempLocation = location, error == nil else { return }
                do {
                    // after downloading your file you need to move it to your destination url
                    try FileManager.default.moveItem(at: tempLocation, to: destinationUrl)
                    print("File moved to documents folder")
                    completion(true, destinationUrl)
                } catch let error as NSError {
                    print(error.localizedDescription)
                    completion(false, nil)
                }
            }).resume()
        }
    }
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return self.previewItem as QLPreviewItem
    }
    func previewControllerDidDismiss(_ controller: QLPreviewController) {
        try? FileManager.default.removeItem(at: (previewItem as URL))
    }
}
