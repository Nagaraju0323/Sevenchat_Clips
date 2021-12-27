//
//  MIAudioPlayer.swift
//  Sevenchats
//
//  Created by mac-0005 on 10/09/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit
import AVFoundation

protocol MIAudioPlayerDelegate: class {
    func MIAudioPlayerDidUpdateTime(_ currentTime : Double? , maximumTime : Double?)
    func MIAudioPlayerDidFinishPlaying(successfully flag: Bool)
}

class MIAudioPlayer: NSObject {
    
    weak var miAudioPlayerDelegate : MIAudioPlayerDelegate?
    
    var trackTimer: Timer?
    var avPlayer: AVPlayer?
    
    private override init() {
        super.init()
    }
    
    private static var player:MIAudioPlayer = {
        let player = MIAudioPlayer()
        return player
    }()
    
    static func shared() ->MIAudioPlayer {
        return player
    }
    
}

// MARK:- -------- TimerFunctions
extension MIAudioPlayer{
    
    func startTrackTimer(){
        trackTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeTick(_:)), userInfo: nil, repeats: true)
    }
    
    @objc fileprivate func timeTick(_ timer : Timer) {
//        print("audioSenderCell.audioSlider === ", self.playerCurrentTime(), self.playerDuration())
        if miAudioPlayerDelegate != nil{
            miAudioPlayerDelegate?.MIAudioPlayerDidUpdateTime(self.playerCurrentTime(), maximumTime : self.playerDuration())
        }
    }
}

// MARK:- -------- AVAudioSession
// MARK:-
extension MIAudioPlayer {
    
    func stopTrack() {
        self.pauseTrack()
        if avPlayer != nil {
            avPlayer?.currentItem?.seek(to: .zero)
        }
    }
    
    func pauseTrack() {
        
        if trackTimer != nil {
            trackTimer?.invalidate()
            trackTimer = nil
        }
        
        if avPlayer != nil {
            avPlayer?.pause()
        }
        
    }
    
    func playTrack() {
        guard let player = avPlayer else {
            // Player is not found...
            GCDMainThread.asyncAfter(deadline: .now() + 1) {
                if self.miAudioPlayerDelegate != nil {
                    self.miAudioPlayerDelegate?.MIAudioPlayerDidFinishPlaying(successfully: true)
                }
            }
            return
        }
        
        if miAudioPlayerDelegate != nil {
            miAudioPlayerDelegate?.MIAudioPlayerDidUpdateTime(self.playerCurrentTime(), maximumTime : self.playerDuration())
        }
        
        player.play()
        self.startTrackTimer()
    }
    
    func seekToTime(_ seekToTime : Double?) {
        if avPlayer != nil {
            
            let playerTimescale = avPlayer?.currentItem?.asset.duration.timescale ?? 1
            let time =  CMTime(seconds: seekToTime!, preferredTimescale: playerTimescale)
            avPlayer!.seek(to: time, toleranceBefore: .zero, toleranceAfter: .zero) { (finished) in 
            }
        }
    }
    
    func prepareTrack(_ audioUrl : URL?) {
        // Dealloc old player...
        if avPlayer != nil {
            self.removePlayerObserver()
            avPlayer?.currentItem?.seek(to: .zero)
            avPlayer = nil
        }
        
        guard let url = audioUrl else { return }
        
        let playerItem = AVPlayerItem(url: url)
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(sender:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
        avPlayer = AVPlayer(playerItem: playerItem)
        self.addPlayerObserver()
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func isPlaying() -> Bool {
        guard let player = avPlayer else {
            return false
        }
        if player.rate != 0 && player.error == nil {
            return true
        }else {
            return false
        }
        
    }
    
    fileprivate func playerCurrentTime() -> Double? {
        guard let player = avPlayer else {
            return 0.0
        }
        
        return CMTimeGetSeconds(player.currentItem?.currentTime() ?? CMTime(seconds: 0, preferredTimescale: 0)).isNaN ? 0.0 : CMTimeGetSeconds(player.currentItem?.currentTime() ?? CMTime(seconds: 0, preferredTimescale: 0))
    }
    
    fileprivate func playerDuration() -> Double? {
        guard let player = avPlayer else {
            return 0.0
        }

        if CMTimeGetSeconds(player.currentItem?.duration ?? CMTime(seconds: 0, preferredTimescale: 0)).isNaN {
            return 0.0
        }
        else {
            return CMTimeGetSeconds(player.currentItem?.duration ?? CMTime(seconds: 0, preferredTimescale: 0))
        }
    }
}

// MARK:- -------- AVPlayer Observer And Notifications
// MARK:-
extension MIAudioPlayer {
    
    @objc func playerDidFinishPlaying(sender: Notification) {
        self.pauseTrack()
        if miAudioPlayerDelegate != nil {
            miAudioPlayerDelegate?.MIAudioPlayerDidFinishPlaying(successfully: true)
        }
    }
    
    fileprivate func addPlayerObserver() {
        guard let player = avPlayer else {return}
        
        player.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions(), context: nil)
    }
    
    fileprivate func removePlayerObserver() {
        guard let player = avPlayer else {return}
        player.removeObserver(self, forKeyPath: "status")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let player = avPlayer else {return}
        
        if keyPath == "status" {
            if player.status == .readyToPlay {
                // Play Here
                self.playTrack()
            }else {
                // Stop here
                self.pauseTrack()
                if miAudioPlayerDelegate != nil {
                    miAudioPlayerDelegate?.MIAudioPlayerDidFinishPlaying(successfully: true)
                }
            }
        }
    }
    
}
