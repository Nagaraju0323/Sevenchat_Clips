//
//  ExtensionUITextField.swift
//  Swifty_Master
//
//  Created by Mac-0002 on 26/08/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import Foundation
import UIKit

// TODO :- Delegate Issue

// MARK: - Extension of UITextField For UITextField's placeholder Color.
extension UITextField {
    
    /// Placeholder Color of UITextField , as it is @IBInspectable so you can directlly set placeholder color of UITextField From Interface Builder , No need to write any number of Lines.
    @IBInspectable var placeholderColor:UIColor?  {
        
        get  {
            return self.placeholderColor
        } set {
            
            if let newValue = newValue {
                self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "" , attributes: [NSAttributedString.Key.foregroundColor:newValue])
            }
        }
    }
    
}

// MARK: - Extension of UITextField For Adding Left & Right View For UITextField.
extension UITextField {
    /// This method is used to add a leftView of UITextField.
    ///
    /// - Parameters:
    ///   - strImgName: String value - Pass the Image name.
    ///   - leftPadding: CGFloat value - (Optional - so you can pass nil if you don't want any spacing from left side) OR pass how much spacing you want from left side.
    func addLeftImageAsLeftView(strImgName:String? , leftPadding:CGFloat?) {
        
        let leftView = UIImageView()
        if let imgName = strImgName {
            leftView.image = UIImage(named: imgName)
        }
        
        leftView.frame = CGRect(x: 0.0, y: 0.0, width: (((leftView.image?.size.width) ?? 0.0) + (leftPadding ?? 0.0)), height: ((leftView.image?.size.height ?? 0.0)))
        
        leftView.contentMode = .center
        
        self.leftViewMode = .always
        self.leftView = leftView
    }
    
    /// This method is used to add a rightView of UITextField.
    ///
    /// - Parameters:
    ///   - strImgName: String value - Pass the Image name.
    ///   - rightPadding: CGFloat value - (Optional - so you can pass nil if you don't want any spacing from right side) OR pass how much spacing you want from right side.
    func addRightImageAsRightView(strImgName:String? , rightPadding:CGFloat?) {
        
        let rightView = UIImageView()
        if let imgName = strImgName {
            rightView.image = UIImage(named: imgName)
        }
        
        rightView.frame = CGRect(x: 0.0, y: 0.0, width: (((rightView.image?.size.width) ?? 0.0) + (rightPadding ?? 0.0)), height: ((rightView.image?.size.height ?? 0.0)))
        
        rightView.contentMode = .center
        
        self.rightViewMode = .always
        self.rightView = rightView
    }
}

typealias selectedDateHandler = ((Date) -> ())

// MARK: - Extension of UITextField For DatePicker as UITextField's inputView.
extension UITextField {
    
    /// This Private Structure is used to create all AssociatedObjectKey which will be used within this extension.
    fileprivate struct AssociatedObjectKey {
        
        static var txtFieldDatePicker = "txtFieldDatePicker"
        static var datePickerDateFormatter = "datePickerDateFormatter"
        static var selectedDateHandler = "selectedDateHandler"
        static var defaultDate = "defaultDate"
        static var isPrefilledDate = "isPrefilledDate"
    }
    
    /// A Computed Property of UIDatePicker , If its already in memory then return it OR not then create new one and store it in memory reference.
    fileprivate var txtFieldDatePicker:UIDatePicker? {
        
        if let txtFieldDatePicker = objc_getAssociatedObject(self, &AssociatedObjectKey.txtFieldDatePicker) as? UIDatePicker {
            
            return txtFieldDatePicker
        } else {
            return self.addDatePicker()
        }
    }
    
    /// A Private method used to create a UIDatePicker and store it in a memory reference.
    ///
    /// - Returns: return a newly created UIDatePicker.
    private func addDatePicker() -> UIDatePicker {
        
        let txtFieldDatePicker = UIDatePicker()
//        self.inputView = txtFieldDatePicker
        
        txtFieldDatePicker.calendar = Calendar(identifier: .gregorian)
        txtFieldDatePicker.calendar.locale = DateFormatter.shared().locale
        txtFieldDatePicker.locale = DateFormatter.shared().locale
        txtFieldDatePicker.addTarget(self, action: #selector(self.handleDateSelection(sender:)), for: .valueChanged)
        
        objc_setAssociatedObject(self, &AssociatedObjectKey.txtFieldDatePicker, txtFieldDatePicker, .OBJC_ASSOCIATION_RETAIN)
        
//        self.inputAccessoryView = self.addToolBar()
//        self.tintColor = .clear
        
        return txtFieldDatePicker
    }
    
    /// A Computed Property of DateFormatter , If its already in memory then return it OR not then create new one and store it in memory reference.
    fileprivate var datePickerDateFormatter:DateFormatter? {
        
        if let datePickerDateFormatter = objc_getAssociatedObject(self, &AssociatedObjectKey.datePickerDateFormatter) as? DateFormatter {
            datePickerDateFormatter.calendar = Calendar(identifier: .gregorian)
            datePickerDateFormatter.locale = DateFormatter.shared().locale
            return datePickerDateFormatter
        } else {
            return self.addDatePickerDateFormatter()
        }
    }
    
    /// A Private methos used to create a DateFormatter and store it in a memory reference.
    ///
    /// - Returns: return a newly created DateFormatter.
    private func addDatePickerDateFormatter() -> DateFormatter {
        
        let datePickerDateFormatter = DateFormatter()
        datePickerDateFormatter.locale = DateFormatter.shared().locale
        datePickerDateFormatter.calendar = Calendar(identifier: .gregorian)
        objc_setAssociatedObject(self, &AssociatedObjectKey.datePickerDateFormatter, datePickerDateFormatter, .OBJC_ASSOCIATION_RETAIN)
        
        return datePickerDateFormatter
    }
    
    /// A Private method used to handle the date selection event everytime when value changes from UIDatePicker.
    ///
    /// - Parameter sender: UIDatePicker - helps to trach the selected date from UIDatePicker
    @objc private func handleDateSelection(sender:UIDatePicker) {
        
        self.text = self.datePickerDateFormatter?.string(from: sender.date)
        
        objc_setAssociatedObject(self, &AssociatedObjectKey.defaultDate, sender.date, .OBJC_ASSOCIATION_RETAIN)
        
        if let selectedDateHandler = objc_getAssociatedObject(self, &AssociatedObjectKey.selectedDateHandler) as? selectedDateHandler {
            
            selectedDateHandler(sender.date)
        }
    }
    
    /// This method is used to set the UIDatePickerMode.
    ///
    /// - Parameter mode: Pass the value of Enum(UIDatePickerMode).
    func setDatePickerMode(mode:UIDatePicker.Mode) {
        self.txtFieldDatePicker?.datePickerMode = mode
    }
    
    /// This method is used to set the maximumDate of UIDatePicker.
    ///
    /// - Parameter maxDate: Pass the maximumDate you want to see in UIDatePicker.
    func setMaximumDate(maxDate:Date) {
        self.txtFieldDatePicker?.maximumDate = maxDate
    }
    
    /// This method is used to set the minimumDate of UIDatePicker.
    ///
    /// - Parameter minDate: Pass the minimumDate you want to see in UIDatePicker.
    func setMinimumDate(minDate:Date) {
        self.txtFieldDatePicker?.minimumDate = minDate
    }
    
    /// This method is used to set the (DateFormatter.Style).
    ///
    /// - Parameter dateStyle: Pass the value of Enum(DateFormatter.Style).
    func setDateFormatterStyle(dateStyle:DateFormatter.Style) {
        self.datePickerDateFormatter?.dateStyle = dateStyle
    }
    
    /// This method is used to enable the UIDatePicker into UITextField. Before using this method you can use another methods for set the UIDatePickerMode , maximumDate , minimumDate & dateFormat) , it will help you to see proper UIDatePickerMode , maximumDate , minimumDate etc into UIDatePicker.
    ///
    /// - Parameters:
    ///   - dateFormate: A String Value used to set the dateFormat you want.
    ///   - defaultDate: A Date? (optional - you can pass@objc  nil if you don't want any defualt value) Or pass proper date which will behave like it is already selected from UIDatePicker(you can see this date into UIDatePicker First when UIDatePicker present).
    ///   - isPrefilledDate: A Bool value will help you to prefilled the UITextField with Default Value when UIDatePicker Present.
    ///   - selectedDateHandler: A Handler Block returns a selected date.
    func setDatePickerWithDateFormate(dateFormate:String , defaultDate:Date? , isPrefilledDate:Bool , selectedDateHandler:@escaping selectedDateHandler) {
        
        self.inputView = self.txtFieldDatePicker
        
        self.setDateFormate(dateFormat: dateFormate)
        
        objc_setAssociatedObject(self, &AssociatedObjectKey.selectedDateHandler, selectedDateHandler, .OBJC_ASSOCIATION_RETAIN)
        
        objc_setAssociatedObject(self, &AssociatedObjectKey.defaultDate, defaultDate, .OBJC_ASSOCIATION_RETAIN)
        
        objc_setAssociatedObject(self, &AssociatedObjectKey.isPrefilledDate, isPrefilledDate, .OBJC_ASSOCIATION_RETAIN)
        
        if let date = defaultDate {
            self.txtFieldDatePicker?.date = date
        }
        
        if let txtField = self as? MIGenericTextFiled // GenericTextField Delegate
        {
            txtField.txtDelegate = self
        }else{
            self.delegate = self
        }
        
    }
    
    /// A Private method is used to set the dateFormat of UIDatePicker.
    ///
    /// - Parameter dateFormat: A String Value used to set the dateFormatof UIDatePicker.
    private func setDateFormate(dateFormat:String) {
        self.datePickerDateFormatter?.dateFormat = dateFormat
    }
    
    /// A fileprivate method is used to add a UIToolbar above UIDatePicker. This UIToolbar contain only one UIBarButtonItem(Done).
    ///
    /// - Returns: return newly created UIToolbar
    fileprivate func addToolBar() -> UIToolbar {
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: CScreenWidth, height: 44.0))
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        let btnDone = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.btnDoneTapped(sender:)))
        
        toolBar.setItems([flexibleSpace , btnDone], animated: true)
        
        return toolBar
    }
    
    /// A Private method used to handle the touch event of button Done(A UIToolbar Button).
    ///
    /// - Parameter sender: UIBarButtonItem
    @objc private func btnDoneTapped(sender:UIBarButtonItem) {
        self.resignFirstResponder()
    }
    
}

typealias selectedPickerDataHandler = ((_ text:String , _ row:Int , _ component:Int) -> ())

extension UITextField : UIPickerViewDataSource , UIPickerViewDelegate {
    
    fileprivate struct AssociatedObjectKeyTwo {
        static var txtFieldPickerView = "txtFieldPickerView"
        static var selectedPickerDataHandler = "selectedPickerDataHandler"
        static var arrPickerData = "arrPickerData"
    }
    
    var txtFieldPickerView:UIPickerView? {
        
        if let txtFieldPickerView = objc_getAssociatedObject(self, &AssociatedObjectKeyTwo.txtFieldPickerView) as? UIPickerView {
            
            return txtFieldPickerView
        } else {
            return self.addPickerView()
        }
    }
    
    private func addPickerView() -> UIPickerView {
        
        let txtFieldPickerView = UIPickerView()
        
        txtFieldPickerView.dataSource  = self
        txtFieldPickerView.delegate  = self
        
//        self.inputView = txtFieldPickerView
        
        objc_setAssociatedObject(self, &AssociatedObjectKeyTwo.txtFieldPickerView, txtFieldPickerView, .OBJC_ASSOCIATION_RETAIN)
        
        self.inputAccessoryView = self.addToolBar()
//        self.tintColor = .clear
        
        return txtFieldPickerView
    }
    
    fileprivate var arrPickerData:[Any]? {
        
        get {
            
            if let arrPickerData = objc_getAssociatedObject(self, &AssociatedObjectKeyTwo.arrPickerData) as? [Any] {
                
                return arrPickerData
            }
            return nil
        }
    }
    
    func setPickerData(arrPickerData:[Any] , selectedPickerDataHandler:@escaping selectedPickerDataHandler , defaultPlaceholder:String?) {
        
        self.inputView = txtFieldPickerView
        self.setUpArrPickerData(arrPickerData: arrPickerData, defaultPlaceholder: defaultPlaceholder)

        objc_setAssociatedObject(self, &AssociatedObjectKeyTwo.selectedPickerDataHandler, selectedPickerDataHandler, .OBJC_ASSOCIATION_RETAIN)
        
        if let txtField = self as? MIGenericTextFiled // GenericTextField Delegate
        {
            txtField.txtDelegate = self
        }else{
            self.delegate = self
        }
    }
    
    func setPickerData(arrPickerData:[Any] , key : String?, selectedPickerDataHandler:@escaping selectedPickerDataHandler , defaultPlaceholder:String?) {
        
        self.inputView = txtFieldPickerView
        var arrPicker = [[String : Any]]()
        var arrPickerValue = [Any]()
        if key != nil && !(key?.isBlank)!{
            arrPicker = (arrPickerData as? [[String : Any]])!
            let keys = arrPicker.map({$0[key!] as? String})
            arrPickerValue = keys as [Any]
        }
        
        self.setUpArrPickerData(arrPickerData: arrPickerValue, defaultPlaceholder: defaultPlaceholder)
        
        objc_setAssociatedObject(self, &AssociatedObjectKeyTwo.selectedPickerDataHandler, selectedPickerDataHandler, .OBJC_ASSOCIATION_RETAIN)
        
        if let txtField = self as? MIGenericTextFiled // GenericTextField Delegate
        {
            txtField.txtDelegate = self
        }else{
            self.delegate = self
        }
    }
    
    private func setUpArrPickerData(arrPickerData:[Any] , defaultPlaceholder:String?) {
        
        objc_setAssociatedObject(self, &AssociatedObjectKeyTwo.arrPickerData, arrPickerData, .OBJC_ASSOCIATION_RETAIN)
        
        txtFieldPickerView?.reloadAllComponents()
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrPickerData?.count ?? 0
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return "\(arrPickerData?[row] ?? "")"
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if (arrPickerData?.isEmpty ?? true) { return }
        
        self.text = "\(arrPickerData?[row] ?? "")"
        
        if let selectedPickerDataHandler = objc_getAssociatedObject(self, &AssociatedObjectKeyTwo.selectedPickerDataHandler) as? selectedPickerDataHandler {
            
            selectedPickerDataHandler(self.text ?? "", row, component)
        }
    }
}

extension UITextField  {
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        
        if let inputView = self.inputView, (inputView is UIDatePicker || inputView is UIPickerView) {
            if action == #selector(UIResponderStandardEditActions.paste(_:)) ||
                action == #selector(UIResponderStandardEditActions.cut(_:)) {
                return false
            }
        }
        
        return super.canPerformAction(action, withSender: sender)
    }
}
extension UITextField : GenericTextFieldDelegate {
     func genericTextFieldDidBeginEditing(_ textField: UITextField){
        self.udpatePickerInitially(textField)
    }
}

extension UITextField : UITextFieldDelegate {

    /// Delegate method of UITextFieldDelegate.
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        self.udpatePickerInitially(textField)
    }
    
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
}

extension UITextField{
    public func udpatePickerInitially(_ textField: UITextField) {
        if let _ = self.inputView as? UIDatePicker {
            
            if let isPrefilledDate = objc_getAssociatedObject(self, &AssociatedObjectKey.isPrefilledDate) as? Bool {
                
                if isPrefilledDate {
                    
                    if let defaultDate = objc_getAssociatedObject(self, &AssociatedObjectKey.defaultDate) as? Date {
                        
                        self.txtFieldDatePicker?.date = defaultDate
                        
                        self.text = self.datePickerDateFormatter?.string(from: defaultDate)
                    }
                }
            }
            
        } else if let _ = self.inputView as? UIPickerView {
            
            if let arrPickerData = arrPickerData {
                
                if let index = arrPickerData.index(where: {($0 as? String) == textField.text}) {
                    
                    self.text = "\(arrPickerData[index])"
                    
                    txtFieldPickerView?.selectRow(index, inComponent: 0, animated: false)
                    
                    if let selectedPickerDataHandler = objc_getAssociatedObject(self, &AssociatedObjectKeyTwo.selectedPickerDataHandler) as? selectedPickerDataHandler {
                        
                        selectedPickerDataHandler(self.text ?? "", index, 0)
                    }
                    
                } else {
                    if arrPickerData.isEmpty{
                        self.text = ""
                        return
                    }
                    self.text = "\(arrPickerData[0])"
                    
                    txtFieldPickerView?.selectRow(0, inComponent: 0, animated: false)
                    
                    if let selectedPickerDataHandler = objc_getAssociatedObject(self, &AssociatedObjectKeyTwo.selectedPickerDataHandler) as? selectedPickerDataHandler {
                        
                        selectedPickerDataHandler(self.text ?? "", 0, 0)
                    }
                }
            }
        }
    }
}
