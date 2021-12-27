//
//  MDLAddMedia.swift
//  Sevenchats
//
//  Created by mac-00020 on 29/05/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

import Foundation
import UIKit
import TLPhotoPicker

//give device type (1=>image, 2=>video,3=>audio,4=>others).[ mandatory field ]
enum AssetTypes : Int {
    case Image = 1
    case Video
    case Audio
    case Pdf
    case Text
    case Other
    
    static func getType(ext:String) -> AssetTypes{
        
        let videoExtention = ["mp4", "mov","flv","3gp","ogg","hdv","avi","quicktime","wmv","vob","wav"]
        if videoExtention.contains(ext.lowercased()){
            return .Video
        }
        
        let audioExtension = ["mp3","aif","wpl","mpa"]
        if audioExtension.contains(ext.lowercased()){
            return .Audio
        }
        
        let imageExtension = ["jpeg","jpg","png","heic","heif"]
        if imageExtension.contains(ext.lowercased()){
            return .Image
        }
        let pdfExtension = ["pdf"]
        if pdfExtension.contains(ext.lowercased()){
            return .Pdf
        }
        let textExtension = ["doc","docx","rtf","txt","tex","wpd"]
        if textExtension.contains(ext.lowercased()){
            return .Text
        }
        
        return .Other
    }
    static func getTypeFromValue(value:String) -> AssetTypes{
        if value == "1" { return .Image }
        if value == "2" { return .Video }
        if value == "3" { return .Audio }
        if value == "4" { return .Pdf }
        if value == "5" { return .Text }
        return .Other
    }
}

enum UploadMediaStatus : Int{
    case Pendding
    case Succeed
    case Failed
    case FailedWithRetry
    case FileExist
}

class MDLAddMedia : NSObject{
    var asset : TLPHAsset?
    var createdAt : String = ""
    var fileName : String?
    var isDownloadedFromiCloud = false
    var mediaID : String?
    var image : UIImage?
    var url : String?
    var serverImgURL : String?
    var isFromGallery = true
    var assetType = AssetTypes.Other
    var uploadMediaStatus = UploadMediaStatus.Pendding
    var fileList : MDLFileList?
    
    init(mediaID : String? = nil,image:UIImage? = nil,url:String?=nil,serverImgURL:String?=nil) {
        self.mediaID = mediaID
        self.image = image
        self.url = url
        self.serverImgURL = serverImgURL
        //self.isVideo = isVideo
    }
}
//extension MDLAddMedia:Encodable{
//
//    enum CodingKeys : String, CodingKey {
//            case contents
//            case other
//        }
//
//        func encode(to encoder: Encoder) throws {
//            var container = encoder.container(keyedBy: CodingKeys.self)
//
//            try container.encode(contents, forKey: .contents)
//            try container.encode(other, forKey: .other)
//        }
//}
