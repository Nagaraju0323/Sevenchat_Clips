//
//  GradientButton.swift
//  Sevenchats
//
//  Created by mac-00020 on 04/10/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

import Foundation
import UIKit

class GradientButton: UIButton {
    
    var gradientLayer : CAGradientLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setGradientBackground()
    }
    
    private func setup() {
        self.titleLabel?.font = UIFont(name: (self.titleLabel?.font.fontName)!, size: round(CScreenWidth * ((self.titleLabel?.font.pointSize)! / 414)))
        self.backgroundColor = .clear
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
    }
    
    func setGradientBackground() {
        
        if gradientLayer != nil{
           gradientLayer?.removeFromSuperlayer()
        }
        gradientLayer = CAGradientLayer()
        gradientLayer?.colors = [UIColor(hex: "97b363").cgColor, UIColor(hex: "8ab68f").cgColor]
        gradientLayer?.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer?.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer?.locations = [0, 1]
        gradientLayer?.frame = bounds
        
        layer.insertSublayer(gradientLayer!, at: 0)
    }
}
