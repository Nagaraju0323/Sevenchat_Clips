//
//  AddPollQuestionCell.swift
//  Sevenchats
//
//  Created by mac-00020 on 27/05/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

import UIKit

class AddPollQuestionCell: UITableViewCell {

    @IBOutlet weak var txtOption : UITextField!
    @IBOutlet weak var btnAdd : UIButton!
    @IBOutlet weak var lblDevider : UILabel!
    
    var option : MDLAddPollQuestion!{
        didSet{
            self.txtOption.text =  option.option
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        self.btnAdd.setImage(UIImage(named:"ic_add_poll_option"), for: .selected)
        self.btnAdd.setImage(UIImage(named:"ic_minus"), for: .normal)
        txtOption.placeholderColor = UIColor.lightGray
        txtOption.delegate = self
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension AddPollQuestionCell : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.option.option = textField.text ?? ""
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty{
            return true
        }
        
        if textField == txtOption{
        if (textField.text?.count ?? 0) > 100{
            return false
        }
        
            
            if string.contains(UIPasteboard.general.string ?? ""){

                let text: NSString = (textField.text ?? "") as NSString
                 let resultString = text.replacingCharacters(in: range, with: string)
                return (string == resultString)
                
                
            }else {
                //Normat type
                if textField == textField{
                let cs = NSCharacterSet(charactersIn: SPECIALCHAR).inverted
                let filtered = string.components(separatedBy: cs).joined(separator: "")
                return (string == filtered)
                }
            }
            
       
        
        }
        return true
    }
}
