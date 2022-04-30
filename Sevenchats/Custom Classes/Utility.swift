//
//  Utility.swift
//  Sevenchats
//
//  Created by mac-00020 on 19/06/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

import UIKit

class Utility: NSObject {


    class func isFileTypeAllowsToUpload(controller:UIViewController, extention:String) -> Bool{
        let arrValidExtention = ["jpeg","jpg","png","pdf","mp3","mov","mp4","webp"]
        if !arrValidExtention.contains(extention){
            controller.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CFileTypeNotAllowedtoUpload, btnOneTitle: CBtnOk , btnOneTapped: nil)
            return false
        }
        return true
    }
}
