//
//  MinioImgsave.swift
//  Sevenchats
//
//  Created by CHINNA on 8/13/21.
//  Copyright © 2021 mac-00020. All rights reserved.
//
//
import Foundation
import UIKit
import AWSS3
import AWSCore

class MInioimageupload: NSObject{

    var uploadCompletionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?

    var callback : ((String) -> Void)?
    var callbackFolderCreate : ((String) -> Void)?

    private static var minioImgupload:MInioimageupload = {
        let minioImgupload = MInioimageupload()
        return minioImgupload
    }()
    static func shared() ->MInioimageupload {
        return minioImgupload
    }
    override init() {
        super.init()
    }

    func generateRandomStringWithLength(length: Int) -> String {
        let randomString: NSMutableString = NSMutableString(capacity: length)
        let letters: NSMutableString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var i: Int = 0

        while i < length {
            let randomIndex: Int = Int(arc4random_uniform(UInt32(letters.length)))
            randomString.append("\(Character( UnicodeScalar( letters.character(at: randomIndex))!))")
            i += 1
        }
        return String(randomString)
    }

//    "https://dev1.sevenchats.com:4443"
    // MARK:- -------- ImageUpload
    //MARK:- ---------TODO
    //MARK:- ---------TODO
    func uploadMinioimages(mobileNo:String,ImageSTt:UIImage,isFrom:String,uploadFrom:String){

        let credentialsProvider = AWSStaticCredentialsProvider(accessKey: CAccesskey, secretKey: CSecretKey)
        let configuration = AWSServiceConfiguration(region: .USEast1, endpoint: AWSEndpoint(region: .USEast1, service: .S3, url: URL(string:BASEURLMINIO)),credentialsProvider: credentialsProvider)

        AWSServiceManager.default().defaultServiceConfiguration = configuration
        self.folderExisted(mobileNo:mobileNo,ImageUrl:ImageSTt,isFrom:isFrom,uploadFrom:uploadFrom)
    }
    
    //MARK:- -------- Folder Existed Or not
    //MARK :- TODO
    //MARK :- TODO
    
    func folderExisted(mobileNo:String,ImageUrl:UIImage,isFrom:String,uploadFrom:String){
       
        let credentialsProvider = AWSStaticCredentialsProvider(accessKey: CAccesskey, secretKey: CSecretKey)
        let configuration = AWSServiceConfiguration(region: .USEast1, endpoint: AWSEndpoint(region: .USEast1, service: .S3, url: URL(string:BASEURLMINIO)),credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        if isFrom == "videos" || isFrom == "audio"{
            let vidoeURL = URL(string: uploadFrom)
            if let url = vidoeURL {
              do {
                let timeStampCngs = String(Int(Date().currentTimeInMilliSecond)) + url.extentionOfPath
                let s3 = AWSS3.default()
                let folderRequest = AWSS3HeadObjectRequest()
                folderRequest?.key = mobileNo + "/"  + timeStampCngs
                folderRequest?.bucket = "sevenchats"
                s3.headObject(folderRequest!).continueWith { (task) -> AnyObject? in
                    if let error = task.error {
                        print("Error to find file: \(error)")
                        self.createFolderWithImageVidoes(vidoeURLStr:uploadFrom,mobileNo:mobileNo)
                    } else {
                        print("fileExist")
                        self.createFolderWithImageVidoes(vidoeURLStr:uploadFrom,mobileNo:mobileNo)
                    }
                    return nil
                }
              } catch let error {
                print(error)
              }
            }
            
        }else {
        
        let datafomat: Data = ImageUrl.pngData()!
        let timeStampCng = String(Int(Date().currentTimeInMilliSecond)) + "." + datafomat.format
        let remoteName = timeStampCng
        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(remoteName)
        let data = ImageUrl.jpegData(compressionQuality: 0.1)
        do {
            try data?.write(to: fileURL)
        }
        catch {}
        
        let s3 = AWSS3.default()
        let folderRequest = AWSS3HeadObjectRequest()
        folderRequest?.key = mobileNo + "/"  + timeStampCng
        folderRequest?.bucket = "sevenchats"
       
        s3.headObject(folderRequest!).continueWith { (task) -> AnyObject? in
            if let error = task.error {
//                print("Error to find file: \(error)")
                //self.createFolderWithImage(imgName: ImageUrl,mobileNo:mobileNo)
                self.createFolderWithImage(imgName:ImageUrl,mobileNo:mobileNo)
                
            } else {
                print("fileExist")
                
                self.createFolderWithImage(imgName:ImageUrl,mobileNo:mobileNo)
            }
            return nil
        }
      }
    }
 
    //MARK:- -------- Folder Created
    //MARK :- TODO
    //MARK :- TODO
    
    func createFolderWithImage(imgName: UIImage,mobileNo:String) {
        var imgMinioUrl  = ""
        
        let credentialsProvider = AWSStaticCredentialsProvider(accessKey: CAccesskey, secretKey: CSecretKey)
        let configuration = AWSServiceConfiguration(region: .USEast1, endpoint: AWSEndpoint(region: .USEast1, service: .S3, url: URL(string:BASEURLMINIO)),credentialsProvider: credentialsProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        let datafomat: Data = imgName.pngData()!
        let timeStampCng = "IOS" + String(Int(Date().currentTimeInMilliSecond)) + "." + datafomat.format
        let remoteName = timeStampCng
        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(remoteName)
        let data = imgName.jpegData(compressionQuality: 0.1)
        do {
            try data?.write(to: fileURL)
        }
        catch {}
    
        AWSServiceManager.default().defaultServiceConfiguration = configuration
            let folderRequest: AWSS3PutObjectRequest = AWSS3PutObjectRequest()
            folderRequest.key = mobileNo + "/"  + timeStampCng
            folderRequest.bucket = "sevenchats"
            folderRequest.body = fileURL
            AWSS3.default().putObject(folderRequest).continueWith(block: { (task) -> Any? in
                if task.error != nil {
                    assertionFailure("* * * error: \(task.error?.localizedDescription ?? "")")
                } else {

                    let url = AWSS3.default().configuration.endpoint.url
                    let publicURL = url?.appendingPathComponent(folderRequest.bucket!).appendingPathComponent(folderRequest.key!)
                    imgMinioUrl = "\(String(describing: publicURL?.absoluteString ?? ""))"
//                    self.downloadMinioimage(ImgnameURL:imgMinioUrl)
                    self.callback?(imgMinioUrl)
                }
                return nil
            })
        }
 
    
    //MARK:- -------- upload Vidoes
    //MARK :- TODO
    //MARK :- TODO

   
    func createFolderWithImageVidoes(vidoeURLStr:String,mobileNo:String) {
        var imgMinioUrl  = ""
        let credentialsProvider = AWSStaticCredentialsProvider(accessKey: CAccesskey, secretKey: CSecretKey)
        let configuration = AWSServiceConfiguration(region: .USEast1, endpoint: AWSEndpoint(region: .USEast1, service: .S3, url: URL(string:BASEURLMINIO)),credentialsProvider: credentialsProvider)
         AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        let vidoeURL = URL(string: vidoeURLStr)
        
        if let url = vidoeURL {
          do {
            
            let timeStampCngs = "IOS" + String(Int(Date().currentTimeInMilliSecond)) + url.extentionOfPath
            AWSServiceManager.default().defaultServiceConfiguration = configuration
            let folderRequest: AWSS3PutObjectRequest = AWSS3PutObjectRequest()
            folderRequest.key = mobileNo + "/"  + timeStampCngs
            folderRequest.bucket = "sevenchats"
            folderRequest.body = vidoeURL
            AWSS3.default().putObject(folderRequest).continueWith(block: { (task) -> Any? in
                if task.error != nil {
                    assertionFailure("* * * error: \(task.error?.localizedDescription ?? "")")
                } else {
                    
                    let url = AWSS3.default().configuration.endpoint.url
                    let publicURL = url?.appendingPathComponent(folderRequest.bucket!).appendingPathComponent(folderRequest.key!)
                    imgMinioUrl = "\(String(describing: publicURL?.absoluteString ?? ""))"
                    //                    self.downloadMinioimage(ImgnameURL:imgMinioUrl)
                    self.callback?(imgMinioUrl)
                }
                return nil
            })
          } catch let error {
            print(error)
          }
        }
        }
    

    //MARK:- -------- upload Vidoes
    //MARK :- TODO
    //MARK :- TODO
    
    func uploadMinioVideo(ImgnameStr:URL) {

        let credentialsProvider = AWSStaticCredentialsProvider(accessKey: CAccesskey, secretKey: CSecretKey)
        let configuration = AWSServiceConfiguration(region: .USEast1, endpoint: AWSEndpoint(region: .USEast1, service: .S3, url: URL(string:BASEURLMINIO)),credentialsProvider: credentialsProvider)

        AWSServiceManager.default().defaultServiceConfiguration = configuration

        let videoData:Data?
        do {
           videoData = try Data(contentsOf: ImgnameStr)
        }catch let error {
            print(error)
        }
        let timeStampCng = "IOS" + String(Int(Date().currentTimeInMilliSecond)) + "." + "mp4"
        let S3BucketName = "sevenchats"
        let remoteName = timeStampCng
        let uploadRequest = AWSS3TransferManagerUploadRequest()!
        uploadRequest.body = ImgnameStr
        uploadRequest.key = remoteName
        uploadRequest.bucket = S3BucketName
        uploadRequest.contentType = "movie/mov"
        uploadRequest.acl = .publicRead

        let transferManager = AWSS3TransferManager.default()
        transferManager.upload(uploadRequest)
        transferManager.upload(uploadRequest).continueWith { (task: AWSTask<AnyObject>) -> Any? in
            DispatchQueue.main.async {
                
            }
            if let error = task.error {
                print("Upload failed with error: (\(error.localizedDescription))")
            }

            if task.result != nil {
                let url = AWSS3.default().configuration.endpoint.url
                let publicURL = url?.appendingPathComponent(uploadRequest.bucket!).appendingPathComponent(uploadRequest.key!)
                print("Uploaded to:\(String(describing: publicURL!))")
            }
            return nil
        }
    }
 
    //MARK:- -------- upload Vidoes
    //MARK :- TODO
    //MARK :- TODO
    
    func downloadMinioimage(ImgnameURL:String) {
        let credentialsProvider = AWSStaticCredentialsProvider(accessKey: CAccesskey, secretKey: CSecretKey)
        let configuration = AWSServiceConfiguration(region: .USEast1, endpoint: AWSEndpoint(region: .USEast1, service: .S3, url: URL(string:BASEURLMINIO)),credentialsProvider: credentialsProvider)

        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        let S3BucketName = "iostesting"
        let remoteName = "IOS1628933746.png"
        let transferManager = AWSS3TransferManager.default()
        let downloadingFileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("temp.jpg")
             if let downloadRequest = AWSS3TransferManagerDownloadRequest(){
                 downloadRequest.bucket = S3BucketName
                 downloadRequest.key = remoteName
                 downloadRequest.downloadingFileURL = downloadingFileURL
                 transferManager.download(downloadRequest).continueWith(executor: AWSExecutor.default(), block: { (task: AWSTask<AnyObject>) -> Any? in
                     if( task.error != nil){
                         print(task.error!.localizedDescription)
                         return nil
                     }
                     print(task.result!)
                     if let data = NSData(contentsOf: downloadingFileURL){
                         DispatchQueue.main.async(execute: { () -> Void in
//                             self.image.image = UIImage(data: data as Data)
                         })
                     }
                 return nil
                 })
         }
    }
    
}

extension Data {

    var format: String {
        let array = [UInt8](self)
        let ext: String
        switch (array[0]) {
        case 0xFF:
            ext = "jpg"
        case 0x89:
            ext = "png"
        case 0x47:
            ext = "gif"
        case 0x49, 0x4D :
            ext = "tiff"
        default:
            ext = "unknown"
        }
        return ext
    }
}

