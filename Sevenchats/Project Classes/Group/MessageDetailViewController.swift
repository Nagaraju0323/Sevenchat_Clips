//
//  MessageDetailViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 01/09/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/********************************************************
* Author :  Chandrika.R                                *
* Model  : GroupChat Messages                          *
* options: Group Messages & Notifications              *
********************************************************/
import UIKit

class MessageDetailViewController: ParentViewController,MIAudioPlayerDelegate {
    
    @IBOutlet var cnNavigationHeight : NSLayoutConstraint!
    @IBOutlet var tblMessageDetail : UITableView!
    @IBOutlet var btnBack : UIButton!
    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var imgGroup : UIImageView! {
        didSet {
            GCDMainThread.async {
                self.imgGroup.roundView()
            }
        }
    }
    
    weak var audioSenderCell : AudioSenderTblCell!
    var messageInfo : TblMessages?
    var arrReadUser = [[String:Any]]()
    var strSelectedAudioMessageID : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialization()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateUIAccordingToLanguage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.stopAllAudio()
    }
    
    // MARK:- --------- Initialization
    func Initialization(){
        cnNavigationHeight.constant = IS_iPhone_X_Series ? 84 : 64
        
        tblMessageDetail.register(UINib(nibName: "MessageDetailUserCell", bundle: nil), forCellReuseIdentifier: "MessageDetailUserCell")
        tblMessageDetail.register(UINib(nibName: "MessageSenderTblCell", bundle: nil), forCellReuseIdentifier: "MessageSenderTblCell")
        tblMessageDetail.register(UINib(nibName: "ImageSenderTblCell", bundle: nil), forCellReuseIdentifier: "ImageSenderTblCell")
        tblMessageDetail.register(UINib(nibName: "AudioSenderTblCell", bundle: nil), forCellReuseIdentifier: "AudioSenderTblCell")
        tblMessageDetail.register(UINib(nibName: "LocationSenderTblCell", bundle: nil), forCellReuseIdentifier: "LocationSenderTblCell")
        
        tblMessageDetail.estimatedRowHeight = 100;
        tblMessageDetail.rowHeight = UITableView.automaticDimension;
        
        MIAudioPlayer.shared().miAudioPlayerDelegate = self
        
        GCDMainThread.async {
            self.tblMessageDetail.reloadData()
        }
        
        self.getGroupInformation()
        self.getMessageDetailFromSever()
    }
    
    func updateUIAccordingToLanguage(){
        
        if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
            // Reverse Flow...
            btnBack.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblTitle.textAlignment = .right
        }else{
            // Normal Flow...
            lblTitle.textAlignment = .left
            btnBack.transform = CGAffineTransform.identity
        }
        
    }
}

// MARK:- --------- Api Functions
extension MessageDetailViewController {
    fileprivate func getGroupInformation() {
        let arrGroups = TblChatGroupList.fetch(predicate: NSPredicate(format: "\(CGroupId) == \(messageInfo?.group_id ?? "0")"))
        if (arrGroups?.count)! > 0 {
            if let groupInfo = arrGroups?.firstObject as? TblChatGroupList {
                lblTitle.text = groupInfo.group_title
                self.imgGroup.loadImageFromUrl(groupInfo.group_image, false)
            }
        }
    }
    
    fileprivate func getMessageDetailFromSever() {
        
//        _ = APIRequest.shared().messageDetails(message_id: messageInfo?.message_id, completion: { (response, error) in
//            if response != nil && error == nil {
//                if let data = response![CJsonData] as? [String : Any] {
//                    if let arrRead = data[CRead_Users]  as? [[String : Any]] {
//                        self.arrReadUser.removeAll()
//                        self.arrReadUser = arrRead
//                        self.tblMessageDetail.reloadData()
//                    }
//                }
//            }
//        })
        
    }
}


// MARK:- --------- UITableView Datasources/Delegate
extension MessageDetailViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        return arrReadUser.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0{
            return UIView()
        }
        
        let headerVW:MessageDetailHeader = MessageDetailHeader.viewFromXib as! MessageDetailHeader
        headerVW.lblTotalMember.text = self.arrReadUser.count > 0 ? "\(CDeliveredTo) \(self.arrReadUser.count) \(CMemberOfGroup)" : CNotDelivered
        return headerVW
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            if let messageInfo = self.messageInfo {
                switch messageInfo.msg_type {
                case 1:
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "MessageSenderTblCell", for: indexPath) as? MessageSenderTblCell {
                        cell.configureMessageSenderCell(messageInfo,false)
                        return cell
                    }
                    
                    break
                case 2:
                    // IMAGE MESSAGE
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "ImageSenderTblCell", for: indexPath) as? ImageSenderTblCell {
                        cell.configureImageSenderCell(messageInfo,false)
                        return cell
                    }
                    break
                case 3:
                    // VIDEO MESSAGE
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "ImageSenderTblCell", for: indexPath) as? ImageSenderTblCell {
                        cell.configureImageSenderCell(messageInfo,false)
                        return cell
                    }
                    
                    break
                case 4:
                    // AUDIO MESSAGE
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "AudioSenderTblCell", for: indexPath) as? AudioSenderTblCell {
                        cell.configureAudioSenderCell(messageInfo,false)
                        cell.audioSenderCellDelegate = self
                        
                        if let selectedID = self.strSelectedAudioMessageID, selectedID == messageInfo.message_id {
                            cell.btnPlayPause.isSelected = MIAudioPlayer.shared().isPlaying()
                            cell.audioSlider.isUserInteractionEnabled = MIAudioPlayer.shared().isPlaying()
                        }else {
                            cell.btnPlayPause.isSelected = false
                            cell.audioSlider.value = 0
                            cell.audioSlider.isUserInteractionEnabled = false
                        }
                        return cell
                    }
                    break
                case 6:
                    // SHARE LOCATION
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "LocationSenderTblCell", for: indexPath) as? LocationSenderTblCell {
                        cell.configureImageSenderCell(messageInfo,false)
                        return cell
                    }
                    break
                default:
                    break
                }
            }
        }else{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "MessageDetailUserCell", for: indexPath) as? MessageDetailUserCell {
                let userInfo = arrReadUser[indexPath.row]
                cell.cellConfigureUserData(userInfo)
                return cell
            }
            
        }
        
        return tableView.tableViewDummyCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

// MARK:-  --------- Audio Related Functions
extension MessageDetailViewController: AudioSenderCellDelegate {
    
    // AudioSenderCellDelegate
    func cell(_ cell: AudioSenderTblCell, isPlay: Bool?) {
        
        if let cellSend = audioSenderCell {
            cellSend.btnPlayPause.isSelected = false
            cellSend.audioSlider.isUserInteractionEnabled = false
            MIAudioPlayer.shared().pauseTrack()
            
            if isPlay!{ // If playing new song that time set slider value = 0
                cellSend.audioSlider.value = 0.0
            }
            
        }
        
        if isPlay!{
            if let selectedID = self.strSelectedAudioMessageID, selectedID == cell.messageInformation.message_id {
                // If playing same song
                MIAudioPlayer.shared().playTrack()
            }else{
                MIAudioPlayer.shared().prepareTrack(cell.audioUrl)
            }
            
            self.audioSenderCell = cell
            self.strSelectedAudioMessageID = cell.messageInformation.message_id
            self.audioSenderCell.btnPlayPause.isSelected = true
            self.audioSenderCell.audioSlider.isUserInteractionEnabled = true
        }
    }
    
    func stopAllAudio() {
        
        // Stop Sender audio file
        if let cellSend = audioSenderCell {
            audioSenderCell = nil
            strSelectedAudioMessageID = nil
            MIAudioPlayer.shared().stopTrack()
            cellSend.btnPlayPause.isSelected = false
            cellSend.audioSlider.isUserInteractionEnabled = false
            cellSend.audioSlider.value = 0.0
        }
        
    }
}

// MARK:- -------- MIAudioPlayerDelgate
extension MessageDetailViewController {
    func MIAudioPlayerDidFinishPlaying(successfully flag: Bool) {
        print("MIAudioPlayerDidFinishPlaying ==== ")
        
        if flag {
            self.stopAllAudio()
        }
    }
    
    func MIAudioPlayerDidUpdateTime(_ currentTime: Double?, maximumTime: Double?) {
        
        var isCellVisible : Bool = false
        for visibleCells in tblMessageDetail.visibleCells {
            if let selectedID = self.strSelectedAudioMessageID {
                
                // Check Visiblity for Sender Cell
                if let cell = visibleCells as? AudioSenderTblCell {
                    if cell.messageInformation.message_id == selectedID {
                        isCellVisible = true
                        break
                    }
                }
            }
        }
        
        if isCellVisible {
            if self.audioSenderCell != nil {
                self.audioSenderCell.audioSlider.maximumValue = maximumTime?.toFloat ?? 0.0
                self.audioSenderCell.audioSlider.value = currentTime?.toFloat ?? 0.0
            }
        }
    }
}
