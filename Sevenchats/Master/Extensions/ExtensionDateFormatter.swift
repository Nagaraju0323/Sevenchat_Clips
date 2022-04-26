//
//  ExtensionDateFormatter.swift
//  TheBayaApp
//
//  Created by mac-0005 on 13/09/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

// MARK:- Date Related Functions
// MARK:-
extension DateFormatter{
    // To Get date string from timestamp
    static func dateStringFrom(timestamp: Double?, withFormate:String?) -> String {
      
        /*let fromDate:Date = Date(timeIntervalSince1970: timestamp!)
         let formater = DateFormatter()
         formater.calendar = Calendar(identifier: .gregorian)
         formater.dateFormat = withFormate
         return formater.string(from: fromDate)*/
        
        let formatter = DateFormatter()
        formatter.dateFormat = withFormate
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = DateFormatter.shared().locale
        formatter.timeZone = NSTimeZone.local
        let fromDate:Date = Date(timeIntervalSince1970: timestamp ?? 0.0)
        return formatter.string(from: fromDate)
        /*let fromDate:Date = Date(timeIntervalSince1970: timestamp!)
         DateFormatter.shared().timeZone = TimeZone.current
         return DateFormatter.shared().string(fromDate: fromDate, dateFormat: withFormate!)
         */
    }
    
    // To Get date from timestamp
    func dateFrom(timestamp: String) -> Date? {
        let fromDate:Date = Date(timeIntervalSince1970: Double(timestamp)!)
        let stringDate = DateFormatter.shared().string(fromDate: fromDate, dateFormat: "dd MMM, YYYY")
        return DateFormatter.shared().date(fromString: stringDate, dateFormat: "dd MMM, YYYY")
    }
    
    // To get specific date string fromate from specific date string
    func convertDateFormat(date : String?, currentformate : String?, updateformate : String?) -> String? {
        let dateString = date
        var dateInfo = ""
        self.dateFormat = currentformate // "dd-MM-yyyy hh:mm a"
        
        if let strCurrnetDate = self.date(from: dateString!){
            self.dateFormat = updateformate //"dd-MMM-yyyy hh:mm a"
            dateInfo = self.string(from: strCurrnetDate)
        }
        
        return dateInfo
    }
    
    // To compare two date with same formate
    func compareTwoDates(startDate : String?, endDate : String?, formate : String?) -> Bool {
        self.dateFormat = formate
        self.timeZone = TimeZone(abbreviation: "GMT")
        let startDateTimeStamp = self.date(from: startDate!)?.timeIntervalSince1970
        let endDateTimeStamp = self.date(from: endDate!)?.timeIntervalSince1970
        return Double(endDateTimeStamp!) > Double(startDateTimeStamp!)
    }
    
    func convertDate(strDate: String?,  formate : String?) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = formate
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = DateFormatter.shared().locale
        guard let convertedDate = formatter.date(from: strDate ?? "") else {
            return nil
        }
        return formatter.string(from: convertedDate)
    }
    
    func convertDatereversLatest(strDate: String?) -> String?{
        
        
        let dateFormatter = DateFormatter()
      
        dateFormatter.dateStyle = DateFormatter.Style.long
        dateFormatter.dateFormat = "E MM d yyyy HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT") as TimeZone?
        guard let convertedDate = dateFormatter.date(from: strDate ?? "") else {
            return nil
        }
       
        dateFormatter.dateFormat = "dd MMM yyyy hh:mm a"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: convertedDate)
    }
    
    func convertDatereversLatestsell(strDate: String?) -> String?{
        
        let dateFormatter = DateFormatter()
      
        dateFormatter.dateStyle = DateFormatter.Style.long
        dateFormatter.dateFormat = "E MM d yyyy HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT") as TimeZone?
        guard let convertedDate = dateFormatter.date(from: strDate ?? "") else {
            return nil
        }
       
        dateFormatter.dateFormat = "dd MMM yyyy"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: convertedDate)
    }
    
    
    func convertDaterevers(strDate: String?) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        dateFormatter.dateFormat = "dd-MM-yyyy"
        guard let convertedDate = dateFormatter.date(from: strDate ?? "") else {
            return nil
        }
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: convertedDate)
    }
    func convertDatereversSinup(strDate: String?) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        dateFormatter.dateFormat = "dd MMM yyyy"
        guard let convertedDate = dateFormatter.date(from: strDate ?? "") else {
            return nil
        }
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: convertedDate)
    }
    func convertDatereveruserDetails(strDate: String?) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        dateFormatter.dateFormat = "dd-MM-yyyy"
        guard let convertedDate = dateFormatter.date(from: strDate ?? "") else {
            return nil
        }
        dateFormatter.dateFormat = "E MMM dd yyyy hh:mm:ss"
        return dateFormatter.string(from: convertedDate)
    }
    
    func reversDateFormat(dateString:String) -> String{
     
         let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "dd MMM yyyy, hh:mm a"
          let date = dateFormatter.date(from: dateString)
        self.timeZone = NSTimeZone(name: "GMT") as TimeZone?
          dateFormatter.dateFormat = "E MMM dd yyyy HH:mm:ss"
         let returnDate =  dateFormatter.string(from: date!)
        return returnDate
         
    }
   
  func convertDateIntoGMTDate(dateToConvert: String?,  formate : String?) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = formate
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = DateFormatter.shared().locale
        guard let convertedDate = formatter.date(from: dateToConvert ?? "") else {
            return nil
        }
        formatter.locale = Locale(identifier: "en_US")
        formatter.timeZone = TimeZone(identifier: "GMT")
        return formatter.string(from: convertedDate)
    }
    
    
    // To get duration string from timestamp
    func durationString(duration: String) -> String {
        let calender:Calendar = Calendar.current as Calendar
        let fromDate:Date = Date(timeIntervalSince1970: Double(duration)!)
        let unitFlags = Set<Calendar.Component>([.year, .month, .day, .hour, .minute])
        let dateComponents = calender.dateComponents(unitFlags, from:fromDate , to: Date())
        
        let years:NSInteger = dateComponents.year!
        let months:NSInteger = dateComponents.month!
        let days:NSInteger = dateComponents.day!
        let hours:NSInteger = dateComponents.hour!
        let minutes:NSInteger = dateComponents.minute!
        
        var durations:NSString = CJustNow as NSString
        
        if (years > 0) {
            durations = (years == 1 ? "\(years) year ago" : "\(years) years ago") as NSString
        }
        else if (months > 0) {
            durations = (months == 1 ? "\(months) month ago" : "\(months) months ago") as NSString
        }
        else if (days > 0) {
            durations = (days == 1 ? "\(days) \(CDayAgo)" : "\(days) \(CDaysAgo)") as NSString
        }
        else if (hours > 0) {
            durations = (hours == 1 ? CHourAgo : "\(hours) \(CHoursAgo)") as NSString
        }
        else if (minutes > 0) {
            durations = (minutes == 1 ? CMinAgo : "\(minutes) \(CMinsAgo)") as NSString
        }
        
        return durations as String;
    }
    
    func getDateFromTimeStamp(timeStamp : Double) -> String {

            let date = NSDate(timeIntervalSince1970: timeStamp / 1000)
            
            let dayTimePeriodFormatter = DateFormatter()
            dayTimePeriodFormatter.dateFormat = "dd MMM YY, hh:mm a"
         // UnComment below to get only time
        //  dayTimePeriodFormatter.dateFormat = "hh:mm a"

            let dateString = dayTimePeriodFormatter.string(from: date as Date)
            return dateString
        }
    
    func dateupdateNewFormat(timeStamp:String) -> String{
    
        let end_date =  timeStamp
        let evnt_endDate = end_date.stringBefore("G")
//        let convert_new = evnt_endDate.chopPrefix(3)
        let startCreated_new = DateFormatter.shared().convertDatereversLatest(strDate: evnt_endDate)
        return startCreated_new ?? ""
    }
    
    
    
}

// MARK:- Timestamp Related Functions
// MARK:-
extension DateFormatter {
    // To Get GMT Timestamp from Specific Date
    func timestampGMTFromDate(date : String?, formate : String?) -> Double? {
        self.dateFormat = formate
        self.timeZone = TimeZone(abbreviation: "GMT")
        var timeStamp = self.date(from: date!)?.timeIntervalSince1970
        timeStamp = Double(timeStamp!)
        return timeStamp
    }
    // To Get local Timestamp from specific date
    func timestampGMTFromDateNew(date : String?) -> Double? {
        let format = "yyyy-MM-dd HH:mm:ss.SSS'Z'"
        self.dateFormat = format
        self.timeZone = TimeZone.current
//        var timeStamp = self.date(from: date!)?.timeIntervalSince1970
        var timeStamp = self.date(from: date!)?.addingTimeInterval((330*60)).timeIntervalSince1970
        timeStamp = Double(timeStamp ?? 1.012122)
        return timeStamp
    }
    // To Get local Timestamp from specific date
    func timestampFromDate(date : String?, formate : String?) -> Double? {
        self.dateFormat = formate
        self.timeZone = TimeZone.current
        var timeStamp = self.date(from: date!)?.timeIntervalSince1970
        //        timeStamp = Double((timeStamp?.toFloat)!)
        timeStamp = Double(timeStamp!)
        return timeStamp
    }
    func timestampFromDateChat(date : String?, formate : String?) -> Double? {
        self.dateFormat = formate
        var timeStamp = self.date(from: date!)?.timeIntervalSince1970
        //        timeStamp = Double((timeStamp?.toFloat)!)
        self.timeZone = TimeZone(abbreviation: "GMT")
        timeStamp = Double(timeStamp!)
        return timeStamp
    }
    
    // To Get GMT Timestamp from current date.
    func currentGMTTimestampInMilliseconds() -> Double? {
        let format = "yyyy-MM-dd HH:mm:ss.SSSS'Z'"
        self.dateFormat = format
        self.timeZone = TimeZone(identifier: "GMT")
        
        let createDate = self.string(from: Date())
        let timestamp = self.timestampGMTFromDate(date: createDate, formate: format)
        return timestamp! * 1000
    }
    
    // To Convert GMT timestamp to local timestamp
    func ConvertGMTMillisecondsTimestampToLocalTimestamp(timestamp: Double) -> Double? {
        
        let format = "yyyy-MM-dd HH:mm:ss.SSSS'Z'"
        self.dateFormat = format
        self.timeZone = TimeZone.current
        let dateStr = NSDate(timeIntervalSince1970:timestamp)
        let createDate = self.string(from: dateStr as Date)
        
        let gmtTimestamp = self.timestampFromDate(date: createDate, formate: format)
        return gmtTimestamp
        
    }
    
    
    func ConvertGMTMillisecondsTimestampToLocalTimestampChat(timestamp: Double) -> Double? {
        
        let format = "yyyy-MM-dd HH:mm:ss.SSSS'Z'"
        self.dateFormat = format
//        self.timeZone = TimeZone.current
        self.timeZone = TimeZone(identifier: "GMT")
        let dateStr = NSDate(timeIntervalSince1970:timestamp)
        let createDate = self.string(from: dateStr as Date)
        self.timeZone = TimeZone(identifier: "GMT")
        let gmtTimestamp = self.timestampFromDateChat(date: createDate, formate: format)
        return gmtTimestamp
        
    }
    func featchDatefomat(dateTimeStamp:String) ->String{
        
        let dateFormatterGetWithMs = DateFormatter()
           dateFormatterGetWithMs.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
           let dateFormatterPrint = DateFormatter()
           
        let date: Date? = dateFormatterGetWithMs.date(from: dateTimeStamp)
        dateFormatterPrint.dateFormat = "dd MMMM yyyy"
        let timeStr = dateFormatterPrint.string(from: date!)
           return timeStr
    }
    
    
    
    
}
