//
//  SideMenuViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 09/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : SideMenuViewController                      *
 * Changes :                                             *
 *                                                       *
 ********************************************************/


import UIKit


let kNotificationCount = "kNotificationCount"
class SideMenuViewController: ParentViewController {
    
    
    @IBOutlet var lblUserName : UILabel!
    @IBOutlet var imgUser : UIImageView!
    @IBOutlet var tblMenu : UITableView!
    
    var arrMenu = [[String : Any]]()
    var selectedIndexPath = IndexPath(item: 0, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Initialization()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateUserProfile()
        arrMenu = [
            [CTitle:CSideHome as Any, CImage:#imageLiteral(resourceName: "ic_home"), CImageSelected:#imageLiteral(resourceName: "ic_home"), kNotificationCount:0],
            [CTitle:CNavFriends as Any, CImage:#imageLiteral(resourceName: "ic_friend"), CImageSelected:#imageLiteral(resourceName: "ic_friend"), kNotificationCount:0],
            [CTitle:CSideConnectInvite as Any, CImage:#imageLiteral(resourceName: "ic_sidemenu_normal_connectInvite"), CImageSelected:#imageLiteral(resourceName: "ic_sidemenu_normal_connectInvite"), kNotificationCount:0],
            [CTitle:CSideGroups as Any, CImage:#imageLiteral(resourceName: "ic_groups"), CImageSelected:#imageLiteral(resourceName: "ic_groups"), kNotificationCount:0],
            [CTitle:CSideChat as Any, CImage:#imageLiteral(resourceName: "ic_chats"), CImageSelected:#imageLiteral(resourceName: "ic_chats"), kNotificationCount:0],
            [CTitle:CSideNews as Any, CImage:#imageLiteral(resourceName: "ic_news"), CImageSelected:#imageLiteral(resourceName: "ic_news"), kNotificationCount:0],
            [CTitle:CSidePSL as Any, CImage:#imageLiteral(resourceName: "ic_psl"), CImageSelected:#imageLiteral(resourceName: "ic_psl"), kNotificationCount:0],
            [CTitle:CSideNotifications as Any, CImage:#imageLiteral(resourceName: "ic_notification"), CImageSelected:#imageLiteral(resourceName: "ic_notification"), kNotificationCount:0],
            [CTitle:CStores as Any, CImage:#imageLiteral(resourceName: "ic_store"), CImageSelected:#imageLiteral(resourceName: "ic_store"), kNotificationCount:0],
            [CTitle:CSideQuotes as Any, CImage:#imageLiteral(resourceName: "ic_quotes"), CImageSelected:#imageLiteral(resourceName: "ic_quotes"), kNotificationCount:0],
            [CTitle:CMyRewards as Any, CImage:#imageLiteral(resourceName: "ic_rewards"), CImageSelected:#imageLiteral(resourceName: "ic_rewards"), kNotificationCount:0],
            [CTitle:CSideFavWebSites as Any, CImage:#imageLiteral(resourceName: "ic_favorite"), CImageSelected:#imageLiteral(resourceName: "ic_favorite"), kNotificationCount:0],
            [CTitle:CSideSettings as Any, CImage:#imageLiteral(resourceName: "ic_settings"), CImageSelected:#imageLiteral(resourceName: "ic_settings"), kNotificationCount:0],
            [CTitle:CSideLogout as Any, CImage:#imageLiteral(resourceName: "ic_logout"), CImageSelected:#imageLiteral(resourceName: "ic_logout"), kNotificationCount:0]
        ]
        
        tblMenu.reloadData()
        
        self.getNotificationCountFromServer()
        
        //...Update Notificatin count after read notification
        appDelegate.updateNotificationCount =  { [weak self]() -> Void in
            guard let _ = self else { return }
            self?.getNotificationCountFromServer()
        }
    }
    
    // MARK:- ------- Initialization
    func Initialization(){
        DispatchQueue.main.async {
            self.imgUser.layer.cornerRadius = self.imgUser.bounds.height / 2
            self.imgUser.layer.masksToBounds = true
            self.imgUser.clipsToBounds = true
            self.imgUser.layer.borderWidth = 3
            self.imgUser.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
        }
    }
    
    func selectIndex(_ index:Int){
        selectedIndexPath = IndexPath(item: index, section: 0)
        tblMenu.reloadData()
    }
    
    func updateUserProfile(){
        lblUserName.text = "\(appDelegate.loginUser?.first_name ?? "") \(appDelegate.loginUser?.last_name ?? "")"
        imgUser.loadImageFromUrl((appDelegate.loginUser?.profile_url ?? ""), true)
    }
}

// MARK:- ---------- Api Functions
// MARK:-
extension SideMenuViewController {
    
    fileprivate func getNotificationCountFromServer() {
        
        
        let groupCount =  0
        let userCount =  0
        let notificationCount =  0
        
        UIApplication.shared.applicationIconBadgeNumber = groupCount + userCount + notificationCount
        
        if groupCount > 0 || userCount > 0 || notificationCount > 0 {
            CUserDefaults.set(true, forKey: UserDefaultNotificationCountBadge)
        }else {
            CUserDefaults.set(false, forKey: UserDefaultNotificationCountBadge)
        }
        DispatchQueue.main.async {
            if let viewcontroller = (appDelegate.sideMenuController.rootViewController as? UINavigationController)?.viewControllers.first as? ParentViewController{
                if viewcontroller.view.tag != 111{
                    viewcontroller.addHomeBurgerButton()
                }
            }
        }
        
        self.arrMenu = [
            [CTitle:CSideHome as Any, CImage:#imageLiteral(resourceName: "ic_home"), CImageSelected:#imageLiteral(resourceName: "ic_home"), kNotificationCount:0],
            [CTitle:CNavFriends as Any, CImage:#imageLiteral(resourceName: "ic_friend"), CImageSelected:#imageLiteral(resourceName: "ic_friend"), kNotificationCount:0],
            [CTitle:CSideConnectInvite as Any, CImage:#imageLiteral(resourceName: "ic_sidemenu_normal_connectInvite"), CImageSelected:#imageLiteral(resourceName: "ic_sidemenu_normal_connectInvite"), kNotificationCount:0],
            [CTitle:CSideGroups as Any, CImage:#imageLiteral(resourceName: "ic_groups"), CImageSelected:#imageLiteral(resourceName: "ic_groups"), kNotificationCount: groupCount],
            [CTitle:CSideChat as Any, CImage:#imageLiteral(resourceName: "ic_chats"), CImageSelected:#imageLiteral(resourceName: "ic_chats"), kNotificationCount:userCount],
            [CTitle:CSideNews as Any, CImage:#imageLiteral(resourceName: "ic_news"), CImageSelected:#imageLiteral(resourceName: "ic_news"), kNotificationCount:0],
            [CTitle:CSidePSL as Any, CImage:#imageLiteral(resourceName: "ic_psl"), CImageSelected:#imageLiteral(resourceName: "ic_psl"), kNotificationCount:0],
            [CTitle:CSideNotifications as Any, CImage:#imageLiteral(resourceName: "ic_notification"), CImageSelected:#imageLiteral(resourceName: "ic_notification"), kNotificationCount:notificationCount],
            [CTitle:CStores as Any, CImage:#imageLiteral(resourceName: "ic_store"), CImageSelected:#imageLiteral(resourceName: "ic_store"), kNotificationCount:0],
            [CTitle:CSideQuotes as Any, CImage:#imageLiteral(resourceName: "ic_quotes"), CImageSelected:#imageLiteral(resourceName: "ic_quotes"), kNotificationCount:0],
            [CTitle:CMyRewards as Any, CImage:#imageLiteral(resourceName: "ic_rewards"), CImageSelected:#imageLiteral(resourceName: "ic_rewards"), kNotificationCount:0],
            [CTitle:CSideFavWebSites as Any, CImage:#imageLiteral(resourceName: "ic_favorite"), CImageSelected:#imageLiteral(resourceName: "ic_favorite"), kNotificationCount:0],
            [CTitle:CSideSettings as Any, CImage:#imageLiteral(resourceName: "ic_settings"), CImageSelected:#imageLiteral(resourceName: "ic_settings"), kNotificationCount:0],
            [CTitle:CSideLogout as Any, CImage:#imageLiteral(resourceName: "ic_logout"), CImageSelected:#imageLiteral(resourceName: "ic_logout"), kNotificationCount:0]
        ]
        
        self.tblMenu.reloadData()
    }
}

// MARK:- --------- UITableView Datasources/Delegate
extension SideMenuViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMenu.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //        return 50.0
        return CScreenWidth*13.34/100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell", for: indexPath) as? SideMenuCell {
            let notificationInfo = arrMenu[indexPath.row]
            cell.lblTitle.text = notificationInfo.valueForString(key: CTitle)
            
            let img = notificationInfo[CImage] as? UIImage
            let imgSelected = notificationInfo[CImageSelected] as? UIImage
            
            cell.btnImage.setImage(img?.imageFlippedForRightToLeftLayoutDirection(), for: .normal)
            cell.btnImage.setImage(imgSelected?.imageFlippedForRightToLeftLayoutDirection(), for: .selected)
            
            if selectedIndexPath == indexPath {
                cell.btnImage.isSelected = true
                cell.viewLine.isHidden = false
              //  cell.lblTitle.textColor = CRGB(r: 131, g: 157, b: 102)
//                cell.contentView.backgroundColor = CRGB(r: 217, g: 238, b: 222)
                cell.lblTitle.textColor = ColorBlack
                cell.contentView.backgroundColor = CRGB(r: 224, g: 224, b: 224)
            } else {
                cell.btnImage.isSelected = false
                cell.viewLine.isHidden = true
                cell.lblTitle.textColor = CRGB(r: 129, g: 122, b: 122)
                cell.contentView.backgroundColor = UIColor.clear
            }
            
            cell.lblNotficationCount.text = notificationInfo.valueForString(key: kNotificationCount)
            cell.lblNotficationCount.isHidden = notificationInfo.valueForInt(key: kNotificationCount) == 0
            
            return cell
        }
        
        return tableView.tableViewDummyCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedIndexPath = indexPath
        tblMenu.reloadData()
        let dicData = arrMenu[indexPath.row]
        switch dicData.valueForString(key: CTitle) {
        case CSideHome:
            appDelegate.sideMenuController.rootViewController = UINavigationController.init(rootViewController: CStoryboardHome.instantiateViewController(withIdentifier: "HomeViewController"))
            appDelegate.hideSidemenu()
            break
            
        case CFileTitle:
            
            appDelegate.sideMenuController.rootViewController = UINavigationController.init(rootViewController: CStoryboardFile.instantiateViewController(withIdentifier: "FileSharingViewController"))
            let systemVersion = UIDevice.current.systemVersion.toInt ?? 0
            if systemVersion < 13 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    appDelegate.hideSidemenu()
                }
            }
            break
        case CSideConnectInvite:
          if let inviteContancVC : InviteAndConnectViewController = CStoryboardLRF.instantiateViewController(withIdentifier: "InviteAndConnectViewController") as? InviteAndConnectViewController{
                        inviteContancVC.isFromSideMenu = true
                        appDelegate.sideMenuController.rootViewController = UINavigationController.init(rootViewController: inviteContancVC)
                        appDelegate.hideSidemenu()
                    }
                    
                    break
            
        case CSideProfile:
            appDelegate.sideMenuController.rootViewController = UINavigationController.init(rootViewController: CStoryboardProfile.instantiateViewController(withIdentifier: "MyProfileViewController"))
            appDelegate.hideSidemenu()
            break
            
      
     
        case CSideProfile:
            appDelegate.sideMenuController.rootViewController = UINavigationController.init(rootViewController: CStoryboardProfile.instantiateViewController(withIdentifier: "MyProfileViewController"))
            appDelegate.hideSidemenu()
            break
            
            
     
            
            
        case CNavFriends:
            if let frndVC = CStoryboardProfile.instantiateViewController(withIdentifier: "MyFriendsViewController") as? MyFriendsViewController {
                frndVC.isFromSideMenu = true
                appDelegate.sideMenuController.rootViewController = UINavigationController.init(rootViewController: frndVC)
                appDelegate.hideSidemenu()
            }
            break
        case CSideChat:
            appDelegate.sideMenuController.rootViewController = UINavigationController.init(rootViewController: CStoryboardChat.instantiateViewController(withIdentifier: "ChatListViewController"))
            let systemVersion = UIDevice.current.systemVersion.toInt ?? 0
            if systemVersion < 13 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    appDelegate.hideSidemenu()
                }
            }
            break
            
        case CSideGroups:
            appDelegate.sideMenuController.rootViewController = UINavigationController.init(rootViewController: CStoryboardGroup.instantiateViewController(withIdentifier: "GroupsViewController"))
            let systemVersion = UIDevice.current.systemVersion.toInt ?? 0
            if systemVersion < 13 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    appDelegate.hideSidemenu()
                }
            }
            break
            
        case CSideQuotes:
            appDelegate.sideMenuController.rootViewController = UINavigationController.init(rootViewController: CStoryboardSideMenu.instantiateViewController(withIdentifier: "QuotesViewController"))
            let systemVersion = UIDevice.current.systemVersion.toInt ?? 0
            if systemVersion < 13 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    appDelegate.hideSidemenu()
                }
            }
            break
            
        case CSidePostAds:
            self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CMessagePostAds, btnOneTitle: CBtnCancel, btnOneTapped: { [weak self](alert) in
                guard let _ = self else { return }
            }, btnTwoTitle: CBtnGoToWebsite, btnTwoTapped:  { [weak self] (alert) in
                guard let _ = self else { return }
                if UIApplication.shared.canOpenURL(URL(string: CWebSiteLink)!){
                    UIApplication.shared.open(URL(string: CWebSiteLink)!, options: [:], completionHandler: nil)
                }})
            break
            
        case CSideNews:
            appDelegate.sideMenuController.rootViewController = UINavigationController.init(rootViewController: CStoryboardSideMenu.instantiateViewController(withIdentifier: "NewsViewController"))
            appDelegate.hideSidemenu()
            break
        case CSidePSL:
            appDelegate.sideMenuController.rootViewController = UINavigationController.init(rootViewController: CStoryboardSideMenu.instantiateViewController(withIdentifier: "PSLViewController"))
            appDelegate.hideSidemenu()
            break
            
        case CSideFavWebSites:
            appDelegate.sideMenuController.rootViewController = UINavigationController.init(rootViewController: CStoryboardSideMenu.instantiateViewController(withIdentifier: "FavWebSideViewController"))
            appDelegate.hideSidemenu()
            break
            
        case CSideConnectInvite:
            if let inviteContancVC : InviteAndConnectViewController = CStoryboardLRF.instantiateViewController(withIdentifier: "InviteAndConnectViewController") as? InviteAndConnectViewController{
                inviteContancVC.isFromSideMenu = true
                appDelegate.sideMenuController.rootViewController = UINavigationController.init(rootViewController: inviteContancVC)
                appDelegate.hideSidemenu()
            }
            
            break
        case CStores:
            
            if let storeList : StoreListVC = CStoryboardProduct.instantiateViewController(withIdentifier: "StoreListVC") as? StoreListVC{
                appDelegate.sideMenuController.rootViewController = nil
                appDelegate.sideMenuController.rootViewController = UINavigationController.init(rootViewController: storeList)
                
                let systemVersion = UIDevice.current.systemVersion.toInt ?? 0
                if systemVersion < 13 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        appDelegate.hideSidemenu()
                    }
                }
            }
            
            break
        case CSideEventCalendar:
            appDelegate.sideMenuController.rootViewController = UINavigationController.init(rootViewController: CStoryboardEvent.instantiateViewController(withIdentifier: "EventListViewController"))
            appDelegate.hideSidemenu()
            break
            
        case CSideNotifications:
            appDelegate.sideMenuController.rootViewController = UINavigationController.init(rootViewController: CStoryboardGeneral.instantiateViewController(withIdentifier: "NotificationViewController"))
            //appDelegate.hideSidemenu()
            let systemVersion = UIDevice.current.systemVersion.toInt ?? 0
            if systemVersion < 13 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    appDelegate.hideSidemenu()
                }
            }
            break
        case CMyRewards:
            appDelegate.sideMenuController.rootViewController = UINavigationController.init(rootViewController: CStoryboardRewards.instantiateViewController(withIdentifier: "MyRewardsVC"))
            let systemVersion = UIDevice.current.systemVersion.toInt ?? 0
            if systemVersion < 13 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    appDelegate.hideSidemenu()
                }
            }
            break
        case CSideSettings:
            appDelegate.sideMenuController.rootViewController = UINavigationController.init(rootViewController: CStoryboardSetting.instantiateViewController(withIdentifier: "SettingViewController"))
            let systemVersion = UIDevice.current.systemVersion.toInt ?? 0
            if systemVersion < 13 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    appDelegate.hideSidemenu()
                }
            }
            break
            
        case CSideLogout:
            self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CMessageLogout, btnOneTitle: CBtnYes, btnOneTapped: { [weak self] (alert) in
                guard let _ = self else { return }
                MIGeneralsAPI.shared().addRemoveNotificationToken(isLogout: 1)
            }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
            
            break
            
        default:
            break
        }
    }
}

// MARK:- ---------- Action Event
// MARK:-
extension SideMenuViewController {
    @IBAction func btnUserCLK(_ sender : UIButton){
        appDelegate.sideMenuController.rootViewController = UINavigationController.init(rootViewController: CStoryboardProfile.instantiateViewController(withIdentifier: "MyProfileViewController"))
        appDelegate.hideSidemenu()
    }
}
