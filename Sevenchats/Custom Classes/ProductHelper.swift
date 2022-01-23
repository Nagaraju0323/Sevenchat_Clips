//
//  ProductHelper.swift
//  Sevenchats
//
//  Created by mac-00020 on 27/09/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

import Foundation
import UIKit

class ProductHelper<T:UIViewController> : NSObject{
    
    override init(){}
    deinit {
        print("Deinit --> MoreOptionMamanger")
    }
    
    class func createProduct(controller:UIViewController?,refreshCnt:[T.Type]) {
        for vc in refreshCnt{
            guard let controller = controller?.getViewControllerFromNavigation(vc)else {
                continue
            }
            if let myProductVC = controller as? StoreListVC {
                DispatchQueue.main.async {
                    myProductVC.filterObj = MDLStoreAppliedFilter()
                    myProductVC.changedController(index: 1)
                    guard let myProductList = myProductVC.myProductVC else {return}
                    myProductList.pullToRefresh()
                }
            }
        }
    }
    
    class func updateProduct(product:MDLProduct, controller:UIViewController?, refreshCnt:[T.Type]) {
        for vc in refreshCnt{
            guard let _controller = controller?.getViewControllerFromNavigation(vc)else {
                continue
            }
            
            if let productDetailVC = _controller as? ProductDetailVC {
                DispatchQueue.main.async {
                    productDetailVC.apiTask?.cancel()
                    productDetailVC.getProductDetail()
                }
            }
            
            if let myProductVC = _controller as? StoreListVC {
                DispatchQueue.main.async {
                    
                    guard let myProductList = myProductVC.myProductVC else {return}
                    
                    if let index = myProductList.allMyProduct.index(where:{$0.productID == product.productID})
                    {
                        myProductList.allMyProduct.remove(at: index)
                        myProductList.allMyProduct.insert(product, at: 0)
                        myProductList.tblProductList.reloadData()
                    }
                    
                }
            }
            if let searchProductVC = _controller as? ProductSearchVC {
                DispatchQueue.main.async {
                    
                    guard let myProductList = searchProductVC.myProductVC else {return}
                    if let index = myProductList.allMyProduct.index(where:{$0.productID == product.productID}){
                        myProductList.allMyProduct.remove(at: index)
                        myProductList.allMyProduct.insert(product, at: index)
                        UIView.performWithoutAnimation {
                            let indexPath = IndexPath(item: index, section: 0)
                            if (myProductList.tblProductList.indexPathsForVisibleRows?.contains(indexPath))!{
                                myProductList.tblProductList.reloadRows(at: [indexPath], with: .none)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    class func updateProductlatest(product:MDLProduct,productID:String, controller:UIViewController?, refreshCnt:[T.Type]) {
        for vc in refreshCnt{
            guard let _controller = controller?.getViewControllerFromNavigation(vc)else {
                continue
            }
            
            if let productDetailVC = _controller as? ProductDetailVC {
                DispatchQueue.main.async {
                    productDetailVC.apiTask?.cancel()
                    productDetailVC.getProductDetail()
                }
            }
            
            if let myProductVC = _controller as? StoreListVC {
                DispatchQueue.main.async {
                    
                    guard let myProductList = myProductVC.myProductVC else {return}
                    
                    if let index = myProductList.allMyProduct.index(where:{$0.productID == productID})
                    {
                        myProductList.allMyProduct.remove(at: index)
                        myProductList.tblProductList.reloadData()
                    }
                    
                }
            }
            if let searchProductVC = _controller as? ProductSearchVC {
                DispatchQueue.main.async {
                    
                    guard let myProductList = searchProductVC.myProductVC else {return}
                    if let index = myProductList.allMyProduct.index(where:{$0.productID == product.productID}){
                        myProductList.allMyProduct.remove(at: index)
                        myProductList.allMyProduct.insert(product, at: index)
                        UIView.performWithoutAnimation {
                            let indexPath = IndexPath(item: index, section: 0)
                            if (myProductList.tblProductList.indexPathsForVisibleRows?.contains(indexPath))!{
                                myProductList.tblProductList.reloadRows(at: [indexPath], with: .none)
                            }
                        }
                    }
                }
            }
        }
    }
    class func deleteProduct(controller:UIViewController?,refreshCnt:[T.Type], productID:Int, isLoader:Bool = true) {
        
        func refershControllerOnDeleteAction(){
            
            func refereshDeletePost(tableView:UITableView){
                tableView.reloadData()
            }
            
            for vc in refreshCnt{
                guard let _controller = controller?.getViewControllerFromNavigation(vc)else {
                    continue
                }
                if let productDetail = controller as? ProductDetailVC {
                    DispatchQueue.main.async {
                        productDetail.navigationController?.popToRootViewController(animated: true)
                        return
                    }
                }
                if let searchProductVC = _controller as? ProductSearchVC {
                    DispatchQueue.main.async {
                        
                        guard let myProductList = searchProductVC.myProductVC else {return}
                        myProductList.allMyProduct = myProductList.allMyProduct.filter({$0.id != productID})
                        refereshDeletePost(tableView: myProductList.tblProductList)
                    }
                }
                if let myProductVC = _controller as? StoreListVC {
                    DispatchQueue.main.async {
                        
                        guard let myProductList = myProductVC.myProductVC else {return}
                        myProductList.allMyProduct = myProductList.allMyProduct.filter({$0.productID != productID.description})
                        refereshDeletePost(tableView: myProductList.tblProductList)
                    }
                }
            }
        }
        
        APIRequest.shared().deleteProduct(productID: productID, showLoader: isLoader, completion:{(response, error) in
            
            if response != nil {
                GCDMainThread.async {
                    refershControllerOnDeleteAction()
                    
                    
                }
            }else{
                MILoader.shared.hideLoader()
            }
        })
    }
    
    
    class func availableProduct(controller:UIViewController?,refreshCnt:[T.Type], productID:Int, isLoader:Bool = true) {
        
        func refershControllerOnDeleteAction(){
            
            func refereshDeletePost(tableView:UITableView){
                tableView.reloadData()
            }
            
            for vc in refreshCnt{
                guard let _controller = controller?.getViewControllerFromNavigation(vc)else {
                    continue
                }
                if let productDetail = controller as? ProductDetailVC {
                    DispatchQueue.main.async {
                        productDetail.navigationController?.popToRootViewController(animated: true)
                        return
                    }
                }
                if let searchProductVC = _controller as? ProductSearchVC {
                    DispatchQueue.main.async {
                        
                        guard let myProductList = searchProductVC.myProductVC else {return}
                        myProductList.allMyProduct = myProductList.allMyProduct.filter({$0.id != productID})
                        refereshDeletePost(tableView: myProductList.tblProductList)
                    }
                }
                if let myProductVC = _controller as? StoreListVC {
                    DispatchQueue.main.async {
                        
                        guard let myProductList = myProductVC.myProductVC else {return}
                        //                        myProductList.allMyProduct = myProductList.allMyProduct.filter({$0.id != productID})
                        myProductList.allMyProduct = myProductList.allMyProduct.filter({$0.productID == productID.description})
                        refereshDeletePost(tableView: myProductList.tblProductList)
                    }
                }
            }
        }
        
    }
    
    
    class func reportProduct(controller:UIViewController?,refreshCnt:[T.Type], productID:Int, isLoader:Bool = true) {
        
        for vc in refreshCnt {
            guard let controller = controller?.getViewControllerFromNavigation(vc)else {
                continue
            }
            if let myProductVC = controller as? StoreListVC {
                DispatchQueue.main.async {
                    guard let allProductList = myProductVC.allProductVC else {return}
                    allProductList.allProduct = allProductList.allProduct.filter({$0.id != productID})
                    allProductList.tblProductList.reloadData()
                }
            }
            
            if let searchProductVC = controller as? ProductSearchVC {
                DispatchQueue.main.async {
                    guard let allProductList = searchProductVC.allProductVC else {return}
                    allProductList.allProduct = allProductList.allProduct.filter({$0.id != productID})
                    allProductList.tblProductList.reloadData()
                }
            }
        }
    }
    
    class func likeUnlike(productId:Int, isLike:Int, totalLike: Int,controller:UIViewController?, refreshCnt:[T.Type]) {
        for vc in refreshCnt{
            guard !(controller?.isKind(of: vc.classForCoder()) ?? false) else{
                continue
            }
            guard let controller = controller?.getViewControllerFromNavigation(vc)else {
                continue
            }
            if let myProductVC = controller as? StoreListVC {
                DispatchQueue.main.async {
                    
                    guard let myProductList = myProductVC.myProductVC else {return}
                    if let index = myProductList.allMyProduct.index(where:{$0.productID == productId.toString}) {
                        if isLike == 0{
                            myProductList.allMyProduct[index].userAsLiked = "No"
                        }else {
                            myProductList.allMyProduct[index].userAsLiked = "Yes"
                        }
                        myProductList.allMyProduct[index].likes = totalLike.toString
                        let indexPath = IndexPath(item: index, section: 0)
                        if (myProductList.tblProductList.indexPathsForVisibleRows?.contains(indexPath))!{
                            myProductList.tblProductList.reloadRows(at: [indexPath], with: .none)
                        }
                    }
                    
                    guard let allProductList = myProductVC.allProductVC else {return}
                    if let index = allProductList.allProduct.index(where:{$0.productID == productId.toString}) {
                        if isLike == 0{
                            allProductList.allProduct[index].userAsLiked = "No"
                        }else {
                            allProductList.allProduct[index].userAsLiked = "Yes"
                        }
                        allProductList.allProduct[index].likes = totalLike.toString
                        let indexPath = IndexPath(item: index, section: 0)
                        if (allProductList.tblProductList.indexPathsForVisibleRows?.contains(indexPath))!{
                            allProductList.tblProductList.reloadRows(at: [indexPath], with: .none)
                        }
                    }
                }
            }
            if let searchProductVC = controller as? ProductSearchVC {
                DispatchQueue.main.async {
                    
                    guard let myProductList = searchProductVC.myProductVC else {return}
                    if let index = myProductList.allMyProduct.index(where:{$0.id == productId}) {
                        myProductList.allMyProduct[index].isLike = isLike
                        myProductList.allMyProduct[index].totalLike = totalLike
                        let indexPath = IndexPath(item: index, section: 0)
                        if (myProductList.tblProductList.indexPathsForVisibleRows?.contains(indexPath))!{
                            myProductList.tblProductList.reloadRows(at: [indexPath], with: .none)
                        }
                    }
                    
                    guard let allProductList = searchProductVC.allProductVC else {return}
                    if let index = allProductList.allProduct.index(where:{$0.id == productId}) {
                        allProductList.allProduct[index].isLike = isLike
                        allProductList.allProduct[index].totalLike = totalLike
                        let indexPath = IndexPath(item: index, section: 0)
                        if (allProductList.tblProductList.indexPathsForVisibleRows?.contains(indexPath))!{
                            allProductList.tblProductList.reloadRows(at: [indexPath], with: .none)
                        }
                    }
                }
            }
        }
    }
    
    class func updateProductData(product:MDLProduct, controller:UIViewController?, refreshCnt:[T.Type]) {
        
        for vc in refreshCnt{
            guard let controller = controller?.getViewControllerFromNavigation(vc)else {
                continue
            }
            
            if let myProductVC = controller as? StoreListVC {
                DispatchQueue.main.async {
                    
                    guard let myProductList = myProductVC.myProductVC else {return}
                    if let index = myProductList.allMyProduct.index(where:{$0.productID.toInt == product.productID.toInt}) {
                        //                        myProductList.allMyProduct.remove(at: index)
                        //                        myProductList.allMyProduct[index].productState = "No"
                        myProductList.allMyProduct[index].productState = "2"
                        
                        
                        //                        myProductList.allMyProduct.insert(product, at: index)
                        let indexPath = IndexPath(item: index, section: 0)
                        if (myProductList.tblProductList.indexPathsForVisibleRows?.contains(indexPath))!{
                            myProductList.tblProductList.reloadRows(at: [indexPath], with: .none)
                        }
                    }
                    
                    guard let allProductList = myProductVC.allProductVC else {return}
                    if let index = allProductList.allProduct.index(where:{$0.productID.toInt == product.productID.toInt}) {
                        allProductList.allProduct.remove(at: index)
                        allProductList.allProduct.insert(product, at: index)
                        let indexPath = IndexPath(item: index, section: 0)
                        if (allProductList.tblProductList.indexPathsForVisibleRows?.contains(indexPath))!{
                            allProductList.tblProductList.reloadRows(at: [indexPath], with: .none)
                        }
                    }
                }
            }
            if let searchProductVC = controller as? ProductSearchVC {
                DispatchQueue.main.async {
                    
                    guard let myProductList = searchProductVC.myProductVC else {return}
                    if let index = myProductList.allMyProduct.index(where:{$0.productID.toInt == product.productID.toInt}) {
                        myProductList.allMyProduct.remove(at: index)
                        myProductList.allMyProduct.insert(product, at: index)
                        let indexPath = IndexPath(item: index, section: 0)
                        if (myProductList.tblProductList.indexPathsForVisibleRows?.contains(indexPath))!{
                            myProductList.tblProductList.reloadRows(at: [indexPath], with: .none)
                        }
                    }
                    
                    guard let allProductList = searchProductVC.allProductVC else {return}
                    if let index = allProductList.allProduct.index(where:{$0.productID.toInt == product.productID.toInt}) {
                        allProductList.allProduct.remove(at: index)
                        allProductList.allProduct.insert(product, at: index)
                        let indexPath = IndexPath(item: index, section: 0)
                        if (allProductList.tblProductList.indexPathsForVisibleRows?.contains(indexPath))!{
                            allProductList.tblProductList.reloadRows(at: [indexPath], with: .none)
                        }
                    }
                }
            }
        }
    }
    
    class func updateProductDatacomments(product:MDLProduct,totalComment:String, controller:UIViewController?, refreshCnt:[T.Type]) {
        
        for vc in refreshCnt{
            guard let controller = controller?.getViewControllerFromNavigation(vc)else {
                continue
            }
            
            if let myProductVC = controller as? StoreListVC {
                DispatchQueue.main.async {
                    
                    guard let myProductList = myProductVC.myProductVC else {return}
                    if let index = myProductList.allMyProduct.index(where:{$0.productID.toInt == product.productID.toInt}) {
                        myProductList.allMyProduct[index].totalComments = totalComment
                        let indexPath = IndexPath(item: index, section: 0)
                        if (myProductList.tblProductList.indexPathsForVisibleRows?.contains(indexPath))!{
                            myProductList.tblProductList.reloadRows(at: [indexPath], with: .none)
                        }
                    }
                    
                    guard let allProductList = myProductVC.allProductVC else {return}
                    if let index = allProductList.allProduct.index(where:{$0.productID.toInt == product.productID.toInt}) {
                        allProductList.allProduct[index].totalComments = totalComment
                        let indexPath = IndexPath(item: index, section: 0)
                        if (allProductList.tblProductList.indexPathsForVisibleRows?.contains(indexPath))!{
                            allProductList.tblProductList.reloadRows(at: [indexPath], with: .none)
                        }
                    }
                }
            }
            if let searchProductVC = controller as? ProductSearchVC {
                DispatchQueue.main.async {
                    
                    guard let myProductList = searchProductVC.myProductVC else {return}
                    if let index = myProductList.allMyProduct.index(where:{$0.productID.toInt == product.productID.toInt}) {
                        myProductList.allMyProduct.remove(at: index)
                        myProductList.allMyProduct.insert(product, at: index)
                        let indexPath = IndexPath(item: index, section: 0)
                        if (myProductList.tblProductList.indexPathsForVisibleRows?.contains(indexPath))!{
                            myProductList.tblProductList.reloadRows(at: [indexPath], with: .none)
                        }
                    }
                    
                    guard let allProductList = searchProductVC.allProductVC else {return}
                    if let index = allProductList.allProduct.index(where:{$0.productID.toInt == product.productID.toInt}) {
                        allProductList.allProduct.remove(at: index)
                        allProductList.allProduct.insert(product, at: index)
                        let indexPath = IndexPath(item: index, section: 0)
                        if (allProductList.tblProductList.indexPathsForVisibleRows?.contains(indexPath))!{
                            allProductList.tblProductList.reloadRows(at: [indexPath], with: .none)
                        }
                    }
                }
            }
        }
    }
    
    
    
}
