//
//  showCameraViewController.swift
//  Sevenchats
//
//  Created by APPLE on 16/03/21.
//  Copyright © 2021 mac-00020. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import TLPhotoPicker
import AssetsLibrary

class showCameraViewController:SwiftyCamViewController, SwiftyCamViewControllerDelegate, TLPhotosPickerViewControllerDelegate, TLPhotosPickerLogDelegate {
 
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
    
    @IBOutlet weak var captureButton    : SwiftyRecordButton!
    @IBOutlet weak var flipCameraButton : UIButton!
    @IBOutlet weak var flashButton      : UIButton!
    @IBOutlet weak var BtnGallery      : UIButton!
    var images:[UIImage] = []
    var arrMedia : [MDLAddMedia] = []
    
    let imagePicker = UIImagePickerController()
    
    var photosPickerVC = TLPhotosPickerViewController()
  
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shouldPrompToAppSettings = true
        cameraDelegate = self
        maximumVideoDuration = 10.0
        shouldUseDeviceOrientation = false
        allowAutoRotate = true
        audioEnabled = true
        
        
        // disable capture button until session starts
        captureButton.buttonEnabled = false
        fetchPhotos()
        
        BtnGallery.setImage(images.first, for: .normal)
        BtnGallery.layer.cornerRadius = 8
        BtnGallery.layer.borderWidth = 1
        BtnGallery.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
        BtnGallery.backgroundColor = .clear
        
        BtnGallery.addTarget(self, action:#selector(self.showImgCLK), for: .touchUpInside)
        
    }
    
   
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captureButton.delegate = self
    }
    
    func swiftyCamSessionDidStartRunning(_ swiftyCam: SwiftyCamViewController) {
        print("Session did start running")
        captureButton.buttonEnabled = true
    }
    
    func swiftyCamSessionDidStopRunning(_ swiftyCam: SwiftyCamViewController) {
        print("Session did stop running")
        captureButton.buttonEnabled = false
    }
    
    
    //MARK: - Memory management methods
    deinit {
        print("### deinit -> AddMediaViewController")
    }

    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
        
//                let newVC = PhotoViewController(image: photo)
//                self.present(newVC, animated: true, completion: nil)
        
        let storyboard = UIStoryboard(name: "PhotoEditor", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PhotoEditorViewController") as! PhotoEditorViewController
        vc.photo = photo
        vc.checkVideoOrIamge = true

        for i in 100...110 {
            vc.stickers.append(UIImage(named: i.description )!)
        }
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false, completion: nil)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didBeginRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        print("Did Begin Recording")
        captureButton.growButton()
        hideButtons()
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        print("Did finish Recording")
        captureButton.shrinkButton()
        showButtons()
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishProcessVideoAt url: URL) {
        let storyboard = UIStoryboard(name: "PhotoEditor", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PhotoEditorViewController") as! PhotoEditorViewController
        vc.videoURL = url
        vc.checkVideoOrIamge = false

        for i in 100...110 {
            vc.stickers.append(UIImage(named: i.description )!)
        }
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false, completion: nil)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFocusAtPoint point: CGPoint) {
        print("Did focus at point: \(point)")
        focusAnimationAt(point)
    }
    
    func swiftyCamDidFailToConfigure(_ swiftyCam: SwiftyCamViewController) {
        let message = NSLocalizedString("Unable to capture media", comment: "Alert message when something goes wrong during capture session configuration")
        let alertController = UIAlertController(title: "AVCam", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"), style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didChangeZoomLevel zoom: CGFloat) {
        print("Zoom level did change. Level: \(zoom)")
        print(zoom)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didSwitchCameras camera: SwiftyCamViewController.CameraSelection) {
        print("Camera did change to \(camera.rawValue)")
        print(camera)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFailToRecordVideo error: Error) {
        print(error)
    }
    
    @IBAction func cameraSwitchTapped(_ sender: Any) {
        switchCamera()
    }
    
    @IBAction func toggleFlashTapped(_ sender: Any) {
        flashEnabled = !flashEnabled
        toggleFlashAnimation()
    }
    
}
extension showCameraViewController{
    //Mark showbutton With Action

    @IBAction func btncloseCLK(_ sender : UIButton){
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        
    }
}

extension showCameraViewController {
  
    fileprivate func hideButtons() {
        UIView.animate(withDuration: 0.25) {
            self.flashButton.alpha = 0.0
            self.flipCameraButton.alpha = 0.0
        }
    }
    fileprivate func showButtons() {
        UIView.animate(withDuration: 0.25) {
            self.flashButton.alpha = 1.0
            self.flipCameraButton.alpha = 1.0
        }
    }
 
    fileprivate func focusAnimationAt(_ point: CGPoint) {
        let focusView = UIImageView(image: #imageLiteral(resourceName: "focus"))
        focusView.center = point
        focusView.alpha = 0.0
        view.addSubview(focusView)
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
            focusView.alpha = 1.0
            focusView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        }) { (success) in
            UIView.animate(withDuration: 0.15, delay: 0.5, options: .curveEaseInOut, animations: {
                focusView.alpha = 0.0
                focusView.transform = CGAffineTransform(translationX: 0.6, y: 0.6)
            }) { (success) in
                focusView.removeFromSuperview()
            }
        }
    }
    
    fileprivate func toggleFlashAnimation() {
        if flashEnabled == true {
            flashButton.setImage(#imageLiteral(resourceName: "flash"), for: UIControl.State())
            flashButton.tintColor = #colorLiteral(red: 0, green: 0.7529411912, blue: 0.650980413, alpha: 1)
        } else {
            flashButton.setImage(#imageLiteral(resourceName: "flashOutline"), for: UIControl.State())
            
        }
    }
}

//MARK :- Pick last image
extension showCameraViewController{
    func fetchPhotos () {
          // Sort the images by descending creation date and fetch the first 3
          let fetchOptions = PHFetchOptions()
          fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
          fetchOptions.fetchLimit = 1

          // Fetch the image assets
          let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)

          // If the fetch result isn't empty,
          // proceed with the image request
          if fetchResult.count > 0 {
              let totalImageCountNeeded = 1 // <-- The number of images to fetch
              fetchPhotoAtIndex(0, totalImageCountNeeded, fetchResult)
          }
      }
    
    func fetchPhotoAtIndex(_ index:Int, _ totalImageCountNeeded: Int, _ fetchResult: PHFetchResult<PHAsset>) {

           // Note that if the request is not set to synchronous
           // the requestImageForAsset will return both the image
           // and thumbnail; by setting synchronous to true it
           // will return just the thumbnail
           let requestOptions = PHImageRequestOptions()
           requestOptions.isSynchronous = true

           // Perform the image request
           PHImageManager.default().requestImage(for: fetchResult.object(at: index) as PHAsset, targetSize: view.frame.size, contentMode: PHImageContentMode.aspectFill, options: requestOptions, resultHandler: { (image, _) in
               if let image = image {
                   // Add the returned image to your array
                   self.images += [image]
               }
               // If you haven't already reached the first
               // index of the fetch result and if you haven't
               // already stored all of the images you need,
               // perform the fetch request again with an
               // incremented index
               if index + 1 < fetchResult.count && self.images.count < totalImageCountNeeded {
                   self.fetchPhotoAtIndex(index + 1, totalImageCountNeeded, fetchResult)
               } else {
                   // Else you have completed creating your array
                print("Completed array: \(self.images)")
                  
               }
           })
       }
   }
    


//MARK :- ShowImage images
extension showCameraViewController{
    
    @objc func showImgCLK(sender : UIButton) {
        print("Button Clicked")
        
//        let storyboard = UIStoryboard(name: "PhotoEditor", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "PhotoEditorViewController") as! PhotoEditorViewController
//        vc.photo = images.first
//        vc.checkVideoOrIamge = true
//
//        for i in 100...110 {
//            vc.stickers.append(UIImage(named: i.description )!)
//        }
//        vc.modalPresentationStyle = .fullScreen
//        present(vc, animated: false, completion: nil)
        
        self.pickerButtonTap()
        
    }
    
}

extension showCameraViewController
{
    func pickerButtonTap() {
        self.photosPickerVC.delegate = self
        var configure = TLPhotosPickerConfigure()
        configure.usedCameraButton = false
        configure.numberOfColumn = 3
        let count = self.arrMedia.filter({!$0.isFromGallery}).count
        configure.maxSelectedAssets = (5 - count)
        self.photosPickerVC.configure = configure
        self.photosPickerVC.selectedAssets = self.arrMedia.filter({$0.isFromGallery}).map({$0.asset!})
        self.photosPickerVC.logDelegate = self
        if #available(iOS 13.0, *){
            self.photosPickerVC.isModalInPresentation = true
            self.photosPickerVC.modalPresentationStyle = .fullScreen
        }
        self.present(self.photosPickerVC, animated: true, completion: nil)
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
        options.progressHandler = { [weak self] (progress, error, stop, info) in
            guard let _ = self else { return }
            print(progress)
            print(info ?? ["Info":"Empty"])
            if (error != nil) {
                print(error?.localizedDescription ?? "")
            }
        }
        asset.exportVideoFile(options: options, progressBlock: { [weak self] (progress) in
            guard let _ = self else { return }
            print(progress)
        }) { [weak self] (url, mimeType) in
            guard let _ = self else { return }
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
            guard let _ = self else { return }
            //guard let _ = self else {return}
            DispatchQueue.main.async {
                print(progress)
            }
        }, completionBlock: { [weak self] (image) in
            guard let _ = self else { return }
            //guard let _ = self else {return}
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
