//
//  PollOptionTableView.swift
//  Sevenchats
//
//  Created by mac-00020 on 06/06/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : PollOptionTableView                         *
 * Changes : poll selection dispaly percentages          *
 *                                                       *
 ********************************************************/



import Foundation
import UIKit

class PollOptionTableView: UITableView {
    
    //MARK: - IBOutlet/Object/Variable Declaration
    var onReloadTable : (()->Void)? = nil
    var arrOption : [MDLPollOption] = []
    var arrOptions : [MDLPollOption] = []
    var arrOptionsch : [MDLPollOption] = []
    var arrOptionNew : [MDLPollOptionsNew] = []
    
    var isSelected = false
    var postID = 0
    var userID = 0
    var userVotedPollId = 0
    var postIDNew = 0
    var userEmailID = ""
    var votedOption = ""
    var optionPoll = [Double]()
    var voteList = [String: Any]()
    var postinfo = [String: Any]()
    var strinEmpty = ""
    
    var totalVotes = 0
    var totalVotesNew = ""
    var updateVoteCount : ((Int) -> Void)?
    var refreshOnVoteWithData : (([String:Any],Int) -> Void)?
    var parameters = [String: Any]()
    var dictArray = [String]()
    var arrPostList = [String : Any]()
    var optionText = ""
    var apiTask : URLSessionTask?
    var arr = [String]()
    var isSelectedByUser = ""
    var updateVoteCountReload : (([String:Any]) -> Void)?
    var refereshData = [String:Any]()
    var pollOptionArr:[String] = []
    var updateindex : ((Int) -> Void)?
    var isLikesOthersPage:Bool?
    var SelectedByUser = ""
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    //MARK:- Override
    override func awakeFromNib() {
        super.awakeFromNib()
        DispatchQueue.main.async {

            self.postIDNew = self.postinfo.valueForString(key: "post_id").toInt ?? 0
            if self.isLikesOthersPage == true {
                self.SelectedByUser = self.postinfo.valueForString(key: "is_selected")
                let replaced2 = self.SelectedByUser.replacingOccurrences(of: "\"", with: "")
                let replaced3 = replaced2.replacingOccurrences(of: "[", with: "")
                let replaced4 = replaced3.replacingOccurrences(of: "]", with: "")
                self.isSelectedByUser = replaced4
            }else {
               
                self.SelectedByUser = self.postinfo.valueForString(key: "is_selected")
                let replaced2 = self.SelectedByUser.replacingOccurrences(of: "\"", with: "")
                let replaced3 = replaced2.replacingOccurrences(of: "[", with: "")
                let replaced4 = replaced3.replacingOccurrences(of: "]", with: "")
                self.isSelectedByUser = replaced4
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
            self.postDetails(postID: self.postIDNew.toString)
        }
    }
    
    override var contentSize:CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
    
    fileprivate func initialize(){
        
       
        self.backgroundColor =  .clear
        self.register(UINib(nibName: "PollProgressTblCell", bundle: nil), forCellReuseIdentifier: "PollProgressTblCell")
        self.separatorStyle = .none
        self.tableFooterView = UIView(frame: .zero)
        self.delegate = self
        self.dataSource = self
        self.estimatedRowHeight = 40
        //self.rowHeight = 40
        self.allowsSelection = true
        self.reloadData()
    }
}

// MARK: - UITableViewDelegate,UITableViewDataSource
extension PollOptionTableView : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrOption.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PollProgressTblCell") as? PollProgressTblCell else {
            return UITableViewCell(frame: .zero)
        }
        
        let option = self.arrOption[indexPath.row]
        cell.lblName.text = option.pollText
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.60) {
            if "\(self.userEmailID)" == "\(String(describing: appDelegate.loginUser?.email ?? ""))"{
                let intArray = self.dictArray.compactMap { Double($0) }
                let total = Double(self.totalVotesNew) ?? 0
                
                for res in intArray {
                    let percentagecorrect :Double! = (res / total) * 100
                    guard !(percentagecorrect.isNaN || percentagecorrect.isInfinite) else {
                        return
                    }
                    
                    let left = Double(Int(percentagecorrect))
                   // print("leftvalues:::::::\(left)")
                    self.optionPoll.append(left )
                    cell.btnCheckAnwer.isHidden = true
                    cell.btnSelectAnwer.isHidden = true
                    let percentag = (self.optionPoll[indexPath.row] / 100.0)
                    cell.progressV.setProgress(Float(percentag), animated: false)
                    cell.lblPercentage.text = "\(Int((self.optionPoll[indexPath.row]).rounded()))%"
                    
                }
                cell.btnCheckAnwer.isHidden = true
                cell.btnSelectAnwer.isHidden = true
                
            }else if self.isSelectedByUser != "N/A" &&  self.isSelectedByUser != "" {
//                DispatchQueue.main.async {
                    let intArray = self.dictArray.compactMap { Double($0) }
                    let total = Double(self.totalVotesNew) ?? 0
                    for res in intArray {
                        let percentagecorrect :Double! = (res / total) * 100
                        guard !(percentagecorrect.isNaN || percentagecorrect.isInfinite) else {
                            return
                        }
                        let left = Double(Int(percentagecorrect))
                        self.optionPoll.append(left)
                        cell.btnCheckAnwer.isHidden = true
                        cell.btnSelectAnwer.isHidden = true
                        let percentag = (self.optionPoll[indexPath.row] / 100.0)
                        cell.progressV.setProgress(Float(percentag), animated: false)
                        cell.lblPercentage.text = "\(Int((percentag * 100).rounded()))%"
              //  }
                }
                
                if option.pollText == self.isSelectedByUser{
                    cell.btnCheckAnwer.isHidden = false
                    cell.btnCheckAnwer.isSelected = true
                    //print("voted")
                }else{
                    cell.btnCheckAnwer.isHidden = true
                    //print("not voted")
                }
            }else{
                
                cell.btnCheckAnwer.isSelected = false
                cell.btnSelectAnwer.isSelected = false
                cell.progressV.setProgress(0.0, animated: true)
                cell.lblPercentage.text = ""
            }
            
            cell.btnCheckAnwer.tag = indexPath.row
            cell.btnSelectAnwer.tag = indexPath.row
            cell.didSelected = { [weak self] (index) in
                guard let _ = self else {return}
                let optiontext = option.pollText

                self?.apiForVoteForPoll(optiontext ?? "") { (success,result) -> Void in
                    if success {
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.40) {
                            MILoader.shared.hideLoader()
                            self?.updateindex?(index)
                            let total = Double(self?.totalVotesNew ?? "0.0") ?? 0
                            cell.progressV.setProgress(Float(total), animated: false)
                            cell.lblPercentage.text = "\(Int((total * 100).rounded()))%"
                            if result == 1{
                                
                                cell.btnCheckAnwer.isHidden = false
                                cell.btnCheckAnwer.isSelected = true
                            }else {
                                cell.btnSelectAnwer.isSelected = true
                            }
                            
                        }
                    }
                }
            }
        }
        cell.progressV.updateLayout()
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()
        cell.layoutIfNeeded()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if apiTask?.state == URLSessionTask.State.running {
            return
        }
        if let cell = tableView.cellForRow(at: indexPath) as? PollProgressTblCell {
            optionText =  cell.lblName.text ?? ""
        }
        if "\(self.userEmailID)" == "\(String(describing: appDelegate.loginUser?.email ?? ""))"{return}
        
        self.postDetailsList(optionTexts: self.optionText,arg: true, completion:{(success) -> Void in
            if success {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.40) {
                    if self.arrOptionNew.count <= 0{
                        return;
                    }
                    if let pollVoteList = CStoryboardPoll.instantiateViewController(withIdentifier: "PollVotesListViewController") as? PollVotesListViewController {
                        pollVoteList.pollUsers = self.arrOptionNew
                        self.viewController?.navigationController?.pushViewController(pollVoteList, animated: true)
                    }
                }
            } else {
                print("false")
            }
        })
    }
}
////MARK:- API's Calling
extension PollOptionTableView {
//    (completion: (success: Bool) -> Void)
    func apiForVoteForPoll(_ optiontext:String,completion: @escaping (_ success: Bool,_ result:Int) -> Void){
//    func apiForVoteForPoll(_ optiontext:String){

        var apiPara = [String : Any]()
        apiPara[CPostId] = self.postIDNew
        apiPara["option"] = optiontext
        apiPara["user_id"] = appDelegate.loginUser?.user_id.description
        APIRequest.shared().voteForPoll(para: apiPara) { [weak self] (response, error) in
            guard let _ = self else {return}
            if response != nil && error == nil{
                if let metaData = response?[CJsonMeta] as? [String : AnyObject] {
                    if metaData.valueForString(key: "status") == "0" {
                        self?.postDetails(postID:self?.postIDNew.toString ?? "")
                        completion(true, 0)
                    }
                }
            }else {
                guard  let errorUserinfo = error?.userInfo["error"] as? String else {return}
                let errorMsg = errorUserinfo.stringAfter(":")
                if errorMsg ==  " option Already Exists"{
                    let alertWindow = UIWindow(frame: UIScreen.main.bounds)
                        alertWindow.rootViewController = UIViewController()

                        let alertController = UIAlertController(title: "Error", message: errorMsg, preferredStyle: UIAlertController.Style.alert)
                        alertController.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.cancel, handler: { _ in
                            alertWindow.isHidden = true
                            self?.postDetails(postID:self?.postIDNew.toString ?? "")
                            completion(true, 1)
                            return
                        }))

                        alertWindow.windowLevel = UIWindow.Level.alert + 1;
                        alertWindow.makeKeyAndVisible()
                        alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}


//MARK:- API's Calling
extension PollOptionTableView{
    func postDetails(postID:String){
        
        var para = [String:Any]()
        para["id"] = postID
        para["user_id"] = appDelegate.loginUser?.user_id.description
        
        APIRequest.shared().viewPollDetailNew(postID: postID.toInt ?? 0) { [weak self] (response, error) in
            guard let _ = self else {return}
            if response != nil{
                self?.arr.removeAll()
                var arrayData  = ["0","0","0","0"]
                if let data = response![CData] as? [[String:Any]]{
                    if data.count == 1 {
                        for datas in data{
                            self?.arrOption = []
                            let objarray = (datas["options"] as? String ?? "" ).replace(string: "\"", replacement: "")
                            
                            self!.pollOptionArr =  self?.jsonToStringConvert(pollString:datas["options"] as? String ?? "") ?? []
                            let obj = datas["results"] as? [String : AnyObject] ?? [:]
                            if obj.count == 1 {
                                self?.arrPostList =  obj
                                for (key, value) in obj {
                                   // print("keyvalues:::::::\(key) values:::::::: \(value)")
                                    let indexOfA  = self?.pollOptionArr.firstIndex(of: key)
                                    if indexOfA == 0{
                                        self?.arr = ["\(value)","0","0","0"]
                                    }else if indexOfA == 1{
                                        self?.arr = ["0","\(value)","0","0"]
                                    }else if indexOfA == 2{
                                        self?.arr = ["0","0","\(value)","0"]
                                    }else if indexOfA == 3{
                                        self?.arr = ["0","0","0","\(value)",]
                                    }
                                }
                            }else {
                                self?.arrPostList =  obj
                                for (key, value) in obj {
                                   // print("key\(key) values \(value)")
                                    //                                    self?.arr.append("\(value)")
                                    let indexOfA  = self?.pollOptionArr.firstIndex(of: key)
                                    arrayData.remove(at: indexOfA ?? 0)
                                    arrayData.insert("\(value)", at: indexOfA ?? 0)
                                }
                                
                                self?.arr += arrayData
                            }
                            self?.dictArray = self?.arr ?? []
                            self?.isSelected = true
                            self?.totalVotesNew = datas.valueForString(key: "total_count")
                            self?.refereshData = datas
                            GCDMainThread.async {
                                self?.updateVoteCount?(self?.totalVotesNew.toInt ?? 0)
                                
                                self?.refreshOnVoteWithData?(datas,self?.totalVotesNew.toInt ?? 0)
                                
                                
                            }
                        }
                    }
                }
            }
        }
    }
    func postDetailsList(optionTexts: String,arg: Bool, completion: (Bool) -> ()) {
        
        apiTask = APIRequest.shared().votePollDetailsList(optionText : optionText,postID : self.postIDNew.toString) { (response, error) in
            self.arrOptionNew.removeAll()
            if response != nil && error == nil {
                if let arrData = response![CJsonData] as? [[String : Any]]{
                    for dict in arrData {
                        self.arrOptionNew.append(MDLPollOptionsNew(fromDictionary: dict))
                    }
                }
            }
        }
        completion(arg)
    }
    
    
    func jsonToStringConvert(pollString:String) -> [String]{
        var jsonStrPoll = [String]()
        let data = pollString.data(using: .utf8)!
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String]{
                jsonStrPoll = jsonArray
            } else {
                print("bad json")
            }
        } catch let error as NSError {
            print(error)
        }
        return jsonStrPoll
    }
    
    
}




