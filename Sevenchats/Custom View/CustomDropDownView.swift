//
//  CustomDropDownView.swift
//  Sevenchats
//
//  Created by mac-00011 on 17/04/20.
//  Copyright © 2020 mac-00020. All rights reserved.
//

/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : CustomDropDownView                          *
 * Description : CustomDropDownView                      *
 ********************************************************/

import UIKit
import Foundation
import DropDown

class CustomDropDownView: UIView {
    
    // MARK:- @IBOutlet -
    
    @IBOutlet weak var txtCategory: MIGenericTextFiled!
    
    // MARK:- Global Variables -
    
    fileprivate typealias DropDownSelectionClosure = (Int, String) -> Void
    
    var blockSearchBarEnd: ((_ text: String) -> Void)?
    var blockForSelectedIndex: ((String, Int) -> Void)?
    var onSelectText: ((String) -> Void)? = nil
    var didChnageText: ((String) -> Void)? = nil
    var onselect: ((String) -> Void)? = nil
    
    
    var arrDataSource: [String] = []
    
    var dropDown: DropDown?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    override func draw(_ rect: CGRect) {
        
        txtCategory.delegate = self
//        txtCategory.resignFirstResponder()
        setTextColorAndFont()
        
//        if let searchTextField = txtCategory.value(forKey: "searchField") as? UITextField {
//            
//            if let searchFieldBackground = searchTextField.subviews.first {
//                
//                searchFieldBackground.backgroundColor = .clear
//                searchFieldBackground.layer.cornerRadius = 0
//                searchFieldBackground.clipsToBounds = true
//            }
//            searchTextField.textColor = .black
//            searchTextField.placeholderColor = .gray
//            searchTextField.clearButtonMode = .whileEditing
//            
//        }
    }
    
    fileprivate func initialize() {
        
    }
    
    /// DropDown
    /// Open dropdown using this method
    /// - Parameters:
    ///   - dataSource: array of string
    ///   - closer: return closer on select
    
    fileprivate func openDropDownFor(dataSource: [String], closer: @escaping DropDownSelectionClosure) {
        
        if (self.dropDown == nil) {
            self.dropDown = DropDown()
        }
        
        self.txtCategory.resignFirstResponder()
        dropDown?.anchorView = self
        dropDown?.dataSource = dataSource
        dropDown?.bottomOffset = CGPoint(x: 0, y: self.txtCategory.bounds.height)
        dropDown?.show()
        dropDown?.selectionAction = { [unowned self] (index: Int, item: String) in
            
            closer(index,item)
            self.txtCategory.text = item
            self.txtCategory.endEditing(true)
            self.dropDown?.hide()
        }
    }
    
    func setTextColorAndFont() {
        
        txtCategory.textColor = ColorGreen
        txtCategory.font = CFontPoppins(size: (14 * CScreenWidth)/375, type: .light)
    }
}

extension CustomDropDownView: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
        
        self.blockSearchBarEnd?(textField.text ?? "")
        self.didChnageText?(self.txtCategory.text ?? "")
        self.dropDown?.hide()
    }
}

// MARK:- Action Events -

extension CustomDropDownView {
    
    @IBAction func onTxtFPasswordChange(_ sender: UITextField) {
        
        let results = (arrDataSource.filter({$0.lowercased().contains(find: sender.text ?? "")}))
        
        self.openDropDownFor(dataSource: arrDataSource) { [unowned self] (index, item) in
            print("this is calling")
            self.onSelectText?(item)
            self.blockForSelectedIndex?(item, index)
            self.didChnageText?(item)
        }
        self.didChnageText?(sender.text ?? "")
    }
}

// MARK:- Extension Optional -

extension Optional where Wrapped == String {
    
    func isEmptyOrNil() -> Bool {
        guard let strongSelf = self else {
            return true
        }
        return strongSelf.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? true : false
    }
}


