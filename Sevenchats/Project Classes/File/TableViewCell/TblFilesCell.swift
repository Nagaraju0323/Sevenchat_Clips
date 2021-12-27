//
//  TblFilesCell.swift
//  ProgressViewDemo
//
//  Created by mac-00018 on 29/05/19.
//  Copyright © 2019 mac-00018. All rights reserved.
//

import UIKit

class TblFilesCell: UITableViewCell {
    
    @IBOutlet weak var viewImgBack: UIView!{
        didSet{
            DispatchQueue.main.async {
                self.viewImgBack.layer.cornerRadius = self.viewImgBack.frame.height / 2
            }
        }
    }
    
    @IBOutlet weak var viewContainer: MIGenericView! {
        didSet {
            GCDMainThread.async {
                self.viewContainer.layer.cornerRadius = ((CScreenWidth/375)*(self.viewContainer.frame.height))/10
            }
        }
    }
    
    @IBOutlet weak var viewBack: UIView!{
        didSet {
            GCDMainThread.async {
                self.viewBack.layer.cornerRadius = ((CScreenWidth/375)*(self.viewBack.frame.height))/10
            }
            
        }
    }
    
    @IBOutlet weak var lblFolderName: UILabel!
    @IBOutlet weak var lblSharedBy: UILabel!
    @IBOutlet weak var btnMore: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
