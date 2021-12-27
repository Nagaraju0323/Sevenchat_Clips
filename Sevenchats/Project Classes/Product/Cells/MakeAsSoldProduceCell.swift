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
        
        //Mark as sold api Hit
        
        if let productDetail = self.viewController as? ProductDetailVC{
            productDetail.updateOnMarkAsSold(available_status:"2")
            //productDetail.apiTask?.cancel()
        
            
//            productDetail.updateProduct(available_status:"No")
            
        }
        
       
     
        
        
//        self.txtLocation.text = _product.address
//
//        categoryDropDownView.txtCategory.text = _product.category
//        self.categoryID = _product.categoryId
//
//        self.txtProductTitle.text = _product.productTitle
//        self.txtProductDesc.text = _product.productDescription
//        self.txtProductPrice.text = _product.productPrice.description
//        self.txtCurrencyList.text = _product.currencyName
//        self.selectedCurrencyName = _product.currencyName
//        let date = Date.init(timeIntervalSince1970: Double(_product.lastDateSelling) ?? 0.0)
//        self.setDate(date: date)
//        self.availableStatus = _product.productState
//        self.prouductID = _product.productId
//
        
        
    //Sold api calls 
//        APIRequest.shared().markAsSold(productId: self.modelData.available_status) { [weak self](response, error) in
//            if response != nil {
//                GCDMainThread.async {
//                    //let data = response![CData] as? [String : Any] ?? [:]
//                    if let productDetail = self?.viewController as? ProductDetailVC{
//                        productDetail.updateOnMarkAsSold(available_status:"No")
//                        //productDetail.apiTask?.cancel()
//                        //productDetail.getProductDetail()
//                    }
//                }
//            }
//        }
    }
    
    
    
}


