//
//  MISocial.swift
//  Nerd
//
//  Created by mac-0005 on 02/06/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import SafariServices
import Alamofire
import FBSDKLoginKit
//import TwitterKit
//import TwitterCore
import GoogleSignIn
import AuthenticationServices

let CInstagramClientID      =  "cd2d438c2be64905a130d46146c4d235"  //"935b4f24f45b4a3480811fefeddf656d"
let CInstagramClientSecret  = "e4f0d32e503b406da61f62c763c3c05a"  //"1f5291c837f84c309f35c3d790da2ae6"
let CSocialRedirectURI      =  "https://itrainacademy.in/sevenchats/"


class MISocial: NSObject {
    var safariVC: SFSafariViewController?

    typealias InstagramUserInfoBlock = ((Any?, Error?) -> Void)
    typealias FacebookUserInfoBlock = ((Any?, Error?) -> Void)
    //typealias TwiterUserInfoBlock = ((TWTRSession?, Error?) -> Void)
    typealias TwiterEmailInfoBlock = ((Any?, Error?) -> Void)
    typealias TwiterFriendListBlock = ((Any?, Error?) -> Void)
    
    typealias GoogleUserInfoBlock = ((Any?, Error?) -> Void)
    
    typealias AppleUserInfoBlock = ((Any?, Error?) -> Void)

    var facebookUserInfoBlock:FacebookUserInfoBlock?
    var instagramUserInfoBlock:InstagramUserInfoBlock?
    //var twiterUserInfoBlock:TwiterUserInfoBlock?
    var twiterEmailInfoBlock:TwiterEmailInfoBlock?
    var twiterFriendListBlock:TwiterFriendListBlock?
    
    var googleUserInfoBlock:GoogleUserInfoBlock?
    
    var appleUserInfoBlock:AppleUserInfoBlock?

    
    private override init() {
        super.init()
    }
    
    private static var social:MISocial = {
        let social = MISocial()
        return social
    }()
    
    static func shared() ->MISocial {
        return social
    }
}

// MARK:- ------------ Facebook
extension MISocial
{
    func signUpWithFacebook(fromVC viewController : UIViewController?, completion userInfoBlock:FacebookUserInfoBlock?) {
        
        //....Facebook Logout
        if (AccessToken.current != nil) {
            LoginManager().logOut()
        }
        
        facebookUserInfoBlock = userInfoBlock
        
        if viewController != nil {
            
            let loginManager = LoginManager()
            //loginManager.loginBehavior = .native
            //["public_profile", "email", "user_friends"]
            loginManager.logIn(permissions: ["public_profile", "email"], from: viewController) { (result, error) in
                
                if result != nil && error == nil {
                    
                    if result?.token != nil {
                        
                        let fbGraphRequest = GraphRequest.init(graphPath: "me", parameters: ["fields": "first_name, last_name, name, picture, email"])
                        _ = fbGraphRequest.start(completionHandler: { (_ , userInfo, error) in
                            
                            guard self.facebookUserInfoBlock  != nil else {
                                return
                            }
                            if self.facebookUserInfoBlock != nil{
                                self.facebookUserInfoBlock!(userInfo, error)
                                self.facebookUserInfoBlock = nil
                            }
                        })
                        
                    } else {
                        
                        if (result?.isCancelled)! {
                            print("Cancelled FacebookLogin: \(String(describing: result))")
                        }
                        
                        guard self.facebookUserInfoBlock  != nil else {
                            return
                        }
                        
                        self.facebookUserInfoBlock!(nil, error)
                        self.facebookUserInfoBlock = nil
                    }
                    
                } else {
                    if self.facebookUserInfoBlock != nil{
                        self.facebookUserInfoBlock!(nil, error)
                        self.facebookUserInfoBlock = nil
                    }
                    
                }
            }
        }
    }
    
    func facebookFriendList(fromVC viewController : UIViewController?, completion userInfoBlock:FacebookUserInfoBlock?) {
        
        facebookUserInfoBlock = userInfoBlock
        
        if viewController != nil {

            let loginManager = LoginManager()
           // loginManager.loginBehavior = .native
            //["public_profile", "email", "user_friends"]
            loginManager.logIn(permissions: ["public_profile", "email"], from: viewController) { (result, error) in
                
                if result != nil && error == nil {
                    
                    if result?.token != nil {
                        
                        let params = ["fields": "id, first_name, last_name, name, email, picture"]
                        
                         //"me/friends"
                        
                        let fbGraphRequest = GraphRequest.init(graphPath: "me/friends", parameters: params, httpMethod: HTTPMethod(rawValue: "GET"))
                        
                        
                        
//                        let fbGraphRequest = FBSDKGraphRequest.init(graphPath: "me/friends", parameters: params, tokenString: "EAAOGSvN785oBAMk0JbvV2cjRDZBCnI2xZApRpbacEBWZBw4zugkZBCYM0VyUzrA9nytxBp9ccZBDmuhFTDDGxGccXpRFIJyivMUE6lJlqdZCk2PaDGZAv9dovnevxHznD9oF7dwnMiC3ESqZA97HF2zOe3aebFSi48MN485TZCflLFH55IES6Hdw96N56Ig0eI3uMDG2f89VsR1xWZAdpIswEZBWzhfcA8BxmvIqNzeUZBEinAZDZD", version: "v3.2", httpMethod: "GET") //FBSDKGraphRequest.init(graphPath: "me/friends", parameters: params, httpMethod: "GET")
//                           //FBSDKGraphRequest.init(graphPath: "me/friends", parameters: params)
                        _ = fbGraphRequest.start(completionHandler: { (_ , userInfo, error) in
                            
                            guard self.facebookUserInfoBlock  != nil else {
                                return
                            }
                            if self.facebookUserInfoBlock != nil{
                                self.facebookUserInfoBlock!(userInfo, error)
                                self.facebookUserInfoBlock = nil
                            }
                            
                        })
                        
                    } else {
                        
                        if (result?.isCancelled)! {
                            print("Cancelled FacebookLogin: \(String(describing: result))")
                        }
                        
                        guard self.facebookUserInfoBlock  != nil else {
                            return
                        }
                        
                        self.facebookUserInfoBlock!(nil, error)
                        self.facebookUserInfoBlock = nil
                    }
                    
                } else {
                    if self.facebookUserInfoBlock != nil{
                        self.facebookUserInfoBlock!(nil, error)
                        self.facebookUserInfoBlock = nil
                    }
                    
                }
            }
        }
    }
    
}

//MARK:- ------------ Google
extension MISocial : GIDSignInDelegate {
    
    func googleLogin(fromVC viewcontroller : UIViewController?, completion userInfoBlock:GoogleUserInfoBlock?) {
        
        if viewcontroller != nil {
          googleUserInfoBlock = userInfoBlock
            
          //UIApplication.shared.beginIgnoringInteractionEvents()
            
           GIDSignIn.sharedInstance()?.presentingViewController = viewcontroller
            
            // Automatically sign in the user.
            //GIDSignIn.sharedInstance()?.restorePreviousSignIn()
            
            let signIn = GIDSignIn.sharedInstance()
            signIn?.shouldFetchBasicProfile = true
            signIn?.delegate = self
            
            signIn?.signIn()
        }
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        UIApplication.shared.endIgnoringInteractionEvents()
        CTopMostViewController.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        UIApplication.shared.endIgnoringInteractionEvents()
        CTopMostViewController.dismiss(animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        UIApplication.shared.endIgnoringInteractionEvents()
        if ((googleUserInfoBlock) != nil) {
            googleUserInfoBlock!(user, error)
            googleUserInfoBlock = nil
        }
    }
}

// MARK:- ------------ Instagram
extension MISocial : ASAuthorizationControllerDelegate{
    
    
    func signUpWithApple (fromVC viewController : UIViewController?, completion userInfoBlock:AppleUserInfoBlock?) {
         
         appleUserInfoBlock = userInfoBlock
                if #available(iOS 13.0, *) {
                    let appleIDProvider = ASAuthorizationAppleIDProvider()
                    let request = appleIDProvider.createRequest()
                         request.requestedScopes = [.fullName, .email]
                         let authorizationController = ASAuthorizationController(authorizationRequests: [request])
                         authorizationController.delegate = self
                         authorizationController.performRequests()
                } else {
                    // Fallback on earlier versions
                }
            }
            
        @available(iOS 13.0, *)
        func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            if #available(iOS 13.0, *) {
                if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
                    let userIdentifier = appleIDCredential.user
                    let fullName = appleIDCredential.fullName
                    let email = appleIDCredential.email
                    
                    appleUserInfoBlock?(appleIDCredential,nil)
                    
                    print("User id is \(userIdentifier) \n Full Name is \(String(describing: fullName)) \n Email id is \(String(describing: email))") }
            } else {
                // Fallback on earlier versions
            }
            }
            
        @available(iOS 13.0, *)
        func authorizationController(controller:ASAuthorizationController, didCompleteWithError error: Error) {
            // Handle error.
            }
    
    func signUpWithInstagram (fromVC viewController : UIViewController?, completion userInfoBlock:InstagramUserInfoBlock?) {
        
        instagramUserInfoBlock = userInfoBlock
        
        let urlString = "https://api.instagram.com/oauth/authorize/?client_id=\(CInstagramClientID)&redirect_uri=\(CSocialRedirectURI)&response_type=code"
        
        safariVC = SFSafariViewController(url: URL(string: urlString)!)
        
        if let navigationVC = CTopMostViewController as? UINavigationController, let vc = navigationVC.viewControllers.last {
            vc.present(safariVC!, animated: true, completion: nil)
        } else {
            CTopMostViewController.present(safariVC!, animated: true, completion: nil)
        }
        
    }
    
    func checkInstagramAccessToken(url : URL) {
        
        if (url.absoluteString.contains("error") == true) {
            print("Instagram Error :", url.absoluteString)
            
        } else if (url.absoluteString.contains("code=") == true) {
            
            let index1: Int = (url.absoluteString as NSString).range(of: "code=").location + (url.absoluteString as NSString).range(of: "code=").length
            let code = (url.absoluteString as NSString).substring(from: index1)
            let parameter: [String: Any] = ["grant_type": "authorization_code", "code": code, "redirect_uri":CSocialRedirectURI, "client_id": CInstagramClientID, "client_secret": CInstagramClientSecret]
            
            SessionManager.default.request("https://api.instagram.com/oauth/access_token", method: .post, parameters: parameter, encoding: URLEncoding.methodDependent, headers: SessionManager.defaultHTTPHeaders).responseJSON(completionHandler: { (response) in
                
                if self.instagramUserInfoBlock != nil{
                    self.instagramUserInfoBlock!(response.result.value, response.error)
                    self.instagramUserInfoBlock = nil
                }
            })
        }
    }
}
