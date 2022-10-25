//
//  ClipsListViewController.swift
//  Sevenchats
//
//  Created by nagaraju k on 19/09/22.
//  Copyright © 2022 mac-00020. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

struct Video {
    var player : AVQueuePlayer
}


class ClipsListViewController: ParentViewController {
    
    //Intilization
    
    @IBOutlet var SCrlView : UIScrollView!
    var arrClipsList = [[String:Any]]()
    var pageNumber = 1
    var refreshControl = UIRefreshControl()
    var apiTask : URLSessionTask?
    var select = true
    var videos = [Video]()
    
    var looper: AVPlayerLooper?
    
    var currentIndex = 0 {
        willSet {
            print("-------VidoesCount\(videos)")
            videos[currentIndex].player.seek(to: .zero)
            videos[currentIndex].player.pause()
            if let looper = looper {
                looper.disableLooping()
            }
        }
        didSet {
     
            if currentIndex == 8{
                DispatchQueue.main.async {
                    self.getPostListFromServer(){ (success) -> Void in
                        if success{
                            self.currentIndex = 0
                            self.loadvideosFromServer()
                            self.resume()
//                            self.view.layoutIfNeeded()
                        }
                    }
                }
            }else{
//                print("-------CurrentIndex\(currentIndex)")
                looper = AVPlayerLooper(player: videos[currentIndex].player, templateItem: videos[currentIndex].player.currentItem!)
                videos[currentIndex].player.play()
            }
       
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Clips"
        Intilization()
        
    }
    
    func Intilization(){
        self.getPostListFromServer(){ (success) -> Void in
            
            if success{
                self.currentIndex = 0
                self.resume()
                self.loadvideosFromServer()
            }
            
        }
    }
    
    @objc func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        
        if select == true{
            select = false
            pause()
        }else{
            select = true
            resume()
        }
    }
    
    func makePlayerViewController(player: AVPlayer, yPos: CGFloat) -> AVPlayerViewController{
        
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.showsPlaybackControls = false
        playerViewController.videoGravity = .resizeAspect
        playerViewController.view.backgroundColor = .black
        playerViewController.view.frame = CGRect(x: 0, y: yPos, width:UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        //MARK: - Button User
        let btnUser:UIButton = UIButton(frame: CGRect(x: self.view.frame.width - 55 , y: self.view.frame.width - 0, width: 50, height:  50))
        btnUser.setImage(UIImage(named: "user.png"), for: .normal)
        btnUser.addTarget(self, action:#selector(self.UserBtnCLK), for: .touchUpInside)
        
        
        
        //MARK: - Label nmae
        let lblname = UILabel()
        
        playerViewController.contentOverlayView?.addSubview(btnUser)
        //        playerViewController.contentOverlayView?.addSubview(button)
        //        playerViewController.contentOverlayView?.addSubview(button2)
        //        playerViewController.contentOverlayView?.addSubview(button3)
        //        playerViewController.contentOverlayView?.addSubview(lblLike)
        //        playerViewController.contentOverlayView?.addSubview(lblComment)
        //        playerViewController.contentOverlayView?.addSubview(lblname)
        //        playerViewController.contentOverlayView?.addSubview(btncarema)
        //        playerViewController.contentOverlayView?.addSubview(btnback)
        return playerViewController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        pause()
    }
    
    
    func pause() {
        videos[currentIndex].player.pause()
    }
    
    func resume() {
        guard videos[currentIndex].player.rate == 0 else {
            return
        }
        videos[currentIndex].player.play()
    }
    
    func Notificationpause() {
        videos[currentIndex].player.pause()
    }
    
    func Notificationresume() {
        guard videos[currentIndex].player.rate == 0 else {
            return
        }
        videos[currentIndex].player.play()
    }
    
    
    
    //MARK: -
    @objc func UserBtnCLK(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if(sender.isSelected == true){
            print("isselected");
            resume()
            
        }else{
            pause()
            print("notisSelectd");
        }
    }
    
}

//MARK: - API Call

extension ClipsListViewController{
    
    func getPostListFromServer(completion:@escaping (_ success: Bool) -> Void){
        
        if apiTask?.state == URLSessionTask.State.running {
            refreshControl.beginRefreshing()
            return
        }
        
        let encryptUser = EncryptDecrypt.shared().encryptDecryptModel(userResultStr: appDelegate.loginUser?.user_id.description ?? "")
        apiTask = APIRequest.shared().getClipsList(userID: appDelegate.loginUser?.user_id.description ?? "", page: pageNumber) { [weak self] (response, error) in
            guard let self = self else { return }
            self.videos.removeAll()
            self.arrClipsList.removeAll()
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
                        if arrList.count > 0 {
                            self.arrClipsList = self.arrClipsList + arrList
                            
                            self.arrClipsList.forEach({ videosURL in
                                self.videos.append(Video(player: AVQueuePlayer(url: URL(string: videosURL.valueForString(key: "media"))!)))
                            })
                            completion(true)
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

extension ClipsListViewController {
    
    
    func loadvideosFromServer(){
        SCrlView = UIScrollView(frame: view.bounds)
        SCrlView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(SCrlView)
        let userTap = UITapGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        userTap.cancelsTouchesInView = false
        select = true
        userTap.numberOfTapsRequired = 1
        SCrlView.addGestureRecognizer(userTap)
        var yPos = 0
        
        videos.forEach { (video) in
            let playerViewController =  makePlayerViewController(player: video.player, yPos:CGFloat(yPos))
            
            SCrlView.addSubview(playerViewController.view)
            self.addChild(playerViewController)
            
            yPos = yPos + Int(UIScreen.main.bounds.height)
        }
        SCrlView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * CGFloat(videos.count))
        SCrlView.showsVerticalScrollIndicator = false
        SCrlView.showsHorizontalScrollIndicator = false
        
        // to ignore safe area...
        SCrlView.contentInsetAdjustmentBehavior = .never
        SCrlView.isPagingEnabled = true
        SCrlView.delegate = self
    }
    
}


extension ClipsListViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.y / UIScreen.main.bounds.height)
        if currentIndex != index {
            currentIndex = index
        }
    }
}


