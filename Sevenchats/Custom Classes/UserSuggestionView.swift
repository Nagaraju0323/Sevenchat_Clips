//
//  UserSuggestionView.swift
//  Sevenchats
//
//  Created by mac-0005 on 28/12/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : UserSuggestionView                          *
 * Description : Comments display to every post          *
 *                                                       *
 ********************************************************/

import UIKit

let kSuggestionViewMaxHeight : CGFloat = 180
let kMentionFriendStringFormate = "~<<<%@>>>~"

@objc protocol UserSuggestionDelegate:class {
    @objc optional func didSelectSuggestedUser(_ userInfo: [String : Any])
}

class UserSuggestionView: UIView {
    
    weak var userSuggestionDelegate : UserSuggestionDelegate!
    @IBOutlet weak var tblfriendSuggestionList : UITableView! {
        didSet {
            tblfriendSuggestionList.register(UINib(nibName: "UserSuggestionTblCell", bundle: nil), forCellReuseIdentifier: "UserSuggestionTblCell")
        }
    }
    
    @IBOutlet weak var cnTblSuggestionHeight : NSLayoutConstraint! {
        didSet {
            cnTblSuggestionHeight.constant = 0
        }
    }
    
    var searchString = ""
    var isSearchString =  false
    var apiTask : URLSessionTask?
    var pageNumber = 1
    var refreshControl = UIRefreshControl()
    
    var arrFilterUser = [[String:Any]]()
    var arrSelectedUser = [[String:Any]]()
    
    override func awakeFromNib() {
        super .awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func resetData(){
        self.arrSelectedUser.removeAll()
        self.searchString = ""
    }
    func addSelectedUser(user: [String:Any]){
        self.arrSelectedUser.append(user)
    }
}

// MARK:- Initialization
// MARK:-
extension UserSuggestionView {
    func initialization() {
        GCDMainThread.async {
            self.refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
            self.refreshControl.tintColor = ColorBlack
            self.tblfriendSuggestionList.pullToRefreshControl = self.refreshControl
            self.pageNumber = 1
            //            self.getFriendList()
        }
        
//        self.layer.shadowColor = CRGB(r: 230, g: 235, b: 239).cgColor
        self.layer.shadowColor = ColorBlack.cgColor
        self.layer.shadowOpacity = 3
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 3
    }
    
}

// MARK:- Api Functions
// MARK:-
extension UserSuggestionView {
    @objc func pullToRefresh() {
        self.pageNumber = 1
        refreshControl.beginRefreshing()
        self.getFriendList()
    }
    
    func getFriendList()
       {
           if apiTask?.state == URLSessionTask.State.running {
               return
           }
           //Add userId

   //        guard let user_id = appDelegate.loginUser?.user_id else {
   //            return
   //        }
   //        let UserID = String(user_id)
           let userID = appDelegate.loginUser?.user_id.description
           
           
           apiTask = APIRequest.shared().getFriendList(page: self.pageNumber, request_type: 0, search: userID, group_id : userID?.toInt, showLoader: false, completion: {[weak self] (response, error) in
               guard let self = self else { return }
               self.refreshControl.endRefreshing()
               if response != nil{
                   if let arrList = response!["my_friends"] as? [[String:Any]]{
                       //                    Remove all data here when page number == 1
                       if self.pageNumber == 1{
                           self.arrFilterUser.removeAll()
                           self.tblfriendSuggestionList.reloadData()
                       }
                       
                       //                    Add Data here...
                       if arrList.count > 0{
                           self.arrFilterUser = self.arrFilterUser + arrList
                           self.tblfriendSuggestionList.reloadData()
                           self.pageNumber += 1
                           self.tblfriendSuggestionList.reloadData()
                       }
                       
                       self.updateTablePeople(false)
                   }
               }
           })
           
       }
}

// MARK:- Helper Functions
// MARK:-
extension UserSuggestionView {
    
    func hideSuggestionView (_ textView: GenericTextView) {
        self.arrSelectedUser.removeAll()
        arrFilterUser.removeAll()
        self.tblfriendSuggestionList.reloadData()
        self.updateTablePeople(false)
        self.setAttributeStringInTextView(textView)
    }
    
    fileprivate func updateTablePeople(_ searching: Bool) {
        
        if searching {
            if self.cnTblSuggestionHeight.constant < 60 {
                self.cnTblSuggestionHeight.constant = kSuggestionViewMaxHeight
            }
        }else {
            tblfriendSuggestionList.flashScrollIndicators()
            if #available(iOS 11.0, *) {
                tblfriendSuggestionList.performBatchUpdates({
                    self.cnTblSuggestionHeight.constant = self.tblfriendSuggestionList.contentSize.height < kSuggestionViewMaxHeight ? self.tblfriendSuggestionList.contentSize.height : kSuggestionViewMaxHeight
                }) { (completed) in
                    self.cnTblSuggestionHeight.constant = self.tblfriendSuggestionList.contentSize.height < kSuggestionViewMaxHeight ? self.tblfriendSuggestionList.contentSize.height : kSuggestionViewMaxHeight
                }
            } else {
                GCDMainThread.async {
                    self.cnTblSuggestionHeight.constant = self.tblfriendSuggestionList.contentSize.height < kSuggestionViewMaxHeight ? self.tblfriendSuggestionList.contentSize.height : kSuggestionViewMaxHeight
                }
            }
        }
        
        self.setNeedsUpdateConstraints()
        
        UIView.animate(withDuration: 0.3) {
            self.tblfriendSuggestionList.layoutIfNeeded()
        }
    }

}

// MARK:- Filter user
// MARK:-
extension UserSuggestionView {
    
    func filterUser(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) {
        
        // Cancel request...
        if apiTask?.state == URLSessionTask.State.running {
            apiTask?.cancel()
        }
        
        let finalText = (textView.text as NSString?)?.replacingCharacters(in: range, with: text) ?? text
        if finalText.count > 0 {
            let rangeOfSpecialCharcter = finalText.range(of: "@", options: .backwards)?.upperBound
            if rangeOfSpecialCharcter == nil {
                // Remove all user...
                arrFilterUser.removeAll()
                tblfriendSuggestionList.reloadData()
                self.updateTablePeople(false)
            } else {
                
                if let _ = rangeOfSpecialCharcter {
                    //let searchString = String(finalText[index...])
                    
                    self.updateTablePeople(true)
                    self.pageNumber = 1
                    //self.searchString = searchString
                    self.getFriendList()
                }
                
            }
        }else {
            arrFilterUser.removeAll()
            tblfriendSuggestionList.reloadData()
            self.updateTablePeople(false)
        }
        
        
    }

}

// MARK:- UITableViewDelegate/UITableViewDataSource
// MARK:-
extension UserSuggestionView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFilterUser.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "UserSuggestionTblCell", for: indexPath) as? UserSuggestionTblCell
        {
            let userInfo = arrFilterUser[indexPath.row]
            cell.lblUserName.text = userInfo.valueForString(key: CFirstname) + " " + userInfo.valueForString(key: CLastname)
            cell.imgUser.loadImageFromUrl(userInfo.valueForString(key: CImage), true)
            
            // Load more data...
            if indexPath == tblfriendSuggestionList.lastIndexPath() {
                self.getFriendList()
            }
            
            return cell
        }
        
        return tableView.tableViewDummyCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userInfo = arrFilterUser[indexPath.row]
        arrSelectedUser.append(userInfo)
        // Pass selected user in respective Viewcontroller...
        if userSuggestionDelegate != nil{
            _ = userSuggestionDelegate?.didSelectSuggestedUser!(userInfo)
        }
        arrFilterUser.removeAll()
        self.tblfriendSuggestionList.reloadData()
        self.updateTablePeople(false)
        self.searchString = ""
        self.isSearchString = false
    }

}

// MARK:- TextView
// MARK:-
extension UserSuggestionView {
    
    // Create Final string with Mentions user for comment...
    func stringToBeSendInComment(_ textView : GenericTextView) -> String? {
      //  var toBeSend = textView.text
        var toBeSend = textView.text.replace(string: "\n", replacement: "\\n")
        for userInfo in self.arrSelectedUser {
            let userName = userInfo.valueForString(key: CFirstname) + " " + userInfo.valueForString(key: CLastname)
            let range = toBeSend.nsRange(of: userName)
            if (range.length > 0){
                toBeSend = (toBeSend as NSString?)?.replacingCharacters(in: range, with: NSString(format: kMentionFriendStringFormate as NSString, userInfo.valueForString(key: CUserId)) as String) ?? ""
            }
            
    
        let name = userInfo.valueForString(key: "first_name") + userInfo.valueForString(key: "last_name")
            toBeSend = (toBeSend as NSString?)?.replacingCharacters(in: range, with: NSString(format: kMentionFriendStringFormate as NSString, name) as String) ?? ""
        }
        
        return toBeSend
    }
    
    // To show text with Mentioned user in Textview...
    func arrangeFinalComment(_ userInfo : [String : Any], textView : GenericTextView) {

        let finalText = textView.text
        let rangeOfSpecialCharcter = finalText!.range(of: "@", options: .backwards)?.lowerBound
        let searchString = rangeOfSpecialCharcter.map(finalText!.substring(to:))
        let userName = userInfo.valueForString(key: CFirstname) + " " + userInfo.valueForString(key: CLastname) + " "
        textView.text = "\(searchString ?? "")" + userName
        self.setAttributeStringInTextView(textView)
        
    }
    
     func setAttributeStringInTextView(_ textView : GenericTextView) {

        let cursorPoint = textView.selectedRange
        let string = textView.text
        
        let attrs = [NSAttributedString.Key.font : CFontPoppins(size: textView.font!.pointSize, type: .light),
                     NSAttributedString.Key.foregroundColor: UIColor.black]
        //let attributedString = NSMutableAttributedString(string: string!, attributes:attrs)
        let attributedString = NSMutableAttributedString(string: string ?? "")
        attributedString.setAttributes(attrs, range: NSMakeRange(0, attributedString.length))
        
        for userInfo in self.arrSelectedUser {
            let selectedUserName = userInfo.valueForString(key: CFirstname) + " " + userInfo.valueForString(key: CLastname)
            do {
                let regex = try NSRegularExpression(pattern: selectedUserName)
                let matchesUserName = regex.matches(in: string!, range: NSRange(string!.startIndex..., in: string!))
                
                for matches in matchesUserName {
                    attributedString.setAttributes([NSAttributedString.Key.foregroundColor:ColorBlack, NSAttributedString.Key.font : CFontPoppins(size: 14, type: .meduim).setUpAppropriateFont() as Any], range: matches.range)
                    //attributedString.addAttributes([NSAttributedString.Key.foregroundColor:ColorAppTheme, NSAttributedString.Key.font : CFontPoppins(size: 14, type: .meduim).setUpAppropriateFont() as Any], range: matches.range)
                }
                
            } catch let error {
                print("invalid regex: \(error.localizedDescription)")
            }
        }
    
        textView.setAttributeText(attributedString: attributedString)
        textView.setSelectedRange(range: cursorPoint)
    }
}
