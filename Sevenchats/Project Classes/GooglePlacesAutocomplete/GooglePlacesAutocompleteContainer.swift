//
//  GooglePlacesAutocompleteContainer.swift
//  GooglePlacesSearchController_Example
//
//  Created by mac-00020 on 13/09/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : RestrictedFilesVC                           *
 * Changes :                                             *
 *                                                       *
 ********************************************************/

import Foundation
import UIKit
import CoreLocation

open class GooglePlacesAutocompleteContainer: UITableViewController {
    private weak var delegate: GooglePlacesAutocompleteViewControllerDelegate?
    
    private var apiKey: String = ""
    private var placeType: PlaceType = .all
    var components: [String] = [] // array of two character ISO (IN,US)
    var coordinate: CLLocationCoordinate2D = kCLLocationCoordinate2DInvalid
    private var radius: Double = 50000
    private var strictBounds: Bool = false
    private let cellIdentifier = "Cell"
    var restrictedCity : String?
    
    private var places = [Place]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    convenience init(delegate: GooglePlacesAutocompleteViewControllerDelegate, apiKey: String, placeType: PlaceType = .all, coordinate: CLLocationCoordinate2D, radius: Double, strictBounds: Bool, components:[String]) {
        self.init()
        self.delegate = delegate
        self.apiKey = apiKey
        self.placeType = placeType
        self.coordinate = coordinate
        self.radius = radius
        self.strictBounds = strictBounds
        self.components = components
    }
}

//MARK: - UITableViewDelegate and UITableViewDatasource
extension GooglePlacesAutocompleteContainer {
    
    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
            ?? UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        
        let place = places[indexPath.row]
        
        cell.textLabel?.text = place.mainAddress
        cell.detailTextLabel?.text = place.secondaryAddress
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place = places[indexPath.row]
        GooglePlacesRequestHelpers
            .getPlaceDetails(id: place.id, apiKey: apiKey) { [unowned self] in
                guard let value = $0 else { return }
                self.delegate?.viewController(didAutocompleteWith: value)
        }
    }
}

//MARK: - UISearchBarDelegate, UISearchResultsUpdating
extension GooglePlacesAutocompleteContainer: UISearchBarDelegate, UISearchResultsUpdating {
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else { places = []; return }
        let parameters = getParameters(for: searchText)
        
        GooglePlacesRequestHelpers.getPlaces(with: parameters) {
            var arrPlaces = $0
            if self.restrictedCity != nil && !(self.restrictedCity?.isEmpty ?? true){
                arrPlaces = arrPlaces.filter({ (place) -> Bool in
                    let arrCitys : [String] = place.terms.compactMap({$0.value.lowercased()})
                    print(arrCitys)
                    return arrCitys.contains((self.restrictedCity?.lowercased() ?? ""))
                })
            }
            self.places = arrPlaces
        }
    }
    
    public func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else { places = []; return }
        let parameters = getParameters(for: searchText)
        
        GooglePlacesRequestHelpers.getPlaces(with: parameters) {
            var arrPlaces = $0
            if self.restrictedCity != nil && !(self.restrictedCity?.isEmpty ?? true){
                arrPlaces = arrPlaces.filter({ (place) -> Bool in
                    let arrCitys : [String] = place.terms.compactMap({$0.value.lowercased()})
                    print(arrCitys)
                    return arrCitys.contains((self.restrictedCity?.lowercased() ?? ""))
                })
            }
            self.places = arrPlaces
        }
    }
    
    private func getParameters(for text: String) -> [String: String] {
        var params = [
            "input": text,
            "types": placeType.rawValue,
            "key": apiKey
        ]
        
        if CLLocationCoordinate2DIsValid(coordinate) {
            params["location"] = "\(coordinate.latitude),\(coordinate.longitude)"
            
            if radius > 0 {
                params["radius"] = "\(radius)"
            }
            
            if strictBounds {
                params["strictbounds"] = "true"
            }
        }
        if !self.components.isEmpty{
            //components=country:us|country:pr|country:vi
            params["components"] = self.components.map({"country:\($0)"}).joined(separator: "|")
        }
        return params
    }
}
