//
//  GradientView.swift
//  Sevenchats
//
//  Created by mac-00020 on 14/10/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//


import Foundation
import UIKit

class GradientView: UIView {
    
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
        /*self.titleLabel?.font = UIFont(name: (self.titleLabel?.font.fontName)!, size: round(CScreenWidth * ((self.titleLabel?.font.pointSize)! / 414)))
        self.backgroundColor = .clear
        self.layer.cornerRadius = 4
        self.clipsToBounds = true*/
    }
    
    func setGradientBackground() {
        
        if gradientLayer != nil{
            gradientLayer?.removeFromSuperlayer()
        }
        gradientLayer = CAGradientLayer()
        gradientLayer?.colors = [UIColor.black.withAlphaComponent(0.1).cgColor,UIColor.black.withAlphaComponent(0.5).cgColor]
        //gradientLayer?.startPoint = CGPoint(x: 0.5, y: 1.0)
        //gradientLayer?.endPoint = CGPoint(x: 0.5, y: 0.0)
        //gradientLayer?.locations = [0, 1]
        gradientLayer?.locations = [0, 0.50]
        gradientLayer?.frame = bounds
        
        layer.insertSublayer(gradientLayer!, at: 0)
    }
}

class IncomingCallRadialGradientLayer: CALayer {

   override init(){

        super.init()

        needsDisplayOnBoundsChange = true
    }

     init(center:CGPoint,radius:CGFloat,colors:[CGColor]){

        self.center = center
        self.radius = radius
        self.colors = colors

        super.init()

    }

    required init(coder aDecoder: NSCoder) {

        super.init()

    }

    var center:CGPoint = CGPoint(x: 50, y: 50)
    var radius:CGFloat = 20
    var colors:[CGColor] = [UIColor(hex: "4d755d").cgColor , UIColor(hex: "64939d").cgColor]

    override func draw(in ctx: CGContext) {
        
        ctx.saveGState()
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let locations:[CGFloat] = [0.0, 1.0]
        
        guard let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: locations) else {
            return
        }
        //let startPoint = CGPoint(x: 0, y: self.bounds.height)
        //let endPoint = CGPoint(x: self.bounds.width, y: self.bounds.height)
        ctx.drawRadialGradient(gradient, startCenter: center, startRadius: 0.0, endCenter: center, endRadius: radius, options: [])
    }
}
