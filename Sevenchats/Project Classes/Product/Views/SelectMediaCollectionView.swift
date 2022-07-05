//
//  SelectMediaCollectionView.swift
//  Sevenchats
//
//  Created by mac-00020 on 26/08/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//
/********************************************************
 * Author : Chandrika R                                  *
 * Model  : product & Minio                              *
 * option :Add product Images with Minio                 *
 ********************************************************/

import UIKit
import TLPhotoPicker
import Photos
import AssetsLibrary

class SelectMediaCollectionView: UICollectionView {
    
    //MARK: - IBOutlet/Object/Variable Declaration
    //@IBOutlet weak var vw: UIView!
    
    var arrMedia : [MDLAddMedia] = []
    let maxVideoFileSizeInMB : Int = 50
    let totalMediaUploadLimit = 5
    let interItemsSpacing: CGFloat = 10
    var arrVideo = [String]()
    var arrImages = [String]()
    var arrImagesVideo = [String]()
    var imgName = ""
    var imageString = ""
    var content = [String:Any]()
    var isSeletected = true
    let imagePicker = UIImagePickerController()
    var photosPickerViewController = TLPhotosPickerViewController()
    var arrDeletedApiImages : [String] = []
    var isConfirmAlertOnDelete = false
    
    
    
    override var contentSize:CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.delegate = self
        self.dataSource =  self
        imagePicker.delegate = self
        photosPickerViewController.delegate = self
        self.register(UINib(nibName: "AddMediaCollCell", bundle: nil), forCellWithReuseIdentifier: "AddMediaCollCell")
        self.register(UINib(nibName: "SelectMediaCollCell", bundle: nil), forCellWithReuseIdentifier: "SelectMediaCollCell")
        self.contentInset = UIEdgeInsets(top: interItemsSpacing, left: interItemsSpacing, bottom: interItemsSpacing, right: interItemsSpacing)
        self.isPagingEnabled    = false
    }
    
}


//MARK:- Collection View Delegate and Data Source Methods
extension SelectMediaCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if arrMedia.count < totalMediaUploadLimit{
            return arrMedia.count + 1
        }
        return arrMedia.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if arrMedia.count > indexPath.row{
            
            let media = arrMedia[indexPath.row]
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddMediaCollCell", for: indexPath) as? AddMediaCollCell else {
                return UICollectionViewCell(frame: .zero)
            }
            
            cell.media = media
            
            if isSeletected == true{
                let imgExt = media.serverImgURL ?? "".fileExtension()
                if imgExt == "mp4" ||  imgExt == "mov" ||  imgExt == "MOV"{
                    self.content = [
                        "mime": "video",
                        "media": "http://localhost:3000/589fd493-401f-4c7c-867c-1938e16d7b68",
                        "image_path":media.serverImgURL ?? ""
                    ]
                }else {
                    self.content = [
                        "mime": "image",
                        "media": "http://localhost:3000/589fd493-401f-4c7c-867c-1938e16d7b68",
                        "image_path":media.serverImgURL ?? ""
                    ]
                    
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: self.content as Any, options: .prettyPrinted)
                        let jsonString = String(data: jsonData, encoding: String.Encoding.ascii)
                        let trimmedString = jsonString?.components(separatedBy: .whitespacesAndNewlines).joined()
                        let replaced1 = trimmedString?.replacingOccurrences(of: "\\", with: "")
                        self.imageString = replaced1!
                    } catch {
                        print(error.localizedDescription)
                    }
                    self.arrImagesVideo.append(self.imageString)
                }
            }
            print(media)
            cell.btnClose.tag = indexPath.row
            cell.btnClose.touchUpInside { [weak self] (sender) in
                guard let _ = self else {return}
                if self?.isConfirmAlertOnDelete ?? true{
                    self?.viewController?.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CAreYouSureToDeleteThisMedia, btnOneTitle: CBtnYes, btnOneTapped: { [weak self](alert) in
                        guard let _ = self else {return}
                        self?.arrImagesVideo.removeAll()
                        let obj = self?.arrMedia[sender.tag]
                        if let mediaId = obj?.mediaID{
                            self?.arrDeletedApiImages.append(mediaId)
                        }
                        self?.arrMedia.remove(at: sender.tag)
                        for mediafile in self?.arrMedia ?? [] {
                            
                            let imgExt = mediafile.serverImgURL ?? "".fileExtension()
                            
                            if imgExt == "mp4" ||  imgExt == "mov" ||  imgExt == "MOV"{
                                self?.content = [
                                    "mime": "video",
                                    "media": "http://localhost:3000/589fd493-401f-4c7c-867c-1938e16d7b68",
                                    "image_path":mediafile.serverImgURL ?? ""
                                ]
                            }else {
                                self?.content = [
                                    "mime": "image",
                                    "media": "http://localhost:3000/589fd493-401f-4c7c-867c-1938e16d7b68",
                                    "image_path":mediafile.serverImgURL ?? ""
                                ]
                                
                                do {
                                    let jsonData = try JSONSerialization.data(withJSONObject: self?.content as Any, options: .prettyPrinted)
                                    let jsonString = String(data: jsonData, encoding: String.Encoding.ascii)
                                    let trimmedString = jsonString?.components(separatedBy: .whitespacesAndNewlines).joined()
                                    let replaced1 = trimmedString?.replacingOccurrences(of: "\\", with: "")
                                    //                                        print("replace1\(replaced1)")
                                    self?.imageString = replaced1!
                                } catch {
                                    print(error.localizedDescription)
                                }
                            }
                            self?.arrImagesVideo.append(self?.imageString ?? "")
                            
                        }
                        self?.isSeletected = false
                        self?.reloadData()
                        
                    }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
                }else{
                    let obj = self?.arrMedia[sender.tag]
                    if let mediaId = obj?.mediaID{
                        self?.arrDeletedApiImages.append(mediaId)
                    }
                    self?.arrImagesVideo.remove(at: sender.tag)
                    self?.arrMedia.remove(at: sender.tag)
                    self?.isSeletected = false
                    self?.reloadData()
                }
            }
            return cell
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectMediaCollCell", for: indexPath) as? SelectMediaCollCell else {
            return UICollectionViewCell(frame: .zero)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard arrMedia.count <= indexPath.row else { return } /// If it's last itmes in collectionview
        /// User can upload product images and video by tapping on `+` button.
        self.viewController?.presentActionsheetWithTwoButtons(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CRegisterChooseFromPhone, btnOneStyle: .default, btnOneTapped: { [weak self] (alert) in
            guard let _ = self else {return}
            self?.pickerButtonTap()
            
        }, btnTwoTitle: CRegisterTakePhoto, btnTwoStyle: .default) { [weak self](alert) in
            guard let `self` = self else {return}
            if self.arrMedia.count < self.totalMediaUploadLimit {
                self.openImagePickerViewController()
            }
        }
    }
}

//MARK:- UICollectionViewDelegateFlowLayout
extension SelectMediaCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalColumns = 3
        let contentWidthWithoutIndents = collectionView.bounds.width - collectionView.contentInset.left - collectionView.contentInset.right
        let itemWidth = (contentWidthWithoutIndents - (CGFloat(totalColumns) - 1) * 1) / CGFloat(totalColumns)
        
        ///let height = itemWidth - ((itemWidth * 40) / 100)
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets.zero
    }
}

//MARK: - UIImagePickerControllerDelegate
extension SelectMediaCollectionView : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func openImagePickerViewController(){
        
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .denied {
            let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!
            let alert = UIAlertController(
                title: nil,
                message: CDeniedCameraPermission,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: CBtnCancel, style: .destructive, handler: nil))
            alert.addAction(UIAlertAction(title: CNavSettings, style: .default, handler: { (alert) -> Void in
                UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
            }))
            self.viewController?.present(alert, animated: true, completion: nil)
        }
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("This device doesn't have a camera.")
            return
        }
        imagePicker.sourceType = .camera
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for:.camera)!
        if #available(iOS 13.0, *){
            imagePicker.isModalInPresentation = true
            imagePicker.modalPresentationStyle = .fullScreen
        }
        self.viewController?.present(imagePicker, animated: true)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String ?? ""
        if mediaType == "public.image"{
            var image:UIImage?
            //            var selectedImage: UIImage!
            var _: URL!
            if self.imagePicker.allowsEditing {
                image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
            } else {
                image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            }
            
            if image != nil{
                let media = MDLAddMedia(image: image, url:nil)
                media.isFromGallery = false
                media.assetType = .Image
                if (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) != nil {
                    let imgName = UUID().uuidString
                    
                    var sharedImg = [String]()
                    sharedImg.removeAll()
                    let documentDirectory = NSTemporaryDirectory()
                    let localPath = documentDirectory.appending(imgName)
                    sharedImg.append(localPath)
                    
                    let modileNum = appDelegate.loginUser?.mobile
                    
                    MInioimageupload.shared().uploadMinioimages(mobileNo: modileNum ?? "", ImageSTt: image!,isFrom:"",uploadFrom:"")
                    
                    MInioimageupload.shared().callback = { [self] imgUrls in
                        print("UploadImage::::::::::::::\(imgUrls)")
                        self.imgName = imgUrls
                        let content:[String:Any]  = [
                            "mime": "image",
                            "media": "http://localhost:3000/589fd493-401f-4c7c-867c-1938e16d7b68",
                            "image_path":imgUrls
                        ]
                        
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: content, options: .prettyPrinted)
                            let jsonString = String(data: jsonData, encoding: String.Encoding.ascii)
                            let trimmedString = jsonString?.components(separatedBy: .whitespacesAndNewlines).joined()
                            let replaced1 = trimmedString?.replacingOccurrences(of: "\\", with: "")
                            //                                        print("replace1\(replaced1)")
                            self.imageString = replaced1!
                        } catch {
                            print(error.localizedDescription)
                        }
                        self.arrImagesVideo.append(self.imageString)
                        print("*****************\(self.arrImagesVideo)")
                        if self.arrImagesVideo.count == self.arrImagesVideo.count{
                            print("Success")
                            DispatchQueue.main.async {
                                MILoader.shared.hideLoader()
                            }
                        }else{
                            print("Failed")
                            DispatchQueue.main.async {
                                MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: CMessagePleaseWait)
                            }
                        }
                    }
                }
                
                media.isDownloadedFromiCloud = true
                self.arrMedia.append(media)
                self.isSeletected = false
                self.reloadData()
            }
        }else{
            if #available(iOS 11.0, *) {
                if let asset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset {
                    PHImageManager.default().requestAVAsset(forVideo: asset, options: nil, resultHandler: { (avAsset, audioMix, info) in
                        if let urlasset = avAsset as? AVURLAsset {
                            self.createThumbnailOfVideoFromRemoteUrl(url: urlasset.url)
                        }
                    })
                }else{
                    let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL
                    if videoURL != nil {
                        let asset = AVURLAsset(url: videoURL!, options: nil)
                        
                        let modileNum = appDelegate.loginUser?.mobile
                        let sampleImage = UIImage()
                        
                        MInioimageupload.shared().uploadMinioimages(mobileNo: modileNum ?? "", ImageSTt:sampleImage ,isFrom:"videos",uploadFrom:videoURL?.toString ?? "")
                        
                        MInioimageupload.shared().callback = { [self] imgUrls in
                            print("UploadImage::::::::::::::\(imgUrls)")
                            self.imgName = imgUrls
                            let content:[String:Any]  = [
                                "mime": "video",
                                "media": "http://localhost:3000/589fd493-401f-4c7c-867c-1938e16d7b68",
                                "image_path":imgUrls
                            ]
                            
                            do {
                                let jsonData = try JSONSerialization.data(withJSONObject: content, options: .prettyPrinted)
                                let jsonString = String(data: jsonData, encoding: String.Encoding.ascii)
                                let trimmedString = jsonString?.components(separatedBy: .whitespacesAndNewlines).joined()
                                let replaced1 = trimmedString?.replacingOccurrences(of: "\\", with: "")
                                self.imageString = replaced1!
                            } catch {
                                print(error.localizedDescription)
                            }
                            self.arrImagesVideo.append(self.imageString)
                            print("*****************\(self.arrImagesVideo)")
                        }
                        
                        
                        self.createThumbnailOfVideoFromRemoteUrl(url: asset.url)
                    }
                }
            } else {
                let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL
                if videoURL != nil {
                    let asset = AVURLAsset(url: videoURL!, options: nil)
                    self.createThumbnailOfVideoFromRemoteUrl(url: asset.url)
                }
            }
        }
        picker.dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func createThumbnailOfVideoFromRemoteUrl(url: URL) {
        let asset = AVAsset(url: url)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        let time = CMTimeMakeWithSeconds(1.0, preferredTimescale: 500)
        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: img)
            let media = MDLAddMedia(image: thumbnail, url:url.absoluteString)
            media.isFromGallery = false
            media.assetType = .Video
            media.isDownloadedFromiCloud = true
            self.arrMedia.append(media)
            self.isSeletected = false
            self.reloadData()
        } catch {
            print(error.localizedDescription)
        }
    }
}

//MARK: - TLPhotosPickerViewController
extension SelectMediaCollectionView {
    
    func pickerButtonTap() {
        
        photosPickerViewController = TLPhotosPickerViewController()
        photosPickerViewController.delegate = self
        var configure = TLPhotosPickerConfigure()
        configure.usedCameraButton = false
        configure.numberOfColumn = 3
        let count = self.arrMedia.filter({!$0.isFromGallery}).count
        configure.maxSelectedAssets = (5 - count)
        photosPickerViewController.configure = configure
        photosPickerViewController.selectedAssets = self.arrMedia.filter({$0.isFromGallery}).compactMap({$0.asset!})
        photosPickerViewController.logDelegate = self
        
        self.viewController?.present(photosPickerViewController, animated: true, completion: nil)
    }
    
    func converVideoByteToHumanReadable(_ bytes:Int64) -> String {
        let formatter:ByteCountFormatter = ByteCountFormatter()
        formatter.countStyle = .binary
        return formatter.string(fromByteCount: Int64(bytes))
    }
    
    func exportVideo(asset:TLPHAsset ,onComplete:((_ thembnil:UIImage,_ videoURL:URL)->Void)?) {
        var vThum : UIImage!
        var vUrl : URL!
        if let thum = asset.fullResolutionImage{
            print(thum)
            vThum = thum
            if let videoURL = vUrl, let videoThum = vThum{
                onComplete?(videoThum,videoURL)
            }
        }
        //asset.phAsset
        let options = PHVideoRequestOptions()
        options.isNetworkAccessAllowed = true
        options.deliveryMode = .automatic
        //iCloud download progress
        options.progressHandler = { [weak self](progress, error, stop, info) in
            guard let _ = self else {return}
            print(progress)
            print(info ?? ["Info":"Empty"])
            if (error != nil) {
                print(error?.localizedDescription ?? "")
            }
        }
        asset.exportVideoFile(options: options, progressBlock: {[weak self] (progress) in
            guard let _ = self else {return}
            print(progress)
        }) { [weak self](url, mimeType) in
            guard let _ = self else {return}
            print("exportVideoFile : \(url)")
            print(mimeType)
            vUrl = url
            if let videoURL = vUrl, let videoThum = vThum{
                onComplete?(videoThum,videoURL)
            }
        }
    }
    
    func getSelectedImage(asset:TLPHAsset, onComplete:((_ thembnil:UIImage)->Void)?) {
        
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
                    print("Image Path : \(asset.originalFileName ?? "")")
                    print("complete download")
                    onComplete?(_image)
                }
            }
        })
    }
    
    func getAssetsFromFileName(fileName:String) -> MDLAddMedia?{
        return self.arrMedia.filter({$0.fileName == fileName}).first
    }
}

//MARK: - TLPhotosPickerViewControllerDelegate ,TLPhotosPickerLogDelegate
extension SelectMediaCollectionView : TLPhotosPickerViewControllerDelegate,TLPhotosPickerLogDelegate {
    
    func shouldDismissPhotoPicker(withTLPHAssets: [TLPHAsset]) -> Bool {
        self.arrMedia = self.arrMedia.filter({!$0.isFromGallery})
        let dispatchGroup = DispatchGroup()
        for asset in withTLPHAssets{
            dispatchGroup.enter()
            print("File Name :  \(asset.originalFileName ?? "File not found")")
            switch asset.type{
            case .video:
                let videoMedia = MDLAddMedia()
                var content = [String:Any]()
                videoMedia.isFromGallery = false
                videoMedia.fileName = asset.originalFileName
                videoMedia.assetType = .Video
                DispatchQueue.main.async {
                    MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: CMessagePleaseWait)
                }
                asset.tempCopyMediaFile { [weak self] (url, min) in
                    guard let _ = self else {return}
                    self?.arrImages.append(url.absoluteString)
                    videoMedia.url = url.absoluteString
                    let urlVidoes = UIImage()
                    self?.imgName = url.absoluteString
                    let modileNum = appDelegate.loginUser?.mobile
                    MInioimageupload.shared().uploadMinioimages(mobileNo: modileNum ?? "", ImageSTt: urlVidoes ,isFrom:"videos",uploadFrom:self?.imgName ?? "")
                    
                    MInioimageupload.shared().callback = { [self] imgUrls in
                        print("UploadImage::::::::::::::\(imgUrls)")
                        self?.imgName = imgUrls
                        
                        let imgExt = imgUrls.fileExtension()
                        print("imgExt\(imgExt)")
                        if imgExt == "mp4" ||  imgExt == "mov" ||  imgExt == "MOV"{
                            content = [
                                "mime": "video",
                                "media": "http://localhost:3000/589fd493-401f-4c7c-867c-1938e16d7b68",
                                "image_path":imgUrls
                            ]
                        }else {
                            content = [
                                "mime": "image",
                                "media": "http://localhost:3000/589fd493-401f-4c7c-867c-1938e16d7b68",
                                "image_path":imgUrls
                            ]
                        }
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: content, options: .prettyPrinted)
                            let jsonString = String(data: jsonData, encoding: String.Encoding.ascii)
                            let trimmedString = jsonString?.components(separatedBy: .whitespacesAndNewlines).joined()
                            let replaced1 = trimmedString?.replacingOccurrences(of: "\\", with: "")
                            self?.imageString = replaced1!
                        } catch {
                            print(error.localizedDescription)
                        }
                        self?.arrImagesVideo.append(self!.imageString)
                        print("*****************\(self!.arrImagesVideo)")
                        if self?.arrImages.count == self?.arrImagesVideo.count || self?.arrMedia.count == self?.arrImagesVideo.count {
                            print("Success")
                            DispatchQueue.main.async {
                                MILoader.shared.hideLoader()
                            }
                        }else{
                            print("Failed")
                        }
                    }
                }
                videoMedia.asset = asset
                self.arrMedia.append(videoMedia)
                self.isSeletected = false
                self.reloadData()
                exportVideo(asset: asset) { [weak self] (thum,url)in
                    guard let _ = self else {return}
                    if let media = self?.getAssetsFromFileName(fileName: asset.originalFileName ?? ""){
                        media.image = thum
                        media.url = url.absoluteString
                        media.fileName = asset.originalFileName
                        media.isDownloadedFromiCloud = true
                        GCDMainThread.async {
                            self?.isSeletected = false
                            self?.reloadData()
                        }
                    }
                    dispatchGroup.leave()
                }
                break
            case .livePhoto:
                
                let imageMedia = MDLAddMedia()
                imageMedia.isFromGallery = false
                imageMedia.fileName = asset.originalFileName
                imageMedia.assetType = .Image
                DispatchQueue.main.async {
                    MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: CMessagePleaseWait)
                }
                asset.tempCopyMediaFile { [weak self] (url, min) in
                    guard let _ = self else {return}
                    self?.arrImages.append(url.absoluteString)
                    imageMedia.url = url.absoluteString
                    let urlVidoes = UIImage()
                    self?.imgName = url.absoluteString
                    let modileNum = appDelegate.loginUser?.mobile
                    MInioimageupload.shared().uploadMinioimages(mobileNo: modileNum ?? "", ImageSTt: urlVidoes ,isFrom:"videos",uploadFrom:self?.imgName ?? "")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                        MInioimageupload.shared().callback = { [self] imgUrls in
                            print("UploadImage::::::::::::::\(imgUrls)")
                            self?.imgName = imgUrls
                            let content:[String:Any]  = [
                                "mime": "video",
                                "media": "http://localhost:3000/589fd493-401f-4c7c-867c-1938e16d7b68",
                                "image_path":imgUrls
                            ]
                            
                            do {
                                let jsonData = try JSONSerialization.data(withJSONObject: content, options: .prettyPrinted)
                                let jsonString = String(data: jsonData, encoding: String.Encoding.ascii)
                                let trimmedString = jsonString?.components(separatedBy: .whitespacesAndNewlines).joined()
                                let replaced1 = trimmedString?.replacingOccurrences(of: "\\", with: "")
                                self?.imageString = replaced1!
                            } catch {
                                print(error.localizedDescription)
                            }
                            self?.arrImagesVideo.append(self!.imageString)
                            print("*****************\(self!.arrImagesVideo)")
                            if self?.arrImages.count == self?.arrImagesVideo.count || self?.arrMedia.count == self?.arrImagesVideo.count{
                                print("Success")
                                DispatchQueue.main.async {
                                    MILoader.shared.hideLoader()
                                }
                            }else{
                                print("Failed")
                                DispatchQueue.main.async {
                                    MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: CMessagePleaseWait)
                                }
                            }
                        }
                    }
                }
                
                imageMedia.asset = asset
                self.arrMedia.append(imageMedia)
                getSelectedImage(asset: asset) { [weak self] (image) in
                    guard let _ = self else {return}
                    if let media = self?.getAssetsFromFileName(fileName: asset.originalFileName ?? ""){
                        media.image = image
                        media.fileName = asset.originalFileName
                        media.isDownloadedFromiCloud = true
                        GCDMainThread.async {
                            self?.isSeletected = false
                            self?.reloadData()
                        }
                    }
                    dispatchGroup.leave()
                }
                break
            case .photo :
                let imageMedia = MDLAddMedia()
                var content = [String:Any]()
                imageMedia.fileName = asset.originalFileName
                imageMedia.isFromGallery = false
                imageMedia.assetType = .Image
                DispatchQueue.main.async {
                    MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: CMessagePleaseWait)
                }
                asset.tempCopyMediaFile { [weak self] (url, min) in
                    guard let _ = self else {return}
                    self?.arrImages.append(url.absoluteString)
                    imageMedia.url = url.absoluteString
                    
                    self?.imgName = url.absoluteString
                    self?.imgName.stringToImage {(image) in
                        guard let mobileNum = appDelegate.loginUser?.mobile else {
                            return
                        }
                        MInioimageupload.shared().uploadMinioimages(mobileNo: mobileNum, ImageSTt: image!,isFrom:"",uploadFrom:"")
                        MInioimageupload.shared().callback = { [self] imgUrls in
                            print("UploadImage::::::::::::::\(imgUrls)")
                            self?.imgName = imgUrls
                            let imgExt = imgUrls.fileExtension()
                            print("imgExt\(imgExt)")
                            if imgExt == "mp4" ||  imgExt == "mov" ||  imgExt == "MOV"{
                                content = [
                                    "mime": "video",
                                    "media": "http://localhost:3000/589fd493-401f-4c7c-867c-1938e16d7b68",
                                    "image_path":imgUrls
                                ]
                            }else {
                                content = [
                                    "mime": "image",
                                    "media": "http://localhost:3000/589fd493-401f-4c7c-867c-1938e16d7b68",
                                    "image_path":imgUrls
                                ]
                            }
                            
                            do {
                                let jsonData = try JSONSerialization.data(withJSONObject: content, options: .prettyPrinted)
                                let jsonString = String(data: jsonData, encoding: String.Encoding.ascii)
                                let trimmedString = jsonString?.components(separatedBy: .whitespacesAndNewlines).joined()
                                let replaced1 = trimmedString?.replacingOccurrences(of: "\\", with: "")
                                self?.imageString = replaced1!
                            } catch {
                                print(error.localizedDescription)
                            }
                            self?.arrImagesVideo.append(self!.imageString)
                            print("*****************\(self!.arrImagesVideo)")
                            if self?.arrImages.count == self?.arrImagesVideo.count || self?.arrMedia.count == self?.arrImagesVideo.count{
                                print("Success")
                                DispatchQueue.main.async {
                                    MILoader.shared.hideLoader()
                                }
                            }else{
                                print("Failed")
                                DispatchQueue.main.async {
                                    MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: CMessagePleaseWait)
                                }
                            }
                        }
                    }
                }
                imageMedia.asset = asset
                self.arrMedia.append(imageMedia)
                getSelectedImage(asset: asset) { [weak self] (image) in
                    guard let _ = self else {return}
                    if let media = self?.getAssetsFromFileName(fileName: asset.originalFileName ?? ""){
                        media.image = image
                        media.isDownloadedFromiCloud = true
                        media.fileName = asset.originalFileName
                        GCDMainThread.async {
                            self?.isSeletected = false
                            self?.reloadData()
                        }
                    }
                    dispatchGroup.leave()
                }
                break
            }
        }
        self.isSeletected = false
        self.reloadData()
        dispatchGroup.notify(queue: .main) {
            print("All Assets downloaded 👍")
        }
        return true
    }
    
    func dismissPhotoPicker(withPHAssets: [PHAsset]) {
    }
    
    func handleNoAlbumPermissions(picker: TLPhotosPickerViewController) {
        DispatchQueue.main.async {
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
                self.viewController?.present(alert, animated: true, completion: nil)
            }
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
            let mb : Int = Int(onDisk / 1000 / 1000)
            print("sizeOnDisk : \(converVideoByteToHumanReadable(sizeOnDisk ?? 0))")
            let tooLarge = mb > maxVideoFileSizeInMB
            if tooLarge {
                self.photosPickerViewController.presentAlertViewWithOneButton(alertTitle: nil, alertMessage: CMaximumStorageOfProductVideoExceeds, btnOneTitle: CBtnOk , btnOneTapped: nil)
                return false
            }
        }
        return true
    }
}

extension SelectMediaCollectionView{
    func asString(jsonDictionary: [String:Any]) -> String {
        do {
            let data = try JSONSerialization.data(withJSONObject: jsonDictionary, options: .prettyPrinted)
            return String(data: data, encoding: String.Encoding.utf8) ?? ""
        } catch {
            return ""
        }
    }
}
