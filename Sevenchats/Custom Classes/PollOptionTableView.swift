//
//  PollOptionTableView.swift
//  Sevenchats
//
//  Created by mac-00020 on 06/06/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
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
    var arrPollInformation : [MDLPollInformation] = []
    
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
    var pollIsSelected = ""
    var isDetailsSelected :Bool?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    //MARK:- Override
    override func awakeFromNib() {
        super.awakeFromNib()
        DispatchQueue.main.async {
            
            
            self.postIDNew = self.postinfo.valueForString(key: "post_id").toInt ?? 0
            //            if self.isLikesOthersPage == true {
            //                self.SelectedByUser = self.postinfo.valueForString(key: "is_selected")
            //                let replaced2 = self.SelectedByUser.replacingOccurrences(of: "\"", with: "")
            //                let replaced3 = replaced2.replacingOccurrences(of: "[", with: "")
            //                let replaced4 = replaced3.replacingOccurrences(of: "]", with: "")
            //                self.isSelectedByUser = replaced4
            //            }else {
            //
            //                self.SelectedByUser = self.postinfo.valueForString(key: "is_selected")
            //                let replaced2 = self.SelectedByUser.replacingOccurrences(of: "\"", with: "")
            //                let replaced3 = replaced2.replacingOccurrences(of: "[", with: "")
            //                let replaced4 = replaced3.replacingOccurrences(of: "]", with: "")
            //                self.isSelectedByUser = replaced4
            //            }
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
        cell.btnCheckAnwer.isSelected = false
        cell.btnCheckAnwer.isHidden = false
        cell.btnSelectAnwer.isHidden = false
        //option.calculateVote(totalVote: totalVotes)
        
        if "\(self.userEmailID)" == "\(String(describing: appDelegate.loginUser?.email ?? ""))"{
            //        if "\(self.userID)" == "\(String(describing: appDelegate.loginUser?.user_id ?? 0))"{
            cell.btnCheckAnwer.isHidden = true
            cell.btnSelectAnwer.isHidden = true
            let percentag = (option.pollVotePer / 100.0)
            cell.progressV.setProgress(Float(percentag), animated: false)
            cell.lblPercentage.text = "\(Int((percentag * 100).rounded()))%"
            
        }else if pollIsSelected != "N/A"{
            let percentag = (option.pollVotePer / 100.0)
            cell.progressV.setProgress(Float(percentag), animated: false)
            cell.lblPercentage.text = "\(Int((percentag * 100).rounded()))%"
            if option.pollText == self.isSelectedByUser{
                cell.btnCheckAnwer.isHidden = true
            }else{
                cell.btnCheckAnwer.isHidden = true
            }
            
            if userVotedPollId == option.pollId{
                cell.btnCheckAnwer.isSelected = true
            }else{
                cell.btnCheckAnwer.isHidden = true
            }
        }else{
            cell.progressV.setProgress(0.0, animated: true)
            cell.lblPercentage.text = ""
        }
        
        cell.btnCheckAnwer.tag = indexPath.row
        cell.btnSelectAnwer.tag = indexPath.row
        cell.btnCheckAnwer.isUserInteractionEnabled = !self.isSelected
        cell.btnSelectAnwer.isUserInteractionEnabled = !self.isSelected
        let dispatchGroupUpdate = DispatchGroup()
        cell.didSelected = { [weak self] (index) in
            guard let _ = self else {return}
            let optionID = self?.arrPollInformation.first?.post_id?.toInt ?? 0
            let optiontext = option.pollText
            //dispatchgroup Create
            
            dispatchGroupUpdate.enter()
            DispatchQueue.main.async {
                self?.apiForVoteForPoll(optiontext ?? "", optionID:optionID) { (success,result,totalCount) -> Void in
                    if success {
                        if result == 0{
                            self?.updateindex?(index)
                            let total = Double(totalCount)
                            cell.progressV.setProgress(Float(total), animated: false)
                            cell.lblPercentage.text = "\(Int((total * 100).rounded()))%"
                            
                            cell.btnCheckAnwer.isHidden = false
                            cell.btnCheckAnwer.isSelected = true
                        }else {
                            return
                        }
                    }
                }
                dispatchGroupUpdate.leave()
            }
            
        }
        
        dispatchGroupUpdate.notify(queue: .main) {
            print("this is completed")
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
//        if "\(self.userEmailID)" != "\(String(describing: appDelegate.loginUser?.email ?? ""))"{return}
        
        if "\(self.userEmailID)" != "\(String(describing: appDelegate.loginUser?.email ?? ""))"{return}else {
                 
                    print("totalVotesCount\(self.totalVotes)")
                    if self.totalVotes == 0{
                        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
                        alertWindow.rootViewController = UIViewController()
                        
                        let alertController = UIAlertController(title: "", message: CAlreadyCannotVoted, preferredStyle: UIAlertController.Style.alert)
                        alertController.addAction(UIAlertAction(title: CBtnOk, style: UIAlertAction.Style.cancel, handler: { _ in
                            alertWindow.isHidden = true
                            return
                        }))
                        
                        alertWindow.windowLevel = UIWindow.Level.alert + 1;
                        alertWindow.makeKeyAndVisible()
                        alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
                       return
                    }
                }
        
        
        self.postDetailsList(optionTexts: self.optionText,arg: true, completion:{(success) -> Void in
            if success {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.40) {
                    if self.arrOptionNew.count <= 0{
                            let alertWindow = UIWindow(frame: UIScreen.main.bounds)
                            alertWindow.rootViewController = UIViewController()
                            
                            let alertController = UIAlertController(title: "", message: CAlreadyCannotVoted, preferredStyle: UIAlertController.Style.alert)
                            alertController.addAction(UIAlertAction(title: CBtnOk, style: UIAlertAction.Style.cancel, handler: { _ in
                                alertWindow.isHidden = true
                                return
                            }))
                            
                            alertWindow.windowLevel = UIWindow.Level.alert + 1;
                            alertWindow.makeKeyAndVisible()
                            alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
                         
                        return
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
    func apiForVoteForPoll(_ optionText:String,optionID:Int,completion: @escaping (_ success: Bool,_ result:Int,_ totalCount:Int) -> Void){
        //    func apiForVoteForPoll(_ optiontext:String){
        
        var apiPara = [String : Any]()
        apiPara[CPostId] = optionID.toString
        apiPara["option"] = optionText
        apiPara["user_id"] = appDelegate.loginUser?.user_id.description
        APIRequest.shared().voteForPoll(para: apiPara) { [weak self] (response, error) in
            guard let _ = self else {return}
            if response != nil && error == nil{
                if let metaData = response?[CJsonMeta] as? [String : AnyObject] {
                    if metaData.valueForString(key: "status") == "0" {
                        self?.postDetails(postID:self?.postID.toString ?? "") { (success,resultCount) -> Void in
                            if success == true {
                                completion(true,0,resultCount)
                            }
                        }
                        
                    }
                }
            }else {
                guard  let errorUserinfo = error?.userInfo["error"] as? String else {return}
                let errorMsg = errorUserinfo.stringAfter(":")
                if errorMsg ==  " option Already Exists"{
                    let alertWindow = UIWindow(frame: UIScreen.main.bounds)
                    alertWindow.rootViewController = UIViewController()
                    
                    let alertController = UIAlertController(title: "", message: CAlreadyVoted, preferredStyle: UIAlertController.Style.alert)
                    alertController.addAction(UIAlertAction(title: CBtnOk, style: UIAlertAction.Style.cancel, handler: { _ in
                        alertWindow.isHidden = true
                        //                            self?.postDetails(postID:self?.postID.toString ?? "")
                        completion(true, 1,0)
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
    func postDetails(postID:String,completion: @escaping (_ success: Bool,_ resultCount:Int) -> Void){
        
        var para = [String:Any]()
        para["id"] = postID
        para["user_id"] = appDelegate.loginUser?.user_id.description
        guard let userID = appDelegate.loginUser?.user_id else {return}
     
        APIRequest.shared().viewPostDetailLatest(postID: postID.toInt ?? 0,userid: userID.description , apiKeyCall: "polls"){ [weak self] (response, error) in
        
//        APIRequest.shared().viewPollDetailNew(postID: postID.toInt ?? 0) { [weak self] (response, error) in
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
//                                    let indexOfA  = self?.pollOptionArr.firstIndex(of: key)
                                    let indexOfA  = self?.pollOptionArr.firstIndex(of: key.trimmingCharacters(in: CharacterSet.whitespaces))
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
//                                    let indexOfA  = self?.pollOptionArr.firstIndex(of: key)
                                    let indexOfA  = self?.pollOptionArr.firstIndex(of: key.trimmingCharacters(in: CharacterSet.whitespaces))
                                    arrayData.remove(at: indexOfA ?? 0)
                                    arrayData.insert("\(value)", at: indexOfA ?? 0)
                                }
                                
                                self?.arr += arrayData
                            }
                            self?.dictArray = self?.arr ?? []
                            self?.isSelected = true
                            self?.totalVotesNew = datas.valueForString(key: "total_count")
                            self?.refereshData = datas
                            completion(true, self?.totalVotesNew.toInt ?? 0)
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
        
        apiTask = APIRequest.shared().votePollDetailsList(optionText : optionText,postID : self.postID.toString) { (response, error) in
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




