//
//  ImageZoomView.swift
//  Sevenchats
//
//  Created by mac-0005 on 24/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : RestrictedFilesVC                           *
 * Changes :                                             *
 *                                                       *
 ********************************************************/

import UIKit

class ImageZoomView: UIView {
    
    @IBOutlet var clImage : UICollectionView!
    var arrImages = [[String : Any]]()
    
    @IBOutlet var btnCancel : UIButton!
    
    @IBOutlet var btnImageScrollBack : UIButton!
    @IBOutlet var btnImageScrollNext : UIButton!
    var imageIndex:Int = 0
    var didPlayVideo : ((URL) -> Void)?
    
    class func initImageZoomView() -> ImageZoomView?{
        let zoomView : ImageZoomView = Bundle.main.loadNibNamed("ImageZoomView", owner: nil, options: nil)?.last as! ImageZoomView
        zoomView.frame = CGRect(x: 0, y: 0, width: CScreenWidth, height: CScreenHeight)
        return zoomView
    }
    
    func showImage(_ arr : [[String : Any]]?){
        
        self.updateUIAccordingToLanguage()
        btnImageScrollBack.isHidden = true
        btnImageScrollBack.isUserInteractionEnabled = false

        arrImages = arr!
        clImage.register(UINib(nibName: "ImageZoomCollCell", bundle: nil), forCellWithReuseIdentifier: "ImageZoomCollCell")
        
        GCDMainThread.async {
            self.clImage.reloadData()
            self.clImage.setContentOffset(CGPoint(x: (CScreenWidth * CGFloat(self.imageIndex)), y: 0), animated: false)
            //self.clImage.scrollToItem(at: IndexPath(row: self.imageIndex, section: 0), at: .right, animated: false)
            self.showHideArrowButton()
        }
    }
    
    func scrollToIndex(indexPath:IndexPath){
        self.clImage.scrollToItem(at: indexPath, at: .right, animated: false)
    }
    
    func updateUIAccordingToLanguage(){
        
        if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
           
            btnCancel.contentHorizontalAlignment = .right
            btnImageScrollNext.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            btnImageScrollBack.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            clImage.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }else{
            
            btnCancel.contentHorizontalAlignment = .left
            btnImageScrollNext.transform = CGAffineTransform.identity
            btnImageScrollBack.transform = CGAffineTransform.identity
            clImage.transform = CGAffineTransform.identity
        }
    }
}

// MARK:- --------- UICollectionView Delegate/Datasources
extension ImageZoomView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:clImage.frame.size.width, height: clImage.frame.size.height)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageZoomCollCell", for: indexPath) as! ImageZoomCollCell
        cell.scrollView.zoomScale = 1.0
        let imgInfo = arrImages[indexPath.item]
        //cell.imgGalleryEvent.loadImageFromUrl(imgInfo.valueForString(key: CImage), false)
        let mediaType = imgInfo.valueForInt(key: CType) ?? 1
        if (mediaType == 2){
            cell.imgGallery.loadImageFromUrl(imgInfo.valueForString(key: CThumbNail), false)
            cell.imgVideoIcon.isHidden =  false
            cell.btnVideoPlay.tag = indexPath.row
            cell.btnVideoPlay.isHidden = false
            cell.btnVideoPlay.touchUpInside { [weak self] (sender) in
                guard let self = self else { return }
                let imageInfo = self.arrImages[sender.tag]
                let mediaType = imageInfo.valueForInt(key: CType) ?? 1
                if mediaType == 2{
                    guard let videoURL = URL(string: imageInfo.valueForString(key: CImage)) else{
                        return
                    }
                    DispatchQueue.main.async {
                        self.removeFromSuperview()
                        self.didPlayVideo?(videoURL)
                    }
                    return
                }
            }
            
        }else{
            cell.imgGallery.loadImageFromUrl(imgInfo.valueForString(key: CImage), false)
            cell.imgVideoIcon.isHidden =  true
            cell.btnVideoPlay.isHidden = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

// MARK:- ------- UIScrollView Delegate
extension ImageZoomView{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = round(scrollView.contentOffset.x/scrollView.bounds.size.width)
        imageIndex = Int(page < 1 ? 0 : page)
        self.showHideArrowButton()
    }
}

// MARK:- ------- General Functions
extension ImageZoomView{
    
    func showHideArrowButton(){
    
        if imageIndex == 0{
            btnImageScrollBack.isHidden = true
            btnImageScrollBack.isUserInteractionEnabled = false
        }else{
            btnImageScrollBack.isHidden = false
            btnImageScrollBack.isUserInteractionEnabled = true
        }
        
        if imageIndex == arrImages.count - 1{
            btnImageScrollNext.isHidden = true
            btnImageScrollNext.isUserInteractionEnabled = false
        }else{
            btnImageScrollNext.isHidden = false
            btnImageScrollNext.isUserInteractionEnabled = true
        }
    }
}
// MARK:- ------- Action event

extension ImageZoomView{
    @IBAction func btnCancelCLK(_ sender : UIButton){
        self.removeFromSuperview()
    }
        
    @IBAction func btnImageBackNextCLK(_ sender : UIButton){
       
        switch sender.tag {
        case 0:
            // back CLK
            if imageIndex > 0{
                imageIndex = imageIndex-1;
            }
            break
        case 1:
            // Next CLK
            if imageIndex < arrImages.count - 1{
                imageIndex = imageIndex+1;
            }
            break
        default:
            break
        }
        clImage.setContentOffset(CGPoint(x: CScreenWidth * CGFloat(imageIndex), y: 0), animated: true)
        self.showHideArrowButton()
    }
}
