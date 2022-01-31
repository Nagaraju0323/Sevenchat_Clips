//
//  APIRequest.swift
//  Social Media
//
//  Created by mac-0005 on 06/06/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : APIRequest                                  *
 * Description : All Api call                            *
 *                                                       *
 ********************************************************/

import Foundation
import UIKit
import Alamofire
import SDWebImage
import LGSideMenuController

//MARK:- ---------BASEURL __ TAG
/// Live
//var BASEURL: String          =   "http://dev1.sevenchats.com:2020/api/v1/"
////MARK: - Dev
var BASEURLNEW: String      =   "https://dev.sevenchats.com:8443/admin/"
let BASEMSGURL:String       =   "https://dev.sevenchats.com:4443/"
//////MARK: - CHAT
var BASEURLCHATLASTMSG: String   =  "https://dev.sevenchats.com:7443/"
//////MARK: - OTP
var BASEURLOTP: String     =   "https://dev.sevenchats.com:7443/"
var BASEEMAILOTP:String    =   "https://dev.sevenchats.com:7443/"
//////MARK: - AUTHENTICATION
var BASEAUTH:String         =   "http://dev.sevenchats.com:3001/"
//////MARK: - Notification
var BASEURLNOTIFICATION: String  = "http://dev.sevenchats.com:1924/"
var BASEURLSENDNOTIF : String  =  "http://dev.sevenchats.com:9480/"
//////MARK:- SockeIO key
let SocketIoUrl = "http://dev.sevenchats.com:8080/ws-chat/websocket"
//////MARK:- NotificationSocket
let BASEURLSOCKETNOTF: String = "ws://dev.sevenchats.com:1923"
let BASEURL_Rew: String = "Dev"


//////MARK:- MINIO
let BASEURLMINIO: String = "https://qa.sevenchats.com:3443"


//MARK: - QA
//var BASEURLNEW: String    =  "https://qa.sevenchats.com:8443/admin/"
//var BASEAUTH:String       =   "https://qa.sevenchats.com:7444/"
//var BASEURLNOTIFICATION: String  = "https://qa.sevenchats.com:7444/"
//var BASEURLSENDNOTIF : String  =  "https://qa.sevenchats.com:7444/"
//let SocketIoUrl : String = "https://qa.sevenchats.com:4443/ws-chat/websocket"
//var BASEURLCHATLASTMSG: String   =   "https://qa.sevenchats.com:7444/"
//let BASEMSGURL:String       =   "https://qa.sevenchats.com:4443/"
//var BASEURLOTP: String     =   "https://qa.sevenchats.com:7444/"
//var BASEEMAILOTP:String    =   "https://qa.sevenchats.com:7444/"
//let BASEURLSOCKETNOTF: String = "https://qa.sevenchats.com:2443/"
//let BASEURL_Rew: String = "QA"


let CAPIVesrion                     = "v1"
let CAPITagRelations                = "relations"
let CAPITagRelship                  = "relationships"
let CAPITagFeedbackList             = "feedback-list"

let CAPITagAnnualIncomes            = "annual-incomes"
let CAPITagEducations               = "educations"
let CAPITagCMS                      = "cms"
let CAPITagQuotes                   = "quotes/all"
let CAPITagSaveProfileImage         = "save-profile-image"
let CAPITagLogin                    = "login"
let CAPITagSocialLogin              = "social-login"
let CAPITagVerifyEmail              = "verify-email"
let CAPITagverifyEmailOTP           = "sendEmailOTP"
let CAPITagVerifyEditEmail          = "verify-edit-email"
let CAPITagVerifyMobile             = "verify-mobile"
let CAPITagVerifyMobileNew          = "sendOTP"
let CAPITagVerifyEditMobile         = "verify-edit-mobile"
let CAPITagVerifyEditMobileNew         = "sendOTP"
let CAPITagResetPassword            = "reset-password"
let CAPITagResendVerification       = "resend-verification"
let CAPITagResendEditVerification   = "edit-resend-verification-code"
let CAPITagForgotPassword           = "forgot-password"
let CAPITaglanguages                = "languages"
let CAPITagEditProfile              = "users/update"
let CAPITagUser                     = "user"
let CAPITagUsers                     = "users/id"
let CAPITagUsersDetails             = "user/details"
let CAPITagUsersMobileDetails       = "user/details/mobile"
let CAPITagUserNew                   = "users/"
let CAPITagUserBlockUnblock         = "user-block-unblock"
let CAPITagFriendStatus             = "friends/handleRequest"
let CAPITagGetFriendStatus             = "friendstatus"
let CAPITagConnectInviteStatus      = "connect-invite-status"
let CAPITagConnectAll               = "connect-all"
let CAPITagAddInterest              = "add-interest"
let CAPITagAddInterestRequest       = "add-interest-request"
let CAPITagInterests                = "interests"
let CAPITagProductcategory          = "productcategory"
let CAPITagCategoryType             = "categories/type/"
let CAPITagChangePassword           = "change-password"
let CAPITagChangeProfilePreferences = "change-profile-preferences"
let CAPITagChangeProfilePreferencesNew = "users/saveuserpreferences"
let CAPITagChangeNotificationStatus = "change-notification-status"
let CAPITagFavWeb = "fav-web"
let CAPITagCommentList = "comments"
let CAPITagAddComment = "add-comment"
let CAPITagDeleteComment = "delete-comment/"
let CAPITagLikeUnlike = "like-unlike"
let CAPITagEventInterest = "events/choice"
let CAPITagAdvertisementList = "advertisement-list"
let CAPITagDeviceToken = "device-token"
let CAPITagHomeSearch = "search-by-type1"
let CAPITagHomeSearchUsers = "users"
let CAPITagSearchUsers = "user/details/name"
let CAPITagSearchGroups = "search/group"
let CAPITagHomePosts = "postlisting/home"
let CAPITagHomePostsNew = "postlisting/"
let CAPITagUserPost = "user-post"
let CAPITagUserPostNew = "mypost/post"
let CAPITagUserPostFilter = "mypost/"
let CAPITagUserMyfriendList = "friends/myfriends"
let CAPITagFriendsList = "friends-list"
let CAPITagBlockUsers = "friends/block"
let CAPITagFriendOfFriends = "friendsOfFriends"
let CAPITagAddEditGroup = "add-edit-group"
let CAPITagAddEditGroupNew = "groups/add"
let CAPITagEditGroup = "groups/update"
let CAPITagMediaUpload = "media-upload"
let CAPITagAddPost = "add-post"
let CAPITagSaveGallery = "save-gallery"
let CAPITagReportUser = "report-user"
let CAPITagGroupsList = "groups-list"
let CAPITagUserChatList = "chatfriends/"
let CAPITagUserTopic = "api/createTopic"
let CAPITagUserChatDetails = "user-chat-details"
let CAPITagUserChatLstDetails = "api/getLastMessages"
let CAPITagGroupChatDetails = "group-chat-details"
let CAPITagReadUser = "read-user"
let CAPITagLikes = "likes/"
let CAPITagNotificationUnreadCount = "unread-count"
let CAPITagPendingGroupRequest = "pending-group-request"
let CAPITagGroupsDetail             = "group-details"
let CAPITagGroupsExit               = "exit-group"
let CAPITagGroupsExit_NEW           = "groups/remove"
let CAPITagGroupsDelete_NEW         = "groups/delete"
let CAPITagAddGroupMember           = "add-group-member"
let CAPITagAddGroupMember_New       = "groups/addmember"
let CAPITagRemoveGroupMember        = "remove-group-member"
let CAPITagRemoveGroupMemberNew     = "groups/remove"
let CAPITagDeleteGroup              = "delete-group"
let CAPITagGroupRequestStatus       = "group-request-status"
let CAPITagSearchGroup              = "search-group"
let CAPITagJoinGroup                = "join-group"
let CAPITagViewPost                 = "post"
let CAPITagPostDelete               = "post/delete"
let CAPITagEventCalendar            = "event-calendar"
let CAPITagRemovePostImage          = "remove-post-image"
let CAPITagDeletePost               = "post/delete"
let CAPITagEventDates               = "event-dates"
let CAPITagNewsCategory             = "news-category"
let CAPITagNewsCategoryNew          = "newscategories"
let CAPITagNews                     = "news"
let CAPITagNotificationList         = "notifications-list"
let CAPITagNotifications            = "notifications"
let CAPITagNotification             = "notification"
let CAPITagNotifier                 = "notifyUser"
let CAPITagReadNotifications        = "read-notifications"
let CAPITagRemoveAdvertisement      = "remove-advertisement"
let CAPITagVotePollsOption          = "polls/option"
let CAPITagVoteDetailsPollsList     = "polls/users"
let CAPITagVoteDetailsPolls         = "polls/details"
let CAPITagFolders      = "folders"
let CAPITagCreateFolder = "create-folder"
let CAPITagCreateFiles = "create-files"
let CAPITagDeleteFolder = "delete-folder"
let CAPITagFilesList = "view-folder"
let CAPITagRemoveShared = "remove-shared"
let CAPITagShareFolder = "share-folder"
let CAPITagSharedFriendList = "shared-friend-list"
let CUserStorage = "storage"
let CDeleteFile = "delete-file"
let CStoragePlan = "storage-plan"
let CUpgradeStorage = "upgrade-storage"
let CRestrictedFileType = "allowed-file-type"
let CCheckFilesExist = "check-files"
let CProductCategoriesList = "categories-list?"
let CProductCategoriesListNew = "categories"
let CProductCategories = "/type/Product"
let CAddEditProduct = "add-edit/product"
let CAddProductNew  = "products/add"
let CAddProductDetail  = "products/id"
let CEditProductNew = "products/update"
let CCurrencies = "currencies"
let CProductList = "product-list"
let CDeleteProduct = "product/delete/"
let CLikeUnlikeProduct = "like-product"
let CLikeUnlikeProducts = "likes/add"
let CLikeUnlikeProductCount = "likes/"
let CdeleteProduct = "products/delete/"
let CReportProduct = "report-product"
let CReportProductNew = "reportproduct/add"
let CProductDetail = "product-detail/"
let CSellerDetail = "seller-detail/"
let CContactSellerAPI = "contact-seller/"
let CMarkAsSoldAPI = "mark-as-sold/"
let CProductCommentListAPI = "product-comments-list/"
let CCommentOnProduct = "comment-product"
let CDeleteProductComment = "delete-product-comment/"
let CProductUserLikes = "product-likes/"
let CAPITagEventAttendees = "event-attendees"
let CAPITagGroupUserList = "group-users-list/"
let CAPITagWalletSummary = "wallet-summary"
let CAPITagWalletSummaryNew = "pointsconfigs"
let CAPITagWalletDetail = "wallet-detail"
let CAPITagForceUpdate = "force-update"
let CAPITagCloneFile = "clone-file"
let CAPITagCheckAutoDeleteStaus = "check-auto-delete-status"
let CEducation_Name      = "education_name"
let CAPITagAnnualIncome  = "incomes"
let CAPITagCountry       = "countries"
let CAPITagPointsConfigs   = "pointsconfigs"
let CAPITagRewardTypeCategory   = "categories/type/Rewards"
let CAPITagState         = "states/countries/"
let CAPITagCity          = "cities/states/"
let CAPITagSignUp        = "users/signup"
let CAPITagRegister      = "auth/login"
let CAPITagSaveProfileImg = "users/saveprofile"
let CAPITagFeedback = "feedbacks/add"
let CAPITagFavWebsites = "websites/all"
let CAPITagFavWebsitesNew = "websites/user/"
let CAPITagPSLWebsites = "websites/type/category"
let CAPITagReportUserNew = "reports/add"
let CAPITagarticles = "articles/add"
let CAPITagchirpies = "chirpies/add"
let CAPITagevents = "events/add"
let CAPITagforums = "forums/add"
let CAPITagshouts = "shouts/add"
let CAPITagsgallery = "galleries/add"
let CAPITagpolls = "polls/add"
let CProductListNew = "products"
let CPollUsers = "polls/users"
let CProductListusers = "products/user/"
let CProductListuser = "products/type/"
let CCurrenciesNew = "currencyconversion"
let CAPITagFriendsListNew = "friends/"
let CAPITagFriendsofFrd = "friends/"
let CAPITagChatMsg = "api/send"
let CAPITagGroupsListNew = "groups/user/"
let CProductCommentListAPINew = "comments/"
let CCommentOnProductnew = "comments/add"
let CCommentdelProductnew = "comments/delete"
let CAPITagSaveCoverImg = "users/savecover"
let CAPITagarticlesDelete = "articles/update"
let CAPITagchirpiesDelete = "chirpies/update"
let CAPITageventsDelete = "events/update"
let CAPITagforumsDelete = "forums/update"
let CAPITagshoutsDelete = "shouts/update"
let CAPITagsgalleryDelete = "galleries/update"
let CAPITagpollsDelete = "polls/update"
let CAPITagarticlesDetials = "articles/"
let CAPITagchirpiesDetials = "chirpies/"
let CAPITageventsDetials = "events/"
let CAPITagforumsDetials = "forums/"
let CAPITagshoutsDetials = "shouts/"
let CAPITagsgalleryDetials = "galleries/"
let CAPITagpollsDetials = "polls/details"
let CAPITagUserIdNew    = "users/id/"
let CAPITagGroups   = "groups/"
let CAPITFriendsList = "friends_list"
let CAPITsendOTP = "sendOTP"
let CAPITverifyMobileOTP = "verifyMobileOTP"
let CAPITrewardAdd = "rewards/add"
let CAPITagRewards = "rewards"
let CAPITagRewardUser = "rewards/users/"
let CAPITagPSLCategoryNew          = "categories/type/PSL"
let CProductMySearch = "search/product"
let CProductListSearch = "search/productpost"

let CJsonResponse           = "response"
let CJsonMessage            = "message"
let CJsonStatus             = "status"
let CStatusCode             = "status_code"
let CJsonTitle              = "title"
let CJsonData               = "data"
let CJsonMeta               = "meta"
let CJsonMessages           = "messages"

let CLimit                  = 7
let CLimitNew                  = "7"
let CLimitTT                  = 20
let CLimitTW                  = "20"
let CLimitS                  = "limit"

let CStatusZero             = 0
let CStatusZeros            = "0"
let CStatusOne              = 1
let CStatusTwo              = 2
let CStatusThree            = 3
let CStatusFour             = 4
let CStatusFive             = 5
let CStatusEight            = 8
let CStatusNine             = 9
let CStatusTen              = 10
let CStatusEleven           = 11
let CStatusTwelve           = 12

let CStatus200              = 200 // Success
let CStatus400              = 400 
let CStatus401              = 401 // Unauthorized
let CStatus500              = 500
let CStatus503              = 503
let CStatus550              = 550 // Inactive/Delete user
let CStatus555              = 555 // Invalid request
let CStatus556              = 556 // Invalid request
let CStatus1009             = -1009 // No Internet
let CStatus1005             = -1005 //Network connection lost
let CStatus405              = 405 // If user has been deleted

//MARK:- --------- Networking
//MARK:-
typealias ClosureSuccess = (_ task:URLSessionTask, _ response:AnyObject?) -> Void
typealias ClosureError   = (_ task:URLSessionTask, _ message:String?, _ error:NSError?) -> Void

class Networking: NSObject
{
    var BASEURL:String?
    var vwUnderMaintenance : MaintenanceView?
    
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
    
    var loggingEnabled = true
    var activityCount = 0
    var backroundSession = URLSessionConfiguration.background(withIdentifier: "com.sevenchats.app.backgroundtransfer")
    public var backgroundSessionManager : SessionManager!
    
    /// Networking Singleton
    static let sharedInstance = Networking.init()
    override init() {
        super.init()
        backroundSession.timeoutIntervalForResource = (60 * 10)
        backgroundSessionManager = Alamofire.SessionManager(configuration: backroundSession)
    }
    
    fileprivate func logging(request req:Request?) -> Void
    {
        if (loggingEnabled && req != nil)
        {
            var body:String = ""
            var length = 0
            
            if (req?.request?.httpBody != nil) {
                body = String.init(data: (req!.request!.httpBody)!, encoding: String.Encoding.utf8)!
                length = req!.request!.httpBody!.count
            }
            
            /*Oldcode Mi
             let printableString = "\(req!.request!.httpMethod!) '\(req!.request!.url!.absoluteString)': \(String(describing: req!.request!.allHTTPHeaderFields)) \(body) [\(length) bytes]"
             
             print("API Request: \(printableString)")
             
             */
        }
    }
    
    fileprivate func logging(response res:DataResponse<Any>?) -> Void
    {
        if (loggingEnabled && (res != nil))
        {
            if (res?.result.error != nil) {
                print("API Response: (\(String(describing: res?.response?.statusCode))) [\(String(describing: res?.timeline.totalDuration))s] Error:\(String(describing: res?.result.error))")
            } else {
                print("API Response: (\(String(describing: res?.response!.statusCode))) [\(String(describing: res?.timeline.totalDuration))s] Response:\(String(describing: res?.result.value))")
            }
        }
    }
}


//MARK:- ---------Networking Functions
//MARK:-
extension Networking {
    /// Uploading
    func upload( _ URLRequest: URLRequestConvertible, multipartFormData: (MultipartFormData) -> Void, encodingCompletion: ((SessionManager.MultipartFormDataEncodingResult) -> Void)?) -> Void {
        
        let formData = MultipartFormData()
        multipartFormData(formData)
        
        
        var URLRequestWithContentType = try? URLRequest.asURLRequest()
        
        URLRequestWithContentType?.setValue(formData.contentType, forHTTPHeaderField: "Content-Type")
        
        let fileManager = FileManager.default
        let tempDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory())
        let fileName = UUID().uuidString
        
        #if swift(>=2.3)
        let directoryURL = tempDirectoryURL.appendingPathComponent("com.alamofire.manager/multipart.form.data")
        let fileURL = directoryURL.appendingPathComponent(fileName)
        #else
        
        let directoryURL = tempDirectoryURL.appendingPathComponent("com.alamofire.manager/multipart.form.data")
        let fileURL = directoryURL.appendingPathComponent(fileName)
        #endif
        
        
        do {
            try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
            try formData.writeEncodedData(to: fileURL)
            
            DispatchQueue.main.async {
                
                let encodingResult = SessionManager.MultipartFormDataEncodingResult.success(request: SessionManager.default.upload(fileURL, with: URLRequestWithContentType!), streamingFromDisk: true, streamFileURL: fileURL)
                encodingCompletion?(encodingResult)
            }
        } catch {
            DispatchQueue.main.async {
                encodingCompletion?(.failure(error as NSError))
            }
        }
    }
    func GETNEWTest(apiTag tag:String, param parameters:[String: AnyObject]?, successBlock success:ClosureSuccess?,   failureBlock failure:ClosureError?) -> URLSessionTask? {
        let uRequest = SessionManager.default.request((tag), method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
        self.handleResponseStatus(uRequest: uRequest, success: success, failure: failure)
        return uRequest.task
    }
    
    func GETNEW(apiTag tag:String, param parameters:[String: AnyObject]?, successBlock success:ClosureSuccess?,   failureBlock failure:ClosureError?) -> URLSessionTask? {
        let uRequest = SessionManager.default.request((BASEURLNEW + tag), method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
        self.handleResponseStatus(uRequest: uRequest, success: success, failure: failure)
        return uRequest.task
    }
    
    func GETNEWPR(apiTag tag:String, param parameters:[String: AnyObject]?, successBlock success:ClosureSuccess?,   failureBlock failure:ClosureError?) -> URLSessionTask? {
        let uRequest = SessionManager.default.request((BASEURLNEW + tag), method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
        self.handleResponseStatus(uRequest: uRequest, success: success, failure: failure)
        return uRequest.task
    }
    
    func GETNEWPRNOTF(apiTag tag:String, param parameters:[String: AnyObject]?, successBlock success:ClosureSuccess?,   failureBlock failure:ClosureError?) -> URLSessionTask? {
        let uRequest = SessionManager.default.request((BASEURLNOTIFICATION + tag), method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
        self.handleResponseStatus(uRequest: uRequest, success: success, failure: failure)
        return uRequest.task
    }
    
    
    func GETNEWPRMSG(apiTag tag:String, param parameters:[String: AnyObject]?, successBlock success:ClosureSuccess?,   failureBlock failure:ClosureError?) -> URLSessionTask? {
        let uRequest = SessionManager.default.request((BASEURLCHATLASTMSG + tag), method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
        self.handleResponseStatus(uRequest: uRequest, success: success, failure: failure)
        return uRequest.task
    }
    
    
    func POSTJSON(apiTag tag:String, param parameters:[String: Any]?, successBlock success:ClosureSuccess?, failureBlock failure:ClosureError?, internalheaders: HTTPHeaders? = nil) -> URLSessionTask? {
        
        let parameterEncoding = JSONStringArrayEncoding.init(array: (parameters ?? [:]) as [String:Any])
        
        let uRequest = SessionManager.default.request((BASEURLNEW + tag), method: .post, parameters: nil, encoding: parameterEncoding, headers: internalheaders ?? headers)
        self.handleResponseStatus(uRequest: uRequest, success: success, failure: failure)
        return uRequest.task
    }
    
    func POSTJSONOTP(apiTag tag:String, param parameters:[String: Any]?, successBlock success:ClosureSuccess?, failureBlock failure:ClosureError?, internalheaders: HTTPHeaders? = nil) -> URLSessionTask? {
        
        let parameterEncoding = JSONStringArrayEncoding.init(array: (parameters ?? [:]) as [String:Any])
        
        let uRequest = SessionManager.default.request((BASEURLOTP + tag), method: .post, parameters: nil, encoding: parameterEncoding, headers: internalheaders ?? headers)
        self.handleResponseStatus(uRequest: uRequest, success: success, failure: failure)
        return uRequest.task
    }
    
    func POSTJSONOTPEmail(apiTag tag:String, param parameters:[String: Any]?, successBlock success:ClosureSuccess?, failureBlock failure:ClosureError?, internalheaders: HTTPHeaders? = nil) -> URLSessionTask? {
        
        let parameterEncoding = JSONStringArrayEncoding.init(array: (parameters ?? [:]) as [String:Any])
        
        let uRequest = SessionManager.default.request((BASEEMAILOTP + tag), method: .post, parameters: nil, encoding: parameterEncoding, headers: internalheaders ?? headers)
        self.handleResponseStatus(uRequest: uRequest, success: success, failure: failure)
        return uRequest.task
    }
    
    
    func POSTJSONMSG(apiTag tag:String, param parameters:[String: Any]?, successBlock success:ClosureSuccess?, failureBlock failure:ClosureError?, internalheaders: HTTPHeaders? = nil) -> URLSessionTask? {
        
        let parameterEncoding = JSONStringArrayEncoding.init(array: (parameters ?? [:]) as [String:Any])
        
        let uRequest = SessionManager.default.request((BASEMSGURL + tag), method: .post, parameters: nil, encoding: parameterEncoding, headers: internalheaders ?? headers)
        self.handleResponseStatus(uRequest: uRequest, success: success, failure: failure)
        return uRequest.task
    }
    
    func POSTPARA(apiTag tag:String, param parameters:[String: AnyObject]?, successBlock success:ClosureSuccess?, failureBlock failure:ClosureError?, internalheaders: HTTPHeaders? = nil) -> URLSessionTask? {
        let uRequest = SessionManager.default.request((BASEURLNEW + tag), method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: internalheaders ?? headers)
        self.handleResponseStatus(uRequest: uRequest, success: success, failure: failure)
        return uRequest.task
    }
    
    func POSTAUTH(apiTag tag:String, param parameters:[String: AnyObject]?, successBlock success:ClosureSuccess?, failureBlock failure:ClosureError?, internalheaders: HTTPHeaders? = nil) -> URLSessionTask? {
        let uRequest = SessionManager.default.request((BASEAUTH + tag), method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: internalheaders ?? headers)
        self.handleResponseStatus(uRequest: uRequest, success: success, failure: failure)
        return uRequest.task
    }
    
    func PUTJSON(apiTag tag:String, param parameters:[String: Any]?, successBlock success:ClosureSuccess?,   failureBlock failure:ClosureError?) -> URLSessionTask? {
        
        let parameterEncoding = JSONStringArrayEncoding.init(array: (parameters ?? [:]) as [String:Any])
        
        let uRequest = SessionManager.default.request(BASEURLNEW+tag, method: .put, parameters: parameters, encoding: parameterEncoding, headers: headers)
        self.handleResponseStatus(uRequest: uRequest, success: success, failure: failure)
        return uRequest.task!
    }
    
    
    func PUTJSONNOTF(apiTag tag:String, param parameters:[String: Any]?, successBlock success:ClosureSuccess?,   failureBlock failure:ClosureError?) -> URLSessionTask? {
        
        let parameterEncoding = JSONStringArrayEncoding.init(array: (parameters ?? [:]) as [String:Any])
        
        let uRequest = SessionManager.default.request(BASEURLNOTIFICATION+tag, method: .put, parameters: parameters, encoding: parameterEncoding, headers: headers)
        self.handleResponseStatus(uRequest: uRequest, success: success, failure: failure)
        return uRequest.task!
    }
    
    func POSTJSONNOTF(apiTag tag:String, param parameters:[String: Any]?, successBlock success:ClosureSuccess?, failureBlock failure:ClosureError?, internalheaders: HTTPHeaders? = nil) -> URLSessionTask? {
        
        let parameterEncoding = JSONStringArrayEncodings.init(array: (parameters ?? [:]) as [String:Any])
        
        
        let uRequest = SessionManager.default.request((BASEURLSENDNOTIF + tag), method: .post, parameters: nil, encoding: parameterEncoding, headers: internalheaders ?? headers)
        self.handleResponseStatus(uRequest: uRequest, success: success, failure: failure)
        return uRequest.task
    }
    func DELETENEW(apiTag tag:String,param parameters: [String: AnyObject]?, success : ClosureSuccess?, failure:ClosureError?) -> URLSessionTask {
        let uRequest = SessionManager.default.request(BASEURLNEW + tag, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: headers)
        self.handleResponseStatus(uRequest: uRequest, success: success, failure: failure)
        return uRequest.task!
    }
    
    func DELETJSON(apiTag tag:String, param parameters:[String: Any]?, successBlock success:ClosureSuccess?,   failureBlock failure:ClosureError?) -> URLSessionTask? {
        
        let parameterEncoding = JSONStringArrayEncoding.init(array: (parameters ?? [:]) as [String:Any])
        
        let uRequest = SessionManager.default.request(BASEURLNEW+tag, method: .delete, parameters: parameters, encoding: parameterEncoding, headers: headers)
        self.handleResponseStatus(uRequest: uRequest, success: success, failure: failure)
        return uRequest.task!
    }
    
    
    fileprivate func handleResponseStatus(uRequest:DataRequest , success : ClosureSuccess?, failure:ClosureError?) {
        
        self.logging(request: uRequest)
        uRequest.responseJSON { (response) in
            
            self.logging(response: response)
            if(response.result.error == nil && ([200, 201, 401] .contains(response.response!.statusCode)) ) {
                
                if self.vwUnderMaintenance != nil {
                    self.vwUnderMaintenance?.removeFromSuperview()
                    self.vwUnderMaintenance =  nil
                }
                
                if(success != nil) {
                    success!(uRequest.task!, response.result.value as AnyObject)
                }
            } else {
                if (response.response?.statusCode ?? 0) == 503 {
                    if self.vwUnderMaintenance == nil {
                        self.vwUnderMaintenance = MaintenanceView.viewFromXib as? MaintenanceView
                        self.vwUnderMaintenance?.frame = CGRect(x: 0, y: 0, width: CScreenWidth, height: CScreenHeight)
                        self.vwUnderMaintenance?.tag = 503
                        //vwUnderMaintenance?.removeFromSuperview()
                        appDelegate.window.addSubview(self.vwUnderMaintenance!)
                    }
                    return
                }
                if(failure != nil) {
                    
                    if response.result.error != nil {
                        print("error\(response.result.error as NSError? as Any)")
                        /* Oldcode by Mi
                         failure!(uRequest.task!,nil, response.result.error as NSError?)
                         */
                    }
                    else {
                        let dict = response.result.value as? [String : AnyObject]
                        let statusCode  = dict?.valueForInt(key: "status") ?? 0
                        guard let message = dict?.valueForString(key: "message") else {
                            return failure!(uRequest.task!,nil, nil)
                        }
                        let error = NSError(domain: "", code: statusCode, userInfo: dict)
                        failure!(uRequest.task!, message, error)
                    }
                    
                }
            }
        }
    }
}
//MARK:- ---------General
//MARK:-
class APIRequest: NSObject {
    
    typealias ClosureCompletion = (_ response:AnyObject?, _ error:NSError?) -> Void
    typealias successCallBack = (([String:AnyObject]?) -> ())
    typealias failureCallBack = ((String) -> ())
    
    private var isInvalidUserAlertDisplaying = false
    
    
    private override init() {
        super.init()
    }
    
    private static var apiRequest:APIRequest {
        let apiRequest = APIRequest()
        
        if (BASEURLNEW.count > 0 && !BASEURLNEW.hasSuffix("/")) {
            BASEURLNEW = BASEURLNEW + "/"
        }
        
        Networking.sharedInstance.BASEURL = BASEURLNEW
        
        return apiRequest
    }
    
    static func shared() -> APIRequest {
        return apiRequest
    }
    
    func isJSONDataValid(withResponse response: AnyObject!) -> Bool
    {
        if (response == nil) {
            return false
        }
        
        let data = response.value(forKey: CJsonData)
        
        if !(data != nil) {
            return false
        }
        
        if (data is String) {
            if ((data as? String)?.count ?? 0) == 0 {
                return false
            }
        }
        
        if (data is [Any]) {
            if (data as? [Any])?.count == 0 {
                return false
            }
        }
        
        return self.isJSONStatusValid(withResponse: response)
    }
    
    func isJSONStatusValid(withResponse response: AnyObject!) -> Bool {
        
        if response == nil {
            return false
        }
        
        let responseObject = response as? [String : AnyObject]
        
        if let meta = responseObject?[CJsonMeta]  as? [String : AnyObject] {
            
            if meta.valueForString(key: CStatusCode).toInt == CStatus200  {
                return  true
            } else {
                return false
            }
        }
        
        if  responseObject?.valueForString(key: CStatusCode).toInt == CStatus200 {
            return  true
        } else {
            return false
        }
    }
    
    
    func checkResponseStatusAndShowAlert(showAlert:Bool, responseobject: AnyObject?, strApiTag:String) -> Bool
    {
        //MILoader.shared.hideLoader()
        
        if let meta = responseobject?.value(forKey: CJsonMeta) as? [String : Any] {
            
            switch meta.valueForInt(key: CJsonStatus) {
            case CStatusOne:
                let message = meta.valueForString(key: CJsonMessage)
                GCDMainThread.async {
                    let topVC = CTopMostViewController
                    topVC.presentAlertViewWithOneButton(alertTitle: "", alertMessage: message, btnOneTitle: CBtnOk) { (alert) in
                        if let sideMenuVC = UIApplication.shared.keyWindow?.rootViewController as? LGSideMenuController {
                            if sideMenuVC.rootViewController is UINavigationController, let navigation = sideMenuVC.rootViewController as? UINavigationController {
                                navigation.popViewController(animated: true)
                            } else if sideMenuVC.rootViewController != nil{
                                sideMenuVC.rootViewController?.navigationController?.popToRootViewController(animated: true)
                            }
                        }
                    }
                }
                return false
                
            case CStatusZero:
                return true
                
            case CStatusFour:
                return true
                
            case CStatusTen : //register from admin
                return true
                
            case CStatus200 : //register from admin
                return true
                
            case CStatus500 : //register from admin
                return true
                
            case CStatus503:
                return false
                
            case CStatusTwelve:
                
                let isAppLaunchHere = CUserDefaults.value(forKey: UserDefaultIsAppLaunchHere) as? Bool ?? true
                if isAppLaunchHere {
                    CUserDefaults.set(false, forKey: UserDefaultIsAppLaunchHere)
                    CUserDefaults.synchronize()
                    appDelegate.initHomeViewController()
                }
                return false
            default:
                if showAlert {
                    let message = meta.valueForString(key: CJsonMessage)
                    GCDMainThread.async {
                        CTopMostViewController.presentAlertViewWithOneButton(alertTitle: "", alertMessage: message, btnOneTitle: CBtnOk, btnOneTapped: nil)
                    }
                }
            }
        } else {
            if let status = responseobject?.value(forKey: "status") as? Int{
                if status == 401 || status == 405 {
                    let token = (CUserDefaults.value(forKey: UserDefaultDeviceToken)) as? String ?? ""
                    if !token.isBlank{
                        appDelegate.logOut()
                    }
                }
            }
        }
        
        
        return false
    }
    
    
    func actionOnAPIFailure(errorMessage:String?, showAlert:Bool, strApiTag:String,error:NSError?) -> Void {
        
        guard  let errorUserinfo = error?.userInfo["error"] as? String else {return}
        let errorMsg = errorUserinfo.stringAfter(":")
        if showAlert && errorMessage != nil{
            //            MIAlertController().present(CTopMostViewController, title: "", message: appDelegate.fetchAppropriateMessage(key: errorMessage!))
            //            CTopMostViewController.presentAlertViewWithOneButton(alertTitle: "", alertMessage: errorMsg, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }
        print("API Error =" + "\(strApiTag )" + "\(String(describing: error?.localizedDescription))" )
    }
    
}

//MARK:- ---------API Functions

extension APIRequest {
    //TODO:
    //TODO: --------------GENERAL API--------------
    //TODO:
    func getLanguageList(showLoader : Bool, completion : @escaping ClosureCompletion) {
        
        if showLoader {
            MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: CMessagePleaseWait)
        }
        
        _ = Networking.sharedInstance.GETNEW(apiTag:CAPITaglanguages, param: [:], successBlock: { (task, response) in
            MILoader.shared.hideLoader()
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITaglanguages){
                self.storeLanguageList(response: response as! [String : AnyObject])
                completion(response, nil)
            }
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITaglanguages, error: error)
            }
        })
    }
    
    func loadLanguagesText(completion : @escaping ClosureCompletion) {
        MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: CMessagePleaseWait)
        let langID = CUserDefaults.value(forKey: UserDefaultSelectedLangID) as! Int
        let langName = CUserDefaults.value(forKey: UserDefaultSelectedLang) as! String
        
        _ = Networking.sharedInstance.GETNEW(apiTag: "\(CAPITaglanguages)/\(langID)", param: [:], successBlock: { (task, response) in
            
            MILoader.shared.hideLoader()
            //            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITaglanguages){
            DispatchQueue.main.async {
                if langName == "English"{
                    let url = Bundle.main.url(forResource: "English", withExtension: "json")!
                    let data = try! Data(contentsOf: url)
                    let JSON = try! JSONSerialization.jsonObject(with: data, options: [])
                    self.storeLanguageText(response: JSON as! [String : AnyObject])
                } else if langName == "Kannada" {
                    let url = Bundle.main.url(forResource: "Kannada", withExtension: "json")!
                    let data = try! Data(contentsOf: url)
                    let JSON = try! JSONSerialization.jsonObject(with: data, options: [])
                    print("JSON\(JSON)")
                    self.storeLanguageText(response: JSON as! [String : AnyObject])
                }else if langName == "Hindi" {
                    let url = Bundle.main.url(forResource: "Hindi", withExtension: "json")!
                    let data = try! Data(contentsOf: url)
                    let JSON = try! JSONSerialization.jsonObject(with: data, options: [])
                    print("JSON\(JSON)")
                    self.storeLanguageText(response: JSON as! [String : AnyObject])
                }
                //                    self.storeLanguageText(response: response as! [String : AnyObject])
                completion(response, nil)
            }
            //            }
            
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITaglanguages, error: error)
            }
        })
    }
    
    func countryList(timestamp : AnyObject, completion: @escaping ClosureCompletion) {
        
        _ = Networking.sharedInstance.GETNEW(apiTag: CAPITagCountry, param: ["timestamp":timestamp], successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagCountry){
                self.storeCountryInLocal(response: response as! [String : AnyObject])
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.countryList(timestamp: timestamp, completion: completion)
            }
        })
    }
    
    func loadPointsConfigs(timestamp : AnyObject, completion: @escaping ClosureCompletion) {
        
        _ = Networking.sharedInstance.GETNEW(apiTag: CAPITagPointsConfigs, param: ["timestamp":timestamp], successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagCountry){
                self.storePointsConfigsInLocal(response: response as! [String : AnyObject])
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.loadPointsConfigs(timestamp: timestamp, completion: completion)
            }
        })
    }
    
    
    func loadRewardsCategory(timestamp : AnyObject, completion: @escaping ClosureCompletion) {
        
        _ = Networking.sharedInstance.GETNEW(apiTag: CAPITagRewardTypeCategory, param: ["timestamp":timestamp], successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagCountry){
                self.storeRewardCategoryInLocal(response: response as! [String : AnyObject])
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.loadPointsConfigs(timestamp: timestamp, completion: completion)
            }
        })
    }
    
    func stateList(timestamp : AnyObject, countryID: String, completion: @escaping ClosureCompletion) -> URLSessionTask?{
        let countryName = countryID.replace(string: " ", replacement: "%20")
        return Networking.sharedInstance.GETNEW(apiTag: CAPITagState + countryName , param:nil, successBlock: { (task, response) in
            //MILoader.shared.hideLoader()
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagState){
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            //MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                //self.countryList(timestamp: timestamp, completion: completion)
            }
        })
    }
    
    func cityList(timestamp : AnyObject, stateId : String, completion: @escaping ClosureCompletion) -> URLSessionTask?{
        
        let stateName = stateId.replace(string: " ", replacement: "%20")
        return Networking.sharedInstance.GETNEW(apiTag: CAPITagCity + stateName, param:nil, successBlock: { (task, response) in
            MILoader.shared.hideLoader()
            completion(response, nil)
            //            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagCity){
            //
            //            }
            
        }, failureBlock: { (task, message, error) in
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                //self.countryList(timestamp: timestamp, completion: completion)
            }
        })
    }
    
    func getRelationList (completion : @escaping ClosureCompletion) {
        
        _ = Networking.sharedInstance.GETNEW(apiTag: CAPITagRelship, param: [:], successBlock: { (task, response) in
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagRelations){
                self.storeRelationList(response : response as! [String : AnyObject])
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.getRelationList(completion: completion)
            }
        })
    }
    
    func getAnnualIncomeList(completion : @escaping ClosureCompletion) {
        
        _ = Networking.sharedInstance.GETNEW(apiTag: CAPITagAnnualIncome, param: [:], successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagAnnualIncomes) {
                self.storeAnnualIncome(response: response as! [String : AnyObject])
                completion(response, nil)
            }
        }, failureBlock: { (task, message, error) in
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.getAnnualIncomeList(completion: completion)
            }
        })
    }
    
    func getEducationList(completion : @escaping ClosureCompletion) {
        
        _ = Networking.sharedInstance.GETNEW(apiTag: CAPITagEducations, param: [:], successBlock: { (task, response) in
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagEducations) {
                self.storeEducationList(response: response as! [String : AnyObject])
                completion(response, nil)
            }
        }, failureBlock: { (task, message, error) in
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.getEducationList(completion: completion)
            }
        })
    }
    
    func loadCMS(completion : @escaping ClosureCompletion) {
        
        MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        
        _ = Networking.sharedInstance.GETNEW(apiTag: CAPITagCMS, param: nil, successBlock: { (task, response) in
            
            MILoader.shared.hideLoader()
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagCMS) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagCMS, error: error)
            }
        })
    }
    
    
    func loadQuotes(page : Int?, shouldShowLoader : Bool?, completion : @escaping ClosureCompletion) -> URLSessionTask {
        
        if shouldShowLoader!{
            MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        }
        return Networking.sharedInstance.GETNEWPR(apiTag: CAPITagQuotes, param: [CPage : page as AnyObject, CPer_limit : CLimit as AnyObject], successBlock: { (task, response) in
            
            MILoader.shared.hideLoader()
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagQuotes) {
                completion (response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagQuotes, error: error)
            }
        })!
    }
    
    //TODO:
    //TODO: --------------INTEREST API--------------
    //TODO:
    
    func getInterestListNew(search : String?,langName : String?, type : Int?, page : Int?, showLoader : Bool, completion : @escaping ClosureCompletion) -> URLSessionTask {
        if showLoader {
            MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        }
        let pages = page?.toString
        let CLimits = CLimitNew
        var para = [ String : Any]()
        para[CPage] = pages
        para[CPer_limit] = CLimits
        if langName != nil{
            para["lang_name"] = langName
        }
        return Networking.sharedInstance.GETNEWPR(apiTag: CAPITagInterests, param: para as [String : AnyObject], successBlock: { (task, response) in
            
            MILoader.shared.hideLoader()
            self.storeInterestInLocal(response: response as! [String : AnyObject])
            completion(response, nil)
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert:true, strApiTag: CAPITagInterests, error: error)
            }
        })!
        
    }
    /********************************************************
     * Author :  Chandrika R                                 *
     * Model   : Category Postlist                          *
     * option                                                *
     ********************************************************/
    
    func getInterestListArticle(articleType : String?,langName : String?, type : Int?, page : Int?, showLoader : Bool, completion : @escaping ClosureCompletion) -> URLSessionTask {
        if showLoader {
            MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        }
        let tag = CAPITagCategoryType + articleType!
        
        return Networking.sharedInstance.GETNEW(apiTag: tag, param: nil, successBlock: { (task, response) in
            
            MILoader.shared.hideLoader()
            self.storeArticleInLocal(response: response as! [String : AnyObject])
            completion(response, nil)
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert:true, strApiTag: CAPITagInterests, error: error)
            }
        })!
    }
    
    
    func getInterestListChiripy(articleType : String?,langName : String?, type : Int?, page : Int?, showLoader : Bool, completion : @escaping ClosureCompletion) -> URLSessionTask {
        if showLoader {
            MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        }
        let tag = CAPITagCategoryType + articleType!
        
        return Networking.sharedInstance.GETNEW(apiTag: tag, param: nil, successBlock: { (task, response) in
            
            MILoader.shared.hideLoader()
            self.storeArticleInChirpy(response: response as! [String : AnyObject])
            completion(response, nil)
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert:true, strApiTag: CAPITagInterests, error: error)
            }
        })!
    }
    
    func getInterestListEvent(articleType : String?,langName : String?, type : Int?, page : Int?, showLoader : Bool, completion : @escaping ClosureCompletion) -> URLSessionTask {
        if showLoader {
            MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        }
        let tag = CAPITagCategoryType + articleType!
        
        return Networking.sharedInstance.GETNEW(apiTag: tag, param: nil, successBlock: { (task, response) in
            
            MILoader.shared.hideLoader()
            self.storeArticleInEvent(response: response as! [String : AnyObject])
            completion(response, nil)
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert:true, strApiTag: CAPITagInterests, error: error)
            }
        })!
    }
    
    func getInterestListForum(articleType : String?,langName : String?, type : Int?, page : Int?, showLoader : Bool, completion : @escaping ClosureCompletion) -> URLSessionTask {
        if showLoader {
            MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        }
        let tag = CAPITagCategoryType + articleType!
        
        return Networking.sharedInstance.GETNEW(apiTag: tag, param: nil, successBlock: { (task, response) in
            
            MILoader.shared.hideLoader()
            self.storeArticleInForum(response: response as! [String : AnyObject])
            completion(response, nil)
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert:true, strApiTag: CAPITagInterests, error: error)
            }
        })!
    }
    
    func getInterestListGallery(articleType : String?,langName : String?, type : Int?, page : Int?, showLoader : Bool, completion : @escaping ClosureCompletion) -> URLSessionTask {
        if showLoader {
            MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        }
        let tag = CAPITagCategoryType + articleType!
        
        return Networking.sharedInstance.GETNEW(apiTag: tag, param: nil, successBlock: { (task, response) in
            
            MILoader.shared.hideLoader()
            self.storeArticleInGallery(response: response as! [String : AnyObject])
            completion(response, nil)
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert:true, strApiTag: CAPITagInterests, error: error)
            }
        })!
    }
    
    func getInterestListPoll(articleType : String?,langName : String?, type : Int?, page : Int?, showLoader : Bool, completion : @escaping ClosureCompletion) -> URLSessionTask {
        if showLoader {
            MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        }
        let tag = CAPITagCategoryType + articleType!
        
        return Networking.sharedInstance.GETNEW(apiTag: tag, param: nil, successBlock: { (task, response) in
            
            MILoader.shared.hideLoader()
            self.storeArticleInPoll(response: response as! [String : AnyObject])
            completion(response, nil)
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert:true, strApiTag: CAPITagInterests, error: error)
            }
        })!
    }
    
    func getInterestSubListNew(langName : String?, interestType:String?, page : Int?, showLoader : Bool, completion : @escaping ClosureCompletion) -> URLSessionTask {
        
        if showLoader {
            MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        }
        
        var para = [ String : Any]()
        if interestType != nil{
            para["category_type"] = interestType
            para["lang_name"] = langName
        }
        
        return Networking.sharedInstance.GETNEWPR(apiTag: CAPITagProductcategory, param: para as [String : AnyObject], successBlock: { (task, response) in
            MILoader.shared.hideLoader()
            //            self.storeSubInterestInLocal(response: response as! [String : AnyObject])
            completion(response, nil)
            //            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagInterests) {
            self.storeProductSubCategoryInLocal(response: response as! [String : AnyObject])
            //                completion(response, nil)
            //            }
            
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert:true, strApiTag: CAPITagInterests, error: error)
            }
        })!
        
    }
    
    func loginUser(dict : [String : AnyObject], completion : @escaping ClosureCompletion){
        MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        _ = Networking.sharedInstance.POSTJSON(apiTag: CAPITagLogin, param: dict, successBlock: { (task, response) in
            MILoader.shared.hideLoader()
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagLogin){
                
                if let metaData = response?.value(forKey: CJsonMeta) as? [String : AnyObject] {
                    if metaData.valueForString(key: CJsonStatus) == CStatusZeros {
                        self.saveUserDetail(response: response as! [String : AnyObject])
                    }
                }
                completion(response, nil)
            }
            if let metaData = response?.value(forKey: CJsonMeta) as? [String : AnyObject] {
                
                if metaData.valueForInt(key: CJsonStatus) == CStatusZero {
                    self.saveUserDetail(response: response as! [String : AnyObject])
                    CUserDefaults.set(true, forKey: UserDefaultIsAppLaunchHere)
                    CUserDefaults.synchronize()
                    completion(response, nil)
                } else if  metaData.valueForInt(key: CJsonStatus) == CStatusTwelve {
                    self.saveUserDetail(response: response as! [String : AnyObject])
                    CUserDefaults.set(false, forKey: UserDefaultIsAppLaunchHere)
                    CUserDefaults.synchronize()
                    completion(response, nil)
                    
                } else if  metaData.valueForInt(key: CJsonStatus) == CStatusTen || metaData.valueForInt(key: CJsonStatus) == CStatusFour {
                    completion(response, nil)
                } else {
                    let message = metaData.valueForString(key: CJsonMessage)
                    GCDMainThread.async {
                        CTopMostViewController.presentAlertViewWithOneButton(alertTitle: "", alertMessage: message, btnOneTitle: CBtnOk, btnOneTapped: nil)
                    }
                }
            }
            
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagLogin, error: error)
            }
        })
    }
    
    func loadUserDetailsList(searchText:String,showLoader : Bool, completion: @escaping ClosureCompletion ) -> URLSessionTask?{
        
        if showLoader{
            MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        }
        //let apiTag = CProductCategoriesList + "search=" + searchText
        let param : [String : Any] = [
            "search" : searchText
        ]
        return Networking.sharedInstance.GETNEW(apiTag: CAPITagUserNew, param:param as [String : AnyObject], successBlock: { (task, reponse) in
            MILoader.shared.hideLoader()
            completion(reponse, nil)
            
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagDeleteFolder, error: error)
            }
        })
    }
    func userDetails(para:[String:AnyObject], completion : @escaping ClosureCompletion) {
        
        _ = Networking.sharedInstance.GETNEWPR(apiTag: CAPITagUsersDetails, param: para , successBlock: { (task, response) in
            
            MILoader.shared.hideLoader()
            let isAppLaunchHere = CUserDefaults.value(forKey: UserDefaultIsAppLaunchHere) as? Bool ?? true
            guard let metaData = response?.value(forKey: CJsonMeta) as? [String : Any] else {
                completion(nil, nil)
                return
            }
            guard let _response = response as? [String : AnyObject] else {
                completion(nil, nil)
                return
            }
            
            guard let responseData = _response.valueForJSON(key: CJsonData) as? [[String : AnyObject]] else {
                completion(_response as AnyObject, nil)
                return
            }
            for response in responseData{
                self.saveUserDetail(response: _response)
                if (response.valueForString(key: "user_id")) == appDelegate.loginUser?.user_id.description {
                    self.saveUserDetail(response: _response)
                }
            }
            
            if metaData.valueForString(key: CJsonStatus) == CStatusZeros && !isAppLaunchHere {
                CUserDefaults.set(true, forKey: UserDefaultIsAppLaunchHere)
                CUserDefaults.synchronize()
                appDelegate.initHomeViewController()
            }
            completion(response, nil)
            
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagUser, error: error)
            }
        })
    }
    
    func userDetailsMobile(para:[String:AnyObject], completion : @escaping ClosureCompletion) {
        
        _ = Networking.sharedInstance.GETNEWPR(apiTag: CAPITagUsersMobileDetails, param: para , successBlock: { (task, response) in
            
            MILoader.shared.hideLoader()
            let isAppLaunchHere = CUserDefaults.value(forKey: UserDefaultIsAppLaunchHere) as? Bool ?? true
            guard let metaData = response?.value(forKey: CJsonMeta) as? [String : Any] else {
                completion(nil, nil)
                return
            }
            guard let _response = response as? [String : AnyObject] else {
                completion(nil, nil)
                return
            }
            
            guard let responseData = _response.valueForJSON(key: CJsonData) as? [[String : AnyObject]] else {
                completion(_response as AnyObject, nil)
                return
            }
            for response in responseData{
                self.saveUserDetail(response: _response)
                if (response.valueForString(key: "user_id")) == appDelegate.loginUser?.user_id.description {
                    self.saveUserDetail(response: _response)
                }
            }
            
            if metaData.valueForString(key: CJsonStatus) == CStatusZeros && !isAppLaunchHere {
                CUserDefaults.set(true, forKey: UserDefaultIsAppLaunchHere)
                CUserDefaults.synchronize()
                appDelegate.initHomeViewController()
            }
            completion(response, nil)
            
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagUser, error: error)
            }
        })
    }
    
    func userDetailNew(userID : String, apiKeyCall: String, completion : @escaping ClosureCompletion) {
        
        var apiTag = ""
        if CAPITagUserNew == apiKeyCall {
            apiTag = CAPITagUserNew + userID.description
        } else if CAPITagUserIdNew == apiKeyCall {
            apiTag = CAPITagUserIdNew + userID.description
        }
        _ = Networking.sharedInstance.GETNEW(apiTag: apiTag, param: nil, successBlock: { (task, response) in
            
            MILoader.shared.hideLoader()
            let isAppLaunchHere = CUserDefaults.value(forKey: UserDefaultIsAppLaunchHere) as? Bool ?? true
            guard let metaData = response?.value(forKey: CJsonMeta) as? [String : Any] else {
                completion(nil, nil)
                return
            }
            guard let _response = response as? [String : AnyObject] else {
                completion(nil, nil)
                return
            }
            guard let responseData = _response.valueForJSON(key: CJsonData) as? [String : AnyObject] else {
                completion(_response as AnyObject, nil)
                return
            }
            
            if metaData.valueForInt(key: CJsonStatus) == CStatusZero && !isAppLaunchHere {
                CUserDefaults.set(true, forKey: UserDefaultIsAppLaunchHere)
                CUserDefaults.synchronize()
                appDelegate.initHomeViewController()
            }
            
            completion(response, nil)
            
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagUser, error: error)
            }
        })
    }
    
    
    func signUpUser(dict : [String : AnyObject], completion : @escaping ClosureCompletion) {
        
        MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        
        _ = Networking.sharedInstance.POSTJSON(apiTag: CAPITagSignUp, param: dict, successBlock: { (task, response) in
            
            MILoader.shared.hideLoader()
            completion(response, nil)
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagSignUp, error: error)
            }
        })
        
    }
    func uploadUserProfile(userID : Int, para: [String : Any],profileImgName:String, completion : @escaping ClosureCompletion){
        MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        _ = Networking.sharedInstance.PUTJSON(apiTag:CAPITagSaveProfileImg , param: para, successBlock: { (task, response) in
            MILoader.shared.hideLoader()
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagSaveProfileImg) {
                appDelegate.loginUser?.profile_img = profileImgName
                CoreData.saveContext()
                completion(response, nil)
            }
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagSaveProfileImg, error: error)
            }
        })
    }
    
    func uploadUserCover(dict : [String : AnyObject],coverImage:String, completion : @escaping ClosureCompletion){
        
        MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        
        _ = Networking.sharedInstance.PUTJSON(apiTag:CAPITagSaveCoverImg , param: dict, successBlock: { (task, response) in
            
            MILoader.shared.hideLoader()
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagSaveCoverImg){
                appDelegate.loginUser?.cover_image = coverImage
                CoreData.saveContext()
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagSaveCoverImg, error: error)
            }
        })
        
    }
    
    func verifyEmail(api:String, email : String,verifyCode : String, completion : @escaping ClosureCompletion) {
        
        MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        
        var dict = [String:Any]()
        dict["to"] = email
        
        
        _ = Networking.sharedInstance.POSTJSONOTPEmail(apiTag: api, param: dict as [String:AnyObject], successBlock: { (task, response) in
            completion(response, nil)
            MILoader.shared.hideLoader()
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagVerifyEmail) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagVerifyEmail, error: error)
            }
        })
    }
    
    func verifyMobile(api: String, email : String, mobile : String, completion : @escaping ClosureCompletion) {
        
        let para : [String:Any]  =
            [
                "to":mobile.description
            ]
        _ = Networking.sharedInstance.POSTJSONOTP(apiTag: CAPITagVerifyEditMobileNew, param: para, successBlock: { (task, response) in
            
            completion(response, nil)
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagVerifyMobile, error: error)
            }
        })
    }
    //MARK:-
    func blockUnblockUserNew(userID : String?,block_unblock_status : String?, completion : @escaping ClosureCompletion) {
        MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        let para :[String:Any]  =  [
            "user_id": appDelegate.loginUser?.user_id ?? "",
            "friend_user_id": userID?.description ?? "",
            "request_type": block_unblock_status?.description ?? ""
        ]
        // _ = Networking.sharedInstance.POST(apiTag: CAPITagUserBlockUnblock, param: [CUserId : userID as AnyObject, CBlock_unblock_status : block_unblock_status as AnyObject], successBlock: { (task, response) in
        _ = Networking.sharedInstance.POSTJSON(apiTag: CAPITagFriendStatus, param: para, successBlock: { (task, response) in
            MILoader.shared.hideLoader()
            completion(response, nil)
            //            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagUserBlockUnblock) {
            //                completion(response, nil)
            //            }
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagFriendStatus, error: error)
            }
        })
    }
    func friendRquestStatus(dict : Any, completion : @escaping ClosureCompletion) {
        
        //           MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        print(dict)
        _ = Networking.sharedInstance.POSTPARA(apiTag: CAPITagFriendStatus, param: dict as? [String : AnyObject], successBlock: { (task, response) in
            MILoader.shared.hideLoader()
            completion(response, nil)
            
        }, failureBlock: { (task, message, error) in
            completion(nil, error)
        })
    }
    
//MARK:- FRIENDS STATUS
    func getFriendStatus(dict : Any, completion : @escaping ClosureCompletion) {

        print(dict)
        _ = Networking.sharedInstance.POSTPARA(apiTag: CAPITagGetFriendStatus, param: dict as? [String : AnyObject], successBlock: { (task, response) in
            MILoader.shared.hideLoader()
            completion(response, nil)
            
        }, failureBlock: { (task, message, error) in
            completion(nil, error)
        })
    }
    
    func getFriendList(page : Int?,request_type : Int?, search : String?,group_id : Int?, showLoader : Bool, completion : @escaping ClosureCompletion) -> URLSessionTask {
        
        var  ApiTag = CAPITagFriendsofFrd
        switch request_type {
        case 0:
            ApiTag = CAPITagFriendsofFrd  + "myfriends"
        case 1:
            ApiTag = CAPITagFriendsofFrd  + "request"
        case 2:
            ApiTag = CAPITagFriendsofFrd  + "pending"
        default:
            print("defauts:::::::")
        }
        var para = [String : Any]()
        para[CPage] = page?.description
        para[CPer_limit] = CLimitTW
        para["user_id"] = group_id?.description
        
        
        if showLoader {
            MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        }
        
        return Networking.sharedInstance.GETNEWPR(apiTag: ApiTag, param: para as [String : AnyObject], successBlock: { (task, response) in
            completion(response, nil)
            //            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagFriendsList) {
            MILoader.shared.hideLoader()
            
            //            }
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert:true, strApiTag: CAPITagFriendsList, error: error)
            }
        })!
    }
    func getFriendListNew(page : Int?,request_type : Int?, search : String?,group_id : Int?, showLoader : Bool, completion : @escaping ClosureCompletion) -> URLSessionTask {
        
        if showLoader {
            MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        }
        
        let Userid = "/245788816"
        return Networking.sharedInstance.GETNEW(apiTag: CAPITagFriendsListNew + Userid, param: nil, successBlock: { (task, response) in
            
            MILoader.shared.hideLoader()
            //            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagFavWeb) {
            //                completion(response, nil)
            //            }
            completion(response, nil)
            
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert:true, strApiTag: CAPITagFavWeb, error: error)
            }
        })!
        
    }
    func getChatFriendsAdd(user_id:String?,friend_user_id:String?, completion : @escaping ClosureCompletion) -> URLSessionTask {
        
        var dict = [String:Any]()
        dict[CUserId] = user_id
        dict[CFriendID] = friend_user_id
        dict[CFriend_status] = "1"
        
        MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        return Networking.sharedInstance.POSTJSON(apiTag: CAPITagUserChatList + "add", param: dict, successBlock: { (task, response) in
            MILoader.shared.hideLoader()
            //            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagFavWeb) {
            //                completion(response, nil)
            //            }
            completion(response, nil)
            
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert:true, strApiTag: CAPITagFavWeb, error: error)
            }
        })!
        
    }
    func ChatFriendsTopicCrt(TopicName:String?, completion : @escaping ClosureCompletion) -> URLSessionTask {
        
        var dict = [String:Any]()
        dict["topic"] = TopicName
        
        MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        return Networking.sharedInstance.POSTJSONMSG(apiTag: CAPITagUserTopic , param: dict, successBlock: { (task, response) in
            MILoader.shared.hideLoader()
            //            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagFavWeb) {
            //                completion(response, nil)
            //            }
            completion(response, nil)
            
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert:true, strApiTag: CAPITagUserTopic, error: error)
            }
        })!
        
    }
    
    func getOtherUserFriendListNew(user_id : String?, completion : @escaping ClosureCompletion) -> URLSessionTask{
        var para = [String : Any]()
        para["user_id"] = appDelegate.loginUser?.user_id.description
        para["friend_user_id"] = user_id
        para["limit"] = CLimitTW
        para["page"] = "1"
        
        return Networking.sharedInstance.GETNEWPR(apiTag: CAPITagFriendOfFriends, param: para as [String : AnyObject], successBlock: { (task, response) in
            
            //  return Networking.sharedInstance.POSTJSON(apiTag: CAPITagFriendOfFriends, param: para as [String : AnyObject],successBlock: { (task, response) in
            completion(response, nil)
            
        }, failureBlock: { (task, message, error) in
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert:true, strApiTag: CAPITagFriendOfFriends, error: error)
            }
        })!
    }
    
    
    func getOtherUserFriendList(page : Int?, user_id : Int?, search : String?, completion : @escaping ClosureCompletion) -> URLSessionTask{
        
        var para = [String : Any]()
        para["user_id"] = "40996976"
        para["friend_user_id"] = "4288"
        
        if search != nil && !(search?.isBlank)!{
            para["search"] = search
        }
        return Networking.sharedInstance.POSTJSON(apiTag: CAPITagFriendOfFriends, param: para as [String : AnyObject],successBlock: { (task, response) in
            completion(response, nil)
        }, failureBlock: { (task, message, error) in
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert:true, strApiTag: CAPITagFriendOfFriends, error: error)
            }
        })!
    }
    
    //TODO:
    //TODO: --------------SETTING API--------------
    //TODO:
    
    func editProfile (dict : [String : AnyObject],para : [String : AnyObject],userID:String,dob:String, completion : @escaping ClosureCompletion) {
        
        var arrList = [[String:Any]]() //array of dictionaries
        arrList.removeAll()
        arrList.append(contentsOf: [para])
        let jsonData = try? JSONSerialization.data(withJSONObject: arrList, options: .prettyPrinted)
        let parsedObject = try! JSONSerialization.jsonObject(with: jsonData!, options: .allowFragments)
        var userDetails = [String : AnyObject]()
        userDetails["data"] = parsedObject as AnyObject
        let jsonDataconvert = try? JSONSerialization.data(withJSONObject: userDetails, options: .prettyPrinted)
        let parsedObjectchange = try! JSONSerialization.jsonObject(with: jsonDataconvert!, options: .allowFragments)
        MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        
        _ = Networking.sharedInstance.PUTJSON(apiTag:CAPITagEditProfile , param: dict, successBlock: { (task, response) in
            MILoader.shared.hideLoader()
            if let metaData = response?.value(forKey: CJsonMeta) as? [String : AnyObject] {
                
                if metaData.valueForString(key: CJsonStatus) == "0" {
                    self.saveUserDetail(response: parsedObjectchange as! [String : AnyObject])
                    //CUserDefaults.set(true, forKey: UserDefaultIsAppLaunchHere)
                    //CUserDefaults.synchronize()
                    completion(response, nil)
                } else if  metaData.valueForInt(key: CJsonStatus) == CStatusTwelve {
                    self.saveUserDetail(response: userDetails )
                    //CUserDefaults.set(false, forKey: UserDefaultIsAppLaunchHere)
                    //CUserDefaults.synchronize()
                    completion(response, nil)
                } else {
                    let message = metaData.valueForString(key: CJsonMessage)
                    GCDMainThread.async {
                        CTopMostViewController.presentAlertViewWithOneButton(alertTitle: "", alertMessage: message, btnOneTitle: CBtnOk, btnOneTapped: nil)
                    }
                }
            }
            
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagEditProfile, error: error)
            }
        })
    }
    
    func changeProfilePreferencesNew(profileDetials : [String:Any], completion : @escaping ClosureCompletion) {
        _ = Networking.sharedInstance.PUTJSON(apiTag:CAPITagChangeProfilePreferencesNew , param: profileDetials, successBlock: { (task, response) in
            completion(response, nil)
        }, failureBlock: { (task, message, error) in
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagChangeProfilePreferencesNew, error: error)
            }
        })
    }
    
    func getBlockUserList(page : Int?, search : String?, showLoader : Bool, completion : @escaping ClosureCompletion) -> URLSessionTask {
        
        if showLoader {
            MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        }
        
        let dict : [String:Any]  =  [
            "user_id": appDelegate.loginUser?.user_id.description ?? "",
            "limit" : CLimitTW,
            "page": page?.description ?? ""
        ]
        return Networking.sharedInstance.GETNEWPR(apiTag: CAPITagBlockUsers, param: dict as [String : AnyObject], successBlock: { (task, response) in
            MILoader.shared.hideLoader()
            completion(response, nil)
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert:true, strApiTag: CAPITagBlockUsers, error: error)
            }
        })!
    }
    //TODO:
    //TODO: --------------HOME APIS --------------
    //TODO:
    
    
    //MARK:-
    func getPostListNew(page : Int?,user_id : Int?,search_type : String?, completion : @escaping ClosureCompletion) -> URLSessionTask {
        
        var para = [String : Any]()
        para[CPage] = page
        para[CPer_page] = CLimit
        
        if user_id != nil{
            para[CUserId] = user_id
        }
        
        if search_type != nil{
            para[CSearchType] = search_type
        }
        
        let dict : [String:Any]  =  [
            "user_id":user_id?.description as Any,
            "post_type" : search_type as Any
            
            
        ]
        return Networking.sharedInstance.GETNEWPR(apiTag: CAPITagHomePostsNew, param: dict as [String : AnyObject], successBlock: { (task, response) in
            completion(response, nil)
        }, failureBlock: { (task, message, error) in
            completion(nil, error)
            if error?.code == CStatus405{
                //           appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert:true, strApiTag: CAPITagHomePostsNew, error: error)
            }
        })!
    }
    func getPostList(userID:Int,page : Int?,filter : [[String : Any]]?, showLoader : Bool, completion : @escaping ClosureCompletion) -> URLSessionTask {
        
        var para = [String : Any]()
        para[CPage] = page
        para[CPer_page] = CLimit
        
        if filter != nil{
            para[CFilterPost] = filter
        }
        var dict = [String:Any] ()
        dict[CUserId] = userID.description
        dict[CPage] = page?.description
        dict[CPer_limit] = CLimitTT.description
        return Networking.sharedInstance.GETNEWPR(apiTag: CAPITagHomePosts, param: dict as [String : AnyObject], successBlock: { (task, response) in
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagUserPost) {
                completion(response, nil)
            }
        }, failureBlock: { (task, message, error) in
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert:true, strApiTag: CAPITagHomePosts, error: error)
            }
        })!
    }
    //----------------------------------------NEW CODE----------------------------------------------
    func getMyfriendList(page : Int?,user_id : Int?,search_type : String?, completion : @escaping ClosureCompletion) -> URLSessionTask {
        
        let dict : [String:Any]  =  [
            "user_id":user_id?.description as Any,
            "page" : page as Any,
            "limit" : CLimitTW]
        return Networking.sharedInstance.GETNEWPR(apiTag: CAPITagUserMyfriendList, param: dict as [String : AnyObject], successBlock: { (task, response) in
            completion(response, nil)
            self.saveUserFriendsDetails(response: response as! [String:AnyObject])
        }, failureBlock: { (task, message, error) in
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert:true, strApiTag: CAPITagUserPostNew, error: error)
            }
        })!
    }
    
    //MARK:- New Filter API
    func getUserPostListNew(page : Int?,user_id : Int?,search_type : String?, completion : @escaping ClosureCompletion) -> URLSessionTask {
        
        var para = [String : Any]()
        para[CPage] = page
        para[CPer_page] = CLimit
        
        if user_id != nil{
            para[CUserId] = user_id
        }
        if search_type != nil{
            para[CSearchType] = search_type
        }
        let dict : [String:Any]  =  [
            "user_id":user_id?.description as Any,
            "post_type" : search_type
        ]
        return Networking.sharedInstance.GETNEWPR(apiTag: CAPITagUserPostFilter, param: dict as [String : AnyObject], successBlock: { (task, response) in
            completion(response, nil)
        }, failureBlock: { (task, message, error) in
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert:true, strApiTag: CAPITagUserPostFilter, error: error)
            }
        })!
    }
    
    func getUserPostList(page : Int?,user_id : Int?,search_type : String?, completion : @escaping ClosureCompletion) -> URLSessionTask {
        
        var para = [String : Any]()
        para[CPage] = page
        para[CPer_page] = CLimit
        
        if user_id != nil{
            para[CUserId] = user_id
        }
        
        if search_type != nil{
            para[CSearchType] = search_type
        }
        
        let dict : [String:Any]  =  [
            "user_id":user_id?.description as Any,
            "page" : page as Any,
            "limit" : CLimit
            
        ]
        return Networking.sharedInstance.GETNEWPR(apiTag: CAPITagUserPostNew, param: dict as [String : AnyObject], successBlock: { (task, response) in
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagUserPost) {
                completion(response, nil)
            }
        }, failureBlock: { (task, message, error) in
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert:true, strApiTag: CAPITagUserPostNew, error: error)
            }
        })!
    }
    
    
    func userSearchDetail(Param:[String:Any], completion : @escaping ClosureCompletion) {
        _ = Networking.sharedInstance.GETNEWPR(apiTag: CAPITagSearchUsers, param: Param as [String : AnyObject], successBlock: { (task, response) in
            MILoader.shared.hideLoader()
            completion(response, nil)
        },failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert:true, strApiTag: CAPITagViewPost, error: error)
            }
        })
    }
    
    //========================================NEWCODE==========================================
    
    func viewPostDetailNew(postID : Int,apiKeyCall: String, completion : @escaping ClosureCompletion) {
        MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        
        var CAPITagurl = ""
        if CAPITagarticlesDetials == apiKeyCall || CAPITagchirpiesDetials == apiKeyCall || CAPITageventsDetials == apiKeyCall  || CAPITagforumsDetials == apiKeyCall || CAPITagsgalleryDetials == apiKeyCall || CAPITagpollsDetials == apiKeyCall  || CAPITagshoutsDetials == apiKeyCall{
            CAPITagurl = apiKeyCall
        }
        
        let apiTag = CAPITagurl + postID.toString
        
        _ = Networking.sharedInstance.GETNEW(apiTag: apiTag, param: nil, successBlock: { (task, response) in
            MILoader.shared.hideLoader()
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: apiTag) {
                //                    self.saveUserDetail(response: response as! [String : AnyObject])
                completion(response, nil)
            }
        },failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert:true, strApiTag: CAPITagViewPost, error: error)
            }
        })
    }
    func viewPollDetailNew(postID : Int, completion : @escaping ClosureCompletion) {
        var para = [String:Any]()
        para["id"] =  postID.toString
        
        _ = Networking.sharedInstance.GETNEWPR(apiTag: CAPITagpollsDetials, param: para as [String : AnyObject], successBlock: { (task, response) in
            MILoader.shared.hideLoader()
            completion(response, nil)
        },failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert:true, strApiTag: CAPITagViewPost, error: error)
            }
        })
    }
    
    //MARK:- NEW Delete Code
    func deletePostNew(postDetials : [String:Any],apiKeyCall: String, completion : @escaping ClosureCompletion) {
        MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        var CAPITagurl = ""
        if apiKeyCall == "post_article"{
            CAPITagurl = CAPITagarticlesDelete
        }else if apiKeyCall == "post_gallery"{
            CAPITagurl = CAPITagsgalleryDelete
        }else if apiKeyCall == "post_chirpy"{
            CAPITagurl = CAPITagchirpiesDelete
        }else if apiKeyCall == "post_shout"{
            CAPITagurl = CAPITagshoutsDelete
        }else if apiKeyCall == "post_forum"{
            CAPITagurl = CAPITagforumsDelete
        }else if apiKeyCall == "post_event"{
            CAPITagurl = CAPITageventsDelete
        }else if apiKeyCall == "post_poll"{
            CAPITagurl = CAPITagpollsDelete
        }
        
        let  Apitag = CAPITagurl
        _ = Networking.sharedInstance.PUTJSON(apiTag:Apitag , param: postDetials, successBlock: { (task, response) in
            
            MILoader.shared.hideLoader()
            completion(response, nil)
            
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagurl, error: error)
            }
        })
    }
    func addEditPost(para : [String : Any], image : UIImage?,apiKeyCall: String, completion : @escaping ClosureCompletion) {
        MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        print("print\(para)")
        var CAPITagurl = ""
        if CAPITagarticles == apiKeyCall || CAPITagchirpies == apiKeyCall || CAPITagevents == apiKeyCall  || CAPITagforums == apiKeyCall || CAPITagsgallery == apiKeyCall || CAPITagpolls == apiKeyCall  || CAPITagshouts == apiKeyCall{
            CAPITagurl = apiKeyCall
        }
        
        _ = Networking.sharedInstance.POSTJSON(apiTag: CAPITagurl, param: para, successBlock: { (task, response) in
            MILoader.shared.hideLoader()
            
            self.saveUserDetail(response: response as! [String : AnyObject])
            completion(response, nil)
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagurl, error: error)
            }
        })
    }
    
    //TODO:
    //TODO: --------------OTO CHAT APIS --------------
    //TODO:
    func getUserChatList(timestamp : Double?,userID:String, showLoader : Bool, completion : @escaping ClosureCompletion) -> URLSessionTask {
        
        if showLoader {
            MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        }
        let apiTag = CAPITagUserChatList + userID
        
        return Networking.sharedInstance.GETNEW(apiTag: apiTag, param: [CTimestamp : timestamp as AnyObject], successBlock: { (task, response) in
            
            MILoader.shared.hideLoader()
            if self.checkResponseStatusAndShowAlert(showAlert: false, responseobject: response, strApiTag: CAPITagUserChatList) {
                self.storeUserChatList(response: response as! [String : Any])
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert:true, strApiTag: CAPITagUserChatList, error: error)
            }
        })!
        
    }
    
    func userMesageListNew (chanelID:String, completion: @escaping ClosureCompletion) -> URLSessionTask? {
        var dict = [String:Any]()
        dict["topic"] = chanelID
        
        return Networking.sharedInstance.GETNEWPRMSG(apiTag: CAPITagUserChatLstDetails, param: dict as AnyObject as? [String : AnyObject], successBlock: { (task, response) in
            completion (response, nil)
        }, failureBlock: { (task, message, error) in
            completion (nil, error)
        })
    }
    
    //TODO:
    //TODO: --------------SocetIO Send Messages APIS --------------
    //TODO:
    
    func userSentMsg(dict:[String:Any], completion: @escaping ClosureCompletion) -> URLSessionTask? {
        return Networking.sharedInstance.POSTJSONMSG(apiTag: CAPITagChatMsg, param:dict, successBlock: { (task, response) in
            
            completion (response, nil)
        }, failureBlock: { (task, message, error) in
            completion (nil, error)
        })
    }
    
    //TODO: --------------CHAT GROUPS APIS --------------
    
    func chatMessagePost(para : [String : Any], showLoader:Bool, completion : @escaping ClosureCompletion) {
        
        MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        
        let _ = Networking.sharedInstance.POSTJSONMSG(apiTag: CAPITagChatMsg, param: para, successBlock: { (task, response) in
            //                MILoader.shared.hideLoader()
            completion(response, nil)
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagReportUserNew) {
                completion(response, nil)
            }else{
                completion(nil, nil)
            }
        }, failureBlock: { (task, message, error) in
            completion(nil, error)
            MILoader.shared.hideLoader()
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert:true, strApiTag: CAPITagReportUserNew, error: error)
            }
        })
    }
    
    //TODO:
    //TODO: --------------CHAT GROUPS APIS --------------
    //TODO:
    
 //MARK:- SEARCH GROUP
    func groupSearchDetail(Param:[String:Any], completion : @escaping ClosureCompletion) {
        _ = Networking.sharedInstance.GETNEWPR(apiTag: CAPITagSearchGroups, param: Param as [String : AnyObject], successBlock: { (task, response) in
            MILoader.shared.hideLoader()
            completion(response, nil)
        },failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert:true, strApiTag: CAPITagSearchGroups, error: error)
            }
        })
    }
    
    
    
    func getGroupChatList(timestamp : Double?, search : String, showLoader : Bool, completion : @escaping ClosureCompletion) -> URLSessionTask {
        
        if showLoader {
            MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        }
        
        let param: [String:Any] = [
            "search" : search,
            CTimestamp : timestamp ?? 0
        ]
        
        
        return Networking.sharedInstance.GETNEW(apiTag: CAPITagGroupsListNew + search, param: nil, successBlock: { (task, response) in
            
            MILoader.shared.hideLoader()
            
            self.storeGroupChatList(response: response as! [String : Any])
            completion(response, nil)
            
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert:true, strApiTag: CAPITagGroupsListNew, error: error)
            }
        })!
        
    }
    
    func groupDetail(group_id : String?,shouldShowLoader : Bool, completion : @escaping ClosureCompletion) {
        if shouldShowLoader{
            MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        }
        var ApiTag = CAPITagGroups
        if group_id != nil {
            ApiTag += group_id!
        }
        
        _ = Networking.sharedInstance.GETNEW(apiTag: ApiTag, param: nil, successBlock: { (task, response) in
            MILoader.shared.hideLoader()
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagGroupsDetail) {
                completion(response, nil)
            }
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert:true, strApiTag: CAPITagGroupsDetail, error: error)
            }
        })
    }
    
    func exitGroup(group_id : String?,user_id : String?,user_type : Int, completion : @escaping ClosureCompletion) {
        var para = [String : Any]()
        
        if user_id != nil{
            para[Cuser_id] = user_id?.description
        }
        if group_id != nil{
            para[CGroupId] = group_id
        }
        var apiTagSelect = ""
        if user_type == 1{
            apiTagSelect = CAPITagGroupsDelete_NEW
        }else{
            apiTagSelect = CAPITagGroupsExit_NEW
        }
        
        MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        
        _ = Networking.sharedInstance.PUTJSON(apiTag: apiTagSelect, param: para, successBlock: { (task, response) in
            MILoader.shared.hideLoader()
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagGroupsExit) {
                completion(response, nil)
            }
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert:true, strApiTag: CAPITagGroupsExit, error: error)
            }
        })
    }
    
    func addMemberInGroup(group_id : Int?, group_users_id : String?,frdsList:[String], completion : @escaping ClosureCompletion) {
        MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        
        var para = [String : Any]()
        
        if group_users_id != nil{
            
            para[CGroupId] = group_id?.description
        }
        
        if group_id != nil{
            para["friends_list"] = frdsList
        }
        
        _ = Networking.sharedInstance.PUTJSON(apiTag: CAPITagAddGroupMember_New, param: para, successBlock: { (task, response) in
            MILoader.shared.hideLoader()
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagAddGroupMember) {
                completion(response, nil)
            }
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert:true, strApiTag: CAPITagAddGroupMember, error: error)
            }
        })
    }
    
    func removeMemberFromGroup(group_id : Int?, group_users_id : String?, completion : @escaping ClosureCompletion) {
        
        var para = [String : Any]()
        if group_users_id != nil{
            para[Cuser_id] = group_users_id?.description
        }
        if group_id != nil{
            para[CGroupId] = group_id?.description
        }
        
        MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        
        _ = Networking.sharedInstance.PUTJSON(apiTag: CAPITagRemoveGroupMemberNew, param: para, successBlock: { (task, response) in
            MILoader.shared.hideLoader()
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagRemoveGroupMember) {
                completion(response, nil)
            }
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert:true, strApiTag: CAPITagRemoveGroupMember, error: error)
            }
        })
    }
    func addEditChatGroup(para : [String : Any],image : UIImage?, completion : @escaping ClosureCompletion) {
        
        print("::::::::\(para)")
        MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        
        _ = Networking.sharedInstance.POSTJSON(apiTag: CAPITagAddEditGroupNew, param: para, successBlock: { (task, response) in
            
            MILoader.shared.hideLoader()
            completion(response, nil)
            
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagAddEditGroup, error: error)
            }
        })
    }
    
    func EditChatGroup(para : [String : Any],image : UIImage?, completion : @escaping ClosureCompletion) {
        
        MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        _ = Networking.sharedInstance.PUTJSON(apiTag: CAPITagEditGroup, param: para, successBlock: { (task, response) in
            
            MILoader.shared.hideLoader()
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagAddEditGroup){
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagAddEditGroup, error: error)
            }
        })
    }
    func getNewsCategory(completion: @escaping ClosureCompletion) {
        
        _ = Networking.sharedInstance.GETNEW(apiTag: CAPITagNewsCategoryNew, param: nil, successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagNewsCategory) {
                self.storeNewsCategory(response: response as! [String : AnyObject])
                completion(response, nil)
            }
        }, failureBlock: { (task, message, error) in
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagNewsCategory, error: error)
            }
        })
    }
    
//MARK:-
    func getPslCategory(completion: @escaping ClosureCompletion) {
        
        _ = Networking.sharedInstance.GETNEW(apiTag: CAPITagPSLCategoryNew, param: nil, successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagNewsCategory) {
                self.storPSLCategory(response: response as! [String : AnyObject])
                completion(response, nil)
            }
        }, failureBlock: { (task, message, error) in
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagNewsCategory, error: error)
            }
        })
    }
    
    func getPSLList(para : [String:Any], completion: @escaping ClosureCompletion) -> URLSessionTask {
        
        return Networking.sharedInstance.GETNEWPR(apiTag: CAPITagPSLWebsites, param: para as AnyObject as? [String : AnyObject], successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagPSLWebsites) {
                completion(response, nil)
            }else{
                completion(nil, nil)
            }
        }, failureBlock: { (task, message, error) in
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagPSLWebsites, error: error)
            }
        })!
    }
    
    func getNewsList(pagerNumber:String?,country:String?,language:String?,categoryID:String?, completion: @escaping ClosureCompletion) -> URLSessionTask {
       
        var para = [String:Any]()
        para["page"] = pagerNumber
        para ["limit"] = "20"
        para[Ccountry] = country
        para[Clanguage] = language
        para[Ccategory] = categoryID

        
        return Networking.sharedInstance.GETNEWPR(apiTag: CAPITagNews, param: para as AnyObject as? [String : AnyObject], successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagNews) {
                completion(response, nil)
            }else{
                completion(nil, nil)
            }
        }, failureBlock: { (task, message, error) in
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagNews, error: error)
            }
        })!
    }
    
//    func getPSLList(page : Int?,type : String?, showLoader : Bool,userId:String, completion: @escaping ClosureCompletion) -> URLSessionTask {
//
//        if showLoader {
//            MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
//        }
//        let apiTag = CAPITagPSLWebsites + type!
//        return Networking.sharedInstance.GETNEW(apiTag: apiTag, param: nil, successBlock: { (task, response) in
//
//            MILoader.shared.hideLoader()
//            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagFavWebsitesNew) {
//                completion(response, nil)
//            }
//        }, failureBlock: { (task, message, error) in
//            completion(nil, error)
//            if error?.code == CStatus405{
//                appDelegate.logOut()
//            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
//            } else {
//                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagFavWebsitesNew, error: error)
//            }
//        })!
//    }
    
    //TODO:
    //TODO: --------------FAV WEBSITE --------------
    //TODO:
    func getFavWebSiteList(page : Int?,type : String?, showLoader : Bool,userId:String, completion : @escaping ClosureCompletion) -> URLSessionTask {
        
        if showLoader {
            MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        }
        let apiTag = CAPITagFavWebsitesNew + userId
        var para = [String : Any]()
        para[CPage] = page
        para[CPer_limit] = CLimitNew
        para[CType] = type
        
        return Networking.sharedInstance.GETNEWPR(apiTag: apiTag, param: para as [String : AnyObject], successBlock: { (task, response) in
            
            MILoader.shared.hideLoader()
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagFavWeb) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert:true, strApiTag: CAPITagFavWeb, error: error)
            }
        })!
        
    }
    
    
    //TODO:
    //TODO: --------------GENERAL APIS --------------
    //TODO:
    
    func feedbackApplication(dict : [String : Any], completion : @escaping ClosureCompletion) {
        MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        _ = Networking.sharedInstance.POSTJSON(apiTag: CAPITagFeedback, param: dict, successBlock: { (task, response) in
            MILoader.shared.hideLoader()
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagSignUp){
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagSignUp, error: error)
            }
        })
    }
    
    
    func getLikeList(page : Int?, post_id : String?, rss_id : Int?, completion : @escaping ClosureCompletion) -> URLSessionTask {
        
        var para = [String : Any]()
        para[CPage] = page
        para[CPer_limit] = CLimitNew
        
        if post_id != nil {
            para[CPostId] = post_id
        }
        
        if rss_id != nil {
            para[CRssId] = rss_id
        }
        let apiTag = CAPITagLikes + (post_id ?? "0").description
        return Networking.sharedInstance.GETNEW(apiTag: apiTag, param: nil, successBlock: { (task, response) in
            MILoader.shared.hideLoader()
            completion(response, nil)
        }, failureBlock: { (task, message, error) in
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert:true, strApiTag: CAPITagLikes, error: error)
            }
        })!
    }
    
    func reportPostUserRSS(para : [String : Any], image : UIImage?, completion : @escaping ClosureCompletion) {
        
        MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        
        var imgData : Data?
        if image != nil{
            imgData = (image?.jpegData(compressionQuality: 0.9))!
        }
        let _ = Networking.sharedInstance.POSTJSON(apiTag: CAPITagReportUserNew, param: para, successBlock: { (task, response) in
            MILoader.shared.hideLoader()
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagReportUserNew) {
                completion(response, nil)
            }else{
                completion(nil, nil)
            }
        }, failureBlock: { (task, message, error) in
            completion(nil, error)
            MILoader.shared.hideLoader()
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert:true, strApiTag: CAPITagReportUserNew, error: error)
            }
        })
    }
    
    func interestMayBeNotInterest(post_id : Int?, type : Int?, completion : @escaping ClosureCompletion) {
        var para = [String : Any]()
        para["choice"] = type?.description
        para["user_id"] = appDelegate.loginUser?.user_id
        
        // To add comment on Post...
        if post_id != nil{
            para["post_id"] = post_id?.description
        }
        
        _ = Networking.sharedInstance.POSTJSON(apiTag: CAPITagEventInterest, param: para as [String : AnyObject], successBlock: { (task, response) in
            
            //                completion(response, nil)
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagEventInterest) {
                completion(response, nil)
            }
        }, failureBlock: { (task, message, error) in
            completion(nil, error)
        })
        
    }
    
    func getNotificationList(receiver : String?,pageNumber:String?, completion : @escaping ClosureCompletion) -> URLSessionTask {
        
        var param = [String:Any]()
        param["receiver"] = receiver
        param["type"] = "1"
        param[CPage] = pageNumber
        param["limit"] = CLimitTW
        
        return Networking.sharedInstance.GETNEWPRNOTF(apiTag: CAPITagNotifications, param: param as [String : AnyObject], successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagNotificationList){
                completion(response, nil)
            }
        }, failureBlock: { (task, message, error) in
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert:true, strApiTag: CAPITagNotificationList, error: error)
            }
        })!
    }
    
    func readNotification(notificationIDs: String?, completion: @escaping ClosureCompletion) {
        
        _ = Networking.sharedInstance.PUTJSONNOTF(apiTag: CAPITagNotification, param: ["nid": notificationIDs as AnyObject], successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagNotification){
                completion(response, nil)
            }
        }, failureBlock: { (task, message, error) in
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert:true, strApiTag: CAPITagNotification, error: error)
            }
        })
    }
    
    func sendNotification(notifications:[String:Any], completion: @escaping ClosureCompletion) {
        
        _ = Networking.sharedInstance.POSTJSONNOTF(apiTag: CAPITagNotifier, param: notifications as [String:Any], successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagNotifier){
                completion(response, nil)
            }
        }, failureBlock: { (task, message, error) in
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert:true, strApiTag: CAPITagNotification, error: error)
            }
        })
    }
    
    // MARK: ----------- Poll Detail ----------------
    func voteForPoll(para : [String : Any], completion : @escaping ClosureCompletion) {
        
        MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        
        _ = Networking.sharedInstance.POSTJSON(apiTag: CAPITagVotePollsOption, param: para as [String : AnyObject], successBlock: { (task, response) in
            
            MILoader.shared.hideLoader()
            completion(response, nil)
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagCMS) {
                
            }
            
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagCMS, error: error)
            }
        })
    }
    func votePollDetailsList(optionText : String?,postID : String?, completion : @escaping ClosureCompletion) -> URLSessionTask {
        var para = [ String : Any]()
        para["id"] = postID
        para["option"] = optionText
        return Networking.sharedInstance.GETNEWPR(apiTag: CPollUsers, param: para as [String : AnyObject], successBlock: { (task, reponse) in
            MILoader.shared.hideLoader()
            completion(reponse, nil)
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert:true, strApiTag: CAPITagInterests, error: error)
            }
        })!
        
    }
    func votePollDetails(para : [String:Any], completion : @escaping ClosureCompletion) {
        
        MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        
        _ = Networking.sharedInstance.GETNEWPR(apiTag: CAPITagVoteDetailsPolls, param: para as [String : AnyObject], successBlock: { (task, response) in
            
            MILoader.shared.hideLoader()
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagCMS) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagCMS, error: error)
            }
        })
    }
    
    
    
    //TODO:
    //TODO: -------------- File Folders APIS --------------
    //TODO:
    
    func uploadFiles(apiName: String,param: [String : Any], key:String ,assets: MDLAddMedia?,  progressBlock:@escaping ((Double)->Void), completion: @escaping ClosureCompletion ) {
        
        Networking.sharedInstance.backgroundSessionManager.upload(multipartFormData: { (multipartData) in
            // multipart setup
            if let media = assets{
                if media.assetType == .Image {
                    if let img = media.image, let imgData = img.jpegData(compressionQuality: 0.9){
                        var fileName : String = media.fileName ?? "\(Date().timeIntervalSince1970)"
                        let arrFileName = fileName.components(separatedBy: ".")
                        if arrFileName.count == 2{
                            fileName = arrFileName[0]
                            fileName += "." + arrFileName[1].lowercased()
                        }
                        //fileName = fileName.replacingOccurrences(of: ".", with: "")
                        //fileName += ".jpeg"
                        multipartData.append(imgData, withName: "\(key)", fileName: fileName, mimeType: "image/jpeg")
                    }
                }else{
                    if let videoUrl = URL(string: media.url ?? ""){
                        do {
                            let data = try Data(contentsOf: videoUrl, options: .mappedIfSafe)
                            var fileName : String = media.fileName ?? "\(Date().timeIntervalSince1970)"
                            let arrFileName = fileName.components(separatedBy: ".")
                            if arrFileName.count == 2{
                                fileName = arrFileName[0]
                                fileName += "." + arrFileName[1].lowercased()
                            }
                            //fileName = fileName.replacingOccurrences(of: ".", with: "")
                            //fileName += videoUrl.extentionOfPath
                            multipartData.append(data, withName: "\(key)", fileName: fileName, mimeType: videoUrl.mimeType())
                        }catch{}
                    }
                }
            }
            for (key, value) in param {
                multipartData.append("\(value)".data(using: .utf8)!, withName: key)
            }
            
        }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, to: (BASEURLNEW + apiName), method: .post, headers: Networking.sharedInstance.headers, encodingCompletion: { encodingResult in
            // transmission closure
            switch (encodingResult) {
            // encodingResult success
            case .success(let request, _, _):
                
                // upload progress closure
                request.uploadProgress(closure: { (progress) in
                    //print("upload progress: \(progress.fractionCompleted)")
                    progressBlock(progress.fractionCompleted * 100)
                    // here you can send out to a delegate or via notifications the upload progress to interested parties
                })
                
                // response handler
                request.responseJSON(completionHandler: { response in
                    switch response.result {
                    case .success(let jsonData):
                        
                        // do any parsing on your request's response if needed
                        GCDMainThread.async {
                            if self.checkResponseStatusAndShowAlert(showAlert: false, responseobject: jsonData as AnyObject, strApiTag: CAPITagCreateFiles) {
                                completion(jsonData as AnyObject, nil)
                            }else{
                                completion(jsonData as AnyObject, nil)
                            }
                        }
                    case .failure(let error):
                        
                        GCDMainThread.async {
                            completion(nil, error as NSError)
                        }
                    }
                })
                
            case .failure(let error):
                
                GCDMainThread.async {
                    completion(nil, error as NSError)
                }
            }
        })
    }
    
    
    func productCategoriesList(searchText:String,showLoader : Bool, completion: @escaping ClosureCompletion ) -> URLSessionTask?{
        
        if showLoader{
            MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        }
        //let apiTag = CProductCategoriesList + "search=" + searchText
        let param : [String : Any] = [
            "search" : searchText
        ]
        let Apitag = CProductCategoriesListNew + "/type/Product"
        return Networking.sharedInstance.GETNEW(apiTag: Apitag, param:param as [String : AnyObject], successBlock: { (task, reponse) in
            MILoader.shared.hideLoader()
            completion(reponse, nil)
            //            self.storeProductCategoryInLocal(response: reponse as! [String : AnyObject])
            
            
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagDeleteFolder, error: error)
            }
        })
    }
    
    func productLevelCategoriesList(searchText:String,showLoader : Bool, completion: @escaping ClosureCompletion ) -> URLSessionTask?{
        
        if showLoader{
            MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        }
        //let apiTag = CProductCategoriesList + "search=" + searchText
        let param : [String : Any] = [
            "lang_name" : searchText
        ]
        return Networking.sharedInstance.GETNEWPR(apiTag: CAPITagProductcategory, param:param as [String : AnyObject], successBlock: { (task, reponse) in
            MILoader.shared.hideLoader()
            completion(reponse, nil)
            self.storeProductCategoryInLocal(response: reponse as! [String : AnyObject])
            
            
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagDeleteFolder, error: error)
            }
        })
    }
    
    func getCurrenciesList(showLoader : Bool, completion: @escaping ClosureCompletion ) {
        
        if showLoader{
            MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        }
        let _ = Networking.sharedInstance.GETNEW(apiTag: CCurrencies, param: nil, successBlock: { (task, reponse) in
            MILoader.shared.hideLoader()
            completion(reponse, nil)
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagDeleteFolder, error: error)
            }
        })
    }
    
    func getProductList(param : [String : Any],userID:String, showLoader : Bool, completion: @escaping ClosureCompletion ) -> URLSessionTask?{
        
        if showLoader{
            MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        }
        return Networking.sharedInstance.GETNEWPR(apiTag: CProductListNew, param: param as [String : AnyObject], successBlock: { (task, reponse) in
            MILoader.shared.hideLoader()
            completion(reponse, nil)
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagDeleteFolder, error: error)
            }
        })
    }
    
    
    func getProductListCategory(param : [String : Any],category:String, showLoader : Bool, completion: @escaping ClosureCompletion ) -> URLSessionTask?{
        let categories = category.replace(string: " ", replacement: "%20")
        return Networking.sharedInstance.GETNEWPR(apiTag: CProductListuser + categories, param: param as [String : AnyObject], successBlock: { (task, reponse) in
            MILoader.shared.hideLoader()
            completion(reponse, nil)
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagDeleteFolder, error: error)
            }
        })
    }
    func getmyProductList(param : [String : Any], showLoader : Bool,userID:String, completion: @escaping ClosureCompletion ) -> URLSessionTask?{
        let tag = CProductListusers + userID
        
        return Networking.sharedInstance.GETNEWPR(apiTag: tag , param: param as [String : AnyObject], successBlock: { (task, reponse) in
            MILoader.shared.hideLoader()
            completion(reponse, nil)
            
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagDeleteFolder, error: error)
            }
        })
    }
    
    
    
    func getmyProductListSearch(param : [String : Any], showLoader : Bool, completion: @escaping ClosureCompletion ) -> URLSessionTask?{
        return Networking.sharedInstance.GETNEWPR(apiTag: CProductMySearch , param: param as [String : AnyObject], successBlock: { (task, reponse) in
            MILoader.shared.hideLoader()
            completion(reponse, nil)
            
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagDeleteFolder, error: error)
            }
        })
    }
    
    
    func getProductListSearch(param : [String : Any],showLoader : Bool, completion: @escaping ClosureCompletion ) -> URLSessionTask?{
        
//        if showLoader{
//            MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
//        }
        return Networking.sharedInstance.GETNEWPR(apiTag: CProductListSearch, param: param as [String : AnyObject], successBlock: { (task, reponse) in
            MILoader.shared.hideLoader()
            completion(reponse, nil)
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagDeleteFolder, error: error)
            }
        })
    }
    
    
    func deleteProduct(productID : Int, showLoader : Bool, completion: @escaping ClosureCompletion ){
        
        if showLoader{
            MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        }
        //        let apiURL = CDeleteProduct + productID.description
        let apiURL = CdeleteProduct + productID.description
        let _ = Networking.sharedInstance.DELETENEW(apiTag: apiURL, param: nil, success: { (task, reponse) in
            MILoader.shared.hideLoader()
            completion(reponse, nil)
        }) { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagDeleteFolder, error: error)
            }
        }
    }
    func addEditProduct(apiTag : String, dict:[String:Any], arrMedia : [MDLAddMedia]?, showLoader : Bool, completion: @escaping ClosureCompletion ){
        
        if showLoader{
            MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        }
        print(dict)
        _ = Networking.sharedInstance.POSTJSON(apiTag: CAddProductNew, param: dict, successBlock: { (task, response) in
            
            MILoader.shared.hideLoader()
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAddProductNew){
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAddProductNew, error: error)
            }
        })
    }
    
    
    
    func productEditProduct(apiTag : String, dict:[String:Any], showLoader : Bool, completion: @escaping ClosureCompletion ){
        
        if showLoader{
            MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        }
        _ = Networking.sharedInstance.PUTJSON(apiTag:CEditProductNew , param: dict, successBlock: { (task, response) in
            
            MILoader.shared.hideLoader()
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CEditProductNew){
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CEditProductNew, error: error)
            }
        })
    }
    
    func EditProduct(apiTag : String, dict:[String:Any], arrMedia : [MDLAddMedia]?, showLoader : Bool, completion: @escaping ClosureCompletion ){
        
        if showLoader{
            MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        }
        _ = Networking.sharedInstance.PUTJSON(apiTag:CEditProductNew , param: dict, successBlock: { (task, response) in
            
            MILoader.shared.hideLoader()
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CEditProductNew){
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CEditProductNew, error: error)
            }
        })
        
    }
    
    func likeUnlikeProducts(userId:Int,productId : Int, isLike : Int, completion : @escaping ClosureCompletion) {
        let isLikes = String(isLike)
        let isproductID = String(productId)
        var para = [String : Any]()
        
        para["user_id"] = userId.description
        para["element_id"] = isproductID.description
        para["like_status"] = isLikes.description
        
        
        _ = Networking.sharedInstance.POSTJSON(apiTag: CLikeUnlikeProducts, param: para as [String : AnyObject], successBlock: { (task, response) in
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagLikeUnlike) {
                completion(response, nil)
            }
        },failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagLikeUnlike, error: error)
            }
        })
    }
    
    func deleteProduct(productId : String, completion : @escaping ClosureCompletion) {
        
        let apiTags = CdeleteProduct + productId
        
        _ = Networking.sharedInstance.DELETENEW(apiTag:apiTags , param:nil, success: { (task, response) in
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagLikeUnlike) {
                completion(response, nil)
            }
        }, failure: { (task, message, error) in
            completion(nil, error)
        })
    }
    
    func likeUnlikeProductCount(productId : Int,completion : @escaping ClosureCompletion) {
        
        let apiTags  = CLikeUnlikeProductCount + String(productId)
        
        _ = Networking.sharedInstance.GETNEW(apiTag:apiTags, param: [:], successBlock: { (task, response) in
            MILoader.shared.hideLoader()
            completion(response, nil)
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CLikeUnlikeProductCount, error: error)
            }
        })
    }
    
    func reportProduct(para : [String : Any],completion : @escaping ClosureCompletion) {
        
        _ = Networking.sharedInstance.POSTJSON(apiTag:CReportProductNew, param: para as [String : AnyObject], successBlock: { (task, response) in
            MILoader.shared.hideLoader()
            completion(response, nil)
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CLikeUnlikeProductCount, error: error)
            }
        })
    }
    
    func getProductDetail(para : [String:Any],productID:Int,userID:String, showLoader : Bool, completion: @escaping ClosureCompletion ) -> URLSessionTask?{
        
        if showLoader{
            MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        }
        return Networking.sharedInstance.GETNEWPR(apiTag: CAddProductDetail, param: para as [String : AnyObject], successBlock: { (task, reponse) in
            MILoader.shared.hideLoader()
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: reponse, strApiTag: CAPITagLikeUnlike) {
                completion(reponse, nil)
            }
            //completion(reponse, nil)
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagDeleteFolder, error: error)
            }
        })
    }
    
    func sendProductCommentnew(productId : String, commentId : Int?, comment : String?, include_user_id : String?, completion : @escaping ClosureCompletion) {
        
        MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        
        var apiURL = CCommentOnProductnew
        var para = [String : Any]()
        para["comment"] = comment
        para["element_id"] = productId
        if include_user_id != nil{
            para["user_id"] = include_user_id
        }
        
        if (commentId ?? 0) != 0{
            apiURL += "/" + commentId!.description
        }
        _ = Networking.sharedInstance.POSTPARA(apiTag: apiURL, param: para as [String : AnyObject], successBlock: { (task, response) in
            
            MILoader.shared.hideLoader()
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagAddComment) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert:true, strApiTag: CAPITagAddComment, error: error)
            }
        })
    }
    
    func getProductCommentLists(page : Int, showLoader : Bool, productId : String, completion : @escaping ClosureCompletion) -> URLSessionTask? {
        
        if showLoader {
            MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        }
        
        var para = [String : Any]()
        para[CPage] = page.description
        para[CPer_limit] = CLimit.description
        let apiTag =  CProductCommentListAPINew + productId.description
        return Networking.sharedInstance.GETNEW(apiTag: apiTag, param: para as [String : AnyObject], successBlock: { (task, reponse) in
            MILoader.shared.hideLoader()
            completion(reponse, nil)
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert:true, strApiTag: CProductCommentListAPINew, error: error)
            }
        })
    }
    func deleteProductCommentNew(productId : String, commentId : String?, comment : String?, include_user_id : String?, completion : @escaping ClosureCompletion) {
        
        MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        
        let apiURL = CCommentdelProductnew
        var para = [String : Any]()
        para["updated_at"] = commentId
        para["element_id"] = productId
        if include_user_id != nil{
            para["user_id"] = include_user_id
        }
        _ = Networking.sharedInstance.DELETJSON(apiTag: apiURL, param: para as [String : AnyObject], successBlock: { (task, response) in
            
            MILoader.shared.hideLoader()
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagAddComment) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert:true, strApiTag: CAPITagAddComment, error: error)
            }
        })
    }
    func rewardsAdding(param:[String:Any], completion: @escaping ClosureCompletion) {
        
        _ = Networking.sharedInstance.POSTJSON(apiTag: CAPITrewardAdd, param: param as [String:Any], successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagNotifier){
                completion(response, nil)
            }
        }, failureBlock: { (task, message, error) in
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert:true, strApiTag: CAPITrewardAdd, error: error)
            }
        })
    }
    
    
    
    func rewardsSummaryNew(dict:[String:Any],showLoader : Bool, completion: @escaping ClosureCompletion) {
        
        if showLoader{
            MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        }
        
        _ = Networking.sharedInstance.GETNEWPR(apiTag: CAPITagRewards, param: dict as [String:AnyObject], successBlock: { (task, reponse) in
            MILoader.shared.hideLoader()
            completion(reponse, nil)
            self.storeUserRewardPoints(response: reponse as! [String : AnyObject])
            
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagRewards, error: error)
            }
        })
    }
    func rewardsDetail(param:[String:Any],showLoader : Bool, completion: @escaping ClosureCompletion) -> URLSessionTask? {
        
        if showLoader{
            MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        }
        return Networking.sharedInstance.GETNEWPR(apiTag: CAPITagRewardUser, param: param as [String:AnyObject], successBlock: { (task, reponse) in
            MILoader.shared.hideLoader()
            completion(reponse, nil)
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus405{
                appDelegate.logOut()
            } else if error?.code == CStatus1009 || error?.code == CStatus1005 {
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagDeleteFolder, error: error)
            }
        })
    }
}

//MARK:- --------- Store in Local

extension APIRequest {
    
    func saveUserDetail(response : [String : AnyObject]) {
        
        if let data = response.valueForJSON(key: CJsonData) as? [[String : AnyObject]] {
            
            for dict in data{
                
                let tblUser = TblUser.findOrCreate(dictionary: [CUserId : Int64(dict.valueForString(key: CUserId)) ?? ""]) as! TblUser
                
                tblUser.email = dict.valueForString(key: CEmail)
                tblUser.first_name = dict.valueForString(key: CFirstname)
                tblUser.last_name = dict.valueForString(key: CLastname)
                tblUser.profile_img = dict.valueForString(key: CImage)
                tblUser.address = dict.valueForString(key: CAddress)
                tblUser.annual_income_id = Int64(dict.valueForString(key: CAnnual_income)) ?? 0
                tblUser.annual_income = dict.valueForString(key: "annual_income")
                
                tblUser.badge_count = 0
                tblUser.block_unblock_status = false
                tblUser.dob = dict.valueForString(key: CDob)
                tblUser.education_id = Int64(dict.valueForString(key: "education_name")) ?? 0
                tblUser.employment_status = Int16(dict.valueForString(key: CEmployment_status)) ?? 0
                
                tblUser.friend_block_unblock_status = false
                tblUser.friend_report_status = false
                tblUser.friend_status = false
                tblUser.friends = dict.valueForJSON(key: CFriends) as? NSObject
                tblUser.gender = Int16(dict.valueForString(key: CGender)) ?? 0
                tblUser.push_notify = dict.valueForBool(key: CPush_notify)
                tblUser.email_notify = dict.valueForBool(key: CEmail_notify)
                tblUser.lang_name = dict.valueForString(key: "lang_name")
                tblUser.latitude = Double(dict.valueForString(key: CLatitude)) ?? 0.0
                tblUser.longitude = Double(dict.valueForString(key: CLongitude)) ?? 0.0
                tblUser.mobile = dict.valueForString(key: CMobile)
                tblUser.profession = dict.valueForString(key: CProfession)
                tblUser.relationship_id = Int64(dict.valueForString(key: "relationship") ) ?? 0
                tblUser.relationship = dict.valueForString(key: "relationship")
                tblUser.religion = dict.valueForString(key: "religion")
                tblUser.short_biography = dict.valueForString(key: CShort_biography)
                tblUser.total_like = Int64(dict.valueForString(key: "likes")) ?? 0
                tblUser.user_type = true
                tblUser.user_types = dict.valueForString(key: "user_type")
                tblUser.visible_to_friend = Int16(dict.valueForString(key: CVisible_to_friend)) ?? 0
                tblUser.visible_to_other = Int16(dict.valueForString(key: CVisible_to_other)) ?? 0
                tblUser.profile_url = dict.valueForString(key: "profile_image")
                tblUser.cover_image = dict.valueForString(key: "cover_image")
                tblUser.education_name = dict.valueForString(key: "education_name")
                tblUser.country = dict.valueForString(key: CCountryName)
                tblUser.state = dict.valueForString(key: CStateName)
                tblUser.city = dict.valueForString(key: CCityName)
                tblUser.status_id = dict.valueForString(key: CStatus_id)
                tblUser.account_type = Int16(dict.valueForString(key: CAccounttype)) ?? 0
                let arrCountry = TblCountry.fetch(predicate: NSPredicate(format:"%K == %s", CCountryName, (dict.valueForString(key: "country_name"))))
                
                if (arrCountry?.count)! > 0{
                    tblUser.country_code = ((arrCountry![0] as! TblCountry).country_code)
                }
                CUserDefaults.setValue(dict.valueForString(key: CUserId), forKey: UserDefaultUserID)
                CUserDefaults.synchronize()
                appDelegate.loginUser = tblUser
                CoreData.saveContext()
            }
        }
        
        let token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjY2NGViZmYyMDM1YjIzZjk3OTg3MDdmYTgwOWYyNTBmZTk2NDVlMGQ3NTg1OGFlMjNiMTA3MTAxNTFhNjFlNTMwZWVmOTkxNDQ3OTUyYWI0In0.eyJhdWQiOiI3IiwianRpIjoiNjY0ZWJmZjIwMzViMjNmOTc5ODcwN2ZhODA5ZjI1MGZlOTY0NWUwZDc1ODU4YWUyM2IxMDcxMDE1MWE2MWU1MzBlZWY5OTE0NDc5NTJhYjQiLCJpYXQiOjE2Mjk0NzU5ODgsIm5iZiI6MTYyOTQ3NTk4OCwiZXhwIjoxNjYxMDExOTg4LCJzdWIiOiI1MjYiLCJzY29wZXMiOltdfQ.cjUBHTR8X8w__fLmKFpDL4l8N9E_EIaoJmZb8QIhvD7cBjvOk0fY2HF88OoBtuGDO7maFkfk0ayZ2LXRzP5EhZY43_imlnZVuM-8XN7OYwlW2N1pW1nYZKmNSjOSukHd4cIhq0iuFTEzYHVnVgI84ctGsVO8aU9lnX4h1YpOLuOON2VwbsYxHS8oITGGhL7AUu2ywmwtODlh2rGKDOAGezLeRu20xu-llDaTwRsalIFW1KNC720PWGmHTogoei2-96-W9hskJVXMDMWjyUO87C1W9LqFQjj5k-33Yx7EYA7AYSFxoYo1CLmFYphjiPT5EU50Fosl3QAu4udH-rNpLQdEJJthw-FcKaJJsaHaYnZ5GMKX_sJFfhT2feMp-9bjbvtx0bh6bjAISZj9TgN8LwVB_3uNUJ4G9AZD7zY-JumxaId91UUcdm9XFbQXeh3PkB1H1ceGmg3cD-SWkI2LjS3QL0IcUVVRXhMaEgBvY_oC_W1Hdkkd3riSBOn5W7-oLVQy0irzyDKqBbw4TS4rjHUNy1oUqY6vppNVgRfgLVN0RfVPbymQi1V2EmNMs1UGbhyqQyCndWfX_B-J2QUV2kK5uR36hkdzbKu23wE3k8PVN_mKYHtU3ASQCYQWBs1e6gZxDWw0X4t1CKLJjtC93lE2aB_JaZ5N-5_os5vISVM"
        
        
        if let metaData = response.valueForJSON(key: CJsonMeta) as? [String : AnyObject] {
            //...Save userID and token in Userdefault
            
            if metaData.valueForString(key: "token") != "" {
                
                CUserDefaults.setValue(metaData.valueForString(key: "token"), forKey: UserDefaultDeviceToken)
            }else {
                
                CUserDefaults.setValue(token, forKey: UserDefaultDeviceToken)
            }
            CUserDefaults.synchronize()
        }
    }
    
    
    func saveUserFriendsDetails(response : [String : AnyObject]) {
        
        if let data = response.valueForJSON(key: "my_friends") as? [[String : AnyObject]] {
            TblTotalFriends.deleteAllObjects()
            for dict in data{
                let tblUsers = TblTotalFriends.findOrCreate(dictionary: ["friend_user_id" : Int64(dict.valueForString(key: "friend_user_id")) ?? ""]) as! TblTotalFriends
                tblUsers.first_name = dict.valueForString(key: CFirstname)
                tblUsers.last_name = dict.valueForString(key: CLastname)
                tblUsers.profile_image = dict.valueForString(key: CImage)
                tblUsers.user_id = Int64(dict.valueForString(key:CUserId)) ?? 0
                tblUsers.friend_user_id = Int64(dict.valueForString(key: "friend_user_id")) ?? 0
                
            }
            CoreData.saveContext()
        }
    }
    
    func updateEmailPhone(userId : Int64, email: String?, mobile: String?, countryCodeId: Int64?) {
        
        let tblUser = TblUser.findOrCreate(dictionary: [CUserId : userId]) as! TblUser
        if email != nil{
            tblUser.email = email!
        }
        if mobile != nil{
            tblUser.mobile = mobile!
        }
        if countryCodeId != nil{
            tblUser.country_code_id = countryCodeId!
            let arrCountry = TblCountry.fetch(predicate: NSPredicate(format:"%K == %d", CCountry_id, countryCodeId!))
            if (arrCountry?.count)! > 0{
                tblUser.country_code = ((arrCountry![0] as! TblCountry).country_code)
            }
        }
        appDelegate.loginUser = tblUser
        CoreData.saveContext()
    }
    
    func storeInterestInLocal(response : [String : AnyObject]) {
        if let data = response.valueForJSON(key: CJsonData) as? [[String : AnyObject]] {
            for item in data {
                let tblInterest = TblInterest.findOrCreate(dictionary: [CName:(item.valueForString(key: CInteresttype))]) as! TblInterest
                tblInterest.name = item.valueForString(key: CInteresttype)
            }
            CoreData.saveContext()
        }
    }
    func storeProductCategoryInLocal(response : [String : AnyObject]) {
        if let data = response.valueForJSON(key: CJsonData) as? [[String : AnyObject]] {
            TblProductCategory.deleteAllObjects()
            for item in data {
                let tblproductCat = TblProductCategory.findOrCreate(dictionary: [CProductcategoryType:(item.valueForString(key: CProductcategoryType))]) as! TblProductCategory
                tblproductCat.product_category_type = item.valueForString(key: "product_category_type")
            }
            
            CoreData.saveContext()
        }
    }
    func storeProductSubCategoryInLocal(response : [String : AnyObject]) {
        if let data = response.valueForJSON(key: CJsonData) as? [[String : AnyObject]] {
            TblProductSubCategory.deleteAllObjects()
            for item in data {
                let tblproductSubCat = TblProductSubCategory.findOrCreate(dictionary: [CCategory_level1:(item.valueForString(key: CCategory_level1))]) as! TblProductSubCategory
                tblproductSubCat.category_level1 = item.valueForString(key: "category_level1")
            }
            CoreData.saveContext()
        }
    }
    func storeSubInterestInLocal(response : [String : AnyObject]) {
        if let data = response.valueForJSON(key: CJsonData) as? [[String : AnyObject]] {
            for item in data {
                let tblInterest = TblSubIntrest.findOrCreate(dictionary: [CInterestID:(item.valueForString(key: CInterestID))]) as! TblSubIntrest
                tblInterest.interest_level2 = item.valueForString(key: CinterestLevel2)
            }
            CoreData.saveContext()
        }
    }
    func storeArticleInLocal(response : [String : AnyObject]) {
        if let data = response.valueForJSON(key: CJsonData) as? [[String : AnyObject]] {
            for item in data {
                let tblInterest = TblArticle.findOrCreate(dictionary: [CCategoryName:(item.valueForString(key: CCategoryName))]) as! TblArticle
                tblInterest.category_name = item.valueForString(key: CCategoryName)
            }
            CoreData.saveContext()
        }
    }
    func storeArticleInChirpy(response : [String : AnyObject]) {
        if let data = response.valueForJSON(key: CJsonData) as? [[String : AnyObject]] {
            for item in data {
                let tblInterest = TblChirpy.findOrCreate(dictionary: [CCategoryName:(item.valueForString(key: CCategoryName))]) as! TblChirpy
                tblInterest.category_name = item.valueForString(key: CCategoryName)
            }
            CoreData.saveContext()
        }
    }
    func storeArticleInEvent(response : [String : AnyObject]) {
        if let data = response.valueForJSON(key: CJsonData) as? [[String : AnyObject]] {
            for item in data {
                let tblInterest = TblEvent.findOrCreate(dictionary: [CCategoryName:(item.valueForString(key: CCategoryName))]) as! TblEvent
                tblInterest.category_name = item.valueForString(key: CCategoryName)
            }
            CoreData.saveContext()
        }
    }
    
    func storeArticleInForum(response : [String : AnyObject]) {
        if let data = response.valueForJSON(key: CJsonData) as? [[String : AnyObject]] {
            for item in data {
                let tblInterest = TblForum.findOrCreate(dictionary: [CCategoryName:(item.valueForString(key: CCategoryName))]) as! TblForum
                tblInterest.category_name = item.valueForString(key: CCategoryName)
            }
            CoreData.saveContext()
        }
    }
    func storeArticleInGallery(response : [String : AnyObject]) {
        if let data = response.valueForJSON(key: CJsonData) as? [[String : AnyObject]] {
            for item in data {
                let tblInterest = TblGallery.findOrCreate(dictionary: [CCategoryName:(item.valueForString(key: CCategoryName))]) as! TblGallery
                tblInterest.category_name = item.valueForString(key: CCategoryName)
            }
            CoreData.saveContext()
        }
    }
    
    func storeArticleInPoll(response : [String : AnyObject]) {
        if let data = response.valueForJSON(key: CJsonData) as? [[String : AnyObject]] {
            for item in data {
                let tblInterest = TblPoll.findOrCreate(dictionary: [CCategoryName:(item.valueForString(key: CCategoryName))]) as! TblPoll
                tblInterest.category_name = item.valueForString(key: CCategoryName)
            }
            CoreData.saveContext()
        }
    }
    
    func storeCountryInLocal(response : [String : AnyObject]) {
        if let data = response.valueForJSON(key: CJsonData) as? [[String : AnyObject]] {
            for item in data {
                let tblCountry = TblCountry.findOrCreate(dictionary: [CCountryName:(item.valueForString(key: CCountryName))]) as! TblCountry
                tblCountry.country_code = item.valueForString(key: "phone_prefix")
                tblCountry.country_iso = item.valueForString(key: CCountryIso)
                tblCountry.country_name = item.valueForString(key: CCountryName)
                tblCountry.countryname_code = "\(item.valueForString(key: CCountryName)) - \(item.valueForString(key: CCountrycode))"
            }
            CoreData.saveContext()
        }
    }
    
    func storePointsConfigsInLocal(response : [String : AnyObject]) {
        if let data = response.valueForJSON(key: CJsonData) as? [[String : AnyObject]] {
            for item in data {
                let tblPointsConfig = TblPointsConfig.findOrCreate(dictionary: [Cpoints_config_id:(item.valueForString(key: Cpoints_config_id))]) as! TblPointsConfig
                tblPointsConfig.points_config_id = item.valueForString(key: "points_config_id")
                tblPointsConfig.category = item.valueForString(key: "category")
                tblPointsConfig.points_config_name = item.valueForString(key: "points_config_name")
                tblPointsConfig.min_points = item.valueForString(key: "min_points")
                tblPointsConfig.max_points = item.valueForString(key: "max_points")
                tblPointsConfig.created_at = item.valueForString(key: "created_at")
                
            }
            CoreData.saveContext()
        }
    }
    
    func storeRewardCategoryInLocal(response : [String : AnyObject]) {
        TblRewardCategory.deleteAllObjects()
        if let data = response.valueForJSON(key: CJsonData) as? [[String : AnyObject]] {
            for item in data {
                let tblRewardCategory = TblRewardCategory.findOrCreate(dictionary: [CCategory_Id:(item.valueForString(key: CCategory_Id))]) as! TblRewardCategory
                tblRewardCategory.category_id = item.valueForString(key: "category_id")
                tblRewardCategory.category_name = item.valueForString(key: "category_name")
            }
            CoreData.saveContext()
        }
    }
    
    func storeUserRewardPoints(response : [String : AnyObject]) {
        if let data = response.valueForJSON(key: CJsonData) as? [[String : AnyObject]] {
            for item in data {
                let tblRewardPts = TblRewardPoint.findOrCreate(dictionary: [CName:(item.valueForString(key: CName))]) as! TblRewardPoint
                tblRewardPts.name = item.valueForString(key: CName)
                tblRewardPts.points = item.valueForString(key: CPointreward)
            }
            CoreData.saveContext()
        }
    }
    
    func storeFeebackCategoryList(response : [String : AnyObject]) {
        TblFeedbackList.deleteAllObjects()
        CoreData.saveContext()
        if let arrFeedback = response.valueForJSON(key: CJsonData) as? [[String : AnyObject]] {
            for catInfo in arrFeedback {
                if let categoryList = TblFeedbackList.findOrCreate(dictionary: [CId : Int64(catInfo.valueForInt(key: CId)!)]) as? TblFeedbackList {
                    categoryList.name = catInfo.valueForString(key: CName)
                }
            }
            CoreData.saveContext()
        }
    }
    
    func storeRelationList(response : [String : AnyObject]) {
        TblRelation.deleteAllObjects()
        CoreData.saveContext()
        if let data = response.valueForJSON(key: CJsonData) as? [[String : AnyObject]] {
            for item in data {
                if let tblRelation = TblRelation.findOrCreate(dictionary: [CName : (item.valueForString(key: CRelationShip))]) as? TblRelation {
                    tblRelation.name = item.valueForString(key:CRelationShip)
                }
            }
            CoreData.saveContext()
        }
        
    }
    
    func storeAnnualIncome(response : [String : AnyObject]) {
        CoreData.saveContext()
        if let data = response.valueForJSON(key: CJsonData) as? [[String : AnyObject]] {
            for item in data {
                let tblAnnualIncome = TblAnnualIncomes.findOrCreate(dictionary : [CIncome : (item.valueForString(key: CIncome))]) as! TblAnnualIncomes
                tblAnnualIncome.income = item.valueForString(key: "income")
            }
            CoreData.saveContext()
        }
    }
    
    func storeEducationList(response : [String : AnyObject]) {
        TblEducation.deleteAllObjects()
        CoreData.saveContext()
        
        if let data = response.valueForJSON(key: CJsonData) as? [[String : AnyObject]] {
            for item in data {
                let tblEducation = TblEducation.findOrCreate(dictionary: [CName : (item.valueForString(key: "education_name"))]) as! TblEducation
                tblEducation.name = item.valueForString(key: CEducation_Name)
            }
            CoreData.saveContext()
        }
    }
    
    func storeNewsCategory(response: [String : AnyObject]) {
        TblNewsCategory.deleteAllObjects()
        CoreData.saveContext()
        if let data = response.valueForJSON(key: CJsonData) as? [[String: Any]] {
            //            var arrNews = data
            for item in data {
                let newsCategory = TblNewsCategory.findOrCreate(dictionary: [CCategoryName: (item.valueForString(key: CCategoryName))]) as! TblNewsCategory
                newsCategory.category_name = item.valueForString(key: CCategoryName)
            }
            CoreData.saveContext()
        }
    }
    
    func storPSLCategory(response: [String : AnyObject]) {
        TblPslCategory.deleteAllObjects()
        CoreData.saveContext()
        
        if let data = response.valueForJSON(key: CJsonData) as? [[String: Any]] {
            var arrNews = data
            for item in arrNews {
                let newsCategory = TblPslCategory.findOrCreate(dictionary: [CCategoryName: (item.valueForString(key: CCategoryName))]) as! TblPslCategory
                newsCategory.category_name = item.valueForString(key: CCategoryName)
                newsCategory.category_id = item.valueForString(key: "category_id")
            }
            CoreData.saveContext()
        }
    }
    
    func storeLanguageList(response : [String : AnyObject]) {
        TblLanguage.deleteAllObjects()
        CoreData.saveContext()
        if let data = response.valueForJSON(key: CJsonData) as? [[String : AnyObject]] {
            
            for item in data {
                let tblLanguage = TblLanguage.findOrCreate(dictionary: [CLang_id : Int64(item.valueForString(key: "lang_id")) ?? 0]) as! TblLanguage
                
                tblLanguage.name = item.valueForString(key: CLang_name)
                tblLanguage.lang_code = item.valueForString(key: CLang_code)
                tblLanguage.orientation = item.valueForBool(key: CLangOrientation)
            }
            CoreData.saveContext()
        }
    }
    
    // Store group chat list to local..
    func storeGroupChatList(response : [String : Any]) {
        TblChatGroupList.deleteAllObjects()
        CoreData.saveContext()
        if let items = response.valueForJSON(key: "data") as? [[String : Any]] {
            for item in items{
                let chatInfo = TblChatGroupList.findOrCreate(dictionary: [CGroupId:item.valueForString(key: CGroupId)]) as! TblChatGroupList
                chatInfo.group_id = item.valueForString(key: CGroupId)
                chatInfo.created_at = item.valueForString(key: "updated_at")
                chatInfo.group_image = item.valueForString(key: CGroupImage)
                chatInfo.group_link = item.valueForString(key: CGroupLink)
                chatInfo.group_title = item.valueForString(key: CGroupTitle)
                chatInfo.group_type = item.valueForString(key: CGroupType)
                chatInfo.last_message = item.valueForString(key: CLast_Message)
                chatInfo.pending_request = item.valueForString(key: CGroupPendingRequest)
                chatInfo.address = item.valueForString(key: CAddress)
                chatInfo.status_id = item.valueForString(key: CStatus_id)
                chatInfo.block_unblock_status = item.valueForString(key: "block_unblock_status")
                chatInfo.group_admin = item.valueForString(key: "group_admin")
                chatInfo.group_admin = item.valueForString(key: "group_admin")
                
            }
        }
        CoreData.saveContext()
    }
    
    // Store user chat list to local..
    func storeUserChatList(response : [String : Any]) {
        if let data = response.valueForJSON(key: CJsonData) as? [[String : Any]] {
            
            for item in data {
                let chatInfo = TblChatUserList.findOrCreate(dictionary: [Cuser_id:item.valueForString(key: Cuser_id)]) as! TblChatUserList
                chatInfo.user_id = (item.valueForString(key:CUserId ))
                chatInfo.first_name = item.valueForString(key: CFirstname)
                chatInfo.last_name = item.valueForString(key: CLastname)
                chatInfo.image = item.valueForString(key: CImage)
                chatInfo.message = item.valueForString(key: CMessage)
                chatInfo.isOnline = item.valueForBool(key: CIs_Online)
                chatInfo.email = item.valueForString(key: CEmail)
                chatInfo.address = item.valueForString(key: CAddress)
            }
            
            CoreData.saveContext()
        }
    }
    
    // Store user Advertise List to local..
    func storeAdvertiseList(response : [String : Any]) {
        
        TblAdvertise.deleteAllObjects()
        CoreData.saveContext()
        
        if let data = response.valueForJSON(key: CJsonData) as? [[String : Any]] {
            
            for item in data {
                let addInfo = TblAdvertise.findOrCreate(dictionary: [CAds_id:Int16(item.valueForInt(key: CAds_id)!)]) as! TblAdvertise
                addInfo.ads_id = Int64(item.valueForInt(key: CAds_id)!)
                addInfo.ads_title = item.valueForString(key: CAds_title)
                addInfo.display_type = Int16(item.valueForInt(key: CDisplay_type)!)
                addInfo.interactive_type = Int16(item.valueForInt(key: CInteractive_type)!)
                addInfo.interactive_value = item.valueForString(key: CInteractive_value)
                addInfo.ads_image = item.valueForString(key: CAds_image)
                addInfo.by_page = Int16(item.valueForInt(key: CBy_page)!)
                addInfo.ads_size = Int16(item.valueForInt(key: CAds_size)!)
            }
            
            CoreData.saveContext()
        }
    }
    
    // Store Application language text to local
    func storeLanguageText(response : [String : AnyObject]) {
        
        if let data = response.valueForJSON(key: CJsonData) as? [String : AnyObject] {
            
            let dict = data.valueForJSON(key: "language_text") as? [String : AnyObject]
            let tblLanguageText = TblLanguageText.findOrCreate(dictionary: [CLang_code : (data.valueForString(key: "lang_code"))]) as! TblLanguageText
            //REGISTER
            
            tblLanguageText.select_your_choice = dict?.valueForString(key: "select_your_choice")
            tblLanguageText.signup_with_email_id = dict?.valueForString(key: "signup_with_email_id")
            tblLanguageText.signup_with_mobile_number = dict?.valueForString(key: "signup_with_mobile_number")
            tblLanguageText.the_provided_email_id_already_registered = dict?.valueForString(key: "the_provided_email_id_already_registered")
            tblLanguageText.the_provided_Mobile_Number_already_registered = dict?.valueForString(key: "the_provided_Mobile_Number_already_registered")
            tblLanguageText.entered_wrong_otp = dict?.valueForString(key: "entered_wrong_otp")
            
            
            //LRF screen Messages...
            tblLanguageText.live_in = dict?.valueForString(key: "live_in")
            tblLanguageText.gender = dict?.valueForString(key: "gender")
            tblLanguageText.relationship_status = dict?.valueForString(key: "relationship_status")
            tblLanguageText.user_removed_from_group_successfully = dict?.valueForString(key: "user_removed_from_group_successfully")
            tblLanguageText.group_deleted_successfully = dict?.valueForString(key: "group_deleted_successfully")
            tblLanguageText.comment_removed_successfully = dict?.valueForString(key: "comment_removed_successfully")
            tblLanguageText.your_request_is_on_the_way_We_will_investigate_and_take_an_action_soon = dict?.valueForString(key: "your_request_is_on_the_way_We_will_investigate_and_take_an_action_soon")
            tblLanguageText.success = dict?.valueForString(key: "success")
            tblLanguageText.group_is_added_successfully = dict?.valueForString(key: "group_is_added_successfully")
            tblLanguageText.product_already_reported = dict?.valueForString(key: "product_already_reported")
            tblLanguageText.login_dont_have_an_account = dict?.valueForString(key: "login_dont_have_an_account")
            tblLanguageText.login_email_not_registered_with_us = dict?.valueForString(key: "login_email_not_registered_with_us")
            tblLanguageText.login_email_or_mobile = dict?.valueForString(key: "login_email_or_mobile")
            tblLanguageText.login_email_or_mobile_cant_blank = dict?.valueForString(key: "login_email_or_mobile_cant_blank")
            tblLanguageText.login_enter_valid_email_address = dict?.valueForString(key: "login_enter_valid_email_address")
            tblLanguageText.login_forgot_password = dict?.valueForString(key: "login_forgot_password")
            tblLanguageText.login_invalid_credentials_email = dict?.valueForString(key: "login_invalid_credentials_email")
            tblLanguageText.login_invalid_credentials_mobile = dict?.valueForString(key: "login_invalid_credentials_mobile")
            tblLanguageText.login_mobile_not_registered_with_us = dict?.valueForString(key: "login_mobile_not_registered_with_us")
            tblLanguageText.login_enter_valid_mobile_no = dict?.valueForString(key: "login_enter_valid_mobile_no")
            tblLanguageText.login_password = dict?.valueForString(key: "login_password")
            tblLanguageText.login_password_cant_blank = dict?.valueForString(key: "login_password_cant_blank")
            tblLanguageText.login_signin = dict?.valueForString(key: "login_signin")
            tblLanguageText.login_with_social = dict?.valueForString(key: "login_with_social")
            
            
            //REWADS
            tblLanguageText.ad_free_subscription = dict?.valueForString(key: "ad_free_subscription")
            tblLanguageText.advertisements = dict?.valueForString(key: "advertisements")
            tblLanguageText.admin_correction = dict?.valueForString(key: "admin_correction")
            tblLanguageText.sell_posts = dict?.valueForString(key: "sell_posts")
            tblLanguageText.usage_time = dict?.valueForString(key: "usage_time")
            tblLanguageText.connections = dict?.valueForString(key: "connections")
            tblLanguageText.postsrwds = dict?.valueForString(key: "posts")
            tblLanguageText.feedback = dict?.valueForString(key: "feedback")
            
            
            
            
            
            //Forgot Screen Messages...
            tblLanguageText.forgot_email_not_registered_with_us = dict?.valueForString(key: "forgot_email_not_registered_with_us")
            tblLanguageText.select_sub_category = dict?.valueForString(key: "select_sub_category")
            
            tblLanguageText.forgot_email_or_mobile_cant_blank = dict?.valueForString(key: "forgot_email_or_mobile_cant_blank")
            tblLanguageText.forgot_enter_valid_email_address = dict?.valueForString(key: "forgot_enter_valid_email_address")
            tblLanguageText.forgot_enter_valid_mobile_no = dict?.valueForString(key: "forgot_enter_valid_mobile_no")
            tblLanguageText.forgot_mobile_not_registered_with_us = dict?.valueForString(key: "forgot_mobile_not_registered_with_us")
            tblLanguageText.forgot_password = dict?.valueForString(key: "forgot_password")
            tblLanguageText.forgot_password_reset_text = dict?.valueForString(key: "forgot_password_reset_text")
            tblLanguageText.forgot_password_reset_text1 = dict?.valueForString(key: "forgot_password_reset_text1")
            tblLanguageText.forgot_password_reset_text2 = dict?.valueForString(key: "forgot_password_reset_text2")
            tblLanguageText.forgot_password_submit = dict?.valueForString(key: "forgot_password_submit")
            
            //Verify Email/Mobile Screen Messages...
            tblLanguageText.verify_code_cant_blank = dict?.valueForString(key: "verify_code_cant_blank")
            tblLanguageText.entered_verification_code_is_incorrect = dict?.valueForString(key: "entered_verification_code_is_incorrect")
            tblLanguageText.verify_mobile = dict?.valueForString(key: "verify_mobile")
            tblLanguageText.verify_email = dict?.valueForString(key: "verify_email")
            
            //Reset PWD Screen Messages...
            tblLanguageText.reset_confirm_password = dict?.valueForString(key: "reset_confirm_password")
            tblLanguageText.reset_confirm_password_blank = dict?.valueForString(key: "reset_confirm_password_blank")
            tblLanguageText.reset_enter_otp = dict?.valueForString(key: "reset_enter_otp")
            tblLanguageText.reset_new_password = dict?.valueForString(key: "reset_new_password")
            tblLanguageText.reset_new_password_and_confirm_password_mismatch = dict?.valueForString(key: "reset_new_password_and_confirm_password_mismatch")
            tblLanguageText.reset_new_password_cant_blank = dict?.valueForString(key: "reset_new_password_cant_blank")
            tblLanguageText.reset_password = dict?.valueForString(key: "reset_password")
            tblLanguageText.reset_password_changed_successfully = dict?.valueForString(key: "reset_password_changed_successfully")
            tblLanguageText.reset_password_min_val = dict?.valueForString(key: "reset_password_min_val")
            tblLanguageText.reset_update = dict?.valueForString(key: "reset_update")
            tblLanguageText.reset_verification_code_cant_blank = dict?.valueForString(key: "reset_verification_code_cant_blank")
            tblLanguageText.reset_verification_code_incorrect = dict?.valueForString(key: "reset_verification_code_incorrect")
            tblLanguageText.reset_verification_code_invalid = dict?.valueForString(key: "reset_verification_code_invalid")
            
            //register Screen Messages...
            
            tblLanguageText.success = dict?.valueForString(key: "success")
            
            tblLanguageText.register = dict?.valueForString(key: "register")
            tblLanguageText.register_choose_from_phone = dict?.valueForString(key: "register_choose_from_phone")
            tblLanguageText.register_code = dict?.valueForString(key: "register_code")
            tblLanguageText.register_confirm_entered_email_and_mobile = dict?.valueForString(key: "register_confirm_entered_email_and_mobile")
            tblLanguageText.register_confirm_password = dict?.valueForString(key: "register_confirm_password")
            tblLanguageText.register_confirm_password_blank = dict?.valueForString(key: "register_confirm_password_blank")
            tblLanguageText.register_country_code_cant_blank = dict?.valueForString(key: "register_country_code_cant_blank")
            tblLanguageText.register_dob = dict?.valueForString(key: "register_dob")
            tblLanguageText.register_dob_cant_blank = dict?.valueForString(key: "register_dob_cant_blank")
            tblLanguageText.register_email = dict?.valueForString(key: "register_email")
            tblLanguageText.register_email_cant_blank = dict?.valueForString(key: "register_email_cant_blank")
            tblLanguageText.register_email_verification_text = dict?.valueForString(key: "register_email_verification_text")
            tblLanguageText.register_enter_valid_email_address = dict?.valueForString(key: "register_enter_valid_email_address")
            tblLanguageText.register_enter_valid_mobile_no = dict?.valueForString(key: "register_enter_valid_mobile_no")
            tblLanguageText.register_enter_verification_code = dict?.valueForString(key: "register_enter_verification_code")
            tblLanguageText.register_female = dict?.valueForString(key: "register_female")
            tblLanguageText.register_first_name = dict?.valueForString(key: "register_first_name")
            tblLanguageText.register_first_name_cant_blank = dict?.valueForString(key: "register_first_name_cant_blank")
            tblLanguageText.register_gender = dict?.valueForString(key: "register_gender")
            tblLanguageText.register_gender_cant_blank = dict?.valueForString(key: "register_gender_cant_blank")
            tblLanguageText.register_last_name = dict?.valueForString(key: "register_last_name")
            tblLanguageText.register_last_name_cant_blank = dict?.valueForString(key: "register_last_name_cant_blank")
            tblLanguageText.register_male = dict?.valueForString(key: "register_male")
            tblLanguageText.register_mobile_cant_blank = dict?.valueForString(key: "register_mobile_cant_blank")
            tblLanguageText.register_mobile_number = dict?.valueForString(key: "register_mobile_number")
            tblLanguageText.register_mobile_verification_text = dict?.valueForString(key: "register_mobile_verification_text")
            tblLanguageText.register_password_check_same = dict?.valueForString(key: "register_password_check_same")
            tblLanguageText.register_others = dict?.valueForString(key: "register_others")
            tblLanguageText.register_password_cant_blank = dict?.valueForString(key: "register_password_cant_blank")
            tblLanguageText.register_password_min_val = dict?.valueForString(key: "register_password_min_val")
            tblLanguageText.remove_photo = dict?.valueForString(key: "remove_photo")
            tblLanguageText.register_resend_code = dict?.valueForString(key: "register_resend_code")
            tblLanguageText.register_select_location = dict?.valueForString(key: "register_select_location")
            tblLanguageText.register_signup = dict?.valueForString(key: "register_signup")
            tblLanguageText.register_take_photo = dict?.valueForString(key: "register_take_photo")
            tblLanguageText.relationship_id_messagenot_valid = dict?.valueForString(key: "relationship_id_messagenot_valid")
            tblLanguageText.register_password = dict?.valueForString(key: "register_password")
            tblLanguageText.register_location_cant_blank = dict?.valueForString(key: "register_location_cant_blank")
            
            //Select Interest and Invite&Connect Screens...
            tblLanguageText.add_your_interests_passions = dict?.valueForString(key: "add_your_interests_passions")
            tblLanguageText.invite_select_all = dict?.valueForString(key: "invite_select_all")
            tblLanguageText.create_own_interest = dict?.valueForString(key: "create_own_interest")
            tblLanguageText.interest_name_cant_blank = dict?.valueForString(key: "interest_name_cant_blank")
            tblLanguageText.invite_contact = dict?.valueForString(key: "invite_contact")
            tblLanguageText.invite_friends = dict?.valueForString(key: "invite_friends")
            tblLanguageText.invite_import_contacts_form = dict?.valueForString(key: "invite_import_contacts_form")
            tblLanguageText.invite_import_contacts_text = dict?.valueForString(key: "invite_import_contacts_text")
            
            
            //Sidemenu Messages...
            tblLanguageText.sidemenu_PSL = dict?.valueForString(key: "sidemenu_PSL")
            tblLanguageText.successfully_signup = dict?.valueForString(key: "successfully_signup")
            tblLanguageText.sidemenu_chats = dict?.valueForString(key: "sidemenu_chats")
            tblLanguageText.sidemenu_connect_invite = dict?.valueForString(key: "sidemenu_connect_invite")
            tblLanguageText.sidemenu_event_calendar = dict?.valueForString(key: "sidemenu_event_calendar")
            tblLanguageText.sidemenu_fav_websites = dict?.valueForString(key: "sidemenu_fav_websites")
            tblLanguageText.sidemenu_groups = dict?.valueForString(key: "sidemenu_groups")
            tblLanguageText.sidemenu_home = dict?.valueForString(key: "sidemenu_home")
            tblLanguageText.sidemenu_logout = dict?.valueForString(key: "sidemenu_logout")
            tblLanguageText.sidemenu_news = dict?.valueForString(key: "sidemenu_news")
            tblLanguageText.sidemenu_notifications = dict?.valueForString(key: "sidemenu_notifications")
            tblLanguageText.sidemenu_post_ads = dict?.valueForString(key: "sidemenu_post_ads")
            tblLanguageText.sidemenu_profile = dict?.valueForString(key: "sidemenu_profile")
            tblLanguageText.sidemenu_quotes = dict?.valueForString(key: "sidemenu_quotes")
            tblLanguageText.sidemenu_settings = dict?.valueForString(key: "sidemenu_settings")
            
            
            //Profile Messages...
            tblLanguageText.edit_profile = dict?.valueForString(key: "edit_profile")
            tblLanguageText.profile_add_your_interest = dict?.valueForString(key: "profile_add_your_interest")
            tblLanguageText.profile_biography = dict?.valueForString(key: "profile_biography")
            tblLanguageText.profile_complete = dict?.valueForString(key: "profile_complete")
            tblLanguageText.profile_education = dict?.valueForString(key: "profile_education")
            tblLanguageText.profile_employed = dict?.valueForString(key: "profile_employed")
            tblLanguageText.profile_income_level = dict?.valueForString(key: "profile_income_level")
            tblLanguageText.profile_personal_interest = dict?.valueForString(key: "profile_personal_interest")
            tblLanguageText.profile_preferences = dict?.valueForString(key: "profile_preferences")
            tblLanguageText.profile_profession = dict?.valueForString(key: "profile_profession")
            tblLanguageText.profile_enter_your_profession = dict?.valueForString(key: "profile_enter_your_profession")
            tblLanguageText.profile_religious_inclination = dict?.valueForString(key: "profile_religious_inclination")
            tblLanguageText.profile_select_income = dict?.valueForString(key: "profile_select_income")
            tblLanguageText.profile_status = dict?.valueForString(key: "profile_status")
            tblLanguageText.profile_update_complete = dict?.valueForString(key: "profile_update_complete")
            tblLanguageText.view_complete_profile = dict?.valueForString(key: "view_complete_profile")
            tblLanguageText.posts = dict?.valueForString(key: "posts")
            tblLanguageText.post = dict?.valueForString(key: "post")
            tblLanguageText.ads_posted = dict?.valueForString(key: "ads_posted")
            tblLanguageText.time_spent = dict?.valueForString(key: "time_spent")
            tblLanguageText.time_spent = dict?.valueForString(key: "time_spent")
            tblLanguageText.data_upload = dict?.valueForString(key: "data_upload")
            tblLanguageText.my_profile = dict?.valueForString(key: "my_profile")
            tblLanguageText.friends = dict?.valueForString(key: "friends")
            tblLanguageText.friend = dict?.valueForString(key: "friend")
            tblLanguageText.likes = dict?.valueForString(key: "likes")
            tblLanguageText.like = dict?.valueForString(key: "like")
            tblLanguageText.profile_contact_us = dict?.valueForString(key: "profile_contact_us")
            tblLanguageText.success = dict?.valueForString(key: "Success")
           
            //Setting Screen Messages...
            tblLanguageText.settings = dict?.valueForString(key: "settings")
            
            tblLanguageText.settings_change_password = dict?.valueForString(key: "settings_change_password")
            tblLanguageText.settings_email_notifications = dict?.valueForString(key: "settings_email_notifications")
            tblLanguageText.settings_feedback = dict?.valueForString(key: "settings_feedback")
            tblLanguageText.settings_push_notifications = dict?.valueForString(key: "settings_push_notifications")
            tblLanguageText.settings_terms_conditions = dict?.valueForString(key: "settings_terms_conditions")
            tblLanguageText.privacy_policy = dict?.valueForString(key: "privacy_policy")
            tblLanguageText.about_us = dict?.valueForString(key: "about_us")
            tblLanguageText.settings_language = dict?.valueForString(key: "settings_language")
            tblLanguageText.feedback_txt = dict?.valueForString(key: "feedback_txt")
            tblLanguageText.blocked_users = dict?.valueForString(key: "blocked_users")
            tblLanguageText.others = dict?.valueForString(key: "Others")
            tblLanguageText.profile_visible_for_friends = dict?.valueForString(key: "profile_visible_for_friends")
            tblLanguageText.profile_visible_for_others = dict?.valueForString(key: "profile_visible_for_others")
            tblLanguageText.basic = dict?.valueForString(key: "basic")
            tblLanguageText.complete = dict?.valueForString(key: "complete")
            tblLanguageText.old_password = dict?.valueForString(key: "Old_password")
            tblLanguageText.please_enter_old_password = dict?.valueForString(key: "Please_enter_old_password")
            tblLanguageText.select_category = dict?.valueForString(key: "select_category")
            tblLanguageText.feedback_category_required = dict?.valueForString(key: "feedback_category_required")
            tblLanguageText.blocked_user = dict?.valueForString(key: "blocked_user")
            tblLanguageText.unblock_user = dict?.valueForString(key: "unblock_user")
            tblLanguageText.select_language = dict?.valueForString(key: "select_language")
            tblLanguageText.blocked_users_count = dict?.valueForString(key: "blocked_users_count")
            
            //Home Screen Messages...
            tblLanguageText.article = dict?.valueForString(key: "article")
            tblLanguageText.chirpy = dict?.valueForString(key: "chirpy")
            tblLanguageText.forum = dict?.valueForString(key: "forum")
            tblLanguageText.event = dict?.valueForString(key: "event")
            tblLanguageText.shout = dict?.valueForString(key: "shout")
            tblLanguageText.image = dict?.valueForString(key: "image")
            tblLanguageText.user = dict?.valueForString(key: "user")
            tblLanguageText.all = dict?.valueForString(key: "all")
            tblLanguageText.gallery = dict?.valueForString(key: "gallery")
            
            //Group Screen...
            tblLanguageText.upload_image = dict?.valueForString(key: "upload_image")
            tblLanguageText.create_group_enter_title = dict?.valueForString(key: "create_group_enter_title")
            tblLanguageText.create_a_group_link_to_join_this_group = dict?.valueForString(key: "create_a_group_link_to_join_this_group")
            tblLanguageText.group_public = dict?.valueForString(key: "public")
            tblLanguageText.group_private = dict?.valueForString(key: "private")
            tblLanguageText.add_participant = dict?.valueForString(key: "add_participant")
            tblLanguageText.members_selected = dict?.valueForString(key: "members_selected")
            tblLanguageText.group_info_add_more = dict?.valueForString(key: "group_info_add_more")
            tblLanguageText.group_image_required = dict?.valueForString(key: "group_image_required")
            tblLanguageText.group_title_cant_blank = dict?.valueForString(key: "group_title_cant_blank")
            tblLanguageText.group_details = dict?.valueForString(key: "group_details")
            tblLanguageText.edit_group = dict?.valueForString(key: "edit_group")
            tblLanguageText.delete_group = dict?.valueForString(key: "delete_group")
            tblLanguageText.group_info_link = dict?.valueForString(key: "group_info_link")
            tblLanguageText.admin = dict?.valueForString(key: "admin")
            tblLanguageText.report_group = dict?.valueForString(key: "report_group")
            tblLanguageText.group_member = dict?.valueForString(key: "group_member")
            tblLanguageText.group_members = dict?.valueForString(key: "group_members")
            tblLanguageText.exit_group = dict?.valueForString(key: "exit_group")
            tblLanguageText.group_type_cant_blank = dict?.valueForString(key: "group_type_cant_blank")
            tblLanguageText.group_member_not_selected = dict?.valueForString(key: "group_member_not_selected")
            tblLanguageText.group_members_minimum = dict?.valueForString(key: "group_members_minimum")
            tblLanguageText.no_comment_found = dict?.valueForString(key: "no_comment_found")
            tblLanguageText.block_user_alert = dict?.valueForString(key: "block_user_alert")
            tblLanguageText.new_group = dict?.valueForString(key: "new_group")
            tblLanguageText.just_now = dict?.valueForString(key: "just_now")
            tblLanguageText.min_ago = dict?.valueForString(key: "min_ago")
            tblLanguageText.mins_ago = dict?.valueForString(key: "mins_ago")
            tblLanguageText.hour_ago = dict?.valueForString(key: "hour_ago")
            tblLanguageText.hours_ago = dict?.valueForString(key: "hours_ago")
            tblLanguageText.day_ago = dict?.valueForString(key: "day_ago")
            tblLanguageText.days_ago = dict?.valueForString(key: "days_ago")
            tblLanguageText.info = dict?.valueForString(key: "info")
            tblLanguageText.you_blocked_this_user = dict?.valueForString(key: "you_blocked_this_user")
            tblLanguageText.delivered_on = dict?.valueForString(key: "delivered_on")
            tblLanguageText.delivered_to = dict?.valueForString(key: "delivered_to")
            tblLanguageText.members_of_this_group = dict?.valueForString(key: "members_of_this_group")
            tblLanguageText.not_delivered = dict?.valueForString(key: "not_delivered")
            tblLanguageText.delete_for_me = dict?.valueForString(key: "delete_for_me")
            tblLanguageText.delete_for_everyone = dict?.valueForString(key: "delete_for_everyone")
            
            //Article Screens...
            tblLanguageText.edit_article = dict?.valueForString(key: "edit_article")
            tblLanguageText.edit_article = dict?.valueForString(key: "edit_article")
            tblLanguageText.add_article = dict?.valueForString(key: "add_article")
            tblLanguageText.enter_article_title = dict?.valueForString(key: "enter_article_title")
            tblLanguageText.select_category_of_article = dict?.valueForString(key: "select_category_of_article")
            tblLanguageText.write_an_article_content_here = dict?.valueForString(key: "write_an_article_content_here")
            tblLanguageText.posts_minimum_age = dict?.valueForString(key: "posts_minimum_age")
            tblLanguageText.posts_invite_allFriends = dict?.valueForString(key: "posts_invite_allFriends")
            tblLanguageText.posts_invite_friends = dict?.valueForString(key: "posts_invite_friends")
            tblLanguageText.posts_invite_group = dict?.valueForString(key: "posts_invite_group")
            tblLanguageText.article_title_cant_blank = dict?.valueForString(key: "article_title_cant_blank")
            tblLanguageText.article_category_cant_blank = dict?.valueForString(key: "article_category_cant_blank")
            tblLanguageText.targeted_content_cant_blank = dict?.valueForString(key: "targeted_content_cant_blank")
            tblLanguageText.event_age_limit = dict?.valueForString(key: "event_age_limit")
            tblLanguageText.article_targeted_audience_cant_blank = dict?.valueForString(key: "article_targeted_audience_cant_blank")
            tblLanguageText.article_image_cant_blank = dict?.valueForString(key: "article_image_cant_blank")
            tblLanguageText.article_details = dict?.valueForString(key: "article_details")
            tblLanguageText.posts_select_friends = dict?.valueForString(key: "posts_select_friends")
            tblLanguageText.article_created_successfully = dict?.valueForString(key: "article_created_successfully")
            tblLanguageText.article_edited_successfully = dict?.valueForString(key: "article_edited_successfully")
            
            //Forum Screens...
            tblLanguageText.edit_forum = dict?.valueForString(key: "edit_forum")
            tblLanguageText.enter_forum_category = dict?.valueForString(key: "enter_forum_category")
            tblLanguageText.enter_forum_content = dict?.valueForString(key: "enter_forum_content")
            tblLanguageText.enter_forum_title = dict?.valueForString(key: "enter_forum_title")
            tblLanguageText.forum_category_cant_blank = dict?.valueForString(key: "forum_category_cant_blank")
            tblLanguageText.forum_title_cant_blank = dict?.valueForString(key: "forum_title_cant_blank")
            tblLanguageText.forum_targeted_audience_cant_blank = dict?.valueForString(key: "forum_targeted_audience_cant_blank")
            tblLanguageText.forum_details = dict?.valueForString(key: "forum_details")
            tblLanguageText.forum_content_cant_blank = dict?.valueForString(key: "forum_content_cant_blank")
            tblLanguageText.forum_created_successfully = dict?.valueForString(key: "forum_created_successfully")
            tblLanguageText.forum_edited_successfully = dict?.valueForString(key: "forum_edited_successfully")
            
            //Event Screens...
            tblLanguageText.add_event = dict?.valueForString(key: "add_event")
            tblLanguageText.edit_event = dict?.valueForString(key: "edit_event")
            tblLanguageText.enter_event_title = dict?.valueForString(key: "enter_event_title")
            tblLanguageText.select_category_of_event = dict?.valueForString(key: "select_category_of_event")
            tblLanguageText.enter_event_end_date = dict?.valueForString(key: "enter_event_end_date")
            tblLanguageText.enter_event_start_date = dict?.valueForString(key: "enter_event_start_date")
            tblLanguageText.enter_event_location = dict?.valueForString(key: "enter_event_location")
            tblLanguageText.event_title_cant_blank = dict?.valueForString(key: "event_title_cant_blank")
            tblLanguageText.event_category_cant_blank = dict?.valueForString(key: "event_category_cant_blank")
            tblLanguageText.event_content_cant_blank = dict?.valueForString(key: "event_content_cant_blank")
            tblLanguageText.event_start_date_cant_blank = dict?.valueForString(key: "event_start_date_cant_blank")
            tblLanguageText.event_end_date_cant_blank = dict?.valueForString(key: "event_end_date_cant_blank")
            tblLanguageText.event_targeted_audience_cant_blank = dict?.valueForString(key: "event_targeted_audience_cant_blank")
            tblLanguageText.all_events = dict?.valueForString(key: "all_events")
            tblLanguageText.my_events = dict?.valueForString(key: "my_events")
            tblLanguageText.invites_accepted_event = dict?.valueForString(key: "invites_accepted_event")
            tblLanguageText.event_calendar = dict?.valueForString(key: "event_calendar")
            tblLanguageText.event_details = dict?.valueForString(key: "event_details")
            tblLanguageText.event_view_all = dict?.valueForString(key: "event_view_all")
            tblLanguageText.interested = dict?.valueForString(key: "interested")
            tblLanguageText.not_interested = dict?.valueForString(key: "not_interested")
            tblLanguageText.may_be = dict?.valueForString(key: "may_be")
            tblLanguageText.event_location_cant_blank = dict?.valueForString(key: "event_location_cant_blank")
            tblLanguageText.write_an_event_content_here = dict?.valueForString(key: "write_an_event_content_here")
            tblLanguageText.event_created_successfully = dict?.valueForString(key: "event_created_successfully")
            tblLanguageText.event_edited_successfully = dict?.valueForString(key: "event_edited_successfully")
            tblLanguageText.no_events_yet = dict?.valueForString(key: "no_events_yet")
            
            //Chirpy Screens...
            tblLanguageText.add_chirpy = dict?.valueForString(key: "add_chirpy")
            tblLanguageText.edit_chirpy = dict?.valueForString(key: "edit_chirpy")
            tblLanguageText.chirpy_details = dict?.valueForString(key: "chirpy_details")
            tblLanguageText.select_category_of_chirpy = dict?.valueForString(key: "select_category_of_chirpy")
            tblLanguageText.enter_chirpy_content = dict?.valueForString(key: "enter_chirpy_content")
            tblLanguageText.chirpy_category_cant_blank = dict?.valueForString(key: "chirpy_category_cant_blank")
            tblLanguageText.chirpy_message_cant_blank = dict?.valueForString(key: "chirpy_message_cant_blank")
            tblLanguageText.post_targeted_audience_cant_blank = dict?.valueForString(key: "post_targeted_audience_cant_blank")
            tblLanguageText.chirpy_created_successfully = dict?.valueForString(key: "chirpy_created_successfully")
            tblLanguageText.chirpy_edited_successfully = dict?.valueForString(key: "chirpy_edited_successfully")
            
            //Shout Screens...
            tblLanguageText.post_shout = dict?.valueForString(key: "post_shout")
            tblLanguageText.edit_shout = dict?.valueForString(key: "edit_shout")
            tblLanguageText.add_shout = dict?.valueForString(key: "add_shout")
            tblLanguageText.shout_details = dict?.valueForString(key: "shout_details")
            tblLanguageText.enter_shout_content = dict?.valueForString(key: "enter_shout_content")
            tblLanguageText.shout_message_cant_blank = dict?.valueForString(key: "shout_message_cant_blank")
            tblLanguageText.please_select_to_whom_you_want_to_post_this_shout = dict?.valueForString(key: "please_select_to_whom_you_want_to_post_this_shout")
            tblLanguageText.select_image = dict?.valueForString(key: "select_image")
            tblLanguageText.add_forum = dict?.valueForString(key: "add_forum")
            tblLanguageText.add_image = dict?.valueForString(key: "add_image")
            tblLanguageText.shout_created_successfully = dict?.valueForString(key: "shout_created_successfully")
            tblLanguageText.shout_edited_successfully = dict?.valueForString(key: "shout_edited_successfully")
            
            //Image Screens...
            tblLanguageText.edit_image = dict?.valueForString(key: "edit_image")
            tblLanguageText.gallery_edited_successfully = dict?.valueForString(key: "gallery_edited_successfully")
            tblLanguageText.please_select_to_whom_you_want_to_post_this_image = dict?.valueForString(key: "please_select_to_whom_you_want_to_post_this_image")
            tblLanguageText.post_upload_images_maximum = dict?.valueForString(key: "post_upload_images_maximum")
            tblLanguageText.alert_delete_message_image = dict?.valueForString(key: "alert_delete_message_image")
            tblLanguageText.post_upload_fail = dict?.valueForString(key: "post_upload_fail")
            
            //General Messages...
            tblLanguageText.please_wait = dict?.valueForString(key: "please_wait")
            tblLanguageText.group_report_submitted_success = dict?.valueForString(key: "group_report_submitted_success")
            
            //Report
            tblLanguageText.report_article = dict?.valueForString(key: "report_article")
            tblLanguageText.report_forum = dict?.valueForString(key: "report_forum")
            tblLanguageText.report_gallery = dict?.valueForString(key: "report_gallery")
            tblLanguageText.report_event = dict?.valueForString(key: "report_event")
            tblLanguageText.report_chirpy = dict?.valueForString(key: "report_chirpy")
            tblLanguageText.report_shout = dict?.valueForString(key: "report_shout")
            tblLanguageText.please_select_report_reason = dict?.valueForString(key: "please_select_report_reason")
            
            //Button Messages...
            tblLanguageText.edit = dict?.valueForString(key: "edit")
            tblLanguageText.delete = dict?.valueForString(key: "delete")
            tblLanguageText.view_all = dict?.valueForString(key: "view_all")
            
            tblLanguageText.posted_on = dict?.valueForString(key: "posted_on")
            tblLanguageText.share = dict?.valueForString(key: "share")
            tblLanguageText.cancel = dict?.valueForString(key: "cancel")
            tblLanguageText.ok = dict?.valueForString(key: "ok")
            tblLanguageText.confirm = dict?.valueForString(key: "confirm")
            tblLanguageText.confirmed = dict?.valueForString(key: "confirmed")
            tblLanguageText.add_friend = dict?.valueForString(key: "add_friend")
            tblLanguageText.unfriend = dict?.valueForString(key: "unfriend")
            tblLanguageText.cancel_request = dict?.valueForString(key: "cancel_request")
            tblLanguageText.accept = dict?.valueForString(key: "accept")
            tblLanguageText.reject = dict?.valueForString(key: "reject")
            tblLanguageText.block_user = dict?.valueForString(key: "block_user")
            tblLanguageText.ublock_user = dict?.valueForString(key: "ublock_user")
            tblLanguageText.report_user = dict?.valueForString(key: "report_user")
            tblLanguageText.done = dict?.valueForString(key: "done")
            tblLanguageText.next = dict?.valueForString(key: "next")
            tblLanguageText.skip = dict?.valueForString(key: "skip")
            tblLanguageText.save = dict?.valueForString(key: "save")
            tblLanguageText.un_employed = dict?.valueForString(key: "un_employed")
            tblLanguageText.student = dict?.valueForString(key: "student")
            tblLanguageText.invitation_sent_successfully = dict?.valueForString(key: "invitation_sent_successfully")
            tblLanguageText.invitation_sent_fail = dict?.valueForString(key: "invitation_sent_fail")
            
            tblLanguageText.no_groups_yet = dict?.valueForString(key: "no_groups_yet")
            tblLanguageText.no_member_request_yet = dict?.valueForString(key: "no_member_request_yet")
            tblLanguageText.alert_remove_participant_message = dict?.valueForString(key: "alert_remove_participant_message")
            tblLanguageText.alert_delete_message = dict?.valueForString(key: "alert_delete_message")
            tblLanguageText.alert_exit_message = dict?.valueForString(key: "alert_exit_message")
            tblLanguageText.no_participant_yet = dict?.valueForString(key: "no_participant_yet")
            tblLanguageText.post_select_groups = dict?.valueForString(key: "post_select_groups")
            tblLanguageText.post_select_contacts = dict?.valueForString(key: "post_select_contacts")
            tblLanguageText.no_contacts_yet = dict?.valueForString(key: "no_contacts_yet")
            tblLanguageText.no_comments_yet = dict?.valueForString(key: "no_comments_yet")
            tblLanguageText.type_your_message = dict?.valueForString(key: "type_your_message")
            tblLanguageText.cancel_subscription_alert = dict?.valueForString(key: "cancel_subscription_alert")
            tblLanguageText.unblock_user_alert = dict?.valueForString(key: "unblock_user_alert")
            tblLanguageText.yes = dict?.valueForString(key: "yes")
            tblLanguageText.no = dict?.valueForString(key: "no")
            tblLanguageText.add_interest = dict?.valueForString(key: "add_interest")
            tblLanguageText.filters = dict?.valueForString(key: "filters")
            tblLanguageText.which_types_of_post_you_are_looking = dict?.valueForString(key: "which_types_of_post_you_are_looking")
            tblLanguageText.are_you_sure_you_want_to_delete_this_post = dict?.valueForString(key: "are_you_sure_you_want_to_delete_this_post")
            tblLanguageText.no_blocked_users_yet = dict?.valueForString(key: "no_blocked_users_yet")
            tblLanguageText.sorry_your_device_is_not_support_mail = dict?.valueForString(key: "sorry_your_device_is_not_support_mail")
            tblLanguageText.are_you_sure_you_want_to_logout = dict?.valueForString(key: "are_you_sure_you_want_to_logout")
            tblLanguageText.apply_filter = dict?.valueForString(key: "apply_filter")
            tblLanguageText.reset = dict?.valueForString(key: "reset")
            tblLanguageText.event_end_date_must_be_greater = dict?.valueForString(key: "event_end_date_must_be_greater")
            tblLanguageText.view_image = dict?.valueForString(key: "view_image")
            tblLanguageText.no_interests_select = dict?.valueForString(key: "no_interests_select")
            tblLanguageText.alert_message_for_cancel = dict?.valueForString(key: "alert_message_for_cancel")
            tblLanguageText.alert_message_for_unfriend = dict?.valueForString(key: "alert_message_for_unfriend")
            tblLanguageText.comments = dict?.valueForString(key: "comments")
            tblLanguageText.write_your_message_here = dict?.valueForString(key: "write_your_message_here")
            tblLanguageText.camera = dict?.valueForString(key: "camera")
            tblLanguageText.audio = dict?.valueForString(key: "audio")
            tblLanguageText.video = dict?.valueForString(key: "video")
            tblLanguageText.link_copied = dict?.valueForString(key: "link_copied")
            tblLanguageText.start_date = dict?.valueForString(key: "start_date")
            tblLanguageText.end_date = dict?.valueForString(key: "end_date")
            tblLanguageText.group_type_change_alert_to_private = dict?.valueForString(key: "group_type_change_alert_to_private")
            tblLanguageText.group_type_change_alert_to_private_message = dict?.valueForString(key: "group_type_change_alert_to_private_message")
            tblLanguageText.group_type_change_alert_to_public = dict?.valueForString(key: "group_type_change_alert_to_public")
            tblLanguageText.group_type_change_alert_to_public_message = dict?.valueForString(key: "group_type_change_alert_to_public_message")
            tblLanguageText.about_event = dict?.valueForString(key: "about_event")
            tblLanguageText.no_likes_found = dict?.valueForString(key: "no_likes_found")
            tblLanguageText.contact_permission_is_required = dict?.valueForString(key: "contact_permission_is_required")
            tblLanguageText.there_is_no_friend_to_connect = dict?.valueForString(key: "there_is_no_friend_to_connect")
            tblLanguageText.select_country = dict?.valueForString(key: "select_country")
            tblLanguageText.go_to_website = dict?.valueForString(key: "go_to_website")
            tblLanguageText.this_feature_is_not_available_go_to_website = dict?.valueForString(key: "this_feature_is_not_available_go_to_website")
            tblLanguageText.invite = dict?.valueForString(key: "invite")
            tblLanguageText.connect_all = dict?.valueForString(key: "connect_all")
            tblLanguageText.connect = dict?.valueForString(key: "connect")
            tblLanguageText.no_data_found = dict?.valueForString(key: "no_data_found")
            tblLanguageText.pending_request = dict?.valueForString(key: "pending_request")
            tblLanguageText.all_friends = dict?.valueForString(key: "all_friends")
            tblLanguageText.request_send = dict?.valueForString(key: "request_send")
            tblLanguageText.unblock = dict?.valueForString(key: "unblock")
            tblLanguageText.provided_by = dict?.valueForString(key: "provided_by")
            tblLanguageText.abusive_language = dict?.valueForString(key: "Abusive Language")
            tblLanguageText.inappropriate_behavior = dict?.valueForString(key: "Inappropriate Behavior")
            tblLanguageText.look_like_spam_user = dict?.valueForString(key: "Looks like spam")
            tblLanguageText.no_posts_found = dict?.valueForString(key: "no_posts_found")
            tblLanguageText.join = dict?.valueForString(key: "join")
            tblLanguageText.member_request = dict?.valueForString(key: "member_request")
            tblLanguageText.report_confirmation = dict?.valueForString(key: "report_confirmation")
            tblLanguageText.account_privacy_msg = dict?.valueForString(key: "account_privacy_msg")
            tblLanguageText.admin_deleted_this_message = dict?.valueForString(key: "admin_deleted_this_message")
            tblLanguageText.report_group_alert_message = dict?.valueForString(key: "report_group_alert_message")
            tblLanguageText.today = dict?.valueForString(key: "today")
            tblLanguageText.yesterday = dict?.valueForString(key: "yesterday")
            tblLanguageText.user_deleted_this_message = dict?.valueForString(key: "user_deleted_this_message")
            tblLanguageText.user_deleted_this_message = dict?.valueForString(key: "user_deleted_this_message")
            tblLanguageText.check_this_in_web_site = dict?.valueForString(key: "check_this_in_web_site")
            tblLanguageText.check_this_in_user = dict?.valueForString(key: "check_this_in_user")
            tblLanguageText.check_this_in_post = dict?.valueForString(key: "check_this_in_post")
            tblLanguageText.no_news_for_this_category = dict?.valueForString(key: "no_news_for_this_category")
            
            
            // Phase - 2
            
            tblLanguageText.add_poll = dict?.valueForString(key: "add_poll")
            tblLanguageText.create_shout = dict?.valueForString(key: "create_shout")
            tblLanguageText.select_category_of_poll = dict?.valueForString(key: "select_category_of_poll")
            tblLanguageText.add_question = dict?.valueForString(key: "add_question")
            tblLanguageText.upload_media = dict?.valueForString(key: "upload_media")
            tblLanguageText.media_max_upload_size = dict?.valueForString(key: "media_max_upload_size")
            tblLanguageText.poll = dict?.valueForString(key: "poll")
            tblLanguageText.files = dict?.valueForString(key: "files")
            tblLanguageText.create_folder = dict?.valueForString(key: "create_folder")
            tblLanguageText.confirm = dict?.valueForString(key: "confirm")
            tblLanguageText.no_internet = dict?.valueForString(key: "no_internet")
            
            tblLanguageText.please_check_internet_connection = dict?.valueForString(key: "please_check_internet_connection")
            tblLanguageText.try_again = dict?.valueForString(key: "try_again")
            tblLanguageText.files = dict?.valueForString(key: "files")
            tblLanguageText.no_files_added_in_this_folder = dict?.valueForString(key: "no_files_added_in_this_folder")
            tblLanguageText.shared_list = dict?.valueForString(key: "shared_list")
            tblLanguageText.shared_files = dict?.valueForString(key: "shared_files")
            tblLanguageText.poll_user_list = dict?.valueForString(key: "poll_user_list")
            tblLanguageText.add_media = dict?.valueForString(key: "add_media")
            tblLanguageText.sidemenu_groups = dict?.valueForString(key: "sidemenu_groups")
            tblLanguageText.shout_groups = dict?.valueForString(key: "shout_groups")
            tblLanguageText.shout_friends = dict?.valueForString(key: "shout_friends")
            tblLanguageText.shout_public = dict?.valueForString(key: "shout_public")
            tblLanguageText.friends = dict?.valueForString(key: "friends")
            tblLanguageText.may_be = dict?.valueForString(key: "may_be")
            tblLanguageText.like = dict?.valueForString(key: "like")
            tblLanguageText.gallery = dict?.valueForString(key: "gallery")
            tblLanguageText.my_files = dict?.valueForString(key: "my_files")
            tblLanguageText.report = dict?.valueForString(key: "report")
            tblLanguageText.option = dict?.valueForString(key: "option")
            tblLanguageText.declined = dict?.valueForString(key: "declined")
            tblLanguageText.comments = dict?.valueForString(key: "comments")
            tblLanguageText.no_folders_has_been_shared_with_you = dict?.valueForString(key: "no_folders_has_been_shared_with_you")
            tblLanguageText.search = dict?.valueForString(key: "search")
            tblLanguageText.gallery_category_cant_blank = dict?.valueForString(key: "gallery_category_cant_blank")
            tblLanguageText.please_enter_poll_category = dict?.valueForString(key: "please_enter_poll_category")
            tblLanguageText.please_enter_question = dict?.valueForString(key: "please_enter_question")
            tblLanguageText.folder_name_cant_be_blank = dict?.valueForString(key: "folder_name_cant_be_blank")
            tblLanguageText.upgrade_storage = dict?.valueForString(key: "upgrade_storage")
            tblLanguageText.upgrade_now = dict?.valueForString(key: "upgrade_now")
            tblLanguageText.contacts = dict?.valueForString(key: "contacts")
            tblLanguageText.poll_detail = dict?.valueForString(key: "poll_detail")
            tblLanguageText.votes = dict?.valueForString(key: "votes")
            tblLanguageText.vote = dict?.valueForString(key: "vote")
            tblLanguageText.invitees = dict?.valueForString(key: "invitees")
            tblLanguageText.terms_and_conditions = dict?.valueForString(key: "terms_and_conditions")
            tblLanguageText.confirmation_to_delete_folder = dict?.valueForString(key: "confirmation_to_delete_folder")
            tblLanguageText.confirmation_to_delete_file = dict?.valueForString(key: "confirmation_to_delete_file")
            tblLanguageText.poll_option_already_exist = dict?.valueForString(key: "poll_option_already_exist")
            tblLanguageText.file_type_not_allowed = dict?.valueForString(key: "file_type_not_allowed")
            tblLanguageText.files = dict?.valueForString(key: "files")
            
            tblLanguageText.there_is_some_issue_in_uploading_files = dict?.valueForString(key: "there_is_some_issue_in_uploading_files")
            tblLanguageText.there_is_some_issue_in_uploading_file = dict?.valueForString(key: "there_is_some_issue_in_uploading_file.")
            tblLanguageText.alert_message_for_files_not_uploaded = dict?.valueForString(key: "alert_message_for_files_not_uploaded")
            tblLanguageText.message_for_wrong_file_type = dict?.valueForString(key: "message_for_wrong_file_type")
            
            tblLanguageText.do_you_want_to_share_this_folder_with_friends = dict?.valueForString(key: "do_you_want_to_share_this_folder_with_friends")
            tblLanguageText.rename_folder = dict?.valueForString(key: "rename_folder")
            tblLanguageText.no_friends_yet = dict?.valueForString(key: "no_friends_yet")
            tblLanguageText.comment = dict?.valueForString(key: "comment")
            tblLanguageText.no_folder_created = dict?.valueForString(key: "no_folder_created")
            tblLanguageText.are_you_sure_to_share_folder = dict?.valueForString(key: "are_you_sure_to_share_folder")
            tblLanguageText.alert_message_to_remove_share_folder = dict?.valueForString(key: "alert_message_to_remove_share_folder")
            
            tblLanguageText.please_select_atleast_one_image_video = dict?.valueForString(key: "please_select_atleast_one_image_video")
            tblLanguageText.are_you_sure_to_delete_this_media = dict?.valueForString(key: "are_you_sure_to_delete_this_media")
            tblLanguageText.payment = dict?.valueForString(key: "payment")
            
            tblLanguageText.minimum_polls_options = dict?.valueForString(key: "minimum_polls_options")
            tblLanguageText.retry = dict?.valueForString(key: "retry")
            tblLanguageText.try_again = dict?.valueForString(key: "try_again")
            tblLanguageText.you_havent_shared_any_folders_with_your_friends = dict?.valueForString(key: "you_havent_shared_any_folders_with_your_friends")
            tblLanguageText.un_supported_file_type = dict?.valueForString(key: "un_supported_file_type")
            tblLanguageText.your_storage_is_full_need_to_upgrade_storage = dict?.valueForString(key: "your_storage_is_full_need_to_upgrade_storage")
            tblLanguageText.poll_created_successfully = dict?.valueForString(key: "poll_created_successfully")
            
            tblLanguageText.your_device_does_not_support_camera = dict?.valueForString(key: "your_device_does_not_support_camera")
            tblLanguageText.clip_must_not_exceed_100 = dict?.valueForString(key: "clip_must_not_exceed_100")
            tblLanguageText.are_you_sure_want_to_send_video = dict?.valueForString(key: "are_you_sure_want_to_send_video")
            tblLanguageText.are_you_sure_you_want_send_audio = dict?.valueForString(key: "are_you_sure_you_want_send_audio")
            tblLanguageText.please_select_2_member = dict?.valueForString(key: "please_select_2_member")
            tblLanguageText.please_select_language = dict?.valueForString(key: "please_select_language")
            tblLanguageText.invitation_has_been_sent = dict?.valueForString(key: "invitation_has_been_sent")
            tblLanguageText.please_enter_comment_text = dict?.valueForString(key: "please_enter_comment_text")
            tblLanguageText.please_enter_report_message = dict?.valueForString(key: "please_enter_report_message")
            tblLanguageText.video_formate_not_supported = dict?.valueForString(key: "video_formate_not_supported")
            tblLanguageText.your_request_to_join_group_has_been_sent_to_admin = dict?.valueForString(key: "your_request_to_join_group_has_been_sent_to_admin")
            
            tblLanguageText.edit_media = dict?.valueForString(key: "edit_media")
            tblLanguageText.report_poll = dict?.valueForString(key: "report_poll")
            
            tblLanguageText.remove = dict?.valueForString(key: "remove")
            tblLanguageText.out_of = dict?.valueForString(key: "out_of")
            tblLanguageText.uploading = dict?.valueForString(key: "uploading")
            tblLanguageText.exporting_file = dict?.valueForString(key: "exporting_file")
            tblLanguageText.downloading_from_icloud = dict?.valueForString(key: "downloading_from_icloud")
            tblLanguageText.please_select_atleast_one_friend = dict?.valueForString(key: "Please_Select_Atleast_one_friend")
            
            tblLanguageText.month = dict?.valueForString(key: "month")
            tblLanguageText.year = dict?.valueForString(key: "year")
            tblLanguageText.using = dict?.valueForString(key: "Using")
            tblLanguageText.of = dict?.valueForString(key: "of")
            tblLanguageText.continue_text = dict?.valueForString(key: "continue")
            tblLanguageText.invite_others = dict?.valueForString(key: "invite_others")
            tblLanguageText.search_friends = dict?.valueForString(key: "search_friends")
            tblLanguageText.polls_created_successfully = dict?.valueForString(key: "polls_created_successfully")
            
            tblLanguageText.enter_folder_name = dict?.valueForString(key: "enter_folder_name")
            tblLanguageText.add_files = dict?.valueForString(key: "add_files")
            tblLanguageText.no_files_yet = dict?.valueForString(key: "no_files_yet")
            tblLanguageText.restore_purchased = dict?.valueForString(key: "restore_purchased")
            
            tblLanguageText.purchased_success = dict?.valueForString(key: "purchased_success")
            tblLanguageText.restored_success = dict?.valueForString(key: "restored_success")
            tblLanguageText.payment_error = dict?.valueForString(key: "payment_error")
            tblLanguageText.select_category_of_gallery = dict?.valueForString(key: "select_category_of_gallery")
            tblLanguageText.gallery_created_successfully = dict?.valueForString(key: "gallery_created_successfully")
            
            tblLanguageText.restricted_file = dict?.valueForString(key: "restricted_file")
            tblLanguageText.no_quotes_yet = dict?.valueForString(key: "no_quotes_yet")
            tblLanguageText.no_notifications_yet = dict?.valueForString(key: "no_notifications_yet")
            tblLanguageText.no_fav_web_list = dict?.valueForString(key: "no_fav_web_list")
            tblLanguageText.are_you_sure_to_report_this_post = dict?.valueForString(key: "are_you_sure_to_report_this_post")
            tblLanguageText.no_pending_request = dict?.valueForString(key: "no_pending_request")
            tblLanguageText.no_request_send_data = dict?.valueForString(key: "no_request_send_data")
            tblLanguageText.no_friends_found = dict?.valueForString(key: "no_friends_found")
            tblLanguageText.more = dict?.valueForString(key: "more")
            
            tblLanguageText.are_you_sure_to_report_this_fav_web = dict?.valueForString(key: "are_you_sure_to_report_this_fav_web")
            tblLanguageText.preparing_to_export = dict?.valueForString(key: "preparing_to_export")
            tblLanguageText.downloading = dict?.valueForString(key: "downloading")
            tblLanguageText.file_already_exist_in_folder = dict?.valueForString(key: "file_already_exist_in_folder")
            
            tblLanguageText.message = dict?.valueForString(key: "message")
            tblLanguageText.you_cant_see_profile = dict?.valueForString(key: "you_cant_see_profile")
            
            tblLanguageText.validation_for_age_in_post = dict?.valueForString(key: "validation_for_age_in_post")
            
            tblLanguageText.shared_post = dict?.valueForString(key: "shared_post")
            tblLanguageText.ago = dict?.valueForString(key: "ago")
            tblLanguageText.stores = dict?.valueForString(key: "stores")
            tblLanguageText.store = dict?.valueForString(key: "store")
            tblLanguageText.all_products = dict?.valueForString(key: "all_products")
            tblLanguageText.my_products = dict?.valueForString(key: "my_products")
            tblLanguageText.available = dict?.valueForString(key: "available")
            tblLanguageText.sold = dict?.valueForString(key: "sold")
            tblLanguageText.last_date_of_product_selling = dict?.valueForString(key: "last_date_of_product_selling")
            tblLanguageText.payment_preference = dict?.valueForString(key: "payment_preference")
            tblLanguageText.seller_information = dict?.valueForString(key: "seller_information")
            tblLanguageText.contact_seller = dict?.valueForString(key: "contact_seller")
            tblLanguageText.buy_now = dict?.valueForString(key: "buy_now")
            tblLanguageText.about_product = dict?.valueForString(key: "about_product")
            tblLanguageText.product_title = dict?.valueForString(key: "product_title")
            tblLanguageText.product_description = dict?.valueForString(key: "product_description")
            tblLanguageText.product_price = dict?.valueForString(key: "product_price")
            tblLanguageText.payment_mode = dict?.valueForString(key: "payment_mode")
            tblLanguageText.offline_payment = dict?.valueForString(key: "offline_payment")
            tblLanguageText.online_payment = dict?.valueForString(key: "online_payment")
            tblLanguageText.link_to_payment = dict?.valueForString(key: "link_to_payment")
            tblLanguageText.accept_all_tems_and_conditions = dict?.valueForString(key: "accept_all_tems_and_conditions")
            tblLanguageText.reviews = dict?.valueForString(key: "reviews")
            tblLanguageText.add_your_experience_to_help_other = dict?.valueForString(key: "add_your_experience_to_help_other")
            tblLanguageText.sort = dict?.valueForString(key: "sort")
            tblLanguageText.sort_new_to_old = dict?.valueForString(key: "new_to_old")
            tblLanguageText.old_to_new = dict?.valueForString(key: "old_to_new")
            tblLanguageText.search_buy_seller_and_product_name = dict?.valueForString(key: "search_buy_seller_and_product_name")
            tblLanguageText.rate_and_review_product = dict?.valueForString(key: "rate_and_review_product")
            tblLanguageText.your_rating = dict?.valueForString(key: "your_rating")
            tblLanguageText.add_your_review = dict?.valueForString(key: "add_your_review")
            tblLanguageText.report_product = dict?.valueForString(key: "report_product")
            tblLanguageText.why_are_you_reporting_this_product = dict?.valueForString(key: "why_are_you_reporting_this_product")
            tblLanguageText.think_it_is_scam = dict?.valueForString(key: "think_it_is_scam")
            tblLanguageText.it_is_a_duplicate_list = dict?.valueForString(key: "it_is_a_duplicate_list")
            tblLanguageText.it_is_wrong_category = dict?.valueForString(key: "it_is_wrong_category")
            tblLanguageText.other = dict?.valueForString(key: "other")
            tblLanguageText.write_about_your_problem = dict?.valueForString(key: "write_about_your_problem")
            tblLanguageText.mark_as_sold = dict?.valueForString(key: "mark_as_sold")
            tblLanguageText.your_information = dict?.valueForString(key: "your_information")
            tblLanguageText.write_your_message_here_optional = dict?.valueForString(key: "write_your_message_here_optional")
            tblLanguageText.add_product_details = dict?.valueForString(key: "add_product_details")
            tblLanguageText.sort_by = dict?.valueForString(key: "sort_by")
            tblLanguageText.please_enter_your_problem = dict?.valueForString(key: "please_enter_your_problem")
            tblLanguageText.please_enter_some_review = dict?.valueForString(key: "please_enter_some_review")
            tblLanguageText.please_enter_some_message = dict?.valueForString(key: "please_enter_some_message")
            tblLanguageText.please_add_atleast_one_product = dict?.valueForString(key: "please_add_atleast_one_product")
            tblLanguageText.video_size_is_large = dict?.valueForString(key: "video_size_is_large")
            tblLanguageText.please_select_any_one_category = dict?.valueForString(key: "please_select_any_one_category")
            tblLanguageText.please_enter_product_title = dict?.valueForString(key: "please_enter_product_title")
            tblLanguageText.please_enter_product_description = dict?.valueForString(key: "please_enter_product_description")
            tblLanguageText.please_enter_product_price = dict?.valueForString(key: "please_enter_product_price")
            tblLanguageText.please_enter_last_date_selling_product = dict?.valueForString(key: "please_enter_last_date_selling_product")
            tblLanguageText.please_enter_any_location = dict?.valueForString(key: "please_enter_any_location")
            tblLanguageText.please_accept_terms_conditions = dict?.valueForString(key: "please_accept_terms_conditions")
            tblLanguageText.no_product_added = dict?.valueForString(key: "no_product_added")
            tblLanguageText.are_you_sure_you_want_to_delete_product = dict?.valueForString(key: "are_you_sure_you_want_to_delete_product")
            tblLanguageText.edit_product_details = dict?.valueForString(key: "edit_product_details")
            tblLanguageText.share_within_seven_chats = dict?.valueForString(key: "share_within_seven_chats")
            tblLanguageText.url_not_found = dict?.valueForString(key: "url_not_found")
            tblLanguageText.payment_description = dict?.valueForString(key: "payment_description")
            
            tblLanguageText.shared_article = dict?.valueForString(key: "shared_article")
            tblLanguageText.shared_chirpy = dict?.valueForString(key: "shared_chirpy")
            tblLanguageText.shared_gallery = dict?.valueForString(key: "shared_gallery")
            tblLanguageText.shared_shout = dict?.valueForString(key: "shared_shout")
            tblLanguageText.shared_polls = dict?.valueForString(key: "shared_polls")
            tblLanguageText.shared_event = dict?.valueForString(key: "shared_event")
            tblLanguageText.shared_forum = dict?.valueForString(key: "shared_forum")
            tblLanguageText.this_content_is_not_available = dict?.valueForString(key: "this_content_is_not_available")
            tblLanguageText.this_content_is_not_available_text = dict?.valueForString(key: "this_content_is_not_available_text")
            tblLanguageText.report_shared_post = dict?.valueForString(key: "report_shared_post")
            tblLanguageText.external_share = dict?.valueForString(key: "external_share")
            tblLanguageText.shared_shared = dict?.valueForString(key: "shared_shared")
            tblLanguageText.shared_post_created_successfully = dict?.valueForString(key: "shared_post_created_successfully")
            tblLanguageText.shared_post_edited_successfully = dict?.valueForString(key: "shared_post_edited_successfully")
            tblLanguageText.please_select_to_whom_to_share = dict?.valueForString(key: "please_select_to_whom_to_share")
            
            tblLanguageText.share_current_location = dict?.valueForString(key: "share_current_location")
            tblLanguageText.product_terms_conditions = dict?.valueForString(key: "product_terms_conditions")
            tblLanguageText.by_posting_this_product = dict?.valueForString(key: "by_posting_this_product")
            tblLanguageText.country = dict?.valueForString(key: "country")
            tblLanguageText.state = dict?.valueForString(key: "state")
            tblLanguageText.city = dict?.valueForString(key: "city")
            tblLanguageText.please_select_country = dict?.valueForString(key: "please_select_country")
            tblLanguageText.please_select_state = dict?.valueForString(key: "please_select_state")
            tblLanguageText.please_select_city = dict?.valueForString(key: "please_select_city")
            
            tblLanguageText.report_product = dict?.valueForString(key: "report_product")
            tblLanguageText.no_category_found = dict?.valueForString(key: "no_category_found")
            tblLanguageText.offline_payment_mode = dict?.valueForString(key: "offline_payment_mode")
            tblLanguageText.online_payment_mode = dict?.valueForString(key: "online_payment_mode")
            tblLanguageText.check_out_this_store_post = dict?.valueForString(key: "check_out_this_store_post")
            tblLanguageText.are_you_sure_you_want_to_delete_product = dict?.valueForString(key: "are_you_sure_you_want_to_delete_product")
            tblLanguageText.product_updated_success = dict?.valueForString(key: "product_updated_success")
            tblLanguageText.product_created_success = dict?.valueForString(key: "product_created_success")
            
            tblLanguageText.your_message_has_been_sent_to_seller = dict?.valueForString(key: "your_message_has_been_sent_to_seller")
            tblLanguageText.no_products_found = dict?.valueForString(key: "no_products_found")
            
            tblLanguageText.open_in_maps = dict?.valueForString(key: "open_in_maps")
            tblLanguageText.open_in_google_maps = dict?.valueForString(key: "open_in_google_maps")
            tblLanguageText.are_you_sure_you_want_to_share_location = dict?.valueForString(key: "are_you_sure_you_want_to_share_location")
            tblLanguageText.audio_call = dict?.valueForString(key: "audio_call")
            tblLanguageText.video_call = dict?.valueForString(key: "video_call")
            tblLanguageText.decline = dict?.valueForString(key: "decline")
            tblLanguageText.location_services_disabled = dict?.valueForString(key: "location_services_disabled")
            tblLanguageText.please_enable_location_service_in_settings = dict?.valueForString(key: "please_enable_location_service_in_settings")
            tblLanguageText.visibility = dict?.valueForString(key: "visibility")
            tblLanguageText.participants = dict?.valueForString(key: "participants")
            tblLanguageText.public_visibility = dict?.valueForString(key: "public")
            
            tblLanguageText.start_calling = dict?.valueForString(key: "start_calling")
            tblLanguageText.connected_with = dict?.valueForString(key: "connected_with")
            tblLanguageText.group_call_from = dict?.valueForString(key: "group_call_from")
            tblLanguageText.video_call_from = dict?.valueForString(key: "video_call_from")
            tblLanguageText.str_in = dict?.valueForString(key: "in")
            tblLanguageText.call_from = dict?.valueForString(key: "call_from")
            tblLanguageText.ringing_ = dict?.valueForString(key: "ringing_")
            tblLanguageText.connecting = dict?.valueForString(key: "connecting")
            tblLanguageText.continue_without_microphone = dict?.valueForString(key: "continue_without_microphone")
            tblLanguageText.microphone_permission_not_granted = dict?.valueForString(key: "microphone_permission_not_granted")
            tblLanguageText.voice_quick_start = dict?.valueForString(key: "voice_quick_start")
            tblLanguageText.calling = dict?.valueForString(key: "calling")
            
            tblLanguageText.connecting_to = dict?.valueForString(key: "connecting_to")
            tblLanguageText.max_50_participants = dict?.valueForString(key: "max_50_participants")
            tblLanguageText.we_are_not_functional_your_location = dict?.valueForString(key: "we_are_not_functional_your_location")
            tblLanguageText.max_file_size_allowed_to_upload_1_GB = dict?.valueForString(key: "max_file_size_allowed_to_upload_1_GB")
            
            tblLanguageText.there_is_no_ongoing_chat = dict?.valueForString(key: "there_is_no_ongoing_chat")
            
            // On-Boarding Text
            tblLanguageText.welcome_to_sevenchats = dict?.valueForString(key: "welcome_to_sevenchats")
            tblLanguageText.all_in_one_platform = dict?.valueForString(key: "all_in_one_platform")
            tblLanguageText.lets_chat = dict?.valueForString(key: "lets_chat")
            tblLanguageText.free_messaging_wherever_and_whenever = dict?.valueForString(key: "free_messaging_wherever_and_whenever")
            tblLanguageText.free_voice_and_video_calls = dict?.valueForString(key: "free_voice_and_video_calls")
            tblLanguageText.call_friends_and_family = dict?.valueForString(key: "call_friends_and_family")
            tblLanguageText.create_store_share = dict?.valueForString(key: "create_store_share")
            tblLanguageText.securely_store_manage_all_your_files = dict?.valueForString(key: "securely_store_manage_all_your_files")
            tblLanguageText.buy_and_sell = dict?.valueForString(key: "buy_and_sell")
            tblLanguageText.sell_your_stuff_and_shop_anything = dict?.valueForString(key: "sell_your_stuff_and_shop_anything")
            tblLanguageText.earn_points_everyday = dict?.valueForString(key: "earn_points_everyday")
            tblLanguageText.you_can_now_collect_points_by_doing = dict?.valueForString(key: "you_can_now_collect_points_by_doing")
            
            tblLanguageText.my_rewards = dict?.valueForString(key: "my_rewards")
            tblLanguageText.you_have_earned = dict?.valueForString(key: "you_have_earned")
            tblLanguageText.points = dict?.valueForString(key: "Points")
            tblLanguageText.total_points = dict?.valueForString(key: "total_points")
            tblLanguageText.point = dict?.valueForString(key: "point")
            
            tblLanguageText.summary = dict?.valueForString(key: "Summary")
            
            tblLanguageText.camera_permission_or_microphone_permission_not_granted_please_allow_it_from_setting = dict?.valueForString(key: "camera_permission_or_microphone_permission_not_granted_please_allow_it_from_setting")
            
            tblLanguageText.alert_message_for_reject = dict?.valueForString(key: "alert_message_for_reject")
            tblLanguageText.alert_message_for_accept = dict?.valueForString(key: "alert_message_for_accept")
           
            tblLanguageText.alert_message_addfriend = dict?.valueForString(key: "alert_message_addfriend")
            tblLanguageText.to_enhance_feed = dict?.valueForString(key: "to_enhance_feed")
            tblLanguageText.force_update_text = dict?.valueForString(key: "force_update_text")
            tblLanguageText.later = dict?.valueForString(key: "later")
            tblLanguageText.location = dict?.valueForString(key: "location")
            
            tblLanguageText.check_this_in_news = dict?.valueForString(key: "check_this_in_news")
            tblLanguageText.forwarded_message = dict?.valueForString(key: "forwarded_message")
            tblLanguageText.forward = dict?.valueForString(key: "forward")
            tblLanguageText.invites_decline_for_event = dict?.valueForString(key: "invites_decline_for_event")
            tblLanguageText.invites_maybe_for_event = dict?.valueForString(key: "invites_maybe_for_event")
            //Feed back
            tblLanguageText.not_user_friendly = dict?.valueForString(key: "not_user_friendly")
            tblLanguageText.prompts_not_clear = dict?.valueForString(key: "prompts_not_clear")
            tblLanguageText.improper_language = dict?.valueForString(key: "improper_language")
            tblLanguageText.incorrect_language_translation = dict?.valueForString(key: "incorrect_language_translation")
            tblLanguageText.need_help_screens = dict?.valueForString(key: "need_help_screens")
            tblLanguageText.missing_functionality = dict?.valueForString(key: "missing_functionality")
            tblLanguageText.nice_to_have_functionality = dict?.valueForString(key: "nice_to_have_functionality")
            tblLanguageText.need_help_with = dict?.valueForString(key: "need_help_with")
           
            
            
            
            
            appDelegate.langugaeText = tblLanguageText
            CoreData.saveContext()
        }
    }
    /// Function for the store new category in Local database
    func saveNewInterest(interestID: Int, interestName: String) {
        guard let arrInterest: [TblInterest] = TblInterest.fetchAllObjects() as? [TblInterest] else {return}
        let interestData = arrInterest.filter({$0.id == Int16(interestID)})
        if (interestData.count == 0) {
            let tblInterest = TblInterest.findOrCreate(dictionary: ["id":
                                                                        Int16(interestID)]) as! TblInterest
            tblInterest.id = Int16(interestID)
            tblInterest.name = interestName
            tblInterest.type = 1
            
            CoreData.saveContext()
        }
        if var arrCategory = appDelegate.loginUser?.interests as? [[String: Any]] {
            var dicData = [String: Any]()
            for category in arrCategory {
                if category[CId] as? Int != interestID {
                    dicData[CId] = interestID
                    dicData[CName] = interestName
                }
            }
            if dicData.count > 0 {
                arrCategory.append(dicData)
            }
            appDelegate.loginUser?.interests = arrCategory as NSObject
        }
    }
}

struct JSONStringArrayEncoding: ParameterEncoding {
    private let array: [String : Any]
    
    init(array: [String : Any]) {
        self.array = array
    }
    
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()
        let data = try JSONSerialization.data(withJSONObject: array, options: [])
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        urlRequest.httpBody = data
        return urlRequest
    }
}

struct JSONStringArrayEncodings: ParameterEncoding {
    private let array: [String : Any]
    
    init(array: [String : Any]) {
        self.array = array
    }
    
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()
        let data = try JSONSerialization.data(withJSONObject: array, options: [])
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        urlRequest.httpBody = data
        return urlRequest
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
