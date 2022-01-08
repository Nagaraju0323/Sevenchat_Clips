//
//  ApplicationConstants.swift
//  Social Media
//
//  Created by mac-0005 on 06/06/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import Foundation
import UIKit


func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
    Swift.print(items[0], separator:separator, terminator: terminator)
    #endif
}

//MARK:- Fonts
//MARK:-
enum CFontType:Int {
    case black
    case blackItalic
    case bold
    case boldItalic
    case light
    case extraLight
    case extraLightItalic
    case italic
    case lightItalic
    case thin
    case thinItalic
    case extraBold
    case extraBoldItalic
    case semibold
    case semiboldItalic
    case meduim
    case meduimItalic
    case regular
}

func CFontPoppins(size: CGFloat, type: CFontType) -> UIFont {
    switch type {
    case .black:
        return UIFont.init(name: "Poppins-Black", size: size)!
        
    case .blackItalic:
        return UIFont.init(name: "Poppins-BlackItalic", size: size)!
        
    case .bold:
        return UIFont.init(name: "Poppins-Bold", size: size)!
        
    case .boldItalic:
        return UIFont.init(name: "Poppins-BoldItalic", size: size)!
        
    case .extraBold:
        return UIFont.init(name: "Poppins-ExtraBold", size: size)!
        
    case .extraBoldItalic:
        return UIFont.init(name: "Poppins-ExtraBoldItalic", size: size)!
        
    case .extraLight:
        return UIFont.init(name: "Poppins-ExtraLight", size: size)!
        
    case .extraLightItalic:
        return UIFont.init(name: "Poppins-ExtraLightItalic", size: size)!
        
    case .italic:
        return UIFont.init(name: "Poppins-Italic", size: size)!
        
    case .light:
        return UIFont.init(name: "Poppins-Light", size: size)!
        
    case .lightItalic:
        return UIFont.init(name: "Poppins-LightItalic", size: size)!
        
    case .meduim:
        return UIFont.init(name: "Poppins-Medium", size: size)!
        
    case .meduimItalic:
        return UIFont.init(name: "Poppins-MediumItalic", size: size)!
        
    case .regular:
        return UIFont.init(name: "Poppins-Regular", size: size)!
        
    case .semibold:
        return UIFont.init(name: "Poppins-SemiBold", size: size)!
        
    case .semiboldItalic:
        return UIFont.init(name: "Poppins-SemiBoldItalic", size: size)!
        
    case .thin:
        return UIFont.init(name: "Poppins-Thin", size: size)!
        
    case .thinItalic:
        return UIFont.init(name: "Poppins-ThinItalic", size: size)!
    }
}

//MARK:- UserDefaults

let UserDefaultTimestamp                  = "UserDefaultTimestamp"
let UserDefaultDeviceToken                = "UserDefaultDeviceToken"
let UserDefaultUserID                     = "UserDefaultUserID"
let UserDefaultViewedOnboarding           = "UserDefaultViewedOnboarding"
let UserDefaultSelectedLangID             = "UserDefaultSelectedLangID"
let UserDefaultSelectedLangCode             = "UserDefaultSelectedLangCode"
let UserDefaultSelectedLang             = "UserDefaultSelectedLang"
let UserDefaultNotificationToken          = "UserDefaultNotificationToken"
let UserDefaultVoIPNotificationToken      = "UserDefaultVoIPNotificationToken"
let UserDefaultAPNsPNotificationToken      = "UserDefaultAPNsPNotificationToken"
let CachedDeviceToken      = "CachedDeviceToken"
let UserDefaultTimeDifference             = "UserDefaultTimeDifference"
let UserDefaultNotificationCountBadge     = "UserDefaultNotificationCountBadge"
let UserDefaultIsAppLaunchHere            = "UserDefaultIsAppLaunchHere"
let CUserDefaultUDID    = "Device_UDID"
let CIAPReceiptKey           = "IAP"
//MARK:- Color Code

let ColorBlack          = CRGB(r: 0, g: 0, b: 0)
let ColorWhite          = CRGB(r: 255, g: 255, b: 255)
//let ColorAppTheme       = CRGB(r: 138, g: 181, b: 136)
let ColorAppTheme       = CRGB(r: 239, g: 239, b: 239)

let ColorAppBackgorund  = CRGB(r: 244, g: 255, b: 247)
let ColorAppBackground1 = CRGB(r: 6, g: 192, b: 166)
let ColorGreen          = CRGB(r: 132, g: 154, b: 164)
let ColorGray           = CRGB(r: 130, g: 122, b: 122)
let ColorPlaceholder    = CRGB(r: 176, g: 177, b: 172)

//MARK:- UIStoryboard

let CStoryboardLRF = UIStoryboard(name: "LRF", bundle: nil)
let CStoryboardHome = UIStoryboard(name: "Home", bundle: nil)
let CStoryboardSetting = UIStoryboard(name: "Setting", bundle: nil)
let CStoryboardGeneral = UIStoryboard(name: "General", bundle: nil)
let CStoryboardSideMenu = UIStoryboard(name: "SideMenu", bundle: nil)
let CStoryboardEvent = UIStoryboard(name: "Event", bundle: nil)
let CStoryboardImage = UIStoryboard(name: "Image", bundle: nil)
let CStoryboardProfile = UIStoryboard(name: "Profile", bundle: nil)
let CStoryboardChat = UIStoryboard(name: "Chat", bundle: nil)
let CStoryboardGroup = UIStoryboard(name: "Group", bundle: nil)
let CStoryboardFile = UIStoryboard(name: "File", bundle: nil)
let CStoryboardPoll = UIStoryboard(name: "Poll", bundle: nil)
let CStoryboardSharedPost = UIStoryboard(name: "SharedPost", bundle: nil)
let CStoryboardProduct = UIStoryboard(name: "Product", bundle: nil)
let CStoryboardLocationPicker = UIStoryboard(name: "LocationPicker", bundle: nil)
let CStoryboardAudioVideo = UIStoryboard(name: "AudioVideo", bundle: nil)
let CStoryboardRewards = UIStoryboard(name: "Rewards", bundle: nil)
let CStoryboardForward = UIStoryboard(name: "Forward", bundle: nil)

//MARK:- Application Language
//MARK:-
let CLanguageEnglish           = "en"
let CLanguageArabic            = "ar"

func CLocalize(text: String) -> String {
    return Localization.sharedInstance.localizedString(forKey: text , value: text)
}


//MARK:- Other

let CPublic  = "Public"
let CPrivate = "Private"
let CComponentJoinedString          = ", "
let CWebSiteLink    = "https://beta.sevenchats.com/"
let PASSWORDALLOWCHAR = "!@#$%ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_"
let SPECIALCHAR = "!@#$%^&,.<>?/[];:ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_/n  "

//MARK:- Google Client ID and Place Picker Key

let CGoogleClientID = "1045965359994-o9s380d6cu7o19katai53452pdn68gkf.apps.googleusercontent.com"
//let CGoogleAPIKey = "AIzaSyD7woCwx7MTjP2dU4RR85g10yZpECaH2EE"
let CGoogleAPIKey = "AIzaSyD7woCwx7MTjP2dU4RR85g10yZpECaH2EE"

//let CGooglePlacePickerKey = "AIzaSyATj-D2T6HVygZFzd4yQM6PWkzJR9x5N5s"
let CGooglePlacePickerKey = "AIzaSyBl8HBDx1j8SBsg_pNqpPfwPD6-6DrugSc"



let CTwitterConsumerKey = "cDPdScDA1UDpUekDJqAGD4uE6"
let CTwitterConsumerSecret = "uE8tRw87V7TjSY5r9IWQzonnMaOXQ3HpZULy4AnwdNABH9Lhjs"



//MARK:- Status Code

let CAccountTypeNormal       = 0
let CAccountTypeFacebook     = 10
let CAccountTypeGoogle       = 2
let CAccountTypeInstagram    = 35
let CLTR         = 0
let CRTL         = 1
let CEmailType  =  1
let CMobileType =  2
let CNormal          = 0
let CFacebook        = 1
let CTwitter         = 2
let CGoogle          = 3
let CApple           = 4

let CMale            = 1
let CFemale          = 2
let COther           = 3
let CInterestType    = 1
let CNewsType        = 2
let CBusinessType    = 3
let CBasicPrefrence      = 1
let CCompletePrefrence   = 2
let CLessThan1Lakh                = 1
let CBetween1LakhAnd5Lakhs        = 2
let CBetween5LakhsTo10Lakhs       = 3
let CBetween10LakhsTo20Lakhs      = 4
let CBetween20LakhsTo35Lakhs      = 5
let CBetween35LakhsTo60Lakhs      = 6
let CMoreThan50Lakhs              = 7

//let CFriendRequestSent              = 1
//let CFriendRequestAccept              = 2
//let CFriendRequestReject              = 3
//let CFriendRequestUnfriend              = 4
//let CFriendRequestCancel              = 5
//let CFriendRequestAcceptReject              = 6

let CFriendRequestSent              = 1
let CFriendRequestAccept              = 5
let CFriendRequestReject              = 3
let CFriendRequestUnfriend              = 4
let CFriendRequestCancel              = 2
let CFriendRequestAcceptReject              = 6

let CPublicToGroup      = 1
let CPublicToContact    = 2
let CPublicToFriend     = 3

let CStaticArticleIdNew     = "post_article"
let CStaticGalleryIdNew     = "post_gallery"
let CStaticChirpyIdNew     = "post_chirpy"
let CStaticShoutIdNew     = "post_shout"
let CStaticForumIdNew     = "post_forum"
let CStaticEventIdNew     = "post_event"
let CStaticPollIdNew      = "post_poll"


let CStaticArticleId     = 1
let CStaticGalleryId     = 5
let CStaticChirpyId     = 2
let CStaticShoutId     = 7
let CStaticForumId     = 4
let CStaticEventId     = 3
let CStaticSearchUserTypeId     = 7
let CStaticPollId     = 6
let CStaticSearchAllType     = 0

let CTypeMayBeInterested     = 3
let CTypeInterested     = 1
let CTypeNotInterested     = 2

let CGroupTypePrivate = 2
let CGroupTypePublic = 1

//MARK:- API Parameter
//MARK:-

let CTimestamp            = "timestamp"
let CPer_page            = "per_page"
let CPage                = "page"
let CLastPage            = "last_page"
let CCurrentPage         = "current_page"
let CAccounttype         = "account_type"
let CSocialid            = "social_id"
let CFirstname           = "first_name"
let CLastname            = "last_name"
let CEmail               = "email"
let CPassword            = "password"
let CCountrycode         = "country_code"
let CMobile              = "mobile"
let CDob                 = "dob"
let CLang_id             = "lang_id"
let CLang_name            = "lang_name"
let CGender              = "gender"
//let CVerificationmail    = "verification_mail"
let CLatitude            = "latitude"
let CLongitude           = "longitude"
let CAddress             = "address"
let CCity                = "city"
let CUsermailID          = "user_email"
let CFriendID          = "friend_user_id"
let CUserId              = "user_id"
let CCountryName         = "country_name"
let CStateName         = "state_name"
let CCityName         = "city_name"
let CCountryIso          = "country_iso"
let CId                  = "id"
let postId = "post_id"
//let postId                  = "post_id"
let CStatusId            = "statusId"
let CEmail_or_Mobile     = "email_or_mobile"
let CVerifyCode          = "verify_code"
let CIs_email_verify     = "is_email_verify"
let CIs_mobile_verify    = "is_mobile_verify"
let COTP                 = "otp"
let CInterest_name       = "interest_name"
let CInterest_ids        = "interest_ids"
let CVisible_to_other           = "visible_to_other"
//let CVisible_to_friend          = "visible_to_friend"
let CVisible_to_friend      = "visible_to_friend"
let CUser_type                  = "user_type"
let CTotal_post                 = "total_post"
let CTotal_like                 = "total_like"
let CTotal_friends              = "total_friends"
let CShort_biography            = "short_biography"
let CReligion                   = "religion"
let CRelationship_id            = "relationship_id"
let CProfession                 = "profession"
let CIs_notify                  = "is_notify"
let CInterest                   = "interests"
let CFriends                    = "friends"
//let CFriend_status              = "friend_status"
let CFriend_status              = "status_id"
let CCheck_status              = "check_status"

let CFriend_report_status       = "friend_report_status"
let CFriend_block_unblock_status   = "friend_block_unblock_status"
let CEmployment_status          = "employment_status"
let CEducation                  = "education"
let CBlock_unblock_status       = "block_unblock_status"
let CBadge_cnt                  = "badge_cnt"
let CAnnual_income              = "annual_income"
let CPush_notify                = "push_notify"
let CEmail_notify               = "email_notify"
let CName                       = "name"
let CAnnual_income_id           = "annual_income_id"
let CIncome                     = "income"
let CCountry_id                 = "country_id"
let CState_id                 = "state_id"
let CCity_id                 = "city_id"
let CEducation_id               = "education_id"
let CType                       = "type"
let CCreated_at                 = "created_at"
let CChat_Time                 = "chat_time"
let CLang_code                  = "lang_code"
let CLangOrientation            = "orientation"
let CEmail_or_mobile            = "email_or_mobile"
let CStatus            = "status"
let CGroupTitle            = "group_title"
let CGroupType            = "group_type"
let CGroupUsersId            = "group_users_id"
let CGroupImage            = "group_image"
let CGroupId            = "group_id"
let CGroupUsers            = "group_users"
let CGroupAdmins            = "group_admin"
let CGroupPendingRequest            = "pending_request"
let CLink            = "link"
let CThumb_Url            = "thumb_url"
let CUnread_Ids            = "unread_msg_ids"
let CThumb_Name            = "thumb_name"
let CMedia_Name            = "media_name"
let CGroupLink            = "group_link"
let CPostType            = "post_type"
let CPostTypeNew            = "type"
let CSearchType            = "search_type"
let CCategory_Id            = "category_id"
let CPost_Detail            = "post_detail"
let CMin_Age            = "min_age"
let CPublish_To            = "publish_to"
let CInvite_Friend            = "invite_friends"
let CInvite_Groups            = "invite_groups"

let CGroup_Ids            = "group_ids"
let CInvite_Ids            = "invite_ids"
let CEvent_Location            = "address_line1"
let CEvent_Start_Date            = "event_start_date"
let CEvent_End_Date            = "event_end_date"
let CGroup_Id            = "group_id"
let CGroup_Title            = "group_title"
let CGroup_Image            = "group_image"
let CGroup_Type            = "group_type"
let CGroup_Link            = "group_link"
let CCreated_By                  = "created_by"
let CLast_Message                = "last_message"
let CDateTime                    = "datetime"
let CEventDate                   = "event_date"
let CUserProfileImage            = "profile_image"
let CTotalInterestedUsers        = "total_interested_users"
let CIsInterested                 = "is_interested"

let CTotalComment                = "total_comment"
let CTotalMaybeInterestedUsers   = "total_maybe_interested_users"
let CTotalNotInterestedUsers     = "total_not_interested_users"
let CIsMyPost                    = "is_my_post"
let CCategory                    = "post_category"
let CContent                     = "post_detail"
let CMinAge                      = "min_age"
let CIs_Like                      = "is_like"
let CIs_Liked                      = "is_liked"
let CTitle                      = "post_title"
let CImage  = "profile_image"
let CProfileImage = "profile_image"
let CImageSelected  = "imageSelected"
let CTotal  = "total"
let CFilterPost  = "filter_post"
let CGalleryImages  = "gallery_images"
let CDeleteIds  = "delete_ids"
let CReportType  = "report_type"
let CReportNote  = "report_note"
let CReportFrom  = "report_from"
let CReportedUrl  = "reported_url"
let CReportedId  = "report_id"
let CPostId     = "post_id"
let CRssId     = "rss_id"
let CIncludeUserId     = "include_user_id"
let CFullName     = "full_name"
let CIs_Online     = "is_online"
let CSender_Id     = "sender_id"
let CMessage     = "message"
let CMsg_type     = "msg_type"
let CChat_type     = "chat_type"
let CRecv_id     = "recv_id"
let CMessage_id     = "message_id"
let CChannel_id     = "channel_id"
let CMessage_Delivered     = "message_Delivered"
let CUsers     = "users"
let CPublishType     = "publish_type"
let CCategoryName  = "category_name"
let CProductcategoryType = "product_category_type"

let CCategory_level1  = "category_level1"
let CCategoryID = "category_id"
//let CFriendId = "friend_id"
let CFriendId = "user_id"
let CUnreadCount = "unread_count"
let CUnreadCnt = "unread_cnt"
let CRead_Users = "read_user"
let CIs_login_blocked = "is_login_blocked"
let CIs_blocked = "is_blocked"
let CIs_reported = "is_reported"

let CBlockUserId = "block_user_id"
let CApiNew = "new"
let CApiOld = "old"
let CFile = "file"
let CFiles = "files"
let CThumbNail = "thumb_nail"
let CAds_id = "ads_id"
let CAds_title = "ads_title"
let CDisplay_type = "display_type"
let CInteractive_type = "interactive_type"
let CInteractive_value = "interactive_value"
let CAds_image = "ads_image"
let CBy_page = "by_page"
let CAds_size = "ads_size"
let CShare_url = "share_url"
let CIs_send = "is_send"
let CStatus_id = "status_id"
let CIs_sender = "is_sender"
let CProfile_url = "profile_url"
let CTransaction_id = "transaction_id"
let CTransaction_from = "transaction_from"


let COptions = "option"
let CPollData = "polls_data"
let CAllVotes = "all_votes"
let CPolles = "polles"
let CIsUserVoted = "is_user_voted"
//let CIsPollVoted = "is_poll_voted"
let COptionID = "option_id"
let CData = "data"
let CUserVotedPoll = "user_voted_poll"


let CFolderName = "folder_name"
let CFolderID = "folder_id"
let CFileType = "file_type"
let CRelationShip = "relationship"



let CreatedAtPostDF = "dd MMM yyy hh:mm a"

let CreatedAtPostConvert = "dd/MM"

let CIsSharedPost         = "is_shared_post"
let CIsPostDeleted        = "is_deleted_post"
let CSharedPost           = "shared_post"
let COriginalPostId       = "original_post_id"

let CBindingId = "bindingId"
//NEW CODE 

let CisAutoDelete       = "is_auto_delete"
let CAccesskey = "minioadmin"
let CSecretKey = "minioadmin"
let CProfileImages    = "profile_image"
let CEmail_Mobile     = "email"
let CCoverImage = "cover_image"

let CGrant_type = "grant_type"
let CClient_id = "client_id"
let CClient_secret = "client_secret"
let Cuser_id = "user_id"
let CCreated_upat = "updated_at"
let CUserProfileImages = "profile_image"
let CInteresttype      = "interest_type"
let CInterestID      = "interest_id"
let CinterestLevel2 = "interest_level2"
let CFriendUserID = "friend_user_id"
let CTargetAudiance = "targeted_audience"
let CSelectedPerson = "selected_persons"
let CPer_limit      = "limit"
let CWebsites      = "websites"
let CLikes    = "likes"
let Cimages = "image"
let CFavWebUrl = "favourite_website_url"
let CfavWebTitle = "favourite_website_title"
let CfavWebID = "favourite_website_id"
let CReason = "reason"
let CReportUser = "reported_user"
let CRepoerterUser = "reporter_user"
let CQuotes = "quotes"
let CLikesCount = "likes_count"
let CIsLiked = "is_liked"
let CpostContent = "post_content"

let Ccountry = "country"
let Clanguage = "language"
let Ccategory = "category"
let Crequesttype = "request_type"
let Cpoints_config_id   = "points_config_id"





//MARK : - rewardConfigNames
let CIncorrectlanguage = "Incorrect language translation feedback"
let CCompleteprofile  = "Complete profile"
let CRegisterprofile = "Register profile"
let CNeedhelpwithfeedback =  "Need help with feedback"
let CPostonstorelike =  "Post on store like"
let Nicetohavefunctionalityfeedback =  "Nice to have functionality feedback"
let CNeedhelpscreensfeedback =  "Need help screens feedback"
let CAdFreeSubscription =  "Ad Free Subscription"
let CUsageTime = "Usage Time"
let CImproperlanguagefeedback =  "Improper language feedback"
let CPostcreate =  "Post create"
let CAdmincredit =  "Admin credit"
let CFriendsrequestaccept =  "Friends request accept"
let CAdmindebit =  "Admin debit"
let CPromptsnotclearfeedback =  "Prompts not clear feedback"
let CPostonstore =  "Post on store"
let CAdvertisement =  "Advertisement"
let CPostlike =  "Post like"
let CMissingfunctionalityfeedback =  "Missing functionality feedback"
let CNotuserfriendlyfeedback =  "Not user friendly feedback"

      
//MARK : - rewardCategoryName


let CAdminCorrection =  "Admin Correction"
let CSellPosts =  "Sell Posts"
let CAdvertisements = "Advertisements"
let CAdFreeSubscriptionCategory =  "Ad Free Subscription"
let CUsageTimeCategory =  "Usage Time"
let CProfile =  "Profile"
let CConnections =  "Connections"
let CPosts =  "Posts"
let CFeedback = "Feedback"
let CPointreward = "points"






