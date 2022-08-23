//
//  MIGenericTextFieldNew.swift
//  Sevenchats
//
//  Created by nagaraju k on 19/08/22.
//  Copyright © 2022 mac-00020. All rights reserved.
//

import Foundation
import UIKit


@objc protocol GenericTextFieldDelegateNew:class {
    @objc optional func genericTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    @objc optional func genericTextField(_ textField: UITextField, shouldChangeCharactersInForEmpty range: NSRange, replacementString string: String) -> Bool
    @objc optional func genericTextFieldDidChange(_ textField : UITextField)
    @objc optional func genericTextFieldDidBeginEditing(_ textField: UITextField)
    @objc optional func genericTextFieldDidEndEditing(_ textField: UITextField)
    @objc optional func genericTextFieldClearText(_ textField: UITextField)
}


class MIGenericTextFiledNew: UITextField {
    
    public weak var txtDelegate: GenericTextFieldDelegateNew?
    
    @IBOutlet
    public weak var genericTextFieldDelegateNew: AnyObject? {
        get { return delegate as AnyObject }
        set { txtDelegate = newValue as? GenericTextFieldDelegateNew }
    }
    
    @IBInspectable var placeHolder: String?
    @IBInspectable var placeHolderFont: UIFont?
    @IBInspectable var PlaceHolderColor:UIColor?
    @IBInspectable var PlaceHolderColorAfterText:UIColor?
    
    var textLimit : Int?
    
    var PlaceholderFontSize : CGFloat = 14
    var lblPlaceHolder = UILabel()
    var imageview = UIImageView()
//    var viewBottomLine = UIView()
    var btnClearText = UIButton()
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        PlaceHolderColor = UIColor.lightGray
        PlaceHolderColorAfterText = UIColor.black
        
        PlaceholderFontSize = (self.font?.pointSize)!
        self.font = UIFont(name: (self.font?.fontName)!, size: round(CScreenWidth * ((self.font?.pointSize)! / 414)))
//        self.borderStyle = .none
        //self.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        // NOTE : tag == 100 (For default text filed)
        GCDMainThread.async {
            self.delegate = self
            
            switch self.tag{
            case 0,21:
                // Textfiled with moveble placeholder (ex. - LRF Related)
                self.placeHolderSetup()
//                self.bottomLineViewSetup()
                self.showHideImage()
                self.clearTextButtonSetup()
                break
                
            case 1:
                // Textfiled without moveble placeholder (ex. - POST Related)
                self.placeHolderSetup()
//                self.bottomLineViewSetup()
                self.clearTextButtonSetup()
                break

            case 2:
                // Drop Down with movable placeholder...
                self.placeHolderSetup()
//                self.bottomLineViewSetup()
                break
                
            case 23,22:
                // Drop Down with movable placeholder...
                self.showHideImage()
                self.placeHolderSetup()
//                self.bottomLineViewSetup()
                break
                
            case 3:
                // Drop Down without movable placeholder...
                self.placeHolderSetup()
//                self.bottomLineViewSetup()
                break
                
            case 10:
                // Password Filed with Show/Hide option
                self.placeHolderSetup()
                self.showHideForgotPassword()
                self.showHideImage()
//                self.bottomLineViewSetup()
                break

            default:
                break
            }
        }
        
        
        if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
            self.semanticContentAttribute = .forceRightToLeft
        } else {
            self.semanticContentAttribute = .forceLeftToRight
        }
        
        let direction = UIView.userInterfaceLayoutDirection(for: self.semanticContentAttribute)
        
        if self.textAlignment != .center{
            if direction == .leftToRight {
                self.textAlignment = .left
            } else {
                self.textAlignment = .right
            }
        }
        
    }
    
    
    // MARK:- --------PlaceHolder
    func placeHolderSetup(){
        lblPlaceHolder.frame = CGRect(x: 40, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)
        lblPlaceHolder.text = placeHolder
        lblPlaceHolder.textColor = PlaceHolderColor
       
        lblPlaceHolder.font = UIFont(name: (self.font?.fontName)!, size: round(CScreenWidth * (PlaceholderFontSize / 414)))
        lblPlaceHolder.isUserInteractionEnabled = false
        self.addSubview(lblPlaceHolder)
    }
    
    func updatePlaceholderFrame(_ isMoveUp : Bool?){
        
        // Hide Placeholder
        if self.tag == 1 || self.tag == 3{
            lblPlaceHolder.isHidden = isMoveUp!
            return
        }
        
        
        // Move Placeholder
        if isMoveUp!{
            UIView.animate(withDuration: 0.3) {
                self.lblPlaceHolder.textColor = self.PlaceHolderColorAfterText
                self.lblPlaceHolder.frame = CGRect(x: 0.0, y: -18, width: self.frame.size.width, height: CScreenWidth * 16 / 375)
                self.lblPlaceHolder.font = UIFont(name: (self.font?.fontName)!, size: round(CScreenWidth * (self.PlaceholderFontSize - 2) / 375))
                self.layoutIfNeeded()
            }
        }
        else
        {
            UIView.animate(withDuration: 0.3) {
                self.lblPlaceHolder.textColor = self.PlaceHolderColor
                self.lblPlaceHolder.frame = CGRect(x: 40, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)
                self.lblPlaceHolder.font = UIFont(name: (self.font?.fontName)!, size: round(CScreenWidth * (self.PlaceholderFontSize ) / 414))
                self.layoutIfNeeded()
            }
        }
    }

    
    // MARK:- --------Cleate Text button
    func clearTextButtonSetup(){
//        btnClearText.frame = CGRect(x: 0.0, y: 0, width: 30, height: self.frame.size.height)
//        btnClearText.isHidden = true
//        btnClearText.setImage(#imageLiteral(resourceName: "ic_cancle"), for: .normal)
//        btnClearText.setTitleColor(CRGB(r: 131, g: 147, b: 98), for: .normal)
//        self.rightViewMode = .always
//        self.rightView = btnClearText
//
//        btnClearText.touchUpInside { [weak self](sender) in
//            guard let `self` = self else {return}
//            self.text = ""
//            self.btnClearText.isHidden = true
//            self.updatePlaceholderFrame(false)
//            self.resignFirstResponder()
//
//            if self.txtDelegate != nil{
//                _ = self.txtDelegate?.genericTextFieldClearText?(self)
//            }
//        }
    }
    
    func showHideClearTextButton(){
        btnClearText.isHidden = (self.text?.count)! == 0
    }
    
    func showHideImage(){
       
        let button = UIButton(type: .custom)
        
        let rightView = UIView()
        rightView.frame = CGRect(x: 0.0, y: 0, width: 60, height: self.frame.size.height)
        let hStackView = UIStackView()
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        hStackView.axis = .horizontal;
        hStackView.distribution = .fill;
        hStackView.alignment = .top;
        hStackView.spacing = 10;
         
        btnClearText.frame = CGRect(x: 0.0, y: 0, width: 30, height: self.frame.size.height)
        btnClearText.isHidden = true
        btnClearText.setImage(#imageLiteral(resourceName: "ic_cancle"), for: .normal)
        btnClearText.setTitleColor(CRGB(r: 131, g: 147, b: 98), for: .normal)
        
        
        switch self.tag{
        case 0:
            // Textfiled with moveble placeholder (ex. - LRF Related)
            button.frame = CGRect(x: 0.0, y: 0, width: 30, height: self.frame.size.height)
            button.setImage(UIImage(named: "email"), for: .normal)
            hStackView.addArrangedSubview(button)
            hStackView.addArrangedSubview(btnClearText)
            break
            
      
        case 10:
            button.frame = CGRect(x: 0.0, y: 0, width: 30, height: self.frame.size.height)
            button.setImage(UIImage(named: "padlock"), for: .normal)
            hStackView.addArrangedSubview(button)
            hStackView.addArrangedSubview(btnClearText)
            break
            
        case 21:
            button.frame = CGRect(x: 0.0, y: 0, width: 30, height: self.frame.size.height)
            button.setImage(UIImage(named: "user"), for: .normal)
            hStackView.addArrangedSubview(button)
            hStackView.addArrangedSubview(btnClearText)
            break
            
        case 22:
            button.frame = CGRect(x: 0.0, y: 0, width: 30, height: self.frame.size.height)
            button.setImage(UIImage(named: "gender"), for: .normal)
            hStackView.addArrangedSubview(button)
            hStackView.addArrangedSubview(btnClearText)
            break
            
       case 23:
            button.frame = CGRect(x: 0.0, y: 0, width: 30, height: self.frame.size.height)
            button.setImage(UIImage(named: "calendar"), for: .normal)
            hStackView.addArrangedSubview(button)
            hStackView.addArrangedSubview(btnClearText)
            break
            
        case 24:
            // Textfiled with moveble placeholder (ex. - LRF Related)
            button.frame = CGRect(x: 0.0, y: 0, width: 30, height: self.frame.size.height)
            button.setImage(UIImage(named: "email"), for: .normal)
            hStackView.addArrangedSubview(button)
            hStackView.addArrangedSubview(btnClearText)
            break
        default:
            break
        }
        
        rightView.addSubview(hStackView)
        NSLayoutConstraint.activate([
            hStackView.leadingAnchor.constraint(equalTo: rightView.leadingAnchor,constant: 10),
            hStackView.trailingAnchor.constraint(equalTo: rightView.trailingAnchor),
            hStackView.topAnchor.constraint(equalTo: rightView.topAnchor),
            hStackView.bottomAnchor.constraint(equalTo: rightView.bottomAnchor)
        ])
        
        self.leftView = rightView
        self.leftViewMode = .always
    }
    
    func showHideForgotPassword(){
        let rightView = UIView()
        rightView.frame = CGRect(x: 0.0, y: 0, width: 60, height: self.frame.size.height)
        let hStackView = UIStackView()
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        hStackView.axis = .horizontal;
        hStackView.distribution = .fillProportionally;
        hStackView.alignment = .fill;
        hStackView.spacing = 4;
        
        btnClearText.frame = CGRect(x: 0.0, y: 0, width: 30, height: self.frame.size.height)
        btnClearText.isHidden = true
        btnClearText.setImage(#imageLiteral(resourceName: "ic_cancle"), for: .normal)
        btnClearText.setTitleColor(CRGB(r: 131, g: 147, b: 98), for: .normal)
        
        let button = UIButton(type: .custom)
        //button.frame = CGRect(x: 0.0, y: 0, width: 30, height: self.frame.size.height)
        
        button.setImage(UIImage(named: "ic_hide_password"), for: .normal)
        button.setImage(UIImage(named: "ic_show_password"), for: .selected)
        
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -22, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(self.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button.addTarget(self, action: #selector(self.btnForgotPasswordPress), for: .touchUpInside)
        
        
        hStackView.addArrangedSubview(button)
//        hStackView.addArrangedSubview(buttonLock)
        hStackView.addArrangedSubview(btnClearText)
        
        rightView.addSubview(hStackView)
        NSLayoutConstraint.activate([
            hStackView.leadingAnchor.constraint(equalTo: rightView.leadingAnchor),
            hStackView.trailingAnchor.constraint(equalTo: rightView.trailingAnchor),
            hStackView.topAnchor.constraint(equalTo: rightView.topAnchor),
            hStackView.bottomAnchor.constraint(equalTo: rightView.bottomAnchor)
        ])
        
        self.rightView = rightView
        self.rightViewMode = .always
        self.isSelected = true
        self.isSecureTextEntry = true
    }
    
    @IBAction func btnForgotPasswordPress(_ sender: UIButton) {
        sender.isSelected.toggle()
        self.isSecureTextEntry = !sender.isSelected
    }
}

// MARK:- --------Textfiled Delegate methods
extension MIGenericTextFiledNew {
   
    @objc func textFieldDidChange(_ textField : UITextField){
        // Hide show clear button
        self.showHideClearTextButton()
        
        if txtDelegate != nil{
            _ = txtDelegate?.genericTextFieldDidChange?(textField)
        }
    }
    
    override func textFieldDidBeginEditing(_ textField: UITextField){
        
        // update placeholder frame
        self.updatePlaceholderFrame(true)
        
        if txtDelegate != nil{
            _ = txtDelegate?.genericTextFieldDidBeginEditing?(textField)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if self.text?.count == 0{
            // update placeholder frame
            self.updatePlaceholderFrame(false)
        }
        
        if txtDelegate != nil{
            _ = txtDelegate?.genericTextFieldDidEndEditing?(textField)
        }
    }
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            
            if string.isEmpty {
                if txtDelegate != nil{
                    return (txtDelegate?.genericTextField?(textField, shouldChangeCharactersInForEmpty: range, replacementString: string)) ??  true
                }
                return true
            }
            
//            if string.contains(UIPasteboard.general.string ?? ""){
//                print("print this copy paste")
//
//                return (txtDelegate?.genericTextField?(textField, shouldChangeCharactersInForEmpty: range, replacementString: string)) ??  true
//
//            }else {
                print("prin normatl test")
               
                if let limit = self.textLimit, let text = textField.text,
                    let textRange = Range(range, in: text){
                    let updatedText = text.replacingCharacters(in: textRange,with: string)
                    if limit < updatedText.count {
                        return false
                    }
                }
                
      // }

            
            
    //
    //        if let limit = self.textLimit, let text = textField.text,
    //            let textRange = Range(range, in: text){
    //            let updatedText = text.replacingCharacters(in: textRange,with: string)
    //            if limit < updatedText.count {
    //                return false
    //            }
    //        }
            
            if txtDelegate != nil{
                return (txtDelegate?.genericTextField?(textField, shouldChangeCharactersIn: range, replacementString: string))!
               
            }
         return true
        }
//    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        if string.isEmpty {
//            if txtDelegate != nil{
//                return (txtDelegate?.genericTextField?(textField, shouldChangeCharactersInForEmpty: range, replacementString: string)) ??  true
//            }
//            return true
//        }
//
//        if let limit = self.textLimit, let text = textField.text,
//            let textRange = Range(range, in: text){
//            let updatedText = text.replacingCharacters(in: textRange,with: string)
//            if limit < updatedText.count {
//                return false
//            }
//        }
//
//        if txtDelegate != nil{
//            return (txtDelegate?.genericTextField?(textField, shouldChangeCharactersIn: range, replacementString: string))!
//
//        }
//        return true
//    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if txtDelegate != nil{
            
            return (txtDelegate?.genericTextField?(textField, shouldChangeCharactersIn: range, replacementString: string))!
            
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
