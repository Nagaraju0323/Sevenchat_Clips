//
//  MILocationManager.swift
//  Sevenchats
//
//  Created by mac-00017 on 22/10/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : MILocationManager                           *
 * Description : Update location help with google Maps   *
 *                                                       *
 ********************************************************/

import UIKit
import CoreLocation
import Contacts
import MapKit
import GooglePlaces
//import GooglePlacePicker
//import LocationPicker

struct MDLLocation {
    var country : String?
    var state : String?
    var city : String?
    var formattedAddress : String?
    var coordinate :CLLocationCoordinate2D?
    var apiTask : URLSessionTask?
    init(formattedAddress:String,coordinate :CLLocationCoordinate2D) {
        self.formattedAddress = formattedAddress
        self.coordinate = coordinate
    }
}

class MILocationManager: NSObject, CLLocationManagerDelegate {
    
    var locationManager : CLLocationManager?
    var currentLocation : CLLocation?
    let geocoder = CLGeocoder()
    var placemark: CLPlacemark?
    var cityName: String?
    var country: String?
    var countryShortName: String?
    var stateName:String?
    var location: CLLocation?
    var apiTask : URLSessionTask?
    var cityNameFromList:String?
    
    var stateListMain = [ "AN":"Andaman and Nicobar Islands",
                          "AP":"Andhra Pradesh",
                          "AR":"Arunachal Pradesh",
                          "AS":"Assam",
                          "BR":"Bihar",
                          "CH":"Chandigarh",
                          "CT":"Chhattisgarh",
                          "DN":"Dadra and Nagar Haveli",
                          "DD":"Daman and Diu",
                          "DL":"Delhi",
                          "GA":"Goa",
                          "GJ":"Gujarat",
                          "HR":"Haryana",
                          "Himachal Pradesh":"HP",
                          "JK":"Jammu and Kashmir",
                          "JH":"Jharkhand",
                          "KA":"Karnataka",
                          "KL":"Kerala",
                          "LD":"Lakshadweep",
                          "MP":"Madhya Pradesh",
                          "MH":"Maharashtra",
                          "MN":"Manipur",
                          "ML":"Meghalaya",
                          "MZ":"Mizoram",
                          "NL": "Nagaland",
                          "OR":"Odisha",
                          "PY":"Puducherry",
                          "PB":"Punjab",
                          "RJ":"Rajasthan",
                          "SK":"Sikkim",
                          "TN":"Tamil Nadu",
                          "TG":"Telangana",
                          "TR":"Tripura",
                          "UP":"Uttar Pradesh",
                          "UT":"Uttarakhand",
                          "WB":"West Bengal"]
    
    
    private override init() {
        super.init()
    }
    
    private static var locManager:MILocationManager = {
        let locManager = MILocationManager()
        return locManager
    }()
    
    static func shared() ->MILocationManager {
        return locManager
    }
    
    func initializeLocationManager()
    {
        if (locationManager == nil)
        {
            locationManager = CLLocationManager()
            locationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager?.distanceFilter = 100
            locationManager?.delegate = self as CLLocationManagerDelegate
            locationManager?.requestWhenInUseAuthorization()
            locationManager?.requestAlwaysAuthorization()
        }
        
        locationManager?.startUpdatingLocation()
        locationManager?.startMonitoringSignificantLocationChanges()
    }
}

// MARK:- ------------ Location Manager delegate

extension MILocationManager {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if (locations.last != nil) {
            currentLocation = locations.last
            
            geocoder.reverseGeocodeLocation(currentLocation!, completionHandler: { (placemarks, error) in
                if error == nil, let placemark = placemarks, !placemark.isEmpty {
                    
                    if placemark.last?.locality != nil {
                        self.cityName =  placemark.last?.locality
                    }
                    
                    if placemark.last?.subAdministrativeArea != nil {
                        self.stateName =  placemark.last?.administrativeArea
                        
                    }
                    if let i = self.stateListMain.index(forKey: self.stateName!) {
                        print(self.stateListMain.values[i])
                        let stateNames = self.stateListMain.values[i]
                        //----ApiCall CityName
                        self.cityList(stateNameList:stateNames,cityNames:self.cityName ?? "")
                        
                    } else {
                        print("printvalues not at there")
                    }
                    
                }
            })
        }
    }
    
    func cityList(stateNameList: String,cityNames:String){
        
        let timestamp : TimeInterval = 0
        apiTask = APIRequest.shared().cityList(timestamp: timestamp as AnyObject, stateId: stateNameList ) { [weak self] (response, error) in
            guard let self = self else {return}
            if response != nil && error == nil {
                DispatchQueue.main.async {
                    let arrData = response![CData] as? [[String : Any]] ?? []
                    for obj in arrData{
                        //                        print("cityNames-----\(cityNames)")
                        if self.cityName == obj.valueForString(key: "city_name"){
                            self.cityNameFromList = self.cityName
                            //                            print("cityNamesMatched------")
                            return
                        }else {
                            //                            print("cityNamesMatchedNot------")
                            self.cityNameFromList = "Bengaluru"
                        }
                    }
                }
            }
        }
    }
}



// MARK:- ------------ Location Manager delegate
typealias GMSPlacePickerInfoBlock = ((MDLLocation) -> Void)
var gmsPlacePickerInfoBlock:GMSPlacePickerInfoBlock?
/*
 extension MILocationManager : GMSPlacePickerViewControllerDelegate {
 
 func openGMSPlacePicker(_ viewController : UIViewController, completion placePickerInfoBlock:GMSPlacePickerInfoBlock?) {
 
 gmsPlacePickerInfoBlock = placePickerInfoBlock
 
 
 /*let center = CLLocationCoordinate2DMake(MILocationManager.shared().currentLocation?.coordinate.latitude ?? 0.0, MILocationManager.shared().currentLocation?.coordinate.longitude ?? 0.0) as CLLocationCoordinate2D
  
  let northEast = CLLocationCoordinate2D(latitude: center.latitude + 0.001, longitude: center.longitude + 0.001)
  let southWest = CLLocationCoordinate2D(latitude: center.latitude - 0.001, longitude: center.longitude - 0.001)
  let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
  let config = GMSPlacePickerConfig(viewport: viewport)
  self.showPlacePicker(config: config, viewController)*/
 
 
 /*let locationPicker = LocationPickerViewController()
  locationPicker.restructedCity = "ahmedabad"
  locationPicker.isShowingHistory = false
  
  // button placed on right bottom corner
  locationPicker.showCurrentLocationButton = true // default: true
  
  // default: navigation bar's `barTintColor` or `.whiteColor()`
  locationPicker.currentLocationButtonBackground = .white
  
  // ignored if initial location is given, shows that location instead
  locationPicker.showCurrentLocationInitially = true // default: true
  
  locationPicker.mapType = .standard // default: .Hybrid
  
  // for searching, see `MKLocalSearchRequest`'s `region` property
  locationPicker.useCurrentLocationAsHint = true // default: false
  
  locationPicker.searchBarPlaceholder = "Search places" // default: "Search or enter an address"
  
  locationPicker.searchHistoryLabel = "Previously searched" // default: "Search History"
  
  // optional region distance to be used for creation region when user selects place from search results
  locationPicker.resultRegionDistance = 500 // default: 600
  
  locationPicker.completion = { [weak self] (location) in
  guard let _ = self else { return }
  
  print("Country : " + (location?.placemark.country ?? "N/A"))
  print("State : " + (location?.placemark.addressDictionary?["State"] as? String ?? "N/A"))
  print("City : " + (location?.placemark.locality ?? "N/A"))
  print("subLocality : " + (location?.placemark.subLocality ?? "N/A"))
  print("isoCountryCode : " + (location?.placemark.isoCountryCode ?? "N/A"))
  print("postalCode : " + (location?.placemark.postalCode ?? "N/A"))
  //print(location)
  var locationObj = MDLLocation(formattedAddress: location?.address ?? "", coordinate: location?.location.coordinate ?? CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0))
  locationObj.country = (location?.placemark.country ?? "")
  locationObj.state = (location?.placemark.addressDictionary?["State"] as? String ?? "")
  locationObj.city = (location?.placemark.locality ?? "")
  
  gmsPlacePickerInfoBlock?(locationObj)
  }
  
  locationPicker.title = "Select Location"
  //viewController.present(locationPicker, animated: true, completion: nil)
  viewController.navigationController?.pushViewController(locationPicker, animated: true)*/
 }
 
 func showPlacePicker(config: GMSPlacePickerConfig, _ viewController : UIViewController ){
 
 let placePicker = GMSPlacePickerViewController(config: config)
 placePicker.delegate = self
 viewController.present(placePicker, animated: true, completion: nil)
 }
 
 
 //...Called when a place has been selected
 func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
 
 viewController.dismiss(animated: true) {
 /*if gmsPlacePickerInfoBlock != nil{
  gmsPlacePickerInfoBlock!(place)
  gmsPlacePickerInfoBlock = nil
  }*/
 }
 }
 
 //...Called when the place picking operation has been cancelled.
 func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
 viewController.dismiss(animated: true, completion: nil)
 }
 func placePicker(_ viewController: GMSPlacePickerViewController, didFailWithError error: Error) {
 print(error.localizedDescription)
 }
 }
 */
