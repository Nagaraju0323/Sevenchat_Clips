//
//  MIServiceManager.swift
//  SF-GenericAPIClass
//
//  Created by mac-00016 on 03/05/19.
//  Copyright © 2019 Mac-00016. All rights reserved.
//

//Please Go through the Instruction File to Follow The Monitoring steps of Api Responce diffrent cases.
import Foundation
import Alamofire
import ObjectMapper
import SystemConfiguration

//import NVActivityIndicatorView
let ServiceManager = MIServiceManager.shared

class MIServiceManager: NSObject {
    
    var request: Alamofire.Request? {
        didSet {
            oldValue?.cancel()
        }
    }
    
    var headers:[String: String]
    {
        if UserDefaults.standard.value(forKey: UserDefaultDeviceToken) != nil {
            
            if CUserDefaults.value(forKey: UserDefaultSelectedLangID) != nil {
                
                //...Get selected langauge detail from local
                let langID = CUserDefaults.value(forKey: UserDefaultSelectedLangID) as? Int
                let arrLang = TblLanguage.fetch(predicate: NSPredicate(format: "%K == %d", CLang_id, langID!), orderBy: CName, ascending: true)
                
                if (arrLang?.count)! > 0 {
                    let dict = arrLang![0] as! TblLanguage
                    return ["Authorization" : "Bearer \((CUserDefaults.value(forKey: UserDefaultDeviceToken)) as? String ?? "")","Content-Type" : "application/json", "Accept-Language" : dict.lang_code ?? "en", "language":"\(CUserDefaults.value(forKey: UserDefaultSelectedLangID) ?? 1)","Accept" : "application/json"]
                }
            }
            
            return ["Authorization" : "Bearer \((CUserDefaults.value(forKey: UserDefaultDeviceToken)) as? String ?? "")","Content-Type" : "application/json", "Accept-Language" : "en", "language":"1","Accept" : "application/json"]
            
        } else {
            
            if CUserDefaults.value(forKey: UserDefaultSelectedLangID) != nil {
                
                //...Get selected langauge detail from local
                let langID = CUserDefaults.value(forKey: UserDefaultSelectedLangID) as? Int
                let arrLang = TblLanguage.fetch(predicate: NSPredicate(format: "%K == %d", CLang_id, langID!), orderBy: CName, ascending: true)
                
                if (arrLang?.count)! > 0 {
                    let dict = arrLang![0] as! TblLanguage
                    return ["Accept" : "application/json", "Content-Type" : "application/json", "Accept-Language" : dict.lang_code ?? "en","language":"\(CUserDefaults.value(forKey: UserDefaultSelectedLangID) ?? 1)"]
                }
            }
            
            return ["Accept" : "application/json", "Content-Type" : "application/json", "Accept-Language" : "en","language":"1"]
        }
    }
    /*var headers: [String: String] {
        return ["Content-Type": "application/x-www-form-urlencoded"
            , "Token": ""
        ]
    }*/
    
    func checkForTheCurrentRequest(_ url: String) {
        Alamofire.SessionManager.default.session.getAllTasks { (tasks) in
            if tasks.count > 0 {
                for task in tasks {
                    if let str = task.originalRequest?.url?.absoluteString {
                        if str.localizedCaseInsensitiveContains(url){
                            task.cancel()
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - SHARED MANAGER
    static let shared = MIServiceManager()
    
    /**
     * Used for Post & Get API
     *
     * - parameter url: complete api url
     * - parameter isPost: if api is post than enter true
     * - parameter isLoaderRequired : if loader required than enter true
     * - parameter paramters : Enter`ed required parameter for API Call
     * - parameter successModel : It's a Generic parameter Type T which extends the Mappable Protocol.(Enter Model in which we want to feel success responce data)
     * - parameter failuerModel : It's a Generic parameter Type E which extends the Mappable Protocol.(Enter Model in which we want to feel failure responce data)
     * - parameter completion : return the filled SuccessModel in complition closure at that place where you called this function. If responce is failure than it return the filled FailureModel in completion closure at that place where you called this function
     */
    func callPostApi<T: Mappable, E: Mappable>(_ url: String, methodType : MethodType, isLoaderRequired: Bool, paramters: [String: Any]?, encoding: ParameterEncoding = URLEncoding.default, successModel: T.Type, failuerModel: E.Type, andCompletion completion: @escaping (T?,E?)->()) {
        
        return callApi(methodType, url: url, paramters: paramters, isLoaderRequired: isLoaderRequired, encoding: encoding, successModel : successModel, failuerModel: failuerModel, andCompletion: completion)
    }
    
    fileprivate func callApi<T: Mappable, E: Mappable>(_ methodType : MethodType, url: String, paramters: [String: Any]?, isLoaderRequired: Bool, encoding: ParameterEncoding = URLEncoding.default, successModel: T.Type, failuerModel: E.Type, andCompletion completion: @escaping (T?,E?)->()) {
        
        print("*************** URL : \(url) ***************** \n ************** PARAMTERS **************** \n \(paramters ?? [String:Any]()) \n ******* header : \(headers) ")
        
        
        Alamofire.request(url, method: HTTPMethod(rawValue: methodType.rawValue)!, parameters: paramters, encoding: encoding, headers: headers).responseJSON { (response) in
            
            // if Loader is activated before than, After getting responce stop the Loader...
            
            
            switch response.result {
            case .success(let JSON):
                
                guard let dictJSON = JSON as? [String:Any] else {
                    completion(nil, nil)
                    return
                }
                
                print("RESPONSE: \(dictJSON)")
                
                if let metaData = dictJSON["meta"] as? [String:Any] , metaData.count != 0 {
                    
                    let status_code: Int = metaData["code"] as? Int ?? 0
                    print("*************** status_code : \(status_code) ***************** \n")
                    completion(Mapper<T>().map(JSONObject: dictJSON),nil)
                } else if let status = dictJSON["status"] as? String {
                    //For Google Place
                    print("*************** status_code : \(status) ***************** \n")
                    completion(Mapper<T>().map(JSONObject: dictJSON),nil)
                } else {
                    //This else part is implemented specially for backend failure responce formate
                    let message = dictJSON["message"] as? String ?? ""
                    let status_code = dictJSON["code"] as? Int ?? 0
                    
                    print("*************** status_code : \(status_code ) ***************** \n *************** message : \(message) ***************** \n")                    
                }
            case .failure( _):
                print("Fail API : \(url)")
                completion(nil,nil)
            }
        }
    }
    
    
    // MARK: - Method Type
    enum MethodType: String {
        case GET = "GET"
        case POST = "POST"
        case PUT = "PUT"
        case DELETE = "DELETE"
    }
}
