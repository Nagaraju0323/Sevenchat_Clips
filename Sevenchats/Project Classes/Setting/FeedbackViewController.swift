//
//  FeedbackViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 11/09/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class FeedbackViewController: ParentViewController {

    @IBOutlet var viewAddImageContainer : UIView!
    @IBOutlet var viewUploadedImageContainer : UIView!
    @IBOutlet var imgFeedback : UIImageView!
    @IBOutlet var txtViewFeedbackContent : GenericTextView!{
        didSet{
            self.txtViewFeedbackContent.txtDelegate = self
            self.txtViewFeedbackContent.type = "1"
        }
    }
    @IBOutlet var txtCategory : MIGenericTextFiled!
    @IBOutlet var lblUploadImg : UILabel!

    fileprivate var categoryId : Int?
    var imgName = ""
    var feedbackImgUrl = ""
    
    var CategoryName = [ "Not User Friendly",
                         "Prompts not clear",
                         "Improper language",
                         "Incorrect language translation",
                         "Need help screens",
                         "Missing functionality",
                         "Nice to have functionality",
                         "Need help with"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialization()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setLanguageText()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // MARK:- ---------- Initialization
    
    func Initialization(){
        viewUploadedImageContainer.isHidden = true
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: #imageLiteral(resourceName: "ic_add_post"), style: .plain, target: self, action: #selector(btnAddFeedbackClicked(_:)))]
        
        self.loadCategoryList()
    }
    
    fileprivate func loadCategoryList() {
        
       /*Oldcode by Mi
         let arrCountry = TblFeedbackList.fetch(predicate: nil, orderBy: CId, ascending: true)
        let arrCountryCode = arrCountry?.value(forKeyPath: CName) as? [Any]
        txtCategory.setPickerData(arrPickerData: arrCountryCode!, selectedPickerDataHandler: { [weak self] (text, row, component) in
            guard let self = self else { return }
            
            if let catInfo = arrCountry![row] as? TblFeedbackList {
                self.txtCategory.text = catInfo.name
                self.categoryId = Int(catInfo.id)
            }
        }, defaultPlaceholder: nil)
       */
        txtCategory.setPickerData(arrPickerData:CategoryName, selectedPickerDataHandler: { [weak self] (text, row, component) in
            guard let self = self else { return }
            
            if let catInfo = self.CategoryName[row] as? String{
                self.txtCategory.text = catInfo as? String ?? ""

            }
        }, defaultPlaceholder: nil)
        
        
        
    }
    
    func setLanguageText() {
        self.title = CSettingFeedback
        lblUploadImg.text = CUploadImage
        txtCategory.placeHolder = CSelectCategory
        self.txtViewFeedbackContent.placeHolder = CPlaceholderWriteYourMessageHere
    }
}


// MARK:- --------- Action Event
extension FeedbackViewController{
    @IBAction func btnUplaodImageCLK(_ sender : UIButton){
        
        self.presentImagePickerController(allowEditing: true) { [weak self] (image, info) in
            guard let self = self else { return }
            if image != nil{
                self.imgFeedback.image = image
                self.viewAddImageContainer.isHidden = true
                self.viewUploadedImageContainer.isHidden = false
                
//                guard let imageURL = info?[UIImagePickerController.InfoKey.imageURL] as? NSURL else {
//                    return
//                }
//                self.imgName = imageURL.absoluteString ?? ""
//                MInioimageupload.shared().uploadMinioimage(ImgnameStr:image!)

                guard let mobileNum = appDelegate.loginUser?.mobile else {
                return
                }
                
                MInioimageupload.shared().uploadMinioimages(mobileNo: mobileNum, ImageSTt: image!,isFrom:"",uploadFrom:"")
                
                MInioimageupload.shared().callback = { message in
                print("message::::::::::::::\(message)")
                self.feedbackImgUrl = message
                }
                
                
            }
        }
    }
    
    @IBAction func btnDeleteImageCLK(_ sender : UIButton){
        viewUploadedImageContainer.isHidden = true
        viewAddImageContainer.isHidden = false
        imgFeedback.image = nil
    }
    
   /* @objc fileprivate func btnAddFeedbackClicked(_ sender : UIBarButtonItem) {
        self.resignKeyboard()
        if (txtCategory.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CBlankFeedbackCategory, btnOneTitle: CBtnOk, btnOneTapped: nil)
        } else if (txtViewFeedbackContent.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CFeedbackMessage, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }else {
            
            //Call feedback api here...
            APIRequest.shared().feedbackApplication(message: txtViewFeedbackContent.text, feedback_id: self.categoryId, image: imgFeedback.image) { [weak self] (response, error) in
                guard let self = self else { return }
                if response != nil {
                    
                    if let metaInfo = response![CJsonMeta] as? [String : Any] {
                        self.navigationController?.popViewController(animated: true)
                        GCDMainThread.async {
                            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: metaInfo.valueForString(key: CJsonMessage), btnOneTitle: CBtnOk, btnOneTapped: nil)
                        }
                    }
                }
            }
        }
    }*/
    
    @objc fileprivate func btnAddFeedbackClicked(_ sender : UIBarButtonItem) {
        self.resignKeyboard()
        if (txtCategory.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CBlankFeedbackCategory, btnOneTitle: CBtnOk, btnOneTapped: nil)
        } else if (txtViewFeedbackContent.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CFeedbackMessage, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }else if(imgFeedback.image == nil) {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CNavAddImage, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }else{
            
            guard let statusId = appDelegate.loginUser?.status_id else {return}
            guard let userId = appDelegate.loginUser?.user_id else {return}
            
            let txtFeedBack = txtViewFeedbackContent.text.replace(string: "\n", replacement: " ")
            let feedback : [String :Any] = [
                "image":feedbackImgUrl,
                "user_id" : userId.description,
                "category":txtCategory.text ?? "",
                "message":txtFeedBack,
                "platform":"IOS",
                "status_id":statusId
            ]
            //Call feedback api here...
            APIRequest.shared().feedbackApplication(dict:feedback) { [weak self] (response, error) in
                guard let self = self else { return }
                if response != nil {
                    
                    if let metaInfo = response![CJsonMeta] as? [String : Any] {
                        let name = (appDelegate.loginUser?.first_name ?? "") + " " + (appDelegate.loginUser?.last_name ?? "")
                        guard let image = appDelegate.loginUser?.profile_img else { return }
                        
                        
                        let stausLike = metaInfo["status"] as? String ?? "0"
                        if stausLike == "0" {
                            if self.txtCategory.text == "Not User Friendly"{
                    MIGeneralsAPI.shared().addRewardsPoints(CNotuserfriendlyfeedback,message:"Feedback",type:CNotuserfriendlyfeedback,title:"Feedback",name:name,icon:image)
                                
                            }else if self.txtCategory.text == "Prompts not clear"{
                                MIGeneralsAPI.shared().addRewardsPoints(CPromptsnotclearfeedback,message:"Feedback",type:CPromptsnotclearfeedback,title:"Feedback",name:name,icon:image)
                            }else if self.txtCategory.text == "Improper language"{
                                MIGeneralsAPI.shared().addRewardsPoints(CImproperlanguagefeedback,message:"Feedback",type:CImproperlanguagefeedback,title:"Feedback",name:name,icon:image)
                            }else if self.txtCategory.text == "Incorrect language translation"{
                                MIGeneralsAPI.shared().addRewardsPoints(CIncorrectlanguage,message:"Feedback",type:CIncorrectlanguage,title:"Feedback",name:name,icon:image)
                            }else if self.txtCategory.text == "Need help screens"{
                                MIGeneralsAPI.shared().addRewardsPoints(CNeedhelpscreensfeedback,message:"Feedback",type:CNeedhelpscreensfeedback,title:"Feedback",name:name,icon:image)
                            }else if self.txtCategory.text == "Missing functionality"{
                                MIGeneralsAPI.shared().addRewardsPoints(CMissingfunctionalityfeedback,message:"Feedback",type:CMissingfunctionalityfeedback,title:"Feedback",name:name,icon:image)
                            }else if self.txtCategory.text == "Nice to have functionality"{
                                MIGeneralsAPI.shared().addRewardsPoints(Nicetohavefunctionalityfeedback,message:"Feedback",type:Nicetohavefunctionalityfeedback,title:"Feedback",name:name,icon:image)
                            }else if self.txtCategory.text == "Need help with"{
                                MIGeneralsAPI.shared().addRewardsPoints(CNeedhelpwithfeedback,message:"Feedback",type:CNeedhelpwithfeedback,title:"Feedback",name:name,icon:image)
                            }
                        }
                        
                        self.navigationController?.popViewController(animated: true)
                        GCDMainThread.async {
                            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: metaInfo.valueForString(key: CJsonMessage), btnOneTitle: CBtnOk, btnOneTapped: nil)
                        }
                    }
                }
            }
        }
    }
    
}


extension FeedbackViewController: GenericTextFieldDelegate {
   
    @objc func genericTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if textField == txtCategory{
        if txtCategory.text?.count ?? 0 > 1500{
            return false
        }
        let cs = NSCharacterSet(charactersIn: PASSWORDALLOWCHAR).inverted
        let filtered = string.components(separatedBy: cs).joined(separator: "")
        return (string == filtered)
    }
    return true
    }
}
// MARK:-  --------- Generic UITextView Delegate
extension FeedbackViewController: GenericTextViewDelegate{
    
    func FeedbackViewController(_ textView: UITextView, height: CGFloat){
        
        if textView == txtViewFeedbackContent{
            //            lblTextCount.text = "\(textView.text.count)/\(txtViewArticleContent.textLimit ?? "0")"
        }
    }

}
