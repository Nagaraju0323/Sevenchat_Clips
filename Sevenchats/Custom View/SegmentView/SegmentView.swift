//
//  ScrollableSegment.swift
//  Virgla
//
//  Created by Ghanshyam on 08/05/18.
//  Copyright © 2018 Ackee s.r.o. All rights reserved.
//

import UIKit

protocol SegmentViewDelegate : class{
    
    /// This method is getting called whenever user did change the segment.
    /// - Parameter index: Indext of selected segemtn
    func didSelectSegmentAt(index:Int)
}

class SegmentView: UIView {

    @IBOutlet weak var vwSegments: UIStackView!
    
    weak var delegate : SegmentViewDelegate?
    var globalIndex : Int = 0
    
    @objc public var selectedSegmentIndex: Int = -1 {
        didSet{
            let views = vwSegments.arrangedSubviews as![SegmentText]
            if views.count > selectedSegmentIndex {
                _ = views.map({$0.isSelected = false})
                views[selectedSegmentIndex].isSelected = true
            }
            delegate?.didSelectSegmentAt(index: selectedSegmentIndex)
        }
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    
    func addSubItems(arrViews : [SegmentText]){
        
        let _ = vwSegments.arrangedSubviews.map({$0.removeFromSuperview()})
        
        for (index,obj) in arrViews.enumerated(){
            obj.delegate = self
            obj.segmentIndex = index
            /*if (index % 2) == 1{
                obj.lblLeftLine.isHidden = true
                obj.lblRightLine.isHidden = true
            }*/
            vwSegments.addArrangedSubview(obj)
        }
    }
    
    //MARK: - Memory management methods
    deinit {
        print("### deinit -> SegmentView")
    }
}

extension SegmentView : SegmentTextDelegate {
    func didSelectSegmentAt(index: Int) {
        self.selectedSegmentIndex = index
    }
}
