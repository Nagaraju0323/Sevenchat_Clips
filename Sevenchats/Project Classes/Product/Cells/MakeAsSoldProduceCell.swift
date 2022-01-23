//
//  MakeAsSoldProduceCell.swift
//  Sevenchats
//
//  Created by mac-00020 on 26/08/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

import UIKit

class MakeAsSoldProduceCell: UITableViewCell, ProductDetailBaseCell  {
    
    @IBOutlet weak var btnMarkSold: MIGenericButton!
    
    var modelData: MDLMarkAsSold!
    var product : MDLProduct?
    var arrMedia : [MDLAddMedia] = []
    var imgName = ""

    
    override func awakeFromNib() {
        super.awakeFromNib()
            self.selectionStyle = .none
            btnMarkSold.setTitle(CMarkAsSold, for: .normal)
            btnMarkSold.layer.cornerRadius = 4
        
        
    }
    
    func configure(withModel: ProductBaseModel) {
        guard let _model = withModel as? MDLMarkAsSold else {
            return
        }
        self.modelData = _model
    }
    
    @IBAction func onMarkAsSold(_ sender:UIButton){
        self.markAsSoldAPI()
    }
}

//MARK: - API Function
extension MakeAsSoldProduceCell {
    
    fileprivate func markAsSoldAPI(){
        
        if let productDetail = self.viewController as? ProductDetailVC{
            productDetail.updateOnMarkAsSold(available_status:"2")
            
        }
    }
}


