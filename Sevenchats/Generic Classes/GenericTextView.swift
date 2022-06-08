//
//  GenericTextView.swift
//  Sevenchats
//
//  Created by mac-0005 on 17/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*
 UITextView tag Info
 0 - Default textView
 1 - TextView with Movable Palceholder and Bottom line
 2 - TextView with normal Palceholder (ex. - Message and Comment TextView)
 3 - Description TextView with normal Palceholder (ex. - Message and Comment TextView)
 */

import UIKit

var placeholderNormalHieght : CGFloat = 30
var Ypossition : CGFloat = 8
var Xpossition : CGFloat = 5

@objc protocol GenericTextViewDelegate : class {
    @objc optional func genericTextView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    @objc optional func genericTextViewDidBeginEditing(_ textView: UITextView)
    @objc optional func genericTextViewDidEndEditing(_ textView: UITextView)
    @objc optional func genericTextViewDidChange(_ textView: UITextView, height : CGFloat)
}

class GenericTextView: UITextView, UITextViewDelegate {

    @IBInspectable var placeHolder: String?
    @IBInspectable var textLimit : String?
    @IBInspectable var type : String?
    @IBInspectable var bottomLineColor:UIColor = CRGB(r: 67, g: 70, b: 67)
    @IBInspectable var placeholderBackgroundColor:UIColor = UIColor.clear
    @IBInspectable var PlaceHolderColor:UIColor? = UIColor.lightGray
    @IBInspectable var PlaceHolderColorAfterText:UIColor? = UIColor.black
    
    var PlaceholderFontSize : CGFloat = 14
    
    var lblPlaceHolder = UILabel()
    var viewBottomLine = UIView()

    public weak var txtDelegate: GenericTextViewDelegate?
    @IBOutlet
    public var genericDelegate: AnyObject? {
        get { return delegate as AnyObject }
        set { txtDelegate = newValue as? GenericTextViewDelegate }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        PlaceHolderColor = UIColor.lightGray
        PlaceHolderColorAfterText = UIColor.black
        
        PlaceholderFontSize = (self.font?.pointSize)!
        self.font = UIFont(name: (self.font?.fontName)!, size: round(CScreenWidth * ((self.font?.pointSize)! / 414)))
        
        GCDMainThread.async {
            self.delegate = self
        }
        
        GCDMainThread.async {
            switch(self.tag){
            case 0:
                // Default TextView
                break
                
            case 1:
                // TextView with Movable Palceholder and Bottom line
                Ypossition = 8
                Xpossition = 5

                self.contentInset = UIEdgeInsets(top: Ypossition, left: -Xpossition, bottom: 0, right: 0)
                self.placeHolderSetup()
                self.bottomLineViewSetup()
                break
                
            case 2:
                // Message and Comment TextView
                Ypossition = 0
                Xpossition = 0
                self.contentInset = UIEdgeInsets(top: Ypossition, left: -Xpossition, bottom: 0, right: 0)
                placeholderNormalHieght = self.frame.size.height
                self.placeHolderSetup()
                break
                
            case 3:
                // Description type TextView
                Ypossition = 0
                Xpossition = 5
                self.contentInset = UIEdgeInsets(top: Ypossition, left: -Xpossition, bottom: 0, right: 0)
                placeholderNormalHieght = 50
                self.placeHolderSetup()
                self.bottomLineViewSetup()
                break
            case 4:
                // TextView with Movable Palceholder and Bottom line
                Ypossition = 8
                Xpossition = 5
                
                self.contentInset = UIEdgeInsets(top: Ypossition, left: -Xpossition, bottom: 0, right: 0)
                self.placeHolderSetup()
                break
            case 5:
                // TextView with Movable Palceholder and Bottom line
                Ypossition = 8
                Xpossition = 5
                
                self.contentInset = UIEdgeInsets(top: Ypossition, left: -Xpossition, bottom: 0, right: 0)
                self.placeHolderSetup()
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
        if direction == .leftToRight {
            self.textAlignment = .left
        } else {
            self.textAlignment = .right
        }
        
    }

    // MARK:- -------- TextView Properties
    // MARK:-
    func setSelectedRange(range : NSRange) {
        self.selectedRange = range
    }
    
    func selectedRange() -> NSRange {
        return self.selectedRange
    }
    
    func setAttributeText(attributedString : NSAttributedString) {
        self.isScrollEnabled = false
        self.attributedText = attributedString
        self.isScrollEnabled = true
    }
    
    
    // MARK:- --------PlaceHolder
    // MARK:-
    func placeHolderSetup(){
        lblPlaceHolder.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y , width: self.frame.size.width, height: placeholderNormalHieght)
        lblPlaceHolder.backgroundColor = placeholderBackgroundColor
        lblPlaceHolder.text = placeHolder
        lblPlaceHolder.textColor = PlaceHolderColor
        lblPlaceHolder.font = UIFont(name: (self.font?.fontName)!, size: round(CScreenWidth * (PlaceholderFontSize / 414)))
        lblPlaceHolder.isUserInteractionEnabled = false
        self.superview!.insertSubview(lblPlaceHolder, aboveSubview: self)
    }
    
    func updatePlaceholderFrame(_ isMoveUp : Bool?) {

        // For normal type textview...
        if self.tag == 2 || self.tag == 3 {
            self.lblPlaceHolder.isHidden = isMoveUp!
            return
        }
        
        if isMoveUp! {
            UIView.animate(withDuration: 0.3) {
                self.lblPlaceHolder.textColor = self.PlaceHolderColorAfterText
                self.lblPlaceHolder.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y - 2 , width: self.frame.size.width, height: CGFloat(ceilf(Float(CScreenWidth * 16 / 375))))
                self.lblPlaceHolder.font = UIFont(name: (self.font?.fontName)!, size: round(CScreenWidth * (self.PlaceholderFontSize - 2) / 414))
                self.layoutIfNeeded()
            }
        }else {
            UIView.animate(withDuration: 0.3) {
                self.lblPlaceHolder.textColor = self.PlaceHolderColor
                self.lblPlaceHolder.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y , width: self.frame.size.width, height: placeholderNormalHieght)
                self.lblPlaceHolder.font = UIFont(name: (self.font?.fontName)!, size: round(CScreenWidth * self.PlaceholderFontSize / 414))
                self.layoutIfNeeded()
            }
        }
    }
    
    // MARK:- --------Bottom Line
    // MARK:-
    func bottomLineViewSetup() {
        viewBottomLine.frame = CGRect(x: self.frame.origin.x, y: self.frame.size.height + self.frame.origin.y , width: self.frame.size.width, height: 1.0)
        viewBottomLine.backgroundColor = bottomLineColor
        viewBottomLine.tag = 1001
        self.superview!.insertSubview(viewBottomLine, aboveSubview: self)
    }
    
    func updateBottomLineAndPlaceholderFrame() {
        viewBottomLine.frame = CGRect(x: self.frame.origin.x, y: self.frame.size.height + self.frame.origin.y , width: self.frame.size.width, height: 1.0)
        self.lblPlaceHolder.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y , width: self.frame.size.width, height: placeholderNormalHieght)
        self.superview?.layoutIfNeeded()
    }
    
    
    // MARK:- --------Textfiled Delegate methods
    // MARK:-
     public func textViewDidBeginEditing(_ textView: UITextView) {
        if txtDelegate != nil {
            _ = txtDelegate?.genericTextViewDidBeginEditing?(textView)
        }
        
        // update placeholder frame
        self.updatePlaceholderFrame(true)
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
       
        if txtDelegate != nil {
            _ = txtDelegate?.genericTextViewDidEndEditing?(textView)
            
        }
        
        
        if self.text?.count == 0 {
            // update placeholder frame
            self.updatePlaceholderFrame(false)
        }
    }
    
    public func textViewDidChange(_ textView: UITextView) {

        // calculate text height....
        let constraintRect = CGSize(width: self.frame.size.width, height: .greatestFiniteMagnitude)
        let boundingBox = textView.text.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self.font!], context: nil)
        
        if txtDelegate != nil {
            _ = txtDelegate?.genericTextViewDidChange?(textView, height: ceil(boundingBox.height))
        }
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if JSON(rawValue: type!) ?? "0" == "1"{
            if type == "1"{
            if txtDelegate != nil {
                if text.contains(UIPasteboard.general.string ?? "") {
                   print("paste")
                    _ = txtDelegate?.genericTextView?(textView, shouldChangeTextIn: range, replacementText: text)
                if textLimit?.toInt != 0 && !(textLimit?.isBlank)! {
                    return textView.text.count + (text.count - range.length) <= (textLimit?.toInt)!
                }
                } else {
                    print("normal typing")
                    let str = (textView.text + text)
                    if str.count <= 5000 {
                        print("done")
                        _ = txtDelegate?.genericTextView?(textView, shouldChangeTextIn: range, replacementText: text)
                        return (text == text)
//                        let inverted = NSCharacterSet(charactersIn: SPECIALCHARNOTALLOWED).inverted
//
//                        if text.isSingleEmoji{
//                          return (text == text)
//                        }else {
//                            let filtered = text.components(separatedBy: inverted).joined(separator: "")
//                            if (text.isEmpty  && filtered.isEmpty ) {
//                                        let isBackSpace = strcmp(text, "\\b")
//                                        if (isBackSpace == -92) {
//                                            print("Backspace was pressed")
//                                            return (text == filtered)
//                                        }
//                            } else {
//                                return (text != filtered)
//                            }
//                        }
                    }


//                   print("normal typing")
//
//
//
//                    _ = txtDelegate?.genericTextView?(textView, shouldChangeTextIn: range, replacementText: text)
//                    let cs = NSCharacterSet(charactersIn: SPECIALCHAR).inverted
//                    let filtered = text.components(separatedBy: cs).joined(separator: "")
//                  return (text == filtered)

          }
//            _ = txtDelegate?.genericTextView?(textView, shouldChangeTextIn: range, replacementText: text)
//               let cs = NSCharacterSet(charactersIn: SPECIALCHAR).inverted
//          let filtered = text.components(separatedBy: cs).joined(separator: "")
//                          return (text == filtered)
            // Check text limit here....
            if textLimit != nil {
                if textLimit?.toInt != 0 && !(textLimit?.isBlank)! {
                    return textView.text.count + (text.count - range.length) <= (textLimit?.toInt)!
                }
            
            }
        }else{
        if txtDelegate != nil {
            _ = txtDelegate?.genericTextView?(textView, shouldChangeTextIn: range, replacementText: text)
//            let cs = NSCharacterSet(charactersIn: PASSWORDALLOWCHAR).inverted
//            let filtered = text.components(separatedBy: cs).joined(separator: "")
//            return (text == filtered)
        }
        
        // Check text limit here....
        if textLimit != nil {
            if textLimit?.toInt != 0 && !(textLimit?.isBlank)! {
                return textView.text.count + (text.count - range.length) <= (textLimit?.toInt)!
            }
        }
        }
        }
        
        
        if type == "3"{
        if txtDelegate != nil {
            if text.contains(UIPasteboard.general.string ?? "") {
               print("paste")
                _ = txtDelegate?.genericTextView?(textView, shouldChangeTextIn: range, replacementText: text)
            if textLimit?.toInt != 0 && !(textLimit?.isBlank)! {
                return textView.text.count + (text.count - range.length) <= (textLimit?.toInt)!
            }
            } else {
            
               print("normal typing")
                let str = (textView.text + text)
                if str.count <= 150 {
                    _ = txtDelegate?.genericTextView?(textView, shouldChangeTextIn: range, replacementText: text)
                    return (text == text)
//                    let RISTRICTED_CHARACTERS = "'\\'\""
//                    let inverted = NSCharacterSet(charactersIn: RISTRICTED_CHARACTERS).inverted
//
//                    if text.isSingleEmoji{
//                      return (text == text)
//                    }else {
//                        let filtered = text.components(separatedBy: inverted).joined(separator: "")
//
//                        if (text.isEmpty  && filtered.isEmpty ) {
//                                    let isBackSpace = strcmp(text, "\\b")
//                                    if (isBackSpace == -92) {
//                                        print("Backspace was pressed")
//                                        return (text == filtered)
//                                    }
//                        } else {
//                            return (text != filtered)
//                        }
//                    }
//                    let cs = NSCharacterSet(charactersIn: SPECIALCHAR).inverted
//                    let filtered = text.components(separatedBy: cs).joined(separator: "")
//                  return (text == filtered)
                }
         }
        // Check text limit here....
        if textLimit != nil {
            if textLimit?.toInt != 0 && !(textLimit?.isBlank)! {
                return textView.text.count + (text.count - range.length) <= (textLimit?.toInt)!
            }
        
        }
    }else{
    if txtDelegate != nil {
        _ = txtDelegate?.genericTextView?(textView, shouldChangeTextIn: range, replacementText: text)
    }
    
    // Check text limit here....
    if textLimit != nil {
        if textLimit?.toInt != 0 && !(textLimit?.isBlank)! {
            return textView.text.count + (text.count - range.length) <= (textLimit?.toInt)!
        }
    }
    }
    }
        
        
        return true
    }
    

}

@IBDesignable extension GenericTextView {
        @IBInspectable var borderWidth: CGFloat {
            set {
                layer.borderWidth = newValue
            }
            get {
                return layer.borderWidth
            }
        }

        @IBInspectable var cornerRadius: CGFloat {
            set {
                layer.cornerRadius = newValue
            }
            get {
                return layer.cornerRadius
            }
        }

        @IBInspectable var borderColor: UIColor? {
            set {
                guard let uiColor = newValue else { return }
                layer.borderColor = uiColor.cgColor
            }
            get {
                guard let color = layer.borderColor else { return nil }
                return UIColor(cgColor: color)
            }
        }
    }
extension Character {
    /// A simple emoji is one scalar and presented to the user as an Emoji
    var isSimpleEmoji: Bool {
        guard let firstScalar = unicodeScalars.first else { return false }
        return firstScalar.properties.isEmoji && firstScalar.value > 0x238C
    }

    /// Checks if the scalars will be merged into an emoji
    var isCombinedIntoEmoji: Bool { unicodeScalars.count > 1 && unicodeScalars.first?.properties.isEmoji ?? false }

    var isEmoji: Bool { isSimpleEmoji || isCombinedIntoEmoji }
}

extension String {
    var isSingleEmoji: Bool { count == 1 && containsEmoji }

    var containsEmoji: Bool { contains { $0.isEmoji } }

    var containsOnlyEmoji: Bool { !isEmpty && !contains { !$0.isEmoji } }

    var emojiString: String { emojis.map { String($0) }.reduce("", +) }

    var emojis: [Character] { filter { $0.isEmoji } }

    var emojiScalars: [UnicodeScalar] { filter { $0.isEmoji }.flatMap { $0.unicodeScalars } }
}
