//
//  CreateFileTableCell.swift
//  Sevenchats
//
//  Created by mac-00020 on 17/06/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//



import UIKit

class CreateFileTableCell: UITableViewCell {
    
    @IBOutlet weak var viewBack: UIView!{
        didSet {
            self.viewBack.layer.cornerRadius = ((CScreenWidth/375)*(self.viewBack.frame.height))/10
        }
    }
    @IBOutlet weak var viewMain: UIView! {
        didSet {
            self.viewMain.layer.cornerRadius = ((CScreenWidth/375)*(self.viewMain.frame.height))/10
        }
    }
    
    
    @IBOutlet weak var lblFileName: UILabel!
    @IBOutlet weak var lblFileDate: UILabel!
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var btnStatus: UIButton!
    @IBOutlet weak var vwShareFile: UIView!
    @IBOutlet weak var btnShareFile: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func updateStatus(status:UploadMediaStatus){
        switch status{
        case .Pendding:
            self.vwShareFile.isHidden = true
            self.btnStatus.setImage(UIImage(named: "ic_close_green"), for: .normal)
        case .Succeed:
            //self.btnStatus.setImage(UIImage(named: "ic_checkmark"), for: .normal)
            self.vwShareFile.isHidden = false
            self.btnStatus.setImage(UIImage(named: "ic_close_green"), for: .normal)
        case .Failed, .FailedWithRetry:
            self.vwShareFile.isHidden = true
            self.btnStatus.setImage(UIImage(named: "ic_group_info"), for: .normal)
        case .FileExist:
            self.vwShareFile.isHidden = true
            self.btnStatus.setImage(UIImage(named: "ic_group_info"), for: .normal)
        }
    }
}




class TblSharedFileDetailsCollCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource{
    
    var arrMediaFiles : [MDLAddMedia] = []
//    @IBOutlet weak var shareFolderLstcol: UICollectionView!
    
    
    @IBOutlet weak var clGallery : UICollectionView!{
        didSet{
            clGallery.register(UINib(nibName: "ClListviewCell", bundle: nil), forCellWithReuseIdentifier: "ClListviewCell")
            clGallery.isPagingEnabled = false
            clGallery.delegate = self
            clGallery.dataSource = self
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrMediaFiles.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{

        
                let width = collectionView.frame.size.width
                return CGSize(width: ((width-30)/3 - 7) , height: clGallery.bounds.height/2)
    
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = clGallery.dequeueReusableCell(withReuseIdentifier: "ClListviewCell", for: indexPath) as! ClListviewCell
        let media = arrMediaFiles[indexPath.row]
        if let file = media.fileList{
            cell.lblFileName.text = file.fileName
            cell.lblFileDate.text = file.createdDate
        }
         return cell
        
    }
    
    
}

