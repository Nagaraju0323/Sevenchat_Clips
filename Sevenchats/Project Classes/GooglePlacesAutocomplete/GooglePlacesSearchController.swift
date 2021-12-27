//
//  GooglePlacesAutocomplete.swift
//  GooglePlacesAutocomplete
//
//  Created by Howard Wilson on 10/02/2015.
//  Copyright (c) 2015 Howard Wilson. All rights reserved.
//
//
//  Created by Dmitry Shmidt on 6/28/15.
//  Copyright (c) 2015 Dmitry Shmidt. All rights reserved.

import Foundation
import UIKit
import CoreLocation


open class GooglePlacesSearchController: UISearchController, UISearchBarDelegate {
    
    var gpaViewController : GooglePlacesAutocompleteContainer?
    
    convenience public init(delegate: GooglePlacesAutocompleteViewControllerDelegate, apiKey: String, placeType: PlaceType = .all, coordinate: CLLocationCoordinate2D = kCLLocationCoordinate2DInvalid, radius: CLLocationDistance = 0, strictBounds: Bool = false, searchBarPlaceholder: String = "Enter Address", restrictedCity:String? = nil, compontes:[String] = []) {
        assert(!apiKey.isEmpty, "Provide your API key")
        
        let _gpaViewController = GooglePlacesAutocompleteContainer(
            delegate: delegate,
            apiKey: apiKey,
            placeType: placeType,
            coordinate: coordinate,
            radius: radius,
            strictBounds: strictBounds,
            components: compontes
        )
        
        self.init(searchResultsController: _gpaViewController)
        self.gpaViewController = _gpaViewController
        self.gpaViewController?.restrictedCity = nil
        self.searchResultsUpdater = self.gpaViewController
        self.hidesNavigationBarDuringPresentation = false
        self.definesPresentationContext = true
        self.searchBar.placeholder = searchBarPlaceholder
        self.view.backgroundColor = .white
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setCurrentLocation(coordinate:CLLocationCoordinate2D?){
        guard let _coordinate = coordinate else {return}
        if CLLocationCoordinate2DIsValid(_coordinate){
            gpaViewController?.coordinate = _coordinate
        }
    }
    func setISOCode(strCode:String){
        guard !strCode.isEmpty else {return}
        gpaViewController?.components = [strCode]
    }
}

