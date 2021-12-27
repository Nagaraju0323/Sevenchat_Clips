//
//  MIVideoCameraGallery.swift
//  Strategy_Creator
//
//  Created by mac-0005 on 06/07/18.
//  Copyright © 2018 Mac-00016. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import CoreMedia
import MediaToolbox
import Photos

typealias imagePickerControllerVideoCompletionHandler = ((_ videoURL:URL? , _ info:[UIImagePickerController.InfoKey : Any]?) -> ())
typealias exportVideoCompletion = ((_ videoURL:URL?, _ success : Bool, _ videoName : String?) -> ())

class MIVideoCameraGallery: NSObject, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var imgPickerCompletion : imagePickerControllerVideoCompletionHandler!;
    var exportVideoCompletion : exportVideoCompletion!;
    
    var videoURL: URL?
    let imagePickerController = UIImagePickerController()
    
    private override init() {
        super.init()
    }
    
    private static var gallery: MIVideoCameraGallery = {
        let gallery = MIVideoCameraGallery()
        return gallery
    }()
    
    static func shared() ->MIVideoCameraGallery {
        return gallery
    }
    
    func presentVideoGallery(_ viewController: UIViewController, _ imagePickerControllerVideoCompletionHandler:@escaping imagePickerControllerVideoCompletionHandler)
    {
        imgPickerCompletion = imagePickerControllerVideoCompletionHandler
        imagePickerController.delegate = self
//        imagePickerController.videoMaximumDuration = 60
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.mediaTypes = [ "public.movie"]
        imagePickerController.videoQuality = .typeHigh
        viewController.present(imagePickerController, animated: true, completion: nil)
    }
    
    func presentVideoCamera(_ viewController: UIViewController, duration: Double?,  _ imagePickerControllerVideoCompletionHandler:@escaping imagePickerControllerVideoCompletionHandler)
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            imgPickerCompletion = imagePickerControllerVideoCompletionHandler
            imagePickerController.delegate = self
            if duration != nil {
                imagePickerController.videoMaximumDuration = duration!
            }
            imagePickerController.sourceType = .camera
            imagePickerController.mediaTypes = [ "public.movie"]
            imagePickerController.videoQuality = .typeHigh
            viewController.present(imagePickerController, animated: true, completion: nil)
        } else {
            viewController.presentAlertViewWithOneButton(alertTitle: nil, alertMessage: CDeviceUnsupportedCamera, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }
    }
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        picker.dismiss(animated: true) {
            if #available(iOS 11.0, *) {
                if let asset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset {
                    PHImageManager.default().requestAVAsset(forVideo: asset, options: nil, resultHandler: { (avAsset, audioMix, info) in
                        if let urlasset = avAsset as? AVURLAsset {
                            self.videoURL = urlasset.url
                            self.completionBlock(asset: urlasset, info: info)
                        }
                    })
                }else{
                    self.videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL
                    
                    if self.videoURL != nil {
                        let asset = AVURLAsset(url: info[UIImagePickerController.InfoKey.mediaURL] as! URL, options: nil)
                        self.completionBlock(asset: asset, info: info)
                    }
                }
            } else {
                // Fallback on earlier versions
                self.videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL
                
                if self.videoURL != nil {
                    let asset = AVURLAsset(url: info[UIImagePickerController.InfoKey.mediaURL] as! URL, options: nil)
                    self.completionBlock(asset: asset, info: info)
                }
            }
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true) {
            if self.imgPickerCompletion != nil {
                self.imgPickerCompletion(nil, nil)
            }
        }
    }
    
        
    // MARK:- Video Crop Functionality
    private func completionBlock(asset: AVURLAsset?, info: Any?) {
        if self.videoURL != nil {
            
            let fileSize = asset?.fileSize
            
            // Video should be less then 100 mb
            if fileSize! > 100000000 {
                CTopMostViewController.presentAlertViewWithOneButton(alertTitle: nil, alertMessage: CVideoSizeLimit, btnOneTitle: CBtnOk, btnOneTapped: nil)
            }else {
                if self.imgPickerCompletion != nil {
                    self.imgPickerCompletion(self.videoURL, nil)
                }
            }
        }else {
            CTopMostViewController.presentAlertViewWithOneButton(alertTitle: nil, alertMessage: CVideoNotSupported, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }
    }
    
    // MARK:- Video Crop Functionality
    
    fileprivate func applicationDocumentsDirectory() -> String? {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)
        let basePath = paths.count > 0 ? paths[0] : nil;
        return basePath;
    }
    
    fileprivate func removeFileAtPath(_ outputPath : String?) {
        let fileManager = FileManager()
        
        if (fileManager.fileExists(atPath: outputPath!)) {
            if (fileManager.isDeletableFile(atPath: outputPath!)) {
                do {
                    try fileManager.removeItem(atPath: outputPath!)
                }
                catch let error as NSError {
                    print("Ooops! Something went wrong: \(error)")
                }
                
            }
        }
    }
    
    func orientationForVideoTrack(_ videoTrack : AVAssetTrack) -> UIInterfaceOrientation?
    {
        let size = videoTrack.naturalSize
        let txf = videoTrack.preferredTransform
        
        if (size.width == txf.tx && size.height == txf.ty)
        {
            return .landscapeRight
        }
        else if (txf.tx == 0 && txf.ty == 0)
        {
            return .landscapeLeft
        }
        else if (txf.tx == 0 && txf.ty == size.width)
        {
            return .portraitUpsideDown
        }
        else
        {
            return .portrait
        }
    }
    
    func exportVideoWithFinalOutput(_ recordedURL : URL?, drawingImage : UIImage?, _ completion:@escaping exportVideoCompletion) {

        exportVideoCompletion = completion;
        
        let videoAsset = AVAsset(url: recordedURL!)
        let mutableComposition = AVMutableComposition()
        
        let firstTrack = mutableComposition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid)
        do {
            try? firstTrack?.insertTimeRange(CMTimeRange(start: CMTime.zero, duration: videoAsset.duration), of: videoAsset.tracks(withMediaType: AVMediaType.video)[0], at: CMTime.zero)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
        
        
        // 4- audio track
        if videoAsset.tracks(withMediaType: .audio).count > 0 {
            let compositionAudioTrack = mutableComposition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
            
            do {
               try? compositionAudioTrack?.insertTimeRange(CMTimeRange(start: CMTime.zero, duration: videoAsset.duration), of: videoAsset.tracks(withMediaType: .audio).first!, at: CMTime.zero)
            } catch {
                print("Failed to insert track")
            }
        }
        
        //.....Final video output path
        let fileManager = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let testURL = fileManager[0]
        let videoName = "\(CApplicationName ?? "")_\(Int(Date().currentTimeStamp)).mp4"
        let finalVideoOutputPath = testURL.appendingPathComponent(videoName)

        
        
        //.....Create an AVAssetTrack with our final asset
        let videoAssetTrack = mutableComposition.tracks(withMediaType: .video)[0]
        var naturalSize:CGSize = videoAssetTrack.naturalSize
        
        //......Orientation of video.
        //        switch ([self orientationForVideoTrack:videoAssetTrack])
        
        if self.orientationForVideoTrack(videoAssetTrack) == UIInterfaceOrientation.portrait || self.orientationForVideoTrack(videoAssetTrack) == UIInterfaceOrientation.portraitUpsideDown {
            naturalSize = CGSize(width: naturalSize.height, height: naturalSize.width)
        }
        
        
        //......Crop Rect Video
        let cropOffX:CGFloat = 0.0
        let cropOffY:CGFloat = 0.0
        let cropWidth:CGFloat = naturalSize.width
        let cropHeight:CGFloat = naturalSize.height
        
        //.....Create a video composition and set some settings
        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = CGSize(width: cropWidth, height: cropHeight)
        videoComposition.frameDuration = CMTimeMake(value: 1, timescale: 30);
        
        
        //.....Create a video instruction
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRange(start: CMTime.zero, duration: videoAsset.duration)
        
        let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoAssetTrack)
        
        let videoOrientation = self.orientationForVideoTrack(videoAssetTrack)
        
        var t1 = CGAffineTransform.identity
        var t2 = CGAffineTransform.identity
        
        switch videoOrientation {
        case .portrait?:
            t1 = CGAffineTransform(translationX: videoAssetTrack.naturalSize.height - cropOffX, y:  0 - cropOffY)
            t2 = CGAffineTransform(rotationAngle: .pi/2)
            break
        case .portraitUpsideDown?:
            t1 = CGAffineTransform(translationX: videoAssetTrack.naturalSize.height - cropOffX, y:  0 - cropOffY)
            t2 = CGAffineTransform(rotationAngle: .pi/2)
            break
        case .landscapeLeft?:
            t1 = CGAffineTransform(translationX: 0 - cropOffX, y:  0 - cropOffY)
            t2 = CGAffineTransform(rotationAngle: 0)
            break
        case .landscapeRight?:
            t1 = CGAffineTransform(translationX:videoAssetTrack.naturalSize.width - cropOffX, y:  videoAssetTrack.naturalSize.height - cropOffY)
            t2 = CGAffineTransform(rotationAngle: .pi)
            
            break
        default:
            break
        }
        
        
        let finalTransform = t2
        layerInstruction.setTransform(finalTransform, at: CMTime.zero)
        
        // Add the transformer layer instructions, then add to video composition
        instruction.layerInstructions = [layerInstruction]
        videoComposition.instructions = [instruction]

        if drawingImage != nil {
            self.applyVideoEffectsToComposition(composition: videoComposition, size: naturalSize, drawingImage: drawingImage)
        }
        
        
        // Now export final video on finalVideoOutputPath
        let exporter = AVAssetExportSession(asset: mutableComposition, presetName: AVAssetExportPreset640x480)// AVAssetExportPresetHighestQuality
        exporter?.outputURL = finalVideoOutputPath;
        exporter?.outputFileType = AVFileType.mp4
        exporter?.videoComposition = videoComposition
        exporter?.shouldOptimizeForNetworkUse = true;
        
        
        MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "Exporting video...")
        exporter?.exportAsynchronously(completionHandler: {
            
            DispatchQueue.main.async {
                switch exporter?.status
                {
                case .failed?:
                    MILoader.shared.hideLoader()
                    self.exportVideoCompletion(finalVideoOutputPath, false, videoName)
                    print("Exported Failed ====== ")
                    break
                    
                case .cancelled?:
                    MILoader.shared.hideLoader()
                    self.exportVideoCompletion(finalVideoOutputPath, false, videoName)
                    print("Exported cancelled ====== ")
                    break
                    
                case .completed?:
                    MILoader.shared.hideLoader()
                    self.exportVideoCompletion(finalVideoOutputPath, true, videoName)
                    print("Exported completed ====== ")
                    break
                    
                default:
                    break
                }
                
                //                MIStrategyLoader.shared().hideLoader()
            }
        })
        
        
    }
    
    //    - (void)applyVideoEffectsToComposition:(AVMutableVideoComposition *)composition size:(CGSize)size
    func applyVideoEffectsToComposition(composition :AVMutableVideoComposition,  size:CGSize, drawingImage:UIImage?)
    {
        let overlayLayer = CALayer()
        var overlayImage : UIImage?
        
        let imgTemp = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
        imgTemp.contentMode = .scaleAspectFit;
        imgTemp.image = drawingImage;
        
        UIGraphicsBeginImageContextWithOptions(imgTemp.bounds.size, false, UIScreen.main.scale);
        imgTemp.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        overlayImage = img;
        overlayLayer.contents = overlayImage?.cgImage
        overlayLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        overlayLayer.masksToBounds = true
        
        
        // 2 - set up the parent layer
        let parentLayer = CALayer()
        let videoLayer = CALayer()
        
        parentLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        videoLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        parentLayer.addSublayer(videoLayer)
        parentLayer.addSublayer(overlayLayer)
        
        // 3 - apply magic
        composition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayers: [videoLayer], in: parentLayer)
    }
    
}

extension AVURLAsset {
    var fileSize: Int? {
        let keys: Set<URLResourceKey> = [.totalFileSizeKey, .fileSizeKey]
        let resourceValues = try? url.resourceValues(forKeys: keys)
        
        return resourceValues?.fileSize ?? resourceValues?.totalFileSize
    }
}
