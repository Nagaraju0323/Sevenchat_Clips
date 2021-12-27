//
//  ColorCollectionViewCell.swift
//  Sevenchats
//
//  Created by APPLE on 22/03/21.
//  Copyright © 2021 mac-00020. All rights reserved.
//

import UIKit

class ColorCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var colorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        colorView.layer.cornerRadius = colorView.frame.width / 2

    }
    
    
    override var isSelected: Bool {
        get {
            return super.isSelected
        }
        set {
            if newValue {
                super.isSelected = true
                self.colorView.alpha = 0.5
                
                let previouTransform =  colorView.transform
                UIView.animate(withDuration: 0.5,
                               animations: {
                                self.colorView.transform = self.colorView.transform.scaledBy(x: 1.5, y: 1.5)
                },
                               completion: { _ in
                                UIView.animate(withDuration: 0.5) {
                                    self.colorView.transform  = previouTransform
                                }
                })
                
            } else if newValue == false {
                super.isSelected = false
                self.colorView.alpha = 1.0
            }
        }
    }
    
}
