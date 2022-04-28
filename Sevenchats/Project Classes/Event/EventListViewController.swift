//
//  EventListViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 21/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : EventListViewController                     *
 * Changes :                                             *
 *                                                       *
 ********************************************************/

import UIKit
import FSCalendar
import UIKit
import FSCalendar
import CoreLocation
import Alamofire

class EventListViewController: ParentViewController,FSCalendarDelegateAppearance {
    
    @IBOutlet weak var calendar: FSCalendar!
    
    @IBOutlet weak var cnCalendarHeight: NSLayoutConstraint! {
        didSet {
            cnCalendarHeight.constant = CScreenWidth * 275 / 375
        }
    }
    
    @IBOutlet weak var cnNavigationHeight: NSLayoutConstraint! {
        didSet {
            cnNavigationHeight.constant = IS_iPhone_X_Series ? 84 : 64
        }
    }
    
    @IBOutlet weak var tblEventList: UITableView! {
        didSet {
            tblEventList.register(UINib(nibName: "EventListTblCell", bundle: nil), forCellReuseIdentifier: "EventListTblCell")
            
            tblEventList.register(UINib(nibName: "EventHldListTblCell", bundle: nil), forCellReuseIdentifier: "EventHldListTblCell")
            tblEventList.estimatedRowHeight = 100;
            tblEventList.rowHeight = UITableView.automaticDimension;
        }
    }
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var txtYear: UITextField!
    @IBOutlet weak var lblNoData: UILabel! {
        didSet {
            self.lblNoData.text = CMessageNoEvent
        }
    }
    
    fileprivate lazy var scopeGesture : UIPanGestureRecognizer = {
        
        let panGesture = UIPanGestureRecognizer.init(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        return panGesture
        
    }()
    
    var arrEventDate = [[String :Any]]()
    var arrEvent = [[String : Any]]()
    
    var arrYears = [String]()
    var isAllEvent : Bool = true
    var isHolidaySlc :Bool = false
    var refreshControl = UIRefreshControl()
    
    var apiTask : URLSessionTask?
    var currentPage : Int = 1
    var locationManager:CLLocationManager!
    
    var cuntryNameStr :String  = ""
    var ctrHldayList = [listCountries]()
    var ctrHoliDaysList = [ctrHolidays]()
    var ctrHoliDaysListTemp = [ctrHolidays]()
    var startHolydate:String = ""
    var endHoldate:String = ""
    
    
    //    let urlstr = URL(string:"https://www.googleapis.com/calendar/v3/calendars/en.indian%23holiday%40group.v.calendar.google.com/events?key=%20AIzaSyAOM61PL7jy7Si40zlqeRSV2vNtzPOOkRc")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Initialization()
        
        calendar.appearance.titleWeekendColor = .red
        calendar.calendarWeekdayView.weekdayLabels[0].textColor = .black
        calendar.calendarWeekdayView.weekdayLabels[6].textColor = .black
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- --------- Initialization
    
    func Initialization() {
        
        self.title = CNavEventsCalendar
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: #imageLiteral(resourceName: "ic_add_event"), style: .plain, target: self, action: #selector(btnAddClicked(_:)))]
        
        self.refreshControl.tintColor = ColorAppTheme
        self.refreshControl.addTarget(self, action: #selector(self.pullToRfersh), for: .valueChanged)
        self.tblEventList.pullToRefreshControl = self.refreshControl
        
        //...Load event dates
        self.loadEventDatesFromServer()
        
        //...Calendar configuration
        self.calendar.select(Date())
        self.view.addGestureRecognizer(scopeGesture)
        tblEventList.panGestureRecognizer.require(toFail: scopeGesture)
        calendar.scope = .month
        calendar.appearance.caseOptions = .weekdayUsesUpperCase
        
        self.calendar.locale = DateFormatter.shared().locale
        self.calendar.appearance.headerDateFormat = DateFormatter.dateFormat(fromTemplate: "", options: 0, locale: DateFormatter.shared().locale)
        for i in (1970..<2050).reversed() {
            arrYears.append("\(i)")
        }
        
        txtYear.setPickerData(arrPickerData: arrYears, selectedPickerDataHandler: { [weak self](string, row, componet) in
            // Specify date components
            guard let _ = self else { return }
            var dateComponents = DateComponents()
            dateComponents.year = string.toInt
            dateComponents.month = 1
            dateComponents.day = 1
            
            // Create date from components
            let userCalendar = Calendar.current // user calendar
            let someDateTime = userCalendar.date(from: dateComponents)
            
            self?.calendar.setCurrentPage(someDateTime!, animated: true)
        }, defaultPlaceholder: nil)
        
        self.updateSelectedDateFromCalender()
        self.callEventListAPI(showLoader : true)
    }
}

// MARK:-
// MARK:- --------- Api Functions
extension EventListViewController {
    
    func callEventListAPI(showLoader : Bool) {
        currentPage = 1
        self.loadEventList(showLoader: showLoader)
    }
    
    func callHolidayListAPI(showLoader : Bool) {
        currentPage = 1
        self.loadHolidayListAPI(showLoader: showLoader)
    }
    
    @objc func pullToRfersh(){
        refreshControl.beginRefreshing()
        if isHolidaySlc == true {
            self.loadHolidayListAPI(showLoader: false)
        }else {
            self.callEventListAPI(showLoader : false)
        }
        
    }
    
    func loadEventList(showLoader : Bool) {
        
        if apiTask?.state == URLSessionTask.State.running {
            return
        }
        
        // Add load more indicator here...
        self.tblEventList.tableFooterView = self.currentPage > 2 ? self.loadMoreIndicator(ColorAppTheme) : UIView()
        let eventDate = DateFormatter.shared().string(fromDate: calendar.selectedDate!, dateFormat: "yyyy-MM-dd")
        var localTimeZoneName: String { return TimeZone.current.identifier }
        let param : [String : Any] = ["timezone":localTimeZoneName
                                      ,CEventDate : eventDate, CType : self.isAllEvent ? 1 : 2 , CPage : currentPage, CPer_page : CLimit]
        
    }
    
    func loadEventDatesFromServer() {
        
    }
    
    func loadHolidayListAPI(showLoader : Bool) {
        self.isHolidaySlc = true
        self.refreshControl.endRefreshing()
        let eventDate = DateFormatter.shared().string(fromDate: calendar.selectedDate!, dateFormat: "yyyy-MM-dd")
        self.ctrHoliDaysListTemp.removeAll()
        let nameFtrNamesme = ctrHoliDaysList.forEach { if $0.startDate == eventDate {
            let holidayvalues =  $0.holidayName
            let start = $0.startDate
            let end = $0.endDate
            self.ctrHoliDaysListTemp.append(ctrHolidays.init(startDate: start, endDate: end, holidayName: holidayvalues))
        }
        }
        self.tblEventList.reloadData()
        self.lblNoData.isHidden = self.ctrHoliDaysListTemp.count != 0
    }
}

// MARK:-
// MARK:- --------- UIGestureRecognizerDelegate

extension EventListViewController  {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        let shouldBegin = self.tblEventList.contentOffset.y <= -self.tblEventList.contentInset.top
        if shouldBegin {
            let velocity = self.scopeGesture.velocity(in: self.view)
            switch self.calendar.scope {
            case .month:
                return velocity.y < 0
            case .week:
                return velocity.y > 0
            default:
                return false
            }
        }
        return shouldBegin
    }
}

// MARK:-
// MARK:- --------- UITableViewDataSource and Delegate method

extension EventListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isHolidaySlc == true {
            return ctrHoliDaysListTemp.count
        }else {
            return arrEvent.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerVW:CalendarHeaderView = CalendarHeaderView.viewFromXib as! CalendarHeaderView
        headerVW.btnAllEvent.setTitle(CbtnAllEvents, for: .normal)
        headerVW.btnMyEvent.setTitle(CbtnMyEvents, for: .normal)
        if isHolidaySlc == true{
            headerVW.btnMyEvent.setTitleColor(CRGB(r: 153, g: 156, b: 147), for: .normal)
            headerVW.btnAllEvent.setTitleColor(CRGB(r: 153, g: 156, b: 147), for: .normal)
            headerVW.btnHolidays.setTitleColor(UIColor.black, for: .normal)
        }else {
            if isAllEvent{
                headerVW.btnMyEvent.setTitleColor(CRGB(r: 153, g: 156, b: 147), for: .normal)
                headerVW.btnHolidays.setTitleColor(CRGB(r: 153, g: 156, b: 147), for: .normal)
                headerVW.btnAllEvent.setTitleColor(UIColor.black, for: .normal)
            }else{
                headerVW.btnAllEvent.setTitleColor(CRGB(r: 153, g: 156, b: 147), for: .normal)
                headerVW.btnHolidays.setTitleColor(CRGB(r: 153, g: 156, b: 147), for: .normal)
                headerVW.btnMyEvent.setTitleColor(UIColor.black, for: .normal)
            }
        }
        headerVW.btnHolidays.touchUpInside { [weak self] (sender) in
            guard let _ = self else { return }
            self?.isHolidaySlc = true
            self?.isAllEvent = false
            headerVW.btnAllEvent.setTitleColor(CRGB(r: 153, g: 156, b: 147), for: .normal)
            headerVW.btnMyEvent.setTitleColor(CRGB(r: 153, g: 156, b: 147), for: .normal)
            headerVW.btnHolidays.setTitleColor(UIColor.black, for: .normal)
            self?.callHolidayListAPI(showLoader : true)
        }
        headerVW.btnMyEvent.touchUpInside { [weak self] (sender) in
            guard let _ = self else { return }
            self?.isAllEvent = false
            self?.isHolidaySlc = false
            headerVW.btnAllEvent.setTitleColor(CRGB(r: 153, g: 156, b: 147), for: .normal)
            headerVW.btnMyEvent.setTitleColor(UIColor.black, for: .normal)
            headerVW.btnHolidays.setTitleColor(CRGB(r: 153, g: 156, b: 147), for: .normal)
            self?.callEventListAPI(showLoader : true)
        }
        
        headerVW.btnAllEvent.touchUpInside { [weak self] (sender) in
            guard let _ = self else { return }
            self?.isAllEvent = true
            self?.isHolidaySlc = false
            headerVW.btnMyEvent.setTitleColor(CRGB(r: 153, g: 156, b: 147), for: .normal)
            headerVW.btnAllEvent.setTitleColor(UIColor.black, for: .normal)
            headerVW.btnHolidays.setTitleColor(CRGB(r: 153, g: 156, b: 147), for: .normal)
            self?.callEventListAPI(showLoader : true)
        }
        return headerVW
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.isHolidaySlc == true {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "EventHldListTblCell") as? EventHldListTblCell {
                
                let dict = ctrHoliDaysListTemp[indexPath.row]
                cell.lblUserName.text = dict.holidayName
                cell.lblEventDescription.text = dict.holidayName
                cell.lblEventDate.text = dict.startDate
                // LOAD MORE DATA..........
                //                if indexPath == tblEventList.lastIndexPath(){
                //                    self.loadHolidayListAPI(showLoader: false)
                //                }
                return cell
            }
            
        }
        else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "EventListTblCell") as? EventListTblCell {
                
                let dict = arrEvent[indexPath.row]
                cell.lblUserName.text = "\(dict.valueForString(key: CFirstname)) \(dict.valueForString(key: CLastname))"
                cell.lblEventDescription.text = dict.valueForString(key: CTitle)
                cell.lblEventDate.text = DateFormatter.dateStringFrom(timestamp: dict.valueForDouble(key: CEvent_Start_Date), withFormate: "EEEE dd hh:mm a")
                cell.imgUser.loadImageFromUrl(dict.valueForString(key: CUserProfileImage), true)
                
                cell.btnProfileImg.touchUpInside { [weak self] (sender) in
                    guard let _ = self else { return }
                    appDelegate.moveOnProfileScreenNew(dict.valueForString(key: CUserId), dict.valueForString(key: CUsermailID), self)
                }
                
                cell.btnUserName.touchUpInside { [weak self] (sender) in
                    guard let _ = self else { return }
                    
                    appDelegate.moveOnProfileScreenNew(dict.valueForString(key: CUserId), dict.valueForString(key: CUsermailID), self)
                }
                
                // LOAD MORE DATA..........
                if indexPath == tblEventList.lastIndexPath(){
                    self.loadEventList(showLoader: false)
                }
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if let cell = tableView.cellForRow(at: indexPath) as? EventHldListTblCell {
            return
        }else {
            if arrEvent[indexPath.row].valueForString(key: CImage) == "" {
                if let eventDetailsVC = CStoryboardEvent.instantiateViewController(withIdentifier: "EventDetailViewController") as? EventDetailViewController{
                    eventDetailsVC.isHideNavCalenderButton = true
                    eventDetailsVC.postID = arrEvent[indexPath.row].valueForInt(key: CId) ?? 0
                    self.navigationController?.pushViewController(eventDetailsVC, animated: true)
                }
            } else {
                if let eventImageDetailsVC = CStoryboardEvent.instantiateViewController(withIdentifier: "EventDetailImageViewController") as? EventDetailImageViewController{
                    eventImageDetailsVC.isHideNavCalenderButton = true
                    eventImageDetailsVC.postID = arrEvent[indexPath.row].valueForInt(key: CId) ?? 0
                    self.navigationController?.pushViewController(eventImageDetailsVC, animated: true)
                }
            }
        }
    }
}

/*
 FscCalander Data Source and Delegate Methods
 Display Events,Couentry Holiday List
 
 */

// MARK:-
// MARK:- --------- FSCalendarDataSource and Delegate method

extension EventListViewController : FSCalendarDataSource, FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.cnCalendarHeight.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if self.isHolidaySlc == true {
            loadHolidayListAPI(showLoader : true)
        }else {
            self.callEventListAPI(showLoader : true)
        }
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        self.updateSelectedDateFromCalender()
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .gregorian)
        let dateString = formatter.string(from: date)
        if self.ctrHoliDaysList.contains(where:{$0.startDate == dateString}) {
            return 2
        }
        if self.arrEventDate.contains(where: {$0.valueForString(key: "event_date") == dateString}) {
            return 2
        }
        return 0
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date)
        if self.ctrHoliDaysList.contains(where: {$0.startDate == dateString}) {
            return .blue
        }
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        return [UIColor.white]
    }
    
    func updateSelectedDateFromCalender(){
        let dfYear = DateFormatter()
        dfYear.locale = DateFormatter.shared().locale
        dfYear.calendar = Calendar(identifier: .gregorian)
        dfYear.dateFormat = "yyyy"
        
        let dfMonth = DateFormatter()
        dfMonth.locale = DateFormatter.shared().locale
        dfMonth.calendar = Calendar(identifier: .gregorian)
        dfMonth.dateFormat = "MMMM"
        txtYear.text  = dfYear.string(from: calendar.currentPage)
        lblMonth.text = dfMonth.string(from: calendar.currentPage)
    }
}

// MARK:- --------- Initialization
extension EventListViewController{
    @objc fileprivate func btnAddClicked(_ sender : UIBarButtonItem) {
        let addEventVC:AddEventViewController = CStoryboardEvent.instantiateViewController(withIdentifier: "AddEventViewController") as! AddEventViewController
        addEventVC.eventType = .addEvent
        self.navigationController?.pushViewController(addEventVC, animated: true)
    }
}

//MARK :- -----------------Location update
extension EventListViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if (error != nil){
                print("error in reverseGeocode")
            }
            let placemark = placemarks! as [CLPlacemark]
            if placemark.count>0{
                let placemark = placemarks![0]
                let country = placemark.country!
                self.cuntryNameStr = country
                DispatchQueue.main.async {
                    self.updateCountryName()
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
    func updateCountryName(){
        for string in listCountries.stringArray {
            if let index = string.firstIndex(of: ",") {
                let firstPart = string.prefix(upTo: index)
                if cuntryNameStr == firstPart{
                    if let index = string.firstIndex(of: "."),
                       case let start = string.index(after: index),
                       let end = string[start...].firstIndex(of: "#") {
                        let substring = string[start..<end]
                        self.holidayListupdate(substring:String(substring))
                    }
                }
            }
        }
    }
    func holidayListupdate(substring:String){
        let urlstr = URL(string:"https://www.googleapis.com/calendar/v3/calendars/en.\(substring)%23holiday%40group.v.calendar.google.com/events?key=%20AIzaSyAOM61PL7jy7Si40zlqeRSV2vNtzPOOkRc")
        Alamofire.request(urlstr!, method: .get, parameters: nil, encoding: JSONEncoding.default)
            .responseJSON { response in
                if let status = response.response?.statusCode {
                    switch(status){
                    case 201:
                        print("example success")
                    default:
                        print("error with response status: \(status)")
                    }
                }
                if let result = response.result.value {
                    self.ctrHoliDaysList.removeAll()
                    let JSON = result as! NSDictionary
                    if let users = JSON["items"] as? [[String : Any]] {
                        for user in users {
                            if let user = user["start"] as? [String : Any] {
                                if let defaultDate = user["date"] as? String {
                                    self.startHolydate = defaultDate
                                }
                            }
                            if let endDate = user["end"] as? [String: Any] {
                                if let edate = endDate["date"] as? String {
                                    print(edate)
                                    self.endHoldate = edate
                                }
                            }
                            let HolidayName = user["summary"] as! String
                            self.ctrHoliDaysList.append(ctrHolidays.init(startDate: self.startHolydate, endDate:  self.endHoldate, holidayName: HolidayName))
                        }
                    }
                    self.reloaddata()
                }
            }
    }
    func reloaddata(){
        DispatchQueue.main.async {
            self.calendar.reloadData()
        }
    }
}



