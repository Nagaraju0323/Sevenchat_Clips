//
//  CreateFolderVC.swift
//  Sevenchats
//
//  Created by mac-00018 on 01/06/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

import UIKit
import QuickLook
import TLPhotoPicker
import Photos
import MobileCoreServices

enum CreateFolderType{
    case AddType
    case EditType
}

class CreateFolderVC: ParentViewController {

    @IBOutlet var txtFolderName: MIGenericTextFiled!{
        didSet{
            self.txtFolderName.PlaceHolderColor = ColorPlaceholder
            self.txtFolderName.placeHolder = CEnterFolderName
            self.txtFolderName.updatePlaceholderFrame(false)
        }
    }
    /// btnAddFiles for add/upload new file
    @IBOutlet var btnAddFile: UIButton!{
        didSet{
            btnAddFile.setTitle(CAddFiles, for: .normal)
        }
    }
    /// btnInfoBar for check restricted file list
    @IBOutlet var btnInfoBar: UIButton!{
        didSet{
            if let controller = self.navigationController?.getViewControllerFromNavigation(FileSharingViewController.self){
                self.restrictedFile = controller.arrRestrictedFileType
                if self.restrictedFile.isEmpty{
                    btnInfoBar.alpha = 0
                    return
                }
                btnInfoBar.alpha = 1
                btnInfoBar.touchUpInside { [weak self] (sender) in
                    guard let _ = self else {return}
                    if let restrictionVC = CStoryboardFile.instantiateViewController(withIdentifier: "RestrictedFilesVC") as? RestrictedFilesVC{
                        restrictionVC.arrDatasource = self?.restrictedFile ?? []
                        self?.navigationController?.pushViewController(restrictionVC, animated: true)
                    }
                }
            }
        }
    }
    
    @IBOutlet weak var tblAddedFolders: UITableView! {
        didSet {
             self.tblAddedFolders.tableFooterView = UIView(frame: .zero)
            self.tblAddedFolders.register(UINib(nibName: "CreateFileTableCell", bundle: nil), forCellReuseIdentifier: "CreateFileTableCell")
            self.tblAddedFolders.separatorStyle = .none
        }
    }
    
    /// Arrary of added item in list
    var arrMedia : [MDLAddMedia] = []
    
    /// Arrary of selected items from `TLPhotoPicker` picker
    var selectedAssets = [TLPHAsset]()
    
    /// `dispatchGroup` Used for get assets item from gallery
    let dispatchGroup = DispatchGroup()
    
    /// For Add or Edit file
    var typeOfAction = CreateFolderType.AddType
    
    /// `folder` it's containt folder id and name
    var folder : MDLCreateFolder!
    
    /// `storage` used for check remanning storage space while uploading files
    var storage : MDLStorage!
    var totalSpace = 0.0
    var selectedData = 0.0
    
    /// It's list of extension. It will be used while uploading file on server to check
    /// file is restricted or not
    var restrictedFile : [MDLRestractedFile] = []
    
    /// Select photos and video from Gallery
    let photosPickerViewController = TLPhotosPickerViewController()
    
    // View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialization()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.txtFolderName.txtDelegate = self
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.txtFolderName.txtDelegate = nil
    }
    
    override func viewDidLayoutSubviews() {
    }
    
    deinit {
        print("Deinit -> CreateFolderVC")
    }
}

// MARK: - Initialization
extension CreateFolderVC {

    fileprivate func initialization() {
    
        DispatchQueue.main.async {
            self.title = CNavCreateFolder
            
            self.createNavigationRightButton()
            
            self.totalSpace = self.storage.totalSpace * UnitOfBytes
            self.selectedData = self.storage.uploaded * UnitOfBytes
            
            if self.typeOfAction == .EditType{
                self.txtFolderName.text = self.folder?.folderName ?? ""
                DispatchQueue.main.async {
                    self.txtFolderName.updatePlaceholderFrame(true)
                    self.txtFolderName.isEnabled = false
                }
            }
        }
    }
    
    // Create navigation right bar button..
    fileprivate func createNavigationRightButton() {
        
        let button = UIButton(type: .custom)
        let btnHeight = 40
        button.frame = CGRect(x: 0, y: 0, width: btnHeight, height: btnHeight)
        button.setImage(UIImage(named: "ic_add_post"), for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(customView: button)
        
        button.touchUpInside { [weak self] (_) in
            guard let _ = self else {return}
            
            // Validation....
            if (self?.txtFolderName.text?.isBlank)!{
                self?.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CCreateFolderAlertBlank, btnOneTitle: CBtnOk , btnOneTapped: nil)
                return
            }
            
            // Add File in existing folder....
            if self?.typeOfAction == .EditType{
                self?.createFiles(folderId: self?.folder?.id ?? 0)
                return
            }
            
            // Create a new folder and then upload files....
            self!.createFolders()
        }
    }
    
    // Delete Folder....
    func deleteFolder(_ indexPath: IndexPath) {
        
        self.presentAlertViewWithTwoButtons(alertTitle: nil, alertMessage: CMessageDeleteFile , btnOneTitle: CBtnYes, btnOneTapped: { [weak self] (_) in
            guard let _ = self else {return}
            self?.arrMedia.remove(at: indexPath.row)
            GCDMainThread.async {
                self?.tblAddedFolders.reloadData()
            }
            
        }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
    }
    
    func checkSameFileExistInThisFolder(fileName:String) -> Bool{
        if !(arrMedia.filter({($0.fileName ?? "").lowercased() == fileName.lowercased()}).isEmpty){
            return true
        }
        return false
    }
}

//MARK: - API Functions
extension CreateFolderVC {
    
    fileprivate func createFolders() {
        
        var para = [String : Any]()
        para[CFolderName] = txtFolderName.text
        GCDMainThread.async {
            MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        }
        
//        APIRequest.shared().createFolder(param: para, showLoader: true) {[weak self] (response, error) in
//            guard let _ = self else {
//                MILoader.shared.hideLoader()
//                return
//            }
//            if response != nil {
//                
//                if let data = response![CData] as? [String:Any]{
//                    self?.folder = MDLCreateFolder(fromDictionary: data)
//                    GCDMainThread.async {
//                        self?.createFiles(folderId: self?.folder?.id ?? 0)
//                    }
//                }else{
//                    MILoader.shared.hideLoader()
//                }
//            }else{
//                MILoader.shared.hideLoader()
//            }
//        }
    }
    
    fileprivate func createFiles(folderId :Int) {
        
        let dispatchGroup = DispatchGroup()
        let concurrentQueue = DispatchQueue(label: "queue", attributes: .concurrent)
        let semaphore = DispatchSemaphore(value: 1)

        var statusFailed = false
        var index = 0
        for asset in self.arrMedia{
            var para = [String : Any]()
            para[CFolderID] = folderId
            para[CFileType] = asset.assetType.rawValue
            print(para)
            dispatchGroup.enter()
            concurrentQueue.async {
                semaphore.wait() /// wait until last file is not upload
                index += 1
                var strPlaceholder = ""
                if self.arrMedia.count > 1{
                    strPlaceholder = "(\(index) \(COutOf) \(self.arrMedia.count))\n"
                }

                APIRequest.shared().uploadFiles(apiName: CAPITagCreateFiles, param: para, key: CFile, assets: asset, progressBlock: { (progress) in
                    var str = "\(CMessagePleaseWait)...\n"
                    str += "\(strPlaceholder)"
                    str += "\(CUploading) \(Int(progress))%"
                    //MILoader.shared.setLblMessageText(message:str)
                    GCDMainThread.async {
                        MILoader.shared.setLblMessageText(message:str)
                        MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: str)
                    }
                    //print("uploading \(progress)")
                }, completion: { [weak self] (response, error) in
                    guard let _ = self else {
                        asset.uploadMediaStatus = .FailedWithRetry
                        semaphore.signal()
                        dispatchGroup.leave()
                        return
                    }
                    if response != nil {
                        print("File Response : \(response ?? "[:]" as AnyObject)")
                        let meta = response!.value(forKey: CJsonMeta) as? [String : Any] ?? [:]
                        if meta.valueForInt(key: CStatus) == 0{
                            asset.uploadMediaStatus = .Succeed
                        }else{
                            asset.uploadMediaStatus = .Failed
                            statusFailed = true
                        }
                    }else{
                        if (error?.code ?? 0) == 400 {
                            asset.uploadMediaStatus = .Failed
                            statusFailed = true
                        }else{
                            asset.uploadMediaStatus = .FailedWithRetry
                            statusFailed = true
                        }
                    }
                    dispatchGroup.leave()
                    semaphore.signal()
                })
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            /// DispatchGroup will be notify once all task has been completed
            DispatchQueue.main.async {
                
                MILoader.shared.hideLoader()
                self.tblAddedFolders.reloadData()
                if statusFailed{
                    let arrFailedFiles = self.arrMedia.filter({$0.uploadMediaStatus == .Failed || $0.uploadMediaStatus == .FailedWithRetry})
                    var strMsg = CThereIsSomeIssueInUploadingFile
                    if arrFailedFiles.count > 1{
                        strMsg = CThereIsSomeIssueInUploadingFiles
                    }
                    self.presentAlertViewWithOneButton(alertTitle: nil, alertMessage: strMsg, btnOneTitle: CBtnOk, btnOneTapped: { (alert) in
                        DispatchQueue.main.async {
                            self.redirectOnResponse()
                        }
                    })
                }else{
                    DispatchQueue.main.async {
                        self.presentAlertViewWithTwoButtons(alertTitle: nil, alertMessage: CDoYouWantToShareThisFolderWithFriends, btnOneTitle: CBtnNo, btnOneTapped: { (_) in
                            DispatchQueue.main.async {
                                if let controller = self.navigationController?.getViewControllerFromNavigation(FileSharingViewController.self){
                                    controller.fileVC?.pullToRefresh()
                                    self.navigationController?.popViewController(animated: false)
                                }
                            }
                        }, btnTwoTitle: CBtnYes, btnTwoTapped: { (_) in
                            DispatchQueue.main.async {
                                self.redirectToFriendListOnSuceess()
                            }
                        })
                    }
                }
            }
        }
    }
    
    func redirectToFriendListOnSuceess(){
        DispatchQueue.main.async {
            
            if let controller = self.navigationController?.getViewControllerFromNavigation(FileSharingViewController.self){
                controller.fileVC?.pullToRefresh()
            }
            if let friendsVC = CStoryboardFile.instantiateViewController(withIdentifier: "FriendsVC") as? FriendsVC {
                friendsVC.folder = self.folder
                friendsVC.isFromCreateFolder = true
                self.navigationController?.pushViewController(friendsVC, animated: true)
            }
        }
    }
    
    func redirectOnResponse(){
        DispatchQueue.main.async {
            if let controller = self.navigationController?.getViewControllerFromNavigation(FileSharingViewController.self){
                controller.fileVC?.pullToRefresh()
                self.navigationController?.popViewController(animated: false)
                let arrFailedFiles = self.arrMedia.filter({$0.uploadMediaStatus == .Failed || $0.uploadMediaStatus == .FailedWithRetry})
                if  let sharedFilesDetailsVC = CStoryboardFile.instantiateViewController(withIdentifier: "SharedFilesDetailsVC") as? SharedFilesDetailsVC {
                    sharedFilesDetailsVC.folder = self.folder.copy() as? MDLCreateFolder
                    sharedFilesDetailsVC.storage = self.storage
                    sharedFilesDetailsVC.arrMedia = arrFailedFiles
                    sharedFilesDetailsVC.failedFiles = arrFailedFiles
                   
                   CATransaction.begin()
                    CATransaction.setCompletionBlock({
                        sharedFilesDetailsVC.getFileListFromServer(isLoader: true)
                    })
                    controller.navigationController?.pushViewController(sharedFilesDetailsVC, animated: true)
                    CATransaction.commit()
                }
            }else{
                self.navigationController?.popViewController(animated: false)
            }
        }
    }
}

//MARK: - UITableView Delegate & Data Source
extension CreateFolderVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrMedia.count == 0{
            tblAddedFolders.setEmptyMessage(CNoFileAdded)
            return 0
        }
        tblAddedFolders.restore()
        return arrMedia.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CreateFileTableCell") as? CreateFileTableCell {
            
            let media = arrMedia[indexPath.row]
            cell.lblFileName.text = media.fileName ?? ""
            cell.lblFileDate.text = media.createdAt
            
            cell.vwShareFile.isHidden = true
            cell.imgV.isHidden = true
            
            if media.assetType == .Image{
                cell.imgV.image = media.image
                cell.imgV.isHidden = false
            }
            
            cell.updateStatus(status: media.uploadMediaStatus)
            
            cell.btnStatus.touchUpInside {[weak self] (_) in
                guard let _ = self else{return}
                switch media.uploadMediaStatus{
                case .Pendding: /// Status of pendding to upload
                    self?.deleteFolder(indexPath)
                default: break
                }
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ((CScreenWidth * 60) / 375)
    }
}

//MARK: - UIDocument Picker Delegate
extension CreateFolderVC: UIDocumentPickerDelegate {
    
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
        if fileUrl.absoluteString.hasSuffix("/"){
            return
        }
        
        // Check If name is exist in this folder.
        if checkSameFileExistInThisFolder(fileName: fileUrl.lastPathComponent){
            DispatchQueue.main.async {
                self.presentAlertViewWithOneButton(alertTitle: nil, alertMessage: CFileIsAlreadyExistsInThisFolder, btnOneTitle: CBtnOk , btnOneTapped: nil)
            }
            return
        }
        
        /// Check file is exist in restricted file list
        let arrRestricted = self.restrictedFile.filter({$0.fileName.lowercased() == fileUrl.pathExtension.lowercased()})
        if arrRestricted.count > 0{
            DispatchQueue.main.async {
                self.presentAlertViewWithOneButton(alertTitle: nil, alertMessage: CFileTypeNotAllowedtoUpload, btnOneTitle: CBtnOk , btnOneTapped: nil)
            }
            return
        }
        
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
        
        /// Check the storage space before uploading
        if selectedData > totalSpace{
            print("Disk is Full....")
            self.selectedData -= size
            DispatchQueue.main.async {
                self.presentAlertViewWithOneButton(alertTitle: nil, alertMessage: CStoregFullMessage, btnOneTitle: CBtnOk , btnOneTapped: nil)
            }
            return
        }
        
        let assetTypes = AssetTypes.getType(ext: fileUrl.pathExtension)
        let media = MDLAddMedia()
        media.url = fileUrl.absoluteString
        media.isDownloadedFromiCloud = false
        media.fileName = fileUrl.lastPathComponent
        media.assetType = assetTypes
        media.isFromGallery = false
        media.createdAt = Date.generateCurrentWith()
        if assetTypes == .Image{
            if let imageData = try? Data(contentsOf: fileUrl){
                media.image = UIImage(data: imageData)
                self.arrMedia.append(media)
                self.tblAddedFolders.reloadData()
            }
        }else{
            self.arrMedia.append(media)
            self.tblAddedFolders.reloadData()
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print(" cancelled by user")
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - Action Events
extension CreateFolderVC {
    
    @IBAction func btnAddFilesAction(_ sender: UIButton) {
        print("Added !!")
        
        self.presentActionsheetWithTwoButtons(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CNavFiles, btnOneStyle: .default, btnOneTapped: { [weak self] (filesButton) in
            print("Files")
            guard let self = self else { return }
            let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.text", "com.apple.iwork.pages.pages", "public.data"], in: .import)
            
            documentPicker.delegate = self
            if #available(iOS 13.0, *){
                documentPicker.isModalInPresentation = true
                documentPicker.modalPresentationStyle = .fullScreen
            }
            self.present(documentPicker, animated: true, completion: nil)
            
        }, btnTwoTitle: CBtnGallery, btnTwoStyle: .default) { [weak self] (cameraButton) in
            guard let self = self else { return }
            self.pickerButtonTap()
        }
    }
}


//MARK: - GenericTextFieldDelegate
extension CreateFolderVC : GenericTextFieldDelegate{
    
    func genericTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if self.txtFolderName == textField, self.txtFolderName?.text!.count ?? 0 > 19{
            return false
        }
        return true
    }
}

//MARK: - TLPhotosPickerViewController
extension CreateFolderVC {
    
    func pickerButtonTap() {
       
        photosPickerViewController.delegate = self
        var configure = TLPhotosPickerConfigure()
        configure.usedCameraButton = false
        configure.numberOfColumn = 3
        configure.maxSelectedAssets = 10
        photosPickerViewController.configure = configure
        photosPickerViewController.selectedAssets = self.selectedAssets
        photosPickerViewController.logDelegate = self
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
        //iCloud download progress
        //options.progressHandler = { (progress, error, stop, info) in
        
        //}
        PHImageManager.default().requestAVAsset(forVideo: phAsset, options: options) { (avasset, avaudioMix, infoDict) in
            guard let avasset = avasset else {
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
    
    func exportVideo(placeholder:String, asset:TLPHAsset ,onComplete:((_ thembnil:UIImage?,_ videoURL:URL?)->Void)?) {
        var vThum : UIImage!
        var vUrl : URL!
        if let thum = asset.fullResolutionImage{
            print(thum)
            vThum = thum
            if let videoURL = vUrl, let videoThum = vThum{
                onComplete?(videoThum,videoURL)
            }
        }
        let options = PHVideoRequestOptions()
        options.isNetworkAccessAllowed = true
        options.deliveryMode = .automatic
        //iCloud download progress
        options.progressHandler = { (progress, error, stop, info) in
            print(progress)
            var str = "\(CMessagePleaseWait)...\n"
            str += "\(placeholder)"
            str += "\(CDownloadFromiCloud) \(Int(progress * 100))%"
            //MILoader.shared.setLblMessageText(message:str)
            GCDMainThread.async {
                MILoader.shared.setLblMessageText(message:str)
                MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: str)
            }
            
            if (error != nil) {
                print(error?.localizedDescription ?? "")
            }
        }
        
        self.exportVideoFile(asset: asset, options:options, progressBlock: { (progress) in
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
extension CreateFolderVC : TLPhotosPickerViewControllerDelegate,TLPhotosPickerLogDelegate {
    
    
    func shouldDismissPhotoPicker(withTLPHAssets: [TLPHAsset]) -> Bool {
        
        if withTLPHAssets.isEmpty{
            return false
        }
        
        self.selectedAssets = withTLPHAssets
        
        MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        
        let concurrentQueue = DispatchQueue(label: "queue", attributes: .concurrent)
        let semaphore = DispatchSemaphore(value: 1)
        
        self.arrMedia = self.arrMedia.filter({!$0.isFromGallery})
        var index = 0
        for asset in self.selectedAssets{
            
            let resources = PHAssetResource.assetResources(for: asset.phAsset!)
            var sizeOnDisk: Double = 0.0
            if let resource = resources.first {
                sizeOnDisk = resource.value(forKey: "fileSize") as? Double ?? 0.0
                selectedData += (sizeOnDisk / UnitOfBytes )
                /// Check the storage space before uploading
                if selectedData > totalSpace{
                    print("Disk is Full....")
                    selectedData -= (sizeOnDisk / UnitOfBytes)
                    DispatchQueue.main.async {
                        self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CStoregFullMessage, btnOneTitle: CBtnOk , btnOneTapped: nil)
                    }
                    continue
                }
            }
            
            dispatchGroup.enter()
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
                        self?.arrMedia.append(media)
                        GCDMainThread.async {
                            self?.tblAddedFolders.reloadData()
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
                        self?.arrMedia.append(media)
                        GCDMainThread.async {
                            self?.tblAddedFolders.reloadData()
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
                        self?.arrMedia.append(media)
                        GCDMainThread.async {
                            self?.tblAddedFolders.reloadData()
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
        }
        
        let resources = PHAssetResource.assetResources(for: phAsset)
        if let resource = resources.first{
            let fileName = resource.originalFilename
            if checkSameFileExistInThisFolder(fileName: fileName){
                DispatchQueue.main.async {
                    self.photosPickerViewController.presentAlertViewWithOneButton(alertTitle: nil, alertMessage: CFileIsAlreadyExistsInThisFolder, btnOneTitle: CBtnOk , btnOneTapped: nil)
                }
               return false
            }
            let strExtension = fileName.components(separatedBy: ".").last ?? ""
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
