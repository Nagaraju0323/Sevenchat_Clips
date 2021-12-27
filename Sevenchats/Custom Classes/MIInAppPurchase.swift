//
//  MIInAppPurchase.swift
//  eLegal
//
//  Created by mac-0005 on 11/04/18.
//  Copyright © 2018 Mac-0005. All rights reserved.
//

import StoreKit


public struct RageProducts {
    public static let sevenchatsyear = "com.sevenchats.yearlyadv"
    
    
    fileprivate static let productIdentifiers: Set<ProductIdentifier> = [RageProducts.sevenchatsyear]
    
    public static let store = MIInAppPurchase(productIds: RageProducts.productIdentifiers)
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
}

public typealias ProductIdentifier = String
public typealias PaymentCompletionHandler = (_ transactionState: SKPaymentTransactionState?,_ productObject : SKProduct?) -> ()

open class MIInAppPurchase : NSObject  {
    fileprivate let productIdentifiers: Set<ProductIdentifier>
    fileprivate var productsRequest: SKProductsRequest?
    fileprivate var arrProducts = [String: SKProduct]()
    fileprivate var configurePaymentCompletionHandler: PaymentCompletionHandler?
    
    
    public init(productIds: Set<ProductIdentifier>) {
        productIdentifiers = productIds
        super.init()
        SKPaymentQueue.default().add(self)
    }
}


// MARK: - StoreKit API -

extension MIInAppPurchase {
    
    public func buyProduct(_ product: SKProduct) {
        if canMakePayments() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        }
    }
    
    public func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    public func restorePurchases(_ completionHandler: @escaping PaymentCompletionHandler) {
        configurePaymentCompletionHandler = completionHandler
        
        if canMakePayments() {
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().restoreCompletedTransactions()
        }
    }
    
    public func prepareProductForBuy(productIDs : [String] , completionHandler: @escaping PaymentCompletionHandler) -> Void {
        
        configurePaymentCompletionHandler = completionHandler
        let productIdentifiers = Set(productIDs)
        
        /*let arrProductsId : [String] = [
            "com.sevenchats.5gbmonth",
            "com.sevenchats.5gbyear",
            "com.sevenchats.10gbmonth",
            "com.sevenchats.10gbyear"
        ]
        let productIdentifiers = Set(arrProductsId)
        */
        
        productsRequest?.cancel()
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest?.delegate = self
        productsRequest?.start()
    }
    
    public func getAppReceipt() {
        let receipturl = Bundle.main.appStoreReceiptURL
        
        guard let receiptURL = receipturl else {  /* receiptURL is nil, it would be very weird to end up here */  return }
        do {
            let receipt = try Data(contentsOf: receiptURL)
            validateAppReceipt(receipt)
        } catch {
            // there is no app receipt, don't panic, ask apple to refresh it
            let appReceiptRefreshRequest = SKReceiptRefreshRequest(receiptProperties: nil)
            appReceiptRefreshRequest.delegate = self
            appReceiptRefreshRequest.start()
            // If all goes well control will land in the requestDidFinish() delegate method.
            // If something bad happens control will land in didFailWithError.
        }
    }
    
    public func requestDidFinish(_ request: SKRequest) {
        
        let receiptURL = Bundle.main.appStoreReceiptURL
        
        // a fresh receipt should now be present at the url
        do {
            let receipt = try Data(contentsOf: receiptURL!) //force unwrap is safe here, control can't land here if receiptURL is nil
            validateAppReceipt(receipt)
        } catch {
            // still no receipt, possible but unlikely to occur since this is the "success" delegate method
        }
    }
    
    
    
    func validateAppReceipt(_ receipt: Data) {
        let receipturl = Bundle.main.appStoreReceiptURL
        
        let requestDictionary = ["receipt-data" : receipt.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)), "password" : "a6a21bfe5a9642fa88eb2ff1986e1454"]
        
        guard JSONSerialization.isValidJSONObject(requestDictionary) else {  print("requestDictionary is not valid JSON");  return }
        do {
            let requestData = try JSONSerialization.data(withJSONObject: requestDictionary)
            
            var validationURLString = "https://buy.itunes.apple.com/verifyReceipt"
            let sandbox = receipturl?.lastPathComponent == "sandboxReceipt"
            if (sandbox)
            {
                validationURLString = "https://sandbox.itunes.apple.com/verifyReceipt"
            }
            
            guard let validationURL = URL(string: validationURLString) else { print("the validation url could not be created, unlikely error"); return }
            //            let session = URLSession(configuration: URLSessionConfiguration.default)
            let session = URLSession.shared
            var request = URLRequest(url: validationURL)
            request.httpMethod = "POST"
            request.httpBody = requestData
            request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
            
            //            MIStrategyLoader.shared().showLoaderWithText("Cheking for IAP...")
            
            //            let task = session.dataTask(with: request) { (data, response, error) in
            //
            //            }
            
            
            
            //            let task = session.uploadTask(with: request, from: requestData) { (data, response, error) in
            let task = session.dataTask(with: request) { (data, response, error) in
                
                //                MIStrategyLoader.shared().hideLoader()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    if let data = data , error == nil {
                        do {
                            let appReceiptJSON = try JSONSerialization.jsonObject(with: data) as! [String : Any]
                            
                            if let dictLatestReceiptsInfo = appReceiptJSON["receipt"] as? [String : Any]
                            {
                                if let arrReciept = dictLatestReceiptsInfo["in_app"] as? [[String :Any]]
                                {
                                    let dicReceipt = arrReciept.last
                                    
                                    print("RECEIPT DATA =========== \(arrReciept)")
                                    
                                    CUserDefaults.set(dicReceipt, forKey: CIAPReceiptKey)
                                    CUserDefaults.synchronize()
                                    MIGeneralsAPI.shared().removeAdvertisement(transactionID: "abc")
                                    
                                }
                            }
                        } catch let error as NSError {
                            print("json serialization failed with error: \(error)")
                        }
                    } else {
                        print("the upload task returned an error: \(String(describing: error))")
                    }
                })
            }
            task.resume()
        } catch let error as NSError {
            print("json serialization failed with error: \(error)")
        }
    }
}

// MARK: - SKProductsRequestDelegate -

extension MIInAppPurchase: SKProductsRequestDelegate {
    
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        if response.products.count > 0 {
            let firstProduct = response.products[0]
            arrProducts[firstProduct.productIdentifier] = firstProduct
            
            // Request for but product here......
            self.buyProduct(firstProduct)
        }
        
        clearRequestAndHandler()
    }

    public func request(_ request: SKRequest, didFailWithError error: Error) {
        print(error.localizedDescription)
        clearRequestAndHandler()
    }

    private func clearRequestAndHandler() {
        productsRequest = nil
        
        if configurePaymentCompletionHandler != nil {
            configurePaymentCompletionHandler!(nil,nil)
        }
    }
}

// MARK: - SKPaymentTransactionObserver -

extension MIInAppPurchase: SKPaymentTransactionObserver {
    
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            switch (transaction.transactionState) {
            case .purchased:
                complete(transaction: transaction)
                break
            case .failed:
                fail(transaction: transaction)
                break
            case .restored:
                restore(transaction: transaction)
                break
            case .deferred:
                break
            case .purchasing:
                break
            }
            
            // call back here...
            
            let product = arrProducts[transaction.payment.productIdentifier]
            if configurePaymentCompletionHandler != nil {
                configurePaymentCompletionHandler!(transaction.transactionState,product)
            }
            
        }
        
    }
    
    private func complete(transaction: SKPaymentTransaction) {
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func restore(transaction: SKPaymentTransaction) {
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func fail(transaction: SKPaymentTransaction) {
        if let transactionError = transaction.error as NSError? {
            if transactionError.code != SKError.paymentCancelled.rawValue {
                print("Transaction Error: \(String(describing: transaction.error?.localizedDescription))")
            }
        }
        SKPaymentQueue.default().finishTransaction(transaction)
    }
}


//MARK:- InApp Purchase -

extension MIInAppPurchase {
    
    public func manageIAPState(_ viewController : UIViewController, _ transactionState: SKPaymentTransactionState,_ productObject : SKProduct!) {
        
        switch transactionState {
        case SKPaymentTransactionState.purchasing:
            break
            
        case SKPaymentTransactionState.purchased:
            RageProducts.store.getAppReceipt()
            // Show alert...
            MIToastAlert.shared.showToastAlert(position: MIToastAlert.MIToastAlertPosition.bottom, message: CIAPBySuccess)
            break
            
        case SKPaymentTransactionState.restored:
            RageProducts.store.getAppReceipt()
            // Show alert...
            MIToastAlert.shared.showToastAlert(position: MIToastAlert.MIToastAlertPosition.bottom, message: CIAPRestoreSuccess)
            break
            
        case SKPaymentTransactionState.failed:
            viewController.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CIAPError, btnOneTitle: CBtnOk, btnOneTapped: nil)
            break
            
        default:
            break
        }
    }
}
