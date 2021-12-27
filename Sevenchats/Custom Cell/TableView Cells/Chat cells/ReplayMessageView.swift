//
//  ReplayMessageView.swift
//  Sevenchats
//
//  Created by APPLE on 25/03/21.
//  Copyright © 2021 mac-00020. All rights reserved.
//

import UIKit

import Foundation

class ReplayMessageView: UIView {
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var contentView:UIView!
    
    
    var uiView:UIView?
    
    override init(frame: CGRect) {
           super.init(frame: frame)
        setup()
       }
       
       required init?(coder: NSCoder) {
           super.init(coder: coder)
        setup()
       }
       
    func setup() {
        self.uiView = Bundle.main.loadNibNamed("ReplayMessageView", owner: self, options: nil)![0] as? UIView
        
//        self.uiView?.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        addSubview(self.uiView!)
        self.uiView?.frame = self.bounds
        }
}


//extension UIView {
//    class func initFromNib<T: UIView>() -> T {
//        return Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)?[0] as! T
//    }
//}
