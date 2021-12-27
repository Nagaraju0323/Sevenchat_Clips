//
//  BlurImageView.swift
//  BlureImageView
//
//  Created by mac-00020 on 04/09/19.
//  Copyright © 2019 mac-00020. All rights reserved.
//

import Foundation
import UIKit

class BlurImageView: UIView {
    
    fileprivate var imgBGBlur : UIImageView?
    fileprivate var vwBlur: VisualEffectView?
    fileprivate var imageView : UIImageView?
    
    var isBlurBackgroundEnable: Bool = true{
        didSet{
            if isBlurBackgroundEnable != oldValue{
                setup()
            }
        }
    }
    var bgColor: UIColor = UIColor(hex: "DEDDE5"){
        didSet{
            if bgColor != oldValue{
                setup()
            }
        }
    }
    var blurRadius : CGFloat = 10{
        didSet{
            vwBlur?.tint(.clear, blurRadius: blurRadius)
        }
    }
    
    var image: UIImage?{
        didSet{
            imgBGBlur?.image = image
            imageView?.image = image
            imageView?.layoutIfNeeded()
            self.layoutIfNeeded()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    deinit {
        print("Deinit -> BlurImageView")
    }
    
    private func setup() {
        
        self.clipsToBounds = true
        
        imgBGBlur?.removeFromSuperview()
        vwBlur?.removeFromSuperview()
        imageView?.removeFromSuperview()
        imgBGBlur = nil
        imageView = nil
        vwBlur = nil
        
        if isBlurBackgroundEnable{
            imgBGBlur = UIImageView()
            imgBGBlur?.contentMode = .scaleToFill
            imgBGBlur?.backgroundColor = .clear
            imgBGBlur?.image = self.image
            self.addSubview(imgBGBlur!)
            imgBGBlur?.fillSuperview()
            
            vwBlur = VisualEffectView(effect: UIBlurEffect(style: .light))
            vwBlur?.backgroundColor = .clear
            self.addSubview(vwBlur!)
            vwBlur?.fillSuperview()
            vwBlur?.tint(.black, blurRadius: blurRadius)
        }else{
            self.backgroundColor = bgColor
        }
        
        imageView = UIImageView()
        imageView?.image = self.image
        imageView?.contentMode = .scaleAspectFit
        imageView?.backgroundColor = .clear
        self.addSubview(imageView!)
        imageView?.translatesAutoresizingMaskIntoConstraints =  false
        
        NSLayoutConstraint.activate([
            imageView!.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView!.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imageView!.leftAnchor.constraint(greaterThanOrEqualTo: self.leftAnchor),
            imageView!.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor)
        ])
    }
    
    func loadImageFromUrl(_ strUrl : String?, _ isuser: Bool)  {
        self.image = nil
        imageView?.sd_setShowActivityIndicatorView(true)
        imageView?.sd_setIndicatorStyle(.gray)
        let placeholder = isuser ? UIImage(named: "user_placeholder") : UIImage(named: "image_placeholder")
        guard let _URL = URL(string: strUrl ?? "") else {return}
        imageView?.sd_setImage(with:  _URL, placeholderImage: placeholder, options: .retryFailed, completed: { [weak self] (img, error, _, _) in
            guard let self = self else { return }
            self.image = img
        })
    }
    
    func loadImageFromUrlWithCompletion(_ strUrl : String?, _ isuser: Bool,Complition:@escaping (UIImage?)-> Void) {
        self.image = nil
        imageView?.sd_setShowActivityIndicatorView(true)
        imageView?.sd_setIndicatorStyle(.gray)
        guard let _URL = URL(string: strUrl ?? "") else {return}
        imageView?.sd_setImage(with: _URL, placeholderImage:  isuser ? UIImage(named: "user_placeholder") : UIImage(named: "image_placeholder"), options: .retryFailed) { [weak self](img, error, _, _) in
            guard let self = self else { return }
            self.image = img
            Complition(img)
        }
    }
}
