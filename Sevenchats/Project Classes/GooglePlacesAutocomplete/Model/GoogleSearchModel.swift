//
//  GoogleSearchModel.swift
//  GooglePlacesSearchController_Example
//
//  Created by mac-00020 on 13/09/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

public enum PlaceType: String {
    case all = ""
    case geocode
    case address
    case establishment
    case regions = "(regions)"
    case cities = "(cities)"
}

open class Term: NSObject {
    public let offset: Int
    public let value: String
    
    override open var description: String {
        get { return "\(offset), \(value)" }
    }
    
    init(offset: Int, value: String) {
        self.offset = offset
        self.value = value
    }
    
    convenience init(term: [String: Any]) {
        
        self.init(
            offset: term["offset"] as? Int ?? 0,
            value: term["value"] as? String ?? ""
        )
    }
}

open class Place: NSObject {
    public let id: String
    public let mainAddress: String
    public let secondaryAddress: String
    public let terms: [Term]
    
    override open var description: String {
        get { return "\(mainAddress), \(secondaryAddress)" }
    }
    
    init(id: String, mainAddress: String, secondaryAddress: String,terms:[Term]) {
        self.id = id
        self.mainAddress = mainAddress
        self.secondaryAddress = secondaryAddress
        self.terms = terms
    }
    
    convenience init(prediction: [String: Any]) {
        let structuredFormatting = prediction["structured_formatting"] as? [String: Any]
        let arrTerms : [[String: Any]] = prediction["terms"] as? [[String: Any]] ?? []
        var tmpTerms : [Term] = []
        for obj in arrTerms{
            tmpTerms.append(Term(term: obj))
        }
        self.init(
            id: prediction["place_id"] as? String ?? "",
            mainAddress: structuredFormatting?["main_text"] as? String ?? "",
            secondaryAddress: structuredFormatting?["secondary_text"] as? String ?? "",
            terms: tmpTerms
        )
    }
}

open class PlaceDetails: CustomStringConvertible {
    public var formattedAddress: String = ""
    open var name: String? = nil
    
    open var streetNumber: String? = nil
    open var route: String? = nil
    open var postalCode: String? = nil
    open var country: String? = nil
    open var state: String? = nil
    open var countryCode: String? = nil
    
    open var locality: String? = nil
    open var subLocality: String? = nil
    open var administrativeArea: String? = nil
    open var administrativeAreaCode: String? = nil
    open var subAdministrativeArea: String? = nil
    
    open var locationImage : UIImage?
    
    open var coordinate: CLLocationCoordinate2D? = nil
    
    public init(name: String?, coordinate: CLLocationCoordinate2D? = nil) {
        self.name = name
        self.coordinate = coordinate
    }
    
    init?(json: [String: Any]) {
        guard let result = json["result"] as? [String: Any],
            let formattedAddress = result["formatted_address"] as? String
            else { return nil }
        
        self.formattedAddress = formattedAddress
        self.name = result["name"] as? String
        
        if let addressComponents = result["address_components"] as? [[String: Any]] {
            streetNumber = get("street_number", from: addressComponents, ofType: .short)
            route = get("route", from: addressComponents, ofType: .short)
            postalCode = get("postal_code", from: addressComponents, ofType: .long)
            country = get("country", from: addressComponents, ofType: .long)
            countryCode = get("country", from: addressComponents, ofType: .short)
            
            locality = get("locality", from: addressComponents, ofType: .long)
            subLocality = get("sublocality", from: addressComponents, ofType: .long)
            administrativeArea = get("administrative_area_level_1", from: addressComponents, ofType: .long)
            administrativeAreaCode = get("administrative_area_level_1", from: addressComponents, ofType: .short)
            subAdministrativeArea = get("administrative_area_level_2", from: addressComponents, ofType: .long)
        }
        
        if let geometry = result["geometry"] as? [String: Any],
            let location = geometry["location"] as? [String: Any],
            let latitude = location["lat"] as? CLLocationDegrees,
            let longitude = location["lng"] as? CLLocationDegrees {
            coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
    
    open var description: String {
        return "\nAddress: \(formattedAddress)\ncoordinate: (\(coordinate?.latitude ?? 0), \(coordinate?.longitude ?? 0))\n"
    }
}

extension PlaceDetails {
    
    enum ComponentType: String {
        case short = "short_name"
        case long = "long_name"
    }
    
    /// Parses the element value with the specified type from the array or components.
    /// Example: `{ "long_name" : "90", "short_name" : "90", "types" : [ "street_number" ] }`
    ///
    /// - Parameters:
    ///   - component: The name of the element.
    ///   - array: The root component array to search from.
    ///   - ofType: The type of element to extract the value from.
    func get(_ component: String, from array: [[String: Any]], ofType: ComponentType) -> String? {
        return (array.first { ($0["types"] as? [String])?.contains(component) == true })?[ofType.rawValue] as? String
    }
}

class Annotation: NSObject {
    var latLong : CLLocationCoordinate2D
    var strTitle : String
    init(latLong : CLLocationCoordinate2D, strTitle : String) {
        self.latLong = latLong
        self.strTitle = strTitle
    }
}
extension Annotation: MKAnnotation {
    @objc public var coordinate: CLLocationCoordinate2D {
        return latLong
    }
    public var title: String?{
        return strTitle
    }
}
