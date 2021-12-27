//
//  LightBoxControllerHelper.swift
//  Sevenchats
//
//  Created by mac-00020 on 07/08/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

import Foundation
import Lightbox

//MARK: - LightBoxControllerHelper
class LightBoxControllerHelper : NSObject{
    
    class func ConfigureLightBox(){
        
        LightboxConfig.CloseButton.image = UIImage(named: "ic_image_close")
        LightboxConfig.CloseButton.text = ""
        LightboxConfig.PageIndicator.textAttributes = [
            .font: UIFont.systemFont(ofSize: 18),
            .foregroundColor: UIColor(hex: "899AB8"),
            .paragraphStyle: {
                let style = NSMutableParagraphStyle()
                style.alignment = .center
                return style
            }()
        ]
    }
    
    func openSingleImage(image:UIImage?,viewController:UIViewController?){
        LightboxConfig.PageIndicator.enabled = false
        guard let img = image else {return}
        let lightboxImage = LightboxImage(image: img)
        let controller = LightboxController(images: [lightboxImage], startIndex: 0)
        controller.dynamicBackground = true
        if #available(iOS 13.0, *){
            controller.isModalInPresentation = true
            controller.modalPresentationStyle = .fullScreen
        }
        viewController?.present(controller, animated: true, completion: nil)
    }
    
    func openSingleImageFromURL(imgURL:String?,viewController:UIViewController?){
        LightboxConfig.PageIndicator.enabled = false
        guard let imgURL = URL(string: imgURL ?? "")else {return}
        let lightboxImage = LightboxImage(imageURL: imgURL)
        let controller = LightboxController(images: [lightboxImage], startIndex: 0)
        controller.dynamicBackground = true
        if #available(iOS 13.0, *){
            controller.isModalInPresentation = true
            controller.modalPresentationStyle = .fullScreen
        }
        viewController?.present(controller, animated: true, completion: nil)
    }
    
    func openMultipleImagesWithVideo(arrGalleryImage:[[String : Any]],controller:UIViewController?, selectedIndex:Int = 0){
        
        var arrGallery : [LightboxImage] = []
        for imgInfo in arrGalleryImage{
            let mediaType = imgInfo.valueForInt(key: CType) ?? 1
            var imgStrURL = imgInfo.valueForString(key: CImage)
            var videoURL : URL?
            if mediaType == 2{
                imgStrURL = imgInfo.valueForString(key: CThumbNail)
                videoURL = URL(string: imgInfo.valueForString(key: CImage))
            }
            if let imgURL = URL(string: imgStrURL){
                let lightboxImage = LightboxImage(imageURL: imgURL, text: "", videoURL: videoURL)
                arrGallery.append(lightboxImage)
            }
        }
        LightboxConfig.PageIndicator.enabled = (arrGallery.count > 1)
        let lightBoxController = LightboxController(images: arrGallery, startIndex: 0)
        lightBoxController.dynamicBackground = true
        lightBoxController.dismissalDelegate = self
        if !arrGallery.isEmpty{
            lightBoxController.goTo(selectedIndex, animated: true)
        }
        if #available(iOS 13.0, *){
            lightBoxController.isModalInPresentation = true
            lightBoxController.modalPresentationStyle = .fullScreen
        }
        controller?.present(lightBoxController, animated: true, completion: nil)
    }
   
    func openMultipleImagesWithVideos(arrGalleryImage:[[String : Any]],controller:UIViewController?, selectedIndex:Int = 0){
        
        var arrGallery : [LightboxImage] = []
        for imgInfo in arrGalleryImage{
           // let mediaType = imgInfo.valueForInt(key: ""mime"") ?? 1
            let mediaType = imgInfo.valueForString(key: "mime")
            var imgStrURL = imgInfo.valueForString(key: "image_path")
            var videoURL : URL?
            //if mediaType == 2{
            if mediaType == "vidoe" || mediaType == "video"{
//                imgStrURL = imgInfo.valueForString(key: CThumbNail)
                imgStrURL = imgInfo.valueForString(key: "image_path")
                videoURL = URL(string: imgInfo.valueForString(key: "image_path"))
            }
            if let imgURL = URL(string: imgStrURL){
                let lightboxImage = LightboxImage(imageURL: imgURL, text: "", videoURL: videoURL)
                arrGallery.append(lightboxImage)
            }
        }
        LightboxConfig.PageIndicator.enabled = (arrGallery.count > 1)
        let lightBoxController = LightboxController(images: arrGallery, startIndex: 0)
        lightBoxController.dynamicBackground = true
        lightBoxController.dismissalDelegate = self
        if !arrGallery.isEmpty{
            lightBoxController.goTo(selectedIndex, animated: true)
        }
        if #available(iOS 13.0, *){
            lightBoxController.isModalInPresentation = true
            lightBoxController.modalPresentationStyle = .fullScreen
        }
        controller?.present(lightBoxController, animated: true, completion: nil)
    }
    
    
    
    func openMultipleImagesWithVideoFrom(assetModel:[MDLAddMedia],controller:UIViewController?, selectedIndex:Int = 0){
        
        var arrGallery : [LightboxImage] = []
        for assets in assetModel{
            
            let imgStrURL = assets.serverImgURL ?? ""
            var videoURL : URL? = nil
//            if assets.assetType == .Video{
//                videoURL = URL(string: assets.url ?? "")
//            }
            
            let imgExt = imgStrURL.fileExtension()
            if imgExt == "mp4" ||  imgExt == "mov" ||  imgExt == "MOV"{
                videoURL = URL(string: imgStrURL )
            }
            
            
            if let imgURL = URL(string: imgStrURL){
                let lightboxImage = LightboxImage(imageURL: imgURL, text: "", videoURL: videoURL)
                arrGallery.append(lightboxImage)
            }
        }
        LightboxConfig.PageIndicator.enabled = (arrGallery.count > 1)
        let lightBoxController = LightboxController(images: arrGallery, startIndex: 0)
        lightBoxController.dynamicBackground = true
        lightBoxController.dismissalDelegate = self
        if !arrGallery.isEmpty{
            lightBoxController.goTo(selectedIndex, animated: true)
        }
        if #available(iOS 13.0, *){
            lightBoxController.isModalInPresentation = true
            lightBoxController.modalPresentationStyle = .fullScreen
        }
        controller?.present(lightBoxController, animated: true, completion: nil)
    }
    
    deinit {
        print("Deinit -> LightBoxControllerHelper")
    }
}

//MARK: - LightboxControllerDismissalDelegate
extension LightBoxControllerHelper : LightboxControllerDismissalDelegate{
   
    func lightboxControllerWillDismiss(_ controller: LightboxController) {
        LightboxConfig.PageIndicator.enabled = false
    }
}
