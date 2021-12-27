//
//  MIGenericView.swift
//  Sevenchats
//
//  Created by mac-0005 on 08/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class MIGenericView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    convenience override init(frame: CGRect) {
        self.init(frame: frame)
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUpViewAppearance()
    }
    
    func initialize() {
        
        switch  self.tag {
        case 0:
            self.backgroundColor = CRGB(r: 240, g: 245, b: 233)
            self.layer.borderWidth = 0.5
            self.layer.borderColor = CRGB(r: 142, g: 183, b: 145).cgColor
            self.layer.cornerRadius = 3
            break
        case 1:
            self.backgroundColor = CRGB(r: 255, g: 255, b: 255)
            self.layer.borderColor = CRGB(r: 142, g: 183, b: 145).cgColor
            self.layer.cornerRadius = 3
            break
        default:
            break
        }
    }
}

extension MIGenericView {
    
    fileprivate func setUpViewAppearance() {
        
        switch self.tag {
            
        case 0:
            // Show Shadow
            //self.shadow(color: CRGB(r: 219, g: 219, b: 219), shadowOffset: CGSize(width: 0, height: 9), shadowRadius: 10.0, shadowOpacity: 8.0)
            break
            
        case 1:
            // Show Shadow For FantasyCoin TblCell
            self.shadow(color: CRGB(r: 219, g: 219, b: 219), shadowOffset: CGSize(width: 0, height: 2), shadowRadius: 3.0, shadowOpacity: 5.0)
            
        case 2:
            // Show Shadow
            self.shadow(color: CRGB(r: 216, g: 238, b: 190), shadowOffset: CGSize(width: 0, height: 9), shadowRadius: 10.0, shadowOpacity: 8.0)
            break
        default:
            break;
        }
        
        //..
    }
    
}
