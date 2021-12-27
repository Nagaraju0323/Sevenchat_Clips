//  MIGenericButton.swift
//  Sevenchats
//
//  Created by mac-0005 on 07/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//


import Foundation
import UIKit

class MIGenericButton: UIButton
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
    
    deinit {}
    
    //MARK:-
    //MARK:- Initialize
    
    func initialize() {
        //self.titleLabel?.font = UIFont(name: (self.titleLabel?.font.fontName)!, size: round(CScreenWidth * ((self.titleLabel?.font.pointSize)! / 375)))
        self.titleLabel?.font = UIFont(name: (self.titleLabel?.font.fontName)!, size: round(CScreenWidth * ((self.titleLabel?.font.pointSize)! / 414)))
    }
    
}
