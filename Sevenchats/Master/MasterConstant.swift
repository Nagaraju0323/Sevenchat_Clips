//
//  MasterConstant.swift
//  Swifty_Master
//
//  Created by Mac-0002 on 05/09/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import Foundation
import UIKit

let CMainScreen = UIScreen.main
let CBounds = CMainScreen.bounds

let CScreenSize = CBounds.size
let CScreenWidth = CScreenSize.width
let CScreenHeight = CScreenSize.height

let CScreenOrigin = CBounds.origin
let CScreenX = CScreenOrigin.x
let CScreenY = CScreenOrigin.y

let CScreenCenter = CGPoint(x: CScreenWidth/2.0, y: CScreenHeight/2.0)
let CScreenCenterX = CScreenCenter.x
let CScreenCenterY = CScreenCenter.y

let CSharedApplication = UIApplication.shared

let appDelegate = CSharedApplication.delegate as! AppDelegate

var CTopMostViewController:UIViewController
{
    get { return CSharedApplication.topMostViewController }
    set{}
}

let CUserDefaults = UserDefaults.standard

let CCurrentDevice = UIDevice.current
let CUserInterfaceIdiom = CCurrentDevice.userInterfaceIdiom
let IS_iPhone = CUserInterfaceIdiom == .phone
let IS_iPad = CUserInterfaceIdiom == .pad
let IS_TV = CUserInterfaceIdiom == .tv

let COrientation = CCurrentDevice.orientation
let IS_Portrait = COrientation.isPortrait
let IS_Landscape = COrientation.isLandscape

let CSystemVersion = CCurrentDevice.systemVersion
let IS_iOS7 = CSystemVersion.toDouble?.toInt == 7
let IS_iOS8 = CSystemVersion.toDouble?.toInt == 8
let IS_iOS9 = CSystemVersion.toDouble?.toInt == 9
let IS_iOS10 = CSystemVersion.toDouble?.toInt == 10
let IS_iOS11 = CSystemVersion.toDouble?.toInt == 11

let IS_SIMULATOR    = (TARGET_IPHONE_SIMULATOR == 1)
let IS_iPhone_4 = CScreenHeight == 480
let IS_iPhone_5 = CScreenHeight == 568
let IS_iPhone_6 = CScreenHeight == 667
let IS_iPhone_6_Plus = CScreenHeight == 736

let IS_iPhone_X = CScreenHeight == 812
let IS_iPhone_XR = CScreenHeight == 896
let IS_iPhone_XS = CScreenHeight == 812
let IS_iPhone_XS_MAX = CScreenHeight == 896

let IS_iPhone_12 = CScreenHeight == 844
let IS_iPhone_12_MINI = CScreenHeight == 780
let IS_iPhone_12_PRO = CScreenHeight == 844
let IS_iPhone_12_PROMAX = CScreenHeight == 926

let IS_iPhone_13 = CScreenHeight == 844
let IS_iPhone_13_MINI = CScreenHeight == 812
let IS_iPhone_13_PRO = CScreenHeight == 844
let IS_iPhone_13_PROMAX = CScreenHeight == 926




//let IS_iPhone_X_Series = (IS_iPhone_X || IS_iPhone_XR || IS_iPhone_XS || IS_iPhone_XS_MAX)

let IS_iPhone_X_Series = (IS_iPhone_X || IS_iPhone_XR || IS_iPhone_XS || IS_iPhone_XS_MAX || IS_iPhone_12 || IS_iPhone_12_MINI || IS_iPhone_12_PRO ||  IS_iPhone_12_PROMAX || IS_iPhone_13 || IS_iPhone_13_MINI || IS_iPhone_13_PRO  || IS_iPhone_13_PROMAX )

let CMainBundle = Bundle.main
let CBundleIdentifier = CMainBundle.bundleIdentifier
let CBundleInfoDictionary = CMainBundle.infoDictionary
let CVersionNumber = CBundleInfoDictionary?.valueForString(key: "CFBundleShortVersionString")
let CBuildNumber = CBundleInfoDictionary?.valueForString(key: "CFBundleVersion")
let CApplicationName = CBundleInfoDictionary?.valueForString(key: "CFBundleName")

func CRGB(r:CGFloat , g:CGFloat , b:CGFloat) -> UIColor {
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
}

func CRGBA(r:CGFloat , g:CGFloat , b:CGFloat , a:CGFloat) -> UIColor {
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}

let IsAudioVideoEnable = true

let GCDMainThread               = DispatchQueue.main
let GCDBackgroundThread         = DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
let GCDBackgroundThreadUtility  = DispatchQueue.global(qos: DispatchQoS.QoSClass.utility)
let GCDBackgroundThreadDefault  = DispatchQueue.global(qos: DispatchQoS.QoSClass.default)
let GCDBackgroundThreadUserInitiated  = DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated)
let GCDBackgroundThreadUserInteractive  = DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive)
let GCDBackgroundThreadUnspecified  = DispatchQueue.global(qos: DispatchQoS.QoSClass.unspecified)
