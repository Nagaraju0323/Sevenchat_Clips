//
//  MDLCloneMedia.swift
//  Sevenchats
//
//  Created by Ghanshyam on 06/05/20.
//  Copyright © 2020 mac-00020. All rights reserved.
//

/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : MDLCloneMedia                               *
 * Descripton  :                                         *
 *                                                       *
 ********************************************************/

import Foundation
import UIKit

class MDLCloneMedia : NSObject{
    
    var image : String!
    var imageUrl : String!
    var thumbName : String!
    var thumbUrl : String!
    var userId : String!
    var groupId : String!
    var groupUsersIds : [String] = []
    
    var localMediaUrl:String?
    
    init(fromJson json: [String:Any], userId:String = "0", groupId:String = "0", groupUsersIds : [String] = [], localMediaUrl:String?){
        
        self.image = json["image"] as? String ?? ""
        self.imageUrl = json["image_url"] as? String ?? ""
        
        self.thumbName = json["thumb_name"] as? String ?? ""
        self.thumbUrl = json["thumb_url"] as? String ?? ""
        
        self.userId = userId.trim
        self.groupId = groupId.trim
        self.groupUsersIds = groupUsersIds
        
        if !localMediaUrl.isEmptyOrNil() {
            
            let mediaURL = CTopMostViewController.applicationDocumentsDirectory()! + "/" + localMediaUrl!
            
            if FileManager.default.fileExists(atPath: mediaURL) {
                
                //let img = UIImage(contentsOfFile: imgPath)
                //let imageData =  img?.jpegData(compressionQuality: 1.0)
                
                let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                let documentsDirectory = paths.count > 0 ? paths[0] : nil;
                var imgName : String = "/" + self.image
                if self.image.isEmpty {
                    imgName = "/\(CApplicationName ?? "Sevenchats")_\(Int(Date().currentTimeStamp * 1000))\(Int.random(in: 1..<10000)).jpg"
                }
                let imgPath = documentsDirectory?.appending(imgName)
                if let path = imgPath {
                    let toURL = URL(fileURLWithPath: path)
                    do {
                        try FileManager.default.copyItem(at: URL(fileURLWithPath: mediaURL), to: toURL)
                        self.localMediaUrl  = imgName
                    }
                    catch let error as NSError {
                        print("Ooops! Something went wrong: \(error)")
                    }
                    //try! imageData?.write(to: imgURL, options: .atomicWrite)
                }
            }
        }
    }
}
