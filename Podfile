# Uncomment the next line to define a global platform for your project
 platform :ios, '11.0'

target 'Sevenchats' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Sevenchats
  pod 'Alamofire', '= 4.9.1'
  pod 'IQKeyboardManagerSwift'
  pod 'LGSideMenuController'
  pod 'FSCalendar'
  #pod 'Fabric'
  pod 'Firebase/Crashlytics'
  #pod 'Crashlytics'
  pod 'ISEmojiView'

  # (Recommended) Pod for Google Analytics
  pod 'Firebase/Analytics'
  
  #pod 'TwitterKit'
  pod 'ActiveLabel'
  pod 'GoogleSignIn'
  pod 'CocoaMQTT'
  pod 'GSImageViewerController'
  pod 'TrueTime'
  pod 'Firebase/Core'
  pod 'Firebase/Messaging'
  pod 'FBSDKLoginKit'
  pod 'SDWebImage'
  pod 'SDWebImage/GIF'
  #pod 'GooglePlacePicker'
  pod 'GooglePlaces'
  pod 'GoogleMaps'
  pod "TLPhotoPicker"
  pod 'Lightbox'
  pod 'Cosmos'
  pod 'ObjectMapper'
  pod 'TwilioVideo', '~> 3.2'
  pod 'TwilioVoice'
  pod 'SwiftySound'
  pod 'PhoneNumberKit'
  pod 'DropDown'
  pod 'AWSS3' , '~> 2.6.27' 
  pod 'StompClientLib'  
  pod 'Socket.IO-Client-Swift'
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        if target.name == 'Cache'
          config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Onone'
        end
        config.build_settings['SWIFT_VERSION'] = '5.0'
        config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'dwarf'
      end
    end
  end
  
end
