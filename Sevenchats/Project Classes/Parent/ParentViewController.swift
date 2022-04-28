//
//  ParentViewController.swift
//  Social Media
//
//  Created by mac-0005 on 06/06/18.
//  Copyright © 2018 mac-0006. All rights reserved.
//

/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : RestrictedFilesVC                           *
 * Changes :                                             *
 *                                                       *
 ********************************************************/


import UIKit


class ParentViewController: UIViewController, UIGestureRecognizerDelegate{
    @IBOutlet weak var parentView : UIView!
    
    var imgPickerController : UIImagePickerController? = UIImagePickerController()
    var isNavigateFromSidePanel : Bool = false
    var iObject : Any?
    
    
    private var shadowImageView: UIImageView?
    
    
    //MARK:- UIStatusBar
    //MARK:-
    var isStatusBarHide = true {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    var statusBarStyle = UIApplication.shared.statusBarStyle {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
            //UIApplication.shared.statusBarStyle = statusBarStyle
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return isStatusBarHide
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return statusBarStyle
        }
    }
    
    //MARK:- LifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        imgPickerController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViewAppearance()
        imgPickerController?.delegate = self
        MIKeyboardManager.shared.enableKeyboardNotification()
        
        if shadowImageView == nil {
            shadowImageView = findShadowImage(under: navigationController?.navigationBar)
        }
        shadowImageView?.isHidden = true
    }
    
    override func viewWillLayoutSubviews() {
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.resignKeyboard()
        shadowImageView?.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func findShadowImage(under _view: UIView?) -> UIImageView? {
        guard let view = _view else { return nil}
        if view is UIImageView && view.bounds.size.height <= 1 {
            return (view as! UIImageView)
        }
        
        for subview in view.subviews {
            if let imageView = findShadowImage(under: subview) {
                return imageView
            }
        }
        return nil
    }
    
    //MARK:- General Method
    //MARK:-
    fileprivate func setupViewAppearance() {
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        //....Generic Navigation Setup
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font:CFontPoppins(size: 18, type: .meduim), NSAttributedString.Key.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.barTintColor = ColorAppBackground1
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "ic_navigation_bg"), for: .default)
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true //false
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        if #available(iOS 15.0, *) {
                       let appearance = UINavigationBarAppearance()
                       appearance.configureWithTransparentBackground()
                       appearance.backgroundImage = UIImage(named: "ic_navigation_bg")
                   appearance.titleTextAttributes = [NSAttributedString.Key.font:CFontPoppins(size: 18, type: .meduim), NSAttributedString.Key.foregroundColor:UIColor.white]
                       navigationController?.navigationBar.standardAppearance = appearance
                       navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
                   }else{
                       self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                       self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font:CFontPoppins(size: 18, type: .meduim), NSAttributedString.Key.foregroundColor:UIColor.white]
                       self.navigationController?.navigationBar.barTintColor = ColorAppBackground1
                       self.navigationController?.navigationBar.tintColor = .white
                       self.navigationController?.navigationBar.barStyle = .default
                       self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "ic_navigation_bg"), for: .default)
                       self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
                       self.navigationController?.navigationBar.shadowImage = UIImage()
                       self.navigationController?.navigationBar.isTranslucent = true //false
                       self.navigationController?.interactivePopGestureRecognizer?.delegate = self
                   }
        
        
        var imgBack = UIImage()
        if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
            /*if IS_iOS10 {
             imgBack = UIImage(named: "ic_back_reverse")!
             }else {
             imgBack = UIImage(named: "ic_back")!
             }*/
            imgBack = UIImage(named: "ic_back")!
        }else{
            imgBack = UIImage(named: "ic_back")!
        }
        
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = imgBack
        self.navigationController?.navigationBar.backIndicatorImage = imgBack
        
        self.navigationItem.hidesBackButton = false
        self.navigationController?.isNavigationBarHidden = false
        
        if (self.view.tag == 100)
        {
            // Hide Navigation.....
            self.navigationController?.isNavigationBarHidden = true
        } else if (self.view.tag == 101)
        {
            // To show Normal Navigation.....
        }
        else if (self.view.tag == 102)
        {
            // Show Navigation and Advertise view.....
            self.showHideAddView()
        }
        else if (self.view.tag == 103)
        {
            // Show Navigation without back button.....
            self.navigationItem.hidesBackButton = true
        }else if (self.view.tag == 104)
        {
            // Transparent Navigation
            //......Show burger menu in navigationItem......
            //            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image:imgMenu, style: .plain, target: self, action: #selector(leftBurgerMenuClicked))
            
            addHomeBurgerButton()
            
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationItem.hidesBackButton = true
            self.navigationController?.navigationBar.isTranslucent = false
            self.showHideAddView()
        }else if (self.view.tag == 99)
        {
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.isTranslucent = true
            self.showHideAddView()
        }else if (self.view.tag == 105)
        {
            // Normal Navigation
            //......Show burger menu in navigationItem......
            //            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image:imgMenu, style: .plain, target: self, action: #selector(leftBurgerMenuClicked))
            addHomeBurgerButton()
            
            self.navigationItem.hidesBackButton = true
            self.showHideAddView()
        }else if (self.view.tag == 106)
        {
            // Hide Navigation
            //......Show Add view
            self.navigationController?.isNavigationBarHidden = true
            self.showHideAddView()
        }else if (self.view.tag == 107) {
            // Transparent navigation with back button
            //......Show Add view
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.isTranslucent = false
            self.showHideAddView()
        }else if (self.view.tag == 108){
            self.navigationItem.hidesBackButton = true
            self.showHideAddView()
        }else if (self.view.tag == 109) {
            // Hide Navigation
            self.navigationController?.isNavigationBarHidden = true
        }else if (self.view.tag == 110) {
            
            //......Show Add view
            self.showHideAddView()
            self.navigationController?.isNavigationBarHidden = true
        }else if (self.view.tag == 111) {
            
            //......Show Add view
            self.showHideAddView()
            self.navigationController?.isNavigationBarHidden = false
        }
    }
    
    internal func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if(self.navigationController!.viewControllers.count > 1){
            return true
        }
        return false
    }
    
    
    func resignKeyboard() {
        UIApplication.shared.sendAction(#selector(resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    //MARK:- ----------Home Burger Button
    //MARK:-
    func addHomeBurgerButton(){
        self.navigationItem.leftBarButtonItem = nil
        let rightItem = UIBarButtonItem(customView: self.createHomeBurgerButton())
        self.navigationItem.leftBarButtonItem = rightItem
    }
    func createHomeBurgerButton() -> UIView {
        
        let viewBurgger = UIView()
        let btnHomeBurger = UIButton()
        var imgMenu = UIImage()
        
        if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
            imgMenu = #imageLiteral(resourceName: "ic_sidemenu_reverse")
            btnHomeBurger.setImage(imgMenu, for: .normal)
            btnHomeBurger.contentHorizontalAlignment = .right
        }
        else{
            imgMenu = #imageLiteral(resourceName: "ic_sidemenu")
            btnHomeBurger.setImage(imgMenu, for: .normal)
            btnHomeBurger.contentHorizontalAlignment = .left
        }
        
        btnHomeBurger.sizeToFit()
        
        btnHomeBurger.touchUpInside { [weak self](sender) in
            self?.leftBurgerMenuClicked()
        }
        
        btnHomeBurger.CViewSetHeight(height: 35)
        btnHomeBurger.CViewSetWidth(width: 35)
        viewBurgger.addSubview(btnHomeBurger)
        
        // If any notification count is there then only red dot will show.
        if let badgeCount = CUserDefaults.value(forKey: UserDefaultNotificationCountBadge) as? Bool, badgeCount {
            let imgNotificationBadge = UIImageView(frame: CGRect(x: imgMenu.size.width-10, y: 5, width: 10, height: 10))
            imgNotificationBadge.backgroundColor = UIColor.red
            imgNotificationBadge.layer.cornerRadius = 5
            imgNotificationBadge.layer.masksToBounds = true
            viewBurgger.addSubview(imgNotificationBadge)
        }
        
        viewBurgger.CViewSetHeight(height: btnHomeBurger.CViewHeight)
        viewBurgger.CViewSetWidth(width: btnHomeBurger.CViewWidth)
        
        return viewBurgger
    }
    
    //MARK:- ----------Advertising View
    //MARK:-
    func showHideAddView() {
        
        var isHideAdd : Bool = true
        
        if appDelegate.loginUser != nil {
            if let arrAdd = TblAdvertise.fetchAllObjects(), arrAdd.count > 0 && !(appDelegate.loginUser?.user_type)! {
                isHideAdd = false
            }
        }else {
            // Hide Advertise after user loged In.
            isHideAdd = false
        }
        
        if parentView != nil && !isHideAdd {
            // show Advertise View....
            _ =  parentView.setConstraintConstant(-60, edge: .bottom, ancestor: true)
            self.createAdvertiseView()
            
        }else {
            // Remove Advertise View....
            if parentView != nil {
                _ =  parentView.setConstraintConstant(0, edge: .bottom, ancestor: true)
                for addView in self.view.subviews where addView.isKind(of: AdvertiseView.classForCoder()) {
                    addView.removeFromSuperview()
                }
            }
        }
    }
    
    func createAdvertiseView() {
        
        var arrAdvertise = [TblAdvertise]()
        
        if self.isKind(of: HomeViewController.classForCoder()) {
            // Home screen Related Add
            if let arr = TblAdvertise.fetch(predicate: NSPredicate(format: "\(CBy_page) == 1 || \(CBy_page) == 3")) as? [TblAdvertise] {
                arrAdvertise = arr
            }
        }else {
            // Other screen Related Add
            if let arr = TblAdvertise.fetch(predicate: NSPredicate(format: "\(CBy_page) == 2 || \(CBy_page) == 3")) as? [TblAdvertise] {
                arrAdvertise = arr
            }
        }
        
        if appDelegate.viewAdvertise == nil {
            if let addView : AdvertiseView = AdvertiseView.viewFromXib as? AdvertiseView {
                addView.CViewSetWidth(width: CScreenWidth)
                appDelegate.viewAdvertise = addView
            }
        }
        
        appDelegate.viewAdvertise.initialization(arrAdvertise)
        var navHeight : CGFloat = 0.0
        if self.view.tag != 110{
            navHeight = (self.navigationController?.navigationBar.frame.size.height)! + UIApplication.shared.statusBarFrame.size.height
        }
        
        var isNavigationHide = Bool()
        
        if (self.navigationController?.isNavigationBarHidden)! || (self.navigationController?.navigationBar.isTranslucent)!{
            isNavigationHide = true
        }
        
        if IS_iPhone_X_Series {
            let iPhoneXBottom = 33.0
            appDelegate.viewAdvertise.CViewSetHeight(height: CGFloat(60 + iPhoneXBottom))
            
            if isNavigationHide {
                appDelegate.viewAdvertise.CViewSetY(y: CScreenHeight - CGFloat(60 + iPhoneXBottom))
            }else {
                appDelegate.viewAdvertise.CViewSetY(y: CScreenHeight - (CGFloat(60 + iPhoneXBottom) + navHeight ))
            }
        }else {
            appDelegate.viewAdvertise.CViewSetHeight(height: 60)
            appDelegate.viewAdvertise.CViewSetY(y: isNavigationHide ? (CScreenHeight - 60) : (CScreenHeight - (60 + navHeight)))
        }
        
        appDelegate.viewAdvertise.btnCloseAdd.touchUpInside { [weak self](sender) in
            guard let _ = self else {return}
            DispatchQueue.main.async {
                if let paymentVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "PaymentViewController") as? PaymentViewController {
                    let nav = UINavigationController.init(rootViewController: paymentVC)
                    if #available(iOS 13.0, *){
                        nav.isModalInPresentation = true
                        nav.modalPresentationStyle = .fullScreen
                    }
                    self?.present(nav, animated: true, completion: nil)
                }
            }
        }
        
        self.view.addSubview(appDelegate.viewAdvertise)
        self.view.bringSubviewToFront(appDelegate.viewAdvertise)
    }
}


//MARK:- ----------Action Event
//MARK:-
extension ParentViewController {
    
    @IBAction func btnBackCLK(_ sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnMenuCLK(_ sender : UIButton) {
        appDelegate.showSidemenu()
    }
    
    @objc func leftBurgerMenuClicked() {
        appDelegate.showSidemenu()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
}


