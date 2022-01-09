//
//  ProductMediaCollectionView.swift
//  Sevenchats
//
//  Created by mac-00020 on 29/08/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class ProductMediaCollectionView: UICollectionView {
   
    //MARK: - IBOutlet/Object/Variable Declaration
    //@IBOutlet weak var vw: UIView!
    
    var isProductDetails:Bool?
    
    var arrMedia : [MDLAddMedia] = []{
        didSet{
            DispatchQueue.main.async {
                self.layoutIfNeeded()
                self.reloadData()
            }
        }
    }
    let interItemsSpacing: CGFloat = 0
    var scrollToIndex : ((Int) -> Void)?
    
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
        
        self.register(UINib(nibName: "ProductGalleryImagesCell", bundle: nil), forCellWithReuseIdentifier: "ProductGalleryImagesCell")
        
        self.contentInset = UIEdgeInsets(top: interItemsSpacing, left: interItemsSpacing, bottom: interItemsSpacing, right: interItemsSpacing)
    }
}

//MARK:- Collection View Delegate and Data Source Methods
extension ProductMediaCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if arrMedia.count > 1{
            if arrMedia.count == 5{
                let width = collectionView.bounds.size.width
                return CGSize(width: (width / 2) - 1 , height: collectionView.bounds.height / 2 - 2)
            }else if arrMedia.count == 4 {
                let width = collectionView.bounds.size.width
//                return CGSize(width: 166, height: 78)
                return CGSize(width: (width / 2) - 1 , height: collectionView.bounds.height / 2 - 2)
            } else if arrMedia.count == 3{
                if indexPath.item == 0{
                    return CGSize(width: (collectionView.bounds.size.width / 2) - 1.5 , height: collectionView.bounds.height - 2)
                }
                else {
                    if isProductDetails == true{
                        return CGSize(width: (collectionView.bounds.size.width / 2) - 1.5 , height: collectionView.bounds.height - 2)
                    }else {
                        let width = collectionView.bounds.size.width
                        return CGSize(width: (width / 2) - 1 , height: collectionView.bounds.height / 2 - 2)
                    }
                }
            } else if arrMedia.count == 2 {
                return CGSize(width: (collectionView.bounds.size.width / 2) - 1.5 , height: collectionView.bounds.height - 2)
            }else {
                return CGSize(width:collectionView.bounds.width, height: collectionView.bounds.height - 2)
            }
          }else {
            return CGSize(width:collectionView.bounds.width, height: collectionView.bounds.height - 2)
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrMedia.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        /************************OLD CODE ******************/
        /*guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductGalleryImagesCell", for: indexPath) as? ProductGalleryImagesCell else {
            return UICollectionViewCell(frame: .zero)
        }
        let model = self.arrMedia[indexPath.row]
        cell.blurImgView.loadImageFromUrl(model.serverImgURL, false)
        cell.imgVideoIcon.isHidden = !(model.assetType == .Video)
        self.setCurrentImageCount()
        cell.invalidateIntrinsicContentSize()
        return cell*/
        /***********************NEW CODE *************************/
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductGalleryImagesCell", for: indexPath) as? ProductGalleryImagesCell else {
            return UICollectionViewCell(frame: .zero)
        }
        let model = self.arrMedia[indexPath.row]
        
        if indexPath.row == 3{

            let imgExt = model.serverImgURL?.fileExtension()
            if imgExt == "mp4" ||  imgExt == "mov" ||  imgExt == "MOV"{
                if let urlVideo = URL(string: model.serverImgURL ?? ""){
                    self.getThumbnailImageFromVideoUrl(url: urlVideo) { (thumbNailImage) in
                        cell.blurImgView.image = thumbNailImage
                    }
                }
            }else {
                cell.blurImgView.loadImageFromUrl(model.serverImgURL, false)
            }
           
            cell.imgVideoIcon.isHidden = !(model.assetType == .Video)
            
            self.setCurrentImageCount()
            cell.invalidateIntrinsicContentSize()
//            cell.showLabelCount.isHidden = false
//            cell.showImageBlur.isHidden = false
//            cell.showImageBlur.backgroundColor =  UIColor.red.withAlphaComponent(0.5)
//            cell.showLabelCount.font = cell.showLabelCount.font.withSize(20)
//            cell.showLabelCount.textColor = .white
//            cell.showLabelCount.text = "+4"
            
            
        }else{
            
            let imgExt = model.serverImgURL?.fileExtension()
            if imgExt == "mp4" ||  imgExt == "mov" ||  imgExt == "MOV"{
                if let urlVideo = URL(string: model.serverImgURL ?? ""){
                    self.getThumbnailImageFromVideoUrl(url: urlVideo) { (thumbNailImage) in
                        cell.blurImgView.image = thumbNailImage
                    }
                }
            }else {
                cell.blurImgView.loadImageFromUrl(model.serverImgURL, false)
            }
            cell.showLabelCount.isHidden = true
            cell.showImageBlur.isHidden = true
            cell.imgVideoIcon.isHidden = !(model.assetType == .Video)
            self.setCurrentImageCount()
            cell.invalidateIntrinsicContentSize()
            
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let lightBoxHelper = LightBoxControllerHelper()
        lightBoxHelper.openMultipleImagesWithVideoFrom(assetModel: arrMedia, controller: self.viewController, selectedIndex: indexPath.item)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        setCurrentImageCount()
    }
    
    func setCurrentImageCount(){
        var visibleRect = CGRect()
        visibleRect.origin = self.contentOffset
        visibleRect.size = self.bounds.size
        let visiblePoint = CGPoint(x: CGFloat(visibleRect.midX), y: CGFloat(visibleRect.midY))
        if let indexPath: IndexPath = self.indexPathForItem(at: visiblePoint){
            let index = indexPath.row + 1
            self.scrollToIndex?(index)
        }
    }
}

//MARK:- UICollectionViewDelegateFlowLayout
extension ProductMediaCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}


extension ProductMediaCollectionView{
    
    func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping ((_ image: UIImage?)->Void)){
        DispatchQueue.global().async { //1
            let asset = AVAsset(url: url) //2
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) //3
            avAssetImageGenerator.appliesPreferredTrackTransform = true //4
            let thumnailTime = CMTimeMake(value: 2, timescale: 1) //5
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
                let thumbNailImage = UIImage(cgImage: cgThumbImage) //7
                DispatchQueue.main.async { //8
                    completion(thumbNailImage) //9
                }
            } catch {
                print(error.localizedDescription) //10
                DispatchQueue.main.async {
                    completion(nil) //11
                }
            }
        }
    }

}
