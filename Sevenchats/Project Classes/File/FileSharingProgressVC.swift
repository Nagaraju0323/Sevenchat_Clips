//
//  FileSharingProgressVC.swift
//  Sevenchats
//
//  Created by mac-00020 on 09/07/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : FileSharingProgressVC                       *
 * Changes :                                             *
 *                                                       *
 ********************************************************/


import UIKit

class FileSharingProgressVC: UIViewController {
    
    //MARK: - IBOutlet/Object/Variable Declaration
    @IBOutlet weak var lblPreparingToExpo: UILabel!{
        didSet{
            lblPreparingToExpo.text = CPreparingToExpo
        }
    }
    @IBOutlet weak var lblDownloading: UILabel!{
        didSet{
            lblDownloading.text = CDownloading
        }
    }
    @IBOutlet weak var viewMainContainer : UIView!
    @IBOutlet weak var btnCancel: UIButton!{
        didSet{
            btnCancel.setTitle(CBtnCancel, for: .normal)
        }
    }

    var downloadTask : URLSessionDownloadTask?
    var completionBlock : ((_ success: Bool,_ fileLocation: URL?) -> Void)?
    
    //MARK: - View life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    class func  getInstance() -> FileSharingProgressVC? {
        if let popUp = CStoryboardFile.instantiateViewController(withIdentifier: "FileSharingProgressVC") as? FileSharingProgressVC{
            popUp.view.backgroundColor = UIColor.clear
            popUp.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
            return popUp
        }
        return nil
    }
    
    func presentController(controller:UIViewController) {
        self.view.backgroundColor = UIColor.clear
        controller.navigationController?.present(self, animated: true){
            UIView.animate(withDuration: 0.5, animations: {
                self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            })
        }
    }
    
    //MARK: - Memory management methods
    deinit {
        print("### deinit -> FileSharingProgressVC")
    }
}

//MARK: - SetupUI
extension FileSharingProgressVC {
    fileprivate func setupView() {
        
        self.viewMainContainer.layer.cornerRadius = 8
        self.viewMainContainer.shadow(color: UIColor.black.withAlphaComponent(0.4), shadowOffset: CGSize(width: 0, height: 5), shadowRadius: 8.0, shadowOpacity: 8.0)
    }
    
    func downloadfile(controller:UIViewController,fileUrl:URL,folderID:Int? = 0,completion: @escaping (_ success: Bool,_ fileLocation: URL?) -> Void){
        
        self.completionBlock = completion
        // then lets create your document folder url
        //var documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentsDirectoryURL = NSURL.fileURL(withPath: NSTemporaryDirectory(), isDirectory: true)

        // Make a directory if Folder ID
        //documentsDirectoryURL = documentsDirectoryURL.appendingPathComponent(String(describing: folderID!))
        do{
            try FileManager.default.createDirectory(at: documentsDirectoryURL, withIntermediateDirectories: true, attributes: nil)
        }
        catch let error as NSError
        {
            NSLog("Unable to create directory \(error.debugDescription)")
        }
        
        // lets create your destination file url
        let destinationUrl = documentsDirectoryURL.appendingPathComponent(fileUrl.lastPathComponent)
        print("File URL : \(destinationUrl.absoluteString)")
        // to check if it exists before downloading it
        if FileManager.default.fileExists(atPath: destinationUrl.path) {
            debugPrint("The file already exists at path")
            self.dismissController(status: true, url: destinationUrl)
            //completion(true, destinationUrl)
            // if the file doesn't exist
        } else {
            self.presentController(controller: controller)
            // you can use NSURLSession.sharedSession to download the data asynchronously
           downloadTask =  URLSession.shared.downloadTask(with: fileUrl, completionHandler: { (location, response, error) -> Void in
                guard let tempLocation = location, error == nil else {
                    //completion(false, nil)
                    self.dismissController(status: false, url: nil)
                    return
                }
                do {
                    // after downloading your file you need to move it to your destination url
                    try FileManager.default.moveItem(at: tempLocation, to: destinationUrl)
                    print("File moved to documents folder")
                    self.dismissController(status: true, url: destinationUrl)
                    //completion(true, destinationUrl)
                } catch let error as NSError {
                    print(error.localizedDescription)
                    self.dismissController(status: false, url: nil)
                    //completion(false, nil)
                }
            })
            downloadTask?.resume()
        }
    }
    
    func downloadfileForChat(controller:UIViewController,fileUrl:URL,localURL:URL,completion: @escaping (_ success: Bool,_ fileLocation: URL?) -> Void){
        
        self.completionBlock = completion
        
        // lets create your destination file url
        print("File URL : \(localURL.absoluteString)")
        // to check if it exists before downloading it
        if FileManager.default.fileExists(atPath: localURL.path) {
            debugPrint("The file already exists at path")
            self.dismissController(status: true, url: localURL)
            //completion(true, destinationUrl)
            // if the file doesn't exist
        } else {
            self.presentController(controller: controller)
            // you can use NSURLSession.sharedSession to download the data asynchronously
            downloadTask =  URLSession.shared.downloadTask(with: fileUrl, completionHandler: { (location, response, error) -> Void in
                guard let tempLocation = location, error == nil else {
                    //completion(false, nil)
                    self.dismissController(status: false, url: nil)
                    return
                }
                do {
                    // after downloading your file you need to move it to your destination url
                    try FileManager.default.moveItem(at: tempLocation, to: localURL)
                    print("File moved to documents folder")
                    self.dismissController(status: true, url: localURL)
                    //completion(true, destinationUrl)
                } catch let error as NSError {
                    print(error.localizedDescription)
                    self.dismissController(status: false, url: nil)
                    //completion(false, nil)
                }
            })
            downloadTask?.resume()
        }
    }
}

//MARK: - IBAction / Selector
extension FileSharingProgressVC {
    
    @IBAction func onCancel(_ sender: UIButton) {
        dismissController(status:false,url:nil)
    }
    
    func dismissController(status:Bool,url:URL?){
        self.downloadTask?.cancel()
        self.downloadTask = nil
        DispatchQueue.main.async {
            self.view.backgroundColor = UIColor.clear
            if (self.presentingViewController != nil){
                self.dismiss(animated: true) {
                    self.completionBlock?(status,url)
                }
            }else{
                self.completionBlock?(status,url)
            }
        }
    }
}
