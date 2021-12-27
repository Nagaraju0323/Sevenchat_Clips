//
//  ExtensionUIImageView.swift
//  Swifty_Master
//
//  Created by Mac-0002 on 06/09/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func loadGif(name: String) {
        
        DispatchQueue.global().async {
            
            if let image = UIImage.gif(name: name) {
                
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
}

extension UIImageView {
    func loadImageFromUrl(_ strUrl : String?, _ isuser: Bool)  {
        
        self.sd_setShowActivityIndicatorView(true)
        self.sd_setIndicatorStyle(.gray)
       
        if isuser{
            
            //self.sd_setImage(with: URL(string: strUrl!), placeholderImage: isuser ? UIImage(named: "user_placeholder.png") : UIImage(named: "image_placeholder"), options: .retryFailed, completed: nil)
            self.sd_setImage(with:  URL(string: strUrl!), placeholderImage:  UIImage(named: "user_placeholder") , options: .retryFailed) { [weak self](img, error, _, _) in
                guard let _ = self else {return}
                guard let _img = img else {
                    self?.image = UIImage(named: "user_placeholder")
                    return
                }
                //print("Profile Image Size : \(_img.size)")
                let ratio = _img.size.width / _img.size.height
                if ratio >= 3{
                    self?.image = self?.resizeImage(image: _img, targetSize: CGSize(width: _img.size.height, height: _img.size.height)) ?? UIImage(named: "user_placeholder")
                }else{
                    self?.image = _img
                }
            }
        } else {
            //self.sd_setImage(with: URL(string: strUrl!), placeholderImage: UIImage(named: "image_placeholder"), options: .retryFailed, completed: nil)
            self.sd_setImage(with:  URL(string: strUrl!), placeholderImage:  UIImage(named: "image_placeholder") , options: .retryFailed) { [weak self](img, error, _, _) in
                guard let _ = self else {return}
                guard let _img = img else {
                    self?.image = UIImage(named: "image_placeholder")
                    return
                }
                self?.image = _img
            }
        }
    }
    
    func loadImageFromUrlWithCompletionHendler(_ strUrl : String?, _ isuser: Bool,Complition:@escaping (UIImage?)-> Void) {
        
        self.sd_setShowActivityIndicatorView(true)
        self.sd_setIndicatorStyle(.gray)
        
        if isuser{
            
            self.sd_setImage(with:  URL(string: strUrl!), placeholderImage:  UIImage(named: "user_placeholder") , options: .retryFailed) { (img, error, _, _) in
                /*guard let _ = self else {
                    self?.image = UIImage(named: "user_placeholder")
                    Complition(UIImage(named: "user_placeholder"))
                    return
                }*/
                guard let _img = img else {
                    self.image = UIImage(named: "user_placeholder")
                    Complition(UIImage(named: "user_placeholder"))
                    return
                }
                //print("Profile Image Size : \(_img.size)")
                let ratio = _img.size.width / _img.size.height
                if ratio >= 3{
                    self.image = self.resizeImage(image: _img, targetSize: CGSize(width: _img.size.height, height: _img.size.height)) ?? UIImage(named: "user_placeholder")
                    Complition(self.image)
                }else{
                    self.image = _img
                    Complition(_img)
                }
            }
        } else {
            self.sd_setImage(with: URL(string: strUrl!), placeholderImage: UIImage(named: "image_placeholder"), options: .retryFailed) { (img, error, _, _) in
                
                guard let _img = img else {
                    self.image = UIImage(named: "image_placeholder")
                    Complition(UIImage(named: "image_placeholder"))
                    return
                }
                self.image = _img
                Complition(_img)
            }
        }
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            //newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            //newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        //let rect = CGRectMake(0, 0, newSize.width, newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()

        return newImage
    }
    
    
     func imageFromURL(urlString: String) {

        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        activityIndicator.startAnimating()
        if self.image == nil{
            self.addSubview(activityIndicator)
        }

        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in

            if error != nil {
                print(error ?? "No Error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                activityIndicator.removeFromSuperview()
                self.image = image
            })

        }).resume()
    }
}

