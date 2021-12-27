//  MIGenericLabel.swift
//  Sevenchats
//
//  Created by mac-0005 on 07/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//


import Foundation
import UIKit

class MIGenericLabel: UILabel
{
    
    //MARK:-
    //MARK:- Override
    
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
    }
    
    
    //MARK:-
    //MARK:- Initialize
    func initialize() {
        self.font = UIFont(name: self.font.fontName, size: round(CScreenWidth * (self.font.pointSize / 414)))
        //self.font = UIFont(name: self.font.fontName, size: round(CScreenWidth * (self.font.pointSize / 375)))
    }
    
}
