//
//  ProductFilterCell.swift
//  Sevenchats
//
//  Created by mac-00020 on 28/08/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : ProductFilterCell                           *
 * Changes :                                             *
 *                                                       *
 ********************************************************/

import UIKit
class MDLProductFilter {
    var name = ""
    var isSelected = false
    init(name:String,isSelected:Bool = false) {
        self.name = name
        self.isSelected = isSelected
    }
}

class ProductFilterCell: UITableViewCell {

    //MARK: - IBOutlet/Object/Variable Declaration
    @IBOutlet weak var lblName: MIGenericLabel!
    @IBOutlet weak var btnRadio: UIButton!{
        didSet{
            btnRadio.setImage(UIImage(named:"ic_unselect"), for: .normal)
            btnRadio.setImage(UIImage(named:"ic_select"), for: .selected)
        }
    }
    
    var category : MDLProductCategory!{
        didSet{
            lblName.text = category.categoryName
            btnRadio.isSelected = category.isSelected
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }
    
}
