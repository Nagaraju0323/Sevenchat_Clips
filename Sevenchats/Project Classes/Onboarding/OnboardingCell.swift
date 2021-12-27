//
//  OnboardingCell.swift
//  Sevenchats
//
//  Created by mac-0005 on 07/02/20.
//  Copyright © 2020 mac-0005. All rights reserved.
//

import UIKit

class OnboardingCell: UICollectionViewCell {
    
    @IBOutlet private var lblTitle: UILabel!
    @IBOutlet private var lblDescription: UILabel!
    @IBOutlet private var imgOnboarding: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}

extension OnboardingCell {
    
    func configureOnboardingCell(onboardingModel: OnboardingModel) {
        
        lblTitle.text = onboardingModel.title
        lblDescription.text = onboardingModel.description
        imgOnboarding.image = UIImage(named: onboardingModel.image ?? "")
    }
}
