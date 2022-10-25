//
//  ClipDetailbTblCell.swift
//  Sevenchats
//
//  Created by nagaraju k on 25/09/22.
//  Copyright © 2022 mac-00020. All rights reserved.
//

import UIKit
import AVFoundation
import MarqueeLabel

protocol HomeCellNavigationDelegate: class {
    // Navigate to Profile Page
    func navigateToProfilePage(userID: String)
}

class ClipDetailbTblCell: UITableViewCell {
    
    // MARK: - UI Components
    var playerView: VideoPlayerView!
    @IBOutlet weak var nameBtn: UIButton!
    @IBOutlet weak var captionLbl: UILabel!
    @IBOutlet weak var musicLbl: MarqueeLabel!
    @IBOutlet weak var profileImgView: UIImageView!{
        didSet{
            
            profileImgView.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(navigateToProfilePage))
            profileImgView.addGestureRecognizer(tapGesture)
        }
    }
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var likeCountLbl: UILabel!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var commentCountLbl: UILabel!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var musicBtn: UIButton!
    @IBOutlet weak var shareCountLbl: UILabel!
    @IBOutlet weak var pauseImgView: UIImageView!{
        didSet{
            pauseImgView.alpha = 0
        }
    }
   
    // MARK: - Variables
    private(set) var isPlaying = false
    private(set) var liked = false
    weak var delegate: HomeCellNavigationDelegate?
    
    // MARK: LIfecycles
    override func prepareForReuse() {
        super.prepareForReuse()
        playerView.cancelAllLoadingRequest()
        resetViewsForReuse()
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.profileImgView.makeRounded(color: .white, borderWidth: 1)
        self.followBtn.makeRounded(color: .clear, borderWidth: 0)
        self.musicBtn.makeRounded(color: .clear, borderWidth: 0)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        playerView = VideoPlayerView(frame: self.contentView.frame)
        musicLbl.holdScrolling = true
        musicLbl.animationDelay = 0
        
        
        contentView.addSubview(playerView)
        contentView.sendSubviewToBack(playerView)
        
        let pauseGesture = UITapGestureRecognizer(target: self, action: #selector(handlePause))
        self.contentView.addGestureRecognizer(pauseGesture)
        
        let likeDoubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLikeGesture(sender:)))
        likeDoubleTapGesture.numberOfTapsRequired = 2
        self.contentView.addGestureRecognizer(likeDoubleTapGesture)
        
        pauseGesture.require(toFail: likeDoubleTapGesture)
    }
    
    var userID:String = ""
    
    func configure(post:[String:Any]){
        
//
        let userDetails = post["user_details"] as? [String:Any] ?? [:]
//        print("-------postDeatils\(userDetails)")
        
        nameBtn.setTitle("@" + "\(userDetails["first_name"] ?? "")" + "\(userDetails["last_name"] ?? "")",  for: .normal)
        userID = userDetails["user_id"] as! String
        nameBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        profileImgView.loadImageFromUrl(userDetails.valueForString(key: CUserProfileImage), true)
        
        musicLbl.text = post.valueForString(key: "tags")
        // Long enough to enable scrolling
        captionLbl.text =  post.valueForString(key: "post_description")
        likeCountLbl.text = post.valueForString(key: "likes").toInt?.shorten()
        commentCountLbl.text = post.valueForString(key: "comments").toInt?.shorten()
        shareCountLbl.text = post.valueForString(key: "shared_count").toInt?.shorten()
        playerView.configure(url: post.valueForString(key: "media") )
    }
    
    
    func replay(){
        if !isPlaying {
            playerView.replay()
            play()
        }
    }
    
    func play() {
        if !isPlaying {
            playerView.play()
            musicLbl.holdScrolling = false
            isPlaying = true
        }
    }
    
    func pause(){
        if isPlaying {
            playerView.pause()
            musicLbl.holdScrolling = true
            isPlaying = false
        }
    }
    
    @objc func handlePause(){
        if isPlaying {
            // Pause video and show pause sign
            UIView.animate(withDuration: 0.075, delay: 0, options: .curveEaseIn, animations: { [weak self] in
                guard let self = self else { return }
                self.pauseImgView.alpha = 0.35
                self.pauseImgView.transform = CGAffineTransform.init(scaleX: 0.45, y: 0.45)
            }, completion: { [weak self] _ in
                self?.pause()
            })
        } else {
            // Start video and remove pause sign
            UIView.animate(withDuration: 0.075, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
                guard let self = self else { return }
                self.pauseImgView.alpha = 0
            }, completion: { [weak self] _ in
                self?.play()
                self?.pauseImgView.transform = .identity
            })
        }
    }
    
    func resetViewsForReuse(){
        likeBtn.tintColor = .white
        pauseImgView.alpha = 0
    }
    
    
    // MARK: - Actions
    // Like Video Actions
    @IBAction func like(_ sender: Any) {
        if !liked {
            likeVideo()
        } else {
            liked = false
            likeBtn.tintColor = .white
        }
        
    }
    
    @objc func likeVideo(){
        if !liked {
            liked = true
            likeBtn.tintColor = .red
        }
    }
    
    // Heart Animation with random angle
    @objc func handleLikeGesture(sender: UITapGestureRecognizer){
        let location = sender.location(in: self)
        let heartView = UIImageView(image: UIImage(named: "heartfilled"))
        heartView.tintColor = .red
        let width : CGFloat = 110
        heartView.contentMode = .scaleAspectFit
        heartView.frame = CGRect(x: location.x - width / 2, y: location.y - width / 2, width: width, height: width)
        heartView.transform = CGAffineTransform(rotationAngle: CGFloat.random(in: -CGFloat.pi * 0.2...CGFloat.pi * 0.2))
        self.contentView.addSubview(heartView)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 3, options: [.curveEaseInOut], animations: {
            heartView.transform = heartView.transform.scaledBy(x: 0.85, y: 0.85)
        }, completion: { _ in
            UIView.animate(withDuration: 0.4, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 3, options: [.curveEaseInOut], animations: {
                heartView.transform = heartView.transform.scaledBy(x: 2.3, y: 2.3)
                heartView.alpha = 0
            }, completion: { _ in
                heartView.removeFromSuperview()
            })
        })
        likeVideo()
    }
    
    @IBAction func comment(_ sender: Any) {
//        CommentPopUpView.init().show()
    }
    
    @IBAction func share(_ sender: Any) {
        
    }
    
    @objc func navigateToProfilePage(){
//        guard let post = post else { return }
        delegate?.navigateToProfilePage(userID: userID)
    }
    
    
    
    
}


// MARK: - UIViews
extension UIView {
    func makeRounded(color: UIColor, borderWidth: CGFloat) {
        self.layer.borderWidth = borderWidth
        self.layer.masksToBounds = false
        self.layer.borderColor = color.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
extension Int {
    /**
     * Shorten the number to *thousand* or *million*
     * - Returns: the shorten number and the suffix as *String*
     */
    func shorten() -> String{
        let number = Double(self)
        let thousand = number / 1000
        let million = number / 1000000
        if million >= 1.0 {
            return "\(round(million*10)/10)M"
        }
        else if thousand >= 1.0 {
            return "\(round(thousand*10)/10)K"
        }
        else {
            return "\(self)"
        }
    }
}
