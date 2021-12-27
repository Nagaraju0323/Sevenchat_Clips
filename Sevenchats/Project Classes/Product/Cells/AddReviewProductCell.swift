//
//  AddReviewProductCell.swift
//  Sevenchats
//
//  Created by mac-00020 on 26/08/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

import UIKit

class AddReviewProductCell: UITableViewCell, ProductDetailBaseCell  {

    //MARK: - IBOutlet/Object/Variable Declaration
    @IBOutlet weak var lblReview: MIGenericLabel!
    @IBOutlet weak var lblAddExpe: MIGenericLabel!
    
    @IBOutlet weak var btnAddReview: MIGenericButton!
    
    var modelData: MDLProductAddRating!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        lblReview.text = CReview
        lblAddExpe.text = CAddExpeToHelpOtherBuyers
        btnAddReview.setTitle(CAddReview, for: .normal)
    }
    
    func configure(withModel: ProductBaseModel) {
        guard let _model = withModel as? MDLProductAddRating else {
            return
        }
        self.modelData = _model
    }
    
    @IBAction func onAddReviewPressed(_ sender:UIButton){
        if let addReview : RateAndReviewProductVC = CStoryboardProduct.instantiateViewController(withIdentifier: "RateAndReviewProductVC") as? RateAndReviewProductVC{
            self.viewController?.navigationController?.pushViewController(addReview, animated: true)
        }
    }
}
