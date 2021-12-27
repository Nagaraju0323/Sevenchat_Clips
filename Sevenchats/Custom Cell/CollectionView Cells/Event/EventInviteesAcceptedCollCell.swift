//
//  EventInviteesAcceptedCollCell.swift
//  Sevenchats
//
//  Created by mac-00020 on 30/05/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

import UIKit

class EventInviteesAcceptedCollCell: UICollectionViewCell {
    
    @IBOutlet weak var imgVUserProfile : UIImageView!
    public var scrollDirection = UICollectionView.ScrollDirection.vertical
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layoutIfNeeded()
    }
    
    
    override public func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        layoutIfNeeded()
        
        let preferredLayoutAttributes =
            super.preferredLayoutAttributesFitting(layoutAttributes)
        preferredLayoutAttributes.bounds = layoutAttributes.bounds
        
        switch scrollDirection {
        case .vertical:
            preferredLayoutAttributes.bounds.size.height = systemLayoutSizeFitting(
                UIView.layoutFittingCompressedSize,
                withHorizontalFittingPriority: .required,
                verticalFittingPriority: .defaultLow).height
        case .horizontal:
            preferredLayoutAttributes.bounds.size.width = systemLayoutSizeFitting(
                UIView.layoutFittingCompressedSize,
                withHorizontalFittingPriority: .defaultLow,
                verticalFittingPriority: .required).width
        }
        
        return preferredLayoutAttributes
    }
}
