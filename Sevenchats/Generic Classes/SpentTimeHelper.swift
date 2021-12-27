//
//  SpentTimeHelper.swift
//  Sevenchats
//
//  Created by mac-00020 on 06/01/20.
//  Copyright © 2020 mac-0005. All rights reserved.
//

import Foundation

struct SpentTime {
    var hh : Int
    var mm : Int
    var ss : Int
}

class SpentTimeHelper {
    
    static let shared = SpentTimeHelper()
    
    private var start : Date?
    private var end : Date?
    
    func startTime() {
        
        /*if !isValidForTimeCount() { return }
        if start != nil { return }
        end = nil
        start = Date()*/
    }
    
    func stopTime() {
        
        /*if !isValidForTimeCount() { return }
        
        end = Date()
        findSpentTime()*/
    }
    
    fileprivate func isValidForTimeCount() -> Bool {
        
        if appDelegate.loginUser?.user_id == nil {
            return false
        }
        
        let isAppLaunchHere = CUserDefaults.value(forKey: UserDefaultIsAppLaunchHere) as? Bool ?? true
        if !isAppLaunchHere && self.start != nil {
            return true
        }
        return isAppLaunchHere
    }
    
    fileprivate func findSpentTime() {
        
        guard let _start = self.start else { return }
        guard let _end = self.end else { return }
        
        let diff = _end.offset(from: _start)
        
        syncSpentTime(model: diff)
        
        start = nil
        end = nil
    }

    fileprivate func syncSpentTime(model: SpentTime) {
        
        guard let userID = appDelegate.loginUser?.user_id else { return }
        let tblSpentTime = TblSpentTime.findOrCreate(dictionary: [CUserId : userID]) as? TblSpentTime
        guard let _tblSpentTime = tblSpentTime else { return }
        
        var hh = Int(_tblSpentTime.hh) + model.hh
        var mm = Int(_tblSpentTime.mm) + model.mm
        var ss = Int(_tblSpentTime.ss) + model.ss
        
        if ss >= 60 {
            let tmpSS = ss % 60
            ss = ss - tmpSS
            mm = mm + (ss / 60)
            ss = tmpSS
        }
        
        if mm >= 60 {
            let tmpMM = mm % 60
            mm = mm - tmpMM
            hh = hh + (mm / 60)
            mm = tmpMM
        }
        
        _tblSpentTime.user_id = userID
        _tblSpentTime.hh = Int64(hh)
        _tblSpentTime.mm = Int64(mm)
        _tblSpentTime.ss = Int64(ss)
        
        print("Hours : \(_tblSpentTime.hh) \nMiniutes : \(_tblSpentTime.mm)\nSeconds : \(_tblSpentTime.ss)")
        
        CoreData.saveContext()
    }
    
    func restTimeCount() {
        
        guard let arrTblSpentTime : [TblSpentTime] = TblSpentTime.fetchAllObjects() as? [TblSpentTime] else {return}
        for tbl in arrTblSpentTime {
            //tbl.user_id = 0
            tbl.hh = Int64(0)
            tbl.mm = Int64(0)
            tbl.ss = Int64(0)
            CoreData.saveContext()
        }
        
        //TblSpentTime.deleteAllObjects()
        
        /*
        guard let userID = appDelegate.loginUser?.user_id else { return }
        let tblSpentTime = TblSpentTime.findOrCreate(dictionary: [CUserId : userID]) as? TblSpentTime
        guard let _tblSpentTime = tblSpentTime else { return }

        _tblSpentTime.user_id = userID
        _tblSpentTime.hh = Int64(0)
        _tblSpentTime.mm = Int64(0)
        _tblSpentTime.ss = Int64(0)
        
        CoreData.saveContext()
         */
    }
}

extension Date {
   
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
   
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> SpentTime {
        
        let hh = hours(from: date)
        let mm = minutes(from: date)
        let ss = seconds(from: date)
        return SpentTime(hh: hh, mm: mm, ss: ss)
    }
}
