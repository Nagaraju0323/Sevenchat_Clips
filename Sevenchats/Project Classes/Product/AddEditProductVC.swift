//
//  AddEditProductViewController.swift
//  Sevenchats
//
//  Created by mac-00020 on 22/08/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

import Foundation
import UIKit
import ActiveLabel
import CoreLocation

enum ProductPaymentMode : Int{
    //(1=>offline,2=>online)
    case Offline = 1
    case Online
}

class AddEditProductVC: ParentViewController {
    
    //MARK: - IBOutlet/Object/Variable Declaration -
    
    @IBOutlet weak var collVMedia : SelectMediaCollectionView!
    
    @IBOutlet private weak var categoryDropDownView: CustomDropDownView!
    
    @IBOutlet private weak var subcategoryDropDownView: CustomDropDownView!
    
    @IBOutlet weak var lblMax5MediaUpload : MIGenericLabel!
    @IBOutlet weak var lblAboutProduct : MIGenericLabel!
    @IBOutlet weak var lblTermsAndCondition : ActiveLabel!
    @IBOutlet weak var lblTextLimit : MIGenericLabel!
    
    @IBOutlet weak var txtProductTitle : MIGenericTextFiled!
    
    @IBOutlet weak var txtLocation : MIGenericTextFiled!
    
    @IBOutlet weak var txtProductDesc : GenericTextView!{
        didSet{
            txtProductDesc.txtDelegate = self
        }
    }
    @IBOutlet weak var txtProductPrice : MIGenericTextFiled!{
        didSet{
            txtProductPrice.txtDelegate = self
        }
    }
    @IBOutlet weak var txtCurrencyList : MIGenericTextFiled!
//    @IBOutlet weak var txtLocation : GenericTextView!{
//        didSet{
//            self.txtLocation.txtDelegate = self
//            self.txtLocation.isScrollEnabled = true
//            self.txtLocation.textLimit = "200"
//        }
//    }
    @IBOutlet weak var txtLastDOP : MIGenericTextFiled!
    
    @IBOutlet weak var txtCountrys : MIGenericTextFiled!
    @IBOutlet weak var txtStates : MIGenericTextFiled!
    @IBOutlet weak var txtCitys : MIGenericTextFiled!
    
    @IBOutlet weak var collVHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var txtHeightLocation: NSLayoutConstraint!{
        didSet{
            self.txtHeightLocation.priority = UILayoutPriority(rawValue: 999.0)
            self.txtHeightLocation.constant = 80.0
        }
    }
    
    var arrCategory : [MDLProductCategory] = []
    var arrCurrency : [MDLCurrencies] = []
    var apiTask : URLSessionTask?
    var countryID : Int?
    var stateID : Int?
    var cityID : Int?
    var countryName:String?
    var stateName : String?
    var cityName : String?
    var categoryID : Int?
    var selectedCurrencyId: Int?
    var categoryName : String?
    var myeditStart:String?
    var isEditMode = false
    var selectedCurrencyName: String?
    var productImgEdit:String?
    var product : MDLProduct?
    fileprivate let lastSellingDateFormate = "yyyy-MM-dd"
    fileprivate let displaySellingDateFormate = "dd MMM, yyyy"
    var strSellingDate : String = ""
    var ImgName = ""
    var availableStatus = ""
    var prouductID = ""
    var apiTag = ""
    var userID = ""
    var currentPage : Int = 1
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    var isEdit = ""
    var categorysubName : String?
    var arrsubCategorys : [MDLProductSubCategory] = []
    var isedits = ""
    
    //MARK: - View life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBarButtonItems()
        self.setupView()
        self.intilization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.collVHeightConstraint.constant = collVMedia.contentSize.height + 10
    }
    
    //MARK: - Memory management methods
    deinit {
        print("### deinit -> AddEditProductVC")
    }
}

//MARK: - SetupUI
extension AddEditProductVC {
    
    func intilization() {
    let arrCategory = MIGeneralsAPI.shared().fetchproductCategoryFromLocalArticle()
    
    /// Set Dropdown on txtCategory
    categoryDropDownView.arrDataSource = arrCategory.map({ (obj) -> String in
        return (obj["product_category_type"] as? String ?? "")
    })
    
    /// On select text from the auto-complition
    categoryDropDownView.onSelectText = { [weak self] (item) in

        guard let `self` = self else { return }
        
        let objArry = arrCategory.filter({ (obj) -> Bool in
            return ((obj["product_category_type"] as? String) == item)
        })
        
        if (objArry.count > 0) {
            self.categoryName = (objArry.first?["product_category_type"] as? String) ?? ""
        }
            self.loadInterestList(interestType : self.categoryName ?? "" , showLoader : true)
    }
        /// On select text from the auto-complition
        subcategoryDropDownView.onSelectText = { [weak self] (item) in

            guard let `self` = self else { return }

            let objArry = self.arrsubCategorys.filter({ (obj) -> Bool in
                return ((obj.interestLevel1) == item)
            })

            if (objArry.count > 0) {
                self.categorysubName = (objArry.first?.interestLevel1) ?? ""
            }
        }
        
    }
    
    
    
    fileprivate func setupView() {
        
        self.isEditMode = (self.product != nil)
        
        self.collVMedia.isConfirmAlertOnDelete = self.isEditMode
        updateUIAccordingToLanguage()
        txtProductDesc.viewBottomLine.backgroundColor = .clear
        txtCurrencyList.text = ""
        self.setCurrenyList()
        txtLastDOP.setDatePickerMode(mode: .date)
        txtLastDOP.setMinimumDate(minDate: Date())
        txtLastDOP.setDatePickerWithDateFormate(dateFormate:displaySellingDateFormate, defaultDate: Date(), isPrefilledDate: false) { [weak self] (date) in
            guard let _ = self else {return}
            self?.setDate(date: date)
        }
        self.setProductInfo()
        self.getCurrencies()
        
    }
    
    fileprivate func addBarButtonItems() {
        
        let addMediaBarButtion = BlockBarButtonItem(image: UIImage(named: "ic_add_post"), style: .plain) { [weak self] (_) in
            guard let _ = self else {return}
            self?.resignKeyboard()
            if self?.isValideAllFileds() ?? false{
                print("Ready for post")
                self?.addEditProduct()
            }
        }
        self.navigationItem.rightBarButtonItems = [addMediaBarButtion]
    }
    
    fileprivate func setDate(date:Date){
        let formatter = DateFormatter()
        formatter.locale = DateFormatter.shared().locale
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: date)
        let strDate = formatter.date(from: myString)
        formatter.dateFormat = displaySellingDateFormate
        self.txtLastDOP.text = formatter.string(from: strDate!)
        self.strSellingDate = DateFormatter.dateStringFrom(timestamp: date.timeIntervalSince1970, withFormate: lastSellingDateFormate)
    }
    
    fileprivate func updateUIAccordingToLanguage(){
        
        if isEditMode{
            self.title = CEditProductDetails
        }else{
            self.title = CAddProductDetails
        }
        
        if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
            collVMedia.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }else{
            collVMedia.transform = CGAffineTransform.identity
        }
        
        lblMax5MediaUpload.text = CMax5MediaAllowedOf50MBEach
        lblAboutProduct.text = CAboutProduct
        categoryDropDownView.txtCategory.placeholder = CSelectProductCategory
        subcategoryDropDownView.txtCategory.placeholder = CSelectsubProductCategory
        txtProductTitle.placeHolder = CProductTitle
        txtProductTitle.textLimit = 200
        txtProductDesc.placeHolder = CProductDescription
        txtProductPrice.placeHolder = CProductPrice
        txtLastDOP.placeHolder = CLastDateOfProductSelling
        txtLocation.placeholder = CEventPlaceholderLocation
        txtProductPrice.textLimit = 15
        txtProductDesc.textLimit = "1500"
        lblTextLimit.text = "0/\(txtProductDesc.textLimit ?? "0")"
        txtCountrys.placeHolder = CCountryPlaceholder
        txtStates.placeHolder = CStatePlaceholder
        txtCitys.placeHolder = CCityPlaceholder
        configTermsAndConditionLabel()
        
        loadCountryList()
    }
    
    fileprivate func configTermsAndConditionLabel(){
        
        lblTermsAndCondition.configureLinkAttribute = { [weak self](type, attributes, isSelected) in
            guard let self = self else { return attributes}
            var attributes = attributes
            attributes[NSAttributedString.Key.font] = CFontPoppins(size: self.lblTermsAndCondition.font.pointSize, type: .meduim)
            return attributes
        }
        
        //..See More & See Less
        let customType1 = ActiveType.custom(pattern: "(\\s\(CSettingTermsAndConditions)\\b)|(\\s\(CSettingPrivacyPolicy)\\b)")
        lblTermsAndCondition.enabledTypes = [customType1]
        lblTermsAndCondition.customColor[customType1] = UIColor(hex: "a1b975") //.blue
        
        lblTermsAndCondition.text = CProductTermsAndConditionsText
        
        lblTermsAndCondition.handleCustomTap(for: customType1) { [weak self] (custom) in
            
            guard let self = self else {return}
            GCDMainThread.async {
                if custom == CSettingTermsAndConditions{
                    print(CSettingTermsAndConditions)
                    let cmsVC : AboutUsViewController = CStoryboardGeneral.instantiateViewController(withIdentifier: "AboutUsViewController") as! AboutUsViewController
                    cmsVC.cmsType = .termsAndConditions
                    self.navigationController?.pushViewController(cmsVC, animated: true)
                    
                }else if custom == CSettingPrivacyPolicy{
                    print(CSettingPrivacyPolicy)
                    let cmsVC : AboutUsViewController = CStoryboardGeneral.instantiateViewController(withIdentifier: "AboutUsViewController") as! AboutUsViewController
                    cmsVC.cmsType = .privacyPolicy
                    self.navigationController?.pushViewController(cmsVC, animated: true)
                }
            }
        }
    }
    
    func setCurrenyList(){
        let currencys = self.arrCurrency.compactMap({$0.currencyName})
        self.txtCurrencyList.setPickerData(arrPickerData: currencys as [Any], selectedPickerDataHandler: { [weak self](text, row, component) in
            guard let self = self else {return}
            
            if self.arrCurrency[row].currencyName != self.selectedCurrencyName && self.selectedCurrencyName != nil{
                //                self.txtProductPrice.text = ""
            }
            self.selectedCurrencyName = self.arrCurrency[row].currencyName
        }, defaultPlaceholder: "")
    }
    
    fileprivate func loadCountryList(){
        
        self.txtCountrys.isEnabled = true
        self.txtStates.isEnabled = false
        self.txtCitys.isEnabled = false
        
        self.showHideCountryStateCityFileds()
        
        let arrCountry = TblCountry.fetch(predicate: nil, orderBy: CCountryName, ascending: true)
        let arrCountryCode = arrCountry?.value(forKeyPath: "country_name") as? [Any]
        
        if (arrCountryCode?.count)! > 0 {
            
            txtCountrys.setPickerData(arrPickerData: arrCountryCode!, selectedPickerDataHandler: { [weak self] (select, index, component) in
                guard let self = self else { return }
                let dict = arrCountry![index] as AnyObject
                let countryName = dict.value(forKey: CCountryName) as? String
                if countryName != self.countryName {
                    self.countryName = dict.value(forKey: CCountryName) as? String
                    self.txtStates.text = ""
                    self.txtCitys.text = ""
                    self.stateID = nil
                    self.cityID = nil
                    self.txtStates.isEnabled = false
                    self.txtCitys.isEnabled = false
                    self.showHideCountryStateCityFileds()
                    self.loadStateList()
                }
            }, defaultPlaceholder: "")
        }
    }
    
    fileprivate func loadStateList(isCancelTask:Bool = true) {
        
        func setStateList(arrState:[MDLState]){
            let states = arrState.compactMap({$0.stateName})
            self.txtStates.setPickerData(arrPickerData: states as [Any], selectedPickerDataHandler: { [weak self](text, row, component) in
                guard let self = self else {return}
                if arrState[row].stateName != self.stateName{
                    self.stateName = arrState[row].stateName
                    self.txtCitys.isEnabled = false
                    self.txtCitys.text = ""
                    self.showHideCountryStateCityFileds()
                    self.loadCityList()
                }
                
            }, defaultPlaceholder: "")
        }
        if apiTask?.state == URLSessionTask.State.running && isCancelTask {
            apiTask?.cancel()
        }
        //...Load country list from server
        let timestamp : TimeInterval = 0
        
        apiTask = APIRequest.shared().stateList(timestamp: timestamp as AnyObject, countryID: self.countryName ?? "") { [weak self] (response, error) in
            guard let self = self else {return}
            if response != nil && error == nil {
                DispatchQueue.main.async {
                    let arrData = response![CData] as? [[String : Any]] ?? []
                    var arrState : [MDLState] = []
                    for obj in arrData{
                        arrState.append(MDLState(fromDictionary: obj))
                    }
                    if arrState.isEmpty{
                        arrState.append(MDLState(fromDictionary: ["state_name":" "]))
                        self.stateID = 0
                        self.cityID = 0
                        self.txtStates.isEnabled = false
                        self.txtCitys.isEnabled = false
                        self.txtStates.text = ""
                        self.txtCitys.text = ""
                    }else{
                        self.txtStates.isEnabled = true
                    }
                    self.showHideCountryStateCityFileds()
                    setStateList(arrState: arrState)
                }
            }
        }
    }
    
    
    fileprivate func loadCityList(isCancelTask:Bool = true) {
        
        func setCityList(arrCity:[MDLCity]){
            let states = arrCity.compactMap({$0.cityName})
            self.txtCitys.setPickerData(arrPickerData: states as [Any], selectedPickerDataHandler: { [weak self](text, row, component) in
                guard let self = self else {return}
                self.cityName = arrCity[row].cityName
            }, defaultPlaceholder: "")
        }
        if apiTask?.state == URLSessionTask.State.running && isCancelTask {
            apiTask?.cancel()
        }
        //...Load country list from server
        let timestamp : TimeInterval = 0
        apiTask = APIRequest.shared().cityList(timestamp: timestamp as AnyObject, stateId: self.stateName ?? "") { [weak self] (response, error) in
            guard let self = self else {return}
            if response != nil && error == nil {
                DispatchQueue.main.async {
                    let arrData = response![CData] as? [[String : Any]] ?? []
                    var arrCity : [MDLCity] = []
                    for obj in arrData{
                        arrCity.append(MDLCity(fromDictionary: obj))
                    }
                    if arrCity.isEmpty{
                        arrCity.append(MDLCity(fromDictionary: ["city_name":" "]))
                        self.cityID = 0
                        self.txtCitys.isEnabled = false
                        self.txtCitys.text = ""
                    }else{
                        self.txtCitys.isEnabled = true
                    }
                    self.showHideCountryStateCityFileds()
                    setCityList(arrCity: arrCity)
                }
            }
        }
    }
    /// This method is called on change country, state and city.
    /// It will hide the textfiled If no data found of country, state and city.
    fileprivate func showHideCountryStateCityFileds(){
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, animations: {
                if !self.txtStates.isEnabled{
                    self.txtStates.superview?.alpha = 0
                }else{
                    self.txtStates.superview?.alpha = 1
                }
                if !self.txtCitys.isEnabled{
                    self.txtCitys.superview?.alpha = 0
                }else{
                    self.txtCitys.superview?.alpha = 1
                }
            }, completion: { (_) in
                self.txtStates.superview?.isHidden = !self.txtStates.isEnabled
                self.txtCitys.superview?.isHidden = !self.txtCitys.isEnabled
            })
        }
    }
    
    /// Set the old data while editing product details.
    fileprivate func setProductInfo(){
        
        guard let _product = self.product else { return }
        self.isEditMode = true
        self.title = CEditProductDetails
        self.collVMedia.isConfirmAlertOnDelete = self.isEditMode
        self.countryName = _product.countryName
        self.stateName = _product.stateName
        self.cityName = _product.cityName
        
        self.txtCountrys.text = _product.countryName
        self.txtStates.text = _product.stateName
        self.txtCitys.text = _product.cityName
        
        self.txtCountrys.isEnabled = !_product.countryName.isEmpty
        self.txtStates.isEnabled = !_product.stateName.isEmpty
        self.txtCitys.isEnabled = !_product.cityName.isEmpty
        
        if (self.stateID ?? 0) != 0{
            self.loadStateList(isCancelTask: false)
        }
        if (self.cityID ?? 0) != 0{
            self.loadCityList(isCancelTask: false)
        }
        self.txtLocation.text = _product.address
        
        categoryDropDownView.txtCategory.text = _product.category
        subcategoryDropDownView.txtCategory.text = _product.productsubCategroy
        self.categoryID = _product.categoryId
        
        self.txtProductTitle.text = _product.productTitle
        self.txtProductDesc.text = _product.productDescription
        self.txtProductPrice.text = _product.productPrice.description
        self.txtCurrencyList.text = _product.currencyName
        self.selectedCurrencyName = _product.currencyName
        let date = Date.init(timeIntervalSince1970: Double(_product.lastDateSelling) ?? 0.0)
        self.setDate(date: date)
        self.availableStatus = _product.productState
        self.prouductID = _product.productID ?? ""
        let productimage = _product.galleyimagesArray as? String
        self.productImgEdit = productimage
        self.collVMedia.arrMedia = _product.galleryImages
        self.collVMedia.reloadData()
        
        DispatchQueue.main.async {
            self.lblTextLimit.text = "\(_product.productDescription.count)/\(self.txtProductDesc.textLimit ?? "0")"
            self.showHideCountryStateCityFileds()
            self.txtProductTitle.updatePlaceholderFrame(true)
            self.txtProductDesc.updatePlaceholderFrame(true)
            self.txtProductPrice.updatePlaceholderFrame(true)
            self.txtCurrencyList.updatePlaceholderFrame(true)
            self.txtLastDOP.updatePlaceholderFrame(true)
            self.txtCountrys.updatePlaceholderFrame(true)
            self.txtStates.updatePlaceholderFrame(true)
            self.txtCitys.updatePlaceholderFrame(true)
            self.txtLocation.updatePlaceholderFrame(true)
            self.txtLocation.layoutIfNeeded()
        }
    }
    
    
    fileprivate func isValideAllFileds() -> Bool{
        
        func displayAlertMessage(meesage:String){
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: meesage, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }
        
        if collVMedia.arrMedia.isEmpty{
            displayAlertMessage(meesage: CAddAtLeastOneProductVideoOrImage)
            return false
        }
        if (categoryDropDownView.txtCategory.text ?? "").trim.isEmpty {
            displayAlertMessage(meesage: CSelectCategoryOfProduct)
            return false
        }
        if (subcategoryDropDownView.txtCategory.text ?? "").trim.isEmpty {
            displayAlertMessage(meesage: CSelectCategoryOfProduct)
            return false
        }
        
        if (txtProductTitle.text ?? "").trim.isEmpty {
            displayAlertMessage(meesage: CBlankProductTitle)
            return false
        }
        if (txtProductDesc.text ?? "").trim.isEmpty {
            displayAlertMessage(meesage: CBlankProductDescription)
            return false
        }
        if (txtProductPrice.text ?? "").trim.isEmpty {
            displayAlertMessage(meesage:CBlankProductPrice)
            return false
        }
        if (txtLastDOP.text ?? "").trim.isEmpty {
            displayAlertMessage(meesage:CBlankLastDateOfProductSelling)
            return false
        }
        if (txtLocation.text ?? "").trim.isEmpty {
            displayAlertMessage(meesage:CBlankProductLocation)
            return false
        }
        return true
    }
}

//MARK: - IBAction / Selector
extension AddEditProductVC {
    
    /// On tap on payment button
    /// - Parameter sender: btnPayment
    @IBAction func onOnlineOfflinePayment(_ sender : UIButton){
    }
}

// MARK:-  --------- Generic UITextView Delegate
extension AddEditProductVC: GenericTextViewDelegate{
    
    func genericTextViewDidChange(_ textView: UITextView, height: CGFloat){
        
        if textView == txtProductDesc{
            lblTextLimit.text = "\(textView.text.count)/\(txtProductDesc.textLimit ?? "0")"
        }
    }
    
    func genericTextView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
}

//MARK: - GenericTextFieldDelegate
extension AddEditProductVC : GenericTextFieldDelegate{
    
    func genericTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        if textField == txtProductPrice{
            if string.isBlank{
                return true
            }
            guard let text = textField.text,
                  let textRange = Range(range, in: text) else{
                return true
            }
            let updatedText = text.replacingCharacters(in: textRange,with: string)
            guard let _ = Int(updatedText) else {return false}
        }
        return true
    }
}

//MARK: - API Function
extension AddEditProductVC {
    
    fileprivate func getCurrencies(){
        self.arrCurrency.removeAll()
        APIRequest.shared().getCurrenciesList(showLoader: true){ [weak self](response, error) in
            if response != nil {
                GCDMainThread.async {
                    let arrData = response![CData] as? [[String : Any]] ?? []
                    for obj in arrData{
                        self?.arrCurrency.append(MDLCurrencies(fromDictionary: obj))
                    }
                    self?.setCurrenyList()
                    if !(self?.arrCurrency.isEmpty ?? true){
                        self?.txtCurrencyList.text = self?.arrCurrency[0].currencyName ?? ""
                        
                    }
                }
            }
        }
    }
    
    func addEditProduct(){
        var dict = [String:Any]()
        var apiURL = CAddEditProduct
        var currencyName = ""
        guard let userId = appDelegate.loginUser?.user_id else { return }
        let userID = userId.description
        guard let firstName = appDelegate.loginUser?.first_name else { return }
        guard let lastName = appDelegate.loginUser?.last_name else { return }
        guard let email = appDelegate.loginUser?.email else { return }
        
        if self.selectedCurrencyName != nil {
            currencyName = self.selectedCurrencyName ?? ""
        }else{
            currencyName = txtCurrencyList.text ?? ""
        }
        if myeditStart == "editCLK"{
            var repl = ""
            repl = (productImgEdit?.replacingOccurrences(of: "\"", with: "\\\""))!
            print(repl)
            
            do {
                let data = try JSONEncoder().encode(self.collVMedia.arrImagesVideo)
                let string = String(data: data, encoding: .utf8)!
                
                print("string\(string)")
                let replaced2 = string.replacingOccurrences(of: "\"{", with: "{")
                let replaced3 = replaced2.replacingOccurrences(of: "}\"", with: "}")
                let replaced4 = replaced3.replacingOccurrences(of: "\\/\\/", with: "//")
                let replaced5 = replaced4.replacingOccurrences(of: "\\/", with: "/")
                ImgName = replaced5
                
            } catch { print(error) }
            
            let changeStr = repl.appending(ImgName)
            let replac = changeStr.replacingOccurrences(of: "][", with: ",")
            let txtproductDesc = self.txtProductDesc.text.replace(string: "\n", replacement: "\\n")
            apiTag = CEditProductNew
            dict = [
                "product_id": prouductID,
                "category_name":categoryDropDownView.txtCategory.text ?? "",
                "category_level1":subcategoryDropDownView.txtCategory.text ?? "",
                "product_image":replac as Any,
                "product_title":self.txtProductTitle.text?.trim ?? "",
                "description":txtproductDesc,
                "available_status":availableStatus,
                "cost":self.txtProductPrice.text ?? "0",
                "currency_name":currencyName,
                "last_date_selling":self.strSellingDate,
                "location":self.txtLocation.text ?? "",
                "latitude":"60",
                "longitude":"80",
                "status_id":"1",
                "address_line1":""
            ]
            if (userID ) != ""{
                dict["user_id"] = userID
            }
            if (cityName ?? "") != ""{
                dict["city_name"] = self.cityName!
            }
            var _arrMedia = self.collVMedia.arrMedia
            if let _product = self.product{
                // When user editing the article....
                apiURL = apiTag + "/" + _product.id.description
                let deletedIDS = self.collVMedia.arrDeletedApiImages.map({$0}).joined(separator: ",")
                _arrMedia = self.collVMedia.arrMedia.filter({$0.uploadMediaStatus != .Succeed})
            }
            
            APIRequest.shared().EditProduct(apiTag: CEditProductNew, dict:dict, arrMedia: _arrMedia, showLoader: true) { [weak self] (response, error) in
                guard let self = self else { return }
                if response != nil && error == nil{
                    var message = CProductHasBeenCreated
                    if self.product != nil {
                        message = CProductHasBeenUpdate
                        let data = response![CData] as? [String : Any] ?? [:]
                        let productObj = MDLProduct(fromDictionary: data)
                        ProductHelper<UIViewController>.updateProduct(
                            product: productObj,
                            controller: self.viewController,
                            refreshCnt:  [StoreListVC.self,ProductSearchVC.self, ProductDetailVC.self]
                        )
                    }else{
                        ProductHelper.createProduct(controller: self, refreshCnt: [StoreListVC.self])
                    }
                    //  self.navigationController?.popToRootViewController(animated: true)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadder"), object: nil)
                    self.navigationController?.popViewController(animated: true)
                    CTopMostViewController.presentAlertViewWithOneButton(alertTitle: "", alertMessage: message, btnOneTitle: CBtnOk, btnOneTapped: nil)
                }
            }
        }else{
            do {
                let data = try JSONEncoder().encode(self.collVMedia.arrImagesVideo)
                let string = String(data: data, encoding: .utf8)!
                
                print("string\(string)")
                let replaced2 = string.replacingOccurrences(of: "\"{", with: "{")
                let replaced3 = replaced2.replacingOccurrences(of: "}\"", with: "}")
                let replaced4 = replaced3.replacingOccurrences(of: "\\/\\/", with: "//")
                let replaced5 = replaced4.replacingOccurrences(of: "\\/", with: "/")
                
                ImgName = replaced5
                
            } catch { print(error) }
            
            if self.selectedCurrencyName != nil {
                currencyName = self.selectedCurrencyName ?? ""
            }else{
                currencyName = txtCurrencyList.text ?? ""
            }
            let txtproductDesc = self.txtProductDesc.text.replace(string: "\n", replacement: "\\n")
            apiTag = CAddProductNew
            dict = [
                "user_first_name": firstName,
                "user_last_name": lastName,
                "user_email": email,
                "category_name":categoryDropDownView.txtCategory.text ?? "",
                "category_level1":subcategoryDropDownView.txtCategory.text ?? "",
                "product_image":ImgName,
                "product_title":self.txtProductTitle.text?.trim ?? "",
                "description":txtproductDesc,
                "available_status":"1",
                "cost":self.txtProductPrice.text ?? "0",
                "currency_name":currencyName,
                "last_date_selling":self.strSellingDate,
                "location":self.txtLocation.text ?? "",
                "latitude":latitude,
                "longitude":longitude,
                "status_id":"1",
                "address_line1":""
            ]
            
            if (userID ) != ""{
                //            dict["user_id"] = self.userID
                dict["user_id"] = userID
            }
            if (cityName ?? "") != ""{
                dict["city_name"] = self.cityName!
            }
            var _arrMedia = self.collVMedia.arrMedia
            if let _product = self.product{
                // When user editing the article....
                apiURL = apiTag + "/" + _product.id.description
                let deletedIDS = self.collVMedia.arrDeletedApiImages.map({$0}).joined(separator: ",")
                //                body["delete_ids"] = deletedIDS
                _arrMedia = self.collVMedia.arrMedia.filter({$0.uploadMediaStatus != .Succeed})
            }
            APIRequest.shared().addEditProduct(apiTag: CAddProductNew, dict:dict, arrMedia: _arrMedia, showLoader: true) { [weak self] (response, error) in
                guard let self = self else { return }
                if response != nil && error == nil{
                    if let metaInfo = response![CJsonMeta] as? [String : Any] {
                        let name = (appDelegate.loginUser?.first_name ?? "") + " " + (appDelegate.loginUser?.last_name ?? "")
                        guard let image = appDelegate.loginUser?.profile_img else { return }
                        let stausLike = metaInfo["status"] as? String ?? "0"
                        if stausLike == "0" {
                            
                            MIGeneralsAPI.shared().addRewardsPoints(CPostonstore,message:"Post_on_store",type:CPostonstore,title:"Post on store",name:name,icon:image)
                        }
                    }
                    
                    var message = CProductHasBeenCreated
                    if self.product != nil {
                        message = CProductHasBeenUpdate
                        let data = response![CData] as? [String : Any] ?? [:]
                        let productObj = MDLProduct(fromDictionary: data)
                        ProductHelper<UIViewController>.updateProduct(
                            product: productObj,
                            controller: self,
                            refreshCnt:  [StoreListVC.self,ProductSearchVC.self, ProductDetailVC.self]
                        )
                    }else{
                        ProductHelper.createProduct(controller: self, refreshCnt: [StoreListVC.self])
                    }
                    //  self.navigationController?.popToRootViewController(animated: true)
                    
                    self.navigationController?.popViewController(animated: true)
                    CTopMostViewController.presentAlertViewWithOneButton(alertTitle: "", alertMessage: message, btnOneTitle: CBtnOk, btnOneTapped: nil)
                }
            }
            
        }
    }
    fileprivate func getProductCategory(isLoader : Bool = true){
        
        let _ = APIRequest.shared().productCategoriesList(searchText: "",showLoader: isLoader) { [weak self](response, error) in
            
            guard let self = self else { return }
            self.arrCategory.removeAll()
            if response != nil {
                GCDMainThread.async {
                    let arrData = response![CData] as? [[String : Any]] ?? []
                    for obj in arrData{
                        self.arrCategory.append(MDLProductCategory(fromDictionary: obj))
                    }
                    self.categoryDropDownView.txtCategory.isEnabled = true
                    let arrCategory = self.arrCategory.compactMap({$0.categoryName})
                    
                    self.categoryDropDownView.arrDataSource = arrCategory.sorted()
                    
                    /// On select text from the auto-complition
                    self.categoryDropDownView.onSelectText = { [weak self] (item) in
                        
                        guard let `self` = self else { return }
                        
                        let objArry = self.arrCategory.filter({ (obj) -> Bool in
                            return (obj.categoryName == item)
                        })
                        
                        if (objArry.count > 0) {
                            self.categoryID = objArry.first?.categoryId.toInt
                        }
                    }
                }
            }
        }
    }
}

extension AddEditProductVC{
    
    func loadInterestList(interestType : String, showLoader : Bool) {

        if apiTask?.state == URLSessionTask.State.running {
            return
        }
        guard let langName = appDelegate.loginUser?.lang_name else {return}

        apiTask = APIRequest.shared().getInterestSubListNew(langName : langName,interestType:interestType, page: currentPage, showLoader : showLoader) { (response, error) in
            self.arrsubCategorys.removeAll()
            if response != nil && error == nil {
                if let arrData = response![CJsonData] as? [[String : Any]]
                {
                    for obj in arrData{
                        self.arrsubCategorys.append(MDLProductSubCategory(fromDictionary: obj))
                    }

                    self.subcategoryDropDownView.arrDataSource = self.arrsubCategorys.map({ (obj) -> String in
                        return (obj.interestLevel1 ?? "")
                    })

                }
            }
        }
    }
    
    
}


extension AddEditProductVC{

@IBAction func btnSelectLocationCLK(_ sender : UIButton){
    
    guard let locationPicker = CStoryboardLocationPicker.instantiateViewController(withIdentifier: "LocationPickerVC") as? LocationPickerVC else {
        return
    }
    locationPicker.prefixLocation = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    locationPicker.showCurrentLocationButton = true
    locationPicker.completion = { [weak self] (placeDetail) in
        guard let self = self else { return }
        
        self.txtLocation.text = placeDetail?.formattedAddress
        self.latitude = placeDetail?.coordinate?.latitude ?? 0.0
        self.longitude = placeDetail?.coordinate?.longitude ?? 0.0
    }
    self.navigationController?.pushViewController(locationPicker, animated: true)
  
}
}
