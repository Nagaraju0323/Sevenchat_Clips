//
//  ReviewProductCell.swift
//  Sevenchats
//
//  Created by mac-00020 on 26/08/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : ReviewProductCell                           *
 * Changes :                                             *
 *                                                       *
 ********************************************************/

import UIKit
import Cosmos

class ReviewProductCell: UITableViewCell, ProductDetailBaseCell  {

    //MARK: - IBOutlet/Object/Variable Declaration
    @IBOutlet weak var imgUser: UIImageView!
    
    @IBOutlet weak var lblUserName: MIGenericLabel!
    @IBOutlet weak var lblReviewDate: MIGenericLabel!
    @IBOutlet weak var lblDescription: MIGenericLabel!
    @IBOutlet weak var vwStar: CosmosView!
    
    var modelData: MDLProduct!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        // Use if you need just to show the stars without getting user's input
        vwStar.settings.updateOnTouch = false
    }
    
    func configure(withModel: ProductBaseModel) {
        guard let _model = withModel as? MDLProduct else {
            return
        }
        self.modelData = _model
    }
}
