//
//  SongListViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 13/02/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : SongListViewController                      *
 * Changes :                                             *
 *                                                       *
 ********************************************************/

import UIKit
import MediaPlayer

class SongListViewController: ParentViewController {
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var cnNavigationHeight: NSLayoutConstraint! {
        didSet {
            cnNavigationHeight.constant = IS_iPhone_X_Series ? 84.0 : 64.0
        }
    }
    
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var tblSongList: UITableView! {
        didSet {
            tblSongList.tableFooterView = UIView()
        }
    }
    var selectedIndexPath: IndexPath!
    
    var arrSongList = [MPMediaItem]()
    var selectedFileName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialization()
    }
}

// MARK:- --------- Configuration
extension SongListViewController {

    fileprivate func initialization() {
        btnDone.setTitle(CBtnDone, for: .normal)
        btnCancel.setTitle(CBtnCancel, for: .normal)
        
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
        
        if MPMediaLibrary.authorizationStatus() == .authorized {
            self.fetchSongFromLocal()
        }else {
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            
            //  Ask for MPMediaLibrary permission..
            MPMediaLibrary.requestAuthorization { (status) in
                GCDMainThread.async {
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                }
                
                switch status {
                case .notDetermined:
                    break
                case .denied:
                    break
                case .restricted:
                    break
                case .authorized:
                    GCDMainThread.async {
                        print("this is calling")
                        self.fetchSongFromLocal()
                    }
                @unknown default:
                    print("screenLocal")
                }
            }
        }
    }
    
    fileprivate func fetchSongFromLocal() {
       let query = MPMediaQuery()
        
        print("query\(query)")
        arrSongList = query.items!
        print("arrSongList\(arrSongList)")
        tblSongList.reloadData()
    }
    
}
// MARK:- --------- UITableView Datasources/Delegate
extension SongListViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSongList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SongListTblCell", for: indexPath) as? SongListTblCell {
            let mediaItem = arrSongList[indexPath.row]
            print("mediaItem\(mediaItem)")
            cell.lblSongName.text = mediaItem.albumTitle?.isBlank ?? true ? mediaItem.title : mediaItem.albumTitle
            cell.lblArtistName.text = mediaItem.artist?.isBlank ?? true ? mediaItem.composer : mediaItem.artist
            if let artWork = mediaItem.value(forKey: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork {
                cell.imgSong.image = artWork.image(at: CGSize(width: 50.0, height: 50.0))
            }
            
            cell.btnSelected.isSelected = selectedIndexPath == indexPath
            return cell
        }
        
        return tableView.tableViewDummyCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == selectedIndexPath {
            selectedIndexPath = nil
            btnDone.isHidden = true
        }else {
            selectedIndexPath = indexPath
            btnDone.isHidden = false
        }
        tblSongList.reloadData()
    }
    
}
// MARK:- Audio Compression
// MARK:-
extension SongListViewController {
    
    func exportAudioFile(_ item: MPMediaItem?, _ completion:@escaping ((_ audioURL:URL?, _ success : Bool, _ audioName : String?, _ fileName: String) -> ())) {
        
        if let mediaItem = item {
            
            //.....Final Audio output path
            let fileManager = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let testURL = fileManager[0]
            let audioName = "\(CApplicationName ?? "")_\(Int(Date().currentTimeStamp)).m4a"
            let fileName = mediaItem.albumTitle ?? ""
            let finalAudioOutputPath = testURL.appendingPathComponent(audioName)
            
            //guard let url = mediaItem.assetURL else {return}
            guard let url = mediaItem.value(forProperty: MPMediaItemPropertyAssetURL) as? URL else{
                self.presentAlertViewWithOneButton(alertTitle: nil, alertMessage: CURLNotFound, btnOneTitle: CBtnOk, btnOneTapped: nil)
                return
            }
            let songAsset = AVURLAsset(url: url, options: nil)
            
            let exporter = AVAssetExportSession(asset: songAsset, presetName: AVAssetExportPresetAppleM4A)
            exporter?.outputFileType = AVFileType.m4a
            exporter?.outputURL = finalAudioOutputPath;
            
            
            MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "Exporting Audio...")
            exporter?.exportAsynchronously(completionHandler: {
                
                DispatchQueue.main.async {
                    switch exporter?.status
                    {
                    case .failed?:
                        MILoader.shared.hideLoader()
                        completion(finalAudioOutputPath, false, audioName, fileName)
                        print("Exported Failed ====== ")
                        break
                        
                    case .cancelled?:
                        MILoader.shared.hideLoader()
                        completion(finalAudioOutputPath, false, audioName, fileName)
                        print("Exported cancelled ====== ")
                        break
                        
                    case .completed?:
                        MILoader.shared.hideLoader()
                        completion(finalAudioOutputPath, true, finalAudioOutputPath.toString, fileName)
                        print("filename\(fileName)")
                        print("Exported completed ====== ")
                        break
                        
                    default:
                        break
                    }
                }
            })
            
        }
    }
}
// MARK:- Action Event
// MARK:-
extension SongListViewController {
    
    @IBAction func btnCancelCLK(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnDoneCLK(_ sender: UIButton) {
        if selectedIndexPath == nil {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: "Please select a song.", btnOneTitle: CBtnOk, btnOneTapped: nil)
        }else {
            let mediaItem = self.arrSongList[selectedIndexPath.row]
            self.exportAudioFile(mediaItem) { (audioURL, success, audioName, fileName) in
                if success {
                    
                    print("print\(fileName)")
                    self.selectedFileName = fileName
                    
                    
                    
                    self.dismiss(animated: true, completion: {
                        GCDMainThread.asyncAfter(deadline: .now() + 0, execute: {
                            if let block = self.block {
                                block(audioName, "select")
                            }
                        })
                    })
                }
            }
        }
    }
}

// MARK:- SongListTblCell
// MARK:-
class SongListTblCell: UITableViewCell {
    
    @IBOutlet weak var lblSongName: UILabel!
    @IBOutlet weak var lblArtistName: UILabel!
    @IBOutlet weak var btnSelected: UIButton!
    @IBOutlet weak var imgSong: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        GCDMainThread.async {
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
