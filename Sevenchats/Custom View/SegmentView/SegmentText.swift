//
//  SegmentText.swift
//  Virgla
//
//  Created by Ghanshyam on 08/05/18.
//  Copyright © 2018 Ackee s.r.o. All rights reserved.
//

import UIKit

protocol SegmentTextDelegate : class {
    func didSelectSegmentAt(index:Int)
}


class SegmentText: UIView {

    weak var delegate : SegmentTextDelegate?
    
    //@IBOutlet weak var lblLeftLine: UILabel!
    //@IBOutlet weak var lblRightLine: UILabel!
    @IBOutlet weak var lblBottomLine: UILabel!
    @IBOutlet weak var lblText: MIGenericLabel!
    
    var segmentIndex : Int = 0
    
    @objc public var isSelected: Bool = false {
        didSet{
            self.lblBottomLine.isHidden = !isSelected
            /*if isSelected {
                self.backgroundColor = UIColor.clear//themeColor.withAlphaComponent(0.9)
                //lblText.textColor = UIColor.white
            }else {
                self.backgroundColor = UIColor.white
                lblText.textColor = UIColor.lightGray
            }*/
        }
    }
    
    override func draw(_ rect: CGRect) {
        setupUI()
    }
    
    func setupUI() {
        
        //lblText.font = UIFont.custom(name: .PoppinsRegular, size: 15.0)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
        lblText.isUserInteractionEnabled = true
        lblText.addGestureRecognizer(tap)
        
        //self.lblLeftLine.backgroundColor = UIColor.appLightGray
        //self.lblRightLine.backgroundColor = UIColor.appLightGray
    }
    
    @objc
    func tapFunction(sender:UITapGestureRecognizer) {
        delegate?.didSelectSegmentAt(index: segmentIndex)
    }
    
    //MARK: - Memory management methods
    deinit {
        //print("### deinit -> \(self.className)")
    }
}
