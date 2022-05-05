//
//  ApplicationMessages.swift
//  Social Media
//
//  Created by mac-0005 on 06/06/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : ApplicationMessages                         *
 * Description : ApplicationMessages                     *
 ********************************************************/

import Foundation

//MARK:- GENERAL


var CBtnRetry: String{ return CLocalize(text: appDelegate.langugaeText?.retry ?? "Retry") }
var CBtnTryAgain: String{ return CLocalize(text: appDelegate.langugaeText?.try_again ?? "Try again") }

var CBtnNextArrow: String{ return CLocalize(text: appDelegate.langugaeText?.next_arrow ?? "Next>") }
var CBtnNext: String{ return CLocalize(text: appDelegate.langugaeText?.next ?? "Next") }
var CBtnSendAgain: String{ return CLocalize(text: "Send again") }
var CError: String{ return CLocalize(text: "ERROR!") }

var CBtnInfo: String{ return appDelegate.langugaeText?.info ?? "Info" }
var CBtnGoToWebsite: String{ return appDelegate.langugaeText?.go_to_website ?? "Ok" }

var CDeniedCameraPermission: String{ return "Camera access is required to perform this action."}
var CDeniedAlbumsPermission: String{ return "Albums access is required to perform this action."}

//MARK:- Navigation Title
var CNavLikes: String{ return appDelegate.langugaeText?.likes ?? "Likes" }
var CProfileLikes: String{ return appDelegate.langugaeText?.likes ?? "Likes" }
var CProfileLike: String{ return appDelegate.langugaeText?.like ?? "Like" }

var CNavComments: String{ return appDelegate.langugaeText?.comments ?? "Comments"}
var CComments: String{ return CLocalize(text: appDelegate.langugaeText?.comments ?? "Comments")}
var CComment: String{ return CLocalize(text: appDelegate.langugaeText?.comment ?? "Comment")}

var CNavReportUser: String{ return appDelegate.langugaeText?.report_user ?? "Report User" }
var CNavReportGroup: String{ return appDelegate.langugaeText?.report_group ?? "Report group" }
var CNavNews: String{ return appDelegate.langugaeText?.sidemenu_news ?? "News"}
var CNavPSL: String{ return appDelegate.langugaeText?.sidemenu_PSL ?? "PSL"}
var CNavAboutUs: String{ return appDelegate.langugaeText?.about_us ?? "About Us" }
var CNavPrivacyPolicy: String{ return appDelegate.langugaeText?.privacy_policy ?? "Privacy Policy" }
var CNavGroups: String{ return appDelegate.langugaeText?.sidemenu_groups ?? "Groups" }
var Cshout_groups: String{ return appDelegate.langugaeText?.shout_groups ?? "Groups" }
var Cshout_friends: String{ return appDelegate.langugaeText?.shout_friends ?? "Friends" }
var Cshout_public: String{ return appDelegate.langugaeText?.shout_public ?? "Public" }
var CNavChats: String{ return appDelegate.langugaeText?.sidemenu_chats ?? "Chats" }
var CNavFriends: String{ return appDelegate.langugaeText?.friends ?? "Friends" }
var CNavAddParticipants: String{ return appDelegate.langugaeText?.add_participant ?? "Add Participants"}
var CNavFeedback: String{ return CLocalize(text:appDelegate.langugaeText?.settings_feedback ?? "Feedback") }
var CNavAddGroup: String{ return appDelegate.langugaeText?.post_select_groups ?? "Select groups"}
var CNavAddContact: String{ return appDelegate.langugaeText?.post_select_contacts ?? "Select contacts"}
var CNavProfileFilter: String{ return appDelegate.langugaeText?.filters ?? "Filters"}
var CNavFilters: String{ return appDelegate.langugaeText?.filters ?? "Filters" }

//MARK:- Button Text
var CBtnInvite: String{ return appDelegate.langugaeText?.invite ?? "Invite" }
var CBtnConnect: String{ return appDelegate.langugaeText?.connect ?? "Connect" }
var CBtnJoin: String{ return appDelegate.langugaeText?.join ?? "Join" }
var CTabAllFriend: String{ return appDelegate.langugaeText?.all_friends ?? "All Friends" }
var CTabPendingRequest: String{ return appDelegate.langugaeText?.pending_request ?? "Pending request" }
var CTabRequestSend: String{ return appDelegate.langugaeText?.request_send ?? "Request sent" }

var CBtnCamera: String{ return appDelegate.langugaeText?.camera ?? "Camera" }
var CBtnGallery: String{ return appDelegate.langugaeText?.gallery ?? "Gallery" }
var CBtnAudio: String{ return appDelegate.langugaeText?.audio ?? "Audio" }
var CBtnVideo: String{ return appDelegate.langugaeText?.video ?? "Video" }

var CBtnApplyFilter: String{ return appDelegate.langugaeText?.apply_filter ?? "Apply filter" }
var CBtnYes: String{ return appDelegate.langugaeText?.yes ?? "Yes" }
var CBtnNo: String{ return appDelegate.langugaeText?.no ?? "No" }
var CBtnReset: String{ return appDelegate.langugaeText?.reset ?? "Reset" }
var CBtnViewAll: String{ return appDelegate.langugaeText?.view_all ?? "View All" }
var CBtnInterested: String{ return appDelegate.langugaeText?.interested ?? "Interested" }
var CBtnNotInterested: String{ return appDelegate.langugaeText?.not_interested ?? "Not interested" }
var CBtnMayBe: String{ return appDelegate.langugaeText?.may_be ?? "May be" }

var CSuccess: String{ return appDelegate.langugaeText?.success ?? "success" }
var CBtnDelete: String{ return appDelegate.langugaeText?.delete ?? "Delete" }
var CBtnEdit: String{ return appDelegate.langugaeText?.edit ?? "Edit" }
var CBtnSave: String{ return appDelegate.langugaeText?.save ?? "Save" }
var CBtnDone: String{ return appDelegate.langugaeText?.done ?? "Done" }
var CBtnSkip: String{ return appDelegate.langugaeText?.skip ?? "Skip" }
var CBtnOk: String{ return appDelegate.langugaeText?.ok ?? "Ok" }
var CBtnCancel: String{ return appDelegate.langugaeText?.cancel ?? "Cancel" }
var CBtnShare: String{ return appDelegate.langugaeText?.share ?? "Share" }
var CBtnConfirm: String{ return appDelegate.langugaeText?.confirm ?? "Confirm" }
var CBtnAddFriend: String{ return appDelegate.langugaeText?.add_friend ?? "Add Friend" }
var CBtnUnfriend: String{ return appDelegate.langugaeText?.unfriend ?? "Unfriend" }
var CBtnCancelRequest: String{ return appDelegate.langugaeText?.cancel_request ?? "Cancel Request" }
var CBtnAccept: String{ return appDelegate.langugaeText?.accept ?? "Accept" }
var CBtnReject: String{ return appDelegate.langugaeText?.reject ?? "Reject" }
var CBtnBlockUser: String{ return appDelegate.langugaeText?.block_user ?? "Block User" }
var CBtnUnblockUser: String{ return appDelegate.langugaeText?.ublock_user ?? "Unblock User" }
var CBtnReportUser: String{ return appDelegate.langugaeText?.report_user ?? "Report User" }
var CBtnAddYourInterest: String{ return appDelegate.langugaeText?.profile_add_your_interest ?? "Add Your interest" }
var CBtnStudent: String{ return appDelegate.langugaeText?.student ?? "Student" }
var CBtnUnemployed: String{ return appDelegate.langugaeText?.un_employed ?? "Un-employed" }
var CBtnDeleteForMe: String{ return appDelegate.langugaeText?.delete_for_me ?? "Delete for me" }
var CBtnDeleteForEveryone: String{ return appDelegate.langugaeText?.delete_for_everyone ?? "Delete for everyone" }

//MARK:- Login Screen
var CLoginDontHaveAccount: String{ return appDelegate.langugaeText?.login_dont_have_an_account ?? "Do not have an Account?" }
//var CLoginPlaceholderEmailMobile: String{ return appDelegate.langugaeText?.login_email_or_mobile ?? "Email address" }
var CLoginPlaceholderEmailMobile: String{ return appDelegate.langugaeText?.login_email_or_mobile ?? "Email address/mobile number" }
var CLoginPlaceholderPassword: String{ return appDelegate.langugaeText?.login_password ?? "Password" }
var CLoginBtnForgot: String{ return appDelegate.langugaeText?.login_forgot_password ?? "Forgot password?" }
var CLoginBtnSignIn: String{ return appDelegate.langugaeText?.login_signin ?? "Sign In" }
var CLoginWithSocial: String{ return appDelegate.langugaeText?.login_with_social ?? "Or login with social media" }
var CLoginAlertEmailMobileBlank: String{ return appDelegate.langugaeText?.login_email_or_mobile_cant_blank ?? "Please enter registered mobile number or email address" }
var CLoginAlertUserExist: String{ return appDelegate.langugaeText?.login_invalid_credentials_email ?? "Email address/Mobile Number and password is not registered with us" }
//var CLoginAlertUserPhNoExist: String{ return appDelegate.langugaeText?.login_invalid_credentials_mobile ?? "Mobile Number and password is not registered with us" }


var CLoginAlertValidEmail: String{ return appDelegate.langugaeText?.login_enter_valid_email_address ?? "Please enter valid email address" }

var CLoginAlertMessage: String{ return appDelegate.langugaeText?.login_password_cant_blank ?? "Please check email and password" }

var CLoginAlertValidMobileNumber: String{ return appDelegate.langugaeText?.login_enter_valid_mobile_no ?? "Please enter valid mobile number" }
var CLoginAlertPasswordBlank: String{ return appDelegate.langugaeText?.login_password_cant_blank ?? "Please enter password" }

//MARK:- Register Screen
var CRegisterTitle: String{ return appDelegate.langugaeText?.register ?? "Register" }
var CRegisterSignup: String{ return appDelegate.langugaeText?.register_signup ?? "Sign Up" }
var CRegisterSuccess: String{ return appDelegate.langugaeText?.successfully_signup ?? "Congratulations, Your Account has been Successfully Created" }
var CREgisterREsendOTP : String{ return appDelegate.langugaeText?.alert_resend_otp ?? "OTP has been Resent" }
var CRegisterPlaceholderFirstName: String{ return appDelegate.langugaeText?.register_first_name ?? "First Name" }
var CRegisterPlaceholderLastName: String{ return appDelegate.langugaeText?.register_last_name ?? "Last Name" }
var CRegisterPlaceholderEmail: String{ return appDelegate.langugaeText?.register_email ?? "Email Address" }
var CRegisterPlaceholderPassword: String{ return appDelegate.langugaeText?.register_password ?? "Password" }
var CRegisterPlaceholderConfirmPassword: String{ return appDelegate.langugaeText?.register_confirm_password ?? "Confirm Password" }
var CRegisterPlaceholderMobileNumber: String{ return appDelegate.langugaeText?.register_mobile_number ?? "Mobile Number" }
var CRegisterPlaceholderGender: String{ return appDelegate.langugaeText?.register_gender ?? "Select Gender" }
var CRegisterPlaceholderDob: String{ return appDelegate.langugaeText?.register_dob ?? "Date of Birth" }
var CRegisterPlaceholderSelectLocation: String{ return appDelegate.langugaeText?.register_select_location ?? "Select Location" }

var gender: String{ return appDelegate.langugaeText?.gender ?? "Gender" }
var CRegisterPlaceholderCode: String{ return appDelegate.langugaeText?.register_code ?? "Code" }
var CRegisterGenderMale: String{ return appDelegate.langugaeText?.register_male ?? "Male" }
var CRegisterGenderFemale: String{ return appDelegate.langugaeText?.register_female ?? "Female" }
var CRegisterGenderOther: String{ return appDelegate.langugaeText?.register_others ?? "Others" }
var CRegisterChooseFromPhone: String{ return appDelegate.langugaeText?.register_choose_from_phone ?? "Choose from phone" }
var CRegisterTakePhoto: String{ return appDelegate.langugaeText?.register_take_photo ?? "Take a photo" }
var CRegisterRemovePhoto: String{ return appDelegate.langugaeText?.remove_photo ?? "Remove Photo" }
var CRegisterAlertFirstNameBlank: String{ return appDelegate.langugaeText?.register_first_name_cant_blank ?? "First Name Cannot be Blank" }
var CRegisterAlertLastNameBlank: String{ return appDelegate.langugaeText?.register_last_name_cant_blank ?? "Last Name Cannot be Blank" }
var CRegisterAlertEmailBlank: String{ return appDelegate.langugaeText?.register_email_cant_blank ?? "Please enter email address" }
var CRegisterAlertValidEmail: String{ return appDelegate.langugaeText?.register_enter_valid_email_address ?? "Please enter valid email address" }
var CRegisterAlertPasswordBlank: String{ return appDelegate.langugaeText?.register_password_cant_blank ?? "Please enter Password" }
var CRegisterPasswordMinLimit: String{ return appDelegate.langugaeText?.register_password_min_val ?? "Password must be minimum 8 character alphanumeric and must have at least one special character" }
var CRegisterAlertConfirmPasswordBlank: String{ return appDelegate.langugaeText?.register_confirm_password_blank ?? "Confirm Password" }
var CRegisterAlertPasswordConfirmPasswordNotMatch: String{ return appDelegate.langugaeText?.register_password_check_same ?? "Password and confirm password do not match" }
var CRegisterAlertCountryCodeBlank: String{ return appDelegate.langugaeText?.register_country_code_cant_blank ?? "Please select Country code" }
var CRegisterAlertMobileNumberBlank: String{ return appDelegate.langugaeText?.register_mobile_cant_blank ?? "Please enter mobile number" }
var CRegisterAlertValidMobileNumber: String{ return appDelegate.langugaeText?.register_enter_valid_mobile_no ?? "Please enter valid mobile number" }
var CRegisterAlertGenderBlank: String{ return appDelegate.langugaeText?.register_gender_cant_blank ?? "Please select gender" }
var CRegisterAlertDobBlank: String{ return appDelegate.langugaeText?.register_dob_cant_blank ?? "Please enter date of birth" }
var CRegisterAlertLocationBlank: String{ return appDelegate.langugaeText?.register_location_cant_blank ?? "Please select location" }
var CRegisterAlertConfirmedEmailMobile: String{ return appDelegate.langugaeText?.register_confirm_entered_email_and_mobile ?? "Please confirm the entered email address and mobile number is correct:" }


//MARK:- Verify Emai/Mobile Screen
var CVerifyEmailTitle: String{ return appDelegate.langugaeText?.verify_email ?? "Verify email address" }
var CVerifyMobileTitle: String{ return appDelegate.langugaeText?.verify_mobile ?? "" }
var CVerifyEmailVerificationInfoText: String{ return appDelegate.langugaeText?.register_email_verification_text ?? "We have sent verification code to verify your email" }
var CVerifyMobileVerificationInfoText: String{ return appDelegate.langugaeText?.register_mobile_verification_text ?? "We have sent you verification code to verify your mobile number" }
var CRegisterPlaceholderVerificationCode: String{ return appDelegate.langugaeText?.register_enter_verification_code ?? "Enter verification code" }
var CForgotBtnResendCode: String{ return appDelegate.langugaeText?.register_resend_code ?? "Resend code" }
var CSELECTCHOICE: String{ return appDelegate.langugaeText?.select_your_choice ?? "select your choice " }
var CWRONGOTP: String{ return appDelegate.langugaeText?.entered_wrong_otp ?? "Entered wrong OTP" }
var CEXISTMOBILENO: String{ return appDelegate.langugaeText?.the_provided_Mobile_Number_already_registered ?? "The provided Mobile Number already registered" }
var CEXISTEMAILID: String{ return appDelegate.langugaeText?.the_provided_email_id_already_registered ?? "The provided email id already registered" }
var CSIGNUPEMAILID: String{ return appDelegate.langugaeText?.signup_with_email_id ?? "signup with email id" }
var CSIGNUPMOBILENO: String{ return appDelegate.langugaeText?.signup_with_mobile_number ?? "signup with mobile number" }
var CForgotAlertVerficationCodeIncorrect: String{ return appDelegate.langugaeText?.reset_verification_code_invalid ?? "Please enter valid verification code" }

//Feed Back

var CNotuserFriendlye: String{ return appDelegate.langugaeText?.not_user_friendly ?? "Not User Friendly" }
var CPromptsnotclear: String{ return appDelegate.langugaeText?.prompts_not_clear ?? "Prompts not clear " }
var CImproperLanguage: String{ return appDelegate.langugaeText?.improper_language ?? "Improper language" }
var CIncorrectLanguageTranslation: String{ return appDelegate.langugaeText?.incorrect_language_translation ?? "Incorrect language translation" }
var CNeedHelpScreens: String{ return appDelegate.langugaeText?.need_help_screens ?? "Need help screens" }
var CMissingFunctionality: String{ return appDelegate.langugaeText?.missing_functionality ?? "Missing functionality" }
var CNicetoHaveFunctionality: String{ return appDelegate.langugaeText?.nice_to_have_functionality ?? "Nice to have functionality" }
var CNeedHelpWith: String{ return appDelegate.langugaeText?.need_help_with ?? "Need help with" }



//MARK:- Invite&Connect and Interest Screen
var CSelectInterestTitle: String{ return appDelegate.langugaeText?.add_your_interests_passions ?? "Add your Interests/Passions" }
var CSelectAll: String{ return appDelegate.langugaeText?.invite_select_all ?? "Select All" }
var CConnectAll: String{ return appDelegate.langugaeText?.connect_all ?? "Connect All" }
var CCreateOwnInterest: String{ return appDelegate.langugaeText?.create_own_interest ?? "Create own interest" }
var CInterestBlank: String{ return appDelegate.langugaeText?.interest_name_cant_blank ?? "Name of Interest must not be blank" }
var CInviteConnectTitle: String{ return appDelegate.langugaeText?.invite_contact ?? "Invite Contact" }
var CInviteConnectInviteFriend: String{ return appDelegate.langugaeText?.invite_friends ?? "Invite Friends" }
var CInviteConnectImportContact: String{ return appDelegate.langugaeText?.invite_import_contacts_form ?? "Import Contacts Form" }
var CInviteConnectNoFriend: String{ return appDelegate.langugaeText?.invite_import_contacts_text ?? "You have not imported any contacts, please import contacts from any of the above options" }
var CInviteSentSuccess: String{ return appDelegate.langugaeText?.invitation_sent_successfully ?? "Invitation sent" }
var CInviteSentUnSuccess: String{ return appDelegate.langugaeText?.invitation_sent_fail ?? "There was some issue sending an invite. Please try again later" }


//MARK:- Forgot PWD Screen
var CForgotTitle: String{ return appDelegate.langugaeText?.forgot_password ?? "Forgot password" }
var CForgotPlaceholderEmailMobile: String{ return appDelegate.langugaeText?.login_email_or_mobile ?? "Email address/mobile number" }
var CForgotBtnSubmit: String{ return appDelegate.langugaeText?.forgot_password_submit ?? "Submit" }
var CForgotAlertEmailMobileBlank: String{ return appDelegate.langugaeText?.forgot_email_or_mobile_cant_blank ?? "Please enter registered mobile number or email address" }
var CForgotAlertValidEmail: String{ return appDelegate.langugaeText?.forgot_enter_valid_email_address ?? "Please enter valid email address" }
var CForgotAlertValidMobileNumber: String{ return appDelegate.langugaeText?.forgot_enter_valid_mobile_no ?? "Please enter valid mobile number" }
var CForgotResetText1: String{ return appDelegate.langugaeText?.forgot_password_reset_text1 ?? "Enter your registered" }
var CForgotResetMobileEmail: String{ return appDelegate.langugaeText?.login_email_or_mobile ?? "Email address/mobile number" }
var CForgotResetText2: String{ return appDelegate.langugaeText?.forgot_password_reset_text2 ?? "To reset password. Verification code will be sent to your email address/ mobile number" }
//MARK:- REWARDS
var CSUBSCRIPTION: String{ return appDelegate.langugaeText?.ad_free_subscription ?? "To reset password. Verification code will be sent to your email address/ mobile number" }
var CADVERTISEMENTS: String{ return appDelegate.langugaeText?.advertisements ?? "To reset password. Verification code will be sent to your email address/ mobile number" }
var CADMINCORRECTION: String{ return appDelegate.langugaeText?.admin_correction ?? "To reset password. Verification code will be sent to your email address/ mobile number" }
var CSELLPOSTS: String{ return appDelegate.langugaeText?.sell_posts ?? "To reset password. Verification code will be sent to your email address/ mobile number" }
var CUSAGEPOSTS: String{ return appDelegate.langugaeText?.usage_time ?? "To reset password. Verification code will be sent to your email address/ mobile number" }
var CCONNECTIONS: String{ return appDelegate.langugaeText?.connections ?? "To reset password. Verification code will be sent to your email address/ mobile number" }
var CPOSTS: String{ return appDelegate.langugaeText?.postsrwds ?? "To reset password. Verification code will be sent to your email address/ mobile number" }
var CFEEDBACK: String{ return appDelegate.langugaeText?.feedback ?? "To reset password. Verification code will be sent to your email address/ mobile number" }


//MARK:- Reset PWD Screen
var CResetTitle: String{ return appDelegate.langugaeText?.reset_password ?? "Reset password" }
var CResetPlaceholderOTP: String{ return appDelegate.langugaeText?.reset_enter_otp ?? "Enter verification code" }
var CResetPlaceholderNewPassword: String{ return appDelegate.langugaeText?.reset_new_password ?? "New password" }
var CResetPlaceholderConfirmNewPassword: String{ return appDelegate.langugaeText?.reset_confirm_password ?? "Confirm password" }
var CResetBtnUpdate: String{ return appDelegate.langugaeText?.reset_update ?? "Update" }
var CResetAlertVerificationCodeBlank: String{ return appDelegate.langugaeText?.reset_verification_code_cant_blank ?? "Please enter verification code" }
var CResetAlertNewPWDBlank: String{ return appDelegate.langugaeText?.reset_new_password_cant_blank ?? "Please enter new password" }
var CResetAlertMinLimit: String{ return appDelegate.langugaeText?.reset_password_min_val ?? "Password must be minimum 8 character alphanumeric and must have at least one special character" }
var CResetAlertConfirmPWDBlank: String{ return appDelegate.langugaeText?.reset_confirm_password_blank ?? "Please confirm password" }
var CResetAlertPWDConfirmPWDNotMatch: String{ return appDelegate.langugaeText?.reset_new_password_and_confirm_password_mismatch ?? "New password and confirm password do not match" }
var CResetPassword: String{ return appDelegate.langugaeText?.reset_password_changed_successfully ?? "Password changed" }
var CResetPasswordNotMatch: String{ return appDelegate.langugaeText?.password_does_not_match ?? "Password Does not Match" }
var CResetOldPasswordNotMatch: String{ return appDelegate.langugaeText?.old_password_does_not_match ?? "Old password does not match" }
var CResetOldNewPasswordMatch: String{ return appDelegate.langugaeText?.old_new_password_does_match ?? "Old and New password are same" }
var CAlreadyVoted: String{ return appDelegate.langugaeText?.already_voted ?? "Your already voted" }

var CGroupMemberExist: String{ return appDelegate.langugaeText?.group_member_already_exist ?? "Group Member Already Exist" }


//MARK:- Profile Screen
var CLive_in: String{ return appDelegate.langugaeText?.live_in ?? "Live" }
var CRelationship_Status: String{ return appDelegate.langugaeText?.relationship_status ?? "Relationship" }
var CNavEditProfile: String{ return appDelegate.langugaeText?.edit_profile ?? "Edit Profile" }
var CNavCompleteProfile: String{ return appDelegate.langugaeText?.profile_complete ?? "Complete Profile" }
var CNavMyProfile: String{ return appDelegate.langugaeText?.my_profile ?? "My Profile" }
var CProfileTitle: String{ return appDelegate.langugaeText?.profile_complete ?? "Complete Profile" }
var CProfilePlaceholderBiography: String{ return appDelegate.langugaeText?.profile_biography ?? "Biography" }
var CProfilePlaceholderStatus: String{ return appDelegate.langugaeText?.profile_status ?? "Status" }
var CProfilePlaceholderEmployed: String{ return appDelegate.langugaeText?.profile_employed ?? "Employed" }
var CProfilePlaceholderEducation: String{ return appDelegate.langugaeText?.profile_education ?? "Education" }
var CProfilePlaceholderReligiousInclination: String{ return appDelegate.langugaeText?.profile_religious_inclination ?? "Religious inclination" }
var CProfilePlaceholderProfession: String{ return appDelegate.langugaeText?.profile_profession ?? "Profession" }
var CProfilePlaceholderEnterProfession: String{ return appDelegate.langugaeText?.profile_enter_your_profession ?? "Enter your profession" }
var CProfilePlaceholderReligiousIncomeLevel: String{ return appDelegate.langugaeText?.profile_income_level ?? "Income Level" }
var CProfilePlaceholderReligiousPersonalInterest: String{ return appDelegate.langugaeText?.profile_personal_interest ?? "Personal interest" }
var CProfilePlaceholderPreferences: String{ return appDelegate.langugaeText?.profile_preferences ?? "Profile preferences" }
var CProfileSelectIncome: String{ return appDelegate.langugaeText?.profile_select_income ?? "Select income" }
var CProfileBtnUpdateComplete: String{ return appDelegate.langugaeText?.profile_update_complete ?? "Update/Complete Profile" }
var CProfileBtnViewCompleteProfile: String{ return appDelegate.langugaeText?.view_complete_profile ?? "View complete Profile" }
var CProfilePosts: String{ return appDelegate.langugaeText?.posts ?? "Posts" }
var CProfilePost: String{ return appDelegate.langugaeText?.post ?? "Post" }
var CProfileAdsPosts: String{ return appDelegate.langugaeText?.ads_posted ?? "Ads posted" }
var CProfileTimeSpent: String{ return appDelegate.langugaeText?.time_spent ?? "Time spent" }
var CProfileDataUpload: String{ return appDelegate.langugaeText?.data_upload ?? "Data upload" }
var CProfileFriends: String{ return appDelegate.langugaeText?.friends ?? "Friends" }
var CProfileFriend: String{ return appDelegate.langugaeText?.friend ?? "Friend" }


//MARK:- Side Menu options
var CSideHome: String{ return appDelegate.langugaeText?.sidemenu_home ?? "Home" }
var CSideProfile: String{ return appDelegate.langugaeText?.sidemenu_profile ?? "Profile" }
var CSideChat: String{ return appDelegate.langugaeText?.sidemenu_chats ?? "Chats" }
var CSideGroups: String{ return appDelegate.langugaeText?.sidemenu_groups ?? "Groups" }
var CSideQuotes: String{ return appDelegate.langugaeText?.sidemenu_quotes ?? "Quotes" }

var CSidePostAds: String{ return appDelegate.langugaeText?.sidemenu_post_ads ?? "Post Ads" }
var CSideNews: String{ return appDelegate.langugaeText?.sidemenu_news ?? "News" }
var CSidePSL: String{ return  appDelegate.langugaeText?.sidemenu_PSL ?? "Public Service" }
var CSideFavWebSites: String{ return appDelegate.langugaeText?.sidemenu_fav_websites ?? "Fav. web sites" }
var CSideConnectInvite: String{ return appDelegate.langugaeText?.sidemenu_connect_invite ?? "Connect & Invite" }
var CSideEventCalendar: String{ return appDelegate.langugaeText?.sidemenu_event_calendar ?? "Event Calendar" }
var CSideNotifications: String{ return appDelegate.langugaeText?.sidemenu_notifications ?? "Notifications" }
var CShoutHere: String{ return appDelegate.langugaeText?.shout_here ?? "shout here and tell all you know about it" }
var CSideSettings: String{ return appDelegate.langugaeText?.sidemenu_settings ?? "Settings" }
var CSideLogout: String{ return appDelegate.langugaeText?.sidemenu_logout ?? "Logout" }

//MARK:- Setting options
var CNavSettings: String{ return appDelegate.langugaeText?.sidemenu_settings ?? "Settings" }
var CSettingEditprofile: String{ return appDelegate.langugaeText?.edit_profile ?? "Edit Profile" }
var CSettingProfilePreference: String{ return appDelegate.langugaeText?.profile_preferences ?? "Profile preferences" }
var CSettingChangePassword: String{ return appDelegate.langugaeText?.settings_change_password ?? "Change Password" }
var CSettingPushNotification: String{ return appDelegate.langugaeText?.settings_push_notifications ?? "Push Notifications" }
var CSettingEmailNotification: String{ return appDelegate.langugaeText?.settings_email_notifications ?? "Email Notifications" }
var CSettingLanguageSetting: String{ return appDelegate.langugaeText?.settings_language ?? "Language setting" }
var CSettingFeedback: String{ return appDelegate.langugaeText?.settings_feedback ?? "Feedback" }

var CSettingRestorePurchased: String{ return appDelegate.langugaeText?.restore_purchased ?? "Restore Purchased" }
var CSettingAboutus: String{ return appDelegate.langugaeText?.about_us ?? "About Us" }
var CSettingTermsAndConditions: String{ return appDelegate.langugaeText?.settings_terms_conditions ?? "Terms & Conditions" }
var CSettingPrivacyPolicy: String{ return appDelegate.langugaeText?.privacy_policy ?? "Privacy Policy" }
var CSettingContactUs: String{ return appDelegate.langugaeText?.profile_contact_us ?? "Contact Us" }
var CFeedbackMessage: String{ return appDelegate.langugaeText?.feedback_txt ?? "Please enter feedback message" }
var CBlockedUsers: String{ return appDelegate.langugaeText?.blocked_users ?? "Blocked users" }
var CFeedbackTypeOthers: String{ return appDelegate.langugaeText?.others ?? "Others" }
var CSelectLanguage: String{ return appDelegate.langugaeText?.select_language ?? "Select language" }
var CProfileVisibleForFriend: String{ return appDelegate.langugaeText?.profile_visible_for_friends ?? "Profile visibility for friends" }
var CProfileVisibleForOther: String{ return appDelegate.langugaeText?.profile_visible_for_others ?? "Profile visibility for unknowns" }
var CProfileBasic: String{ return appDelegate.langugaeText?.basic ?? "Basic" }
var CProfileComplete: String{ return appDelegate.langugaeText?.complete ?? "Complete" }
var COldPassword: String{ return appDelegate.langugaeText?.old_password ?? "Old password" }
var CBlankOldPassword: String{ return appDelegate.langugaeText?.please_enter_old_password ?? "Please enter old password" }
var CSelectCategory: String{ return appDelegate.langugaeText?.select_category ?? "Select category" }
var CSelectSubCategory: String{ return appDelegate.langugaeText?.select_sub_category ?? "Select Sub category" }
var CBlankFeedbackCategory: String{ return appDelegate.langugaeText?.feedback_category_required ?? "Please select feedback category" }
var CBlockedUser: String{ return appDelegate.langugaeText?.blocked_user ?? "Blocked User" }
var CUnblockUser: String{ return appDelegate.langugaeText?.unblock_user ?? "Unblock User" }
var CUnblock: String{ return appDelegate.langugaeText?.unblock ?? "Unblock" }
var CAlertblocked: String{ return appDelegate.langugaeText?.alert_message_blocked ?? "Blocked" }
var CAlertUnblock: String{ return appDelegate.langugaeText?.alert_message_unblock ?? "Unblock" }
var CBlockedUsersCount: String{ return appDelegate.langugaeText?.blocked_users_count ?? "You have" }
var CPlaceholderWriteYourMessageHere: String{ return appDelegate.langugaeText?.write_your_message_here ?? "Write your message here.." }
var CFeedBackMessage: String{ return appDelegate.langugaeText?.alert_message_feedback ?? "Feedback Submitted Successfully" }

//MARK:- Home Screen
var CMessageWhichTypesOfPostYouAreLooking: String{ return appDelegate.langugaeText?.which_types_of_post_you_are_looking ?? "Which types of post you are looking?" }
var CTypeAll: String{ return appDelegate.langugaeText?.all ?? "All" }
var CTypeArticle: String{ return appDelegate.langugaeText?.article ?? "Article" }
var CTypeChirpy: String{ return appDelegate.langugaeText?.chirpy ?? "Chirpy" }
var CTypeForum: String{ return appDelegate.langugaeText?.forum ?? "Forum" }
var CTypeGallery: String{ return appDelegate.langugaeText?.gallery ?? "Gallery" }
var CTypeEvent: String{ return appDelegate.langugaeText?.event ?? "Event" }
var CTypeUser: String{ return appDelegate.langugaeText?.user ?? "Users" }
var CTypeShout: String{ return appDelegate.langugaeText?.shout ?? "Shout" }
var CTypeImage: String{ return appDelegate.langugaeText?.image ?? "Image" }

//MARK:- Post Related Common MSG
var CPostPostsInviteAllFriends: String{ return appDelegate.langugaeText?.posts_invite_allFriends ?? "All Friends" }
var CPostPostsInviteContacts: String{ return appDelegate.langugaeText?.posts_invite_friends ?? "Invite Contacts" }
var CPostPostsInviteGroups: String{ return appDelegate.langugaeText?.posts_invite_group ?? "Invite Groups" }

var CPostPlaceholderMinAge: String{ return appDelegate.langugaeText?.posts_minimum_age ?? "Minimum age limit" }
var CMessagePostAgeLimit: String{ return appDelegate.langugaeText?.event_age_limit ?? "Please enter age limit" }
var CMessagePostsSelectFriends: String{ return appDelegate.langugaeText?.posts_select_friends ?? "Select contact/group" }

//MARK:- Article Screen
var CNavViewArticles: String{ return appDelegate.langugaeText?.article_details ?? "Article details" }
var CNavAddArticle: String{ return appDelegate.langugaeText?.add_article ?? "Add Article" }
var CNavEditArticle: String{ return appDelegate.langugaeText?.edit_article ?? "Edit Article" }
var CArticlePlaceholderTitle: String{ return appDelegate.langugaeText?.enter_article_title ?? "Enter Article title" }
var CArticlePlaceholderSelecetCategory: String{ return appDelegate.langugaeText?.select_category_of_article ?? "Select category of Article" }

var CArticlePlaceholderContent: String{ return appDelegate.langugaeText?.write_an_article_content_here ?? "Write an Article content here" }
var CMessageArticleTitle: String{ return appDelegate.langugaeText?.article_title_cant_blank ?? "Please enter Article title" }
var CMessageArticleImage: String{ return appDelegate.langugaeText?.article_image_cant_blank ?? "Please add Article image" }
var CMessageArticleCategory: String{ return appDelegate.langugaeText?.article_category_cant_blank ?? "Please select Article category" }
var CMessageArticleContent: String{ return appDelegate.langugaeText?.targeted_content_cant_blank ?? "Please enter Article content" }
var CMessageSelectContactGroupArticle: String{ return appDelegate.langugaeText?.article_targeted_audience_cant_blank ?? "Please select to whom you want to post this Article" }
var CMessageArticlePostUpload : String{ return appDelegate.langugaeText?.article_created_successfully ?? "Article posted Successfully" }
var CMessageArticlePostUpdated : String{ return appDelegate.langugaeText?.article_edited_successfully ?? "Article has been updated" }
var CMessagePostDeleted : String{ return appDelegate.langugaeText?.alert_message_delete ?? "Article has been updated" }

//MARK:- Forum Screen
var CNavFavAddForum: String{ return appDelegate.langugaeText?.add_forum ?? "Add Forum" }
var CNavForumDetails: String{ return appDelegate.langugaeText?.forum_details ?? "Forum details" }
var CNavFavEditForum: String{ return appDelegate.langugaeText?.edit_forum ?? "Edit Forum" }
var CForumPlaceholderTitle: String{ return appDelegate.langugaeText?.enter_forum_title ?? "Enter Forum title" }
var CForumPlaceholderSelecetCategory: String{ return appDelegate.langugaeText?.enter_forum_category ?? "Select category of Forum" }
var CForumPlaceholderContent: String{ return appDelegate.langugaeText?.enter_forum_content ?? "Write your message here" }
var CMessageForumTitle: String{ return appDelegate.langugaeText?.forum_title_cant_blank ?? "Please enter Forum title" }
var CMessageForumCategory: String{ return appDelegate.langugaeText?.forum_category_cant_blank ?? "Please select Forum category" }
var CMessageForumContent: String{ return appDelegate.langugaeText?.forum_content_cant_blank ?? "Please enter Forum content" }
var CMessageSelectContactGroupForum: String{ return appDelegate.langugaeText?.forum_targeted_audience_cant_blank ?? "Please select to whom you want to post this Forum" }
var CMessageForumPostUpload : String{ return appDelegate.langugaeText?.forum_created_successfully ?? "Your Forum has been posted" }
var CMessageForumPostUpdated : String{ return appDelegate.langugaeText?.forum_edited_successfully ?? "Forum has been updated" }

//MARK:- Chirpy Screen
var CNavChirpyDetails: String{ return appDelegate.langugaeText?.chirpy_details ?? "Chirpy details" }
var CNavAddChirpy: String{ return appDelegate.langugaeText?.add_chirpy ?? "Add Chirpy" }
var CNavEditChirpy: String{ return appDelegate.langugaeText?.edit_chirpy ?? "Edit Chirpy" }
var CChirpyPlaceholderSelecetCategory: String{ return appDelegate.langugaeText?.select_category_of_chirpy ?? "Select category of Chirpy" }
var CChirpyPlaceholderContent: String{ return appDelegate.langugaeText?.enter_chirpy_content ?? "Write your message here" }
var CMessageChirpyContent: String{ return appDelegate.langugaeText?.chirpy_message_cant_blank ?? "Please enter Chirpy message" }
var CMessageChirpyCategory: String{ return appDelegate.langugaeText?.chirpy_category_cant_blank ?? "Please select Chirpy category" }
var CMessageSelectContactGroupChirpy: String{ return appDelegate.langugaeText?.post_targeted_audience_cant_blank ?? "Please select to whom you want to post this Chirpy" }
var CMessageChirpyPostUpload : String{ return appDelegate.langugaeText?.chirpy_created_successfully ?? "Chirpy added Successfully" }
var CMessageChirpyPostUpdated : String{ return appDelegate.langugaeText?.chirpy_edited_successfully ?? "Chirpy has been updated" }

//MARK:- Event Screen
var CbtnAllEvents: String{ return appDelegate.langugaeText?.all_events ?? "All Events" }
var CbtnMyEvents: String{ return appDelegate.langugaeText?.my_events ?? "My Events" }
var CbtnViewAllEvents: String{ return appDelegate.langugaeText?.event_view_all ?? "View All>" }
var CNavEventsCalendar: String{ return appDelegate.langugaeText?.event_calendar ?? "Event calendar" }
var CNavEventsDetails: String{ return appDelegate.langugaeText?.event_details ?? "Event details" }
var CNavAddEvent: String{ return appDelegate.langugaeText?.add_event ?? "Add Event" }
var CNavEditEvent: String{ return appDelegate.langugaeText?.edit_event ?? "Edit Event" }
var CEventPlaceholderTitle: String{ return appDelegate.langugaeText?.enter_event_title ?? "Enter Event title" }
var CEventPlaceholderSelecetCategory: String{ return appDelegate.langugaeText?.select_category_of_event ?? "Select category of Event" }
var CEventPlaceholderContent: String{ return appDelegate.langugaeText?.write_an_event_content_here ?? "Write an Event content here" }
var CEventPlaceholderStartDateTime: String{ return appDelegate.langugaeText?.enter_event_start_date ?? "Enter start date & time" }
var CEventPlaceholderEndDateTime: String{ return appDelegate.langugaeText?.enter_event_end_date ?? "Enter end date & time" }
var CEventPlaceholderLocation: String{ return appDelegate.langugaeText?.enter_event_location ?? "Event location" }
var CMessageEventTitle: String{ return appDelegate.langugaeText?.event_title_cant_blank ?? "Please enter Event title" }
var CMessageEventCategory: String{ return appDelegate.langugaeText?.event_category_cant_blank ?? "Please select Event category" }
var CMessageEventContent: String{ return appDelegate.langugaeText?.event_content_cant_blank ?? "Please enter Event content" }
var CMessageEventStartDate: String{ return appDelegate.langugaeText?.event_start_date_cant_blank ?? "Please enter start date & time" }
var CMessageEventEndDate: String{ return appDelegate.langugaeText?.event_end_date_cant_blank ?? "Please enter end date & time" }
var CMessageEventLocation: String{ return appDelegate.langugaeText?.event_location_cant_blank ?? "Please select Event location" }
var CAlertEventEndMax: String{ return appDelegate.langugaeText?.event_end_date_must_be_greater ?? "Event end date and time must greater than start date and time" }
var CMessageSelectContactGroupEvent: String{ return appDelegate.langugaeText?.event_targeted_audience_cant_blank ?? "Please select to whom you want to post this Event" }
var CMessageInviteeAcceptedEvent: String{ return appDelegate.langugaeText?.invites_accepted_event ?? "Invitees accepted event" }
var CMessageEventPostUpload : String{ return appDelegate.langugaeText?.event_created_successfully ?? "Event added Successfully" }
var CMessageEventPostUpdated : String{ return appDelegate.langugaeText?.event_edited_successfully ?? "Event has been updated" }
var CMessageAboutEvent : String{ return appDelegate.langugaeText?.about_event ?? "About Event" }
var CMessageNoEvent : String{ return appDelegate.langugaeText?.no_events_yet ?? "No events yet" }



//MARK:- Shout Screen
var CNavAddShout: String{ return appDelegate.langugaeText?.add_shout ?? "Add Shout" }
//var CNavCreateShout: String{ return (appDelegate.langugaeText?.post_shout)! }
var CNavEditShout: String{ return appDelegate.langugaeText?.edit_shout ?? "Edit Shout" }
var CNavShoutDetails: String{ return appDelegate.langugaeText?.shout_details ?? "Shout details" }
var CMessageShoutContent: String{ return appDelegate.langugaeText?.shout_message_cant_blank ?? "Please enter Shout message" }
var CMessageSelectContactGroupShout: String{ return appDelegate.langugaeText?.please_select_to_whom_you_want_to_post_this_shout ?? "Please select to whom you want to post this Shout" }
var CShoutPlaceholderContent: String{ return appDelegate.langugaeText?.enter_shout_content ?? "Write your message here" }

var CShoutPlaceholderContents: String{ return appDelegate.langugaeText?.enter_shout_content ?? "Share Some What you are Thinking" }

var CMessageShoutPostUpload : String{ return appDelegate.langugaeText?.shout_created_successfully ?? "Shout added Successfully" }
var CMessageShoutPostUpdated : String{ return appDelegate.langugaeText?.shout_edited_successfully ?? "Shout has been updated" }
var CMessageSpecial : String{ return appDelegate.langugaeText?.alert_message_special_character ?? "Avoid special character" }


//MARK:- Image Screen
var CNavEditImage: String{ return appDelegate.langugaeText?.edit_image ?? "Edit Image" }
var CNavSelectImage: String{ return appDelegate.langugaeText?.select_image ?? "Select image" }
var CNavAddImage: String{ return appDelegate.langugaeText?.add_image ?? "Add Image" }
var CNavImageDetails: String{ return appDelegate.langugaeText?.view_image ?? "Gallery details" }
var CMessageSelectContactGroupImage : String{ return appDelegate.langugaeText?.please_select_to_whom_you_want_to_post_this_image ?? "Please select to whom you want to post this image" }
var CMessageImagePostUpdated : String{ return appDelegate.langugaeText?.gallery_edited_successfully ?? "Gallery  posted Successfully" }

//MARK:- Group Chat Related messages
var CgroupCreated: String{ return CLocalize(text: appDelegate.langugaeText?.group_is_added_successfully ?? "Group added Successfully")}
var CgroupRemoved: String{ return CLocalize(text: appDelegate.langugaeText?.group_deleted_successfully ?? "group deleted successfully")}
var CgroupExitYes: String{ return CLocalize(text: appDelegate.langugaeText?.alert_message_exitgroup_yes ?? "You exited from this Group")}
var CgroupExitNo: String{ return CLocalize(text: appDelegate.langugaeText?.alert_message_exitgroup_no ?? "You remain the member of this Group")}

var CNavMemberRequest: String{ return appDelegate.langugaeText?.member_request ?? "Member request" }
var CNavNewGroup: String{ return appDelegate.langugaeText?.new_group ?? "New group" }
var CNavEditGroup: String{ return appDelegate.langugaeText?.edit_group ?? "Edit group" }
var CGroupEnterTitle: String{ return appDelegate.langugaeText?.create_group_enter_title ?? "Group Title" }
var CGroupCreateGroupLinkToJoinGroup: String{ return appDelegate.langugaeText?.create_a_group_link_to_join_this_group ?? "Create a group link to join this group" }
var CGroupPublic: String{ return appDelegate.langugaeText?.group_public ?? "Public" }
var CGroupPrivate: String{ return appDelegate.langugaeText?.group_private ?? "Private" }
var CGroupAddParticipant: String{ return appDelegate.langugaeText?.add_participant ?? "Add Participants" }
var CGroupMemberSelected: String{ return appDelegate.langugaeText?.members_selected ?? "Members selected" }
var CGroupInfoAddMore: String{ return appDelegate.langugaeText?.group_info_add_more ?? "Add more" }
var CGroupImageRequired: String{ return appDelegate.langugaeText?.group_image_required ?? "Please add group image" }
var CGroupDetail: String{ return appDelegate.langugaeText?.group_details ?? "Group details" }
var CGroupEdit: String{ return appDelegate.langugaeText?.edit_group ?? "Edit group" }
var CGroupDelete: String{ return appDelegate.langugaeText?.delete_group ?? "Delete Group" }
var CGroupInfoLink: String{ return appDelegate.langugaeText?.group_info_link ?? "Group Link" }
var CGroupAdmin: String{ return appDelegate.langugaeText?.admin ?? "Admin" }
var CGroupReport: String{ return appDelegate.langugaeText?.report_group ?? "Report group" }
var CGroupMembers: String{ return appDelegate.langugaeText?.group_members ?? "Members" }
var CGroupMember: String{ return appDelegate.langugaeText?.group_member ?? "Member" }
var CGroupExit: String{ return appDelegate.langugaeText?.exit_group ?? "Exit Group" }
var CDeliveredOn: String{ return appDelegate.langugaeText?.delivered_on ?? "Delivered on" }
var CDeliveredTo: String{ return appDelegate.langugaeText?.delivered_to ?? "Delivered to" }
var CMemberOfGroup: String{ return appDelegate.langugaeText?.members_of_this_group ?? "members of this group" }
var CNotDelivered: String{ return appDelegate.langugaeText?.not_delivered ?? "Not Delivered" }


//MARK:- Comment
var CJustNow: String{ return appDelegate.langugaeText?.just_now ?? "Just now" }
var CMinAgo: String{ return appDelegate.langugaeText?.min_ago ?? "min ago" }
var CMinsAgo: String{ return appDelegate.langugaeText?.mins_ago ?? "mins ago" }
var CHourAgo: String{ return appDelegate.langugaeText?.hour_ago ?? "An hour ago" }
var CHoursAgo: String{ return appDelegate.langugaeText?.hours_ago ?? "Hours ago" }
var CDayAgo: String{ return appDelegate.langugaeText?.day_ago ?? "Yesterday" }
var CDaysAgo: String{ return appDelegate.langugaeText?.days_ago ?? "Days ago" }

//MARK:- Report
var CReportArticles: String{ return appDelegate.langugaeText?.report_article ?? "Report Article" }
var CReportForum: String{ return appDelegate.langugaeText?.report_forum ?? "Report Forum" }
var CReportGallery: String{ return appDelegate.langugaeText?.report_gallery ?? "Report Gallery" }
var CReportEvent: String{ return appDelegate.langugaeText?.report_event ?? "Report Event" }
var CReportChirpy: String{ return appDelegate.langugaeText?.report_chirpy ?? "Report Chirpy" }
var CReportShout: String{ return appDelegate.langugaeText?.report_shout ?? "Report Shout" }
var CMessageSelectReportReason: String{ return appDelegate.langugaeText?.please_select_report_reason ?? "Please select report reason" }
var CSelectCountry: String{ return appDelegate.langugaeText?.select_country ?? "Select Country" }
var CMessageConnectNoFriend: String{ return appDelegate.langugaeText?.there_is_no_friend_to_connect ?? "There is no friend to connect" }
var CContactPermissionIsRequired: String{ return appDelegate.langugaeText?.contact_permission_is_required ?? "Contacts permission is required to send the invites" }
var CMessageBlankGroupTitle: String{ return appDelegate.langugaeText?.group_title_cant_blank ?? "Please enter group name" }
var CAlertGroupRemoveParticipant: String{ return appDelegate.langugaeText?.alert_remove_participant_message ?? "Are you sure? you want to remove " }
var CAlertGroupDelete: String{ return appDelegate.langugaeText?.alert_delete_message ?? "Are you sure you want to delete this group?" }
var CAlertGroupExit: String{ return appDelegate.langugaeText?.alert_exit_message ?? "Are you sure you want to exit from this group?" }
var CNoParticipantsYet: String{ return appDelegate.langugaeText?.no_participant_yet ?? "No participants yet" }
var CMessageNoGroupList: String{ return appDelegate.langugaeText?.no_groups_yet ?? "No groups yet" }
var CMessageNoMemberRequest: String{ return appDelegate.langugaeText?.no_member_request_yet ?? "No member request yet" }
var CMessageNoCommentFound: String{ return appDelegate.langugaeText?.no_comment_found ?? "No comments yet" }


//MARK:- Messages

var CMessageEmailExists: String{ return appDelegate.langugaeText?.alert_already_registered_email ?? "The provided Email already registered" }
var CMessagePhNoExists: String{ return appDelegate.langugaeText?.alert_already_registered_ph ?? "The provided Mobile Number already registered" }



var CMessageReport: String{ return appDelegate.langugaeText?.report_success ?? "Your Request is on the way. We will investigate and take an action soon" }
var CMessageUpdatedprofile: String{ return appDelegate.langugaeText?.alert_message_editprofile ?? "Thank You for updating your information" }
var CMessageReportSubmitted: String{ return appDelegate.langugaeText?.group_report_submitted_success ?? "User report has been submitted" }
var CMessagePleaseWait: String{ return appDelegate.langugaeText?.please_wait ?? "Please Wait..." }
var CMessageBlockUser: String{ return appDelegate.langugaeText?.block_user_alert ?? "Are you sure you want to block this user?" }
var CMessageUnBlockUser: String{ return appDelegate.langugaeText?.unblock_user_alert ?? "Are you sure you want to unblock?" }
var CMessageNoContactYet: String{ return appDelegate.langugaeText?.no_contacts_yet ?? "No contacts yet" }
var CMessageNoCommentYet: String{ return appDelegate.langugaeText?.no_comments_yet ?? "No comments yet" }
var CUploadImage: String{ return appDelegate.langugaeText?.upload_image ?? "Upload image" }
var CMessageTypeYourMessage: String{ return appDelegate.langugaeText?.type_your_message ?? "Type your message here.." }
var CMessageCancelSubscription: String{ return appDelegate.langugaeText?.cancel_subscription_alert ?? "" }

var CMessagePostUploadFail: String{ return appDelegate.langugaeText?.post_upload_fail ?? "There has been some issue adding your post. Please try again later" }
var CMessageMaximumImage: String{ return appDelegate.langugaeText?.post_upload_images_maximum ?? "Maximum 5 images are allowed in a single post" }
var CMessageDeleteImage: String{ return appDelegate.langugaeText?.alert_delete_message_image ?? "Are you sure you want to delete this image?" }
var CMessageFilterMinSelection: String{ return appDelegate.langugaeText?.no_interests_select ?? "Please select at least one interest" }
var CMessageDeletePost: String{ return appDelegate.langugaeText?.are_you_sure_you_want_to_delete_this_post ?? "Are you sure you want to delete this post?" }
var CMessageCancelRequest: String{ return appDelegate.langugaeText?.alert_message_for_cancel ?? " You want to cancel this request!" }
var CMessageUnfriend: String{ return appDelegate.langugaeText?.alert_message_for_unfriend ?? "Do you want to unfriend" }
var CMessageAddfriend: String{ return appDelegate.langugaeText?.alert_message_addfriend ?? "Are you sure you want to addfriend?"}
var CMessageAfterUnfriend : String{ return appDelegate.langugaeText?.alert_message_after_unfriend ?? "and you are no longer friends"}
var CMessageAfterCancel : String{ return appDelegate.langugaeText?.alert_message_after_cancelrequest ?? "Sent request has been canceled"}
var CMessageAfterReject : String{ return appDelegate.langugaeText?.alert_message_after_rejectrequest ?? "Friend Request rejected successfully!"}
var CMessageAfterAccept : String{ return appDelegate.langugaeText?.alert_message_after_acceptrequest ?? "You got a new Friend!"}

var CMessageLogout: String{ return appDelegate.langugaeText?.are_you_sure_you_want_to_logout ?? "Do you want to logout?" }

var CMessageAddInterest: String{ return appDelegate.langugaeText?.add_interest ?? "Add Interest" }
var CDeviceUnsupportedCamera: String{ return CLocalize(text: appDelegate.langugaeText?.your_device_does_not_support_camera ?? "Your device does not support camera.") }
var CVideoSizeLimit: String{ return CLocalize(text: appDelegate.langugaeText?.clip_must_not_exceed_100 ?? "The clip must not exceed 100 mb.") }
var CVideoSendConfirmation: String{ return CLocalize(text: appDelegate.langugaeText?.are_you_sure_want_to_send_video ?? "Are you sure you want to send this video?") }
var CAudioSendConfirmation: String{ return CLocalize(text: appDelegate.langugaeText?.are_you_sure_you_want_send_audio ?? "Are you sure you want to send this Audio?") }
var CMessagePostAds: String{ return appDelegate.langugaeText?.this_feature_is_not_available_go_to_website ?? "This feature is not available for mobile App, please use website to post ads" }
var CMessageGroupMinParticipants: String{ return CLocalize(text: appDelegate.langugaeText?.please_select_2_member ?? "Please select at least 2 member.") }
var CMessageSelectLanguage: String{ return CLocalize(text: appDelegate.langugaeText?.please_select_language ?? "Please select a language.") }
var CMessageSentInvitation: String{ return CLocalize(text: appDelegate.langugaeText?.invitation_has_been_sent ?? "Invitation has been sent.") }
var CMessageCommentBlank: String{ return CLocalize(text: appDelegate.langugaeText?.please_enter_comment_text ?? "Please enter comment text.") }
var CMessageSelectImage: String{ return CLocalize(text: appDelegate.langugaeText?.please_select_atleast_one_image ?? "Please select at least one image.") }
var CMessageReportContent: String{ return CLocalize(text: appDelegate.langugaeText?.please_enter_report_message ?? "Please enter report message.") }
var CMessageReportReason: String{ return CLocalize(text: appDelegate.langugaeText?.please_select_report_reason ?? "Please select report reason.") }

var CMessageChatGroupImage: String{ return appDelegate.langugaeText?.group_image_required ?? "Please add group image" }
var CMessageChatGroupTitle: String{ return appDelegate.langugaeText?.group_title_cant_blank ?? "Please enter group name" }
var CMessageChatGroupType: String{ return appDelegate.langugaeText?.group_type_cant_blank ?? "Please select group type" }
var CMessageChatGroupMemebers: String{ return appDelegate.langugaeText?.group_member_not_selected ?? "Please select group members" }
var CMessageChatGroupMinMemebers: String{ return appDelegate.langugaeText?.group_members_minimum ?? "Please add at least 2 group members" }

var CPostedOn: String{ return appDelegate.langugaeText?.posted_on ?? "Posted on:" }
var CMessageGroupExit: String{ return appDelegate.langugaeText?.alert_exit_message ?? "Are you sure you want to exit from this group?" }
var CMessageDeleteEvent: String{ return appDelegate.langugaeText?.alert_delete_message ?? "Are you sure you want to delete this group?" }
var CMessageSorryYourDeviceIsNotSupportMail: String{ return appDelegate.langugaeText?.sorry_your_device_is_not_support_mail ?? "Sorry, your device is not support mail" }
var CMessageLinkCopied: String{ return appDelegate.langugaeText?.link_copied ?? "Link copied" }
var CMessageNoBlockedUser: String{ return appDelegate.langugaeText?.no_blocked_users_yet ?? "No blocked users yet" }

var CMessageGroupTypeChangeAlertToPrivate: String{ return appDelegate.langugaeText?.group_type_change_alert_to_private ?? "Are you sure you want to update the public of this group to the private?" }
var CMessagegroupTypeChangeAlertToPrivateMessage: String{ return appDelegate.langugaeText?.group_type_change_alert_to_private_message ?? "Making it private will need the Admin to verify each new request to join this group" }
var CMessageGroupTypeChangeAlertToPublic: String{ return appDelegate.langugaeText?.group_type_change_alert_to_public ?? "Are you sure you want to update the private of this group to the public?" }
var CMessageGroupTypeChangeAlertToPublicMessage: String{ return appDelegate.langugaeText?.group_type_change_alert_to_public_message ?? "Making it public will automatically accept all the pending requests to join this group" }
var CStartDate: String{ return (appDelegate.langugaeText?.start_date ?? "Start Date") + ":" }
var CEndDate: String{ return (appDelegate.langugaeText?.end_date ?? "End Date") + ":" }
var CMessageNoLikesFound: String{ return appDelegate.langugaeText?.no_likes_found ?? "No likes yet" }
var CMessageNoDataFound: String{ return appDelegate.langugaeText?.no_data_found ?? "No data found" }
var CProvidedBy: String{ return (appDelegate.langugaeText?.provided_by ?? "Provided by") + ":" }
var CDeleteMessageByAdmin: String{ return "∅ \(appDelegate.langugaeText?.admin_deleted_this_message ?? "This message is deleted by Admin")"}
var CDeleteMessageForReciever: String{ return "∅ This message was deleted"}
var CDeleteMessageBySender: String{ return "∅ You deleted this message"}
var CDeleteMessageByUser: String{ return "∅ \(appDelegate.langugaeText?.user_deleted_this_message ?? "Message deleted.")"}
var CMessageReportInappropriateBehavior: String{ return appDelegate.langugaeText?.inappropriate_behavior ?? "Inappropriate Behaviour" }
var CMessageReportAbusiveLanguage: String{ return appDelegate.langugaeText?.abusive_language ?? "Abusive Language" }
var CMessageReportLookLikeSpamUser: String{ return appDelegate.langugaeText?.look_like_spam_user ?? "Looks like spam" }
var CMessageReportOthers: String{ return appDelegate.langugaeText?.others ?? "Others" }
//var CMessageNoPost: String{ return appDelegate.langugaeText?.no_posts_found ?? "No posts found" }
var CMessageReportConfirmation: String{ return appDelegate.langugaeText?.report_confirmation ?? "Are you sure you want to report this user?" }
var CMessageMediaNotExist: String{ return "Media does not exist." }
var CMessageAccountPrivacyMsg: String{ return appDelegate.langugaeText?.account_privacy_msg ?? "This account has privacy configured for the limited details." }
var CMessageLoginUserBlock: String{ return "You blocked this user." }
var CMessageOtherUserBlock: String{ return CLocalize(text: appDelegate.langugaeText?.you_blocked_this_user ?? "You blocked by this user.")}
var CMessageNoLongerFriend: String{ return "You are no longer friend togther." }
var CMessageReportGroup: String{ return appDelegate.langugaeText?.report_group_alert_message ?? "By reporting this group, you will be exited from this group." }
var CMessageGroupDeleted: String{ return "This group has been delete by admin." }
var CMessageGroupNoLongerAvailable: String{ return "You are no longer participant in this group." }
var CToday: String{ return appDelegate.langugaeText?.today ?? "Today" }
var CYesterday: String{ return appDelegate.langugaeText?.yesterday ?? "Yesterday" }
var CVideoNotSupported: String{ return CLocalize(text: appDelegate.langugaeText?.video_formate_not_supported ?? "Video formate is not supported.") }
var CSharePostContentMsg : String{ return CLocalize(text: appDelegate.langugaeText?.check_this_in_post ?? "Check out this post on Sevenchat")}
var CShareWebsiteContentMsg : String{ return CLocalize(text: appDelegate.langugaeText?.check_this_in_web_site ?? "Check out this website on Sevenchat")}
var CShareProfileContentMsg : String{ return CLocalize(text: appDelegate.langugaeText?.check_this_in_user ?? "Check out this user on Sevenchat")}
var CJoinPrivateGroupMsg : String{ return CLocalize(text: appDelegate.langugaeText?.your_request_to_join_group_has_been_sent_to_admin ?? "Your request to join the group has been sent to the admin.")}
var CNoDataFoundForNewMsg : String{ return appDelegate.langugaeText?.no_news_for_this_category ?? "No news for this category."}

var CIAPBySuccess : String{ return CLocalize(text: appDelegate.langugaeText?.purchased_success ?? "Purchased successfully.")}
var CIAPRestoreSuccess : String{ return CLocalize(text: appDelegate.langugaeText?.restored_success ?? "Restored successfully.")}
var CIAPError : String{ return CLocalize(text: appDelegate.langugaeText?.payment_error ?? "Payment error. Try again.")}

//NEW CODE
var CAutodelete_change: String{ return appDelegate.langugaeText?.turn_on_confidentail_mode ?? "turn on confidentail mode" }

var CCreateshout : String{return CLocalize(text: appDelegate.langugaeText?.create_shout ?? "Create Shout")}
// MARK: - Phase 2

var CAddPoll : String{return CLocalize(text: appDelegate.langugaeText?.add_poll ?? "Add Poll")}
var CSelectCategoryOfPoll : String{return CLocalize(text: appDelegate.langugaeText?.select_category_of_poll ?? "Select Category of Poll")}
var CAddQuestion : String{return CLocalize(text: appDelegate.langugaeText?.add_question ?? "Add Question")}

var CUploadMedia : String{return CLocalize(text: appDelegate.langugaeText?.upload_media ?? "Upload Media")}
var CMax5MediaAllowedOf50MB : String{return CLocalize(text: appDelegate.langugaeText?.media_max_upload_size ?? "Max 5 media allowed of 50 MB each")}
var CTypePoll: String{ return CLocalize(text: appDelegate.langugaeText?.poll ?? "Poll") }
var CFileTitle: String{ return CLocalize(text: appDelegate.langugaeText?.files ?? "Files") }
var CNavCreateFolder: String{ return CLocalize(text: appDelegate.langugaeText?.create_folder ?? "Create Folder") }

var CNoInternet: String{ return CLocalize(text: appDelegate.langugaeText?.no_internet ?? "No Internet!")}

var CPleaseCheckYourIntenet: String{ return CLocalize(text: appDelegate.langugaeText?.please_check_internet_connection ?? "Please check your internet Connection.")}
var CTryAgain: String{ return CLocalize(text: appDelegate.langugaeText?.try_again ?? "Try Again")}
var CNavFiles: String{ return CLocalize(text: appDelegate.langugaeText?.files ?? "Files") }
var CNavSharedList: String{ return CLocalize(text: appDelegate.langugaeText?.shared_list ?? "Shared List") }
var CTitleSharedFiles: String{ return CLocalize(text: appDelegate.langugaeText?.shared_files ?? "Shared Files") }
var CPollUsersList: String{ return CLocalize(text: appDelegate.langugaeText?.poll_user_list ?? "Poll Users List")}
var CAddMedia : String{return CLocalize(text: appDelegate.langugaeText?.add_media ?? "Add Gallery")}
var CGroups : String{return CLocalize(text: appDelegate.langugaeText?.sidemenu_groups ?? "Groups")}
var CCFriends : String{return CLocalize(text: appDelegate.langugaeText?.friends ?? "Friends")}

var CMaybe : String{ return CLocalize(text: appDelegate.langugaeText?.may_be ?? "May Be")}
var CConfirmed : String{ return CLocalize(text: appDelegate.langugaeText?.confirmed ?? "Confirmed")}
var CDeclined : String{ return CLocalize(text: appDelegate.langugaeText?.declined ?? "Declined")}

var CLike: String{ return CLocalize(text: appDelegate.langugaeText?.like ?? "Like") }
var CGallery: String{ return CLocalize(text: appDelegate.langugaeText?.gallery ?? "Gallery") }
var CtitleMyFiles: String{ return CLocalize(text: appDelegate.langugaeText?.my_files ?? "My Files") }
var CReport : String{return CLocalize(text: appDelegate.langugaeText?.report ?? "Report")}
var COption: String{ return CLocalize(text: appDelegate.langugaeText?.option
    ?? "Option") }
var CFoldersHasBeenSharedWithYou: String{ return CLocalize(text: appDelegate.langugaeText?.no_folders_has_been_shared_with_you ?? "No folders has been shared with you") }
var CSearch: String{ return CLocalize(text: appDelegate.langugaeText?.search ?? "Search") }
var CMessageGalleryCategory: String{ return CLocalize(text: appDelegate.langugaeText?.gallery_category_cant_blank ?? "Please select gallery category") }
var CMessageSelectContactGroupPoll: String{ return CLocalize(text: appDelegate.langugaeText?.please_select_to_whom_to_share ?? "Please select to whom you want to post this poll.") }
var CMessagePollQuestion: String{ return CLocalize(text: appDelegate.langugaeText?.please_enter_question ?? "Please enter question.") }
var CCreateFolderAlertBlank: String{ return appDelegate.langugaeText?.folder_name_cant_be_blank ?? "Please enter folder name" }
var CNavUpgradeStorage: String{ return CLocalize(text: appDelegate.langugaeText?.upgrade_storage ?? "Upgrade Storage") }
var CBtnUpgradeNow: String{ return CLocalize(text: appDelegate.langugaeText?.upgrade_now ?? "Upgrade Now") }
var CContacts : String{return CLocalize(text: appDelegate.langugaeText?.contacts ?? "Contacts")}
var CNoFileAdded: String{ return CLocalize(text: appDelegate.langugaeText?.no_files_added_in_this_folder ?? "No file is added in this folder.") }
var CPollDetails: String{ return CLocalize(text: appDelegate.langugaeText?.poll_detail ?? "Poll details") }
var CVotes : String{ return CLocalize(text: appDelegate.langugaeText?.votes ?? "Votes")}
var CVote : String{ return CLocalize(text: appDelegate.langugaeText?.vote ?? "Vote")}
var CNavInvitees: String{ return CLocalize(text: appDelegate.langugaeText?.invitees ?? "Invitees") }
var CNavTermsAndConditions: String{ return CLocalize(text: appDelegate.langugaeText?.terms_and_conditions ?? "Terms and Conditions") }
var CMessageDeleteFile: String{ return CLocalize(text: appDelegate.langugaeText?.confirmation_to_delete_file ?? "Are you sure you want to delete this file?") }
var CPollOptionAlreadyExist: String{ return CLocalize(text: appDelegate.langugaeText?.poll_option_already_exist ?? "Please add another option. This option is already added.") }
var CFileTypeNotAllowedtoUpload: String{ return CLocalize(text: appDelegate.langugaeText?.file_type_not_allowed ?? "File type not allowed to upload")}
var CThereIsSomeIssueInUploadingFiles: String{ return CLocalize(text: appDelegate.langugaeText?.there_is_some_issue_in_uploading_files ?? "There was some issue uploading the files.")}
var CThereIsSomeIssueInUploadingFile: String{ return CLocalize(text: appDelegate.langugaeText?.there_is_some_issue_in_uploading_file ?? "There was some issue while uploading file")}
var CAlertMessageForFilesNotUploaded: String{ return CLocalize(text: appDelegate.langugaeText?.alert_message_for_files_not_uploaded ?? "Few files are not uploaded. Are you sure you want to go out of the screen?")}
var CMessageForWrongFileType: String{ return CLocalize(text: appDelegate.langugaeText?.message_for_wrong_file_type ?? "Cannot upload the file. The format is not supported.")}
var CDoYouWantToShareThisFolderWithFriends: String{ return CLocalize(text: appDelegate.langugaeText?.do_you_want_to_share_this_folder_with_friends ?? "Do you want to share this folder with your friends?")}
var CRenameFolder: String{ return CLocalize(text: appDelegate.langugaeText?.rename_folder ?? "Rename Folder")}
var CNoFriendsYet: String{ return CLocalize(text: appDelegate.langugaeText?.no_friends_yet ?? "No friends yet.")}
var CFoldersCreated: String{ return CLocalize(text: appDelegate.langugaeText?.no_folder_created ?? "No folders created") }
var CAreYouSureToStopShareFolder: String{ return CLocalize(text: appDelegate.langugaeText?.are_you_sure_to_share_folder ?? "Are you sure, you want want to stop sharing this folder with this user?") }
var CPleaseSelectAtLeastOneOmageVideo: String{ return CLocalize(text: appDelegate.langugaeText?.please_select_atleast_one_image_video ?? "Please select at least one image/Video.") }
var CAreYouSureToDeleteThisMedia: String{ return CLocalize(text: appDelegate.langugaeText?.are_you_sure_to_delete_this_media ?? "Are you sure you want to delete this media?") }
var CNavPayment: String{ return CLocalize(text: appDelegate.langugaeText?.payment ?? "Payment") }
var CMessagePollAddOption: String{ return CLocalize(text: appDelegate.langugaeText?.minimum_polls_options ?? "Please add minimum 2 options or maximum 4 options.") }
var CNoSharedUser: String{ return CLocalize(text: appDelegate.langugaeText?.you_havent_shared_any_folders_with_your_friends ?? "You have not shared any files with your friends.") }
var CUnsupportedFileType: String{ return CLocalize(text: appDelegate.langugaeText?.un_supported_file_type ?? "Unsupported file type.")}
var CStoregFullMessage: String{ return CLocalize(text: appDelegate.langugaeText?.your_storage_is_full_need_to_upgrade_storage ?? "Your storage is full. Please upgrade your storage to upload more files.")}
var CNavReportPoll: String{ return CLocalize(text: appDelegate.langugaeText?.report_poll ?? "Report poll")}
var CEditMedia: String{ return CLocalize(text: appDelegate.langugaeText?.edit_media ?? "Edit Media")}
var CBtnRemove: String{ return CLocalize(text: appDelegate.langugaeText?.remove ?? "Remove") }
var COutOf: String{ return CLocalize(text: appDelegate.langugaeText?.out_of ?? "out of") }
var CUploading: String{ return CLocalize(text: appDelegate.langugaeText?.uploading ?? "uploading") }
var CExportingFile: String{ return CLocalize(text: appDelegate.langugaeText?.exporting_file ?? "Exporting file") }
var CDownloadFromiCloud: String{ return CLocalize(text: appDelegate.langugaeText?.downloading_from_icloud ?? "downloading from iCloud") }
var CMessageMinSelection: String{ return CLocalize(text: appDelegate.langugaeText?.please_select_atleast_one_friend ?? "Please select at least one friend")}
var CYear : String{ return CLocalize(text: appDelegate.langugaeText?.year ?? "Year") }
var CMonth : String{ return CLocalize(text: appDelegate.langugaeText?.month ?? "Month") }
var CUsing : String{ return CLocalize(text: appDelegate.langugaeText?.using ?? "Using") }
var COf : String{ return CLocalize(text: appDelegate.langugaeText?.of ?? "of") }
var CBtnContinue : String{ return CLocalize(text: appDelegate.langugaeText?.continue_text ?? "Continue") }
var CInviteOthers : String{ return CLocalize(text: appDelegate.langugaeText?.invite_others ?? "Invite Others") }
var CSearchFriends : String{ return CLocalize(text: appDelegate.langugaeText?.search_friends ?? "Search friends") }
var CMessagePollPostUpload : String{ return CLocalize(text: appDelegate.langugaeText?.polls_created_successfully ?? "Poll posted Successfully") }
var CEnterFolderName : String{ return CLocalize(text: appDelegate.langugaeText?.enter_folder_name ?? "Enter Folder Name") }
var CAddFiles : String{ return CLocalize(text: appDelegate.langugaeText?.add_files ?? "Add Files") }
var CMessageDeleteFolder: String{ return CLocalize(text: appDelegate.langugaeText?.confirmation_to_delete_folder ?? "Are you sure you want to delete this folder?") }
var CNoFileYet: String{ return CLocalize(text: appDelegate.langugaeText?.no_files_yet ?? "No files yet") }
var CSelectCategoryOfGallery: String{ return CLocalize(text: appDelegate.langugaeText?.select_category_of_gallery ?? "Select category of Gallery") }
var CGalleryHasBeenPosted: String{ return CLocalize(text: appDelegate.langugaeText?.gallery_created_successfully ?? "Gallery added Successfully") }
var CRestrictedFile: String{ return CLocalize(text: appDelegate.langugaeText?.restricted_file ?? "Restricted File") }

var CNoQuotesYet: String{ return CLocalize(text: appDelegate.langugaeText?.no_quotes_yet ?? "No quotes yet") }
var CNoNotificationsYet: String{ return CLocalize(text: appDelegate.langugaeText?.no_notifications_yet ?? "No notifications yet.") }
var CNoFavWebList: String{ return CLocalize(text: appDelegate.langugaeText?.no_fav_web_list ?? "You havent added any new Favourite web sites.") }
var CAreYouSureToReportThisPost: String{ return CLocalize(text: appDelegate.langugaeText?.are_you_sure_to_report_this_post ?? "Are you sure you want to report this post?") }

var CNoPendingRequestYet: String{ return CLocalize(text: appDelegate.langugaeText?.no_pending_request ?? "No pending request yet") }
var CNoRequestDataSent: String{ return CLocalize(text: appDelegate.langugaeText?.no_request_send_data ?? "No request data sent") }
var CNoFriendsFound: String{ return CLocalize(text: appDelegate.langugaeText?.no_friends_found ?? "No friends found") }
var CMore: String{ return CLocalize(text: appDelegate.langugaeText?.more ?? "More") }

var CReportFavWebSite: String{ return CLocalize(text: appDelegate.langugaeText?.are_you_sure_to_report_this_fav_web ?? "Are you sure you want to report your favourite website?") }

var CPreparingToExpo: String{ return CLocalize(text: appDelegate.langugaeText?.preparing_to_export ?? "Preparing to export") }

var CDownloading: String{
    return CLocalize(text: appDelegate.langugaeText?.downloading ?? "Downloading")
}

var CFileIsAlreadyExistsInThisFolder: String{
    return CLocalize(text: appDelegate.langugaeText?.file_already_exist_in_folder ?? "File with same name already exists in this folder.")
}

var CMessageText: String{
    return CLocalize(text: appDelegate.langugaeText?.message ?? "Message")
}

var CYouCannotSeeHisHerProfile: String{
    return CLocalize(text: appDelegate.langugaeText?.you_cant_see_profile ?? "You can not see his/her profile.")
}

var CMinumumAgeLimitBetween13To100: String{
    return CLocalize(text: appDelegate.langugaeText?.validation_for_age_in_post ?? "Please enter minimum age limit between 13 to 100 years.")
}

var CMessageDelete: String{
    return CLocalize(text: "Are you sure you want to delete?")
}
var CFolderHasBeenSharedSuccessfully: String{
    return CLocalize(text: "Folder has been shared successfully")
}

//MARK: - Add/Edit Product
var CAddProductDetails: String{
    return CLocalize(text: appDelegate.langugaeText?.add_product_details ?? "Add Product Details")
}
var CEditProductDetails: String{
    return CLocalize(text: appDelegate.langugaeText?.edit_product_details ?? "Edit Product Details")
}
var CStore: String{
    return CLocalize(text: appDelegate.langugaeText?.store ?? "Store")
}
var CStores: String{
    return CLocalize(text: appDelegate.langugaeText?.stores ?? "Stores")
}

var CMax5MediaAllowedOf50MBEach: String{
    return CLocalize(text: appDelegate.langugaeText?.media_max_upload_size ?? "Max 5 media allowed of 50 MB each")
}
var CAboutProduct: String{
    return CLocalize(text: appDelegate.langugaeText?.about_product ?? "About Product")
}
var CSelectProductCategory: String{
    return CLocalize(text: appDelegate.langugaeText?.select_category ?? "Select Category")
}

var CSelectsubProductCategory: String{
  
    
    return CLocalize(text: appDelegate.langugaeText?.select_sub_category ?? "Select Sub category")
}
var CProductTitle: String{
    return CLocalize(text: appDelegate.langugaeText?.product_title ?? "Product Title")
}
var CProductDescription: String{
    return CLocalize(text: appDelegate.langugaeText?.product_description ?? "Product Description")
}
var CProductPrice: String{
    return CLocalize(text: appDelegate.langugaeText?.product_price ?? "Product Price")
}
var CLastDateOfProductSelling: String{
    return CLocalize(text: appDelegate.langugaeText?.last_date_of_product_selling ?? "Last Date of Product Selling")
}
var CSelectLocation: String{
    return CLocalize(text: appDelegate.langugaeText?.register_select_location ?? "Select Location")
}
var CPaymentMode: String{
    return CLocalize(text: appDelegate.langugaeText?.payment_mode ?? "Payment Mode")
}
var COfflinePayment: String{
    return CLocalize(text: appDelegate.langugaeText?.offline_payment ?? "Offline Payment")
}
var COnlinePayment: String{
    return CLocalize(text: appDelegate.langugaeText?.online_payment ?? "Online Payment")
}
var CLinkToPayment: String{
    return CLocalize(text: appDelegate.langugaeText?.link_to_payment ?? "Link to Payment")
}
var CProductTermsAndCondition: String{
    return CLocalize(text: appDelegate.langugaeText?.accept_all_tems_and_conditions ?? "I accept all the terms and conditions including the privacy policies")
}

var CWriteYourMessageHereOptional: String{
    return CLocalize(text: appDelegate.langugaeText?.write_your_message_here_optional ?? "Write your message here (Optional)")
}
var CShareWithinSevenChats: String{
    return CLocalize(text: appDelegate.langugaeText?.share_within_seven_chats ?? "Share within Sevenchats")
}
var CExternalShare: String{
    return CLocalize(text:  "External Share")
}

var CAddAtLeastOneProductVideoOrImage: String{
    return CLocalize(text: appDelegate.langugaeText?.please_add_atleast_one_product ?? "Please add at least one product video or image.")
}
var CMaximumStorageOfProductVideoExceeds: String{
    return CLocalize(text: appDelegate.langugaeText?.video_size_is_large ?? "Video Size exceeds by 50 MB. Please upload video less than 50 MB.")
}
var CSelectCategoryOfProduct: String{
    return CLocalize(text: appDelegate.langugaeText?.please_select_any_one_category ?? "Please select any one category of product.")
}
var CBlankProductTitle: String{
    return CLocalize(text: appDelegate.langugaeText?.please_enter_product_title ?? "Please enter Product title.")
}
var CBlankProductDescription: String{
    return CLocalize(text: appDelegate.langugaeText?.please_enter_product_description ?? "Please enter some product description.")
}
var CBlankProductPrice: String{
    return CLocalize(text: appDelegate.langugaeText?.please_enter_product_price ?? "Please enter product price.")
}
var CBlankProductCurrencyPrice: String{
    return CLocalize(text: "Please select currency.")
}
var CBlankLastDateOfProductSelling: String{
    return CLocalize(text: appDelegate.langugaeText?.please_enter_last_date_selling_product ?? "Please enter last date of selling product.")
}
var CBlankProductLocation: String{
    return CLocalize(text: appDelegate.langugaeText?.please_enter_any_location ?? "Please enter any location.")
}
var CProductNoCheckedAcceptTermsAndConditions: String{
    return CLocalize(text: appDelegate.langugaeText?.please_accept_terms_conditions ?? "Please accept the terms and conditions.")
}

//MARK: - Product Detail
var CSold: String{
    return CLocalize(text: appDelegate.langugaeText?.sold ?? "Sold")
}

//MARK: - Rate and Review

var CRateAndReviewTitle: String{
    return CLocalize(text: appDelegate.langugaeText?.rate_and_review_product ?? "Rate and Review Product")
}
var CYourRating: String{
    return CLocalize(text: appDelegate.langugaeText?.your_rating ?? "Your Rating")
}
var CPlaceholderAddYourReview: String{
    return CLocalize(text: appDelegate.langugaeText?.add_your_review ?? "Add your reviews")
}
var CBlankReviewText: String{
    return CLocalize(text: appDelegate.langugaeText?.please_enter_some_review ?? "Please enter some review to help other buyers about the product.")
}

//MARK: - Product Detail
var CProductReport: String{
    return CLocalize(text: appDelegate.langugaeText?.your_request_is_on_the_way_We_will_investigate_and_take_an_action_soon ?? "CReportProduct")
}
var CProductAlreadyReport: String{
    return CLocalize(text: appDelegate.langugaeText?.product_already_reported ?? "CReportProduct")
}
var CPaymentPreference: String{
    return CLocalize(text: appDelegate.langugaeText?.payment_preference ?? "Payment Preferences")
}
var CPaymentDescription: String{
    return CLocalize(text: appDelegate.langugaeText?.payment_description ?? "Description")
}
var CSellerInformation: String{
    return CLocalize(text: appDelegate.langugaeText?.seller_information ?? "Seller Information")
}
var CContactSeller: String{
    return CLocalize(text: appDelegate.langugaeText?.contact_seller ?? "Contact Seller")
}
var CBuyNow: String{
    return CLocalize(text: appDelegate.langugaeText?.buy_now ?? "Buy Now")
}
var CAvailable: String{
    return CLocalize(text: appDelegate.langugaeText?.available ?? "Available")
}

var CAddExpeToHelpOtherBuyers: String{
    return CLocalize(text: appDelegate.langugaeText?.add_your_experience_to_help_other ?? "Add your experience to help other buyers")
}
var CReview: String{
    return CLocalize(text: appDelegate.langugaeText?.reviews ?? "Reviews")
}
var CAddReview: String{
    return CLocalize(text: appDelegate.langugaeText?.add_your_review ?? "Add your reviews")
}
var CMarkAsSold: String{
    return CLocalize(text: appDelegate.langugaeText?.mark_as_sold ?? "Mark as Sold")
}

//MARK: - Store List

var CAllProducts: String{
    return CLocalize(text: appDelegate.langugaeText?.all_products ?? "All Products")
}
var CMyProducts: String{
    return CLocalize(text: appDelegate.langugaeText?.my_products ?? "My Products")
}
var CNoProductAddedInMyProductList: String{
    return CLocalize(text: appDelegate.langugaeText?.no_product_added ?? "No products added. Click on ⊕ to add any new product.")
}
var CNoProductList: String{
        return CLocalize(text: appDelegate.langugaeText?.products_sold ?? "The product have been Sold")
}
var CURLNotFound: String{
    return CLocalize(text: appDelegate.langugaeText?.url_not_found ?? "URL not found.")
}

//MARK: - Store Search List
var CSearchSellerPlaceholder: String{
    return CLocalize(text: appDelegate.langugaeText?.search_buy_seller_and_product_name ?? "Search by product title")
}

//MARK: - Product Report
var CWhyAreYouReporing: String{
    return CLocalize(text: appDelegate.langugaeText?.why_are_you_reporting_this_product ?? "Why are you reporting this product?")
}
var CIThinksItSpam: String{
    return CLocalize(text: appDelegate.langugaeText?.think_it_is_scam ?? "I think its a scam")
}
var CItADuplicateList: String{
    return CLocalize(text: appDelegate.langugaeText?.it_is_a_duplicate_list ?? "Its a duplicate listing")
}
var CItsInWrongCat: String{
    return CLocalize(text: appDelegate.langugaeText?.it_is_wrong_category ?? "It's in a wrong  category")
}
var COtherText: String{
    return CLocalize(text: appDelegate.langugaeText?.other ?? "Other")
}
var CWriteAboutYourProblem: String{
    return CLocalize(text: appDelegate.langugaeText?.write_about_your_problem ?? "Write about your problem.")
}
var CBlankProductReportText: String{
    return CLocalize(text: appDelegate.langugaeText?.please_enter_your_problem ?? "Please elaborate your problem to help other buyers about the product.")
}

//MARK: - Contact Seller
var CYourInfo: String{
    return CLocalize(text: appDelegate.langugaeText?.your_information ?? "Your Information")
}
var CBlankContactSellerMessage: String{
    return CLocalize(text: appDelegate.langugaeText?.please_enter_some_message ?? "Please enter some message to contact the seller.")
}
//MARK: - Sort By Product
var CSortBy: String{
    return CLocalize(text: appDelegate.langugaeText?.sort_by ?? "Sort By")
}
var CNewToOld: String{
    return CLocalize(text: appDelegate.langugaeText?.sort_new_to_old ?? "New To Old")
}
var COldToNew: String{
    return CLocalize(text: appDelegate.langugaeText?.old_to_new ?? "Old To New")
}

//MARK: - Chat Detail
var CShareCurrentLocation: String{
    return CLocalize(text: appDelegate.langugaeText?.share_current_location ?? "Share Current Location")
}
var CFriendsExists: String{
    return CLocalize(text: appDelegate.langugaeText?.chat_friend_already_exists ?? "Chat Friend Already Exists")
}


var CTermsAndConditionsText: String{
    return CLocalize(text: appDelegate.langugaeText?.product_terms_conditions ?? "By Signing Up, you agree to our Terms & Conditions, and that you have read our Privacy Policy.")
}
var CProductTermsAndConditionsText: String{
    return CLocalize(text: appDelegate.langugaeText?.by_posting_this_product ?? "By posting this product, you agree to our Terms & Conditions, and that you have read our Privacy Policy.")
}


var CCountryPlaceholder: String{
    return CLocalize(text: appDelegate.langugaeText?.country ?? "Country")
}
var CStatePlaceholder: String{
    return CLocalize(text: appDelegate.langugaeText?.state ?? "State")
}
var CCityPlaceholder: String{
    return CLocalize(text: appDelegate.langugaeText?.city ?? "City")
}

var CBlankCountry: String{
    return CLocalize(text: appDelegate.langugaeText?.please_select_country ?? "Please select country")
}
var CBlankState: String{
    return CLocalize(text: appDelegate.langugaeText?.please_select_state ?? "Please select state")
}
var CBlankCity: String{
    return CLocalize(text: appDelegate.langugaeText?.please_select_city ?? "Please select city")
}

var CSharedArticle: String{
    return CLocalize(text: appDelegate.langugaeText?.shared_article ?? "shared article")
}
var CSharedGallery: String{
    return CLocalize(text: appDelegate.langugaeText?.shared_gallery ?? "shared gallery")
}
var CSharedShout: String{
    return CLocalize(text: appDelegate.langugaeText?.shared_shout ?? "shared shout")
}
var CSharedPoll: String{
    return CLocalize(text: appDelegate.langugaeText?.shared_polls ?? "shared poll")
}
var CSharedEvents: String{
    return CLocalize(text: appDelegate.langugaeText?.shared_event ?? "shared events")
}
var CSharedForum: String{
    return CLocalize(text: appDelegate.langugaeText?.shared_forum ?? "shared forum")
}
var CSharedChirpy: String{
    return CLocalize(text: appDelegate.langugaeText?.shared_chirpy ?? "shared chirpy")
}
var CReportSharePost: String{
    return CLocalize(text: appDelegate.langugaeText?.report_shared_post ?? "Report shared post")
}
var CPostHasBeenShared: String{
    return CLocalize(text: appDelegate.langugaeText?.shared_post_created_successfully ?? "Shared post has been added successfully")
}
var CSharedPostHasBeenUpdated: String{
    return CLocalize(text: appDelegate.langugaeText?.shared_post_edited_successfully ?? "Shared post has been edited successfully.")
}
var CContentIsNotAvailable: String{
    return CLocalize(text: appDelegate.langugaeText?.this_content_is_not_available ?? "This content isn't available right now")
}
var CContentIsNotAvailableDescription: String{
    return CLocalize(text: appDelegate.langugaeText?.this_content_is_not_available_text ?? "When this happens, it's usually because the owner only shared it with a small group of people, changed who can see it or it's been deleted.")
}
var CProductHasBeenCreated: String{
    return CLocalize(text: appDelegate.langugaeText?.product_created_success ?? "Product added successfully")
}
var CProductHasBeenUpdate: String{
    return CLocalize(text: appDelegate.langugaeText?.product_updated_success ?? "Product has been updated")
}
var CMessageDeleteProduct: String{
    return appDelegate.langugaeText?.are_you_sure_you_want_to_delete_product ?? "Are you sure you want to delete this product?"
}

var CShareProductText: String{
    return CLocalize(text: appDelegate.langugaeText?.check_out_this_store_post ?? "Check out this store post on social media app:")
}
var COnlinePaymentMode: String{
    return CLocalize(text: appDelegate.langugaeText?.online_payment_mode ?? "Online Payment Mode")
}
var COfflinePaymentMode: String{
    return CLocalize(text: appDelegate.langugaeText?.offline_payment_mode ?? "Offline Payment Mode")
}
var CNoCategoryFound: String{
    return CLocalize(text: appDelegate.langugaeText?.no_category_found ?? "No Category found")
}
var CReportProductTitle: String{
    return CLocalize(text: appDelegate.langugaeText?.report_product ?? "Report Product")
}



var CContactToSellerSuccessfully: String{
    return CLocalize(text: appDelegate.langugaeText?.your_message_has_been_sent_to_seller ?? "Your message has been sent to the seller successfully.")
}
var CNoProductFound: String{
    
    return CLocalize(text: appDelegate.langugaeText?.no_products_found ?? "No products found")
}


var COpenInMaps: String{
    return CLocalize(text: appDelegate.langugaeText?.open_in_maps ?? "Open In Maps")
}
var COpenInGoogleMaps: String{
    return CLocalize(text: appDelegate.langugaeText?.open_in_google_maps ?? "Open In Google Maps")
}

var CAreYouSureYouWantToShareThisLocation: String{
    return CLocalize(text: appDelegate.langugaeText?.are_you_sure_you_want_to_share_location ?? "Are you sure you want to share this location?")
}
var CVideoCall: String{
    return CLocalize(text: appDelegate.langugaeText?.video_call ?? "Video Call")
}
var CAudioCall: String{
    return CLocalize(text: appDelegate.langugaeText?.audio_call ?? "Audio Call")
}
var CDecline: String{
    return CLocalize(text: appDelegate.langugaeText?.decline ?? "Decline")
}

var CLocationServicesDisabled: String{
    return CLocalize(text: appDelegate.langugaeText?.location_services_disabled ?? "Location Services disabled")
}
var CPleaseEnableLocationServices: String{
    return CLocalize(text: appDelegate.langugaeText?.please_enable_location_service_in_settings ?? "Please enable Location Services in Settings")
}
var CVisiblity: String{
    return CLocalize(text: appDelegate.langugaeText?.visibility ?? "Visibility")
}

var CParticipants: String{
    return CLocalize(text: appDelegate.langugaeText?.participants ?? "Participants")
}

var CPostPostsInvitePublic: String{ return appDelegate.langugaeText?.public_visibility ?? "Public" }

var CVoiceQuickStart: String{
    return CLocalize(text: appDelegate.langugaeText?.voice_quick_start ?? "Voice Quick Start")
}
var CMicrophonePermissionNotGranted: String{
    return CLocalize(text: appDelegate.langugaeText?.microphone_permission_not_granted ?? "Microphone permission not granted")
}
var CContinueWithoutMicrophone: String{
    return CLocalize(text: appDelegate.langugaeText?.continue_without_microphone ?? "Continue without microphone")
}
var CConnecting: String{
    return CLocalize(text: appDelegate.langugaeText?.connecting ?? "Connecting...")
}
var CStartCalling: String{
    return CLocalize(text: appDelegate.langugaeText?.start_calling ?? "Start calling...")
}
var CRinging: String{
    return CLocalize(text: appDelegate.langugaeText?.ringing_ ?? "Ringing...")
}
var CConnectedWith : String{
    return CLocalize(text: appDelegate.langugaeText?.connected_with ?? "Connected with")
}

var CCallFrom: String{
    return CLocalize(text: appDelegate.langugaeText?.call_from ?? "Call From")
}
var CGroupCallFrom: String{
    return CLocalize(text: appDelegate.langugaeText?.group_call_from ?? "Group Call From")
}
var CVideoCallFrom: String{
    return CLocalize(text: appDelegate.langugaeText?.video_call_from ?? "Video call from")
}
var CIn: String{
    return CLocalize(text: appDelegate.langugaeText?.str_in ?? "in")
}

var CCallingTo: String{
    return CLocalize(text: appDelegate.langugaeText?.calling ?? "Calling to")
}

var CMaximum50ParticipantsSelect: String{
    return CLocalize(text: appDelegate.langugaeText?.max_50_participants ?? "Maximum 50 participants allowed in a group call.")
}

var CConnectingTo: String{
    return CLocalize(text: appDelegate.langugaeText?.connecting_to ?? "connecting to")
}

var CAppNotAvailableAtYourLocation: String{
    return CLocalize(text: appDelegate.langugaeText?.we_are_not_functional_your_location ?? "We are not functional at your location quite yet. We are expanding soon and we will let you know when Sevenchats arrives.")
}

var CMaximumFileSizeAllowedToUploadIs1GB: String{
    return CLocalize(text: appDelegate.langugaeText?.max_file_size_allowed_to_upload_1_GB ?? "Maximum file size allowed to upload is 1 GB.")
}

var CFeatureNotAvailable: String{
    return CLocalize(text: "Feature not available")
}

var CPleaseSelectPollCategory: String{
    return CLocalize(text: appDelegate.langugaeText?.please_enter_poll_category ?? "Please select poll category.")
}

var CMaintenanceMode: String {
    return CLocalize(text: appDelegate.langugaeText?.maintenance_mode ?? "Sorry for the inconvenience social app is currently down due to some maintenance process going on server. We will be back soon.")
}

var CThereIsNoOnGoingChat: String{
    return CLocalize(text: appDelegate.langugaeText?.there_is_no_ongoing_chat ?? "There is no ongoing chat. Click on the chat button and start connecting with your friend.")
}

var CMyRewards: String{
    return CLocalize(text: appDelegate.langugaeText?.my_rewards ?? "My Rewards")
}

var CPoints: String{
    return CLocalize(text: appDelegate.langugaeText?.points ?? "Points")
}

var CPoint: String{
    return CLocalize(text: appDelegate.langugaeText?.point ?? "Point")
}

var CTotalPoints: String{
    return CLocalize(text: appDelegate.langugaeText?.total_points ?? "Total Points")
}

var CYouHaveEarned: String{
    return CLocalize(text: appDelegate.langugaeText?.you_have_earned ?? "You've Earned")
}

var CSummary: String{
    return CLocalize(text: appDelegate.langugaeText?.summary ?? "Summary")
}

var C_1_Onboarding_title: String{
    return CLocalize(text: appDelegate.langugaeText?.welcome_to_sevenchats ?? "Welcome to Sevenchats")
}

var C_1_Onboarding_Description: String{
    return CLocalize(text: appDelegate.langugaeText?.all_in_one_platform ?? "All in One Platform. Connect with Friends, share what you’re up to or see what’s new from others all over the world.")
}

var C_2_Onboarding_title: String{
    return CLocalize(text: appDelegate.langugaeText?.lets_chat ?? "Let’s Chat")
}

var C_2_Onboarding_Description: String{
    return CLocalize(text: appDelegate.langugaeText?.free_messaging_wherever_and_whenever ?? "Free, Messaging Wherever and Whenever!. Send free one-to-one and group texts to your friends anytime, anywhere.")
}

var C_3_Onboarding_title: String{
    return CLocalize(text: appDelegate.langugaeText?.free_voice_and_video_calls ?? "Free Voice and Video Calls")
}

var C_3_Onboarding_Description: String{
    return CLocalize(text: appDelegate.langugaeText?.call_friends_and_family ?? "Call friends and family as often as you want, for as long as you want. High Quality Audio and Video Calls for a quick “hello” or a face-to-face gossip.")
}

var C_4_Onboarding_title: String{
    return CLocalize(text: appDelegate.langugaeText?.create_store_share ?? "Create, Store and Share")
}

var C_4_Onboarding_Description: String{
    return CLocalize(text: appDelegate.langugaeText?.securely_store_manage_all_your_files ?? "Securely store, manage all your files, photos and documents. Invite others to view and collaborate on all the files and folders you want.")
}

var C_5_Onboarding_title: String{
    return CLocalize(text: appDelegate.langugaeText?.buy_and_sell ?? "Buy and Sell")
}

var C_5_Onboarding_Description: String{
    return CLocalize(text: appDelegate.langugaeText?.sell_your_stuff_and_shop_anything ?? "Sell your stuff and shop anything from a limited edition headphones or antique furniture to second hand electronics or used cars!")
}

var C_6_Onboarding_title: String{
    return CLocalize(text: appDelegate.langugaeText?.earn_points_everyday ?? " Earn Points Everyday")
}

var C_6_Onboarding_Description: String{
    return CLocalize(text: appDelegate.langugaeText?.you_can_now_collect_points_by_doing ?? "You can now collect points by doing simple things like building connections with other people, posting superior content, completing profile, and many more.")
}

var CCameraOrAudioPermission: String{
    return CLocalize(text: appDelegate.langugaeText?.camera_permission_or_microphone_permission_not_granted_please_allow_it_from_setting ?? "Camera permission or Microphone permission not granted. Please allow it from setting.")
}

var CAlertMessageForRejectRequest: String{
    return CLocalize(text: appDelegate.langugaeText?.alert_message_for_reject ?? "Are you sure? You want to reject request!")
}
var CAlertMessageForAcceptRequest: String{
    return CLocalize(text: appDelegate.langugaeText?.alert_message_for_accept ?? "Are you sure? You want to accept friend request!")
}
var CAlertMessageForSendRequest: String{
    return CLocalize(text: appDelegate.langugaeText?.alert_message_for_send ?? "Are you sure? You want to send friend request!")
}

var CToEnhanceFeed: String{
    return CLocalize(text: appDelegate.langugaeText?.to_enhance_feed ?? "To enhance your feed and make it more interesting. Build your connections with other people, pick your interests from the profile section, or start posting your own content.")
}
var CForceUpdateText: String{
    return CLocalize(text: appDelegate.langugaeText?.force_update_text ?? "We have released a new version for the application. Please click on the update button and get the latest version to make sure you have a seamless experience.")
}
var CLater: String{
    return CLocalize(text: appDelegate.langugaeText?.later ?? "Later")
}

var CLocation: String{
    return CLocalize(text: appDelegate.langugaeText?.location ?? "location")
}
var CCheckThisInNews: String{
    return CLocalize(text: appDelegate.langugaeText?.check_this_in_news ?? "Check out this news from Sevenchats.")
}

var CForward: String{
    return CLocalize(text: appDelegate.langugaeText?.forward ?? "Forward")
}
var CForwarded: String{
    return CLocalize(text: appDelegate.langugaeText?.forwarded_message ??  "Forwarded Message")
}

var CInviteesDeclinedEvent: String{
    return CLocalize(text: appDelegate.langugaeText?.invites_decline_for_event ??  "Invitees declined Event")
}
var CInviteesMayJoinEvent: String{
    return CLocalize(text: appDelegate.langugaeText?.invites_maybe_for_event ??  "Invitees may join Event")
}

/*
 var C: String{
     return CLocalize(text: "")
 }
*/
