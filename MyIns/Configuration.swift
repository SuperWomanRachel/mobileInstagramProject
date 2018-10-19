//
//  Configuration.swift
//  MyIns
//
//  Created by tq on 2018/9/28.
//  Copyright © 2018年 Jingyuan Bi. All rights reserved.
//

import Foundation

class Config{
    
    
    static var STORAGE_ROOT_REF = "gs://mobileproject-8906e.appspot.com"
//    static var STORAGE_ROOT_REF = "gs://myins-52dda.appspot.com"
    
    
    static func timestampToDate(timeStamp: Int) -> String {
        //        let timeStamp = 1463241600
        let timeInterval: TimeInterval = TimeInterval(timeStamp)
        let date = NSDate(timeIntervalSince1970: timeInterval)
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let time = dateformatter.string(from: date as Date)
        //        print("time is :"+time)
        return time
    }
    
    static func timeToDate(timeStamp: Int) -> Date {
        let timeInterval: TimeInterval = TimeInterval(Double(timeStamp))
        let date = Date(timeIntervalSince1970: timeInterval)
        return date
    }
    
    static func dateToTimestamp(dateString: String) -> Int {
        let datefmatter = DateFormatter()
        datefmatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let date = datefmatter.date(from: dateString )
        let dateStamp:TimeInterval = date!.timeIntervalSince1970
        let dateStr:Int = Int(dateStamp)
        print(dateStr)
        return dateStr
    }
    
    static func getCurrentTimeStamp() -> Int {
        let now = NSDate()
        let timeInterval:TimeInterval = now.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
//        print("timestamp is ：\(timeStamp)")
        return timeStamp
    }
    
    
}

