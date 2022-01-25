//
//  GalleryListViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 23/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : GalleryListViewController                   *
 * Changes :                                             *
 *                                                       *
 ********************************************************/

import UIKit
import PhotosUI

class GalleryListViewController: ParentViewController {
    
    @IBOutlet var clGallery : UICollectionView!
    var isFromChatScreen : Bool!
    var arrGalleryImages = PHFetchResult<PHAsset>()
    var arrSelectedImages = [UIImage]()
    var arrSelectedImageIndexPath = [IndexPath]()
    var isAddMoreImage : Bool = false
    var isAllreadySelectedImageCount : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Initialization()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    deinit {
        print("#### deinit -> GalleryListViewController")
    }
    // MARK: - ---------- Initialization
    
    func Initialization(){
        self.title = CNavSelectImage
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: CBtnNextArrow, style: .plain, target: self, action: #selector(btnNextClicked(_:)))
        self.fetchImagesFromGallery()
    }
    
}

// MARK:- --------- Gallery Images
extension GalleryListViewController{
    func fetchImagesFromGallery(){
        self.phAssetController(.image) { [weak self] (result) in
            guard let self = self else { return }
            if result != nil{
                self.arrGalleryImages = result!
                GCDMainThread.async {
                    self.clGallery.reloadData()
                }
            }
        }
    }
}

// MARK:- --------- UICollectionView Delegate/Datasources
extension GalleryListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrGalleryImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = (CScreenWidth - 20)/2
        return CGSize(width:cellSize, height: cellSize)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryListCollCell", for: indexPath) as! GalleryListCollCell
        
        let asset = arrGalleryImages[indexPath.item]
        cell.lblImageNumber.text = "\(indexPath.row + 1)"
        cell.imgGallery.backgroundColor = UIColor.white
        
        PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width : cell.frame.size.width, height : cell.frame.size.height), contentMode: .default, options: nil, resultHandler: { (image, info) in
            cell.imgGallery.image = image
        })
        
        if self.arrSelectedImageIndexPath.contains(indexPath){
            cell.imgGallery.alpha = 0.5
            cell.imgSelected.isHidden = false
        }else {
            cell.imgGallery.alpha = self.arrSelectedImageIndexPath.contains(indexPath) ? 0.5 : 1.0
            cell.imgSelected.isHidden = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if arrSelectedImageIndexPath.contains(indexPath){
            if let index = arrSelectedImageIndexPath.firstIndex(where: {$0 == indexPath}){
                arrSelectedImageIndexPath.remove(at: index)
                arrSelectedImages.remove(at: index)
                clGallery.reloadData()
            }
        }else{
            if (arrSelectedImages.count + isAllreadySelectedImageCount) >= 5 {
                self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageMaximumImage, btnOneTitle: CBtnOk, btnOneTapped: nil)
            } else {
                let requestOptions = PHImageRequestOptions()
                requestOptions.isNetworkAccessAllowed = true
                requestOptions.progressHandler = {[weak self](progress, error, stop, info) in
                    guard let _ = self else { return }
                    print(progress)
                }
                let asset = self.arrGalleryImages[indexPath.item]
                PHImageManager.default().requestImageData(for: asset, options: requestOptions)
                { [weak self] (data, uti, orientation, info) in
                    guard let self = self else { return }
                    do {
                        if let imgData = data, let rawImage = UIImage(data: imgData)?.upOrientationImage() {
                            self.arrSelectedImageIndexPath.append(indexPath)
                            self.arrSelectedImages.append(rawImage)
                            self.clGallery.reloadData()
                        }
                    }
                }
            }
        }
    }
}


// MARK:- ----------- Action Event
extension GalleryListViewController{
    @objc fileprivate func btnNextClicked(_ sender : UIBarButtonItem) {
        
        if arrSelectedImages.count < 1 {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageSelectImage, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }else{
            if isAddMoreImage{
                if let blockHandler = self.block {
                    blockHandler(arrSelectedImages, "refresh screen")
                }
                self.navigationController?.popViewController(animated: true)
            }else{
                if let galleryViewVC = CStoryboardImage.instantiateViewController(withIdentifier: "GalleryPreviewViewController") as? GalleryPreviewViewController {
                    galleryViewVC.imagePostType = .addImagePost
                    galleryViewVC.isFromChatScreen = self.isFromChatScreen
                    galleryViewVC.arrSelectedImages = arrSelectedImages
                    self.navigationController?.pushViewController(galleryViewVC, animated: true)
                }
            }
            
        }
    }
}

extension UIImage {
    func upOrientationImage() -> UIImage? {
        switch imageOrientation {
        case .up:
            return self
        default:
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            draw(in: CGRect(origin: .zero, size: size))
            let result = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return result
        }
    }
}
