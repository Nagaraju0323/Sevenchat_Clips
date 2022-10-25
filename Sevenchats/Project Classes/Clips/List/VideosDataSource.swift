////
////  VideosDataSource.swift
////  Sevenchats
////
////  Created by nagaraju k on 21/09/22.
////  Copyright © 2022 mac-00020. All rights reserved.
////
//
//import Foundation
//
//import AVFoundation
//struct Video {
//   var player : AVQueuePlayer
//}
//
//class VideoDataSource {
//    static let sharedInstance = VideoDataSource()
//    var looper: AVPlayerLooper?
//    var currentIndex = 0 {
//        willSet {
//            videos[currentIndex].player.seek(to: .zero)
//            videos[currentIndex].player.pause()
//            if let looper = looper {
//                looper.disableLooping()
//            }
//        }
//        didSet {
//            looper = AVPlayerLooper(player: videos[currentIndex].player, templateItem: videos[currentIndex].player.currentItem!)
//            videos[currentIndex].player.play()
//        }
//    }
//    func pause() {
//        videos[currentIndex].player.pause()
//    }
//
//    func resume() {
//        guard videos[currentIndex].player.rate == 0 else {
//            return
//        }
//        videos[currentIndex].player.play()
//    }
//
//    func Notificationpause() {
//        videos[currentIndex].player.pause()
//    }
//
//    func Notificationresume() {
//        guard videos[currentIndex].player.rate == 0 else {
//            return
//        }
//        videos[currentIndex].player.play()
//    }
//
//
////    var videos = [
////        Video(player: AVQueuePlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "1", ofType: "mp4")!))),
////        Video( player: AVQueuePlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "11", ofType: "mp4")!))),
////        Video(player: AVQueuePlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "10", ofType: "mp4")!))),
//////            Video(id: 3, player: AVQueuePlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "8", ofType: "mp4")!))),
////        Video( player: AVQueuePlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "9", ofType: "mp4")!))),
////        Video( player: AVQueuePlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "2", ofType: "mp4")!))),
////        Video( player: AVQueuePlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "3", ofType: "mp4")!))),
////        Video(player: AVQueuePlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "4", ofType: "mp4")!))),
////        Video( player: AVQueuePlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "5", ofType: "mp4")!))),
////        Video( player: AVQueuePlayer(url: URL(string: "https://stg.sevenchats.com:3443/iamunited/18464896/1662695075226.mp4")!)),
//////            Video(id: 10, player: AVQueuePlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "7", ofType: "mp4")!)))
////        Video(player: AVQueuePlayer(url: URL(string: "https://stg.sevenchats.com:3443/iamunited/16674872/1663331880312.mp4")!))
////    ]
////
//
//    //TODO: -
//
//
//
//
//}
//
//
//extension ClipsListViewController{
//
//
//    @objc func button1CLK(sender: UIButton) {
//        sender.isSelected = !sender.isSelected
//
//        if(sender.isSelected == true){
//            print("isselected");
//            VideoDataSource.sharedInstance.resume()
//
//        }else{
//            VideoDataSource.sharedInstance.pause()
//            print("notisSelectd");
//        }
//    }
//
//    @objc func handlePanGesture(_ sender: UIPanGestureRecognizer) {
//
//        if select == true{
//            print("pause")
//            select = false
//            VideoDataSource.sharedInstance.pause()
//            print("notisSelectd");
//        }else{
//            print("play")
//            select = true
//            print("isselected");
//            VideoDataSource.sharedInstance.resume()
//        }
//    }
//
//
//}
