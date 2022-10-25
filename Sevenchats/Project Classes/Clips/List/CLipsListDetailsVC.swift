//
//  CLipsListDetailsVC.swift
//  Sevenchats
//
//  Created by nagaraju k on 25/09/22.
//  Copyright © 2022 mac-00020. All rights reserved.
//

import UIKit
import AVFAudio
import AVFoundation

class CLipsListDetailsVC: ParentViewController {
    
    @IBOutlet weak var mainTableView: UITableView!
    
    @objc dynamic var currentIndex = 0
 
    var arrClipsList = [[String:Any]]()
    var pageNumber = 1
    var refreshControl = UIRefreshControl()
    var apiTask : URLSessionTask?
    var isLoadMoreCompleted =  false
    var oldAndNewIndices = (0,0)
   
    override func viewDidLoad() {
        super.viewDidLoad()

      Intilization()
      setAudioMode()
    }
    
    // Setup Audio
    func setAudioMode() {
        do {
            try! AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch (let err){
            print("setAudioMode error:" + err.localizedDescription)
        }
        
    }
    
    func Intilization(){
        mainTableView.backgroundColor = .black
        mainTableView.translatesAutoresizingMaskIntoConstraints = false  // Enable Auto Layout
        mainTableView.tableFooterView = UIView()
        mainTableView.isPagingEnabled = true
        mainTableView.contentInsetAdjustmentBehavior = .never
        mainTableView.showsVerticalScrollIndicator = false
        mainTableView.separatorStyle = .none
      
        mainTableView.register(UINib(nibName: "ClipDetailbTblCell", bundle: nil), forCellReuseIdentifier: "ClipDetailbTblCell")
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.prefetchDataSource = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        self.getPostListFromServer()
        if let cell = mainTableView.visibleCells.first as? ClipDetailbTblCell {
            print("----SecondCalled")
            cell.play()
        }
        
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let cell = mainTableView.visibleCells.first as? ClipDetailbTblCell {
            cell.pause()
        }
    }
    
}


// MARK: - Table View Extensions
extension CLipsListDetailsVC: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrClipsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClipDetailbTblCell", for: indexPath) as! ClipDetailbTblCell
        cell.configure(post: arrClipsList[indexPath.row])
        if indexPath == mainTableView.lastIndexPath() && !self.isLoadMoreCompleted{
            getPostListFromServer()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height
    }
    
//
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // If the cell is the first cell in the tableview, the queuePlayer automatically starts.
        // If the cell will be displayed, pause the video until the drag on the scroll view is ended
        if let cell = cell as? ClipDetailbTblCell{
            oldAndNewIndices.0 = indexPath.row
            currentIndex = indexPath.row
            cell.pause()
        }
        
        
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Pause the video if the cell is ended displaying
        if let cell = cell as? ClipDetailbTblCell {
            cell.pause()
        }
    }
//
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
//        for indexPath in indexPaths {
//            print(indexPath.row)
//        }
    }
//
    
}


extension CLipsListDetailsVC{
    
    func getPostListFromServer(){
        
        if apiTask?.state == URLSessionTask.State.running {
            refreshControl.beginRefreshing()
            return
        }
        
        let encryptUser = EncryptDecrypt.shared().encryptDecryptModel(userResultStr: appDelegate.loginUser?.user_id.description ?? "")
        apiTask = APIRequest.shared().getClipsList(userID: appDelegate.loginUser?.user_id.description ?? "", page: pageNumber) { [weak self] (response, error) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if response != nil && error == nil {
                    let metaData = response?.value(forKey: CJsonMeta) as? [String : AnyObject]
                    if metaData!["status"] as? String != "0"{
                        print("error")
                    }else {
                        let arrList = response!["data"] as! [[String:Any]]
                        if self.pageNumber == 1 {
                            self.arrClipsList.removeAll()
                        }
                        self.isLoadMoreCompleted = arrList.isEmpty
                        if arrList.count > 0 {
                            self.arrClipsList = self.arrClipsList + arrList
                            self.mainTableView.reloadData()
                            self.pageNumber += 1
                            
                        }
                    }
                }else {
                    print("error------\(error)")
                    
                }
            }
        }
    }
}

// MARK: - ScrollView Extension
extension CLipsListDetailsVC: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let cell = self.mainTableView.cellForRow(at: IndexPath(row: self.currentIndex, section: 0)) as? ClipDetailbTblCell
        cell?.replay()
    }
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        var visibleRect = CGRect()
//
//        visibleRect.origin = self.mainTableView.contentOffset
//        visibleRect.size = self.mainTableView.bounds.size
//
//        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
//
//        guard let indexPath = self.mainTableView.indexPathForRow(at: visiblePoint) else { return }
//
//        print(indexPath)
//    }
    
}

// MARK: - Navigation Delegate
// TODO: Customized Transition
extension CLipsListDetailsVC: HomeCellNavigationDelegate {
    func navigateToProfilePage(userID: String) {
        appDelegate.moveOnProfileScreenNew(userID, "", self)
    }
}
