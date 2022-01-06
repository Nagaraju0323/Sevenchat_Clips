////
////  VideoCallCell.swift
////  VideoCallCollectionLayoutDemo
////
////  Created by mac-00013 on 01/10/19.
////  Copyright © 2019 swift. All rights reserved.
////
//
//import UIKit
//import TwilioVideo
//
//class VideoCallCell: UICollectionViewCell {
//    
//    //MARK:-
//    //MARK: - ------- Public Properties
//    @IBOutlet weak var vwMuteImage: UIView!
//    @IBOutlet weak var viewBG: UIView! {
//        didSet {
//            self.viewBG.layer.cornerRadius = 10
//        }
//    }
//    @IBOutlet weak var lblInfo: UILabel!
//    
//    var videoCellModel : AppParticipant!{
//        didSet{
//            if let vw = videoCellModel.remoteView{
//                self.configuration(view: vw)
//            }
//            //self.vwMuteImage.isHidden = (videoCellModel.remoteParticipant.remoteAudioTracks.first?.track?.isEnabled ?? false)
//            self.vwMuteImage.isHidden = true
//        }
//    }
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    func configuration(view: VideoView) {
//        let _ = viewBG.subviews.map({$0.removeFromSuperview()})
//        view.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
//        viewBG.addSubview(view)
//        view.fillSuperview()
//        view.contentMode = .scaleAspectFill
//    }
//    
//}
