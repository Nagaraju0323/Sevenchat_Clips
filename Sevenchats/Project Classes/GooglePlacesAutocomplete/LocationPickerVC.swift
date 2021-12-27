//
//  LocationPickerVC.swift
//  GooglePlacesSearchController_Example
//
//  Created by mac-00020 on 13/09/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

//import Foundation
//import UIKit
//import MapKit
//import CoreLocation
//
//
//class LocationPickerVC: UIViewController {
//
//    //MARK: - IBOutlet/Object/Variable Declaration
//    struct CurrentLocationListener {
//        let once: Bool
//        let action: (CLLocation) -> ()
//    }
//    var prefixLocation : CLLocationCoordinate2D?
//    var currentLocationListeners: [CurrentLocationListener] = []
//    // region distance to be used for creation region when user selects place from search results
//    public var resultRegionDistance: CLLocationDistance = 600
//
//    @IBOutlet var mapView: MKMapView!
//    @IBOutlet var vwAddress: UIView!
//    @IBOutlet var vwBlur: VisualEffectView!
//    @IBOutlet var lblAddress: UILabel!
//    @IBOutlet var imgSelectLocation: UIImageView!
//
//    var annotationView : MKAnnotationView?
//    var annotation : MKPointAnnotation?
//
//    @IBOutlet weak var imgSelectLocationHorzConst: NSLayoutConstraint!
//    public var mapType: MKMapType = .standard {
//        didSet {
//            if isViewLoaded {
//                mapView.mapType = mapType
//            }
//        }
//    }
//    let geocoder = CLGeocoder()
//    var location : PlaceDetails?{
//        didSet {
//            if isViewLoaded {
//                updateAnnotation()
//                self.strAdderess = location?.formattedAddress ?? ""
//            }
//        }
//    }
//
//    let locationManager = CLLocationManager()
//    lazy var placesSearchController: GooglePlacesSearchController = {
//        let controller = GooglePlacesSearchController(
//            delegate: self,
//            apiKey: CGooglePlacePickerKey,
//            placeType: .geocode,
//            coordinate: kCLLocationCoordinate2DInvalid,
//            radius: 50000,
//            strictBounds: true,
//            searchBarPlaceholder: "Start typing..."
//        )
//        //Optional: controller.searchBar.isTranslucent = false
//        //Optional: controller.searchBar.barStyle = .black
//        //Optional: controller.searchBar.tintColor = .white
//        //Optional: controller.searchBar.barTintColor = .black
//        return controller
//    }()
//
//    /// default: true
//    public var showCurrentLocationButton = true
//    /// default: true
//    public var showCurrentLocationInitially = true
//
//    /// default: false
//    /// Select current location only if `location` property is nil.
//    public var selectCurrentLocationInitially = false
//    var presentedInitialLocation = false
//
//    /// default: "Select"
//    public var selectButtonTitle = "Select"
//    public var completion: ((PlaceDetails?) -> ())?
//    var locationButton: UIButton?
//    var getImageLocation = false
//
//    var showConfirmAlertOnSelectLocation = false
//
//    var strAdderess = ""{
//        didSet{
//            UIView.animate(withDuration: 0.3, animations: {
//                self.vwAddress.alpha = self.strAdderess.isEmpty ? 0 : 1
//            }) { (_) in
//                self.lblAddress.text = self.strAdderess
//            }
//        }
//    }
//
//    //MARK: - View life cycle methods
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.setupView()
//        self.backButtonSetup()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.isNavigationBarHidden = false
//    }
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        if !presentedInitialLocation && prefixLocation == nil{
//            setInitialLocation()
//            presentedInitialLocation = true
//        }
//        if let coordinate = prefixLocation,
//            CLLocationCoordinate2DIsValid(coordinate),
//            coordinate.latitude != 0.0 {
//            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
//            selectLocation(location: location)
//            showCoordinates(location.coordinate)
//            prefixLocation = nil
//        }
//    }
//
//    open override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        // setting initial location here since viewWillAppear is too early, and viewDidAppear is too late
//    }
//
//    func backButtonSetup(){
//        let imgBack = UIImage(named: "ic_back")
//        let backBarButton = BlockBarButtonItem(image: imgBack, style: .plain) { [weak self] (_) in
//            guard let _ = self else {return}
//            self?.navigationController?.popViewController(animated: true)
//        }
//        self.navigationItem.leftBarButtonItem = backBarButton
//    }
//
//    //MARK: - Memory management methods
//    deinit {
//        print("### deinit -> LocationPickerVC")
//    }
//}
//
////MARK: - SetupUI
//extension LocationPickerVC {
//    fileprivate func setupView() {
//
//        self.title = CSelectLocation
//
//        strAdderess = ""
//        mapView.showsCompass = false
//        mapView.mapType = mapType
//        mapView.delegate = self
//        locationManager.delegate = self
//
//        // user location
//        mapView.userTrackingMode = .none
//        mapView.showsUserLocation = showCurrentLocationInitially || showCurrentLocationButton
//
//        /* // gesture recognizer for adding by tap
//        let locationSelectGesture = UILongPressGestureRecognizer(
//            target: self, action: #selector(addLocation(_:)))
//        locationSelectGesture.delegate = self
//        mapView.addGestureRecognizer(locationSelectGesture)
//        */
//        let searchBarItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(onSearchBarButton))
//        self.navigationItem.rightBarButtonItem = searchBarItem
//
//        if showCurrentLocationButton {
//            let button = UIButton()
//            button.backgroundColor = .white
//            button.layer.masksToBounds = true
//            button.layer.cornerRadius = 16
//            button.setImage(UIImage(named: "geolocation"), for: .normal)
//            button.addTarget(self, action: #selector(currentLocationPressed),
//                             for: .touchUpInside)
//            button.translatesAutoresizingMaskIntoConstraints =  false
//            view.addSubview(button)
//            if #available(iOS 11, *) {
//                let guide = view.safeAreaLayoutGuide
//                NSLayoutConstraint.activate([
//                    button.widthAnchor.constraint(equalToConstant: 35.0),
//                    button.heightAnchor.constraint(equalToConstant: 35.0),
//                    button.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -30),
//                    button.rightAnchor.constraint(equalTo: guide.rightAnchor, constant: -20)
//                    ])
//            } else {
//                NSLayoutConstraint.activate([
//                    button.widthAnchor.constraint(equalToConstant: 35.0),
//                    button.heightAnchor.constraint(equalToConstant: 35.0),
//                    button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30),
//                    button.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20)
//                ])
//            }
//            locationButton = button
//        }
//        setupAddressSelectionView()
//        checkLocationPermission()
//    }
//
//    func setupAddressSelectionView(){
//        vwBlur.tint(UIColor.black.withAlphaComponent(0.2), blurRadius: 6.0)
//    }
//
//    fileprivate func checkLocationPermission(){
//        if CLLocationManager.locationServicesEnabled() {
//            let restrictedStatus : [CLAuthorizationStatus] = [.notDetermined, .restricted, .denied]
//            let status = CLLocationManager.authorizationStatus()
//            if restrictedStatus.contains(status){
//                let alert = UIAlertController(title: CLocationServicesDisabled, message: CPleaseEnableLocationServices, preferredStyle: .alert)
//                let okAction = UIAlertAction(title: CBtnOk, style: .default) { (_) in
//                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
//                        return
//                    }
//                    if UIApplication.shared.canOpenURL(settingsUrl) {
//                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
//                            print("Settings opened: \(success)")
//                        })
//                    }
//                }
//                alert.addAction(okAction)
//
//                present(alert, animated: true, completion: nil)
//            }else{
//                self.showCurrentLocation(false)
//            }
//        } else {
//            print("Location services are not enabled")
//        }
//    }
//
//    fileprivate func setInitialLocation() {
//        if let location = location {
//            // present initial location if any
//            self.location = location
//            if let coordinate = location.coordinate{
//                showCoordinates(coordinate, animated: false)
//            }
//            return
//        } else if showCurrentLocationInitially || selectCurrentLocationInitially {
//            if selectCurrentLocationInitially {
//                let listener = CurrentLocationListener(once: true) { [weak self] location in
//                    if self?.location == nil { // user hasn't selected location still
//                        self?.selectLocation(location: location)
//                    }
//                }
//                currentLocationListeners.append(listener)
//            }
//            checkLocationPermission()
//        }
//    }
//
//    fileprivate func getLocationImage(){
//        guard let coordinate = self.location?.coordinate else {
//            self.completion?(self.location)
//            return
//        }
//
//        let strLatitude = coordinate.latitude.description
//        let strLongitude = coordinate.longitude.description
//        let url = "https://maps.googleapis.com/maps/api/staticmap?size=350x220&maptype=roadmap%5C&markers=size:mid%7Ccolor:red%7C\(strLatitude + "," + strLongitude)&zoom=13&key=\(CGoogleAPIKey)"
//        //AIzaSyBm8tiCaKh-Ghkh7dx42CEOB0EfEHT7_v8
//        print(url)
//        load(url: URL(string: url))
//    }
//
//    fileprivate func load(url: URL?) {
//        guard let _url = url else {return}
//        MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
//        DispatchQueue.global().async { [weak self] in
//            if let data = try? Data(contentsOf: _url) {
//                if let image = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                        MILoader.shared.hideLoader()
//                        self?.location?.locationImage = image
//                        self?.completion?(self?.location)
//                        if let navigation = self?.navigationController, navigation.viewControllers.count > 1 {
//                            navigation.popViewController(animated: true)
//                        } else {
//                            self?.presentingViewController?.dismiss(animated: true, completion: nil)
//                        }
//                    }
//                } else {
//                    DispatchQueue.main.async {
//                        MILoader.shared.hideLoader()
//                        self?.completion?(nil)
//                    }
//                }
//            } else {
//                DispatchQueue.main.async {
//                    MILoader.shared.hideLoader()
//                    self?.completion?(nil)
//                }
//            }
//        }
//    }
//}
//
////MARK: - IBAction / Selector
//extension LocationPickerVC {
//
//    @objc func onSearchBarButton(_ sender: UIBarButtonItem) {
//        present(placesSearchController, animated: true, completion: nil)
//    }
//
//    @objc func addLocation(_ gestureRecognizer: UIGestureRecognizer) {
//        if gestureRecognizer.state == .began {
//            let point = gestureRecognizer.location(in: mapView)
//            let coordinates = mapView.convert(point, toCoordinateFrom: mapView)
//            let location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
//
//            // clean location, cleans out old annotation too
//            self.location = nil
//            selectLocation(location: location)
//        }
//    }
//
//    @objc func currentLocationPressed() {
//        showCurrentLocation()
//    }
//
//    @IBAction func onSendLocation(_ sender:UIButton){
//        if showConfirmAlertOnSelectLocation{
//            self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CAreYouSureYouWantToShareThisLocation, btnOneTitle: CBtnYes, btnOneTapped: { [weak self] (alert) in
//                guard let self = self else {return}
//                self.sendLocation()
//            }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
//        }else {
//            self.sendLocation()
//        }
//    }
//
//    func sendLocation(){
//        if !getImageLocation{
//            self.completion?(self.location)
//            if let navigation = navigationController, navigation.viewControllers.count > 1 {
//                navigation.popViewController(animated: true)
//            } else {
//                presentingViewController?.dismiss(animated: true, completion: nil)
//            }
//        }else{
//            self.getLocationImage()
//        }
//    }
//}
//
////MARK: - UIGestureRecognizerDelegate
//extension LocationPickerVC: UIGestureRecognizerDelegate {
//    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
//}
//
////MARK: - CLLocationManagerDelegate
//extension LocationPickerVC: CLLocationManagerDelegate {
//    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.first else { return }
//        currentLocationListeners.forEach { $0.action(location) }
//        currentLocationListeners = currentLocationListeners.filter { !$0.once }
//        placesSearchController.setCurrentLocation(coordinate: location.coordinate)
//        manager.stopUpdatingLocation()
//        selectLocation(location: location)
//        showCoordinates(location.coordinate)
//    }
//
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        self.checkLocationPermission()
//    }
//}
//
////MARK: - GooglePlacesAutocompleteViewControllerDelegate
//extension LocationPickerVC: GooglePlacesAutocompleteViewControllerDelegate {
//    func viewController(didAutocompleteWith place: PlaceDetails) {
//        print(place.description)
//        placesSearchController.isActive = false
//        self.location = place
//        if let coordinate = self.location?.coordinate {
//            showCoordinates(coordinate)
//        }
//    }
//}
//
////MARK: - Select Location
//extension LocationPickerVC {
//
//    func getCurrentLocation() {
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
//    }
//
//    func showCurrentLocation(_ animated: Bool = true) {
//        let listener = CurrentLocationListener(once: true) { [weak self] location in
//            self?.showCoordinates(location.coordinate, animated: animated)
//        }
//        currentLocationListeners.append(listener)
//        getCurrentLocation()
//    }
//
//    func updateAnnotation() {
//        //mapView.removeAnnotations(mapView.annotations)
//        if let location = location {
//            guard let coordinate = location.coordinate else {
//                return
//            }
//            if let annotation = self.addAnnotation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)){
//                mapView.selectAnnotation(annotation, animated: true)
//            }
//            /*let annotation = MKPointAnnotation()
//             annotation.title = location.name ?? ""
//             annotation.coordinate = coordinate
//             //Annotation(latLong: coordinate, strTitle: location.name ?? "")
//             if self.annotation == nil{
//             mapView.addAnnotation(annotation)
//             }
//             self.annotation = annotation
//             mapView.selectAnnotation(annotation, animated: true)
//             //showCoordinates(coordinate)
//             */
//        }
//    }
//
//    func addAnnotation(_ location: CLLocation) -> MKPointAnnotation?{
//
//        let annotations = mapView.annotations.filter({$0.isKind(of: MKPointAnnotation.classForCoder()) })
//
//        if annotations.isEmpty{
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = location.coordinate
//            mapView.addAnnotation(annotation)
//            return annotation
//        }
//        if let annotation = annotations.first{
//            if let _annotation = annotation as? MKPointAnnotation {
//                _annotation.coordinate = location.coordinate
//                return _annotation
//            }
//        }
//        return nil
//        /*let annotation = MKPointAnnotation()
//        annotation.coordinate = location.coordinate
//        if self.annotation == nil{
//            mapView.addAnnotation(annotation)
//        }else{
//
//            for annotation in mapView.annotations {
//                if let annotation = annotation as? MKPointAnnotation {
//                    annotation.coordinate = location.coordinate
//                }
//            }
//        }
//        self.annotation = annotation
//
//        return annotation*/
//    }
//
//    func showCoordinates(_ coordinate: CLLocationCoordinate2D, animated: Bool = true) {
//        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: resultRegionDistance, longitudinalMeters: resultRegionDistance)
//        mapView.setRegion(region, animated: animated)
//    }
//
//    func selectLocation(location: CLLocation) {
//        // add point annotation to map
//        /*let annotation = MKPointAnnotation()
//        annotation.coordinate = location.coordinate
//        if self.annotation == nil{
//            mapView.addAnnotation(annotation)
//        }
//        self.annotation = annotation*/
//        let annotation = self.addAnnotation(location)
//        if annotation == nil { return }
//        geocoder.cancelGeocode()
//        geocoder.reverseGeocodeLocation(location) { response, error in
//            if let error = error as NSError?, error.code != 10 { // ignore cancelGeocode errors
//                // show error and remove annotation
//                let alert = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in }))
//                self.present(alert, animated: true) {
//                    self.mapView.removeAnnotation(annotation!)
//                }
//            } else if let placemark = response?.first {
//
//                if let addressDic = placemark.addressDictionary {
//                    var _strAddress = ""
//                    if let lines = addressDic["FormattedAddressLines"] as? [String] {
//                        _strAddress = lines.joined(separator: ", ")
//                    }
//                    self.strAdderess = _strAddress
//                    // pass user selected location too
//                    let locationObj = PlaceDetails(name: _strAddress, coordinate: location.coordinate)
//                    locationObj.formattedAddress = _strAddress
//                    locationObj.country = placemark.country
//                    locationObj.locality = placemark.locality
//                    locationObj.subLocality = placemark.subLocality
//                    locationObj.countryCode = placemark.isoCountryCode
//                    locationObj.postalCode = placemark.postalCode
//
//                    self.location = locationObj
//                }
//            }
//        }
//    }
//}
//
//
//// MARK: MKMapViewDelegate
//
//extension LocationPickerVC: MKMapViewDelegate {
//
//    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
//        self.annotationView?.alpha = 0
//        self.imgSelectLocation.alpha = 0.7
//    }
//
//    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//
//        self.location = nil
//        let location = CLLocation(latitude: self.mapView.centerCoordinate.latitude, longitude: self.mapView.centerCoordinate.longitude)
//        self.selectLocation(location: location)
//        self.imgSelectLocation.alpha = 0.0
//        self.annotationView?.alpha = 1
//    }
//
//    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//
//        if annotation is MKUserLocation { return nil }
//
//        var view: MKAnnotationView
//        let pinImg = UIImage(named: "ic_location_pin")
//        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotation") {
//            dequeuedView.annotation = annotation
//            view = dequeuedView
//        } else {
//            view = MKAnnotationView(annotation: annotation, reuseIdentifier: "annotation")
//            view.canShowCallout = false
//        }
//
//        view.image = pinImg
//        self.annotationView = view
//        return view
//    }
//
//    func selectLocationButton() -> UIButton {
//        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 30))
//        button.setTitle(selectButtonTitle, for: UIControl.State())
//        if let titleLabel = button.titleLabel {
//            let width = titleLabel.textRect(forBounds: CGRect(x: 0, y: 0, width: Int.max, height: 30), limitedToNumberOfLines: 1).width
//            button.frame.size = CGSize(width: width, height: 30.0)
//        }
//        button.setTitleColor(view.tintColor, for: UIControl.State())
//        return button
//    }
//
//    public func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        if !getImageLocation{
//            self.completion?(self.location)
//            if let navigation = navigationController, navigation.viewControllers.count > 1 {
//                navigation.popViewController(animated: true)
//            } else {
//                presentingViewController?.dismiss(animated: true, completion: nil)
//            }
//        }else{
//            self.getLocationImage()
//        }
//    }
//
//    public func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
//        let pins = mapView.annotations.filter { $0 is MKPinAnnotationView }
//        assert(pins.count <= 1, "Only 1 pin annotation should be on map at a time")
//
//        if let userPin = views.first(where: { $0.annotation is MKUserLocation }) {
//            userPin.canShowCallout = false
//        }
//    }
//}


/****************************NEW CODE **********************************/
import Foundation
import UIKit
import MapKit
import CoreLocation


class LocationPickerVC: UIViewController {
    
    //MARK: - IBOutlet/Object/Variable Declaration
    struct CurrentLocationListener {
        let once: Bool
        let action: (CLLocation) -> ()
    }
    var prefixLocation : CLLocationCoordinate2D?
    var currentLocationListeners: [CurrentLocationListener] = []
    // region distance to be used for creation region when user selects place from search results
    public var resultRegionDistance: CLLocationDistance = 600
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var vwAddress: UIView!
    @IBOutlet var vwBlur: VisualEffectView!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var imgSelectLocation: UIImageView!
    var set_auto_Delete = 0
    
    var annotationView : MKAnnotationView?
    var annotation : MKPointAnnotation?
    
    @IBOutlet weak var imgSelectLocationHorzConst: NSLayoutConstraint!
    public var mapType: MKMapType = .standard {
        didSet {
            if isViewLoaded {
                mapView.mapType = mapType
            }
        }
    }
    let geocoder = CLGeocoder()
    var location : PlaceDetails?{
        didSet {
            if isViewLoaded {
                updateAnnotation()
                self.strAdderess = location?.formattedAddress ?? ""
            }
        }
    }
    
    let locationManager = CLLocationManager()
    lazy var placesSearchController: GooglePlacesSearchController = {
        let controller = GooglePlacesSearchController(
            delegate: self,
            apiKey: CGooglePlacePickerKey,
            placeType: .geocode,
            coordinate: kCLLocationCoordinate2DInvalid,
            radius: 50000,
            strictBounds: true,
            searchBarPlaceholder: "Start typing..."
        )
        //Optional: controller.searchBar.isTranslucent = false
        //Optional: controller.searchBar.barStyle = .black
        //Optional: controller.searchBar.tintColor = .white
        //Optional: controller.searchBar.barTintColor = .black
        return controller
    }()
    
    /// default: true
    public var showCurrentLocationButton = true
    /// default: true
    public var showCurrentLocationInitially = true
    
    /// default: false
    /// Select current location only if `location` property is nil.
    public var selectCurrentLocationInitially = false
    var presentedInitialLocation = false
    
    /// default: "Select"
    public var selectButtonTitle = "Select"
    public var completionAutoDelete: ((_ infoToReturn :Int) ->())?
    public var completion: ((PlaceDetails?) -> ())?
    
    var locationButton: UIButton?
    var getImageLocation = false
    
    var showConfirmAlertOnSelectLocation = false
    
    var strAdderess = ""{
        didSet{
            UIView.animate(withDuration: 0.3, animations: {
                self.vwAddress.alpha = self.strAdderess.isEmpty ? 0 : 1
            }) { (_) in
                self.lblAddress.text = self.strAdderess
            }
        }
    }
    
    //MARK: - View life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.backButtonSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !presentedInitialLocation && prefixLocation == nil{
            setInitialLocation()
            presentedInitialLocation = true
        }
        if let coordinate = prefixLocation,
            CLLocationCoordinate2DIsValid(coordinate),
            coordinate.latitude != 0.0 {
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            selectLocation(location: location)
            showCoordinates(location.coordinate)
            prefixLocation = nil
        }
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // setting initial location here since viewWillAppear is too early, and viewDidAppear is too late
    }
    
    func backButtonSetup(){
        //let imgBack = UIImage(named: "ic_back")
        var imgBack : UIImage?
        if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
            imgBack = UIImage(named: "ic_back_reverse")!
            
        }else{
            imgBack = UIImage(named: "ic_back")!
        }
        let backBarButton = BlockBarButtonItem(image: imgBack, style: .plain) { [weak self] (_) in
            guard let _ = self else {return}
            self?.navigationController?.popViewController(animated: true)
        }
        self.navigationItem.leftBarButtonItem = backBarButton
    }
    
    //MARK: - Memory management methods
    deinit {
        print("### deinit -> LocationPickerVC")
    }
}

//MARK: - SetupUI
extension LocationPickerVC {
    fileprivate func setupView() {
        
        self.title = CSelectLocation
        
        strAdderess = ""
        mapView.showsCompass = false
        mapView.mapType = mapType
        mapView.delegate = self
        locationManager.delegate = self
        
        // user location
        mapView.userTrackingMode = .none
        mapView.showsUserLocation = showCurrentLocationInitially || showCurrentLocationButton
        
        /* // gesture recognizer for adding by tap
        let locationSelectGesture = UILongPressGestureRecognizer(
            target: self, action: #selector(addLocation(_:)))
        locationSelectGesture.delegate = self
        mapView.addGestureRecognizer(locationSelectGesture)
        */
        let searchBarItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(onSearchBarButton))
        self.navigationItem.rightBarButtonItem = searchBarItem
        
        if showCurrentLocationButton {
            let button = UIButton()
            button.backgroundColor = .white
            button.layer.masksToBounds = true
            button.layer.cornerRadius = 16
            button.setImage(UIImage(named: "geolocation"), for: .normal)
            button.addTarget(self, action: #selector(currentLocationPressed),
                             for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints =  false
            view.addSubview(button)
            if #available(iOS 11, *) {
                let guide = view.safeAreaLayoutGuide
                NSLayoutConstraint.activate([
                    button.widthAnchor.constraint(equalToConstant: 35.0),
                    button.heightAnchor.constraint(equalToConstant: 35.0),
                    button.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -30),
                    button.rightAnchor.constraint(equalTo: guide.rightAnchor, constant: -20)
                    ])
            } else {
                NSLayoutConstraint.activate([
                    button.widthAnchor.constraint(equalToConstant: 35.0),
                    button.heightAnchor.constraint(equalToConstant: 35.0),
                    button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30),
                    button.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20)
                ])
            }
            locationButton = button
        }
        setupAddressSelectionView()
        checkLocationPermission()
    }
    
    func setupAddressSelectionView(){
        vwBlur.tint(UIColor.black.withAlphaComponent(0.2), blurRadius: 6.0)
    }
    
    fileprivate func checkLocationPermission(){
        if CLLocationManager.locationServicesEnabled() {
            let restrictedStatus : [CLAuthorizationStatus] = [.notDetermined, .restricted, .denied]
            let status = CLLocationManager.authorizationStatus()
            if restrictedStatus.contains(status){
                let alert = UIAlertController(title: CLocationServicesDisabled, message: CPleaseEnableLocationServices, preferredStyle: .alert)
                let okAction = UIAlertAction(title: CBtnOk, style: .default) { (_) in
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)")
                        })
                    }
                }
                alert.addAction(okAction)
                
                present(alert, animated: true, completion: nil)
            }else{
                self.showCurrentLocation(false)
            }
        } else {
            print("Location services are not enabled")
        }
    }
    
    fileprivate func setInitialLocation() {
        if let location = location {
            // present initial location if any
            self.location = location
            if let coordinate = location.coordinate{
                showCoordinates(coordinate, animated: false)
            }
            return
        } else if showCurrentLocationInitially || selectCurrentLocationInitially {
            if selectCurrentLocationInitially {
                let listener = CurrentLocationListener(once: true) { [weak self] location in
                    if self?.location == nil { // user hasn't selected location still
                        self?.selectLocation(location: location)
                    }
                }
                currentLocationListeners.append(listener)
            }
            checkLocationPermission()
        }
    }
    
    fileprivate func getLocationImage(){
        guard let coordinate = self.location?.coordinate else {
            self.completion?(self.location)
//            guard let cb = completionAutoDelete else {return}
//            cb(set_auto_Delete)
            return
        }

        let strLatitude = coordinate.latitude.description
        let strLongitude = coordinate.longitude.description
        let url = "https://maps.googleapis.com/maps/api/staticmap?size=350x220&maptype=roadmap%5C&markers=size:mid%7Ccolor:red%7C\(strLatitude + "," + strLongitude)&zoom=13&key=\(CGoogleAPIKey)"
        //AIzaSyBm8tiCaKh-Ghkh7dx42CEOB0EfEHT7_v8
        print(url)
      
        load(url: URL(string: url))
        
//        guard let cb = self.completionAutoDelete else {return}
//        cb("true")    
    }
    
    fileprivate func load(url: URL?) {
        guard let _url = url else {return}
        MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")

        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: _url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        MILoader.shared.hideLoader()
                       
                        self?.location?.locationImage = image
                        self?.completion?(self?.location)
                      
                        if let navigation = self?.navigationController, navigation.viewControllers.count > 1 {
                            navigation.popViewController(animated: true)
                        } else {
                            self?.presentingViewController?.dismiss(animated: true, completion: nil)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        MILoader.shared.hideLoader()
                        self?.completion?(nil)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    MILoader.shared.hideLoader()
                    self?.completion?(nil)
                }
            }
        }
    }
}

//MARK: - IBAction / Selector
extension LocationPickerVC {
    
    @objc func onSearchBarButton(_ sender: UIBarButtonItem) {
        present(placesSearchController, animated: true, completion: nil)
    }
    
    @objc func addLocation(_ gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let point = gestureRecognizer.location(in: mapView)
            let coordinates = mapView.convert(point, toCoordinateFrom: mapView)
            let location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
            
            // clean location, cleans out old annotation too
            self.location = nil
            selectLocation(location: location)
        }
    }
    
    @objc func currentLocationPressed() {
        showCurrentLocation()
    }
    
    @IBAction func onSendLocation(_ sender:UIButton){
        
        if showConfirmAlertOnSelectLocation{
            //Old Code(MITeam)
//            self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CAreYouSureYouWantToShareThisLocation, btnOneTitle: CBtnYes, btnOneTapped: { [weak self] (alert) in
//                guard let self = self else {return}
//                self.sendLocation()
//            }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
            
            
            
            let alertController = UIAlertController(title: CAreYouSureYouWantToShareThisLocation, message: "", preferredStyle: UIAlertController.Style.alert);
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                self.sendLocation()

            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
    //        let btnImage    = UIImage(named: "ic_checkbox_unselected")!
//            let btnImage    = UIImage(named: "ic_uncheckbox")!
//            let imageButton : UIButton = UIButton(frame: CGRect(x: 25, y: 60, width: 30, height: 30))
//            imageButton.setBackgroundImage(btnImage, for: UIControl.State())
//            imageButton.addTarget(self, action: #selector(checkBoxAction(_:)), for: .touchUpInside)
//            alertController.view.addSubview(imageButton)
            self.present(alertController, animated: false, completion: { () -> Void in
            })

            
            
        }else {
            self.sendLocation()
        }
    }
    
    func sendLocation(){
        if !getImageLocation{
            self.completion?(self.location)
            if let navigation = navigationController, navigation.viewControllers.count > 1 {
                navigation.popViewController(animated: true)
            } else {
                presentingViewController?.dismiss(animated: true, completion: nil)
            }
        }else{
            self.getLocationImage()
        }
    }
    
    @objc func checkBoxAction(_ sender: UIButton){
        if (sender.isSelected == true){
            let set_auto_Delete = 0
            NotificationCenter.default.post(name: Notification.Name("NotificationIdentifierLocation"), object: set_auto_Delete)
            sender.setBackgroundImage(UIImage(named: "ic_uncheckbox"), for:  UIControl.State())
            sender.isSelected = false;
        }
        else{
            let set_auto_Delete = 1
            NotificationCenter.default.post(name: Notification.Name("NotificationIdentifierLocation"), object: set_auto_Delete)
            sender.setBackgroundImage(UIImage(named: "ic_checkbox"), for: UIControl.State())
            sender.isSelected = true;
        }
    }
    
}

//MARK: - UIGestureRecognizerDelegate
extension LocationPickerVC: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

//MARK: - CLLocationManagerDelegate
extension LocationPickerVC: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        currentLocationListeners.forEach { $0.action(location) }
        currentLocationListeners = currentLocationListeners.filter { !$0.once }
        placesSearchController.setCurrentLocation(coordinate: location.coordinate)
        manager.stopUpdatingLocation()
        selectLocation(location: location)
        showCoordinates(location.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.checkLocationPermission()
    }
}

//MARK: - GooglePlacesAutocompleteViewControllerDelegate
extension LocationPickerVC: GooglePlacesAutocompleteViewControllerDelegate {
    func viewController(didAutocompleteWith place: PlaceDetails) {
        print(place.description)
        placesSearchController.isActive = false
        self.location = place
        if let coordinate = self.location?.coordinate {
            showCoordinates(coordinate)
        }
    }
}

//MARK: - Select Location
extension LocationPickerVC {
    
    func getCurrentLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func showCurrentLocation(_ animated: Bool = true) {
        let listener = CurrentLocationListener(once: true) { [weak self] location in
            self?.showCoordinates(location.coordinate, animated: animated)
        }
        currentLocationListeners.append(listener)
        getCurrentLocation()
    }
    
    func updateAnnotation() {
        //mapView.removeAnnotations(mapView.annotations)
        if let location = location {
            guard let coordinate = location.coordinate else {
                return
            }
            if let annotation = self.addAnnotation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)){
                mapView.selectAnnotation(annotation, animated: true)
            }
            /*let annotation = MKPointAnnotation()
             annotation.title = location.name ?? ""
             annotation.coordinate = coordinate
             //Annotation(latLong: coordinate, strTitle: location.name ?? "")
             if self.annotation == nil{
             mapView.addAnnotation(annotation)
             }
             self.annotation = annotation
             mapView.selectAnnotation(annotation, animated: true)
             //showCoordinates(coordinate)
             */
        }
    }
    
    func addAnnotation(_ location: CLLocation) -> MKPointAnnotation?{
        
        let annotations = mapView.annotations.filter({$0.isKind(of: MKPointAnnotation.classForCoder()) })
        
        if annotations.isEmpty{
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            mapView.addAnnotation(annotation)
            return annotation
        }
        if let annotation = annotations.first{
            if let _annotation = annotation as? MKPointAnnotation {
                _annotation.coordinate = location.coordinate
                return _annotation
            }
        }
        return nil
        /*let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        if self.annotation == nil{
            mapView.addAnnotation(annotation)
        }else{
            
            for annotation in mapView.annotations {
                if let annotation = annotation as? MKPointAnnotation {
                    annotation.coordinate = location.coordinate
                }
            }
        }
        self.annotation = annotation
        
        return annotation*/
    }
    
    func showCoordinates(_ coordinate: CLLocationCoordinate2D, animated: Bool = true) {
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: resultRegionDistance, longitudinalMeters: resultRegionDistance)
        mapView.setRegion(region, animated: animated)
    }
    
    func selectLocation(location: CLLocation) {
        // add point annotation to map
        /*let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        if self.annotation == nil{
            mapView.addAnnotation(annotation)
        }
        self.annotation = annotation*/
        let annotation = self.addAnnotation(location)
        if annotation == nil { return }
        geocoder.cancelGeocode()
        geocoder.reverseGeocodeLocation(location) { response, error in
            if let error = error as NSError?, error.code != 10 { // ignore cancelGeocode errors
                // show error and remove annotation
                let alert = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in }))
                self.present(alert, animated: true) {
                    self.mapView.removeAnnotation(annotation!)
                }
            } else if let placemark = response?.first {
                
                if let addressDic = placemark.addressDictionary {
                    var _strAddress = ""
                    if let lines = addressDic["FormattedAddressLines"] as? [String] {
                        _strAddress = lines.joined(separator: ", ")
                    }
                    self.strAdderess = _strAddress
                    // pass user selected location too
                    let locationObj = PlaceDetails(name: _strAddress, coordinate: location.coordinate)
                    locationObj.formattedAddress = _strAddress
                    locationObj.country = placemark.country
                    locationObj.locality = placemark.locality
                    locationObj.subLocality = placemark.subLocality
                    locationObj.countryCode = placemark.isoCountryCode
                    locationObj.postalCode = placemark.postalCode
                    
                    self.location = locationObj
                }
            }
        }
    }
}


// MARK: MKMapViewDelegate

extension LocationPickerVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        self.annotationView?.alpha = 0
        self.imgSelectLocation.alpha = 0.7
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {

        self.location = nil
        let location = CLLocation(latitude: self.mapView.centerCoordinate.latitude, longitude: self.mapView.centerCoordinate.longitude)
        self.selectLocation(location: location)
        self.imgSelectLocation.alpha = 0.0
        self.annotationView?.alpha = 1
    }
    
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
       
        if annotation is MKUserLocation { return nil }
        
        var view: MKAnnotationView
        let pinImg = UIImage(named: "ic_location_pin")
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotation") {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKAnnotationView(annotation: annotation, reuseIdentifier: "annotation")
            view.canShowCallout = false
        }
        
        view.image = pinImg
        self.annotationView = view
        return view
    }
    
    func selectLocationButton() -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 30))
        button.setTitle(selectButtonTitle, for: UIControl.State())
        if let titleLabel = button.titleLabel {
            let width = titleLabel.textRect(forBounds: CGRect(x: 0, y: 0, width: Int.max, height: 30), limitedToNumberOfLines: 1).width
            button.frame.size = CGSize(width: width, height: 30.0)
        }
        button.setTitleColor(view.tintColor, for: UIControl.State())
        return button
    }
    
    public func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if !getImageLocation{
            self.completion?(self.location)
            if let navigation = navigationController, navigation.viewControllers.count > 1 {
                navigation.popViewController(animated: true)
            } else {
                presentingViewController?.dismiss(animated: true, completion: nil)
            }
        }else{
            self.getLocationImage()
        }
    }
    
    public func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        let pins = mapView.annotations.filter { $0 is MKPinAnnotationView }
        assert(pins.count <= 1, "Only 1 pin annotation should be on map at a time")
        
        if let userPin = views.first(where: { $0.annotation is MKUserLocation }) {
            userPin.canShowCallout = false
        }
    }
}


